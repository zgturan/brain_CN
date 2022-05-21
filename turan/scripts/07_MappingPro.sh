#!bin/sh

for i in `cat file_name.txt`
do 
echo -n $i'\t' >> /data/processed/txt/mapping_proportion_R1
zcat /data/raw/"$i"_R1_001.fastq.gz | echo $((`wc -l`/4)) >> /turan/data/processed/txt/mapping_proportion_R1
done
                                                                       
                                                                      