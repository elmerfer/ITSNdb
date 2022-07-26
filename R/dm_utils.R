#dm_utils.R
#dm.factor2variables <- function(fdat,base=0,target=1)
#ROCeval<-function(Predicted,True)
#dm.BuildBalanceWeights<-function(Y)
#dm.ConfusionMatrix<-function(O,P)
#dm.ClassificationError <-function(O,P)
#dm.minmax
#tablafreq
#funciones utiles para data mining
#loobc
#Loobc: function for
dm.factor2variables <- function(fdat,base=0,target=1){
#esta funcion mapea variables nominales (factors) en una matriz expandida
#parameters:
#	fdat:
  if(is.factor(fdat)==F)
    stop("ERROR: imput param should be factor")
  nl=levels(fdat)
  n <- length(fdat)
  nas <- is.na(fdat)
  mat=matrix(base,ncol=length(nl),nrow=n)
  mat[(1:n) + n*(unclass(fdat)-1)] <- target
  dimnames(mat) <- list(names(fdat), levels(fdat))
  if(sum(nas)>0) mat[nas,] <- NA
  mat
}
#ROC analisis
#parameters: Predicted: factor with 2 levesl of predicted classes. True: factor of 2 levels of the original *true) classes)
ROCeval<-function(Predicted,True){
  tab=table(Pred=Predicted, True = True)
  pos=which(dim(tab)==1);
  if(length(pos)>0){
  if(pos==1)
    tab=rbind(tab,c(0,0));
  if(pos==2)
    tab=cbind(tab,c(0,0));
    }


  TP=tab[1,1]
  TN=tab[2,2]
  FP=tab[1,2]
  FN=tab[2,1]
  Se=round(100*TP/(TP+FN),2)
  Sp=round(100*TN/(TN+FP),2)
  ERG=(1-Se/100)+(1-Sp/100)#error rate as defined by stolovizky
  PPV=round(100*TP/(TP+FP),2)
  NPV=round(100*TN/(TN+FN),2)
  DO=round(sqrt(((Se-100)^2)+((Sp-100)^2) +((PPV-100)^2)+((NPV-100)^2)),2)
  DOSeSp=round(sqrt((Se-100)^2+(Sp-100)^2),2)
  F1 <- 2*(Se*PPV)/(Se+PPV)
  return(list(Stats=data.frame(TP,TN,FP,FN,Se,Sp,PPV,NPV,DO,DOSeSp,ERG=ERG,F1=F1),Table=tab))
}

###############
###############
#----------------------
#this function create weight for each of the classes.
#the weigths are the frequency of representation
dm.BuildBalanceWeights<-function(Y){
	return(summary(as.factor(Y))/length(Y))
}
#-------------------------
#-----------
dm.ConfusionMatrix<-function(O,P){
	tt=table(P,O)
	cn=colnames(tt)
	rn=rownames(tt)
	md=nlevels(as.factor(O))
	tab=matrix(0,ncol=md,nrow=md)
	colnames(tab)=levels(O)
	rownames(tab)=levels(O)
	cnm=match(colnames(tab),cn)
	rnm=match(rownames(tab),rn)
 tab[which(is.finite(rnm)), which(is.finite(cnm))] = tt
	return(tab)
}
dm.ClassificationError <-function(O,P){

  ta=dm.ConfusionMatrix(P=as.factor(P),O=as.factor(O))

  OK=sum(diag(ta))

  nOK=sum(ta)-OK
	return(list(Tabla=ta,Good=OK,Bad=nOK,ER=100*nOK/(OK+nOK)))
}
#---------------------------------
# Basic Outlier detection ********
#---------------------------------
#Tabla de frecuencias para datos de conteo
tablafreq=function(x){
  xv=c(as.matrix(x));
  xi=sort(unique(xv));
  m=length(xi);
  ni=rep(0,m);
  for(i in 1:m){
    ni[i]=length(which(xi[i]==xv));
  }
  Nacc=cumsum(ni);
  fi=100*ni/Nacc[m];
  Facc=cumsum(fi);
  ret=data.frame(xi,ni,Nacc,Freq=round(fi,2),Facc=round(Facc,2))
  ord=order(xi)
  return(ret[ord,])
}

