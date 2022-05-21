source('./turan/scripts/00_Source.R')

namex= read.table('./turan/file_name.txt')[,1]
namex=as.character(namex)
length(namex)
# 1564

mapping_pro <- readRDS("./turan/data/processed/rds/mapping_pro_turan.rds")
dim(mapping_pro)
head(mapping_pro)
# 1564    3

mapping_pro$mapping_pro= log10(mapping_pro$mapping_pro)

blank= c("AB01" ,"AB02", "AB03" ,"AB04", "AB05", "AB18" ,"AB19" ,"AB20", "AB21" ,"AB22")
length(blank)
# 10
facs= c("UU_5603_13_S21", "UU_5603_14_S22" ,"UU_5603_15_S23", "UU_5603_16_S24" ,"UU_5603_17_S25",
        "UU_5603_18_S26", "UU_5603_19_S27","UU_5603_20_S28" ,"UU_5603_21_S29" ,"UU_5603_22_S30" ,
        "UU_5603_23_S31" ,"UU_5603_24_S32")
length(facs)
# 12
lcm= setdiff(mapping_pro$id, c(blank,facs))
length(lcm)
# 1542

mapping_pro$id= mgsub(mapping_pro$id, blank, rep('Blank',length(blank)))
mapping_pro$id= mgsub(mapping_pro$id, facs,  rep('FACS', length(facs)))
mapping_pro$id= mgsub(mapping_pro$id, lcm,   rep('LCM',  length(lcm)))

my_comparisons= list(c("Blank", "FACS"), c("Blank", "LCM"), c("FACS", "LCM") )

mappingx= ggboxplot(mapping_pro, x = "id", y = "mapping_pro",
              fill = 'id', color = 'gray5', 
              combine=T,
              palette = c( "#f0a860", "#486090","#d8f0f0")) +
  xlab('')+
  scale_x_discrete(labels=c("Blank"=  paste0("Blank\n(n= ",dim(mapping_pro[mapping_pro$id%in%'Blank',])[1],")"), 
                            "LCM"=    paste0("LCM\n(n= ", dim(mapping_pro[mapping_pro$id%in%'LCM',])[1],")"),
                            "FACS"=   paste0("FACS\n(n= ",dim(mapping_pro[mapping_pro$id%in%'FACS',])[1],")")))+
  
  # scale_y_continuous(trans='log10')+
  #  scale_y_continuous(trans='log10', labels = scales::number_format(accuracy = 0.01, decimal.mark = '.'))+
# scale_y_continuous(limits = c(-2,2))+
  ylab('Mapping proportion (log10)')+
  stat_compare_means(comparisons= my_comparisons, label='p.format')+
  guides(fill= F)+
  theme_pubr(base_size = 12)

saveRDS(mappingx, file = "./turan/data/processed/rds/mapping_pro_figure.rds")

ggsave("./turan/results/mapping_pro.pdf", mappingx, units = "cm", width = 16, height = 12, useDingbats = F)
ggsave("./turan/results/mapping_pro.png", mappingx, units = "cm", width = 16, height = 12)

svg("./turan/results/mapping_pro.svg", width = 8, height = 6)
mappingx
dev.off()
