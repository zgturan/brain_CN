variation=0.9
outpath= file.path("./trial/results", paste0("genome_wide_", variation,'/', 'ginkgo/'))

turan_Clouds <- readRDS(paste0(outpath, "turan_clouds_genome.rds"))
turan_SegNorm <- readRDS("./turan/data/processed/rds/turan_SegNorm.rds")
pos= turan_SegNorm[,c(1:3)]
turan_Clouds2=data.frame(pos, turan_Clouds)

number_of_CN5 <- readRDS(paste0(outpath, "number_of_CN5_genome.rds"))
###########################################################
number_of_CN6= rbind()
for (x in 1:dim(number_of_CN5)[1]){
  cnv_value=  turan_Clouds2[(colnames(turan_Clouds2)%in%number_of_CN5$id[x])]
  cnv_value2= data.frame(turan_Clouds2[,1:3], cnv_value)
  cnv=        number_of_CN5$cnv[x]
  chr=        cnv_value2[cnv_value2$CHR%in%number_of_CN5$chr[x],]
  start_pos=  chr[(chr$START%in%number_of_CN5$start[x]),]
  end_pos=    chr[(chr$END%in%number_of_CN5$end[x]),]
  cnv_ss=     cnv-(cnv_value[as.numeric(rownames(start_pos)[1]):as.numeric(rownames(end_pos)[1]),])
  cnv_ss_t= mean(cnv_ss)/sd(cnv_ss)
  number_of_CN6= rbind(number_of_CN6, cnv_ss_t)
 }

number_of_CN7= cbind(number_of_CN5, number_of_CN6)
turan_cnv_stat <- readRDS(paste0(outpath, "turan_cnv_stat_genome.rds"))
dim(turan_cnv_stat)
# 559   8
head(turan_cnv_stat)

turan_cnv_stat[,ncol(turan_cnv_stat)+1]= number_of_CN7[,ncol(number_of_CN7)]
colnames(turan_cnv_stat)[ncol(turan_cnv_stat)]=c('eff_siz')
head(turan_cnv_stat)
saveRDS(turan_cnv_stat, file = paste0(outpath, "turan_cnv_stat_check_genome.rds"))