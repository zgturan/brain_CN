source('./turan/scripts/00_Source.R')

samp_info=data.frame(read_excel('./turan/data/processed/txt/Table_2.xlsx'))
samp_info$fastq=as.character(samp_info$fastq)
samp_info$Sex=as.character(samp_info$Sex)
samp_info$Brain_region=as.character(samp_info$Brain_region)
samp_info$Dataset_name=as.character(samp_info$Dataset_name)
samp_info$Cell_type=as.character(samp_info$Cell_type)
head(samp_info)

thres1_signi <- readRDS("./turan/data/processed/rds/thres1_signix.rds")
thres1_signix= merge(thres1_signi, by.x='id', samp_info, by.y="fastq")
dim(thres1_signix)
# 16 20

saveRDS(thres1_signix, file='./turan/data/processed/rds/CN_table_thres1.rds')

