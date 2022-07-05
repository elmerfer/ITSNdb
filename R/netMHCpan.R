#' install_netMHCPan
#' @param file = NULL 
#' @param dir = "./"
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
  


.RunNetMHCPan <- function(seqfile, allele, rthParam = 0.50, rltParam= 2.0, tParam = -99.9002, pLength, fileInfo){
  hla <- allele
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
  arguments["a"] <- paste("-a",paste0(al,collapse=","))
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
#'
#' @return
#' a list of alleles with length = nSegments (ussualy set to the number of cores or CPU workers)
#'
#' @examples
#' \dontrun{
#' FormatOut(eDB = result)
#' }
.GetMHCgeneList <- function(segmentsLength = 10,
                            alleleGroup = c("HLA","BoLA", "Gogo","H","H2", "Mamu", "Patr","SLA", "All")){
  softwarePath <- .OpenConfigFile()
  allele.names.file <- stringr::str_replace_all( file.path(softwarePath$netMHCpan$main, "data/allelenames" ),"//","/")
  if(file.exists(allele.names.file)==FALSE){
    stop("error: File not found")
  }
  HLA.table <- read.table(allele.names.file)
  
  HLA.group <- match.arg( alleleGroup, c("HLA","BoLA", "Gogo","H","H2", "Mamu", "Patr","SLA", "All"))
  if(HLA.group != "ALL") {
    HLA.table <- HLA.table[stringr::str_detect(HLA.table$V1,HLA.group),]
  }
  
  id <- c(seq(1,nrow(HLA.table),length.out = segmentsLength),nrow(HLA.table)+1)
  
  allele.list <- lapply(1:(length(id)-1), function(x) HLA.table$V1[id[x]:(id[x+1]-1)])
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