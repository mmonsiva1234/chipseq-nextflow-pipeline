#!/usr/bin/env nextflow

process TAGDIR {


    stub:
    """
    mkdir ${sample_id}_tags
    """
}


