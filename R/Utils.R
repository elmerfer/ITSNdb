library(msa)
#function to obtain frecuency matrix
FreqMatrix<- function(classSubMatrix){
  alphabet <- c('A', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'K', 'L', 'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'V', 'W', 'Y')
  n <- stringr::str_length(classSubMatrix[1])
  Base_matrix <- matrix(0, nrow=length(alphabet), ncol=n)
  rownames(Base_matrix) <- alphabet
  concensusM <- consensusMatrix(classSubMatrix)
  Base_matrix[row.names(concensusM),] <- concensusM
  freqM <- round(100*Base_matrix/length(classSubMatrix), 2)
  
  return(freqM) 
} 

softmax <- function(mat){
  t(apply(mat,1,function(x) exp(x)/sum(exp(x))))
}

#Example
# matrix_neg_neo <- freqMatrixFunction(No_immunogNeo, 9) 

#create a dataframe with frecuencies values of each secuence
vectorFrecDFfunction <- function(seqVector,frecMatrix) {
  Len <- length(seqVector)
  sl <- stringr::str_length(seqVector[1])
  if(sl!=ncol(frecMatrix)){
    stop("error")
  }
  dfseqV <- data.frame(matrix(0, nrow = Len, ncol = sl))
  for(z in 1:Len){
    seqV <- unlist(strsplit((seqVector[z]),""))
    newV <- rep(0,sl)
    for(i in 1:sl){
      newV[i] <- frecMatrix[seqV[i],i] 
    }
    dfseqV[z,] <- newV
  }
  return(dfseqV)
}

#Example
Pos_vect_frec_df <- vectorFrecDFfunction(curatedDB$Sequence,matrix_pos_neo,9)