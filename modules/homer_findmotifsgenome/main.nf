#!/usr/bin/env nextflow

process FIND_MOTIFS_GENOME {
    label 'process_medium'
    container 'ghcr.io/bf528/homer_samtools:latest'
    publishDir params.outdir_final

    input: 
    path(annotated_peaks)
    path(genome)

    output: 
    path("motifs/")
    
    script: 
    """
    mkdir motifs
    findMotifsGenome.pl ${annotated_peaks} ${genome} motifs/ -size 200
    """
    stub:
    """
    mkdir motifs
    """
}


