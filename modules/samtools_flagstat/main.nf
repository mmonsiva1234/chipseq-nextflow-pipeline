#!/usr/bin/env nextflow

process SAMTOOLS_FLAGSTAT {


    stub:
    """
    touch ${sample_id}_flagstat.txt
    """
}