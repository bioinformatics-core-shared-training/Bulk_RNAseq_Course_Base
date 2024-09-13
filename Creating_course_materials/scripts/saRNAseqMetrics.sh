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

output=${inBam/.bam/.RNAseqMetrics.txt}

refFasta="${wkDir}/references/homo_sapiens/GRCh38/fasta/hsa.GRCh38.fa"
refFlat="${wkDir}/references/homo_sapiens/GRCh38/annotation/hsa.GRCh38.txt"
rRNA="${wkDir}/references/ribsosomal_RNA.GRCh38.108.intervals_list"

tempDir=${wkDir}/tmp_RNAmtr
mkdir -p ${tempDir}

 singularity exec \
    -B ${wkDir} \
    ${wkDir}/${simg} \
    java -Djava.io.tmpdir="${tempDir}" \
        -Xms4032m -Xmx4032m \
        -jar /usr/local/lib/picard.jar CollectRnaSeqMetrics \
        INPUT=${inBam} \
        OUTPUT=${output} \
        REFERENCE_SEQUENCE=${refFasta} \
        REF_FLAT=${refFlat} \
        RIBOSOMAL_INTERVALS=${rRNA} \
        STRAND_SPECIFICITY=SECOND_READ_TRANSCRIPTION_STRAND \
        ASSUME_SORTED=true \
        VALIDATION_STRINGENCY=SILENT \
        TMP_DIR="$TMPDIR"

echo "Done!"