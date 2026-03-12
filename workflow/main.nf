#!/usr/bin/env nextflow
include {FASTQC as FASTQC_RAW} from './modules/fastqc'
include {FASTQC as FASTQC_TRIM} from './modules/fastqc'
include {TRIM} from './modules/trimmomatic'
include {BOWTIE2_BUILD} from './modules/bowtie2_build'
include {BOWTIE2_ALIGN} from './modules/bowtie2_align'
include {SAMTOOLS_SORT} from './modules/samtools_sort'
include {SAMTOOLS_FLAGSTAT} from './modules/samtools_flagstat'
include {MULTIQC} from './modules/multiqc'
include {SAMTOOLS_IDX} from './modules/samtools_idx'
include {BAMCOVERAGE} from './modules/deeptools_bamcoverage'
include {MULTIBWSUMMARY} from './modules/deeptools_multibwsummary'
include {PLOTCORRELATION} from './modules/deeptools_plotcorrelation'
include {TAGDIR} from './modules/homer_maketagdir'
include {FINDPEAKS} from './modules/homer_findpeaks'
include {POS2BED} from './modules/homer_pos2bed'
include {BEDTOOLS_INTERSECT} from './modules/bedtools_intersect'
include {BEDTOOLS_REMOVE} from './modules/bedtools_remove'
include {ANNOTATE} from './modules/homer_annotatepeaks'
include {COMPUTEMATRIX} from './modules/deeptools_computematrix'
include {PLOTPROFILE} from './modules/deeptools_plotprofile'
include {FIND_MOTIFS_GENOME} from './modules/homer_findmotifsgenome'