tablafre<-function(x){
ta=as.data.frame(table(x))
ta$Perc=round(100*ta$Freq/sum(ta$Freq),2)
ta$Ac=cumsum(ta$Freq)
ta$AcPerc=round(100*ta$Ac/sum(ta$Freq),2)
noceros=ta$Freq>0
return(ta[noceros,])
}

freqtable<-function(x,k=10){
  mi=min(x,na.rm=T);
  mx=max(x,na.rm=T);
  delta=(mx-mi)/k;
  delta_i_mi=mi;
  delta_i_mx=delta_i_mi+delta;
  rnames=rep(NA,k) #intervalo por fila
  rnames[1]=sprintf("[%.3f,%.3f)",delta_i_mi,delta_i_mx)
  ni=rep(NA,k)
  ni[1]=length(intersect(which(x>=delta_i_mi),which(x < delta_i_mx)))
  for(i in 2:k){
    delta_i_mi=delta_i_mx;
    delta_i_mx=delta_i_mi+delta;
    if(i==k)
      delta_i_mx=max(x)
    ni[i]=length(intersect(which(x>delta_i_mi),which(x <= (delta_i_mx))));
    rnames[i]=sprintf("(%.3f,%.3f]",delta_i_mi,delta_i_mx)
  }
  Ni=cumsum(ni)
  fi=ni/length(x)
  Fi=cumsum(fi)
  return(data.frame(Intervalo=rnames,ni,Ni,fi,Fi))
}

dm.minmax=function(mat){
  if(!any(class(mat) %in% c("matrix","data.frame")) ) stop("ERROR: matrix or data.frame expected")
  mx=apply(mat,2,max,na.rm=T)
  mn=apply(mat,2,min,na.rm=T)
  dif=mx-mn
  mat=(mat-matrix(rep(mn,each=nrow(mat)),ncol=ncol(mat),byrow=F))
  return(mat/matrix(rep(dif,each=nrow(mat)),ncol=ncol(mat),byrow=F))
#  return(mat)
}

loobc <- function(classes){
   min.n <- min(table(classes))
   min.c <- names(which.min(table(classes)))
   class.names <- names(table(classes))
   id.classes <- lapply(class.names , function(x) which(classes==x))
   sets <- lapply(1:min.n, function(x) unlist(lapply(id.classes, function(idc,j) idc[j],j=x  )))
   return(sets)
}

loobc <- function(classes){
  min.n <- min(table(classes))
  min.c <- names(which.min(table(classes)))
  class.names <- names(table(classes))
  id.classes <- lapply(class.names , function(x) which(classes==x))
  sets <- lapply(1:min.n, function(x) unlist(lapply(id.classes, function(idc,j) idc[j],j=x  )))
  return(sets)
}
#########################################################################
Loobc <- function(classes, mode = c("linear", "random"), times = 1){
##This function provides LOOBC data indexes
##Input:
##    classes: a factor vector with class labels
##    mode: "linear" or "random" . If linear, only one loobc set is provided with
##    the elements in order as they appear in the original order. If random: times sets of random order
##    the "random" mode avoids to perform permutations to reach different sets
##Output:
##    a list of set indexes. The length of the list will be times*#of items in the less represented class
##    if mode=="linear" times=1
  if(mode == "linear") return(loobc(classes))
  ## random sampling
  min.n <- min(table(classes))
  min.c <- names(which.min(table(classes)))
  class.names <- names(table(classes))
  id.classes <- lapply(class.names , function(x) which(classes==x))
  sets <- as.data.frame(do.call(cbind,
                                lapply(1:times,
                                       function(t) do.call(rbind,lapply(id.classes, function(x, mn) sample(x,mn) , mn = min.n)))))
  # return(sets)
   return(lapply(sets,function(x) x))
}
