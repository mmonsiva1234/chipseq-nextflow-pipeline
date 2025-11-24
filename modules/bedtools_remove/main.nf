#!/usr/bin/env nextflow

process BEDTOOLS_REMOVE {
    label 'process_medium'
    // not sure if it is proceess_medium?
    container 'ghcr.io/bf528/bedtools:latest'
    publishDir params.results, mode: 'copy'   

    input:
    tuple val(name), path(peaks_bed), path(blacklist_bed)

    output:
    tuple val(name), path("${name}_filtered.bed")

    stub:
    """
    touch repr_peaks_filtered.bed
    """
    script:
    """
    bedtools intersect \
        -v \
        -a ${peaks_bed} \
        -b ${blacklist_bed} \
        > ${name}_filtered.bed
    """
}