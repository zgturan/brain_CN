# args <- commandArgs(trailingOnly = T)
# variation= as.numeric(args[1])
variation=0.9
outpath= file.path("/trial/results", paste0("genome_wide_", variation,'/','ginkgo/'))

source('./turan/scripts/00_Source.R')

table2= read_xlsx('./turan/data/processed/txt/Table_2.xlsx')

thres_svd <- readRDS(paste0(outpath, "remaning_cells_genome.rds"))
turan_segstat <- readRDS("./turan/data/processed/rds/turan_segstat.rds")
thres_svd2= turan_segstat[turan_segstat$id%in%thres_svd,c('id','bed_reads')]
colnames(thres_svd2)= c('id', 'number_of_reads')
dim(thres_svd2)
# 1301    2

CN_table_thres_svd <- readRDS(paste0(outpath, "CN_table_thres_svd_genome.rds"))[,1:16]
head(CN_table_thres_svd)
OUT <- createWorkbook()
addWorksheet(OUT, "Cell_Info")
addWorksheet(OUT, "CNV_Info")
writeData(OUT, sheet = "Cell_Info", x = thres_svd2)
writeData(OUT, sheet = "CNV_Info", x = CN_table_thres_svd)

saveWorkbook(OUT, paste0(outpath, "Supp1.xlsx"))
