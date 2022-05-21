# female
source('./turan/scripts/00_Source.R')

female_id <- readRDS("./turan/data/processed/rds/female_id.rds")
thres2 <- readRDS("./turan/data/processed/rds/remaning_cells.rds")
thres2_female= thres2[thres2$id%in%female_id,]
dim(thres2_female)

raw_female_median_all <- readRDS("./turan/data/processed/rds/raw_female_median_all.rds")
raw_female_median= raw_female_median_all[names(raw_female_median_all)%in%thres2_female$id]


saveRDS(raw_female_median, file = './turan/data/processed/rds/raw_female_median.rds')
