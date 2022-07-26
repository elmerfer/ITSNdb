library(BiocParallel)
#' install_netMHCPan
#' @param file = this should be the downloaded tar.gz file "netMHCpan-4.1b.Linux.tar.gz", requested from 
#' \code{\link[netMHCpan web site]{https://services.healthtech.dtu.dk/service.php?NetMHCpan-4.1}}
#' @param dir = "./", the path to the directory where do you whant to store your netMHCpan. Then it will be 
#' accesible blindly
#' @return 
#' on success the following mss will be printed "netMHCpan Installation OK"
#' @export
install_netMHCPan <- function(file = NULL , dir = "./"){
  software <- .OpenConfigFile()
  if(is.null(software)==FALSE){
    if(is.null(software$netMHCpan$command)==TRUE){
      stop("\nnetMHCpan already installed")
    }
  }else{
    software$netMHCpan$main <- dir
  }
  
  if(is.null(file)){
    stop("file is missing")
    
  }
  if(stringr::str_detect(file, "MHCII")==TRUE){
    stop("\nAre you trying to install netMHCIIpan ?? please verify the imput file")
  }
  if(file.exists(file)==FALSE){
    stop("File not found")
  }
  if(!stringr::str_detect(file,"Linux")){
    stop("Only linux installation")
  }
  
  tsch <- system2(command = "tcsh", args= "--version" ,stdout=TRUE)
  if(!stringr::str_detect(tsch,"tcsh")){
    stop("Pls install tsch shell to run netMHCpan")
  }
  
  # file <- "/media/elmer/141f3650-b135-4c9d-a497-9f1ee77c14f5/home/Elmer/Inmuno/netMHCpan-4.1b.Linux.tar.gz"
  # dir <- "/media/elmer/141f3650-b135-4c9d-a497-9f1ee77c14f5/home/Elmer/Inmuno"
  .netMHCpan.file <- basename(file)
  
  
  files.in.tar <- untar(file, list = TRUE)
  readme.file <- files.in.tar[stringr::str_detect(files.in.tar,"readme")]
  software.name <- files.in.tar[1]
  # sf.info <- .SoftwareInfo(name = "netMHCpan", masterDirectory = dir, softwareDirectory = software,version = "4.1")
  
  cat(paste("\nUncompressing files at:", software$netMHCpan$main))
  if(dir.exists(software$netMHCpan$main)==FALSE){
    dir.create(software$netMHCpan$main)
  }
  ##Untar
  untar(file, exdir = software$netMHCpan$main)
  software$netMHCpan$main <- file.path(software$netMHCpan$main,software.name)
  #reading readme file to look for data
  # readme.f <- readLines(file.path(software$netMHCpan$main,readme.file))
  data.url <- "https://services.healthtech.dtu.dk/services/NetMHCpan-4.1/data.tar.gz"
  if(length(data.url)<1){
    cat("data URL not found, pls check the readme file and install data file")
  }
  
  oldp <- getwd()
  setwd(software$netMHCpan$main)
  
  cat(paste("\nDownloading", basename(data.url)," file in:", getwd(),"\n.... This may take time!!!...\n"))
  
  download.file(data.url, destfile = basename(data.url), method = "wget")
  if(file.exists(basename(data.url))){
    untar(basename(data.url))
  }else{
    stop("Fail download")
  }
  
  cat(paste("\nEditing ", "netMHCpan"))
  .EditTCSHfile.v4.1(software)
   software$netMHCpan$command <- file.path(software$netMHCpan$main,"netMHCpan")
  .TestCode(software)
  setwd(oldp)
  .OpenConfigFile(software)
}



