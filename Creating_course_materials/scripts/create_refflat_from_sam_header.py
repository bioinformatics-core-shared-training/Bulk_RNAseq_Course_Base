#!/usr/bin/env python

from optparse import OptionParser
import sys
import subprocess

parser = OptionParser()
# Basic Input Files, required
parser.add_option("-b", "--bam", dest="BAMfile",help="input BAM file", metavar="BAMfile")
parser.add_option("-o", "--output", dest="OutputFileName",help="user specified name of file for output to be written", metavar="OutputFileName")

(options, args) = parser.parse_args()

#open input and output files
BamFile=str(options.BAMfile)
OutFile=open(options.OutputFileName,'w')


cmd = "samtools view -H " + BamFile
header = subprocess.check_output(cmd, shell=True).decode('utf-8').split('\n')

for line in header:
    fields = line.rstrip().split("\t")
    if len(fields) == 4 and fields[0] == "@SQ" and fields[3] == "DS:T":
        transcript = fields[1].lstrip("SN:")
        length = int(fields[2].lstrip("LN:"))
        fields = [transcript, transcript, transcript, "+", 0, length, 0, length, 1, 0, length]
        fields = [str(x) for x in fields]
        newline = "\t".join(fields)
        OutFile.write(newline + '\n')

