#' RunNetMHCPan_pMHC
#'
#' Run a predict binding affinity and rank for each peptide-MHC allele pair in a cohort based manner present in the file
#'
#' @param pMHCfile character with the file path of the fasta file (it should be .fasta and contain onle 1 sequence)
#' @param rthParam float (default 0.5) upper limit for strong binder (SB -> peptide percent rank < rhtParam)
#' @param rlhParam float (default 2.0) upper limit for weak binder (WB ->  rhtParam <= peptide percent rank < rltParam )
#' @param tParam tparam
#' @param nCores
#' @param outFile file name of the output file  
#'
#' @details run netMHCpan trhough the sequence fasta file for each HLA
#'
#' @export
#'
#' @return a character
#'
RunNetMHCPan_pMHC <- function(pMHCfile, rthParam = 0.50, rltParam= 2.0, tParam = -99.9002, nCores=1L, outFile){
     pMHC <- as.data.frame(data.table::fread(pMHCfile,sep=","))
     
     if(all((c("Sample","Neoantigen","HLA") %in% colnames(pMHC)))==FALSE){
       stop("ERROR: RunNetMHCPan_pMHC  -> The following column names (Sample,Neoantigen,HLA) are mandatory")
     }
     HLA.u <- stringr::str_remove_all(unique(pMHC$HLA)," ")
     id.ok <- unlist(lapply(HLA.u, function(x) ITSNdb:::.CheckAllele(stringr::str_remove(x,"\\*"))))
     if(any(id.ok==FALSE)){
       cat(paste0("\nThe followings HLA has not been found in the allele database:"))
       cat(paste0(HLA.u[!id.ok], collapse=" - "))
     }
     pMHC$HLA <- stringr::str_remove_all(pMHC$HLA,"\\*")
     HLA.u <- stringr::str_remove_all(HLA.u[id.ok],"\\*")
     
     res<- do.call(rbind,BiocParallel::bplapply(HLA.u, function(x){
       peps <- subset(pMHC,HLA==x)$Neoantigen
       RunNetMHCPan_peptides(peps=peps,alleles = x)[[x]]
     }, BPPARAM= BiocParallel::MulticoreParam(workers =  nCores)))
     
     return(invisible(res))
}