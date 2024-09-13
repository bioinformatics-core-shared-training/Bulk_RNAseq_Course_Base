#!/bin/bash
#SBATCH --cpus-per-task 8 # Number of cores
#SBATCH -t 3:00:00 # Runtime in D-HH:MM
#SBATCH --mem=8G 
#SBATCH -o SalmonQuant_%A.%a.%j.out
#SBATCH -e SalmonQuant_%A.%a.%j.err
#SBATCH -J SalmonQuant

# This script is used to quantify the expression of transcripts using salmon
# It is designed to be run as an array job, with each job quantifying the
# expression of transcripts for a single sample
# The script takes 4 arguments:
# 1. A regex for extracting the sample barcode from the fastq files
# 2. The directory containing the fastq files
# 3. The parent directory in which to write the results directory
# 4. The directory containing the salmon index
#
# The script will handle multiple read files for each sample, and will write
# the results to a directory named after the barcode in the parent directory
#
# The barcode is used to identify fastqs for each sample
#
# The script extracts all possible barcodes from the fastq files in the fastq
# directory and then runs salmon quantification for the barcode corresponding to
# the array job number

set -exu

# This scripts uses the bulkRNAseq_build conda environment.
# condaBin is the path to your conda binary directory
condaBin=/mnt/scratchc/bioinformatics/sawle01/software/miniforge3/bin

echo "Start "`date`

bcdRegex=${1} # regex for extracting sample barcode from fastq files
fastqDir=${2} # directory containing fastq files
quantDir=${3} # parent directory in which to write results directory
salInd=${4} # salmon index directory

lineNumb=${SLURM_ARRAY_TASK_ID}
barcode=`ls ${fastqDir}/*_1.fastq.gz | grep -Eo ${bcdRegex} | sort | uniq | sed "${lineNumb}q;d"`

# read files
read1Files=`ls ${fastqDir}/*${barcode}_1.fastq.gz`
read2Files=${read1Files//_1/_2}

# output directory
outDir=${quantDir}/${barcode}

# sam file
samFile=${quantDir}/${barcode}.salmon.sam
bamFile=${quantDir}/${barcode}.salmon.bam

# activate the conda environment and then salmon 
set +xu
source ${condaBin}/activate bulkRNAseq_build
set -xu

salmon quant \
    -p 8 \
    -i ${salInd} \
    --gcBias \
    --writeMappings=${samFile} \
    -l A \
    -1 ${read1Files} \
    -2 ${read2Files} \
    -o ${outDir}

samtools sort -@ 8 -O BAM -o ${bamFile} ${samFile}    
samtools index ${bamFile}

rm -f ${samFile}

echo "Done "`date`
salmon --version 
samtools --version

conda deactivate