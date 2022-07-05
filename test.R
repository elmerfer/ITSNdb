df.chem<-ggseqlogo:::get_col_scheme("chemistry")
df.chem$Replace <- stringr::str_sub(df.chem$group,1,1)

seq <- s2c(db$mut_seq_prot[1])

change <- function(seq){
  seq <- s2c(seq)
  groups <- unique(df.chem$group)
  id.p<- which(seq %in% df.chem$letter[df.chem$group=="Polar"])
  id.n<- which(seq %in% df.chem$letter[df.chem$group=="Neutral"])
  id.b<- which(seq %in% df.chem$letter[df.chem$group=="Basic"])
  id.a<- which(seq %in% df.chem$letter[df.chem$group=="Acid"])
  id.h<- which(seq %in% df.chem$letter[df.chem$group=="Hydrophobic"])
  seq[id.p] <- "G"
  seq[id.n] <- "N"
  seq[id.b] <- "K"
  seq[id.a] <- "D"
  seq[id.h] <- "P"
  
  return(paste0(seq, collapse=""))
}

rbind(change(subset(db, NeoType=="Positive" & seq_length==49)$mut_seq_prot[1]),subset(db, NeoType=="Positive" & seq_length==49)$mut_seq_prot[1])
seqs <- plyr::ldply(subset(db, NeoType=="Positive" & seq_length==49)$mut_seq_prot, change)
seqsn <- plyr::ldply(subset(db, NeoType=="Negative" & seq_length==49)$mut_seq_prot, change)
seqsc <- plyr::ldply(subset(db, NeoType=="Cryptic" & seq_length==49)$mut_seq_prot, change)


cs1 = make_col_scheme(chars=c('P', 'N', 'K', 'A', 'H'), groups=unique(df.chem$group), 
                      cols=c('red', 'blue', 'black', 'yellow','orange'))

g1<-ggseqlogo(seqs$V1,method="prob")
g2<-ggseqlogo(seqsn$V1,method="prob")
g3<-ggseqlogo(seqsc$V1,method="prob")

grid.arrange(g1,g2,g3)
ggseqlogo(consensusMatrix(seqs$V1), "prob")
