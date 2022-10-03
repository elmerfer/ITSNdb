#' RunNetMHCPan_pMHC
#'
#' Run netMHCpan 4.1 to predict binding affinity and rank of each peptide-MHC allele pair in a cohort based manner present in the file.
#' @description 
#' The csv file (comma separated) should have the following columns :
#' Sample,Neoantigen,HLA
#' Pat1,GRIAFFLKY,HLA-B27:05
#' ...    
#' This columns are mandatory and the file could include others
#' The alleles will be checked. If they are not present in the allele Database they will be omitted
#' @param pepFile character with the file path of csv file containing all the Neoantigen-HLA pairs and the Sample identification
#' @param nCores integer indicating the number of CPUs. 
#' @param outFile boolean default TRUE. If TRUE, the same input file will be returned by adding the appropriate estimated columns
#'
#'
#' @export
#'
#' @return 
#' a data frame with all the peptide information from the pMHCfile with the extra columns returned by netMHCpan v.1
#' if outFile == TRUE, it will overwrite the input file with the extra columns returned by netMHCpan 4.1
#'
RunNetMHCPan <- function(pepFile, nCores=1L, outFile=FALSE){
    pMHCfile <- pepFile
     pMHC <- as.data.frame(data.table::fread(pMHCfile,sep=","))
     
     if(all((c("Sample","Neoantigen","HLA") %in% colnames(pMHC)))==FALSE){
       stop("ERROR: RunNetMHCPan_pMHC  -> The following column names (Sample,Neoantigen,HLA) are mandatory")
     }
     HLA.u <- stringr::str_remove_all(unique(pMHC$HLA)," ")
     id.ok <- unlist(lapply(HLA.u, function(x) ITSNdb:::.CheckAllele(stringr::str_remove(x,"\\*"))))
     if(sum(id.ok)==0){
       stop("ERROR, pls check alleles")
     }
     if(any(id.ok==FALSE)){
       cat(paste0("\nThe followings HLA has not been found in the allele database:"))
       cat(paste0(HLA.u[!id.ok], collapse=" - "))
     }
     pMHC$ID <- 1:nrow(pMHC)
     pMHC$HLA2 <- stringr::str_remove_all(pMHC$HLA,"\\*")
     HLA.u <- stringr::str_remove_all(HLA.u[id.ok],"\\*")
     orig.colnames <- colnames(pMHC)
     res<- do.call(rbind,BiocParallel::bplapply(HLA.u, function(x){
       peps <- subset(pMHC,HLA2==x)
       pf.n <- RunNetMHCPan_peptides(peps=peps$Neoantigen,alleles = x)[[x]]
       merge(peps[,colnames(peps)!="HLA2"], pf.n, by.x="Neoantigen",by.y="Peptide",sort=F)
     }, BPPARAM= BiocParallel::MulticoreParam(workers =  nCores)))
     res <- res[order(res$ID),]
     res$ID <- NULL
     if(outFile==TRUE){
       write.csv(res, pMHCfile, quote=F, row.names = F)
     }
     colnames(res)[!c(colnames(res) %in% orig.colnames)] <- paste0("NetMCpan_",colnames(res)[!c(colnames(res) %in% orig.colnames)])
     colnames(res) <- stringr::str_remove_all(colnames(res),"X.")
     return(invisible(res))
}