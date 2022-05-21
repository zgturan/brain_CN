# args <- commandArgs(trailingOnly = T)
# variation= as.numeric(args[1])
variation=0.9
outpath= file.path("./trial/results", paste0("genome_wide_", variation,'/', 'ginkgo/'))

source('./turan/scripts/00_Source.R')

samp_info=data.frame(read_excel('./turan/data/processed/txt/Table_2.xlsx'))
samp_info$fastq=as.character(samp_info$fastq)
samp_info$Sex=as.character(samp_info$Sex)
samp_info$Brain_region=as.character(samp_info$Brain_region)
samp_info$Dataset_name=as.character(samp_info$Dataset_name)
samp_info$Cell_type=as.character(samp_info$Cell_type)

thres_svd_signi <- readRDS(paste0(outpath, "thres_svd_signi_genome.rds"))
thres_svd_signix= merge(thres_svd_signi, by.x='id', samp_info, by.y="fastq")
table(thres_svd_signix$Diagnosis)
table(thres_svd_signix$cnv)
thres_svd_signix$Brain_region

saveRDS(thres_svd_signix, file= paste0(outpath, "CN_table_thres_svd_genome.rds"))