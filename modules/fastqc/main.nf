#!/usr/bin/env nextflow

process FASTQC {
    label 'process_low'
    container 'ghcr.io/bf528/fastqc:latest'
    // publishDir "${params.outdir}/fastqc", mode: 'copy'
    // FASTQC has a dedicates subfolder inside reaults/fastqc
    publishDir params.outdir, mode:'copy'


    input:
    tuple val(name), path(reads)
    // single-end input, only one FASTQ file

    output:
    tuple val(name), path("*_fastqc.zip"), emit: zip
    tuple val(name), path("*_fastqc.html"), emit: html
    //tuple val(name), path("*.zip"), path("*.html")

    script:
    """ 
    fastqc -t ${task.cpus} ${reads}
    """

    stub:
    """
    touch stub_${name}_fastqc.zip
    touch stub_${name}_fastqc.html
    """

 }