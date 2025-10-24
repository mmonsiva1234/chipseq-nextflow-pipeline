#!/usr/bin/env nextflow

process BOWTIE2_ALIGN {
   

    stub:
    """
    touch ${sample_id}.bam
    """
}