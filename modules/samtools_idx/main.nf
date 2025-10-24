#!/usr/bin/env nextflow

process SAMTOOLS_IDX {

    stub:
    """
    touch ${sample_id}.stub.sorted.bam.bai
    """
}