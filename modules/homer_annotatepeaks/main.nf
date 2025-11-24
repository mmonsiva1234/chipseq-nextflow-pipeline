#!/usr/bin/env nextflow

process ANNOTATE {
    label 'process_low'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir params.outdir, mode:'copy'


    input:
        path bedfile
        path genome
        path gtf

    output:
        path "annotated_peaks.txt"

    script:
    """
    annotatePeaks.pl $bedfile \
        $genome \
        -gtf $gtf \
        > annotated_peaks.txt
    """

    stub:
    """
    touch annotated_peaks.txt
    """
}



