#!/usr/bin/env nextflow

process SAMTOOLS_FLAGSTAT {
    label 'process_low'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir params.outdir_final

    input: 
    tuple val(sample_id), path(sorted_bam) 

    output: 
    path("${sample_id}_flagstat.txt")
    
    script: 
    """
    samtools flagstat -@ ${task.cpus} ${sorted_bam} > ${sample_id}_flagstat.txt
    """

    stub:
    """
    touch ${sample_id}_flagstat.txt
    """
}