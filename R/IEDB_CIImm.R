#' CIImm 
#' Implementation of the immunogenicity score from
#' Calis, Jorg J A et al. “Properties of MHC class I presented peptides that enhance immunogenicity.” 
#' PLoS computational biology vol. 9,10 (2013): e1003266. doi:10.1371/journal.pcbi.1003266
#' Up to now only 9-mer peptides
#' @param pep string of 9-mer peptide. ie. "SLFNTVATL"
#' @export
#' @return the immunogenic score
#' 
CIImm <- function(pep){
  
  pep <- seqinr::s2c(pep)
  if(length(pep) !=9 ){
    stop("only 9-mer peptides ")
  }
  data("CIImm")
  E <- as.numeric(aas[pep,2])
  I <- as.numeric(pos$Importance)
  s <- sum(E*I)
  return(s)
}
pep<-"SLFNTVATL"
c(CIImm("FIAGLIAIV"),
CIImm("VFIAGLIAI"),
CIImm("IAGLIAIVV"))
FIAGLIAIV
KAVYNFATC
RLNEVAKNL
LITGRLQSL
FQPQNGQFI