# args <- commandArgs(trailingOnly = T)
# variation= as.numeric(args[1])
variation= 0.9
outpath= file.path("/trial/results", paste0("genome_wide_", variation,'/'))

unloadNamespace("tilingArray")
library(plyr)
library(DNAcopy) 
library(inline) 
library(scales)
library(ggpubr)
library('unikn')     
library('ggpubr')
library('rtracklayer')
library('tidyverse')
library("wesanderson")
library(plyr)
library(ggplot2)
library(gridExtra)
library(nortest)
library(ggplot2)
######################
set.seed(1)

setwd(paste0(outpath, "cells/"))
aa= list.files()
ds_id= gsub('_plot2.pdf','',grep('_plot2.pdf', aa, value = T))


for (i in 1:length(ds_id)){
  tryCatch({
    top=8
    idx= ds_id[i]
    print(c(i,idx))
    cell <- readRDS(paste0(outpath, "cells/", idx, ".rds"))
    cell_svd <- readRDS(paste0(outpath, "ginkgo/", idx, "_svd.rds"))
    p= grid.arrange(cell_svd,cell)
    ggsave(paste0(outpath, "check_accu/",idx, '_befor_after', ".pdf"), p, width = 14, height = 7)
    dev.off()
  }, error = function(e) {cat('error\n'); print(e); e })}
