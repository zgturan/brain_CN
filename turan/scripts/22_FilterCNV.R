source('./turan/scripts/00_Source.R')

remaning_cells <- readRDS("./turan/data/processed/rds/remaning_cells.rds")
dim(remaning_cells)
# 588   3

turan_cnv_stat <- readRDS("./turan/data/processed/rds/turan_cnv_stat2.rds")
turan_cnv_statx= turan_cnv_stat[turan_cnv_stat$id%in%remaning_cells$id,]

turan_cnv_statxx= turan_cnv_statx[!(turan_cnv_statx$chr%in%'chrX'),]
dim(turan_cnv_statxx)
# 517  12
################################
turan_cnv_statx_tri=  turan_cnv_statxx[turan_cnv_statxx$cnv%in%3,]
turan_cnv_statx_tri2= turan_cnv_statx_tri[turan_cnv_statx_tri$zscore >= 2,]
dim(turan_cnv_statx_tri2)
# 11 12
rownames(turan_cnv_statx_tri2)=NULL
colnames(turan_cnv_statx_tri2)=NULL
#########################
turan_cnv_statx_one=  turan_cnv_statxx[turan_cnv_statxx$cnv%in%1,]
turan_cnv_statx_one2= turan_cnv_statx_one[turan_cnv_statx_one$zscore >= 2,]
dim(turan_cnv_statx_one2)
# 38 12
rownames(turan_cnv_statx_one2)=NULL
colnames(turan_cnv_statx_one2)=NULL

thres1_cnv= data.frame(rbindlist(list(turan_cnv_statx_tri2, turan_cnv_statx_one2)))
colnames(thres1_cnv)= colnames(turan_cnv_statx_one)
dim(thres1_cnv)
thres1_cnv= thres1_cnv[!(thres1_cnv$cnv%in%3&thres1_cnv$chr%in%'chr19'&thres1_cnv$start%in%1&thres1_cnv$end<21000000),]
dim(thres1_cnv)
# 49 12

thres1_cnvx= thres1_cnv[abs(thres1_cnv$eff_siz) <= 0.5,]
head(thres1_cnvx)
dim(thres1_cnvx)
# 20 12

table(thres1_cnvx$cnv)

saveRDS(thres1_cnvx, file= './turan/data/processed/rds/thres1_signi.rds')
