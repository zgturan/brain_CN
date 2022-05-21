source('./trial/scripts/00_Source.R')

segstat1=read.table('./trial/data/processed/ginkgo/1/SegStats')
segstat1=data.frame(rownames(segstat1), segstat1[,'Reads'],  segstat1[,'Disp'])
colnames(segstat1)=NULL
rownames(segstat1)=NULL
segstat2=read.table('./trial/data/processed/ginkgo/2/SegStats')
segstat2=data.frame(rownames(segstat2), segstat2[,'Reads'], segstat2[,'Disp'])
colnames(segstat2)=NULLs
rownames(segstat2)=NULL
segstat3=read.table('./trial/data/processed/ginkgo/3/SegStats')
segstat3=data.frame(rownames(segstat3), segstat3[,'Reads'], segstat3[,'Disp'])
colnames(segstat3)=NULL
rownames(segstat3)=NULL
segstat4=read.table('./trial/data/processed/ginkgo/4/SegStats')
segstat4=data.frame(rownames(segstat4),segstat4[,'Reads'], segstat4[,'Disp'])
colnames(segstat4)=NULL
rownames(segstat4)=NULL
segstat=rbindlist(list(segstat1, segstat2, segstat3, segstat4))
segstat=data.frame(segstat)
colnames(segstat)=c('id','bed_reads','dispersion')
segstat$id=as.character(segstat$id)
head(segstat)
trial_segstat=segstat
saveRDS(trial_segstat, file = "./trial/data/processed/rds/trial_segstat.rds")
####################################################################
rm(list = ls())
source('./trial/scripts/03_Source.R')

raw1 = read.table('./trial/data/processed/ginkgo/1/data', header=TRUE, sep="\t")
raw2 = read.table('./trial/data/processed/ginkgo/2/data', header=TRUE, sep="\t")
raw3 = read.table('./trial/data/processed/ginkgo/3/data', header=TRUE, sep="\t")
raw4 = read.table('./trial/data/processed/ginkgo/4/data', header=TRUE, sep="\t")

trial_raw= cbind(raw1,raw2,raw3,raw4)
dim(trial_raw)
head(trial_raw)[1:6,1:6]
dim(trial_raw)
# 5578 1564

saveRDS(trial_raw, file = "./trial/data/processed/rds/trial_raw.rds")
####################################################################
rm(list = ls())
source('./trial/scripts/03_Source.R')

our1= read.table('./trial/data/processed/ginkgo/1/CNV1')
colnames(our1)= NULL
rownames(our1)= NULL
our2= read.table('./trial/data/processed/ginkgo/2/CNV1')
colnames(our2)= NULL
rownames(our2)= NULL
our3= read.table('./trial/data/processed/ginkgo/3/CNV1')
colnames(our3)= NULL
rownames(our3)= NULL
our4= read.table('./trial/data/processed/ginkgo/4/CNV1')
colnames(our4)= NULL
rownames(our4)= NULL
trial_CNV1= rbindlist(list(our1, our2,our3,our4))
head(trial_CNV1)
trial_CNV1= data.frame(trial_CNV1)
dim(trial_CNV1)
# 40742     5

head(trial_CNV1)
colnames(trial_CNV1)=c('chr','start','end','id','cnv')
trial_CNV1$chr= as.character(trial_CNV1$chr)
trial_CNV1$id= as.character(trial_CNV1$id)

saveRDS(trial_CNV1, file = "./trial/data/processed/rds/trial_CNV1.rds")
############################################################################