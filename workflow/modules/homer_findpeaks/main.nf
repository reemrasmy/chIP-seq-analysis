#!/usr/bin/env nextflow

process FINDPEAKS {
    label 'process_medium'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir params.outdir_final

    input: 
    tuple( val(ip_sampleid), val(ip_condition), path(ip_tagdir), val(input_sampleid), val(input_condition), path(input_tagdir) )

    output: 

    tuple( val(ip_sampleid), path("peaks_${ip_sampleid}.txt") )

    script: 
    """
    findPeaks ${ip_tagdir} -style factor -o peaks_${ip_sampleid}.txt -i ${input_tagdir}
    """

    stub:
    """
    touch ${rep}_peaks.txt
    """
}


