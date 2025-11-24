#!/usr/bin/env nextflow

process BOWTIE2_ALIGN {
    label 'process_high'
    // not sure if it is proceess_medium?
    container 'ghcr.io/bf528/bowtie2:latest'
   // publishDir "${params.outdir}/alignment", mode: 'copy'
    publishDir params.results, mode: 'copy'
    
    input:
    tuple val(name), path(reads)
    path index_prefix  

    output:
    tuple val(name), path("${name}.bam"), emit: bam

    script:
    """
    bowtie2 -x ${index_prefix}/genome_index \
            -U ${reads} \
        | samtools view -bS - > ${name}.bam
    """

    stub:
    """
    touch ${name}.bam
    """
}