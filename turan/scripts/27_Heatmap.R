source('./turan/scripts/00_Source.R')

signicnv_locati <- readRDS("./turan/data/processed/rds/turan_signicnv_locati_heatmap.rds")
colnames(signicnv_locati)=c('start_id', 'end_id', 'id', 'cnv')
signicnv_locati$id=as.character(signicnv_locati$id)

loc    = read.table('/home/users/ginkgo-master/genomes/hg19/variable_500000_76_bwa' , header=TRUE , sep="\t", as.is=TRUE)
ert= matrix(2, nrow(loc), length(unique(signicnv_locati$id)))
colnames(ert)= unique(signicnv_locati$id)
rownames(ert)= loc[,1]
ert[1:6,1:6]
head(signicnv_locati)

for (i in 1:nrow(signicnv_locati)){
  ert[signicnv_locati$start_id[i]:signicnv_locati$end_id[i], colnames(ert)%in%signicnv_locati$id[i]] =  signicnv_locati$cnv[i]
}

rem2= signicnv_locati$id
table2= read_xlsx('./turan/data/processed/txt/Table_2.xlsx')
table2= table2[as.character(table2$fastq)%in%as.character(rem2),]
table3= as.data.frame(table2[,c('fastq','Diagnosis', 'Brain_region')])
table3$Brain_region= gsub('hippocampus_ca3','hippocampal_CA3',table3$Brain_region)
table3$Brain_region= gsub('hippocampus_ca1','hippocampal_CA1',table3$Brain_region)
table3= table3[order(table3$Diagnosis),]
table3= table3[order(table3$Brain_region),]

#table3x= table3[match(colnames(ert), table3$fastq),]
ert= ert[,match(table3$fastq, colnames(ert))]

annotation_row = data.frame(Diagnosis = table3$Diagnosis,Brain_Region = table3$Brain_region)

rownames(annotation_row) = colnames(ert)
saveRDS(annotation_row, file="./turan/data/processed/rds/turan_annotation_row.rds")


ann_color = list("Brain_Region"=c("temporal_cortex"="#666666","hippocampal_CA1"="#7570B3", 
                                  "entorhinal_cortex" ="#D95F02",
                                  "hippocampal_CA3"="#E6AB02","cerebellum"="#1B9E77"),
                 "Diagnosis"=c("AD"="#FFB8AC","control"='#FEE2DD'))

ert= ert[!rownames(ert)%in%c('chrX','chrY'),]
tail(ert)[1:6,1:6]
dim((ert))

count= table(rownames(ert))
count2= count[c(paste0('chr',1:22))]
sept= cumsum(count2)
L1= rep("", nrow(ert))
L2= c()
for(i in 1:length(sept)){
  if(i ==1){
    L2=c(L2, round(sept[i]/2,0))
  } else {
    L2= c(L2, round((sept[i]- sept[i-1])/2 + sept[i-1],0))
  }}
# L1[L2]= gsub("chr","",names(L2))
L1[L2]=  names(L2)

saveRDS(ert, file="./turan/data/processed/rds/turan_heatmap_signi.rds")