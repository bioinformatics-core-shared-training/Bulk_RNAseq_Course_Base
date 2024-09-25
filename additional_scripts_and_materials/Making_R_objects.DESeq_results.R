library(DESeq2)
library(tidyverse)

# Make DESeq object

txi <- readRDS("RObjects/txi.rds")
sampleinfo <- read_tsv("data/samplesheet_corrected.tsv", col_types="cccc") %>% 
    mutate(Status = fct_relevel(Status, "Uninfected"))


interaction.model <- as.formula(~ TimePoint * Status)
ddsObj.raw <- DESeqDataSetFromTximport(txi = txi,
                                        colData = sampleinfo,
                                        design = interaction.model)

keep <- rowSums(counts(ddsObj.raw)) > 5
ddsObj.filt <- ddsObj.raw[keep,]

ddsObj.interaction <- DESeq(ddsObj.filt)

# Results objects

results.interaction.11 <- results(ddsObj.interaction, 
                                  name="Status_Infected_vs_Uninfected",
                                  alpha=0.05)
results.interaction.33 <- results(ddsObj.interaction, 
                                  contrast = list(c("Status_Infected_vs_Uninfected", 
                                                    "TimePointd33.StatusInfected")),
                                  alpha=0.05)

saveRDS(ddsObj.interaction, "RObjects/DESeqDataSet.interaction.rds")
saveRDS(results.interaction.11, "RObjects/DESeqResults.interaction_d11.rds")
saveRDS(results.interaction.33, "RObjects/DESeqResults.interaction_d33.rds")

# Annotation of results

ensemblAnnot <- readRDS("RObjects/Ensembl_annotations.rds")

# as.data.frame(results.interaction.11) %>% 
#     rownames_to_column("GeneID") %>% 
#     left_join(ensemblAnnot, "GeneID") %>% 
#     rename(logFC=log2FoldChange, FDR=padj) %>% 
#     saveRDS(file="RObjects/Annotated_Results.d11.rds")
# 
# as.data.frame(results.interaction.33) %>% 
#     rownames_to_column("GeneID") %>% 
#     left_join(ensemblAnnot, "GeneID") %>% 
#     rename(logFC=log2FoldChange, FDR=padj) %>% 
#     saveRDS(file="RObjects/Annotated_Results.d33.rds")

# Shrunk tables

lfcShrink(ddsObj.interaction, 
          res = results.interaction.11,
          type = "ashr") %>% 
    as.data.frame() %>%
    rownames_to_column("GeneID") %>% 
    left_join(ensemblAnnot, "GeneID") %>% 
    rename(logFC=log2FoldChange, FDR=padj) %>% 
    saveRDS(file="RObjects/Shrunk_Results.d11.rds")

lfcShrink(ddsObj.interaction, 
                          res = results.interaction.33,
                          type = "ashr") %>% 
    as.data.frame() %>%
    rownames_to_column("GeneID") %>% 
    left_join(ensemblAnnot, "GeneID") %>% 
    rename(logFC=log2FoldChange, FDR=padj) %>% 
    saveRDS(file="RObjects/Shrunk_Results.d33.rds")

