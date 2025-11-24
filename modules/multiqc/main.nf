#!/usr/bin/env nextflow

process MULTIQC {
    label 'process_medium'
    container 'ghcr.io/bf528/multiqc:latest'
    publishDir params.results, mode: 'copy'

    input:
    val qc_files

    output:
    path "multiqc_report.html", emit: html
    //path "multiqc_data", emit: data
   
    script:
    """
    multiqc ${params.results} -o .
    """


    stub:
    """
    touch multiqc_report.html
    """
}