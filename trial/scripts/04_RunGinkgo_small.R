variation=0.9
outpath= file.path("./trial/results", paste0("genome_wide_", variation))

unloadNamespace("tilingArray")
library(plyr)
library(DNAcopy) 
library(inline) 
library(scales)
library(ggpubr)
library('unikn')     
library('ggpubr')
library('rtracklayer')
library('tidyverse')
library("wesanderson")
library(plyr)
library(ggplot2)
library(gridExtra)
library(nortest)
library(ggplot2)
######################
set.seed(1)
minPloidy   = 1.5
maxPloidy   = 6
minBinWidth = 5

cp = 3
col1 = col2 = matrix(0,3,2)
col1[1,] = c('darkmagenta', 'goldenrod')
col1[2,] = c('darkorange', 'dodgerblue')
col1[3,] = c('blue4', 'brown2')
col2[,1] = col1[,2]
col2[,2] = col1[,1]

# Load genome specific files
GC     = read.table('/home/users/ginkgo-master/genomes/hg19/GC_variable_500000_76_bwa', header=FALSE, sep="\t", as.is=TRUE)
loc    = read.table('/home/users/ginkgo-master/genomes/hg19/variable_500000_76_bwa' , header=TRUE , sep="\t", as.is=TRUE)
bounds = read.table('/home/users/ginkgo-master/genomes/hg19/bounds_variable_500000_76_bwa', header=FALSE, sep="\t")


raw <- readRDS(file.path(outpath, paste0('pca_genomewide', '_', variation,'_pos.rds')))
# raw=raw[, 1:10]

ploidy = rbind(c(0,0), c(0,0))
dim(raw)
step  = 1
chrom = loc[1,1]
for (i in 1:nrow(loc))
{
  if (loc[i,1] != chrom)
  {
    bounds[step,1] = chrom
    bounds[step,2] = i
    step           = step+1
    chrom          = loc[i,1]
  }
}

# Initialize color palette
colors     = matrix(0,3,2)
colors[1,] = c('goldenrod', 'darkmagenta')
colors[2,] = c('dodgerblue', 'darkorange')
colors[3,] = c('brown2', 'blue4')

# Initialize data structures
l            = dim(raw)[1] # Number of bins
w            = dim(raw)[2] # Number of cells
breaks       = matrix(0,l,w)
fixed        = matrix(0,l,w)
final        = matrix(0,l,w)
stats        = matrix(0,w,10)
pos          = cbind(c(1,bounds[,2]), c(bounds[,2], l))
# Initialize CN inference variables
CNgrid       = seq(minPloidy, maxPloidy, by=0.05)
n_ploidy     = length(CNgrid)  # Number of ploidy tests during CN inference
CNmult       = matrix(0,n_ploidy,w)
CNerror      = matrix(0,n_ploidy,w)
outerColsums = matrix(0,n_ploidy,w)

###    ###    ###
# Normalize cells
# normal  = sweep(raw+1, 2, colMeans(raw+1), '/')
normal=   raw
normal2 = normal
lab     = colnames(normal)