workflow {

    // Initial Channel
    read_ch = Channel.fromPath(params.samplesheet)
    .splitCsv( header: true )
    .map{ row -> tuple(row.name, file(row.path)) }
    //read_ch.view()
        // Sample Output: 
        //[INPUT_rep1_subset, /projectnb/bf528/materials/project-3-chipseq/subsampled_files/INPUT_rep1.subset.fastq.gz]
        //[INPUT_rep2_subset, /projectnb/bf528/materials/project-3-chipseq/subsampled_files/INPUT_rep2.subset.fastq.gz]
    
    // Running FASTQC on raw reads first to see difference in quality after using trimmomatic
    FASTQC_RAW(read_ch)
    TRIM(read_ch, params.adapter_fa)
    // Running FASTQC on trimmed reads 
    FASTQC_TRIM(TRIM.out.trimmed)
    BOWTIE2_BUILD(params.genome)
    BOWTIE2_ALIGN(read_ch, BOWTIE2_BUILD.out)
    SAMTOOLS_SORT(BOWTIE2_ALIGN.out)
    SAMTOOLS_FLAGSTAT(SAMTOOLS_SORT.out)

    trim_logs = TRIM.out.logs
    fastqc_zips = FASTQC_RAW.out.zip.map { sample_id, zip -> zip }
    flagstats = SAMTOOLS_FLAGSTAT.out

    multiqc_ch = fastqc_zips.mix(trim_logs, flagstats).flatten().collect()
    MULTIQC(multiqc_ch)


    SAMTOOLS_IDX(SAMTOOLS_SORT.out)
    BAMCOVERAGE(SAMTOOLS_IDX.out)

    bw_ch = BAMCOVERAGE.out.map { sample_id, bw -> bw }.collect()
    //bw_ch.view()
    // Sample Output: one list of all the files
        // [/projectnb/bf528/students/rrasmy/project-3-reemrasmy/work/ce/a2aee9b3da03f40d36b13bf25d1ccf/INPUT_rep2_subset.bw, 
        //  /projectnb/bf528/students/rrasmy/project-3-reemrasmy/work/5f/693ad35b547bbbbc239ef53c92047d/IP_rep2_subset.bw, 
        //  /projectnb/bf528/students/rrasmy/project-3-reemrasmy/work/01/fd91920581521074b36e503ccc8320/IP_rep1_subset.bw, 
        //  /projectnb/bf528/students/rrasmy/project-3-reemrasmy/work/78/1ce2d105f6d045ce21e9a513844524/INPUT_rep1_subset.bw ]
    MULTIBWSUMMARY(bw_ch, params.blacklist)
    PLOTCORRELATION(MULTIBWSUMMARY.out.summary)
    TAGDIR(SAMTOOLS_SORT.out)

    homer_meta = Channel.fromPath(params.homer_meta)
        .splitCsv(header: true)
        .map { row -> tuple(row.sample_id, row.replicate, row.condition)}
    
    tagdir_ch = TAGDIR.out
    
    join_samples = homer_meta.join(tagdir_ch)
    
    //Sample Output: 
        // [[IP_rep1_subset, IP, /projectnb/bf528/students/rrasmy/project-3-reemrasmy/work/fa/74f9be75d07726c6d7eba40b5b9b48/IP_rep1_subset_tags], [INPUT_rep1_subset, INPUT, /projectnb/bf528/students/rrasmy/project-3-reemrasmy/work/74/ba3025c4c3324b4537090af2400d75/INPUT_rep1_subset_tags]]
        // [[IP_rep2_subset, IP, /projectnb/bf528/students/rrasmy/project-3-reemrasmy/work/1f/2ad6e18c4af38341e9000d236cd4bf/IP_rep2_subset_tags], [INPUT_rep2_subset, INPUT, /projectnb/bf528/students/rrasmy/project-3-reemrasmy/work/18/cf0aa9ca1240de1f1e29c625a6a96d/INPUT_rep2_subset_tags]]
    paired_samples = join_samples.map { sample_id, replicate, condition, tagdir -> tuple(replicate, tuple(sample_id, condition, tagdir)) }
        .groupTuple()
        .map {replicate, samples -> 
            ip = samples.find { it[1] == 'IP'}
            control = samples.find {it[1] == 'INPUT'}
            tuple(ip[0], ip[1], ip[2], control[0], control[1], control[2]) }
        //.view()
    FINDPEAKS(paired_samples)
    // Sample Output: 
        //[IP_rep1_subset, /projectnb/bf528/students/rrasmy/project-3-reemrasmy/work/84/63f90febe248827d6aec6089794dca/peaks_IP_rep1_subset.txt]
        //[IP_rep2_subset, /projectnb/bf528/students/rrasmy/project-3-reemrasmy/work/89/5e23095cbe325c056ffd3e5a2ab0d6/peaks_IP_rep2_subset.txt]
    
    POS2BED(FINDPEAKS.out)
    // Sample Output: 
        //[IP_rep1_subset, /projectnb/bf528/students/rrasmy/project-3-reemrasmy/work/88/0ab9a04e8a9f7cee36e5a659686179/peaks_IP_rep1_subset.bed]
        //[IP_rep2_subset, /projectnb/bf528/students/rrasmy/project-3-reemrasmy/work/42/7baf99ee81b08c662914d3d7d334f6/peaks_IP_rep2_subset.bed]

    beds_ch = POS2BED.out.map { sample_id, bed -> bed }.collect()
    // Sample Output: 
        //[/projectnb/bf528/students/rrasmy/project-3-reemrasmy/work/42/7baf99ee81b08c662914d3d7d334f6/peaks_IP_rep2_subset.bed, 
        // /projectnb/bf528/students/rrasmy/project-3-reemrasmy/work/88/0ab9a04e8a9f7cee36e5a659686179/peaks_IP_rep1_subset.bed]
    
    BEDTOOLS_INTERSECT(beds_ch)
    BEDTOOLS_REMOVE(BEDTOOLS_INTERSECT.out, params.blacklist)
    ANNOTATE(BEDTOOLS_REMOVE.out, params.genome, params.gtf)
    ip_bws = BAMCOVERAGE.out.filter {sample_id, bw -> sample_id.startsWith('IP')}
        //Sample Output: 
            //[IP_rep2, /projectnb/bf528/students/rrasmy/project-3-reemrasmy/work/ae/b5ff64edd3418b96158503ed45bd1b/IP_rep2.bw]
            //[IP_rep1, /projectnb/bf528/students/rrasmy/project-3-reemrasmy/work/e2/a128fc5cac1b89820ae930c4f5c35f/IP_rep1.bw]
    
    COMPUTEMATRIX(ip_bws, params.ucsc_genes)
    PLOTPROFILE(COMPUTEMATRIX.out)
    FIND_MOTIFS_GENOME(ANNOTATE.out, params.genome)

    


}
// commands
// nextflow run main.nf -stub-run --outdir stub_results
// nextflow run main.nf -profile singularity,local
// nextflow run main.nf -profile singularity,cluster
// conda env create -f chipseq_notebook_env.yml
// Check Version
    // singularity exec docker://<container_name> <tool_command> --version

