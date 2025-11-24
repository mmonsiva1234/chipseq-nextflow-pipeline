#!/usr/bin/env nextflow

process POS2BED {
    label 'process_low'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir "${params.outdir}/homer/bed", mode: 'copy'
    
    input:
        tuple val(rep), path(peaks_txt)

    output:
        tuple val(rep), path("${rep}.bed")

    stub:
    """
    touch ${homer_txt.baseName}.bed
    """
    
    script:
    """
    pos2bed.pl ${peaks_txt} > ${rep}.bed
    """
}


