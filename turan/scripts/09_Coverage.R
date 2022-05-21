source('./turan/scripts/00_Source.R')

namex= read.table('./turan/scripts/file_name.txt')[,1]
namex=as.character(namex)
length(namex)
# 1564

cover= read.table('./turan/data/processed/coverage/txt/07_Coverage.txt',sep = ':', header=F)
head(cover)
dim(cover)
# 1564    2

colnames(cover)= c('id','coverage')
cover$id= as.character(cover$id)
cover$id=gsub('.txt','',cover$id)
head(cover)


blank= c("AB01" ,"AB02", "AB03" ,"AB04", "AB05", "AB18" ,"AB19" ,"AB20", "AB21" ,"AB22")
length(blank)
# 10
facs= c( "UU_5603_13_S21", "UU_5603_14_S22" ,"UU_5603_15_S23", "UU_5603_16_S24" ,"UU_5603_17_S25" ,
        "UU_5603_18_S26", "UU_5603_19_S27","UU_5603_20_S28" ,"UU_5603_21_S29" ,"UU_5603_22_S30" ,
        "UU_5603_23_S31" ,"UU_5603_24_S32")
length(facs)
# 12

lcm= setdiff(cover$id, c(blank,facs))
length(lcm)
# 1542

alphax= cover$id
cover$id= mgsub(cover$id, blank, rep('Blank',length(blank)))
cover$id= mgsub(cover$id, facs,  rep('FACS',length(facs)))
cover$id= mgsub(cover$id, lcm,   rep('LCM',length(lcm)))

turan_cover=cover
saveRDS(turan_cover, file ='./turan/data/processed/rds/Coverage_q60.rds')