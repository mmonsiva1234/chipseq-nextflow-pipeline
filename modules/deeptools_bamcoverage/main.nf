#!/usr/bin/env nextflow

process BAMCOVERAGE {
    label 'process_medium'
    container 'ghcr.io/bf528/deeptools:latest'
    // publishDir "${params.outdir}/bigwig", mode: 'copy'
    publishDir params.results, mode: 'copy'

    input:
    tuple val(name), path(sorted_bam), path(bai)
    //tuple val(name),  path(bam), path(bai)

    output:
    tuple val(name), path("${name}.bw")

    script:
    """
    bamCoverage -b ${sorted_bam} -o ${name}.bw
    """
 //ln -s ${bam} ${name}.bam
   // ln -s ${bai} ${name}.bam.bai
    // bamCoverage -b ${name} -o ${name}.bw
    stub:
    """
    touch ${name}.bw
    """
}