# Introduction to Bulk RNA-seq data analysis 
### 30th June - 2nd July 2021
#### Taught remotely
#### Bioinformatics Training, Craik-Marshall Building, Downing Site, University of Cambridge

![](images/CRUK_Cambridge_Major_Centre_logo.jpg)

## Instructors

* Abigail Edwards - Bioinformatics Core, Cancer Research UK Cambridge Institute
* Ashley D Sawle - Bioinformatics Core, Cancer Research UK Cambridge Institute
* Chandra Chilamakuri - Bioinformatics Core, Cancer Research UK Cambridge Institute
* Jon Price - Miska Group, Gurdon Institute, Cambridge
* Stephane Ballereau - Bioinformatics Core, Cancer Research UK Cambridge Institute
* Zeynep Kalender Atak - Miller Group, Cancer Research UK Cambridge Institute
* Hugo Tavares - Bioinformatics Training Facility, Dept of Genetics


## Outline

In this workshop, you will be learning how to analyse RNA-seq data. This will
include read alignment, quality control, quantification against a reference,
reading the count data into R, performing differential expression analysis, and
gene set testing, with a focus on the DESeq2 analysis workflow. You will learn
how to generate common plots for analysis and visualisation of gene expression
data, such as boxplots and heatmaps. 

This workshop is aimed at biologists interested in learning how to perform
differential expression analysis of RNA-seq data. 

Whilst we have run this course for several years, we are still learning how to
teach it remotely.  Please bear with us if there are any technical hitches, and
be aware that timings for different sections laid out in the schedule below may
not be adhered to. There may be some necessity to make adjusments to the course
as we go.

