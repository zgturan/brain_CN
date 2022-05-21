source('./turan/scripts/00_Source.R')

remaning_cells <- readRDS("./turan/data/processed/rds/remaning_cells.rds")
dim(remaning_cells)
# 588   2
male_id <- readRDS("./turan/data/processed/rds/male_id.rds")

remaning_cells=remaning_cells[remaning_cells$id%in%male_id,'id']
length(remaning_cells)
# 373

turan_cnv_stat <- readRDS("./turan/data/processed/rds/turan_cnv_stat2.rds")
turan_cnv_statx= turan_cnv_stat[turan_cnv_stat$id%in%remaning_cells,]
dim(turan_cnv_statx)
head(turan_cnv_statx)

turan_cnv_statx_male= turan_cnv_statx[ (turan_cnv_statx$chr%in%'chrX') & (turan_cnv_statx$start%in%1) & (turan_cnv_statx$cnv%in%1) &  (turan_cnv_statx$end%in%155270560),]
dim(turan_cnv_statx_male)
# 344  12
head(turan_cnv_statx_male)

saveRDS(turan_cnv_statx_male$eff_siz, "./turan/data/processed/rds/turan_male_effect_size.rds")