#!/usr/bin/env nextflow

process TRIM {
    label 'process_low'
    container 'ghcr.io/bf528/trimmomatic:latest'
    publishDir params.outdir_final

    input: 
    tuple val(sample_id), path(read)
    path(adapters)


    output:
    tuple val(sample_id), path('*.fastq.gz'), emit: trimmed
    path('*.log'), emit: logs
    
    script:
    """
    trimmomatic SE -threads ${task.cpus} -phred33 ${read} ${sample_id}_trimmed.fastq.gz ILLUMINACLIP:${adapters}:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36  2> ${sample_id}_trim.log
    """

    stub:
    """
    touch ${sample_id}_stub_trim.log
    touch ${sample_id}_stub_trimmed.fastq.gz
    """
}
