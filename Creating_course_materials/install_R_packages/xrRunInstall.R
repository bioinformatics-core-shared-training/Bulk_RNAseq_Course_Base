#!/usr/bin/env Rscript
library(tidyverse)

# log file
timenow <- str_replace_all(as.character(Sys.time()), " ", "_") %>% 
    str_remove_all(":|\\.[0-9]+$")

filename <- str_c("PackageInstallation_", timenow, ".log")

con <- file(filename)
sink(con, append = TRUE)
sink(con, append = TRUE, type = "message")

# This will echo all input and not truncate 150+ character lines...
source("InstallPackages.R", echo = TRUE, max.deparse.length = 10000)