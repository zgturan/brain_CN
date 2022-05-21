variation= 0.9
outpath= file.path("./trial/results", paste0("genome_wide_", variation,'/', 'ginkgo/'))

turan_cell_stat_clouds <- readRDS(paste0(outpath, "turan_cell_stat_clouds_genome.rds")) 
turan_cell_stat_cloudsx= data.frame(rownames(turan_cell_stat_clouds), turan_cell_stat_clouds[,1], turan_cell_stat_clouds[,2])
rownames(turan_cell_stat_cloudsx)= NULL
colnames(turan_cell_stat_cloudsx)=c('id',"cell_mean","cell_sd")
turan_cell_stat_cloudsx$id= as.character(turan_cell_stat_cloudsx$id)

turan_cnv_stat <- readRDS(paste0(outpath, "turan_cnv_stat_check_genome.rds"))
turan_cnv_statx= merge(turan_cnv_stat, by.x='id', turan_cell_stat_cloudsx, by.y='id')

turan_cnv_statx[,ncol(turan_cnv_statx)+1]= abs((turan_cnv_statx$cn_mean - turan_cnv_statx$cell_mean)/turan_cnv_statx$cn_sd)
colnames(turan_cnv_statx)[ncol(turan_cnv_statx)]='zscore'

saveRDS(turan_cnv_statx, file = paste0(outpath, "turan_cnv_stat2_genome.rds"))