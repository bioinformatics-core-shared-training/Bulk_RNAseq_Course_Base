#!/bin/bash
#SBATCH --mem=8192
#SBATCH -t 2:00:00
#SBATCH -o RNAseqMetrics.%A.%a.%j.out
#SBATCH -e RNAseqMetrics.%A.%a.%j.err
#SBATCH -J RNAseqMetrics

set -exu

# This scripts uses the bulkRNAseq_build conda environment.
# condaBin is the path to your conda binary directory
condaBin=/mnt/scratchc/bioinformatics/sawle01/software/miniforge3/bin

bamDir=${1}

lineNumb=${SLURM_ARRAY_TASK_ID}
inBam=`ls ${bamDir}/*bam | sed "${lineNumb}q;d"`

output=${inBam/.bam/.RNA_metrics.txt}

refFlat="materials_build/salmon_ref/GRCm39.M35.refFlat.txt"

# Activate the conda environment
set +xu
source ${condaBin}/activate bulkRNAseq_build
set -xu

picard CollectRnaSeqMetrics \
        INPUT=${inBam} \
        OUTPUT=${output} \
        REF_FLAT=${refFlat} \
        STRAND_SPECIFICITY=NONE \
        VALIDATION_STRINGENCY=SILENT

echo "Done!"