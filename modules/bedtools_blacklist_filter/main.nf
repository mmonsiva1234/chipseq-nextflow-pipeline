#!/usr/bin/env nextflow

process BEDTOOLS_BLACKLIST_FILTER {
    tag "blacklist_filter"
    label 'process_medium'

    container 'ghcr.io/bf528/bedtools:latest'
    publishDir "${params.results}/blacklist_filtered", mode: 'copy'

    input:
    tuple path(peaks), path(blacklist)

    output:
    path("filtered_peaks.bed")

    script:
    """
    bedtools intersect \
        -a ${peaks} \
        -b ${blacklist} \
        -v \
        > filtered_peaks.bed
    """

    stub:
    """
    touch filtered_peaks.bed
    """
}