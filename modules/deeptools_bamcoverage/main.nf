#!/usr/bin/env nextflow

process BAMCOVERAGE {


    stub:
    """
    touch ${sample_id}.bw
    """
}