source('./turan/scripts/00_Source.R')

iod <- readRDS("./turan/data/processed/rds/turan_segstat.rds")
dim(iod)
iod= iod[,-2]
head(iod)

exc= c("AB01" ,"AB02", "AB03" ,"AB04", "AB05", "AB18" ,"AB19" ,"AB20", "AB21" ,"AB22","UU_5603_13_S21", 
       "UU_5603_14_S22" ,"UU_5603_15_S23", "UU_5603_16_S24" ,"UU_5603_17_S25" ,
       "UU_5603_18_S26", "UU_5603_19_S27","UU_5603_20_S28" ,"UU_5603_21_S29" ,"UU_5603_22_S30" ,
       "UU_5603_23_S31" ,"UU_5603_24_S32")
length(exc)
# 22

iod=iod[!(iod$id%in%exc),]
dim(iod)
# 1542    3
samp_info=data.frame(read_excel('./turan/data/processed/txt/Table_2.xlsx'))
samp_info= samp_info[,c('Case_ID','fastq','Diagnosis','Brain_region')]
samp_info$fastq=as.character(samp_info$fastq)
samp_info$Brain_region=as.character(samp_info$Brain_region)
head(samp_info)

turan_cnv_statx= merge(iod, by.x='id', samp_info, by.y='fastq')
head(turan_cnv_statx)

cover= read.table('./turan/data/processed/coverage/txt/07_Coverage.txt',sep = ':', header=F)
head(cover)
dim(cover)
# 1564    2
colnames(cover)= c('id','coverage')
cover$id= as.character(cover$id)
cover$id=gsub('.txt','',cover$id)
head(cover)

turan_cnv_statxa= merge(turan_cnv_statx, by.x='id', cover, by.y='id')
head(turan_cnv_statxa)

turan_cnv_statxa$Case_ID= gsub('_EC','',turan_cnv_statxa$Case_ID)
turan_cnv_statxa$Case_ID= gsub('_CA1','',turan_cnv_statxa$Case_ID)
turan_cnv_statxa$Case_ID= gsub('_CB','',turan_cnv_statxa$Case_ID)
turan_cnv_statxa$Case_ID= gsub('_CA3','',turan_cnv_statxa$Case_ID)

thres1_matrix= turan_cnv_statxa
thres1_matrix$Case_ID= as.factor(paste0('indiv_',thres1_matrix$Case_ID))
thres1_matrix$Brain_region= as.factor(thres1_matrix$Brain_region)
thres1_matrix$Diagnosis= as.factor(thres1_matrix$Diagnosis)
head(thres1_matrix)

hist(thres1_matrix$dispersion)

set.seed(123)
cutoff2_glmm_total = try(glmmadmb(formula = dispersion ~ Diagnosis + coverage,
                                      random = ~1|Case_ID,
                                      data=thres1_matrix,
                                    # zeroInflation = T,
                                      family = 'gamma',
                                      extra.args = '-ndi 1000000'), silent=T)
glmmVars = grep('_glmm_', ls(), val=T)


sapply(glmmVars, function(x){
  assign(paste("s", x, sep='_'), summary(get(x)), envir = .GlobalEnv)})


aa= s_cutoff2_glmm_total$coefficients[,4]
aa[aa <= 0.05]


