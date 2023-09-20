# -*- mode: Snakemake -*-
#
# list the all input files for each step

# ---- Quality control
# FastQC reports
TARGET_FASTQC = expand(
    str(QC_FP/'reports'/'{sample}_{rp}_fastqc'/'fastqc_data.txt'),
    sample=Samples.keys(), rp=Pairs)

# Quality-control reads
TARGET_CLEAN = expand(
    str(QC_FP/'cleaned'/'{sample}_{rp}.fastq.gz'),
    sample = Samples.keys(), rp = Pairs)

TARGET_QC = TARGET_CLEAN + TARGET_FASTQC

# Remove host reads
TARGET_DECONTAM = expand(
    str(QC_FP/'decontam'/'{sample}_{rp}.fastq.gz'),
    sample = Samples.keys(), rp = Pairs)


# ---- Classification
# Classify all reads
TARGET_CLASSIFY = [str(CLASSIFY_FP/'kraken'/'all_samples.tsv')]


# ---- Assembly
# Assemble contigs
TARGET_ASSEMBLY = expand(
    str(ASSEMBLY_FP/'contigs'/'{sample}-contigs.fa'),
    sample = Samples.keys())


# ---- Mapping
# Map reads to target genomes
TARGET_MAPPING = [
    expand(
        str(MAPPING_FP/"{genome}"/"{sample}.bam.bai"),
        genome=GenomeSegments.keys(), sample=Samples.keys()),
    expand(
        str(MAPPING_FP/"{genome}"/"{sample}.raw.bcf"),
        genome=GenomeSegments.keys(), sample=Samples.keys()),
    expand(
        str(MAPPING_FP/"{genome}"/"coverage.csv"),
        genome=GenomeSegments.keys())
]


# ---- Contig annotation
# Annotate all contigs
TARGET_ANNOTATE = expand(
    str(ANNOTATION_FP/'summary'/'{sample}.tsv'),
    sample=Samples.keys())


# ---- Reports
# MultiQC report
MULTIQC_REPORT = str(QC_FP/'reports'/'multiqc_report.html')

TARGET_REPORT = [
    str(QC_FP/'reports'/'preprocess_summary.tsv'),
    str(QC_FP/'reports'/'fastqc_quality.tsv'),
    str(ASSEMBLY_FP/'contigs_coverage.txt'),
    MULTIQC_REPORT
]

# ---- All targets
TARGET_ALL = (
    TARGET_QC +
    TARGET_DECONTAM +
    TARGET_CLASSIFY +
    TARGET_ASSEMBLY +
    TARGET_ANNOTATE +
    TARGET_REPORT +
    TARGET_MAPPING
)