> ## Prerequisites
>
> __**Some basic experience of using a UNIX/LINUX command line is assumed**__
> 
> __**Some R knowledge is assumed and essential. Without it, you
> will struggle on this course.**__ 
> If you are not familiar with the R statistical programming language we
> strongly encourage you to work through an introductory R course before
> attempting these materials.
> We recommend our [Introduction to R course](https://bioinformatics-core-shared-training.github.io/r-intro/)

## Shared Google Document

This 
<a href="https://docs.google.com/document/d/1OQ0GX1f2tgmT1_BqLK2SW63PuKpQy4kOl5CSo4v2FCY/edit#" target="_blank">Google Document</a> contains useful information and links.. 

Please use it to post any questions you have during the course.

The trainers will be monitoring the document and will answer questions as quickly
as they can.

## Introduce Yourself

There is another Google Doc 
<a href="https://docs.google.com/document/d/120QckTIzI5dFU2Bi5zngmiC3cnxaCYyPwGq8WX7CMIw/edit?usp=sharing" target="_blank">here</a>. 
Please write a couple sentences here to introduce yourself to the class, tell
us a bit about your background and what you hope to get out of this course.  If
you are a student or staff at the University of Cambridge, tell us which
Department you are in.


## Course etiquette

As this course is being taught online and there are a large number of participants,
we will all need to follow a [few simple rules](https://docs.google.com/presentation/d/e/2PACX-1vQv9nTlsdRC9iZJU138tLL1jrwNoryp8P-FnXxb_ugOOWjbav4QHTLYLLZj2KK4kTO0_3x3VlzSdrUu/pub?start=false&loop=false&delayms=3000) to ensure things run as smoothly as possible:

1. Please mute your microphone

2. To get help from a tutor, please click the "Raise Hand" button in Zoom:

    ![](images/raise_hand.png)
   
   This can be found by clicking on the 'Participants' button. A tutor will
   then contact you in the chat. If necessary, you and the tutor can be moved
   to a breakout room where you can discuss your issue in more detail.

3. Please ask any general question by typing it into the Google Doc mentioned above

4. During practicals, when you are done, please press the green "Yes" button: 
    
    ![](images/yes_button.png)

   This way we will know when we can move on.

## Timetable

**We are still learning how to teach this course remotely, all times here should be
regarded as aspirations**

### Day 1

9:30 - 9:45 - Welcome! <!-- Abbi -->

9:45 - 10:15 - [Introduction to RNAseq 
Methods](Markdowns/01_Introduction_to_RNAseq_Methods.html) - Zeynep Kalender Atak

10:15 - 11:15 [Raw read file format and 
QC](Markdowns/02_FastQC_introduction.html)  - Zeynep Kalender Atak  
    - [Practical](Markdowns/02_FastQC_practical.html) ([pdf](Markdowns/02_FastQC_practical.pdf))   
    - [Practical solutions](Markdowns/02_FastQC_practical.Solutions.html) ([pdf](Markdowns/02_FastQC_practical.Solutions.pdf))   

11:15 - 12:45 [Short read alignment with 
HISAT2](Markdowns/03_Alignment_with_HISAT2_introduction.html) - Jon Price  
    - [Practical](Markdowns/03_Alignment_with_HISAT2_practical.html)  ([pdf](Markdowns/03_Alignment_with_HISAT2_practical.pdf))    
    - [Practical solutions](Markdowns/03_Alignment_with_HISAT2_practical.Solutions.html) ([pdf](Markdowns/03_Alignment_with_HISAT2_practical.Solutions.pdf))  

12:45 - 13:45 Lunch

13:45 - 15:30 [QC of alignment](Markdowns/04_QC_of_aligned_reads_introduction.html) - Jon Price  
    - [Practical](Markdowns/04_QC_of_aligned_reads_practical.html) ([pdf](Markdowns/04_QC_of_aligned_reads_practical.pdf))  
    - [Practical solutions](Markdowns/04_QC_of_aligned_reads_practical.Solutions.html) ([pdf](Markdowns/04_QC_of_aligned_reads_practical.Solutions.pdf))

15:30 - 17:00 [Quantification of Gene Expression with Salmon](Markdowns/05_Quantification_with_Salmon_introduction.html) - Ashley Sawle  
    - [Practical](Markdowns/05_Quantification_with_Salmon_practical.html)  ([pdf](Markdowns/05_Quantification_with_Salmon_practical.pdf))  
    - [Practical solutions](Markdowns/05_Quantification_with_Salmon_practical.Solutions.html) ([pdf](Markdowns/05_Quantification_with_Salmon_practical.Solutions.pdf))

### Day 2

9:30 - 10:15  [Introduction to RNAseq Analysis in 
R](Markdowns/06_Introduction_to_RNAseq_Analysis_in_R.html) - Ashley Sawle  

10:15 - 12:15 - [RNA-seq 
Data Exploration](Markdowns/07_Data_Exploration.html) ([pdf](Markdowns/07_Data_Exploration.pdf)) - Ashley Sawle   
    - [Practical solutions](Markdowns/07_Data_Exploration.Solutions.html) ([pdf](Markdowns/07_Data_Exploration.Solutions.pdf))   
    - [Ashley's Live Script](live_scripts/Data_Exploration.R)

12:15 - 13:15 Lunch

13:15 - 15:45 Statistical Analysis of Bulk RNAseq Data

- Part I: [Statistics of RNA-seq analysis](Markdowns/08_Stats.pdf) - Zeynep Kalender Atak  
- Part II: [Linear Models in R and DESeq2](Markdowns/09_Linear_Models.html) ([pdf](Markdowns/09_Linear_Models.pdf)) - Hugo Tavares  
    - [Slides](https://docs.google.com/presentation/d/1FTP_gdOQ7sBQWZqTbkB97uUzZ57O9FTyVTgfQrqHPeg/edit?usp=sharing) ([live blackboard used during lecture](https://jamboard.google.com/d/1g2M7x_y91n9C35I3DzEPucX3nJexmqXPz8ail3cjLSs/edit?usp=sharing))
    - Find the worksheet in `Course_Materials/stats/models_in_r_worksheet.R`


15:45 - 17:00 [Experimental Design of Bulk RNAseq studies](additional_scripts_and_materials/ExperimentalDesignCourse_Edwards_23-03-2021.pptx) - Abbi Edwards    
    - [Practical](additional_scripts_and_materials/RNAseq_ExperimentalDesignPractical.pdf)    
    - [Answers](additional_scripts_and_materials/RNAseq_ExperimentalDesignPractical_Answers.pdf)

### Day 3

9:30 - 12:15 - [Differential Expression for RNA-seq](Markdowns/10_DE_analysis_with_DESeq2.html) ([pdf](Markdowns/10_DE_analysis_with_DESeq2.pdf)) - Chandra Chilamakuri   
     - [practical solutions](Markdowns/10_DE_analysis_with_DESeq2.Solutions.html) ([pdf](Markdowns/10_DE_analysis_with_DESeq2.Solutions.html))  
   <!-- - [Chandra's Live Script](live_scripts/day3_DESeq2_session_v1.0.R) -->
 
12:15 - 13:15 Lunch

13:15 - 15:30 [Annotation and Visualisation of RNA-seq
results](Markdowns/11_Annotation_and_Visualisation.html) ([pdf](Markdowns/11_Annotation_and_Visualisation.pdf)) - Abbi Edwards    
    - [practical solutions](Markdowns/11_Annotation_and_Visualisation_Solutions.html)  
    - [Abbi's Live Script](live_scripts/liveScript_AandV.R)

15:30 - 17:00 [Gene-set testing](Markdowns/12_Gene_set_testing_introduction.html) - Stephane Ballereau    
   - [Practical (html)](Markdowns/12_Gene_set_testing.html) [(rmd)](Markdowns/12_Gene_set_testing.Rmd) [(pdf)](Markdowns/12_Gene_set_testing.pdf)
   - [Practical solutions (html)](12_Gene_set_testing.Solutions.html) [(rmd)](Markdowns/12_Gene_set_testing.Solutions.Rmd) [(pdf)](Markdowns/12_Gene_set_testing.Solutions.pdf)

<!-- Goodbye: Abbi -->

## Source Materials for Practicals

The lecture slides and other source materials, including R code and 
practical solutions, can be found in the course's [Github 
repository](https://github.com/bioinformatics-core-shared-training/Bulk_RNAseq_Course_2021)

## Extended materials

The [Extended Materials](Extended_index.md) contain extensions to some of the
sessions and additional materials, including instruction on downloading and
processing the raw data for this course, a link to an excellent R course, and
where to get further help after the course.

## Additional Resources

* [Bioconductor for relevant R packages](https://bioconductor.org/)
* [DESeq2 Vignette](https://bioconductor.org/packages/release/bioc/vignettes/DESeq2/inst/doc/DESeq2.html)  
* [RNAseq Workflow](http://master.bioconductor.org/packages/release/workflows/vignettes/rnaseqGene/inst/doc/rnaseqGene.html)  
* [RStudio CheatSheets](https://rstudio.com/resources/cheatsheets/)

## Acknowledgements

This course is based on the course [RNAseq analysis in
R](http://combine-australia.github.io/2016-05-11-RNAseq/) prepared by [Combine
Australia](https://combine.org.au/) and delivered on May 11/12th 2016 in
Carlton. We are extremely grateful to the authors for making their materials
available; Maria Doyle, Belinda Phipson, Matt Ritchie, Anna Trigos, Harriet
Dashnow, Charity Law.

![](images/combine_banner_small.png)

The materials have been rewritten/modified/corrected/updated by various
contributors over the past 5 years including:

Abigail Edwards
Ashley D Sawle
Chandra Chilamakuri
Dominique-Laurent Couturier
Guillermo Parada González
Hugo Tavares
Jon Price
Mark Dunning
Mark Fernandes
Oscar Rueda
Sankari Nagarajan
Stephane Ballereau
Zeynep Kalender Atak

Apologies if we have missed anyone!
