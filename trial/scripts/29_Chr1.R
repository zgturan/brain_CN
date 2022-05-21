source('./turan/scripts/00_Source.R')

trial <- readRDS("./trial/results/genome_wide_0.9/ginkgo/turan_clouds_genome.rds")
head(trial)[1:6,1:6]

mcconnell_SegNorm <- readRDS("./mcconnell/data/processed/rds/mcconnell_SegNorm.rds")
pos= mcconnell_SegNorm[,c(1:3)]
clouds2= data.frame(as.character(pos$CHR), trial)
head(clouds2)
colnames(clouds2)[1]='chr'
clouds2$chr=as.character(clouds2$chr)
unique(clouds2$chr)
clouds3=clouds2[clouds2$chr%in%'chr1',]

thres_svd <- readRDS("./trial/results/genome_wide_0.9/ginkgo/remaning_cells_genome.rds")
length(thres_svd)
# 1301

raw_male= clouds3[,colnames(clouds3)%in%thres_svd]
dim(raw_male)
# 440 1301

raw_male_median= apply(raw_male, 2, median)
head(raw_male_median)


saveRDS(raw_male_median, file = './trial/results/genome_wide_0.9/ginkgo/trial_chr1_median.rds')
