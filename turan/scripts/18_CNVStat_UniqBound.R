source('./turan/scripts/00_Source.R')

turan_CNV1 <- readRDS("./turan/data/processed/rds/turan_CNV1.rds")
CNV1= turan_CNV1
dim(CNV1)
# 38526     5
head(CNV1)

remaning_cells <- readRDS("./turan/data/processed/rds/remaning_cells.rds")
CNV1= CNV1[(CNV1$id%in%remaning_cells$id),]
number_of_CN= CNV1[!(CNV1$chr%in%c("chrX","chrY")),]
dim(number_of_CN)
# 3521     5
head(number_of_CN)

chrlength=read.table('./turan/data/processed/txt/lengths')
chrlength2= data.frame(chrlength$V1, rep(1,24), chrlength$V2)
colnames(chrlength2)= c('chr', 'start','end')
chrlength2$chr= as.character(chrlength2$chr)
head(chrlength2)

number_of_CNx5= rbind()
for (i in 1:nrow(number_of_CN)){
       number_of_CNx= number_of_CN[number_of_CN$start%in%1,]
       number_of_CNx2= number_of_CNx[i,]
       number_of_CNx3= c((number_of_CNx2$chr %in% chrlength2$chr) , (number_of_CNx2$end %in% chrlength2$end))
       number_of_CNx2[,6]=number_of_CNx3[1]
       number_of_CNx2[,7]=number_of_CNx3[2]
       number_of_CNx5= rbind(number_of_CNx5, number_of_CNx2)}

number_of_CNx6= number_of_CNx5[ ((number_of_CNx5$V6%in%TRUE) & (number_of_CNx5$V7%in%TRUE)), ]
dim(number_of_CNx6)
# 99  7
number_of_CNx7= number_of_CNx6[,1:5]
head(number_of_CNx7)

saveRDS(number_of_CNx7, file = './turan/data/processed/rds/unique_bound_aneup.rds')

unique_bound=  number_of_CN[,c('chr', 'start','end')]
unique_bound2= data.frame(table(unique_bound))
unique_bound3= unique_bound2[unique_bound2$Freq%in%1,]
dim(unique_bound3)
# 662     4

saveRDS(unique_bound2, file = './turan/data/processed/rds/unique_bound2.rds')
saveRDS(unique_bound3, file = './turan/data/processed/rds/unique_bound3.rds')
