args <- commandArgs(trailingOnly = T)
variation= as.numeric(args[1])
outpath= file.path("/trial/results", paste0("genome_wide_", variation))

suppressPackageStartupMessages(library(tilingArray))
raw <- readRDS(file.path(outpath, paste0('pca_genomewide', '_', variation,'.rds')))
raw= raw+1

number_of_CN6= cbind()
for (i in 1:ncol(raw)){
        cellx= raw[,i]  
        if (min(cellx) <= 0){
                cellx[cellx <= 0] = posMin(cellx[cellx>0] )}
        
        else{
                cellx= cellx}
        
        number_of_CN6= cbind(number_of_CN6, cellx)
}

colnames(number_of_CN6)= colnames(raw)
number_of_CN6= data.frame(number_of_CN6)

saveRDS(number_of_CN6, file= file.path(outpath, paste0('pca_genomewide', '_', variation,'_pos.rds')))

