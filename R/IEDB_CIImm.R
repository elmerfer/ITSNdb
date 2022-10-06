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
    return(NA)
  }
  data("CIImm")
  E <- as.numeric(aas[pep,2])
  I <- as.numeric(pos$Importance)
  s <- sum(E*I)
  return(s)
}

#' RunClassIImmunogenicity
#' It apply the Class I Immunogenicity (CIImm) score (IEDB) to cohort with a list of peptide-HLA pairs.
#' Up to now only 9-mer peptides
#' @param pepFile the full path to the peptide-HLA pairs
#' @export
#' @return a data frame with the uploaded peptide_HLA pairs with extra columns added by the CIImm output
#' @usage 
#' \dontrun{
#' df.to.test <- data.frame(Sample = c("Subject1","Subject1","Subject2"), Neoantigen=ITSNdb$Neoantigen[1:3],HLA = ITSNdb$HLA[1:3])
#' write.csv(df.to.test,file="MyPatientsNeoantigenList.csv",quote=F, row.names = F)
#' run predictions 
#' Cohort_results <- RunClassIImmunogenicity(pepsFile = "MyPatientsNeoantigenList.csv")
#' }
#' 


RunClassIImmunogenicity <- function(pepFile){
  peps <- read.csv(pepFile,h=T)
  if(all(c("Sample","Neoantigen","HLA") %in% colnames(peps) )==FALSE){
    stop("colnames error: it shuould contain at least the following columns Sample,Neoantigen,HLA")
  }
  
  peps$CIImm <- unlist(lapply(as.character(peps$Neoantigen), CIImm))
  return(peps)
  
}

