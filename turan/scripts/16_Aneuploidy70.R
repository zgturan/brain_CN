source('./turan/scripts/00_Source.R')

our <- readRDS("./turan/data/processed/rds/turan_CNV1.rds")
remove_samp=c("AB01" ,"AB02", "AB03" ,"AB04", "AB05", "AB18" ,"AB19" ,"AB20", "AB21" ,"AB22",
              "UU_5603_13_S21", "UU_5603_14_S22" ,"UU_5603_15_S23", "UU_5603_16_S24" ,"UU_5603_17_S25" ,
              "UU_5603_18_S26", "UU_5603_19_S27","UU_5603_20_S28" ,"UU_5603_21_S29" ,"UU_5603_22_S30" ,
              "UU_5603_23_S31" ,"UU_5603_24_S32")
our=our[!our$id%in%remove_samp,]
dim(our)
# 38318     5
length(unique(our$id))
# 1542
###########################################################
head(our)
colnames(our)= c('chr','start','end','id','cnv')

ourx= our[!our$chr %in% c('chrX','chrY'),]
dim(ourx)
# 34452     5
head(ourx)

ourxx= unique(ourx$id)

qq6= rbind()
for (y in 1:length(ourxx)){
  print(y)
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

dim(qq6)
# 33220     3

colnames(qq6)=c('id', 'chr', 'cover')
qq6= data.frame(qq6)
qq6$id= as.character(qq6$id)
qq6$chr= as.character(qq6$chr)
qq6$cover = as.numeric(as.character(qq6$cover))
head(qq6)
###########################################################
chrlength=read.table('./turan/data/processed/txt/lengths')
chrlength$V1= as.character(chrlength$V1)
colnames(chrlength)=c('chr', 'length')
head(chrlength)
chrlength$length= (chrlength$length*70)/100

ourxy= merge(qq6, by.x='chr', chrlength, by.y='chr')
head(ourxy)

ourx3= ourxy[ourxy$cover >= ourxy$length,]
head(ourx3)
dim(ourx3)
# 13479     4

ourx3$chr= as.character(ourx3$chr)

ourx4=ourx3
head(ourx4)
resx=rbind()
for (i in 1:dim(ourx4)[1]){
       aa=   unique(ourx4$id)[i]
       bb=   as.character(ourx4[ourx4$id%in%aa,'chr'])
       bb2=  length(bb)
       dd2=  c(aa,bb2)
       resx= rbind(resx,dd2)
}
dim(resx)
# 13479     2

head(resx)
resx=data.frame(resx)
head(resx)
resx$X2= as.numeric(as.character(resx$X2))
resx$X1= as.character(resx$X1)

resxx=resx[resx$X2 > 2,]
head(resxx)
resx3= resxx$X1
length(resx3)
# 799

saveRDS(resx3, file='./turan/data/processed/rds/cover70per.rds')
