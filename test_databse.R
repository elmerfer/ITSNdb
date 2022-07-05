dat <- read.csv("/home/elmer/Elmer/ITSNdb/DB_1.1.csv",h=T)
View(dat)
library(plyr)
peps <- lapply(unique(dat$HLA), function(x) subset(dat,HLA==x))

lp <- lapply(peps, function(x){
  ft <- tempfile(, fileext = ".pep")
  writeLines(x$Sequence,ft)
  res <- ITSNdb:::.RunNetMHCPan(seqfile = ft,allele = x$HLA[1])
  file.remove(ft)
  return(res)
})

##calcular la cantidad de allelos a los que se pega, mutado y wt.
##calcular DAI


