#!/bin/bash
#SBATCH -n 6 # Number of cores
#SBATCH --mem=12G # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --time=12:00:00
#SBATCH -o getFastq_%A.%a.%j.out
#SBATCH -e getFastq_%A.%a.%j.err
#SBATCH -J getFastqSRA

set -exu

# This scripts uses the bulkRNAseq_build conda environment.
# condaBin is the path to your conda binary directory
condaBin=/mnt/scratchc/bioinformatics/sawle01/software/miniforge3/bin

# file with the list of SRR accessions
# run the job as an array job with the number of lines in the file
# each line should have a single SRR accession
# each job will select a line from the file according to the job array index
# and download the corresponding SRR accession
accList=$1

# Get the SRR accession
lineNumb=${SLURM_ARRAY_TASK_ID}
srrAcc=`sed "${lineNumb}q;d" ${accList}`

# Activate the conda environment
set +xu
source ${condaBin}/activate bulkRNAseq_build
set -xu

# prefech the SRA file
prefetch ${srrAcc}

# convert the SRA file to fastq
sraFile=materials_build/sra/${srrAcc}.sra
fasterq-dump -O materials_build/fastq --split-files ${sraFile}

gzip materials_build/fastq/${srrAcc}_1.fastq
gzip materials_build/fastq/${srrAcc}_2.fastq

echo "done"
