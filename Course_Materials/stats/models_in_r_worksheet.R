# ==== Worksheet for Linear Models Section ==== #

# load packages
library(DESeq2)
library(tidyverse)


# Model Specification - Formula Syntax ------------------------------------

# create example data
example_samples <- tibble(
  sample = paste0("sample", 1:6),
  treatment = rep(c("A", "B"), each = 3)
)
example_samples

# define a model formula
treatment_model <- ~ treatment

# model matrix - creates indicator variables for us
model.matrix(treatment_model, data = example_samples)



# Exercise 2 --------------------------------------------------------------


# Use read_tsv() to read table in "data/samplesheet_corrected.tsv"
# Store it in an object called sample_info
sample_info <- read_tsv("data/samplesheet_corrected.tsv")

# Create a model formula to investigate the effect of “Status” on gene expression.


# Look at the model matrix and identify which is the reference group in the model.




# Exercise 3 --------------------------------------------------------------


# Using sample_info, create a new design formula specifying an additive model
# between “Status” and “TimePoint”.


# How many coefficients do you have with this model?


# What is your reference group?



