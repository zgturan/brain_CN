# args <- commandArgs(trailingOnly = T)
# variation= as.numeric(args[1])
variation= 0.9
outpath= file.path("./trial/results", paste0("genome_wide_", variation,'/', 'ginkgo/'))


thres1_signi <- readRDS(paste0(outpath, "thres_svd_signi_genome.rds"))
thres1_signi= thres1_signi[,c('id','chr','start','end','cnv')]

turan1= read.table('./turan/data/processed/ginkgo/1/SegNorm', header = T)
chrx= turan1[,c(1:3)]


cnv_x2= rbind()
 for (i in 1:nrow(thres1_signi)){
  idx=     thres1_signi[i,]
  start=   as.numeric(rownames(chrx[chrx$CHR%in%idx$chr&chrx$START%in%idx$start,]))
  end=     as.numeric(rownames(chrx[chrx$CHR%in%idx$chr&chrx$END%in%idx$end,]))
  cnv=     idx$cnv
  cnv_x= data.frame(x=start:end, y=rep(cnv, length(start:end)), z= rep(idx$id,length(start:end)))
  cnv_x2= rbind(cnv_x2, cnv_x)
 }

saveRDS(cnv_x2, file = paste0(outpath, "signicnv_locati_genome.rds"))