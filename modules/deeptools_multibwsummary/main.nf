#!/usr/bin/env nextflow

process MULTIBWSUMMARY {


    stub:
    """
    touch bw_all.npz
    """
}