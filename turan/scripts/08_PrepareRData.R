source('./turan/scripts/00_Source.R')

##### number of reads after MAPQ 60
flags_stat= read.delim('./turan/data/processed/txt/flagstat', sep='\t', header=F)
dim(flags_stat)
flags_stat[,1]= as.character(flags_stat[,1])
colnames(flags_stat) = c('id', 'rm_bam_reads')
head(flags_stat)

##### 
map1= read.table('./turan/data/processed/txt/mapping_proportion_R1', sep="\t")
head(map1)
dim(map1)
# 1564    2
map1[,1]=as.character(map1[,1])

map2= read.table('./turan/data/processed/txt/mapping_proportion_R2', sep="\t")
head(map2)
dim(map2)
# 1564    2
map2[,1]=as.character(map2[,1])

map3= (map1[,2] + map2[,2])/2
map4=data.frame(map2[,1], map3)
colnames(map4)= c('id','raw_read')
map4$id=as.character(map4$id)
head(map4)

identical(flags_stat[,1], map4[,1])
# TRUE

mapping_pro_turan= data.frame(flags_stat[,1], flags_stat[,2]/map4[,2], rep("turan", dim(flags_stat)[1]))
colnames(mapping_pro_turan) = c('id', 'mapping_pro', 'dataset')
head(mapping_pro_turan)

mapping_pro_turan[,1]= as.character(mapping_pro_turan[,1])
mapping_pro_turan[,3]= as.character(mapping_pro_turan[,3])

saveRDS(mapping_pro_turan, file = "./turan/data/processed/rds/mapping_pro_turan.rds")

###################################
rm(list = ls())
source('./turan/scripts/00_Source.R')

segstat1=read.table('./turan/data/processed/ginkgo/1/SegStats')
segstat1=data.frame(rownames(segstat1), segstat1[,'Reads'],  segstat1[,'Disp'])
colnames(segstat1)=NULL
rownames(segstat1)=NULL
segstat2=read.table('./turan/data/processed/ginkgo/2/SegStats')
segstat2=data.frame(rownames(segstat2), segstat2[,'Reads'], segstat2[,'Disp'])
colnames(segstat2)=NULL
rownames(segstat2)=NULL
segstat3=read.table('./turan/data/processed/ginkgo/3/SegStats')
segstat3=data.frame(rownames(segstat3), segstat3[,'Reads'], segstat3[,'Disp'])
colnames(segstat3)=NULL
rownames(segstat3)=NULL
segstat4=read.table('./turan/data/processed/ginkgo/4/SegStats')
segstat4=data.frame(rownames(segstat4),segstat4[,'Reads'], segstat4[,'Disp'])
colnames(segstat4)=NULL
rownames(segstat4)=NULL
segstat=rbindlist(list(segstat1, segstat2, segstat3, segstat4))
segstat=data.frame(segstat)
colnames(segstat)=c('id','bed_reads','dispersion')
segstat$id=as.character(segstat$id)
head(segstat)
turan_segstat=segstat
saveRDS(turan_segstat, file = "./turan/data/processed/rds/turan_segstat.rds")
###########################################################
rm(list = ls())
source('./turan/scripts/00_Source.R')

eliminate1= read_tsv('./turan/data/processed/ginkgo/1/results.txt')
eliminate1=as.data.frame(eliminate1[,1:2])
colnames(eliminate1)=NULL
rownames(eliminate1)=NULL

eliminate2= read_tsv('./turan/data/processed/ginkgo/2/results.txt')
eliminate2=as.data.frame(eliminate2[,1:2])
colnames(eliminate2)=NULL
rownames(eliminate2)=NULL

eliminate3= read_tsv('./turan/data/processed/ginkgo/3/results.txt')
eliminate3=as.data.frame(eliminate3[,1:2])
colnames(eliminate3)=NULL
rownames(eliminate3)=NULL

eliminate4= read_tsv('./turan/data/processed/ginkgo/4/results.txt')
eliminate4=as.data.frame(eliminate4[,1:2])
colnames(eliminate4)=NULL
rownames(eliminate4)=NULL

eliminate= data.frame(rbindlist(list(eliminate1, eliminate2, eliminate3, eliminate4)))
head(eliminate)
dim(eliminate)
# 3128    2
turan_ploidy= data.frame(eliminate)
turan_ploidy= eliminate[complete.cases(eliminate),]
head(turan_ploidy)
colnames(turan_ploidy)= c('id','predicted_ploidy')
turan_ploidy$id= as.character(turan_ploidy$id)
dim(turan_ploidy)  
# 1564    2

