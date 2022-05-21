# args <- commandArgs(trailingOnly = T)
# variation= as.numeric(args[1])
variation=0.9
outpath= file.path("/trial/results", paste0("genome_wide_", variation,'/','ginkgo/'))

turan_SegNorm = read.table(paste0(outpath, 'SegNorm'), header = T)
turan_SegNorm$CHR= as.character(turan_SegNorm$CHR)
dim(turan_SegNorm)
# 5578 1340
# head(turan_SegNorm)[1:6,1:6]

turan_ploidy <- readRDS(paste0(outpath, 'cell_cn.rds'))
turan_ploidy= data.frame(id= names(turan_ploidy), predicted_ploidy=as.numeric(turan_ploidy))
turan_ploidy$id= as.character(turan_ploidy$id)
head(turan_ploidy)
dim(turan_ploidy)
# 1337    2

identical(colnames(turan_SegNorm[,4:ncol(turan_SegNorm)]), turan_ploidy$id)
head(turan_SegNorm[,4:ncol(turan_SegNorm)])[1:6,1:6]

turan_clouds= sweep(turan_SegNorm[,4:ncol(turan_SegNorm)], 2, turan_ploidy$predicted_ploidy, "*")
head(turan_clouds)[1:6,1:6]
saveRDS(turan_clouds, file = paste0(outpath, 'turan_clouds_genome.rds'))
