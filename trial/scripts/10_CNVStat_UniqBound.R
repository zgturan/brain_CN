# args <- commandArgs(trailingOnly = T) 
# variation= as.numeric(args[1])
variation= 0.9
outpath= file.path("./trial/results", paste0("genome_wide_", variation,'/','ginkgo/'))

turan_CNV1_svd= read.table(paste0(outpath, 'CNV1'))
colnames(turan_CNV1_svd)= c('chr','start','end','id','cnv')
turan_CNV1_svd$chr= as.character(turan_CNV1_svd$chr)
turan_CNV1_svd$id= as.character(turan_CNV1_svd$id)
CNV1= turan_CNV1_svd

exc3 <- readRDS(paste0(outpath, "remaning_cells_genome.rds"))
CNV1= CNV1[(CNV1$id%in%exc3),]
length(unique(CNV1$id))
# 1301
number_of_CN= CNV1[!(CNV1$chr%in%c("chrX","chrY")),]
dim(number_of_CN)
# 1298    5

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
# 8  7
number_of_CNx7= number_of_CNx6[,1:5]
head(number_of_CNx7)

saveRDS(number_of_CNx7, file = './trial/results/genome_wide_0.9/unique_bound_aneup.rds')

unique_bound=  number_of_CN[,c('chr', 'start','end')]
unique_bound2= data.frame(table(unique_bound))
unique_bound3= unique_bound2[unique_bound2$Freq%in%1,]
dim(unique_bound3)
# 1225    4

saveRDS(unique_bound2, file = paste0(outpath, "unique_bound2_genome.rds"))
saveRDS(unique_bound3, file = paste0(outpath, "unique_bound3_genome.rds"))