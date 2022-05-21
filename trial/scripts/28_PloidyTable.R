source('./turan/scripts/00_Source.R')

cell_cn <- readRDS("./trial/results/genome_wide_0.9/ginkgo/cell_cn.rds")
table(cell_cn)

svd1= length(cell_cn[cell_cn<=1.85])
svd2= length(cell_cn[cell_cn >=1.9 & cell_cn<=2])
svd3= length(cell_cn[cell_cn >=2.05])
svd4= c("Corrected data",svd1, svd2, svd3)

turan_ploidy <- readRDS("./turan/data/processed/rds/turan_ploidy.rds")
exc=c("AB01" ,"AB02", "AB03" ,"AB04", "AB05", "AB18" ,"AB19" ,"AB20", "AB21" ,"AB22", "UU_5603_13_S21", 
      "UU_5603_14_S22" ,"UU_5603_15_S23", "UU_5603_16_S24" ,"UU_5603_17_S25" ,
      "UU_5603_18_S26", "UU_5603_19_S27","UU_5603_20_S28" ,"UU_5603_21_S29" ,"UU_5603_22_S30" ,
      "UU_5603_23_S31" ,"UU_5603_24_S32")
turan_ploidy= turan_ploidy[!(turan_ploidy$id%in%exc),]
head(turan_ploidy)
dim(turan_ploidy)
turan_ploidyx= turan_ploidy[turan_ploidy$id%in%names(cell_cn),2]

uncorr1= length(turan_ploidyx[turan_ploidyx<=1.85])
uncorr2= length(turan_ploidyx[turan_ploidyx >=1.9 & turan_ploidyx<=2])
uncorr3= length(turan_ploidyx[turan_ploidyx >=2.05])
uncorr1+uncorr2+uncorr3
uncorr4= c("Uncorrected data",uncorr1, uncorr2, uncorr3)

xx4= rbind(uncorr4, svd4)
colnames(xx4)= c('','1.5 - 1.85', '1.9 - 2', '2.05 - 6')
rownames(xx4)= NULL

tab <- ggtexttable(xx4, rows = NULL, theme = ttheme("classic"))
# tab <- ggtexttable(xx4, rows = NULL, theme = ttheme("classic", 
#                                                     colnames.style = colnames_style(fill = "white",face = "plain", linecolor = "black")))
tab2= tab %>%
      table_cell_bg(  row = 2:tab_nrow(tab), column = 3, fill = "#1B9E77") %>%
      table_cell_font(row = 2:tab_nrow(tab), column = 3, face = "plain", color = "white") 
tab2

saveRDS(tab2, file= "./common/results/ploidy_table.rds")
