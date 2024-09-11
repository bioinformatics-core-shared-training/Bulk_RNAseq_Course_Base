library(tidyverse)

set.seed(76320)

newSample <- c("SRR7657893")

# make a fake aligment metrics file
# randomly choose a read depth, set alignment rate, NA everything else

makeFakeAlnMtr <- function(newSamID, ratAln = 1){
    srcFile <- "metrics/SRR7657883.alignment_metrics.txt"
    orig <- read_lines(srcFile) %>%  
        str_replace_all("SRR[0-9]+", newSamID)

    # random sample nReads (range is from the real data)
    mx <- 39267241
    mn <- 28009077
    nReads <- round(runif(1, mn, mx), 0)

    # set new metrics
    newDat <- read_tsv(srcFile, comment = "#", n_max = 3, col_types = cols()) %>%  
        mutate(TOTAL_READS = case_when(
                                       CATEGORY=="PAIR" ~ 2 * nReads,
                                       TRUE ~ nReads)) %>%  
        mutate(PF_READS = TOTAL_READS) %>%  
        mutate(PF_READS_ALIGNED = round(PF_READS * ratAln, 0)) %>%  
        mutate(PCT_PF_READS_ALIGNED = round(PF_READS_ALIGNED / PF_READS, 5)) %>%  
        mutate(across(PF_ALIGNED_BASES:READ_GROUP, function(x){x <-  NA})) 

    ## reduce the alignment rate
    outNam <- str_c("metrics/", newSamID, ".alignment_metrics.txt") 
    wrnMsg <-"# This is a fake metrics file for the sake of having some bad QC"
    write_lines(c(orig[1:4], wrnMsg, orig[5:7]), outNam)
    write_tsv(newDat, outNam, append = TRUE)
    write_lines(orig[-(1:10)], outNam, append = TRUE)
}

# make a fake insert size metrics file
# adjust the counts according to alignment Rate in the fake aln metrics file
# Then if desired squeeze the curve to give a new median

makeFakeInsSize <- function(newSamID, newMedian = NA){
    srcFile <- "metrics/SRR7657883.insert_size.txt"
    alnFile <- str_c("metrics/", newSamID, ".alignment_metrics.txt") 

    alnNReads <- read_tsv(alnFile, comment = "#", n_max = 1, col_types = cols()) %>%  
        pull(PF_READS_ALIGNED)

    # set new metrics
    dat <- read_tsv(srcFile, comment = "#", n_max = 1, col_types = cols()) 
    nReads <- pull(dat, READ_PAIRS)
    newDat <- dat %>%  
        mutate(READ_PAIRS = alnNReads) 

    # set new histogram
    alnRat <- alnNReads / nReads
    newHist <- read_tsv(srcFile, skip = 10, col_types = cols()) %>%  
        mutate(All_Reads.fr_count = round(All_Reads.fr_count * alnRat, 0))

    if(!is.na(newMedian)){
        medianSize <- pull(newDat, MEDIAN_INSERT_SIZE)
        medianRatio = newMedian / medianSize
        minSize <- pull(newDat, MIN_INSERT_SIZE)
        newDat <- newDat  %>%  
            mutate(MEDIAN_INSERT_SIZE = newMedian)  %>%  
            mutate(MODE_INSERT_SIZE = round(medianRatio * MODE_INSERT_SIZE, 0))
        totalReads <- sum(newHist$All_Reads.fr_count)
        squeeHist <- newHist %>%  
            mutate(insert_size = round(((insert_size - minSize) * medianRatio) + minSize)) %>%  
            group_by(insert_size) %>%  
            summarise(across(All_Reads.fr_count, mean)) %>%  
            ungroup() %>%  
            mutate(NewReads = round(All_Reads.fr_count * totalReads / 
                                        sum(All_Reads.fr_count), 
                                    0)) %>%  
            select(insert_size, All_Reads.fr_count = NewReads) 
        lastVal <- tail(squeeHist$All_Reads.fr_count, n = 1)
        tailHist <- filter(newHist, !insert_size%in%squeeHist$insert_size) %>%  
            mutate(All_Reads.fr_count = 
                       All_Reads.fr_count * lastVal / max(All_Reads.fr_count)) %>%  
            mutate(All_Reads.fr_count = round(All_Reads.fr_count, 0))
        newHist <- bind_rows(squeeHist, tailHist)
    }

    # get the original file
    orig <- read_lines(srcFile) %>%  
        str_replace_all("SRR[0-9]+", newSamID)

    # output new file
    outNam <- str_c("metrics/", newSamID, ".insert_size.txt") 
    wrnMsg <-"# This is a fake metrics file for the sake of having some bad QC"
    write_lines(c(orig[1:4], wrnMsg, orig[5:7]), outNam)
    write_tsv(newDat, outNam, append = TRUE)
    write_lines(orig[9:11], outNam, append = TRUE)
    write_tsv(newHist, outNam, append = TRUE)
}

