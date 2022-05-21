source('./turan/scripts/00_Source.R')

turan_iod_q60 <- readRDS("./turan/data/processed/rds/turan_iod_q60.rds")
turan_iod= turan_iod_q60
head(turan_iod)

turan_iod$dispersion= log10(turan_iod$dispersion)

my_comparisons= list(c("Blank", "FACS"), c("Blank", "LCM"), c("FACS", "LCM") )

iod= ggboxplot(turan_iod, x = "id", y = "dispersion",
              fill = 'id', color = 'gray5', 
              combine=T,
              palette = c("#f0a860", "#486090","#d8f0f0")) +
  xlab('')+
  scale_x_discrete(labels=c("Blank"=  paste0("Blank\n(n= ",dim(turan_iod[turan_iod$id%in%'Blank',])[1],")"), 
                            "LCM"=    paste0("LCM\n(n= ",dim(turan_iod[turan_iod$id%in%'LCM',])[1],")"),
                            "FACS"=   paste0("FACS\n(n= ",dim(turan_iod[turan_iod$id%in%'FACS',])[1],")")))+
  ylab('Index of dispersion (log10)')+
  # scale_y_continuous(trans='log10')+
  # scale_y_continuous(breaks=c(-1, 0, 1, 2, 3), labels=c(exp(-1), exp(0), exp(1), exp(2), exp(3)))+
  guides(fill=F) +
  stat_compare_means(comparisons= my_comparisons, label = 'p.format')+
  theme_pubr(base_size = 12)  

saveRDS(iod, file = "./turan/data/processed/rds/iod_figure.rds")

ggsave("./turan/results/IOD_alter.pdf", iod, units = 'cm', width = 16, height = 12, useDingbats = F)
ggsave('./turan/results/IOD_alter.png', iod, units = 'cm', width = 16, height = 12, type='cairo')

svg("./turan/results/IOD_alter.svg", width = 8, height = 6)
iod
dev.off()
