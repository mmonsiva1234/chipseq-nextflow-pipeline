#!/usr/bin/env nextflow

process BEDTOOLS_REMOVE {
   

    stub:
    """
    touch repr_peaks_filtered.bed
    """
}