#!/usr/bin/env nextflow

process FINDPEAKS {
  

    stub:
    """
    touch ${rep}_peaks.txt
    """
}


