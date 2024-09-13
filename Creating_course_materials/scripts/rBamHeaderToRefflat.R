#!/usr/bin/env Rscript
suppressPackageStartupMessages(library(optparse))
suppressPackageStartupMessages(library(Rsamtools))
suppressPackageStartupMessages(library(tidyverse))

parser <- OptionParser()
parser <- add_option(parser, c("-b", "--bam"), type="character",
                     help="Path to input bam file")

parser <- add_option(parser, c("-o", "--output"), type="character",
                     help="Path/name for output Refflat file")

parse_args(parser) %>%
    list2env(envir = globalenv())

message("Bam file: ", bam)
message("Output file: ", output)

scanBamHeader(bam, what = "targets") %>%
    pluck(1) %>%
    pluck("targets") %>%
    enframe(name = "TX", value = "LEN") %>%
    filter(str_detect(TX, "ENS")) %>%
    mutate(STRAND = "+") %>%
    mutate(START = 0) %>%
    mutate(nEXONS = 1) %>%
    select(geneName   = TX,
           name       = TX,
           chrom      = TX,
           strand     = STRAND,
           txStart    = START,
           txEnd      = LEN,
           cdsStart   = START,
           cdsEnd     = LEN,
           exonCount  = nEXONS,
           exonStarts = START,
           exonEnds   = LEN) %>%
    write_tsv(output, col_names = FALSE)

