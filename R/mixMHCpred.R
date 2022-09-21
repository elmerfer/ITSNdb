
#' Install_PRIME v 2.2
#' This function will install PRIME (PRedictor of class I IMmunogenic Epitopes) in your local computer. Up to now only for linux environment.
#' \code{\link[PRIME web site]{https://github.com/GfellerLab/PRIME}}
#' @param dir = "./", the path to the directory where do you whant to store your netMHCpan. Then it will be 
#' accesible blindly
#' @return 
#' on success the following msg will be printed "PRIME has been successfully installed"
#' @export
#' @usage 
#' \notrun{
#' library(ITSNdb)
#' dir.path <- "my/directory"
#' Install_PRIME(dir = dir.path)
#' }
Install_PRIME <- function(dir = "./"){
  if(Sys.info()["sysname"]!="Linux"){
    stop("ONLY for Linux")
  }
  software <- ITSNdb:::.OpenConfigFile()
  if(is.null(software)==FALSE){
    if(is.null(software$mixMHCpred$command)==FALSE){
      stop("\nnetMHCpan already installed")
    }else{
      software$mixMHCpred$main <- dir
    }
  }else{#la base de datos de softwares no existe
    software$mixMHCpred$main <- dir
  }
  
  
  url.mixMHCpred <- "https://github.com/GfellerLab/MixMHCpred/archive/refs/heads/master.zip"
  tmp.file <- file.path(software$mixMHCpred$main, "mixMHCpred.zip")
  download.file(url = url.mixMHCpred, method = "wget",destfile = tmp.file)
  lfiles <- unzip(tmp.file,list=T)
  unzip(tmp.file, junkpaths = F, exdir = software$mixMHCpred$main)
  
  software$mixMHCpred$main <- file.path(software$mixMHCpred$main,lfiles$Name[1])
  
  fpath <- file.path(software$mixMHCpred$main,"MixMHCpred")
  file.exists(fpath)
  con <- file(fpath)
  conf.file <- readLines(con)
  id <- which(stringr::str_detect(conf.file, "lib_path="))
  conf.file[id] <- paste0("lib_path=","\"",software$mixMHCpred$main,"/lib","\"")
  writeLines(conf.file, con=con)
  close(con)
  
  system2(command = "g++", 
          args = c( file.path(software$mixMHCpred$main,"lib","MixMHCpred.cc"), 
                   paste0("-o ",file.path(software$mixMHCpred$main,"lib","MixMHCpred.x"))))
  
  
  software$mixMHCpred$command <- file.path(software$mixMHCpred$main,"MixMHCpred")
  system2(command="chmod", args=c("u=rwx,g=r,o=r", software$mixMHCpred$command))
  sout <- system2(command = software$mixMHCpred$command , args = "-h", stdout = TRUE)
  if(any(sout == "Usage: MixMHCpred -i INPUT_FILE -o OUTPUT_FILE -h LIST_OF_ALLELES")==FALSE){
    stop("Installation ERROR")
  }else{
    cat(paste0("\nMixMHCpred has been succesfully installed"))
  }

  
  ##-------------------------------------
  software$PRIME$main <- dir
  url.primer <- "https://github.com/GfellerLab/PRIME/archive/refs/heads/master.zip"
  tmp.file <- file.path(software$PRIME$main, "PRIME.zip")
  download.file(url = url.primer, method = "wget",destfile = tmp.file)
  lfiles <- unzip(tmp.file,list=T)
  unzip(tmp.file, junkpaths = F, exdir = software$PRIME$main)
  
  software$PRIME$main <- file.path(software$PRIME$main,lfiles$Name[1])
  
  fpath <- file.path(software$PRIME$main,"PRIME")
  file.exists(fpath)
  con <- file(fpath)
  conf.file <- readLines(con)
  id <- which(stringr::str_detect(conf.file, "lib_path="))
  conf.file[id] <- paste0("lib_path=","\"",software$PRIME$main,"/lib","\"")
  writeLines(conf.file, con=con)
  close(con)
  
  system2(command = "g++", 
          args = c( file.path(software$PRIME$main,"lib","PRIME.cc"), 
                    paste0("-o ",file.path(software$PRIME$main,"lib","PRIME.x"))))
  
  
  software$PRIME$command <- file.path(software$PRIME$main,"PRIME")
  system2(command="chmod", args=c("u=rwx,g=r,o=r", software$PRIME$command))
  sout <- system2(command = software$PRIME$command , args = "-h", stdout = TRUE)
  
  
  
  if(any(sout == "Usage:PRIME -i INPUT -a ALLELES -o OUTPUT ")==FALSE){
    stop("Installation ERROR")
  }else{
    cat(paste0("\nPRIME has been succesfully installed"))
  }  
  invisible(.OpenConfigFile(software))
}

