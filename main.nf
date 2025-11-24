#!/usr/bin/env nextflow

// Include your modules here

include { FASTQC }           from './modules/fastqc'
include { TRIM }             from './modules/trimmomatic'
include { BOWTIE2_BUILD }    from './modules/bowtie2_build'
include { BOWTIE2_ALIGN }    from './modules/bowtie2_align'
include { SAMTOOLS_SORT }    from './modules/samtools_sort'
include { SAMTOOLS_IDX }     from './modules/samtools_idx'
include { SAMTOOLS_FLAGSTAT } from './modules/samtools_flagstat'
include { BAMCOVERAGE }      from './modules/deeptools_bamcoverage'
include { MULTIQC }          from './modules/multiqc'
include {MULTIBWSUMMARY}     from './modules/deeptools_multibwsummary'
include {PLOTCORRELATION}    from './modules/deeptools_plotcorrelation'
include {TAGDIR}             from './modules/homer_maketagdir'
include {FINDPEAKS}          from './modules/homer_findpeaks'
include {POS2BED}            from './modules/homer_pos2bed'
include {BEDTOOLS_INTERSECT} from './modules/bedtools_intersect'
include {BEDTOOLS_BLACKLIST_FILTER} from './modules/bedtools_blacklist_filter'
include {ANNOTATE}                  from './modules/homer_annotatepeaks'
include {FIND_MOTIFS_GENOME}        from './modules/homer_findmotifsgenome'
include { COMPUTEMATRIX  } from './modules/deeptools_computematrix'
include { PLOTPROFILE}     from './modules/deeptools_plotprofile'


workflow {

    //
    // 1) READS
    //
    reads = Channel
        .fromPath(params.samplesheet)
        .splitCsv(header:true)
        .map { row -> tuple(row.name, file(row.path)) }

    //
    // 2) FASTQC
    //
    fastqc = FASTQC(reads)

    //
    // 3) TRIMMOMATIC
    //
    trimmed        = TRIM(reads)
    trimmed_reads  = trimmed.trimmed_reads
    trim_logs      = trimmed.log


    //
    // 4) BOWTIE2 BUILD
    //
    index_ch = BOWTIE2_BUILD(params.genome)
        .map { file(it).parent }
        .unique()

    //
    // 5) ALIGN
    //
    aligned_ch = BOWTIE2_ALIGN(trimmed_reads, index_ch)

    //
    // 6) SORT
    //
    sorted = SAMTOOLS_SORT(aligned_ch)

    //
    // 7) INDEX
    //
    indexed_ch = SAMTOOLS_IDX(sorted)

    //
    // 8) FLAGSTAT
    //
    flagstat = SAMTOOLS_FLAGSTAT(indexed_ch)

    //
    // 9) BAMCOVERAGE → BIGWIG
    //
    bw = indexed_ch.map { name, bam, bai -> tuple(name, bam, bai) } | BAMCOVERAGE

    //
    // 10) COLLECT QC FOR MULTIQC
    //
    multiqc_input = fastqc.zip
        .mix(fastqc.html)
        .mix(trim_logs)
        .mix(flagstat.map { it[1] })
        .collect()

    //
    // 11) RUN MULTIQC
    //
    MULTIQC(multiqc_input)

    //
    // 12) MULTIBIGWIGSUMMARY & CORRELATION
    //
    bigwig_list = bw.map { name, bigwig -> bigwig }.collect()
    mbw = MULTIBWSUMMARY(bigwig_list)
    correlation = PLOTCORRELATION(mbw[0])

    //
    // 13) HOMER TAGDIRECTORY
    //
    tagdirs_ch = TAGDIR(indexed_ch)

    cleaned_tagdirs = tagdirs_ch.map { name, tg ->
        def clean = name.replace('.sorted','').replace('_subset','')
        tuple(clean, tg)
    }

    //
    // SPLIT IP vs INPUT
    //
    ip_ch    = cleaned_tagdirs.filter { n, tg -> n.startsWith("IP_") }
    input_ch = cleaned_tagdirs.filter { n, tg -> n.startsWith("INPUT_") }

    // Normalize names to rep1 / rep2
    ip_ch = ip_ch.map { name, tg ->
        def rep = name.replace("IP_", "")
        tuple(rep, tg)
    }

    input_ch = input_ch.map { name, tg ->
        def rep = name.replace("INPUT_", "")
        tuple(rep, tg)
    }

    //
    // 14) PAIR (rep1-IP , rep1-INPUT)
    //
    paired_tags_ch = ip_ch.join(input_ch)
                          .map { rep, ip_tg, input_tg ->
                              tuple(rep, ip_tg, input_tg)
                          }

    //
    // 15) FINDPEAKS
    //
    peaks_ch = FINDPEAKS(paired_tags_ch)

    //
    // 16) POS2BED
    //
    bed_ch = POS2BED(peaks_ch)

    // split reps
    bed1_ch = bed_ch.filter { rep, bed -> rep == "rep1" }.map { rep, bed -> bed }
    bed2_ch = bed_ch.filter { rep, bed -> rep == "rep2" }.map { rep, bed -> bed }

    //
    // 17) INTERSECT FOR REPRODUCIBLE PEAKS
    //
    consensus_peaks = bed1_ch.combine(bed2_ch) | BEDTOOLS_INTERSECT

    //
    // 18) BLACKLIST FILTER
    //
    filtered_peaks = consensus_peaks.map {  bedfile ->
        tuple(bedfile, file(params.blacklist))
    } | BEDTOOLS_BLACKLIST_FILTER

    filtered_peaks_bed = filtered_peaks

    //
    // 19) ANNOTATE PEAKS
    //
    annotated = ANNOTATE(
        filtered_peaks_bed,
        Channel.of(file(params.genome)),
        Channel.of(file(params.gtf))
    )   

    //
    // 20) MOTIF ENRICHMENT (WEEK 3)
    //
    motifs = FIND_MOTIFS_GENOME(filtered_peaks_bed)

    //
    // 21) WEEK 3: computeMatrix + plotProfile
    //

    // extract ONLY IP bigwigs
    ip_bw = bw.filter { name, bwfile ->  bwfile.getName().startsWith("IP_") }
               .map { name, bwfile -> bwfile }
               .collect()

    // run computeMatrix
    matrix = COMPUTEMATRIX(
        ip_bw.flatten(),
        file(params.ucsc_genes),
        params.window
        )

    // run plotProfile
    profile = PLOTPROFILE(matrix)

}




