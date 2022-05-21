source('./turan/scripts/00_Source.R')

thres1_signi <- readRDS("./turan/data/processed/rds/thres1_signix.rds")
head(thres1_signi)
thres1_signi= thres1_signi[,c('id','chr','start','end','cnv')]
dim(thres1_signi)
# 16   5

length(unique(thres1_signi$id))

turan1= read.table('./turan/data/processed/ginkgo/1/SegNorm', header = T)
chrx= turan1[,c(1:3)]
head(chrx)
dim(chrx)

cnv_x2= rbind()
 for (i in 1:nrow(thres1_signi)){
  idx=     thres1_signi[i,]
  start=   as.numeric(rownames(chrx[chrx$CHR%in%idx$chr&chrx$START%in%idx$start,]))
  end=     as.numeric(rownames(chrx[chrx$CHR%in%idx$chr&chrx$END%in%idx$end,]))
  cnv=     idx$cnv
  cnv_x= data.frame(x=start, y= end, z= idx$id, q= cnv)
  cnv_x2= rbind(cnv_x2, cnv_x)
 }

saveRDS(cnv_x2, file = "./turan/data/processed/rds/turan_signicnv_locati_heatmap.rds")