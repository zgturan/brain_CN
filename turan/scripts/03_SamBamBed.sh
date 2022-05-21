#!/bin/sh

SamBam()
{
direct=$1

export PATH=$PATH:/home/users/bedtools2/bin
export PATH=$PATH:/home/users/HMMcopy/bin

cd $direct
for i in `cat file_name.txt`
do
  echo $i
  samtools view -f 2 -F 3852 -b $direct/data/processed/sam/"$i".sam > $direct/data/processed/bam/"$i".bam
  samtools view -h $direct/data/processed/bam/"$i".bam | egrep -i "^@|XT:A:U" | samtools view -Shu - > $direct/data/processed/bam/"$i".bam2
  samtools view -h -q 60 $direct/data/processed/bam/"$i".bam2 > $direct/data/processed/bam/"$i".bam3
  samtools sort $direct/data/processed/bam/"$i".bam3 > $direct/data/processed/bam/"$i".sorted.bam
  samtools rmdup -S $direct/data/processed/bam/"$i".sorted.bam  $direct/data/processed/bam/"$i"_rm.sorted.bam
  samtools index -b $direct/data/processed/bam/"$i"_rm.sorted.bam

  /home/users/bedtools2/bin/bamToBed -i $direct/data/processed/bam/"$i"_rm.sorted.bam > $direct/data/processed/bed/"$i".bed
  sort -k1,1V -k2,2n $direct/data/processed/bed/"$i".bed > $direct/data/processed/bed/"$i".bed2
done
}


