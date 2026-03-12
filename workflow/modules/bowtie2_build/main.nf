#!/usr/bin/env nextflow

process BOWTIE2_BUILD {
    label 'process_high'
    container 'ghcr.io/bf528/bowtie2:latest'
    publishDir params.outdir_final

    input: 
    path(ref_genome)

    output:
    tuple val("${ref_genome.baseName}"), path("bowtie2_index/") 

    script: 
    """
    mkdir bowtie2_index
    bowtie2-build --threads ${task.cpus} ${ref_genome} bowtie2_index/${ref_genome.baseName} 

    """
    stub:
    """
    mkdir bowtie2_index
    """
}