#!/usr/bin/env nextflow

process BEDTOOLS_REMOVE {
    label 'process_low'
    container 'ghcr.io/bf528/bedtools:latest'
    publishDir params.outdir_final

    input: 
    path(all_reproducible_peaks)
    path(blacklist)
    
    output:
    path("reproducible_peaks_filtered.bed")
    script: 
    """
    bedtools intersect -a ${all_reproducible_peaks} -b ${blacklist} -v > reproducible_peaks_filtered.bed
    """

    stub:
    """
    touch repr_peaks_filtered.bed
    """
}