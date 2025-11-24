#!/usr/bin/env nextflow

process BEDTOOLS_INTERSECT {
    tag "replicate_consensus"

    container 'ghcr.io/bf528/bedtools:latest'
    publishDir "${params.results}/reproducible_peaks", mode: 'copy'
    
    input:
    tuple path(bed1), path(bed2)

    output:
    path "consensus_peaks.bed"

    
    script:
    """
    bedtools intersect \
        -a ${bed1} \
        -b ${bed2} \
        > consensus_peaks.bed
    """  

}