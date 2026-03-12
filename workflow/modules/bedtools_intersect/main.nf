#!/usr/bin/env nextflow

process BEDTOOLS_INTERSECT {
    label 'process_low'
    container 'ghcr.io/bf528/bedtools:latest'
    publishDir params.outdir_final

    input: 
    
    tuple(path(bed_rep1), path(bed_rep2))

    output: 
    
    path("reproducible_peaks.bed")
    
    script: 
    """
    bedtools intersect -a ${bed_rep1} -b ${bed_rep2} -wa > reproducible_peaks.bed
    """

    stub:
    """
    touch repr_peaks.bed
    """
}