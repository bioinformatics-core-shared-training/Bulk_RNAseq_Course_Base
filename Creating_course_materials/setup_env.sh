# activate conda environment
conda activate bulkRNAseq_build

# Export variables
export matDir=`readlink -f materials_build`
export salRefDir=${matDir}/salmon_ref/
export quantDir=${matDir}/salmon_results
