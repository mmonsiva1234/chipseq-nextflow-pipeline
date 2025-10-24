#!/usr/bin/env nextflow

process BEDTOOLS_INTERSECT {
    

    stub:
    """
    touch repr_peaks.bed
    """
}