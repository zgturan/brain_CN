#!/bin/sh

TrimAlign()
{
direct=$1
fastqdir=$2

cd $direct

for i in `cat file_name.txt`
do
  echo $i
	## trimming
  java -jar /usr/local/sw/Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads 80 -trimlog $direct/data/processed/trimmed/trimlog.txt $fastqdir/"$i"_R1_001.fastq.gz $fastqdir/"$i"_R2_001.fastq.gz $direct/data/processed/trimmed/T"$i"_R1.fastq $direct/data/processed/trimmed/T"$i"_R1U.fastq $direct/data/processed/trimmed/T"$i"_R2.fastq $direct/data/processed/trimmed/T"$i"_R2U.fastq ILLUMINACLIP:/data/processed/adapter/adapt.fa:2:30:10:8:TRUE HEADCROP:35 MINLEN:66 CROP:66

  ## alignment
  /usr/local/sw/bwa-0.7.17/bwa aln -t 80 /mnt/NEOGENE1/projects/aneuploidy_2016/hg19.fa $direct/data/processed/trimmed/T"$i"_R1.fastq > $direct/data/processed/trimmed/T"$i"_R1.sai
  /usr/local/sw/bwa-0.7.17/bwa aln -t 80 /mnt/NEOGENE1/projects/aneuploidy_2016/hg19.fa $direct/data/processed/trimmed/T"$i"_R2.fastq > $direct/data/processed/trimmed/T"$i"_R2.sai
  /usr/local/sw/bwa-0.7.17/bwa sampe /mnt/NEOGENE1/projects/aneuploidy_2016/hg19.fa $direct/data/processed/trimmed/T"$i"_R1.sai $direct/data/processed/trimmed/T"$i"_R2.sai $direct/data/processed/trimmed/T"$i"_R1.fastq $direct/data/processed/trimmed/T"$i"_R2.fastq  > $direct/data/processed/sam/"$i".sam

  ## Quality trimmed fastq
  /usr/local/sw/FastQC/fastqc $direct/data/processed/trimmed/T"$i"_R1.fastq -o $direct/data/processed/trimmed/
  /usr/local/sw/FastQC/fastqc $direct/data/processed/trimmed/T"$i"_R2.fastq -o $direct/data/processed/trimmed/
done

 multiqc $direct/data/processed/trimmed/ -o $direct/data/processed/trimmed/
}

