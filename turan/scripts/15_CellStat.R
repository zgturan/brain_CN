source('./turan/scripts/00_Source.R')

turan_clouds <- readRDS("./turan/data/processed/rds/turan_clouds.rds")
dim(turan_clouds)
# 5578 1564
turan_cloudsx= turan_clouds[1:5243,]
head(turan_cloudsx)[1:6,1:6]
dim(turan_cloudsx)
# 5243 1564

turan_cloudsx2= apply(turan_cloudsx, 2, mean)
head(turan_cloudsx2)

turan_clouds_mad= apply(turan_cloudsx, 2, sd)
head(turan_clouds_mad)

identical(names(turan_cloudsx2), names(turan_clouds_mad))

turan_cell_stat= cbind(as.numeric(turan_cloudsx2), as.numeric(turan_clouds_mad))
colnames(turan_cell_stat)= c('cell_mean','cell_sd')
rownames(turan_cell_stat)= names(turan_cloudsx2)
head(turan_cell_stat)

saveRDS(turan_cell_stat, file = "./turan/data/processed/rds/turan_cell_stat_clouds.rds")
