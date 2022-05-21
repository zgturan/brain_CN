variation= 0.9
outpath= file.path("./trial/results", paste0("genome_wide_", variation,'/', 'ginkgo/'))

source('./turan/scripts/00_Source.R')
turan_segstat <- readRDS("./turan/data/processed/rds/turan_segstat.rds")

turan_ploidy <- readRDS(paste0(outpath, "cell_cn.rds"))
head(turan_ploidy)
length(turan_ploidy)
# 1337
turan_ploidy= data.frame(id= names(turan_ploidy), predicted_ploidy= as.numeric(turan_ploidy))
turan_ploidy$id= as.character(turan_ploidy$id)
head(turan_ploidy)

turan_segstatxx= turan_ploidy[(turan_ploidy$predicted_ploidy>=1.9) & (turan_ploidy$predicted_ploidy<=2),]
head(turan_segstatxx)
dim(turan_segstatxx)
# 1302    2

table(turan_segstatxx$predicted_ploidy)

cover70per <- readRDS(paste0(outpath, "cover70per_genome.rds"))
segstatxx2= turan_segstatxx[!(turan_segstatxx$id%in%cover70per),]
dim(segstatxx2)
# 1301

segstatxx2= segstatxx2$id

saveRDS(segstatxx2, file = paste0(outpath, "remaning_cells_genome.rds"))
