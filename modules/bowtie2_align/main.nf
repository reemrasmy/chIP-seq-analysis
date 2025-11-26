#!/usr/bin/env nextflow

process BOWTIE2_ALIGN {
    label 'process_high'
    container 'ghcr.io/bf528/bowtie2:latest'
    publishDir params.outdir_final

    input: 
    tuple val(sample_id), path(read)
    tuple val(ref_genome), path(bowtie2_index)

    output:
    tuple val(sample_id), path("${sample_id}.bam")

    script: 
    """
    bowtie2 -x bowtie2_index/${ref_genome} -U ${read} -p ${task.cpus} | samtools view -bS - > ${sample_id}.bam

    """
    stub:
    """
    touch ${sample_id}.bam
    """
}