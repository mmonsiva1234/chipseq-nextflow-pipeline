#!/usr/bin/env nextflow

process MULTIBWSUMMARY {
    label 'process_medium'
    container 'ghcr.io/bf528/deeptools:latest'
    publishDir "${params.results}/multiBigwigSummary", mode: 'copy'

    input: 
        path bigwigs

    output: 
        path "bw_all.npz"
        path "bw_all.tab"

    stub:

    """
    touch bw_all.npz
    touch bw_all.tab
    """
    
    script:
    """
    multiBigwigSummary bins \
        --bwfiles ${bigwigs.join(' ')} \
        --binSize 1000 \
        --outFileName bw_all.npz \
        --outRawCounts bw_all.tab
    """

}