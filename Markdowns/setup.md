---
title: "Introduction to Bulk RNAseq data analysis"
subtitle: "Software Setup"
output:
  html_document:
    toc: yes
    toc_float: true
    css: ../css/boxes.css
---

:::note
**Workshop Attendees**

If you are attending one of our workshops, we will provide a training environment with all of the required software and data. 
There is no need for you to set anything up in advance. 
 
These instructions are for those who would like setup their own computer to run the analysis demonstrated on the materials.
:::

There are two groups of software tools that we used in the workshop: 

- Command line software - runs on _Linux_ operating system.
- R packages - can be used on any operating system. 

We start by giving instructions on how to get a _Linux_ distribution on your computer. 
However, we note that the command line steps are often computationally heavy and not suitable to be run on a standard laptop. 
Our recommendation would be to perform those steps on a HPC cluster.  
The R analysis are typically fine on a standard laptop. 


## Linux installation {.tabset}

### Ubuntu

The recommendation for bioinformatic analysis is to have a dedicated computer running a _Linux_ distribution. 
The kind of distribution you choose is not critical, but we recommend **Ubuntu** if you are unsure.

You can follow the [installation tutorial on the Ubuntu webpage](https://ubuntu.com/tutorials/install-ubuntu-desktop#1-overview). 

:::warning
Installing Ubuntu on the computer will remove any other operating system you had previously installed, and can lead to data loss. 
:::

### Windows WSL

The **Windows Subsystem for Linux (WSL2)** runs a compiled version of Ubuntu natively on Windows. 

There are detailed instructions on how to install WSL on the [Microsoft documentation page](https://learn.microsoft.com/en-us/windows/wsl/install). 
But briefly:

- Click the Windows key and search for  _Windows PowerShell_, right-click on the app and choose **Run as administrator**. 
- Answer "Yes" when it asks if you want the App to make changes on your computer. 
- A terminal will open; run the command: `wsl --install`. 
  - This should start installing "ubuntu". 
  - It may ask for you to restart your computer. 
- After restart, click the Windows key and search for _Ubuntu_, click on the App and it should open a new terminal. 
- Follow the instructions to create a username and password (you can use the same username and password that you have on Windows, or a different one - it's your choice). 
- You should now have access to a Ubuntu Linux terminal. 
  This (mostly) behaves like a regular Ubuntu terminal, and you can install apps using the `sudo apt install` command as usual. 

After WSL is installed, it is useful to create shortcuts to your files on Windows. 
Your `C:\` drive is located in `/mnt/c/` (equally, other drives will be available based on their letter). 
For example, your desktop will be located in: `/mnt/c/Users/<WINDOWS USERNAME>/Desktop/`. 
It may be convenient to set shortcuts to commonly-used directories, which you can do using _symbolic links_, for example: 

- **Documents:** `ln -s /mnt/c/Users/<WINDOWS USERNAME>/Documents/ ~/Documents`
  - If you use OneDrive to save your documents, use: `ln -s /mnt/c/Users/<WINDOWS USERNAME>/OneDrive/Documents/ ~/Documents`
- **Desktop:** `ln -s /mnt/c/Users/<WINDOWS USERNAME>/Desktop/ ~/Desktop`
- **Downloads**: `ln -s /mnt/c/Users/<WINDOWS USERNAME>/Downloads/ ~/Downloads`

### Virtual machine

Another way to run Linux within Windows (or macOS) is to install a Virtual Machine.
However, this is mostly suitable for practicing and **not suitable for real data analysis**.

Detailed instructions to install an Ubuntu VM using Oracle's Virtual Box is available from the [Ubuntu documentation page](https://ubuntu.com/tutorials/how-to-run-ubuntu-desktop-on-a-virtual-machine-using-virtualbox#1-overview).

**Note:** In the step configuring "Virtual Hard Disk" make sure to assign a large storage partition (at least 100GB).


## Update Ubuntu

After installing Ubuntu (through either of the methods above), open a terminal and run the following commands to update your system and install some essential packages: 

```bash
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
sudo apt install -y git
sudo apt install -y default-jre
```


## Conda/Mamba

We recommend using the _Conda_ package manager to install the command line software. 
In particular, the newest implementation called _Mamba_. 

To install _Mamba_, run the following commands from the terminal: 

```bash
wget "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-$(uname)-$(uname -m).sh"
bash Mambaforge-$(uname)-$(uname -m).sh -b
rm Mambaforge-$(uname)-$(uname -m).sh
```

Restart your terminal (or open a new one) and confirm that your shell now starts with the word `(base)`.
Then run the following commands: 

```bash
conda config --add channels defaults; conda config --add channels bioconda; conda config --add channels conda-forge
conda config --set remote_read_timeout_secs 1000
```


## Command line software

The **command line software** used in data pre-processing can be installed using the `mamba` package manager. 

```bash
mamba create --name rnaseq
mamba install --name rnaseq picard salmon fastqc
```


## R and RStudio {.tabset}

### Windows

Download and install all these using default options:

- [R](https://cran.r-project.org/bin/windows/base/release.html)
- [RTools](https://cran.r-project.org/bin/windows/Rtools/)
- [RStudio](https://www.rstudio.com/products/rstudio/download/#download)

### Mac OS

Download and install all these using default options:

- [R](https://cran.r-project.org/bin/macosx/)
- [RStudio](https://www.rstudio.com/products/rstudio/download/#download)

### Linux

- Go to the [R installation](https://cran.r-project.org/bin/linux/) folder and look at the instructions for your distribution.
- Download the [RStudio](https://www.rstudio.com/products/rstudio/download/#download) installer for your distribution and install it using your package manager.


## R packages

The **R packages** used in this course can be installed with the following commands from an R console:

```r
if (!require("BiocManager", quietly = TRUE)){
  install.packages("BiocManager")
}
    
BiocManager::install(c("AnnotationDbi", 
                       "AnnotationHub", 
                       "ComplexHeatmap", 
                       "DESeq2", 
                       "DT", 
                       "GenomicAlignments", 
                       "GenomicFeatures", 
                       "GenomicRanges", 
                       "Glimma", 
                       "biomaRt", 
                       "circlize", 
                       "clusterProfiler",
                       "corrplot", 
                       "enrichplot", 
                       "ensembldb", 
                       "gganimate", 
                       "ggbio", 
                       "ggdendro", 
                       "ggfortify", 
                       "ggrepel", 
                       "ggvenn", 
                       "msigdbr", 
                       "org.Mm.eg.db", 
                       "patchwork", 
                       "pathview", 
                       "rtracklayer", 
                       "shape", 
                       "tidyverse", 
                       "tximport"))
```
