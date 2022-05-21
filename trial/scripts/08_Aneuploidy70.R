# args <- commandArgs(trailingOnly = T)
# variation= as.numeric(args[1])
variation=0.9
outpath= file.path("/trial/results", paste0("genome_wide_", variation,'/','ginkgo/'))

turan_CNV1_svd= read.table(paste0(outpath, 'CNV1'))
colnames(turan_CNV1_svd)= c('chr','start','end','id','cnv')
turan_CNV1_svd$chr= as.character(turan_CNV1_svd$chr)
turan_CNV1_svd$id= as.character(turan_CNV1_svd$id)

our=turan_CNV1_svd
colnames(our)= c('chr','start','end','id','cnv')
ourx= our[!our$chr %in% c('chrX','chrY'),]
ourxx= unique(ourx$id)

qq6= rbind()
for (y in 1:length(ourxx)){
  # print(y)
  for (i in 1:22){
    idx= ourxx[y]
    qq=  ourx[ourx$id %in% idx,]
    qq2= qq[qq$chr %in% paste0('chr',i),]
    qq3= qq2[,c('chr','start', 'end')]
    qq3[,4]= qq3$end-qq3$start+1
    qq4= sum(qq3[,4])
    qq5= c(idx, paste0('chr',i), qq4)
    qq6= rbind(qq6, qq5)
  }}

colnames(qq6)=c('id', 'chr', 'cover')
qq6= data.frame(qq6)
qq6$id= as.character(qq6$id)
qq6$chr= as.character(qq6$chr)
qq6$cover = as.numeric(as.character(qq6$cover))
###########################################################
chrlength=read.table('./turan/data/processed/txt/lengths')
chrlength$V1= as.character(chrlength$V1)
colnames(chrlength)=c('chr', 'length')
chrlength$length= (chrlength$length*70)/100

ourxy= merge(qq6, by.x='chr', chrlength, by.y='chr')
ourx3= ourxy[ourxy$cover >= ourxy$length,]
ourx3$chr= as.character(ourx3$chr)

ourx4=ourx3
resx=rbind()
for (i in 1:dim(ourx4)[1]){
       aa=   unique(ourx4$id)[i]
       bb=   as.character(ourx4[ourx4$id%in%aa,'chr'])
       bb2=  length(bb)
       dd2=  c(aa,bb2)
       resx= rbind(resx,dd2)
}

resx=data.frame(resx)
resx$X2= as.numeric(as.character(resx$X2))
resx$X1= as.character(resx$X1)
resxx=resx[resx$X2>2,]
resx3= resxx$X1

saveRDS(resx3, file= paste0(outpath, 'cover70per_genome.rds'))