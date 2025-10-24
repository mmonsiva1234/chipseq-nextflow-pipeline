#!/usr/bin/env nextflow

process MULTIQC {


    stub:
    """
    touch multiqc_report.html
    """
}