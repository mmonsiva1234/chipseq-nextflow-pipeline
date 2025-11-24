#!/usr/bin/env nextflow

process FINDPEAKS {
    label 'process_medium'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir params.outdir, mode:'copy'

    input:
        tuple val(rep), path(ip_tagdir), path(input_tagdir)

    output:
        tuple val(rep), path("${rep}_peaks.txt")


    stub:
    """
    touch ${rep}_peaks.txt
    """
    
    script:
    """
    findPeaks ${ip_tagdir} \
        -i ${input_tagdir} \
        -style factor \
        > ${rep}_peaks.txt
    """
}


