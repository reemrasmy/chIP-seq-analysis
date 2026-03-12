#!/usr/bin/env nextflow

process SAMTOOLS_SORT {
    label 'process_medium'
    container 'ghcr.io/bf528/samtools:latest'
    publishDir params.outdir_final

    input: 
    tuple val(sample_id), path(bam)
    
    output: 
    tuple val(sample_id), path("${sample_id}.sorted.bam")
    
    script: 
    """
    samtools sort -@ ${task.cpus} ${bam} > ${sample_id}.sorted.bam
    samtools index -@ ${task.cpus} ${sample_id}.sorted.bam
    """
    
    stub:
    """
    touch ${sample_id}.sorted.bam
    """
}