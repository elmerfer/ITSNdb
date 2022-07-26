dat <- read.csv("/home/elmer/Elmer/ITSNdb/DB_07_2022.csv",h=T)
View(dat)
library(plyr)
peps <- lapply(, function(x) subset(dat,HLA==x))

lp <- lapply(peps, function(x){
  # ft <- tempfile(fileext = ".pep")
  ft <- "test.pep"
  writeLines(x$Sequence,ft)
  file.exists(ft)
  res <- ITSNdb:::PeptidePromiscuity(seqfile = ft)
  
  # res <- ITSNdb:::.RunNetMHCPan(seqfile = ft,allele = c(x$HLA[1],"HLA-B40:01"))
  file.remove(ft)
  return(res)
})

##calcular la cantidad de allelos a los que se pega, mutado y wt.
##calcular DAI


ft <- "muttest.pep"
writeLines(dat$Sequence,ft)
ftwt <- "wttest.pep"
writeLines(dat$WT,ftwt)
file.exists(ft)
res <- ITSNdb:::PeptidePromiscuity(seqfile = ft, nCores = 5)
reswt <- ITSNdb:::PeptidePromiscuity(seqfile = ftwt, nCores = 5)
file.remove(ft)
file.remove(ftwt)

