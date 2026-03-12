#!/usr/bin/env nextflow

process SAMTOOLS_IDX {
    label 'process_low'
    container 'ghcr.io/bf528/samtools:latest'
    publishDir params.outdir_final

    input: 
    tuple val(sample_id), path(sorted_bam)

    output:
    tuple val(sample_id), path("${sample_id}.sorted.bam"), path("${sample_id}.sorted.bam.bai")

    script: 
    """
    samtools index -@ ${task.cpus} ${sample_id}.sorted.bam
    """


    stub:
    """
    touch ${sample_id}.stub.sorted.bam.bai
    """
}