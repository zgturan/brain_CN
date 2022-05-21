source('./turan/scripts/00_Source.R')

xx= c('Freq of CNVs', 'Indiv', 'Diagnosis + Coverage')
xx1=c('Freq of CNVs', 'Indiv', 'Chr * Diagnosis + Coverage')
xx2=c('Freq of CNVs', 'Indiv', 'Chr * Diagnosis + Brain reg + Coverage')
xx3=c('Freq of CNVs', 'Indiv', 'Chr * Diagnosis + Brain reg + Sex + Coverage')

xx4= rbind(xx,xx1,xx2,xx3)
colnames(xx4)= c('Response variable', 'Random factor','Fixed factors')
rownames(xx4)=NULL

ss <- tableGrob(xx4,theme=ttheme("classic"))
grid.arrange(ss)

saveRDS(ss, "./turan_svd/data/processed/rds/glmm_combina.rds")