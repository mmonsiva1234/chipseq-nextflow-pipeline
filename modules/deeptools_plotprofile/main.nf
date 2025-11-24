#!/usr/bin/env nextflow

process PLOTPROFILE {
    label 'process_medium'
    container 'ghcr.io/bf528/deeptools:latest'
    publishDir params.results, mode: 'copy'
  

    input:
        path(matrix)

    output:
        path "${matrix.baseName}.png"


    script:
    """
    plotProfile \
        --matrixFile ${matrix} \
        --outFileName ${matrix.baseName}.png
    """

}
