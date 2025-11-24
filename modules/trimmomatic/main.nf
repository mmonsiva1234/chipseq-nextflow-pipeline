#!/usr/bin/env nextflow

process TRIM {
    label 'process_low'
    // worked up this label online couldnt find in the lab , 
    container 'ghcr.io/bf528/trimmomatic:latest'
    publishDir params.results, mode: 'copy'

    input:
    tuple val(name), path(reads)

    output:
    tuple val(name), path("${name}_trimmed.fastq.gz"), emit: trimmed_reads
    tuple val(name), path("${name}.trim.log"), emit: log


    shell:
    """
     trimmomatic SE -threads ${task.cpus} \
        ${reads} \
        ${name}_trimmed.fastq.gz \
        ILLUMINACLIP:${params.adapter_fa}:2:30:10 \
        SLIDINGWINDOW:4:20 MINLEN:25 \
        2> ${name}.trim.log
    """

    stub:
    """
    touch ${name}.trim.log
    touch ${name}_trimmed.fastq.gz
    """
}
