#!bin/sh

for i in `cat file_name.txt`
do 

echo -n $i'\t' >> /data/processed/txt/flagstat
samtools flagstat /data/processed/bam/"$i"_rm.sorted.bam | sed -n 10p >> /data/processed/txt/flagstat

done
echo "finished"