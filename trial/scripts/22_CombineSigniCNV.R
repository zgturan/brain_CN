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

variation=0.9
outpath= file.path("/trial/results", paste0("genome_wide_", variation,'/','cells','/'))

setwd(outpath)
aa= list.files()
ds_id= gsub('_plot2.pdf','',grep('_plot2.pdf', aa, value = T))
length(ds_id)
# 11


library(gridExtra)
library(ggplot2)

p <- list()
for (i in 1:length(ds_id)){
  top=8
  print(i)
  idx= ds_id[i]
  p[[i]] <- readRDS(paste0(outpath, idx, ".rds"))
  
}
xx=do.call(grid.arrange,p)

ggsave(paste0(outpath, "corrected_cells.pdf"), xx, units = "cm", width = 124, height = 30, useDingbats = F)
ggsave(paste0(outpath, "corrected_cells.png"), xx, units = "cm", width = 124, height = 20, type='cairo')
