#!/usr/bin/env nextflow

process COMPUTEMATRIX {
    label 'process_medium'
    // not sure what the label is
    container 'ghcr.io/bf528/deeptools:latest'
    publishDir params.results, mode: 'copy'

    input:  
        path bigwigs
        path regions
        val window

    output:
        path "matrix.gz"

    stub:
    """
    touch ${sample_id}_matrix.gz
    """

    script:
    """
    computeMatrix scale-regions \
        --regionsFileName ${regions} \
        --scoreFileName ${bigwigs.join(' ')} \
        --regionBodyLength ${window} \
        --beforeRegionStartLength ${window} \
        --afterRegionStartLength ${window} \
        --binSize 50 \
        --numberOfProcessors ${task.cpus} \
        --outFileName matrix.gz
    """

}