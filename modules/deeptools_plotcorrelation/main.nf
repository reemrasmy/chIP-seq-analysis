#!/usr/bin/env nextflow

process PLOTCORRELATION {
    label 'process_low'
    container 'ghcr.io/bf528/deeptools:latest'
    publishDir params.outdir_final

    input: 
    path(multibw_summary)

    output: 
    path('correlation_plot.png')

    script: 
    """
    plotCorrelation -in ${multibw_summary} -o correlation_plot.png -c spearman -p heatmap -T "ChIPseq Correlation Plot" --colorMap GnBu --plotNumbers  
    """

    stub:
    """
    touch correlation_plot.png
    """
}






