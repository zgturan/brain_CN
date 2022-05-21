source('./turan/scripts/00_Source.R')

remove_samp=c("AB01" ,"AB02", "AB03" ,"AB04", "AB05", "AB18" ,"AB19" ,"AB20", "AB21" ,"AB22",
              "UU_5603_13_S21", "UU_5603_14_S22" ,"UU_5603_15_S23", "UU_5603_16_S24" ,"UU_5603_17_S25" ,
              "UU_5603_18_S26", "UU_5603_19_S27","UU_5603_20_S28" ,"UU_5603_21_S29" ,"UU_5603_22_S30" ,
              "UU_5603_23_S31" ,"UU_5603_24_S32")
eliminate <- readRDS("./turan/data/processed/rds/turan_ploidy.rds")
head(eliminate)
eliminate=eliminate[!eliminate$id%in%remove_samp,]
dim(eliminate)
# 1542    2

turan_segstat_bedreads <- readRDS("./turan/data/processed/rds/turan_segstat.rds")
turan_segstat_bedreads= turan_segstat_bedreads[!turan_segstat_bedreads$id%in%remove_samp,]
dim(turan_segstat_bedreads)
# 1542    3

turan_segstat_bedreads= turan_segstat_bedreads[turan_segstat_bedreads$bed_reads >= 50000,]
dim(turan_segstat_bedreads)
# 1337    3


saveRDS(turan_segstat_bedreads$id, file = "./turan/data/processed/rds/cover_cells.rds")

eliminate= eliminate[eliminate$id%in%turan_segstat_bedreads$id,]
dim(eliminate)
# 1337    2

eliminatex= eliminate[eliminate$predicted_ploidy<=2,]
dim(eliminatex)
# 719   2

eliminatexx= eliminatex[eliminatex$predicted_ploidy>=1.9,]
dim(eliminatexx)
# 611   2

cover70per <- readRDS("./turan/data/processed/rds/cover70per.rds")
segstatxx2= eliminatexx[!(eliminatexx$id%in%cover70per),]
dim(segstatxx2)
# 588   2
saveRDS(segstatxx2, file = "./turan/data/processed/rds/remaning_cells.rds")

turan_segstat_bedreads <- readRDS("./turan/data/processed/rds/turan_segstat.rds")
segstatxx3= turan_segstat_bedreads[turan_segstat_bedreads$id%in%segstatxx2$id,]
dim(segstatxx3)
# 588   3
saveRDS(segstatxx3, file = "./turan/data/processed/rds/remaning_cellsx.rds")