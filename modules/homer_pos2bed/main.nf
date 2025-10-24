#!/usr/bin/env nextflow

process POS2BED {


    stub:
    """
    touch ${homer_txt.baseName}.bed
    """
}


