#!/usr/bin/env nextflow

process FASTQC {


    stub:
    """
    touch stub_${sample_id}_fastqc.zip
    touch stub_${sample_id}_fastqc.html
    """
}