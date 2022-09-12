library(data.table)
dat <- read.csv("/home/elmer/Elmer/europa/Transfer/input_TSNADB_MCC_breast.csv",h=T)
res <- fread("/home/elmer/Elmer/europa/datGerman_predicted_result.csv")
rank <- fread("/home/elmer/Elmer/europa/datGerman_predicted_result_rank.csv")

dim(dat)
length(unique(dat$Annotation))

lapply(unique(dat$Annotation), function(x){
  df <- subset(dat, Annotation==x)
  write.csv(df, paste0("/home/elmer/Elmer/europa/Transfer/",x,".csv"), quote = F, row.names = F )
})

key <- paste0(dat$HLA,"-",dat$peptide)
length(key)
length(unique(key))
rm(key)
dat$Annotation <- "PAT1"
write.csv(dat, paste0("/home/elmer/Elmer/europa/Transfer/datGerman.csv"), quote = F, row.names = F )
head(res)
dim(res)
head(dat)
res$PatientID <- dat$Annotation
df <-as.data.frame(res)
df <- df[,-ncol(df)]
df$Annotation <- res$PatientID
head(df)
write.csv(df,"/home/elmer/Elmer/europa/German_predicted_deepHLApan.csv", quote = F, row.names = F)
rank<-as.data.frame(rank)
head(rank)
dim(rank)
dim(df)
rownames(rank)<- paste0(rank$HLA,":",rank$Peptide)
rownames(df) <-  paste0(df$HLA,":",df$Peptide)
rank$Subject <- df[rownames(rank),"Annotation"]
head(rank)
rank$Annotation<-rank$Subject
rank<-rank[,-ncol(rank)]
write.csv(rank,"/home/elmer/Elmer/europa/German_predicted_rank_deepHLApan.csv", quote = F, row.names = F)
