variation=0.9
outpath= file.path("./trial/results", paste0("genome_wide_", variation,'/', 'ginkgo/'))
source('./turan/scripts/00_Source.R')

remaning_cells <- readRDS(paste0(outpath, "remaning_cells_genome.rds"))
turan_cnv_stat <- readRDS(paste0(outpath, "turan_cnv_stat2_genome.rds"))
turan_cnv_statx= turan_cnv_stat[turan_cnv_stat$id%in%remaning_cells,]
turan_cnv_statxx= turan_cnv_statx[!(turan_cnv_statx$chr%in%'chrX'),]
head(turan_cnv_statxx)
################################
turan_cnv_statx_tri=  turan_cnv_statxx[turan_cnv_statxx$cnv%in%3,]
turan_cnv_statx_tri2= turan_cnv_statx_tri[turan_cnv_statx_tri$zscore >= 2,]
rownames(turan_cnv_statx_tri2)=NULL
colnames(turan_cnv_statx_tri2)=NULL
#########################
turan_cnv_statx_one=  turan_cnv_statxx[turan_cnv_statxx$cnv%in%1,]
turan_cnv_statx_one2= turan_cnv_statx_one[turan_cnv_statx_one$zscore >= 2,]
rownames(turan_cnv_statx_one2)=NULL
colnames(turan_cnv_statx_one2)=NULL

thres_svd_cnv= data.frame(rbindlist(list(turan_cnv_statx_tri2, turan_cnv_statx_one2)))
colnames(thres_svd_cnv)= colnames(turan_cnv_statx_one)
thres_svd_cnv= thres_svd_cnv[!(thres_svd_cnv$cnv%in%3&thres_svd_cnv$chr%in%'chr19'&thres_svd_cnv$start%in%1&thres_svd_cnv$end < 21000000),]
dim(thres_svd_cnv)
# 31 12

thres_svd_cnvx= thres_svd_cnv[abs(thres_svd_cnv$eff_siz) <= 0.5,]
dim(thres_svd_cnvx)

saveRDS(thres_svd_cnvx, file= paste0(outpath, "thres_svd_signi_genome.rds"))