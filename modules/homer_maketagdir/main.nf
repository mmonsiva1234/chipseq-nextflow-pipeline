#!/usr/bin/env nextflow

process TAGDIR {
    label 'process_medium'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir params.outdir, mode:'copy'


    input:
        tuple val(sample_id), path(bam), path(bai)

    output:
        tuple val(sample_id), path("${sample_id}_tags")

    stub:
    """
    mkdir ${sample_id}_tags
    """

    script:
    """
    makeTagDirectory ${sample_id}_tags ${bam}
    """
}


