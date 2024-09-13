#!/bin/bash
#SBATCH --mem=16G
#SBATCH -c 8
#SBATCH -t 2:00:00
#SBATCH -o AddRG.%A.%a.%j.out
#SBATCH -e AddRG.%A.%a.%j.err
#SBATCH -J AddRG

set -exu

# This scripts uses the bulkRNAseq_build conda environment.
# condaBin is the path to your conda binary directory
condaBin=/mnt/scratchc/bioinformatics/sawle01/software/miniforge3/bin

bamDir=${1}

lineNumb=${SLURM_ARRAY_TASK_ID}
inBam=`ls ${bamDir}/*bam | sed "${lineNumb}q;d"`

tmpBam=${inBam/.bam/.tmp.bam}

# Activate the conda environment
set +xu
source ${condaBin}/activate bulkRNAseq_build
set -xu

samtools addreplacerg \
    -@ 8 \
    -r "@RG\tID:RG1\tSM:SampleName\tPL:Illumina\tLB:Library.fa" \
    -o ${tmpBam} \
    ${inBam}

mv ${tmpBam} ${inBam}
rm ${inBam}.bai
samtools index ${inBam}

echo "Done!"