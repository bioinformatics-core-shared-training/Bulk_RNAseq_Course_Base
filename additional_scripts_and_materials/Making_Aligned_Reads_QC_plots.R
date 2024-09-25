library(tidyverse)

# Insert size

read_tsv("metrics/SRR7657872.insert_size.txt", skip = 10) %>%  
    ggplot(aes(x = insert_size, y = All_Reads.fr_count)) +
        geom_line(col = "#6427A3") +
        labs(x = "Insert Size (nucleotides)", y = "Read count")  
ggsave("images/Insert_Size.svg", width = 8, height=3)


# Genomic locations

list.files("metrics", pattern="RNA_metrics", full.n = TRUE)[1:2] %>% 
  map_dfr(read_tsv, comment="#", n_max = 1) %>%
  mutate(Sample=str_c("Sample ", LETTERS[row_number()])) %>%  
  select(Sample, Coding=PCT_CODING_BASES, UTR=PCT_UTR_BASES, Intronic=PCT_INTRONIC_BASES,
         Intergenic=PCT_INTERGENIC_BASES) %>% 
  pivot_longer(names_to = "Location", values_to = "Percentage", -Sample) %>% 
  mutate(Location=fct_relevel(Location, c("Intergenic", "Intronic", "UTR"))) %>% 
  ggplot(aes(x=Sample, y=Percentage)) +
      geom_col(aes(fill=Location), colour="black") +
      labs(fill="", x="") +
      coord_flip() +
      theme(legend.position="bottom")

ggsave("images/GenomicLocations.svg", width = 10, height=3)


# Transcript coverage

list.files("metrics", pattern="3.RNA_metrics", full.n = TRUE) %>% 
  map_dfr(read_tsv, skip=10, .id = "FILE", comment = "#") %>%
  mutate(Sample=str_c("Sample ", LETTERS[as.numeric(FILE)])) %>%  
  ggplot(aes(x=normalized_position, y=All_Reads.normalized_coverage)) +
      geom_line(aes(colour=Sample)) +
      labs(colour="", x="Normalised Position", y="Normalized Coverage") +
      theme(legend.position="bottom")

ggsave("images/TranscriptCoverage.svg", width = 8, height=5)