cell_cn= c()  
res4=c()
for(k in 1:w){
  tryCatch({
    # Calculate normalized for current cell (previous values of normal seem wrong)
    lowess.gc = function(jtkx, jtky) {
      jtklow = lowess(jtkx, log(jtky), f=0.05);
      jtkz = approx(jtklow$x, jtklow$y, jtkx)
      return(exp(log(jtky) - jtkz$y))
    }
    #  normal[,k] = lowess.gc( GC[,1], (raw[,k]+1)/mean(raw[,k]+1) )
    normal[,k] = lowess.gc(GC[,1], raw[,k]) 
    
    # Compute log ratio between kth sample and reference
    lr = log2(normal[,k])
    
    set.seed(1)
    # Determine breakpoints and extract chrom/locations
    CNA.object   = CNA(genomdat = lr, chrom = loc[,1], maploc = as.numeric(loc[,2]), data.type = 'logratio')
    CNA.smoothed = smooth.CNA(CNA.object)
    segs         = segment(CNA.smoothed, verbose=0, undo.SD=1, alpha = 0.0001, min.width=minBinWidth)
    frag         = segs$output[,2:3]
    
    # Map breakpoints to kth sample
    len = dim(frag)[1]
    bps = array(0, len)
    for (j in 1:len)
      bps[j]=which((loc[,1]==frag[j,1]) & (as.numeric(loc[,2])==frag[j,2]))
    bps = sort(bps)
    bps[(len=len+1)] = l
    
    
    # Track global breakpoint locations
    breaks[bps,k] = 1
    
    # Modify bins to contain median read count/bin within each segment
    fixed[,k][1:bps[2]] = median(normal[,k][1:bps[2]])
    for(i in 2:(len-1))
      fixed[,k][bps[i]:(bps[i+1]-1)] = median(normal[,k][bps[i]:(bps[i+1]-1)])
    fixed[,k] = fixed[,k]/mean(fixed[,k])
    
    # Determine Copy Number     
    outerRaw         = fixed[,k] %o% CNgrid
    outerRound       = round(outerRaw)
    outerDiff        = (outerRaw - outerRound) ^ 2
    outerColsums[,k] = colSums(outerDiff, na.rm = FALSE, dims = 1)
    CNmult[,k]       = CNgrid[order(outerColsums[,k])]
    CNerror[,k]      = round(sort(outerColsums[,k]), digits=2)
    
    f=0
    if (f == 0 | length(which(lab[k]==ploidy[,1]))==0 ) {
      CN = CNmult[1,k]
    } else if (f == 1) {
      CN = ploidy[which(lab[k]==ploidy[,1]),2]
      # If user specified FACS file, still calculate CNerror
      CNerror_facs = round( sort(colSums((round(fixed[,k] %o% c(CN)) - fixed[,k] %o% c(CN)) ^ 2, na.rm=FALSE, dims=1)), digits=2 )
    } else {
      estimate = ploidy[which(lab[k]==ploidy[,1]),2]
      CN = CNmult[which(abs(CNmult[,k] - estimate)<.4),k][1]
    }
    final[,k] = round(fixed[,k]*CN)  
    print(k)
    CN_export=CN
    names(CN_export)= colnames(normal)[k]
    cell_cn= c(cell_cn, CN_export)
    
    clouds=data.frame(x=normal[,k]*CN)
    # plot1 = ggplot() +
    #   geom_histogram(data=clouds, aes(x=x), binwidth=.05, color="black", fill="gray60") +
    #   geom_vline(xintercept=seq(0,10,1), size=1, linetype="dashed", color=colors[cp,1]) +
    #   scale_x_continuous(limits=c(0,10), breaks=seq(0,10,1)) +
    #   labs(title=paste("Frequency of Bin Counts for Sample \"", lab[k], "\"\nNormalized and Scaled by Predicted CN (", CNmult[1,k], ")", sep=""), x="Copy Number", y="Frequency") +
    #   theme(plot.title=element_text(size=12, vjust=1.5)) +
    #   theme(axis.title.x=element_text(size=12, vjust=-2.8), axis.title.y=element_text(size=12, vjust=.1)) +
    #   theme(axis.text=element_text(color="black", size=12), axis.ticks=element_line(color="black")) +
    #   theme(plot.margin=unit(c(.5,1,.5,1),"cm")) +
    #   theme(panel.background = element_rect(color = 'black'))
    
    top=8
    rectangles1=data.frame(pos[seq(1,nrow(pos), 2),])
    rectangles2=data.frame(pos[seq(2,nrow(pos), 2),])
    clouds=data.frame(x=1:l, y=normal[,k]*CN)
    amp=data.frame(x=which(final[,k]>2), y=final[which(final[,k]>2),k])
    del=data.frame(x=which(final[,k]<2), y=final[which(final[,k]<2),k])
    flat=data.frame(x=which(final[,k]==2), y=final[which(final[,k]==2),k])
    anno=data.frame(x=(pos[,2]+pos[,1])/2, y=-top*.05, chrom=substring(c(as.character(bounds[,1]), "chrY"), 4 ,5))
    
    plot2 = ggplot() +
      geom_rect(data=rectangles1, aes(xmin=X1, xmax=X2, ymin=-top*.1, ymax=top), fill='gray85', alpha=0.2) +
      geom_rect(data=rectangles2, aes(xmin=X1, xmax=X2, ymin=-top*.1, ymax=top), fill='gray75', alpha=0.2) +
      geom_point(data=clouds, aes(x=x, y=y), color='gray45', size= 0.3) +
      geom_point(data=flat, aes(x=x, y=y), size= 0.3) +
      geom_point(data=amp, aes(x=x, y=y), size= 0.3, color=colors[cp,1]) +
      geom_point(data=del, aes(x=x, y=y), size= 0.3, color=colors[cp,2]) +
      geom_text(data=anno, aes(x=x, y=y, label=chrom), size=4) +
      scale_x_continuous(limits=c(0, l), expand = c(0, 0)) +
      scale_y_continuous(limits=c(-top*.1, top), expand = c(0, 0)) +
      labs(title=paste("Integer Copy Number Profile for Sample \"", lab[k], "\"\n Predicted Ploidy = ", CN, sep=""), x="Chromosome", y="Copy Number", size=10) +
      theme(plot.title=element_text(size=12, vjust=1.5)) +
      theme(axis.title.x=element_text(size=12, vjust=-.05), axis.title.y=element_text(size=12, vjust=.1)) +
      theme(axis.text=element_text(color="black", size=12), axis.ticks=element_line(color="black"))+
      theme(axis.ticks.x = element_blank(), axis.text.x = element_blank(), axis.line.x = element_blank()) +
      theme(panel.background = element_rect(fill = 'gray90')) +
      theme(plot.margin=unit(c(.40,.60,.10,.60),"cm")) +
      theme(panel.grid.major.x = element_blank()) +
      geom_vline(xintercept = c(1, l), size=.1) +
      geom_hline(yintercept = c(-top*.1, top), size=.1)
    
    saveRDS(plot2, file = file.path(outpath, "ginkgo", paste0(lab[k], "_svd", ".rds")))
    ggsave(file.path(outpath, "ginkgo", paste0(lab[k],'_plot2',".pdf")), plot2, width = 14, height = 3.5)
    
    # p= grid.arrange(plot2,plot1)
    # 
    # ggsave(file.path(outpath, "ginkgo", paste0(lab[k], '_segnorm', ".pdf")), p, width = 14, height = 8)
    dev.off()
    
  }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})}


