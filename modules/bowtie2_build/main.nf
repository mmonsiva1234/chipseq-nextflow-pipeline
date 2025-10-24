#!/usr/bin/env nextflow

process BOWTIE2_BUILD {


    stub:
    """
    mkdir bowtie2_index
    """
}