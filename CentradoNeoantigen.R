library(openxlsx)
library(stringr)
library(msa)
library(ComplexHeatmap)
library(e1071)
library(seqinr)
# if(!require(devtools)) install.packages("devtools")
# devtools::install_github("kassambara/factoextra")
library(factoextra)

db <- read.xlsx("/home/elmer/Elmer/Immuno/Neoantigens/data/DB_02_2022.xlsx")
db <- read.csv("/home/elmer/Elmer/ITSNdb/DB_07_2022.csv",h=T)
db <- subset(db,NeoType != "Cryptic")
FPM <- FreqMatrix(subset(db,Length==9)$Sequence )
FPMp <- FreqMatrix(subset(db,Length==9 & NeoType == "Positive")$Sequence )
FPMn <- FreqMatrix(subset(db,Length==9 & NeoType == "Negative")$Sequence )


v1 <-vectorFrecDFfunction(subset(db,Length==9)$Sequence,FPM)
vp <-vectorFrecDFfunction(subset(db,Length==9)$Sequence,FPMp)
vn <-vectorFrecDFfunction(subset(db,Length==9)$Sequence,FPMn)

Heatmap(FPM, cluster_rows = F, cluster_columns = F)+
  Heatmap(FPMp-FPM, cluster_rows = F, cluster_columns = F)+
  Heatmap(FPMn-FPM, cluster_rows = F, cluster_columns = F)+
  Heatmap(FPMp-FPMn, cluster_rows = F, cluster_columns = F)

Heatmap(scale(FPMp,T,T), cluster_rows = F, cluster_columns = F)

Heatmap(vp-v1, cluster_rows = F, cluster_columns = F) +
  Heatmap(vn-v1, cluster_rows = F, cluster_columns = F) +
  Heatmap((vp-vn), cluster_rows = F, cluster_columns = F) 

rownames(FPM-FP)
g1<-ggseqlogo(FPMp-FPM)
g2<-ggseqlogo(FPMn-FPM)

gridExtra::grid.arrange(g1,g2)


df.pca <- cbind(vp-v1,vn-v1)
dim(df.pca)
colnames(df.pca) <- c(paste0(c(1:9),"P"),paste0(c(1:9),"N"))
mod.pca <- prcomp(df.pca,scale=T)
ggbiplot(mod.pca, groups = subset(db, Length == 9)$NeoType,
         var.scale = 1.5,ellipse = T,labels.size = 5)
ggplot(data.frame(mod.pca$x,LAB=subset(db, Length == 9)$NeoType), aes(y=PC1,x=LAB,col=LAB))+geom_violin()+geom_boxplot()

li

dat <- subset(db,Length==9)
dat$NeoType<-factor(dat$NeoType,levels=c("Positive","Negative"))
loo <- loobc(dat$NeoType)
res <- do.call(rbind,lapply(loo, function(select){
  
  FPM <- FreqMatrix(dat[-select,]$Sequence )
  FPMp <- FreqMatrix(subset(dat[-select,], NeoType == "Positive")$Sequence )
  FPMn <- FreqMatrix(subset(dat[-select,], NeoType == "Negative")$Sequence )
  
  ##train
  v1 <-vectorFrecDFfunction(dat[-select,]$Sequence,FPM)
  vp <-vectorFrecDFfunction(dat[-select,]$Sequence ,FPMp)
  vn <-vectorFrecDFfunction(dat[-select,]$Sequence,FPMn)
  df.pca <- cbind(vp-v1,vn-v1)
  train.pca <- prcomp(df.pca,scale=T)
  mod.svm <- e1071::svm(x=df.pca,y=dat[-select,]$NeoType, scale=T,kernel="lin",cost=10 )
  
  ##predict
  v1p <-vectorFrecDFfunction(dat[select,]$Sequence,FPM)
  vpp <-vectorFrecDFfunction(dat[select,]$Sequence ,FPMp)
  vnp <-vectorFrecDFfunction(dat[select,]$Sequence,FPMn)
  pred <- factor(predict(mod.svm,cbind(vpp-v1p,vnp-v1p)),levels=c("Positive","Negative"))
  truth <- dat[select,]$NeoType
  ROCeval(pred,truth)$Stats
  
}))


lr <- lapply(1:100, function(x) sample(nrow(dat),0.1*nrow(dat)))
res.rand <- do.call(rbind,lapply(lr, function(select){
  
  FPM <- FreqMatrix(dat[-select,]$Sequence )
  FPMp <- FreqMatrix(subset(dat[-select,], NeoType == "Positive")$Sequence )
  FPMn <- FreqMatrix(subset(dat[-select,], NeoType == "Negative")$Sequence )
  
  ##train
  v1 <-vectorFrecDFfunction(dat[-select,]$Sequence,FPM)
  vp <-vectorFrecDFfunction(dat[-select,]$Sequence ,FPMp)
  vn <-vectorFrecDFfunction(dat[-select,]$Sequence,FPMn)
  # df.pca <- cbind(vp-v1,vn-v1)
  # df.pca <- cbind(vp-vn)
  df.pca <- cbind(vp)
  train.pca <- prcomp(df.pca,scale=T)
  mod.svm <- e1071::svm(x=df.pca,y=dat[-select,]$NeoType, scale=T,kernel="lin",cost=100, probability = TRUE )
  
  ##predict
  v1p <-vectorFrecDFfunction(dat[select,]$Sequence,FPM)
  vpp <-vectorFrecDFfunction(dat[select,]$Sequence ,FPMp)
  vnp <-vectorFrecDFfunction(dat[select,]$Sequence,FPMn)
  # pred <- factor(predict(mod.svm,cbind(vpp-v1p,vnp-v1p)),levels=c("Positive","Negative"))
  # pred <- factor(predict(mod.svm,cbind(vpp-vnp)),levels=c("Positive","Negative"))
  pred <- factor(predict(mod.svm,cbind(vpp), probability = T),levels=c("Positive","Negative"))
  truth <- dat[select,]$NeoType
  ROCeval(pred,truth)$Stats
  
}))
summary(res.rand[,c("Se","Sp","PPV","NPV","DO","F1")])

View(plyr::ldply(res,function(x) x))

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