# Internal function for config edition
.EditTCSHfile.v4.1 <- function(file.info){
  if(file.exists(file.path(file.info$netMHCpan$main,"netMHCpan"))==FALSE){
    stop(paste0("ERROR: ejectution file netMHCpan", "not found"))
  }
  
  # file <- file.path(dir,paste(files.in.tar[1],"netMHCpan",sep=""))
  rl <- readLines(file.path(file.info$netMHCpan$main,"netMHCpan"))
  
  id<- which(stringr::str_detect(rl, "setenv\tNMHOME"))
  rl[id] <- paste("setenv\tNMHOME\t",file.info$netMHCpan$main,sep="")
  id<- which(stringr::str_detect(rl, "scratch"))
  if(length(id)==0) {
    id <- which(stringr::str_detect(rl, "\tsetenv  TMPDIR  /tmp"  ))
    rl[id] <- paste0("\tsetenv  TMPDIR  ",file.info$netMHCpan$main, "tmp")
  }else{
    # rl[id] <- str_replace(rl[id],"/scratch", file.path(dirname(file), "tmp"))
  }
  dir.create(file.path(file.info$netMHCpan$main, "tmp"))
  writeLines(text=rl, con = file.path(file.info$netMHCpan$main,"netMHCpan"))
}



# Internal function for testing installation
.TestCode <- function(software){
    res <- system2(command = software$netMHCpan$command, args = "-p test/test.pep", stdout = TRUE)
    if(any(res == "   1 HLA-A*02:01      AAAWYLWEV AAAWYLWEV  0  0  0  0  0    AAAWYLWEV         PEPLIST 0.4403830    0.472  0.74258 <= SB")){
      cat("\n netMHCpan Installation OK\n")
    }else{
      stop("Error, installation went wrong\n")
    }
  }
  
#' RunNetMHCPan
#'
#' Run a peptides between 8 to 14 mers along a fasta sequence (from file)
#' now running for netMHCpan 4.1
#'
#' @param peps character with the file path of the fasta file (it should be .fasta and contain onle 1 sequence)
#' @param alleles a character vector with the HLA sequences  c("HLA-A01:01") or c("HLA-A01:01","HLA-A02:01") and so on. If NULL it will be automatically downloaded from the netMHCpan server (it may take time)
#' @param rthParam float (default 0.5) upper limit for strong binder (SB -> peptide percent rank < rhtParam)
#' @param rlhParam float (default 2.0) upper limit for weak binder (WB ->  rhtParam <= peptide percent rank < rltParam )
#' @param tParam tparam
#' @param nCores
#'
#' @details run netMHCpan trhough the sequence fasta file for each HLA
#'
#' @export
#'
#' @return a character
#'
RunNetMHCPan_peptides <- function(peps, alleles, rthParam = 0.50, rltParam= 2.0, tParam = -99.9002, nCores=1L){
  .ValidatePepLength(peps = peps)
  nCores <- ifelse(length(alleles)>=nCores, length(alleles),nCores)
  pep.files <- .BuildAllelesPepFiles(pep,alleles)
  res<- BiocParallel::bplapply(pep.files, function(x){
    .RunNetMHCPan(seqfile=x$pfile, allele=x$allel, rthParam , rltParam , tParam )
  }, BPPARAM= MulticoreParam(workers =  nCores))
  .RemoveTmpPepFiles(pep.files)
  return(invisible(res))
}


.ValidatePepLength <- function(peps){
  if(any(stringr::str_length(peps)<8 | stringr::str_length(peps)>14)){
    stop("ERROR: 8 <= Peptide length <= 15")
  }
}
.BuildAllelesPepFiles <- function(peps,alleles){
  if(missing(alleles)){
    alleles<-"HLA"
  }
  pep.files <- lapply(alleles, function(x){
    tmp<-tempfile(fileext = ".pep")
    writeLines(peps,tmp)
    return(list(pfile=tmp,allele=x))
  })
  return(pep.files)
}

.RemoveTmpPepFiles<-function(tmp.list){
  file.remove(unlist(lapply(tmp.list,function(x)x$pfile)))
}