#' RunPRIME
#' It will run PRIME immunogenic predictions for peptides-HLA pairs stored in a file
#' The file (a text comma separated file) should have the following columns
#' Sample,Neoantigen,HLA
#' Sample: Identify the sample, patients or any other useful annotation
#' Neoantigen: the neoantigen sequence (8 to 14 mer length)
#' HLA : the specif allele for such neoantigen
#' Any further column is allowed and will be kept on the final result data frame
#' @param pepFile the full path to the peptide-HLA pairs
#' @export
#' @return a data frame with the uploaded peptide_HLA pairs with extra columns added by the PRIME output
#' @usage 
#' \notrun{
#' df.to.test <- data.frame(Sample = c("Subject1","Subject1","Subject2"), Neoantigen=ITSNdb$Neoantigen[1:3],HLA = ITSNdb$HLA[1:3])
#' write.csv(df.to.test,file="MyPatientsNeoantigenList.csv",quote=F, row.names = F)
#' run predictions 
#' Cohort_results <- RunPRIME(pepsFile = "MyPatientsNeoantigenList.csv")
#' }
#' 
RunPRIME <- function(pepFile){
  software <- ITSNdb:::.OpenConfigFile()
  peps <- read.csv(pepFile,h=T)
  if(all(c("Sample","Neoantigen","HLA") %in% colnames(peps) )==FALSE){
    stop("colnames error: it shuould contain at least the following columns Sample,Neoantigen,HLA")
  }
  
  peps$ID <- 1:nrow(peps)
  HLA <- peps$HLA
  HLA <- stringr::str_remove_all(HLA, "HLA-")
  HLA <- stringr::str_remove_all(HLA, "\\*")
  HLA <- stringr::str_remove_all(HLA, ":")
  peps$HLAaux <- HLA
  HLA.unique <- unique(HLA)
  # BiocParallel::bp
  imm.pred <-plyr::ldply(HLA.unique, function(hla){
    ifile <- tempfile(fileext = ".txt")
    ofile <- stringr::str_replace_all(ifile,".txt","_out.txt")
    psample <- subset(peps, HLAaux==hla)
    file.con <- file(ifile)
    writeLines(psample$Neoantigen,con=file.con)
    close(file.con)
    system2(command = software$PRIME$command , args = c(paste0("-i ", ifile),
                                                        paste0("-a ",hla),
                                                        paste0("-o ",ofile),
                                                        paste0("-mix ", software$mixMHCpred$command)))
    rl <- read.table(file = ofile,h=T)
    rl$HLA <- hla
    colnames(rl) <- stringr::str_remove_all(colnames(rl),paste0("_",hla))
    rl <- merge(psample,rl, by.x=c("Neoantigen","HLAaux"),by.y = c("Peptide","HLA"),sort = F)
    rl$HLAaux<-NULL
    file.remove(c(ifile,ofile))
    # print(rl)
    return(rl)
  })#, BPPARAM = MulticoreParam())
  
  imm.pred <- imm.pred[order(imm.pred$ID),]
  imm.pred$ID <- NULL
  return(imm.pred)
  
}
