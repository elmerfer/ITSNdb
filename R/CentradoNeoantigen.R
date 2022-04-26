library(openxlsx)
library(stringr)
library(msa)
library(ComplexHeatmap)
library(e1071)
library(seqinr)
# if(!require(devtools)) install.packages("devtools")
# devtools::install_github("kassambara/factoextra")
library(factoextra)

db <- read.xlsx("/home/elmer/Elmer/Immuno/Neoantigens/data/DB_seq49AA.xlsx")

FPMp.total <- consensusMatrix(subset(db,NeoType =="Positive")$mut_seq_prot )
FPMp.total <- 100*sweep(FPMp.total,MARGIN=2,STATS = colSums(FPMp.total), FUN = "/")

FPMc.total  <- consensusMatrix(subset(db,NeoType=="Cryptic")$mut_seq_prot )
FPMc.total <- 100*sweep(FPMc.total,MARGIN=2,STATS = colSums(FPMc.total), FUN="/")

FPMn.total  <- consensusMatrix(subset(db,NeoType=="Negative")$mut_seq_prot )
FPMn.total <- 100*sweep(FPMn.total,MARGIN=2,STATS = colSums(FPMn.total), FUN="/")

g1<-ggseqlogo(FPMp.total, method="prob")
g2<-ggseqlogo(FPMn.total, method="prob")
g3<-ggseqlogo(FPMc.total, method="prob")

gridExtra::grid.arrange(g1,g2,g3)

colnames(FPMp.total)
Heatmap()

ncol(FPMn.total)
PeptideMap(db$mut_seq_prot[1],list(N=FPMp.total,P=FPMn.total))
df.pca <- plyr::ldply(subset(db, seq_length==ncol(FPMn.total))$mut_seq_prot,
                      function(pep) PeptideMap(pep,list(N=FPMp.total,P=FPMn.total))) 
colnames(df.pca)
vars <- c(
  paste0(c(40,36,27,28,30),"N"),
  paste0(c(16,35,38,27,2),"P")
)
mod.pca <- prcomp(df.pca,scale=T)
fviz_eig(mod.pca)
fviz_pca_ind(mod.pca,
             col.ind = "cos2", # Color by the quality of representatio
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE     # Avoid text overlapping
)
fviz_pca_var(mod.pca,
             col.var = "contrib", # Color by contributions to the PC
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE     # Avoid text overlapping
)

ggbiplot(mod.pca, groups = subset(db, seq_length == 49)$NeoType,
         var.scale = 1.5)

p <- 0.5

lp2 <- lapply(c(0.3,0.5,0.7,0.8,0.9,0.95,1), function(p){
 plyr::ldply(1:100, function(i,p){
  nc <-table(db$NeoType)
  id.c <- sample(which(db$NeoType=="Cryptic"), round(p*nc["Cryptic"]))
  id.n <- sample(which(db$NeoType=="Negative"), round(p*nc["Negative"]))
  id.p <- sample(which(db$NeoType=="Positive"), round(p*nc["Positive"]))
  
  FPMp <- consensusMatrix(db[id.p,]$mut_seq_prot )
  FPMp <- 100*sweep(FPMp,2,colSums(FPMp),FUN="/")
  FPMp[is.infinite(FPMp)] <- 0

  M <- 0*FPMp.total
  M[rownames(FPMp),] <- FPMp
  FPMp<-M


  FPMc <- consensusMatrix(db[id.c,]$mut_seq_prot )
  FPMc <- 100*sweep(FPMc,2,colSums(FPMc),FUN="/")
  FPMc[is.infinite(FPMc)] <- 0
  M <- 0*FPMc.total
  M[rownames(FPMc),] <- FPMc
  FPMc<-M

  FPMn <- consensusMatrix(db[id.n,]$mut_seq_prot )
  FPMn <- 100*sweep(FPMn,2,colSums(FPMn),FUN="/")
  FPMn[is.infinite(FPMn)] <- 0
  
  M <- 0*FPMn.total
  M[rownames(FPMn),] <- FPMn
  FPMn<-M

  
  c(sum(abs(FPMp-FPMp.total)),c=sum(abs(FPMc-FPMc.total)),n=sum(abs(FPMn-FPMn.total)))
  
},p)
  })
M<-plyr::laply(1:3 , function(i) {
  unlist(lapply(lp2, function(xx,j) xx[1,j],j=i))
  })


res.p <- lapply(1:20, function(x,p){
  nc <-table(db$NeoType)
  #selecciono un porcentaje "p" de muestras para entrenar
  id.c <- sample(which(db$NeoType=="Cryptic"), round(p*nc["Cryptic"]))
  id.n <- sample(which(db$NeoType=="Negative"), round(p*nc["Negative"]))
  id.p <- sample(which(db$NeoType=="Positive"), round(p*nc["Positive"]))
  
  db.train <- db[c(id.n,id.p),]
  
  #calculo las matrices de frecuencia 
  FPMp <- consensusMatrix(db[id.p,]$mut_seq_prot )
  FPMp <- 100*sweep(FPMp,2,colSums(FPMp),FUN="/")
  FPMp[is.infinite(FPMp)] <- 0
    M <- 0*FPMp.total
  M[rownames(FPMp),] <- FPMp
  FPMp<-M
  
  FPMc <- consensusMatrix(db[id.c,]$mut_seq_prot )
  FPMc <- 100*sweep(FPMc,2,colSums(FPMc),FUN="/")
  FPMc[is.infinite(FPMc)] <- 0
  M <- 0*FPMc.total
  M[rownames(FPMc),] <- FPMc
  FPMc<-M
  
  FPMn <- consensusMatrix(db[id.n,]$mut_seq_prot )
  FPMn <- 100*sweep(FPMn,2,colSums(FPMn),FUN="/")
  FPMn[is.infinite(FPMn)] <- 0
  
  #conmstruyo la base de datos
  db.train <- subset(db.train, seq_length==ncol(FPMn.total))
  train <- plyr::ldply(db.train$mut_seq_prot,function(pep) PeptideMap(pep,list(N=FPMn,P=FPMp))) 
  y.train <- factor(as.character(db.train$NeoType))
  
  #entreno el modelo
  mod <- svm(x=train, y=y.train,kernel = "lin",probability = T)
  summary(mod)
  ##
  db.test <- db[-c(id.n,id.p),]
  db.test <- subset(db.test, seq_length==ncol(FPMn.total))
  test <- plyr::ldply(db.test$mut_seq_prot,function(pep) PeptideMap(pep,list(N=FPMn,P=FPMp))) 
  pred <- predict(mod, test, probability = T)
  prob <- attr(pred,"probabilities")
  return(data.frame(Pred=as.character(pred), Pneg=prob[,"Negative"],Ppos = prob[,"Positive"],Y=db.test$NeoType))
  },p=0.7)


df <- plyr::ldply(res.p, function(x) {
  data.frame(P=x$Pred,O=x$Y)
})

df$O[df$O=="Cryptic"] <- "Positive"
df$P <- factor(df$P,levels = c("Positive","Negative"))
df$O <- factor(df$O,levels = c("Positive","Negative"))
ROCeval(df$P,df$O)
