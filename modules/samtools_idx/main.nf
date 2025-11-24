#!/usr/bin/env nextflow

process SAMTOOLS_IDX {
    label 'process_single'
    container 'ghcr.io/bf528/samtools:latest'
    publishDir params.results, mode: 'copy'

    input: 
    tuple val(name), path(sorted_bam)

    output: 
    tuple val(name),  path("${name}.sorted.bam"), path("${name}.sorted.bam.bai")

    script:
    """
    samtools index ${name}.sorted.bam
    """
    
    stub:
    """
    touch ${name}.sorted.bam.bai
    """
}