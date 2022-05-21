# args <- commandArgs(trailingOnly = T)
# variation= as.numeric(args[1])
variation= 0.9
outpath= file.path("/trial/results", paste0("genome_wide_", variation,'/', 'ginkgo/'))

source('/turan/scripts/00_Source.R')

set.seed(123)
thres_svd_matrix <- readRDS(paste0(outpath, "thres_svd_matrix.rds"))

thres_svd_matrix= thres_svd_matrix[!duplicated(thres_svd_matrix),]
thres_svd_matrix$Case_ID= as.factor(paste0('indiv_',thres_svd_matrix$Case_ID))
thres_svd_matrix$Brain_region= as.factor(thres_svd_matrix$Brain_region)
thres_svd_matrix$Sex= as.factor(thres_svd_matrix$Sex)
thres_svd_matrix$Diagnosis= as.factor(thres_svd_matrix$Diagnosis)
head(thres_svd_matrix)


cutoff2_glmm_total = try(glmmadmb(formula = Freq ~ chr + Diagnosis + coverage,
                                      random = ~1|Case_ID,
                                      data=thres_svd_matrix,
                                      zeroInflation = T,
                                     
                                      family = 'nbinom1',
                                      extra.args = '-ndi 10000000'), silent=T)

glmmVars = grep('_glmm_', ls(), val=T)

sapply(glmmVars, function(x){
  assign(paste("s", x, sep='_'), summary(get(x)), envir = .GlobalEnv)})

aa= s_cutoff2_glmm_total$coefficients[,4]
aa[aa <= 0.05]

table(round(as.numeric(aa),2))

