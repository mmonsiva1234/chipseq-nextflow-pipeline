#!/usr/bin/env nextflow

process SAMTOOLS_SORT {
    label 'process_single'
    container 'ghcr.io/bf528/samtools:latest'
   // publishDir params.results, mode: 'copy'
    publishDir "${params.outdir}/alignment", mode: 'copy'
    
    input:
    tuple val(name), path(bam)

    output:
    tuple val(name), path("${name}.sorted.bam")

    script:
    """
    samtools sort -@ ${task.cpus} -o ${name}.sorted.bam ${bam}
    """
    // -@ uses multiple CPU threads to speed up sorting double check the label for this command
    stub:
    """
    touch ${name}.sorted.bam
    """
}