#' onLoad
.onLoad <- function(libname=NULL, pkgname="ITSNdb"){
  # load("./data/ITSNdb.RData")
  # pkgmaker::onLoad(libname, pkgname)
  
}

### Configuration files ####

#  .OpenConfigFile
#'
#' internal function to load configuration info.
#'
#'
#' @details It will create a ITSNdb.RDS file with software location paths and version
#'  PLEASE DO NOT DELET this file
#'
#' @return
#' the configuration list. Each slot holds one software
#'
.OpenConfigFile <- function(cf){
  if(missing(cf)){##read the configfile
    if( file.exists(file.path(.libPaths()[1],"ITSNdb.RDS")) == TRUE ){
      config.list <- readRDS(file.path(.libPaths()[1],"ITSNdb.RDS"))
      # cat("\nConfig file exists")
    }else{
      config.list <- NULL
      cat("\nConfig file NOT exists")
      # config.list$main$path <- file.path(dirname("~/.local/bin"),"bin")
      # if(dir.exists(config.list$main$path) == FALSE){
      #   dir.create(config.list$main$path)
      #   if(dir.exists(config.list$main$path) == FALSE){
      #     stop(paste("ERROR: Please verify dir creation permitions at",dirname(config.list$main$path)))
      #   }
      # }  
    }
  }else{
    saveRDS(cf,file.path(.libPaths()[1],"ITSNdb.RDS"))
    if( file.exists(file.path(.libPaths()[1],"ITSNdb.RDS")) == FALSE ){
      stop("ERROR can create ConfigFile")
    }
    config.list<-cf
  }
  return(config.list)
}


.removeConfigFile <-function(){
  if( file.exists(file.path(.libPaths()[1],"ITSNdb.RDS")) == TRUE ){
    file.remove(file.path(.libPaths()[1],"ITSNdb.RDS"))
  }
}