.RunNetMHCPan <- function(seqfile, allele, rthParam = 0.50, rltParam= 2.0, tParam = -99.9002, pLength, fileInfo){
  if(length(allele)>1){
    cat("\nOnly processing ",allele[1]," Allele")
  }
  hla <- allele[1]
  software <- .OpenConfigFile()
  
  if(is.null(software) | !dir.exists(software$netMHCpan$main)){
    stop("ERROR: missing netMHCpan path")
  }
  if(!.CheckAllele(allele)){
    stop(paste(allele, "NOT Found, Please check allele name"))
  }
  if(stringr::str_detect(basename(seqfile),".fasta")){
    datafile <- seqfile
  }else{
    if(stringr::str_detect(basename(seqfile),".pep")){
      datafile <- paste("-p ",seqfile,sep="")
    }else{
      stop("ERROR file should end in fasta or pep")
    }
  }
  if(missing(pLength)){
    long.pep <- paste(8:11,collapse = ",")
  }else{
    long.pep <- pLength
  }
  
  command <- software$netMHCpan$command
  
  # command <- str_replace_all(command,"//","/")
  arguments <- c(file = datafile,
                 syn = paste("-syn ",file.path(software$netMHCpan$main,"Linux_x86_64/data/synlist.bin"),sep = ""),
                 tdir = paste("-tdir ", file.path(software$netMHCpan$main,"tmp/netMHCpanXXXXXX"),sep = ""),
                 rdir = paste("-rdir ", file.path(software$netMHCpan$main,"Linux_x86_64"),sep = ""),
                 hlapseudo = paste("-hlapseudo ", file.path(software$netMHCpan$main,"Linux_x86_64/data/MHC_pseudo.dat"),sep = ""),
                 thrfmt = paste("-thrfmt ", file.path(software$netMHCpan$main,"Linux_x86_64/data/threshold/%s.thr.%s"),sep = ""),
                 version = paste("-version ", file.path(software$netMHCpan$main,"Linux_x86_64/data/version"),sep = ""),
                 allname = paste("-allname ", file.path(software$netMHCpan$main,"Linux_x86_64/data/allelenames"),sep = ""),
                 rth = paste("-rth ",rthParam, sep = ""),
                 rlt = paste("-rlt ",rltParam, sep = ""),
                 t = paste("-t ",tParam,sep = ""),
                 v = "-v",
                 BA= "-BA",
                 a = paste("-a", NULL),
                 l= paste("-l ",long.pep))
  nm <- names(arguments)
  arguments <- stringr::str_replace_all(arguments,"//","/")
  names(arguments) <- nm
  # res <- unlist(lapply(hla,function(al){
  al <- stringr::str_remove_all(hla,"\\*")
  arguments["a"] <- paste("-a",paste0(al))
  # print(arguments["a"])
  s1 <- system2(command = command, stdout = TRUE, args = arguments)
  return(.FormatOut(s1))
   # print(paste("Longitud seq:",length(s1)))
  # binders <- c(which(str_detect(s1,"SB")),which(str_detect(s1,"WB")))
  # class(s1) <- "RAPIMHC"
  # if(length(binders)>0){
  #   return(s1[binders])
  # }else return(NA)
  # }))
}

.FormatOut <- function(resRAPIMHC){
  id <- which(stringr::str_detect(resRAPIMHC,"-------------------"))
  id.ini <- id[2]+1
  id.fin <- id[3]-1
  cns <- unlist(stringr::str_split(resRAPIMHC[id[1]+1]," "))
  cns <- cns[cns!=""]
  
  ret <- data.frame(do.call(rbind, lapply(id.ini:id.fin, function(i){
    
    re <- unlist(stringr::str_split(resRAPIMHC[i]," "))
    re <- re[re != ""]
    re <- re[re != "<="]
    if(length(re)==length(cns)){
      return(re)
    }else{
      return(c(re,NA))
    }
  }    )))
  
  colnames(ret) <-cns
  return(ret)
}

.CheckAllele <- function(allele){
  softwarePath <- .OpenConfigFile()
  allele.names.file <- stringr::str_replace_all( file.path(softwarePath$netMHCpan$main, "data/allelenames" ),"//","/")
  if(file.exists(allele.names.file)==FALSE){
    stop("error: File not found")
  }
  HLA.table <- read.table(allele.names.file)
  return(any(stringr::str_detect(HLA.table$V1, allele)))
}


