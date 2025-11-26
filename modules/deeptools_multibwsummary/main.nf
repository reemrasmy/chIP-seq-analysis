#!/usr/bin/env nextflow

process MULTIBWSUMMARY {
    label 'process_high'
    container 'ghcr.io/bf528/deeptools:latest'
    publishDir params.outdir_final

    input:
    path(bw)
    path(blacklist)  
    
    output:
    path('multibw_summary.npz'), emit: summary
    path('multibw_counts.txt')
    
    script: 
    """
    multiBigwigSummary bins -b ${bw.join(" ")} -o multibw_summary.npz --outRawCounts multibw_counts.txt --smartLabels -bl ${blacklist} -p ${task.cpus}
    """

    stub:
    """
    touch bw_all.npz
    """
}