#!/usr/bin/env nextflow

process ANNOTATE {
    label 'process_low'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir params.outdir_final

    input: 
    path(filtered_peaks)
    path(ref_genome)
    path(gtf)
    
    output: 
    path("annotated_peaks.txt")
    
    script: 
    """
    annotatePeaks.pl ${filtered_peaks} ${ref_genome} -gtf ${gtf} > annotated_peaks.txt
    """

    stub:
    """
    touch annotated_peaks.txt
    """
}



