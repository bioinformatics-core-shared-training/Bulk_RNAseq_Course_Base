#!/bin/bash
#SBATCH -n 12 # Number of cores
#SBATCH -t 2:00:00 # Runtime in D-HH:MM
#SBATCH --mem=24G 
#SBATCH -o SalmonIndex_%j.out
#SBATCH -e SalmonIndex_%j.err
#SBATCH -J SalmonIndex

set -exu 

# This scripts uses the bulkRNAseq_build conda environment.
# condaBin is the path to your conda binary directory
condaBin=/mnt/scratchc/bioinformatics/sawle01/software/miniforge3/bin

echo "Start "`date`

# set the kmer length according to read length
# see the Salmon docs for advice
# For 50 base reads a kmer size of 23 is appropriate
# For reads >75 bases, the default of 31 is fine
kmer=31

# activate the conda environment and then salmon 
set +xu
source ${condaBin}/activate bulkRNAseq_build
set -xu

salmon index \
    -t materials_build/salmon_ref/gentrome.fa.gz \
    -d materials_build/salmon_ref/decoys.txt \
    -k ${kmer} \
    -p 12 \
    --gencode \
    -i materials_build/salmon_ref/salmon_index

echo "Done "`date`
salmon --version
conda deactivate
