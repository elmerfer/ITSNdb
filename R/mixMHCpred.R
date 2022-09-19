##install mixMHCpred

.IntallMixMHCpred <- function(dir = "./"){
  dir <- "/media/respaldo4t/Guada/"
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
  con <- file(fpath,)
  conf.file <- readLines(fpath)
  id <- which(stringr::str_detect(conf.file, "lib_path="))
  conf.file[id] <- paste0("lib_path=","\"",software$mixMHCpred$main,"/lib")
  writeLines(conf.file, con=fpath)
  
  system2(command = "g++", 
          args = c( file.path(software$mixMHCpred$main,"lib","MixMHCpred.cc"), 
                   paste0("-o ",file.path(software$mixMHCpred$main,"lib","MixMHCpred.x"))))
  system2(command = "chmod", args = c("a=x", file.path(software$mixMHCpred$main,"MixMHCpred")))
  
  software$mixMHCpred$command <- file.path(software$mixMHCpred$main,"MixMHCpred")
 system2(command = software$mixMHCpred$command , args = "-h")
           
           
           c(paste0("-i ", file.path(software$mixMHCpred$main,"test","test.fa")),
                                                         paste0("-o",file.path(software$mixMHCpred$main,"test","out.R.txt")),
                                                         "- 0 A0101") ) 
}

.WriteMixMHCpred.config <- function(fpath){
  fpath <- "/media/respaldo4t/Guada/MixMHCpred-master/MixMHCpred"
  conf.file <- readLines(fpath)
  id <- which(stringr::str_detect(conf.file, "lib_path="))
  conf.file[id] <- paste0()
              
}