saveRDS(cell_cn, file = file.path(outpath, "/ginkgo", "cell_cn.rds"))


# Store processed sample information
loc2=loc
loc2[,3]=loc2[,2]
pos = cbind(c(1,bounds[,2]), c(bounds[,2], l))

#
for (i in 1:nrow(pos))
{
  # If only 1 bin in a chromosome
  if( (pos[i,2] - pos[i,1]) == 0 ) {
    loc2[pos[i,1],1] = 1
    # If two bins.......
  } else if( (pos[i,2] - pos[i,1]) == 1 ) {
    loc2[pos[i,1],1] = 1
    loc2[pos[i,2],1] = loc2[pos[i,1],2] + 1
  } else {
    loc2[pos[i,1]:(pos[i,2]-1),2]=c(1,loc[pos[i,1]:(pos[i,2]-2),2]+1)
  }
}
loc2[nrow(loc2),2]=loc2[nrow(loc2)-1,3]+1
colnames(loc2)=c("CHR","START", "END")
write.table(cbind(loc2,normal), file=paste(outpath, "/ginkgo", "/SegNorm", sep=""),   row.names=FALSE, col.names=c(colnames(loc2),lab), sep="\t", quote=FALSE)
write.table(cbind(loc2,final),  file=paste(outpath, "/ginkgo", "/SegCopy", sep=""),   row.names=FALSE, col.names=c(colnames(loc2),lab), sep="\t", quote=FALSE)
write.table(cbind(loc2,breaks), file=paste(outpath, "/ginkgo", "/SegBreaks", sep=""), row.names=FALSE, col.names=c(colnames(loc2),lab), sep="\t", quote=FALSE)
print('finished')