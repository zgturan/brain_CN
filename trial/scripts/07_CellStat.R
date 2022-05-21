# args <- commandArgs(trailingOnly = T)
# variation= as.numeric(args[1])
variation=0.9
outpath= file.path("/trial/results", paste0("genome_wide_", variation,'/','ginkgo/'))

turan_clouds <- readRDS(paste0(outpath, 'turan_clouds_genome.rds'))
turan_cloudsx= turan_clouds[1:5243,]
head(turan_cloudsx)[1:6,1:6]
dim(turan_cloudsx)
# 5243 1337

turan_cloudsx2= apply(turan_cloudsx, 2, mean)
head(turan_cloudsx2)

turan_clouds_mad= apply(turan_cloudsx, 2, sd)
head(turan_clouds_mad)

identical(names(turan_cloudsx2), names(turan_clouds_mad))

turan_cell_stat= cbind(as.numeric(turan_cloudsx2), as.numeric(turan_clouds_mad))
colnames(turan_cell_stat)= c('cell_mean','cell_sd')
rownames(turan_cell_stat)= names(turan_cloudsx2)
head(turan_cell_stat)

saveRDS(turan_cell_stat, file = paste0(outpath, 'turan_cell_stat_clouds_genome.rds'))

