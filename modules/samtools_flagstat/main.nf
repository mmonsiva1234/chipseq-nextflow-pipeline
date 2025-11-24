#!/usr/bin/env nextflow

process SAMTOOLS_FLAGSTAT {
    label 'process_single'
    // wasnt label to find the label process for this mocule so used the samtools_idx label
    container 'ghcr.io/bf528/samtools:latest'
    publishDir params.results, mode: 'copy'

    input:
    tuple val(name), path(bam), path(bai)

    output: 
    tuple val(name), path("${name}.flagstat.txt")

    script: 
    """
    samtools flagstat ${bam} > ${name}.flagstat.txt
    """
    stub:
    """
    touch ${name}.flagstat.txt
    """

}