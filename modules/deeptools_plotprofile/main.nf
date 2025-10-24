#!/usr/bin/env nextflow

process PLOTPROFILE {
    


    stub:
    """
    touch ${sample_id}_signal_coverage.png
    """
}