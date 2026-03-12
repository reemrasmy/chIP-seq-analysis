# ChIP-seq Analysis of RUNX1 Binding in MCF-7 Breast Cancer Cells

## Project Overview
This project implements a reproducible ChIP-seq analysis pipeline to characterize genome-wide binding patterns of a transcription factor in MCF-7 breast cancer cells.

The analysis reproduces key findings from the study RUNX1 contributes to higher-order chromatin organization and gene regulation in breast cancer cells, which investigated how the transcription factor RUNX1 regulates gene expression and chromatin organization in breast cancer. 

By analyzing ChIP-seq data from immunoprecipitated samples and corresponding input controls, this project identifies enriched genomic regions bound by the protein and infers its biological function and identity through motif discovery, genomic enrichment analysis, and integration with RNA-seq data.

#### *Biological Context of Study*

RUNX1 is a transcription factor that can act as both a tumor suppressor and oncogene depending on cellular context and has been implicated in several cancers, including breast cancer. 

chipseq_paper

RUNX1 regulates gene expression through direct binding at promoters and enhancers and may also influence higher-order chromatin structure. Understanding RUNX1 binding patterns helps reveal how transcription factors control regulatory networks involved in tumor progression.

In this study, genome-wide RUNX1 binding sites were identified in MCF-7 breast cancer cells to determine how RUNX1 contributes to transcriptional regulation and chromatin organization.

## Project Goals 

This project aimed to reproduce key ChIP-seq analyses used to identify the transcription factor and characterize its regulatory role.

Specifically, the analysis reproduces:

• Genome-wide identification of enriched protein binding sites (peak calling)
• Motif discovery within enriched binding regions
• Visualization of transcription factor binding patterns across genes
• Integration of ChIP-seq peaks with RNA-seq data to identify potential direct transcriptional targets

## Computational Pipeline Overview

1. Quality control of raw ChIP-seq reads using FastQC
2. Adapter trimming and quality filtering using Trimmomatic 
3. Alignment of reads to the reference genome using Bowtie2
4. Alignment processing and sorting using SAMtools
5. Generating normalized signal tracks using deepTools
6. Peak calling using HOMER to identify enriched protein-DNA binding regions
7. Motif discovery within enriched peaks using HOMER
8. Functional enrichment analysis of peak-associated genes using GREAT
9. Integrating ChIP-seq peaks with RNA-seq differential expression results

## Programs & Tools

**Workflow**: Nextflow

**Read Trimming**: Trimmomatic

**Quality control**: FastQC, MultiQC

**Alignment**: Bowtie2

**Alignment processing**: SAMtools

**Peak calling**: HOMER

**Signal visualization**: deepTools

**Motif discovery**: HOMER

**Functional enrichment**: GREAT

## Repository Structure

```
chip-seq-analysis/
│
├── workflow/
│   ├── main.nf             # Nextflow main workflow pipeline
│   ├── nextflow.config     # Reference and param files
│   └── modules/            # Nextflow process modules for each analysis step
│
├── envs/
│   └── chipseq_notebook_env.yml
│
├── python_scripts/
│   ├── peak_enrichment.py              # Extracts gene names from annotated ChIP-seq peaks to generate gene list for enrichment analysis.
│   └── publication_RNAseq_data.py      # Configures data to reproduce figure 2F in publication
│
├── data/
│   ├── annotated_peaks.tsv                                 # HOMER generated annotated peaks file
│   ├── GSE75070_MCF7_runx1_rnaseq_log2_foldchange.tsv      # RNA-seq normalized log2fold change results
│   └── igv_data/                                           # genome browser tracks for each sample (bigwigs)
│
├── project_reports/
│   ├── runx1_chIPseq.ipynb     # full project analysis with figures 
│   └── runx1_chIPseq.html      # project analysis in html 
│
├── chip-seq-pipeline.png       # viszualization of project pipeline
└── README.md
```


## Key Results of Study

Peak calling identified thousands of enriched genomic regions corresponding to transcription factor binding sites. Signal coverage analysis revealed strong enrichment of binding near transcription start sites (TSS), indicating that the protein primarily binds promoter regions and likely functions as a transcriptional regulator. 


Motif enrichment analysis identified the RUNX1 binding motif as the most significantly enriched sequence within peaks (p ≈ 1e-537), confirming that the protein captured in the ChIP experiment corresponds to the RUNX1 transcription factor. 


Additional enriched motifs included FOXM1, FOXA1, and FOXA2, suggesting potential cooperative binding with other transcription factors involved in cell proliferation and gene regulation. 


Integration of ChIP-seq peaks with RNA-seq differential expression results demonstrated that several genes exhibiting expression changes also contain nearby RUNX1 binding sites, indicating potential direct transcriptional regulation by RUNX1.


Visualization of genomic loci further confirmed strong RUNX1 binding near the promoters of MALAT1 and NEAT1, supporting the study’s conclusion that RUNX1 directly regulates these long non-coding RNAs involved in nuclear organization and cancer progression.

## Skills Demonstrated

• ChIP-seq data analysis & reproducible workflow development

• Nextflow pipeline design for genomics workflows

• Peak calling and transcription factor binding analysis

• Motif discovery and regulatory sequence analysis

• Integration of ChIP-seq and RNA-seq datasets

• Biological interpretation of genome-wide transcription factor binding

#### Citation
Barutcu et al.
RUNX1 contributes to higher-order chromatin organization and gene regulation in breast cancer cells.
Biochimica et Biophysica Acta (2016)