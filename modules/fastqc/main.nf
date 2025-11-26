#!/usr/bin/env nextflow

process FASTQC {
    label 'process_low'
    container 'ghcr.io/bf528/fastqc:latest'
    publishDir params.outdir_final

    input: 
    tuple val(sample_id), path(read)

    output: 
    tuple val(sample_id), path('*.zip'), emit: zip
    tuple val(sample_id), path('*.html'), emit: html

    script: 
    """
    fastqc $read --threads ${task.cpus} 
    """

    stub:
    """
    touch stub_${sample_id}_fastqc.zip
    touch stub_${sample_id}_fastqc.html
    """
}

