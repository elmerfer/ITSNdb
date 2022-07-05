library(openxlsx)
library(stringr)
library(msa)
library(ComplexHeatmap)
library(e1071)
library(seqinr)
library(ggseqlogo)
# if(!require(devtools)) install.packages("devtools")
# devtools::install_github("kassambara/factoextra")
library(factoextra)
if(Sys.info()["nodename"]=="elmer-pc"){
  db.path <- "/home/elmer/Elmer/Rstudio/libraries/"
}else{
  db.path<-"/home/elmer/Elmer/Immuno/Neoantigens/data/"  
}


db <- read.xlsx(paste0(db.path,"DB_seq49AA.xlsx"))
table(db$NeoType)
FPMp.total <- consensusMatrix(subset(db,NeoType =="Positive")$mut_seq_prot[sample(79,13)] )
FPMp.total <- 100*sweep(FPMp.total,MARGIN=2,STATS = colSums(FPMp.total), FUN = "/")

FPMc.total  <- consensusMatrix(subset(db,NeoType=="Cryptic")$mut_seq_prot[sample(23,13)] )
FPMc.total <- 100*sweep(FPMc.total,MARGIN=2,STATS = colSums(FPMc.total), FUN="/")

FPMn.total  <- consensusMatrix(subset(db,NeoType=="Negative")$mut_seq_prot )
FPMn.total <- 100*sweep(FPMn.total,MARGIN=2,STATS = colSums(FPMn.total), FUN="/")

g1<-ggseqlogo(FPMp.total, method="prob")
g2<-ggseqlogo(FPMn.total, method="prob")
g3<-ggseqlogo(FPMc.total, method="prob")

gridExtra::grid.arrange(g1,g2,g3)
FPMp.total <- consensusMatrix(subset(db,NeoType =="Positive")$mut_seq_prot[sample(79,13)] )
FPMc.total  <- consensusMatrix(subset(db,NeoType=="Cryptic")$mut_seq_prot[sample(23,13)] )
g1<-ggseqlogo(FPMp.total)
g2<-ggseqlogo(FPMn.total)
g3<-ggseqlogo(FPMc.total)

gridExtra::grid.arrange(g1,g2,g3)

FPMp.total <- consensusMatrix(subset(db,NeoType =="Positive")$mut_seq_prot[sample(79,13)] )
FPMc.total  <- consensusMatrix(subset(db,NeoType=="Cryptic")$mut_seq_prot[sample(23,13)] )

g1<-ggseqlogo(consensusMatrix(subset(db,NeoType =="Positive")$mut_seq_prot[sample(79,13)] )) + annotate('rect', xmin = 20.5, xmax = 29.5, ymin = -0.05, ymax = 2.5, alpha = .1, col='black', fill='yellow') 
g2<-ggseqlogo(consensusMatrix(subset(db,NeoType =="Positive")$mut_seq_prot[sample(79,13)] ))+ annotate('rect', xmin = 20.5, xmax = 29.5, ymin = -0.05, ymax = 2.5, alpha = .1, col='black', fill='yellow') 
g3<-ggseqlogo(consensusMatrix(subset(db,NeoType =="Positive")$mut_seq_prot[sample(79,13)] ))+ annotate('rect', xmin = 20.5, xmax = 29.5, ymin = -0.05, ymax = 2.5, alpha = .1, col='black', fill='yellow') 
g4<-ggseqlogo(consensusMatrix(subset(db,NeoType =="Positive")$mut_seq_prot[sample(79,13)] ))+ annotate('rect', xmin = 20.5, xmax = 29.5, ymin = -0.05, ymax = 2.5, alpha = .1, col='black', fill='yellow') 
g5<-ggseqlogo(consensusMatrix(subset(db,NeoType =="Positive")$mut_seq_prot[sample(79,13)] ))+ annotate('rect', xmin = 20.5, xmax = 29.5, ymin = -0.05, ymax = 2.5, alpha = .1, col='black', fill='yellow') 
g6<-ggseqlogo(consensusMatrix(subset(db,NeoType =="Positive")$mut_seq_prot[sample(79,13)] ))+ annotate('rect', xmin = 20.5, xmax = 29.5, ymin = -0.05, ymax = 2.5, alpha = .1, col='black', fill='yellow') 
gridExtra::grid.arrange(g1,g2,g3,g4,g5,g6)

