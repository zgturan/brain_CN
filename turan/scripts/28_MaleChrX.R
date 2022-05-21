# male
source('./turan/scripts/00_Source.R')

male_id <- readRDS("./turan/data/processed/rds/male_id.rds")
thres2 <- readRDS("./turan/data/processed/rds/remaning_cells.rds")
thres2_male= thres2[thres2$id%in%male_id,]
dim(thres2_male)
# 373   3

raw_male_median_all <- readRDS("./turan/data/processed/rds/raw_male_median_all.rds")
raw_male_median= raw_male_median_all[names(raw_male_median_all)%in%thres2_male$id]

saveRDS(raw_male_median, file = './turan/data/processed/rds/raw_male_median.rds')