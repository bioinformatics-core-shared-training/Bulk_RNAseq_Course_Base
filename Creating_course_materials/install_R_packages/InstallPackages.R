#!/usr/bin/env Rscript

library(purrr)
library(stringr)

# Install the package but exit with error if the package install
# fails.

installPackage <- function(pkg) {
    message("Attempting to install package ", pkg)
    status <- tryCatch({
        BiocManager::install(pkg, ask = FALSE)
        status <- "success"
    }, error = function(e) {
        message("ERROR: FAILED TO INSTALL PACKAGE ", pkg)
        message(conditionMessage(e))
        return("FAILED")
    })
    message("----------------------------------------\n")
    str_c(pkg, ": ", status)
}

# Read the list of packages from the file and loop through
packages <- read_lines("Packages.txt")

# Remove any that are already installed
pkgs <- setdiff(packages, rownames(installed.packages()))

# Loop through and install each package
map_chr(pkgs, installPackage)

