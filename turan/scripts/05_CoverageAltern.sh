for x in `cat all_name_coverage.txt`
do
samtools depth -a /data/processed/bam/"$x" | awk '{sum+=$3} END { print "Average = ",sum/NR}' >> /data/processed/CoverageAltern.txt
done
