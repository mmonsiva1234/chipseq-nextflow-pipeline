#!/usr/bin/env nextflow

process FIND_MOTIFS_GENOME {
    label 'process_medium'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir "${params.outdir}/motifs", mode:'copy'
    
    input:
    path peaks_bed

    output:
    path "motifs"

    script:
    """
    mkdir motifs
    findMotifsGenome.pl ${peaks_bed} hg38 motifs -size given
    """
}


