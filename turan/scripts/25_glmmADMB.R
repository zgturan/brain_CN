source('./turan/scripts/00_Source.R')

set.seed(123)
thres1_matrix <- readRDS("./turan/data/processed/rds/thres1_matrix.rds")
head(thres1_matrix)
dim(thres1_matrix)

thres1_matrix= thres1_matrix[!duplicated(thres1_matrix),]
dim(thres1_matrix)
head(thres1_matrix)

thres1_matrix$Case_ID= as.factor(paste0('indiv_',thres1_matrix$Case_ID))
thres1_matrix$Brain_region= as.factor(thres1_matrix$Brain_region)
thres1_matrix$Sex= as.factor(thres1_matrix$Sex)
thres1_matrix$Diagnosis= as.factor(thres1_matrix$Diagnosis)

cutoff2_glmm_total = try(glmmadmb(formula = Freq ~ chr + Diagnosis + coverage,
                                      random = ~1|Case_ID,
                                      data=thres1_matrix,
                                      zeroInflation = T,
                                      family = 'nbinom1',
                                      extra.args = '-ndi 1000000'), silent=T)

glmmVars = grep('_glmm_', ls(), val=T)
glmmVars

sapply(glmmVars, function(x){
  assign(paste("s", x, sep='_'), summary(get(x)), envir = .GlobalEnv)})

aa= s_cutoff2_glmm_total$coefficients[,4]
aa[aa <= 0.05]

table(round(as.numeric(aa),2))