source('./turan/scripts/00_Source.R')

turan_cover <- readRDS("./turan/data/processed/rds/Coverage_q60.rds")
turan_cover$coverage= log10(turan_cover$coverage)
summary(turan_cover$coverage)

my_comparisons= list( c("Blank", "FACS"), c("Blank", "LCM"), c("FACS", "LCM") )
coverage=     ggboxplot(turan_cover, x = "id", y = "coverage",
              fill = 'id', color = 'gray5', 
              combine=T,
              palette = c( "#f0a860", "#486090","#d8f0f0")) +
  xlab('')+
  scale_x_discrete(labels=c("Blank"=  paste0("Blank\n(n= ",dim(turan_cover[turan_cover$id%in%'Blank',])[1],")"), 
                            "LCM"=    paste0("LCM\n(n= ",  dim(turan_cover[turan_cover$id%in%'LCM',])[1],")"),
                            "FACS"=   paste0("FACS\n(n= ", dim(turan_cover[turan_cover$id%in%'FACS',])[1],")")))+
  ylab('Coverage (log10)')+
  stat_compare_means(comparisons= my_comparisons, label = 'p.format' )+
  guides(fill=F) +
  theme_pubr(base_size = 12)

saveRDS(coverage, file = "./turan/data/processed/rds/Coverage_figure.rds")

ggsave("./turan/results/coverage.pdf", coverage, units = "cm", width = 16, height = 12, useDingbats = F)
ggsave("./turan/results/coverage.png", coverage, units = "cm", width = 16, height = 12)

svg("./turan/results/coverage.svg", width = 8, height = 6)
coverage
dev.off()