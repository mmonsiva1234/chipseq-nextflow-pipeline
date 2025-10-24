#!/usr/bin/env nextflow

process COMPUTEMATRIX {
    

    stub:
    """
    touch ${sample_id}_matrix.gz
    """
}