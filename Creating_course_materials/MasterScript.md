# Preamble

This markdown contains all the steps to create the necessary reference files,
data files and R objects for the "Introduction to Bulk RNA-seq data analysis"
course.

The steps in this MasterScript assume that you are working on a HPC with the
Slurm job scheduler. If you are working on a different system, you will need to
modify the script to suit your system.

The various scripts (bash, R, etc.) used in this markdown are stored in the
`scripts` directory. The markdown commands assume that the `scripts` directory
is on the PATH. All scripts and paths in this markdown assume the working 
directory is the `Creating_course_materials` directory. 

The materials are built inside the git repo directory in a directory called
`materials_build`. This has been added to the `.gitignore` file so that it is
not tracked by git. In this markdown, the variable `matDir` is used to refer to
the `materials_build` directory. This variable should be set to the full path of
the `materials_build` directory.

```
matDir=`readlink -f materials_build`
```


Most software used is managed using a conda enviroment. The file
`scripts/build_env.yaml` can be used to create the enviroment. Build it using:

```
mamba env create --file scripts/build_env.yaml 
```

Then activate it when necessary using:

```
conda activate bulkRNAseq_build
```

You will also need to modify the path to the `activate` command in any scripts
that use the Conda enviroment. 

The scripts `setup_env.sh` will start the conda enviroment and set any variables
(e.g. ${matDir}) that are used.

```
. ./setup_env.sh
```

# 1. Download the fastq files from the SRA database

The data for this course comes from the paper [Transcriptomic Profiling of 
Mouse Brain During Acute and Chronic Infections by *Toxoplasma gondii*
Oocysts](https://www.frontiersin.org/articles/10.3389/fmicb.2020.570903/full) 
[@Hu2020]. The raw data (sequence reads) can be downloaded from the [NCBI Short 
Read Archive](https://www.ncbi.nlm.nih.gov/sra) under project number 
**PRJNA483261**.

We will use the sra-toolkit to download the data.

### b) Set up the download directory

We want to direct the toolkit to download the data to a directory we specify.

```
vdb-config --set /repository/user/default-path=${matDir}
vdb-config --set /repository/user/main/public/root=${matDir}
vdb-config --prefetch-to-user-repo
```

# 2. Download data

## a) Manually retrieve accessions and meta data

```
mkdir materials_build/accessoryFiles
```

From:
https://www.ncbi.nlm.nih.gov/Traces/study/?acc=PRJNA562904&o=acc_s%3Aa

--> materials_build/accessoryFiles/SraRunTable.txt
--> materials_build/accessoryFiles/SRR_Acc_List.txt

## b) Get SRA files and extract fastqs

```
sbatch --array=1-12 saPrefetchAndDump.sh \
    materials_build/accessoryFiles/SRR_Acc_List.txt
```
Submitted batch job 36172873
--> sraDir/sra/SRR{*}.sra

# 3. Generate Salmon Reference

## a) References for Salmon index from Gencode

```
salRefDir=${matDir}/salmon_ref/
mkdir ${salRefDir} 

gcdURL=https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_M35
wget -P ${salRefDir} ${gcdURL}/gencode.vM35.transcripts.fa.gz
wget -P ${salRefDir} ${gcdURL}/GRCm39.genome.fa.gz
wget -P ${salRefDir} ${gcdURL}/gencode.vM35.basic.annotation.gtf.gz
```
--> materials_build/salmon_ref/gencode.vM35.transcripts.fa.gz
--> materials_build/salmon_ref/GRCm39.genome.fa.gz


### iii) Create concatenated reference file

The references will be the transcriptome followed by the decoy sequences (i.e.
the genome)

```
cat ${salRefDir}/gencode.vM35.transcripts.fa.gz \
    ${salRefDir}/GRCm39.genome.fa.gz \
    > ${salRefDir}/gentrome.fa.gz
```
--> materials_build/salmon_ref/gentrome.fa.gz

### ii) Make decoy targets list

The decoy sequences are the genomic sequences.

```
zcat ${salRefDir}/GRCm39.genome.fa.gz |
    grep "^>" | 
    cut -f 1 -d ' ' | 
    sed 's/>//g' \
    > ${salRefDir}/decoys.txt
```
--> ${salRefDir}/decoys.txt

### iii) Create index

Note: read length is 50 so the kmer length should be 23 

```
sbatch sSalmonIndex.sh
```
Submitted batch job 36173566
--> **materials_build/salmon_ref/salmon_index**

```
mv SalmonIndex_1* logs/.
```

### iv) Extract chromosome 14 sequences

For the indexing practical we need cDNA and DNA fasta files with just chr14.

First the genome sequence:

```
zcat ${salRefDir}/GRCm39.genome.fa.gz |
    awk -v RS=">" '$1 == "chr14" {print ">"$0}' |
    gzip -c - > ${salRefDir}/GRCm39.genome.chr14.fa.gz
```
--> materials_build/salmon_ref/GRCm39.genome.chr14.fa.gz

To get the transcript sequences we need the names of the transcripts on chr14 from
the GTF file. We can then use `seqtk` to extract the sequences.

```
zcat ${salRefDir}/gencode.vM35.basic.annotation.gtf.gz |
    awk '($1 == "chr14" && $3 = "transcript") {print $10}' |
    sed 's/[";]//g' |
    sort |
    uniq > ${salRefDir}/chr14_transcripts.txt
seqtk subseq ${salRefDir}/gencode.vM35.transcripts.fa.gz \
    ${salRefDir}/chr14_transcripts.txt |
    gzip -c - > ${salRefDir}/gencode.vM35.transcripts.chr14_transcripts.fa.gz
```
--> materials_build/salmon_ref/gencode.vM35.transcripts.chr14_transcripts.fa.gz

Check that we can create the chr14 index in a reasonable time for the course.

```
cat ${salRefDir}/gencode.vM35.transcripts.chr14_transcripts.fa.gz \
    ${salRefDir}/GRCm39.genome.chr14.fa.gz \
    > ${salRefDir}/gentrome.chr14.fa.gz
echo "chr14" >> ${salRefDir}/decoys.chr14.txt
sbatch sSalmonIndex_chr14test.sh
```

Worked fine. Less than a minute.

```
rm -f ${salRefDir}/chr14_transcripts.txt
rm -f ${salRefDir}/gentrome.chr14.fa.gz
rm -f ${salRefDir}/decoys.chr14.txt
rm -rf ${salRefDir}/salmon_index_chr14
```

# 4. Run Salmon

```
bcdRegex="SRR[0-9]+"
fastqDir=${matDir}/fastq
quantDir=${matDir}/salmon_results
salInd=${salRefDir}/salmon_index

sbatch --array=1-12 saSalmonQuant.sh \
    ${bcdRegex} \
    ${fastqDir} \
    ${quantDir} \
    ${salInd}
```
--> **materials_build/salmon_results/SRR{*}**
--> materials_build/salmon_results/SRR{*}.SRR7657882.salmon.bam
--> materials_build/salmon_results/SRR{*}.SRR7657882.salmon.bam.bai

# 5. Run Picard for alignment QC

## a) Add read group to bam files

It seems Picard is now throwing an error if the read group is not present in the
BAM file. We will add the read group to the BAM files.

```
sbatch --array=1-12 saAddReadGroup.sh ${quantDir}
```

## a) Duplication Metrics

```
quantDir=${matDir}/salmon_results
sbatch --array=1-12 saDuplicationMetrics.sh ${quantDir}
```