g1<-ggseqlogo(consensusMatrix(subset(db,NeoType =="Negative")$mut_seq_prot[sample(23,13)] )) + annotate('rect', xmin = 20.5, xmax = 29.5, ymin = -0.05, ymax = 2.5, alpha = .1, col='black', fill='yellow') 
g2<-ggseqlogo(consensusMatrix(subset(db,NeoType =="Negative")$mut_seq_prot[sample(23,13)] ))+ annotate('rect', xmin = 20.5, xmax = 29.5, ymin = -0.05, ymax = 2.5, alpha = .1, col='black', fill='yellow') 
g3<-ggseqlogo(consensusMatrix(subset(db,NeoType =="Negative")$mut_seq_prot[sample(23,13)] ))+ annotate('rect', xmin = 20.5, xmax = 29.5, ymin = -0.05, ymax = 2.5, alpha = .1, col='black', fill='yellow') 
g4<-ggseqlogo(consensusMatrix(subset(db,NeoType =="Negative")$mut_seq_prot[sample(23,13)] ))+ annotate('rect', xmin = 20.5, xmax = 29.5, ymin = -0.05, ymax = 2.5, alpha = .1, col='black', fill='yellow') 
g5<-ggseqlogo(consensusMatrix(subset(db,NeoType =="Negative")$mut_seq_prot[sample(23,13)] ))+ annotate('rect', xmin = 20.5, xmax = 29.5, ymin = -0.05, ymax = 2.5, alpha = .1, col='black', fill='yellow') 
g6<-ggseqlogo(consensusMatrix(subset(db,NeoType =="Negative")$mut_seq_prot[sample(23,13)] ))+ annotate('rect', xmin = 20.5, xmax = 29.5, ymin = -0.05, ymax = 2.5, alpha = .1, col='black', fill='yellow') 
gridExtra::grid.arrange(g1,g2,g3,g4,g5,g6)


FPMp <- consensusMatrix(subset(db,NeoType =="Positive")$mut_seq_prot )
FPMp <- 100*sweep(FPMp,MARGIN=2,STATS = colSums(FPMp), FUN = "/")

dpos <- plyr::ldply(subset(db,NeoType =="Positive" & seq_length==ncol(FPMp))$mut_seq_prot ,function(pep) PeptideMap(pep,list(P=FPMp)))

h1 <-Heatmap(scale(dpos), cluster_columns = F, clustering_distance_rows = "pearson", km=5)
dend <- draw(h1)
dend<-row_dend(dend)


FPMn  <- consensusMatrix(subset(db,NeoType=="Negative")$mut_seq_prot )
FPMn <- 100*sweep(FPMn,MARGIN=2,STATS = colSums(FPMn), FUN="/")

dneg <- plyr::ldply(subset(db,NeoType =="Negative" & seq_length==ncol(FPMn))$mut_seq_prot ,function(pep) PeptideMap(pep,list(N=FPMn)))


hn <-Heatmap(scale(dneg), cluster_columns = F, clustering_distance_rows = "pearson", km=4)
dendn <- draw(hn)
dendn<-row_dend(dendn)
glog <- lapply(dendn, function(nd){
     id <- labels(nd)
     make_col_scheme(chars=c('A', 'T', 'C', 'G'), groups=c('gr1', 'gr1', 'gr2', 'gr2'), 
                     cols=c('purple', 'purple', 'blue', 'blue'))
   ggseqlogo(consensusMatrix(subset(db,NeoType =="Positive" & seq_length==ncol(FPMp))$mut_seq_prot[id] ))  + 
     annotate('rect', xmin = 20.5, xmax = 29.5, ymin = -0.05, ymax = 2.5, alpha = .1, col='black', fill='yellow') 
})
grid.arrange(glog[[1]],glog[[2]],glog[[3]],glog[[4]],glog[[5]])
glogn <- lapply(dendn, function(nd,cs){
  id <- labels(nd)
  print(id)  
   ggseqlogo(consensusMatrix(subset(db,NeoType =="Negative" & seq_length==ncol(FPMn))$mut_seq_prot[id] ),col_scheme=cs)  + 
     annotate('rect', xmin = 20.5, xmax = 29.5, ymin = -0.05, ymax = 2.5, alpha = .1, col='black', fill='yellow') 
},cs="taylor")

grid.arrange(glogn[[1]],glogn[[2]],glogn[[3]],glogn[[4]])
names(dend)
