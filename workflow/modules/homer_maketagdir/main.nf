#!/usr/bin/env nextflow

process TAGDIR {
    label 'process_low' 
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir params.outdir_final

    input: 
    tuple val(sample_id), path(sorted_bam)
    
    output:
    tuple val(sample_id), path("${sample_id}_tags") 

    script: 
    """
    makeTagDirectory ${sample_id}_tags/ ${sorted_bam}
    """
    stub:
    """
    mkdir ${sample_id}_tags
    """
}


