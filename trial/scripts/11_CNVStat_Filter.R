variation=0.9
outpath= file.path("./trial/results", paste0("genome_wide_", variation,'/', 'ginkgo/'))
source('./turan/scripts/00_Source.R')

turan_CNV1_svd= read.table(paste0(outpath, 'CNV1'))
colnames(turan_CNV1_svd)= c('chr','start','end','id','cnv')
turan_CNV1_svd$chr= as.character(turan_CNV1_svd$chr)
turan_CNV1_svd$id= as.character(turan_CNV1_svd$id)

exc2 <- readRDS(paste0(outpath, "remaning_cells_genome.rds"))
length(exc2)
# 1301
turan_CNV1_svd= turan_CNV1_svd[(turan_CNV1_svd$id%in%exc2),]
CNV1= turan_CNV1_svd

CNV1= CNV1[(CNV1$id%in%exc2),]
CNV1_chrx= CNV1[CNV1$chr%in%"chrX",]
CNV1_chrx[,6]= (CNV1_chrx$end - CNV1_chrx$start)+1
colnames(CNV1_chrx)[6]='width'

number_of_CN= CNV1[!(CNV1$chr%in%c("chrX","chrY")),]
dim(number_of_CN)
# 1298   5
########################################################################
unique_bound3 <- readRDS(paste0(outpath, "unique_bound3_genome.rds"))
unique_bound3$chr= as.character(unique_bound3$chr)
unique_bound3$start= as.numeric(as.character(unique_bound3$start))
unique_bound3$end= as.numeric(as.character(unique_bound3$end))
dim(unique_bound3)
# 1225   4

number_of_CN2=rbind()
for(y in 1:dim(unique_bound3)[1]){
  cnv_chrs=      number_of_CN[(number_of_CN$chr%in%unique_bound3$chr[y])&(number_of_CN$start%in%unique_bound3$start[y])&
                              (number_of_CN$end%in%unique_bound3$end[y]),]
  number_of_CN2=rbind(number_of_CN2,cnv_chrs)
}
dim(number_of_CN2)
# 1225   5

unique_bound_aneup <- readRDS("./trial/results/genome_wide_0.9/unique_bound_aneup.rds")
dim(unique_bound_aneup)
# 8  5
table(unique_bound_aneup$chr)

aaa= data.frame(rbindlist(list(number_of_CN2, unique_bound_aneup)))
head(aaa)
dim(aaa)
# 1233   5

aaa2= aaa[!duplicated(aaa),]
dim(aaa2)
# 1228    5

number_of_CN3= aaa2[aaa2$cnv>0 & aaa2$cnv<4,]
dim(number_of_CN3)
# 998   5

number_of_CN3[,6]= (number_of_CN3$end - number_of_CN3$start)+1
colnames(number_of_CN3)[6]='width'
colnames(number_of_CN3)

number_of_CN4= number_of_CN3[number_of_CN3$width>=10000000,]
dim(number_of_CN4)
# 461   6

table(number_of_CN4$cnv)

rownames(number_of_CN4)= NULL
colnames(number_of_CN4)= NULL
rownames(CNV1_chrx)= NULL
colnames(CNV1_chrx)= NULL

number_of_CN5= data.frame(rbindlist(list(number_of_CN4, CNV1_chrx)))
colnames(number_of_CN5)= colnames(number_of_CN3)
saveRDS(number_of_CN5, file = paste0(outpath, 'number_of_CN5_genome.rds'))
########################################################################
turan_Clouds <- readRDS(paste0(outpath, 'turan_clouds_genome.rds'))
turan_SegNorm = read.table(paste0(outpath, 'SegNorm'), header = T)
pos= turan_SegNorm[,c(1:3)]
turan_Clouds2=data.frame(pos, turan_Clouds)
###########################################################
number_of_CN6=rbind()
for (x in 1:dim(number_of_CN5)[1]){
  cnv_value=  turan_Clouds2[(colnames(turan_Clouds2)%in%number_of_CN5$id[x])]
  cnv_value2= data.frame(pos, cnv_value)
  chr=        cnv_value2[cnv_value2$CHR%in%number_of_CN5$chr[x],]
  start_pos=  chr[(chr$START%in%number_of_CN5$start[x]),]
  end_pos=    chr[(chr$END%in%number_of_CN5$end[x]),]
  cnv_mean=   mean(cnv_value[as.numeric(rownames(start_pos)[1]):as.numeric(rownames(end_pos)[1]),])
  cnv_sd=     sd(cnv_value[as.numeric(rownames(start_pos)[1]):as.numeric(rownames(end_pos)[1]),])
  aaa= c(cnv_mean, cnv_sd)
  number_of_CN6=rbind(number_of_CN6, aaa)}

head(number_of_CN5)
head(number_of_CN6)
number_of_CN5[,7:8]= number_of_CN6[,1:2]
colnames(number_of_CN5)[7:8]= c('cn_mean','cn_sd')

saveRDS(number_of_CN5, file = paste0(outpath, 'turan_cnv_stat_genome.rds'))