saveRDS(turan_ploidy, file = "./turan/data/processed/rds/turan_ploidy.rds")
###########################################################
rm(list = ls())
source('./turan/scripts/00_Source.R')

turan1= read.table('./turan/data/processed/ginkgo/1/SegNorm', header = T)
chrx= turan1[,c(1:3)]
turan1= turan1[,-c(1:3)]
turan2= read.table('./turan/data/processed/ginkgo/2/SegNorm', header = T)
turan2= turan2[,-c(1:3)]
turan3= read.table('./turan/data/processed/ginkgo/3/SegNorm', header = T)
turan3= turan3[,-c(1:3)]
turan4= read.table('./turan/data/processed/ginkgo/4/SegNorm', header = T)
turan4= turan4[,-c(1:3)]

turan= data.frame(turan1, turan2, turan3, turan4)
head(turan)[1:6,1:6]
dim(turan)
# 5578 1564    
turan_SegNorm= data.frame(chrx, turan)
tail(turan_SegNorm)[1:6,1:6]

turan_SegNorm$CHR=as.character(turan_SegNorm$CHR)
saveRDS(turan_SegNorm, file = "./turan/data/processed/rds/turan_SegNorm.rds")
####################################################################
rm(list = ls())
source('./turan/scripts/00_Source.R')

raw1 = read.table('./turan/data/processed/ginkgo/1/data', header=TRUE, sep="\t")
raw2 = read.table('./turan/data/processed/ginkgo/2/data', header=TRUE, sep="\t")
raw3 = read.table('./turan/data/processed/ginkgo/3/data', header=TRUE, sep="\t")
raw4 = read.table('./turan/data/processed/ginkgo/4/data', header=TRUE, sep="\t")

turan_raw= cbind(raw1,raw2,raw3,raw4)
dim(turan_raw)
head(turan_raw)[1:6,1:6]
dim(turan_raw)
# 5578 1564

saveRDS(turan_raw, file = "./turan/data/processed/rds/turan_raw.rds")
####################################################################
rm(list = ls())
source('./turan/scripts/00_Source.R')

our1= read.table('./turan/data/processed/ginkgo/1/CNV1')
colnames(our1)= NULL
rownames(our1)= NULL
our2= read.table('./turan/data/processed/ginkgo/2/CNV1')
colnames(our2)= NULL
rownames(our2)= NULL
our3= read.table('./turan/data/processed/ginkgo/3/CNV1')
colnames(our3)= NULL
rownames(our3)= NULL
our4= read.table('./turan/data/processed/ginkgo/4/CNV1')
colnames(our4)= NULL
rownames(our4)= NULL
turan_CNV1= rbindlist(list(our1, our2,our3,our4))
head(turan_CNV1)
turan_CNV1= data.frame(turan_CNV1)
dim(turan_CNV1)
# 38526     5

head(turan_CNV1)
colnames(turan_CNV1)=c('chr','start','end','id','cnv')
turan_CNV1$chr= as.character(turan_CNV1$chr)
turan_CNV1$id= as.character(turan_CNV1$id)

saveRDS(turan_CNV1, file = "./turan/data/processed/rds/turan_CNV1.rds")
############################################################################
rm(list = ls())
source('./turan/scripts/00_Source.R')

turan1= read.table('./turan/data/processed/ginkgo/1/SegCopy', header = T)
chrx= turan1[,c(1:3)]
turan1= turan1[,-c(1:3)]
turan2= read.table('./turan/data/processed/ginkgo/2/SegCopy', header = T)
turan2= turan2[,-c(1:3)]
turan3= read.table('./turan/data/processed/ginkgo/3/SegCopy', header = T)
turan3= turan3[,-c(1:3)]
turan4= read.table('./turan/data/processed/ginkgo/4/SegCopy', header = T)
turan4= turan4[,-c(1:3)]

turan= data.frame(turan1, turan2, turan3, turan4)
head(turan)[1:6,1:6]
dim(turan)
# 5578 1564    
turan_SegCopy= data.frame(chrx, turan)
tail(turan_SegCopy)[1:6,1:6]

turan_SegCopy$CHR=as.character(turan_SegCopy$CHR)
saveRDS(turan_SegCopy, file = "./turan/data/processed/rds/turan_SegCopy.rds")