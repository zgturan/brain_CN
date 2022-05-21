source('./turan/scripts/00_Source.R')

turan_SegNorm <- readRDS("./turan/data/processed/rds/turan_SegNorm.rds")
dim(turan_SegNorm)
# 5578 1567
head(turan_SegNorm)[1:6,1:6]

turan_ploidy <- readRDS("./turan/data/processed/rds/turan_ploidy.rds")
head(turan_ploidy)
dim(turan_ploidy)

identical(colnames(turan_SegNorm[,4:1567]), turan_ploidy$id)
head(turan_SegNorm[,4:1567])[1:6,1:6]

turan_clouds= sweep(turan_SegNorm[,4:1567], 2, turan_ploidy$predicted_ploidy, "*")
head(turan_clouds)[1:6,1:6]
saveRDS(turan_clouds, file = './turan/data/processed/rds/turan_clouds.rds')