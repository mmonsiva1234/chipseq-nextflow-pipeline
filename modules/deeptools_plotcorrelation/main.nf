#!/usr/bin/env nextflow

process PLOTCORRELATION {
    label 'process_medium'
    container 'ghcr.io/bf528/deeptools:latest'
    publishDir params.results, mode: 'copy'

    input:
        path npz

    output:
        path "correlation_heatmap.png"
        path "correlation_values.tab"

    stub:
    """
    touch correlation_plot.png
    """

    script:
    """
    plotCorrelation \
        --corData ${npz} \
        --corMethod spearman \
        --whatToPlot heatmap \
        --colorMap RdBu \
        --plotNumbers \
        --skipZeros \
        --plotFile correlation_heatmap.png \
        --outFileCorMatrix correlation_values.tab
    """
   
}






