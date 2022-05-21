source('./turan/scripts/00_Source.R')

CN_table <- readRDS("./turan/data/processed/rds/CN_table_thres1.rds")

CN_table= CN_table[,c('id', 'chr')]
chroms= paste0('chr',1:22)

CN_tablex= CN_table
rownames(CN_tablex)= NULL
colnames(CN_tablex)= NULL

add_chroms= data.frame(rep("cell_dummy",length(chroms)), chroms)
rownames(add_chroms)= NULL
colnames(add_chroms)= NULL

CN_tablexx= data.frame(rbindlist(list(CN_tablex, add_chroms)))
CN_tablexx3= data.frame(table(CN_tablexx))
dim(CN_tablexx3)
head(CN_tablexx3)
colnames(CN_tablexx3)= c('id','chr','Freq')
CN_tablexx3=CN_tablexx3[!CN_tablexx3$id%in%'cell_dummy',]
dim(CN_tablexx3)

infox <- readRDS("./turan/data/processed/rds/CN_table_thres1.rds")
infox= infox[,c('Diagnosis','id', 'Brain_region', 'Case_ID', 'Sex')]
CN_tablexx4= merge(CN_tablexx3, by.x='id', infox, by.y='id')
head(CN_tablexx4)


cover= read.table('./turan/data/processed/coverage/txt/07_Coverage.txt',sep = ':', header=F)
head(cover)
dim(cover)
# 1564    2
colnames(cover)= c('id','coverage')
cover$id= as.character(cover$id)
cover$id=gsub('.txt','',cover$id)
head(cover)

CN_tablexx5= merge(CN_tablexx4, by.x='id', cover, by.y='id')
head(CN_tablexx5)

CN_tablexx5$Case_ID= gsub('_EC','',CN_tablexx5$Case_ID)
CN_tablexx5$Case_ID= gsub('_CA1','',CN_tablexx5$Case_ID)
CN_tablexx5$Case_ID= gsub('_CB','',CN_tablexx5$Case_ID)
CN_tablexx5$Case_ID= gsub('_CA3','',CN_tablexx5$Case_ID)
head(CN_tablexx5)

saveRDS(CN_tablexx5, file="./turan/data/processed/rds/thres1_matrix.rds")