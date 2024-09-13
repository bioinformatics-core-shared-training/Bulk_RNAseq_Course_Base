#!/bin/bash
#SBATCH --mem=8192
#SBATCH -t 2:00:00
#SBATCH -o DuplicationMetrics.%A.%a.%j.out
#SBATCH -e DuplicationMetrics.%A.%a.%j.err
#SBATCH -J DuplicationMetrics

set -exu

# This scripts uses the bulkRNAseq_build conda environment.
# condaBin is the path to your conda binary directory
condaBin=/mnt/scratchc/bioinformatics/sawle01/software/miniforge3/bin

bamDir=${1}

lineNumb=${SLURM_ARRAY_TASK_ID}
inBam=`ls ${bamDir}/*bam | sed "${lineNumb}q;d"`

outMtr=${inBam/.bam/.mkdup_metrics.txt}
outBam=${inBam/.bam/.mkdup.bam}

# Activate the conda environment
set +xu
source ${condaBin}/activate bulkRNAseq_build
set -xu

picard MarkDuplicates \
    INPUT=${inBam} \
    OUTPUT=${outBam} \
    METRICS_FILE=${outMtr} \
    CREATE_INDEX=true \
    READ_NAME_REGEX=null \
    VALIDATION_STRINGENCY=SILENT

echo "Done!"