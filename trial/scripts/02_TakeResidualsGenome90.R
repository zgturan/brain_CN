variation= as.numeric(args[1])
outpath= file.path("./trial/results", paste0("genome_wide_",variation))

source('./trial/scripts/03_Source.R')

loca <- readRDS("./vandenBos/data/processed/rds/locations.rds")
loca$CHR= as.character(loca$CHR)

SegNorm <- readRDS("./turan/data/processed/rds/turan_raw.rds")
SegNorm= sweep(SegNorm+1, 2, colMeans(SegNorm+1), '/')


incz <- readRDS("./turan/data/processed/rds/cover_cells.rds")
remove_samp=c("AB01" ,"AB02", "AB03" ,"AB04", "AB05", "AB18" ,"AB19" ,"AB20", "AB21" ,"AB22",
              "UU_5603_13_S21", "UU_5603_14_S22" ,"UU_5603_15_S23", "UU_5603_16_S24" ,"UU_5603_17_S25" ,
              "UU_5603_18_S26", "UU_5603_19_S27","UU_5603_20_S28" ,"UU_5603_21_S29" ,"UU_5603_22_S30" ,
              "UU_5603_23_S31" ,"UU_5603_24_S32")

incz2= setdiff(incz, remove_samp)
length(incz2)

SegNorm= SegNorm[,colnames(SegNorm)%in%incz2]
dim(SegNorm)
# 5578 1337

SegNorm= cbind(loca, SegNorm)
dim(SegNorm)
# 5578 1340

nn= ncol(SegNorm)-3

pcxx= c()
res=c()
for (i in 1:nn){
        print(i)
        SegNorm2= SegNorm
        SegNorm3= SegNorm2[,-c(1:3)]
        id= colnames(SegNorm3)[i]
        SegNorm4= SegNorm3[,!(colnames(SegNorm3)%in%id)]
        pc_rm = prcomp(SegNorm4, scale. = TRUE)
        
        qq= summary(pc_rm)
        qq2=qq$importance[2,]
        qq3= which(cumsum(qq2)> variation)[1]
        qq4= cumsum(qq2)[(cumsum(qq2)> variation)][1]
        
        pcxx= rbind(pcxx, cbind(id, qq3, qq4))
        pcrm2= pc_rm$x[,1:qq3]
        partial= residuals(lm(SegNorm2[,colnames(SegNorm2)%in%id] ~ pcrm2))
        res=cbind(res, partial)}
dim(SegNorm)

new_mat= cbind(SegNorm[,1:3], res)
colnames(new_mat)=colnames(SegNorm)
new_mat2= new_mat
datax= new_mat2[,-c(1:3)]

saveRDS(datax, file = file.path(outpath, paste0('pca_genomewide', '_', variation,'.rds')))


rownames(pcxx)= NULL
colnames(pcxx)= c('id', 'PC','variance')
pcxx=data.frame(pcxx)

OUT <- createWorkbook()
addWorksheet(OUT, "trial_svd")
writeData(OUT, sheet = "trial_svd", x = pcxx)
saveWorkbook(OUT, file.path(outpath, paste0('pc_variance_genomewide', '_', variation,'.xlsx')))

saveRDS(pcxx, file.path(outpath, paste0('pc_variance_genomewide', '_', variation,'.rds')))
