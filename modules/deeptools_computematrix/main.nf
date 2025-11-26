#!/usr/bin/env nextflow

process COMPUTEMATRIX {
    label 'process_medium'
    container 'ghcr.io/bf528/deeptools:latest'
    publishDir params.outdir_final

    input: 
    tuple(val(sample_id), path(ip_bw))
    path(genes_bed) //uscsc .bed file

    output: 
    tuple( val(sample_id), path("${sample_id}_matrix.gz") )

    script: 
    """
    computeMatrix scale-regions -S ${ip_bw} -R ${genes_bed} -b 2000 -a 2000 -o ${sample_id}_matrix.gz -p ${task.cpus}
    """

    stub:
    """
    touch ${sample_id}_matrix.gz
    """
}