#'  GetMHCgeneList
#'
#' returns an list of Allele types (length nSegments)
#'
#'
#' @param nSegments integer, number of segments
#' @param MHC.group MHC allele group "HLA","BoLA", "Gogo","H","H2", "Mamu", "Patr","SLA",
#'        "DRB", "DQ","DP","Mouse","All"
#' @param MHCII (logical) if MHCII = TRUE, then only MHC.group in "DRB", "DQ","DP","Mouse","All" are evaluated
#'                        if MHCII = FALSE, only "HLA","BoLA", "Gogo","H","H2", "Mamu", "Patr","SLA", "All" are evaluated
#' @export
#' @return
#' a list of alleles with length = nSegments (ussualy set to the number of cores or CPU workers)
#'
#' @examples
#' \dontrun{
#' FormatOut(eDB = result)
#' }
.GetMHCgeneList <- function(nSegments = 10,
                            alleleGroup = c("HLA","BoLA", "Gogo","H","H2", "Mamu", "Patr","SLA", "All")){
  softwarePath <- .OpenConfigFile()
  data("MHC_allele_names")
 
  HLA.table <- MHC_allele_names
  
  HLA.group <- match.arg( alleleGroup, c("HLA","BoLA", "Gogo","H","H2", "Mamu", "Patr","SLA", "All"))
  if(HLA.group != "ALL") {
    HLA.table <- HLA.table[stringr::str_detect(HLA.table$Alleles,HLA.group),,drop=F]
  }
  
  id1 <- seq(1,length(HLA.table$Alleles),length.out = nSegments+1)
  id <- cbind(id1[-length(id1)],c(id1[-c(1,length(id1))]-1,rev(id1)[1]))
  
  
  allele.list <- lapply(1:nrow(id), function(x) HLA.table$Alleles[id[x,1]:id[x,2]] )
  return(allele.list)
  
}

RunMHCAlleles <- function(seqfile, alleleList , rthParam = 0.50, rltParam= 2.0, tParam = -99.9002,  nCores ){
  
  if(missing(nCores)){
    nCores <- parallel::detectCores()-1
    cat(paste("\nSetting number of cores to", nCores," (since nCores args is missing)\n"))
  }
  if(nCores > length(alleleList)){
    nCores <- length(alleleList)
    cat(paste("\nSetting number of cores to", nCores," as long of the HLA list input\n"))
  }
  
  
  ret.list <- bplapply(alleleList, function(x, sqf){
    return(.RunNetMHCPan(seqfile=sqf, allele = x, rltParam = rltParam, rthParam = rthParam, tParam = tParam))
  }, sqf = seqfile, BPPARAM= MulticoreParam(workers =  nCores))
  return(ret.list)
}


PeptidePromiscuity <- function(seqfile, alleleType="HLA", rthParam = 0.50, rltParam= 2.0, tParam = -99.9002,  nCores ){
  
  if(missing(nCores)){
    nCores <- parallel::detectCores()-1
    cat(paste("\nSetting number of cores to", nCores," (since nCores args is missing)\n"))
  }
  
  
  allele.list <- .GetMHCgeneList(nSegments=nCores, alleleGroup = "HLA")
  ret.list <- bplapply(allele.list, function(x, sqf){
    df<-plyr::ldply(x, function(p){
      rr <- .RunNetMHCPan(seqfile=sqf, allele = p, rltParam = rltParam, rthParam = rthParam, tParam = tParam)
      if(is.na(rr$BindLevel)) return(NULL)
      return(rr)
    })
  }, sqf = seqfile, BPPARAM= MulticoreParam(workers =  nCores))
  df1 <- na.omit(plyr::ldply(ret.list, function(x) x))
  df2 <- df1 %>% group_by(Peptide) %>% summarize(WB = sum(BindLevel=="WB"), SB = sum(BindLevel=="SB"), Count = n())
  return(df2)
}

