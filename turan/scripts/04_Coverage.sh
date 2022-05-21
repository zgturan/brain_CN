
for i in `cat file_name.txt`
do
  echo $i
  samtools view -b /data/processed/bam/"$i"_rm.sorted.bam | /home/users/bedtools2/bin/genomeCoverageBed -ibam - -g hg19.fa > /data/processed/coverage/"$i".cov
  grep genome /data/processed/coverage/"$i".cov | awk '{NUM+=$2*$3; DEN+=$3} END {print NUM/DEN}' > /data/processed/coverage/"$i".txt
done