# make a fake mark duplicates metrics file
# adjust the counts and aligned according to alignment Rate in the fake aln metrics file
# Based unpaired aligned and duplicate rates on SRRxxxx83
# Adjust duplicate pairs by 

makeFakeMkDup <- function(newSamID, newDup){
    alnFile <- str_c("metrics/", newSamID, ".alignment_metrics.txt") 
    aln <- read_tsv(alnFile, comment = "#", n_max = 3, col_types = cols()) %>%  
                filter(CATEGORY=="PAIR") %>%  
                select(xTotal = TOTAL_READS, xAligned = PF_READS_ALIGNED)

    # set new metrics
    newDat <- tibble(LIBRARY = "Unknown Library") %>%
              bind_cols(aln) %>%   
              mutate(UNPAIRED_READS_EXAMINED  = round(xAligned * 0.0347591875048028, 0))   %>%  
              mutate(READ_PAIRS_EXAMINED = round((xAligned - UNPAIRED_READS_EXAMINED) / 2, 0)) %>%  
              mutate(SECONDARY_OR_SUPPLEMENTARY_RDS = NA) %>%   
              mutate(UNMAPPED_READS = xTotal - xAligned) %>%  
              mutate(UNPAIRED_READ_DUPLICATES = 
                        round(0.701727659188212 * UNPAIRED_READS_EXAMINED, 0)) %>%   
              mutate(xPairedDups = newDup * xAligned) %>%  
              mutate(xPairedDups = xPairedDups - UNPAIRED_READ_DUPLICATES) %>%  
              mutate(READ_PAIR_DUPLICATES = round(xPairedDups / 2, 0)) %>%  
              mutate(READ_PAIR_OPTICAL_DUPLICATES = 0) %>% 
              mutate(PERCENT_DUPLICATION  = newDup) %>%  
              mutate(ESTIMATED_LIBRARY_SIZE = NA) %>%  
              select(-starts_with("x"))

            
    # get the original file
    srcFile <- "metrics/SRR7657883.mkdup_metrics.txt"
    orig <- read_lines(srcFile) %>%  
        str_replace_all("SRR[0-9]+", newSamID)

    # output new file
    outNam <- str_c("metrics/", newSamID, ".mkdup_metrics.txt") 
    wrnMsg <-"# This is a fake metrics file for the sake of having some bad QC"
    write_lines(c(orig[1:4], wrnMsg, orig[5:7]), outNam)
    write_tsv(newDat, outNam, append = TRUE)
    write_lines(orig[-(1:8)], outNam, append = TRUE)
}

# make a fake RNAseq metrics file
# adjust the counts and aligned according to alignment Rate in the fake aln metrics file
# to make the bad coverage stats, just copy the data from the old example

getRNAseqProportions <- function(){
    list.files("metrics", pattern = "[78]..RNA", full.names = TRUE) %>%  
        map_dfr(read_tsv, comment = "#", n_max = 1, col_types = cols()) %>%  
        select(starts_with("PCT")) %>%  
        rename_all(~(str_remove_all(.x, "PCT_|_BASES") %>%
                     str_to_title())) %>%  
        select(Coding, UTR = Utr, Intronic, Intergenic) %>%  
        pivot_longer(names_to = "Region", values_to = "perc", everything()) %>%  
        group_by(Region) %>%  
        summarise(Mean = mean(perc), SD = sd(perc)) %>%  
        mutate(newPerc = map2_dbl(Mean, SD, ~rnorm(1, mean = .x, sd = .y))) %>%  
        select(Region, newPerc) %>%  
        deframe() %>%  
        as.list()
}


