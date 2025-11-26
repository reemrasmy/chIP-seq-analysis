#!/usr/bin/env nextflow

process POS2BED {
    label 'process_low'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir params.outdir_final

    input: 

    tuple( val(ip_sampleid) , path(peaks_txt) )

    output: 

    tuple( val(ip_sampleid), path("peaks_${ip_sampleid}.bed") )

    script: 
    """
    pos2bed.pl ${peaks_txt} > peaks_${ip_sampleid}.bed 
    """

    stub:
    """
    touch ${homer_txt.baseName}.bed
    """
}


