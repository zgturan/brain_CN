source('./turan/scripts/00_Source.R')

namex= read.table('./turan/scripts/file_name.txt')[,1]
namex=as.character(namex)
length(namex)
# 1564

iod <- readRDS("./turan/data/processed/rds/turan_segstat.rds")
dim(iod)
# 1564    3

blank= c("AB01" ,"AB02", "AB03" ,"AB04", "AB05", "AB18" ,"AB19" ,"AB20", "AB21" ,"AB22")
length(blank)
# 10
facs= c( "UU_5603_13_S21", "UU_5603_14_S22" ,"UU_5603_15_S23", "UU_5603_16_S24" ,"UU_5603_17_S25" ,
        "UU_5603_18_S26", "UU_5603_19_S27","UU_5603_20_S28" ,"UU_5603_21_S29" ,"UU_5603_22_S30" ,
        "UU_5603_23_S31" ,"UU_5603_24_S32")
length(facs)
# 12
lcm= setdiff(iod$id, c(blank,facs))
length(lcm)
# 1542

alphax= iod$id
iod$id= mgsub(iod$id, blank, rep('Blank',length(blank)))
iod$id= mgsub(iod$id, facs, rep('FACS',length(facs)))
iod$id= mgsub(iod$id, lcm, rep('LCM',length(lcm)))

turan_iod=iod
saveRDS(turan_iod, file ='./turan/data/processed/rds/turan_iod_q60.rds')