makeFakeRNAseqMtr <- function(newSamID, badCoverage){
    alnFile <- str_c("metrics/", newSamID, ".alignment_metrics.txt") 
    alnDat <- read_tsv(alnFile, comment = "#", n_max = 3, col_types = cols()) %>%  
        filter(CATEGORY=="PAIR") %>%  
        mutate(PF_BASES = TOTAL_READS * 150) %>%  
        mutate(PF_ALIGNED_BASES = PF_READS_ALIGNED * 150) %>% 
        select(PF_BASES, PF_ALIGNED_BASES)

    rnaParams <- getRNAseqProportions()

    newDat <- str_c("metrics/SRR7657883.RNA_metrics.txt")  %>%  
              read_tsv(comment = "#", n_max = 1, col_types = cols()) %>%  
              slice(0) %>%  
              bind_rows(alnDat) %>%  
              mutate(CODING_BASES = round(PF_ALIGNED_BASES * rnaParams$Coding, 0)) %>%  
              mutate(UTR_BASES = round(PF_ALIGNED_BASES * rnaParams$UTR, 0)) %>%  
              mutate(INTRONIC_BASES = round(PF_ALIGNED_BASES * rnaParams$Intronic, 0)) %>%  
              mutate(INTERGENIC_BASES = round(PF_ALIGNED_BASES * rnaParams$Intergenic, 0)) %>%  
              mutate(PCT_RIBOSOMAL_BASES = "")   %>%  
              mutate(PCT_CODING_BASES = round(rnaParams$Coding, 6)) %>%  
              mutate(PCT_UTR_BASES = round(rnaParams$UTR, 6)) %>%  
              mutate(PCT_INTRONIC_BASES = round(rnaParams$Intronic, 6)) %>%  
              mutate(PCT_INTERGENIC_BASES = round(rnaParams$Intergenic, 6))   %>%  
              mutate(PCT_MRNA_BASES = PCT_CODING_BASES + PCT_UTR_BASES)   %>%  
              mutate(CORRECT_STRAND_READS = 0) %>%  
              mutate(INCORRECT_STRAND_READS = 0)

    srcFile <- "metrics/SRR7657883.RNA_metrics.txt"
    if(badCoverage){
        covDat <- read_tsv("coverage_bias_example.RNA_metrics.txt",
                           skip = 10,
                           col_types = cols())
    }else{
        covDat <- read_tsv(srcFile, skip = 10, col_types = cols())
    }
                
    # get the original file
    orig <- read_lines(srcFile) %>%  
        str_replace_all("SRR[0-9]+", newSamID)

    # output new file
    outNam <- str_c("metrics/", newSamID, ".RNA_metrics.txt") 
    wrnMsg <-"# This is a fake metrics file for the sake of having some bad QC"
    write_lines(c(orig[1:4], wrnMsg, orig[5:7]), outNam)
    write_tsv(newDat, outNam, append = TRUE)
    write_lines(orig[9:11], outNam, append = TRUE)
    write_tsv(covDat, outNam, append = TRUE)
}

# walk2(newSamples, c(0.87, 0.43, 0.93), makeFakeAlnMtr)
# walk2(newSamples, c(NA, 120, NA), makeFakeInsSize)
# walk2(newSamples, c(0.234435, 0.212121, 0.823125), makeFakeMkDup)
# walk2(newSamples, c(TRUE, FALSE, FALSE), makeFakeRNAseqMtr)

makeFakeAlnMtr(newSample, 0.43)
makeFakeInsSize(newSample, 120)
# we have decided not to include a sample with excess duplication
makeFakeMkDup(newSample, 0.23534)
makeFakeRNAseqMtr(newSample, TRUE)


