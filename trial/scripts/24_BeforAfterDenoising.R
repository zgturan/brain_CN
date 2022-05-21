# args <- commandArgs(trailingOnly = T)
# variation= as.numeric(args[1])
variation=0.9
outpath= file.path("/trial/results", paste0("genome_wide_", variation,'/','cells','/'))

set.seed(1)

setwd(outpath)
aa= list.files()
ds_id= gsub('_plot2.pdf','',grep('_plot2.pdf', aa, value = T))
length(ds_id)

source('./turan/scripts/00_Source.R')

for (i in 1:length(ds_id)){
  top=8
  idx= ds_id[i]
  cell <- readRDS(paste0("./turan_svd/data/processed/ginkgo/", idx, ".rds"))
  cell_svd <- readRDS(paste0(outpath, idx, ".rds"))
  p= grid.arrange(cell, cell_svd)
  
  ggsave(paste0(outpath, '/', idx,'_befor_after',".pdf"), p, width = 14, height = 7)
  ggsave(paste0(outpath, '/', idx,'_befor_after',".png"), p, width = 14, height = 7)
  dev.off()
}