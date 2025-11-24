#!/usr/bin/env nextflow

process BOWTIE2_BUILD {
    label 'process_high'
    // not sure if it is proceess_medium?
    // not sure if im suppose to add in container for both bowtie2 align and bowtie2 build?
    container 'ghcr.io/bf528/bowtie2:latest'
    // publishDir "${params.outdir}/genome_index", mode: 'copy'
    publishDir params.results, mode: 'copy'

    input: 
    path genome_fasta

    output:
    path "genome_index.1.bt2", emit: index
    // bowtie2 created 6 index files 

    script:
    """
    bowtie2-build ${genome_fasta} genome_index
    """
 // mkdir bowtie2_index
    stub:
    """
    touch genome_index.1.bt2
    touch genome_index.2.bt2
    touch genome_index.3.bt2
    touch genome_index.4.bt2
    touch genome_index.rev.1.bt2
    touch genome_index.rev.2.bt2
    """
}