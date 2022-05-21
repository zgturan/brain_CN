#!/bin/sh

QC()
{
direct=$1
fastqdir=$2

cd $direct
for i in `cat file_name.txt`
do
  echo $i
  ## Quality fastq
  /usr/local/sw/FastQC/fastqc $fastqdir/"$i"_R1_001.fastq.gz -o $direct/data/processed/quality_cont/
  /usr/local/sw/FastQC/fastqc $fastqdir/"$i"_R2_001.fastq.gz -o $direct/data/processed/quality_cont/
done

multiqc $direct/data/processed/quality_cont/ -o $direct/data/processed/quality_cont/
}

