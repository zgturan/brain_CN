source('./turan/scripts/00_Source.R')

turan_CNV1 <- readRDS("./turan/data/processed/rds/turan_CNV1.rds")
CNV1= turan_CNV1
dim(CNV1)
# 38526     5
head(CNV1)

remaning_cells <- readRDS("./turan/data/processed/rds/remaning_cells.rds")
CNV1= CNV1[(CNV1$id%in%remaning_cells$id),]

CNV1_chrx= CNV1[CNV1$chr%in%"chrX",]
CNV1_chrx[,6]= (CNV1_chrx$end - CNV1_chrx$start)+1
colnames(CNV1_chrx)[6]='width'

number_of_CN= CNV1[!(CNV1$chr%in%c("chrX","chrY")),]
dim(number_of_CN)
# 3521     5
########################################################################
unique_bound3 <- readRDS("./turan/data/processed/rds/unique_bound3.rds")
head(unique_bound3)
unique_bound3$chr= as.character(unique_bound3$chr)
unique_bound3$start= as.numeric(as.character(unique_bound3$start))
unique_bound3$end= as.numeric(as.character(unique_bound3$end))
dim(unique_bound3)

number_of_CN2=rbind()
for(y in 1:dim(unique_bound3)[1]){
  cnv_chrs=      number_of_CN[(number_of_CN$chr%in%unique_bound3$chr[y])&(number_of_CN$start%in%unique_bound3$start[y])&
                              (number_of_CN$end%in%unique_bound3$end[y]),]
  number_of_CN2=rbind(number_of_CN2,cnv_chrs)
}
dim(number_of_CN2)
# 662     5
head(number_of_CN2)

unique_bound_aneup <- readRDS("./turan/data/processed/rds/unique_bound_aneup.rds")
dim(unique_bound_aneup)
# 99  5
table(unique_bound_aneup$chr)

aaa= data.frame(rbindlist(list(number_of_CN2, unique_bound_aneup)))
head(aaa)
dim(aaa)
# 761   5

aaa2= aaa[!duplicated(aaa),]
dim(aaa2)
# 757   5

number_of_CN3= aaa2[aaa2$cnv>0 & aaa2$cnv<4,]
dim(number_of_CN3)
# 691    5

number_of_CN3[,6]= (number_of_CN3$end - number_of_CN3$start)+1
colnames(number_of_CN3)[6]='width'
colnames(number_of_CN3)

number_of_CN4= number_of_CN3[number_of_CN3$width>=10000000,]
dim(number_of_CN4)
# 517   6

rownames(number_of_CN4)= NULL
colnames(number_of_CN4)= NULL
rownames(CNV1_chrx)= NULL
colnames(CNV1_chrx)= NULL

number_of_CN5= data.frame(rbindlist(list(number_of_CN4, CNV1_chrx)))
dim(number_of_CN5)
# 1026   6  
colnames(number_of_CN5)= colnames(number_of_CN3)

saveRDS(number_of_CN5, file = "./turan/data/processed/rds/number_of_CN5.rds")
########################################################################
turan_Clouds <- readRDS("./turan/data/processed/rds/turan_clouds.rds")
head(turan_Clouds)

turan_SegNorm <- readRDS("./turan/data/processed/rds/turan_SegNorm.rds")
pos= turan_SegNorm[,c(1:3)]

turan_Clouds2=data.frame(pos, turan_Clouds)
turan_Clouds2[1:6,1:6]
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

saveRDS(number_of_CN5, file = "./turan/data/processed/rds/turan_cnv_stat.rds")