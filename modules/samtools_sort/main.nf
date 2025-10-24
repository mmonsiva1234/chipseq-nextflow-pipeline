#!/usr/bin/env nextflow

process SAMTOOLS_SORT {


    stub:
    """
    touch ${sample_id}.stub.sorted.bam
    """
}