source('./turan/scripts/00_Source.R')

thres1 <- readRDS("./turan/data/processed/rds/remaning_cells.rds")
rem2= thres1$id

table2=read_xlsx('./turan/data/processed/txt/Table_2.xlsx')
table2=table2[as.character(table2$fastq)%in%as.character(rem2),]
table3=table2[,c('Age_yrs', 'Diagnosis', 'Sex', 'Brain_region','Braak_level')]
####
tables= table2[,c('Sex')]
tables2= as.data.frame(t(table(tables)))
tables2$tables=gsub('^male','Male',tables2$tables)
tables2$tables=gsub('female','Female',tables2$tables)
tables2$tables <- factor(tables2$tables, levels=c('Male','Female'))
s=ggbarplot(tables2, x ="tables",  y = "Freq",
          fill = "tables", color = "white",
          palette = c('#99af96', '#e88966'), 
          label = T, lab.pos = "in",lab.col = "black")+
  ggtitle('Sex')+
  theme(legend.position = "none")+
  labs(x = "", fill = "")+
  labs(y = "Number of cells", fill = "")+
  theme_pubr(base_size = 12)+  
  guides(fill=FALSE)
s

diag= table2[,c('Diagnosis')]
diag2= as.data.frame(t(table(diag)))
diag2$diag=gsub('control','Control',diag2$diag)
diag2$diag <- factor(diag2$diag, levels=c('Control','AD'))
d=ggbarplot(diag2, x ="diag",  y = "Freq",
            fill = "diag", color = "white",
            palette = c('#96b2b9', '#e0c8c6'), 
            ylab = "Number of cells", 
            xlab='',
            label = T, lab.pos = "in", lab.col = "black")+
  ggtitle('Diagnosis')+
  theme(legend.position = "none")+
  theme_pubr(base_size = 12)+  
  guides(fill=FALSE)
d

region= table2[,c('Brain_region')]
region2= as.data.frame(t(table(region)))
region2$region=c('Cereb.','Ent.', 'CA1' ,  'CA3'   ,'Temp.' )
region2$region <- factor(region2$region, levels=c('Temp.','Cereb.','Ent.','CA1','CA3'))
r=ggbarplot(region2, x ="region",  y = "Freq",
            fill = "region", color = "white",
            palette = c("#dab457","#6f7a53" ,"#dd8e58" ,"#6c648b" ,"#bc7b7d"),
            ylab = "Number of cells", 
            xlab='',
            label = T, lab.pos = "in", lab.col = "black")+
  ggtitle('Brain region')+
  theme(legend.position = "none")+
  theme_pubr(base_size = 12)+  
  guides(fill=FALSE)
r

blevel=table2[,c('Braak_level')]
blevel=blevel[!blevel==0]
blevel2= as.data.frame(t(table(blevel)))
blevel2$blevel=paste0('Stage-',blevel2$blevel)
blevel2$blevel <- factor(blevel2$blevel, levels=c('Stage-3','Stage-4','Stage-5','Stage-6'))
l=ggbarplot(blevel2, x ="blevel",  y = "Freq",
          fill = "blevel", color = "white",
          palette = c('#d1d3cf', '#6b82a8', '#757081', '#6c4f70'), 
          ylab = "Number of cells", 
          xlab='',
          label = T, lab.pos = "in", lab.col = "black")+
  ggtitle('Braak level')+
  theme(legend.position = "none")+
  theme_pubr(base_size = 12)+  
  guides(fill=FALSE)
l

p= ggarrange(s, d ,r,l,labels = c("A", "B", "C","D"),
          ncol = 2, nrow = 2)+
  theme(plot.margin = margin(1 ,0.4, 0.1, 0.4, "cm"))

ggsave(p, filename = "./turan/results/thres1_info_alter.pdf", units = "cm", width = 21, height = 18, useDingbats = F)
ggsave(p, filename = "./turan/results/thres1_info_alter.png", units = "cm", width = 21, height = 18, type='cairo')


saveRDS(p, file = "./turan/data/processed/rds/thres1_info_alter.rds")

svg("./turan/results/thres1_info_alter.svg", width = 9, height = 8)
p
dev.off()
dev.off()
