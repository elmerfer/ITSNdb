% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/IEDB_CIImm.R
\name{RunClassIImmunogenicity}
\alias{RunClassIImmunogenicity}
\title{RunClassIImmunogenicity
It apply the Class I Immunogenicity (CIImm) score (IEDB) to cohort with a list of peptide-HLA pairs.
Up to now only 9-mer peptides}
\usage{
\dontrun{
df.to.test <- data.frame(Sample = c("Subject1","Subject1","Subject2"), Neoantigen=ITSNdb$Neoantigen[1:3],HLA = ITSNdb$HLA[1:3])
write.csv(df.to.test,file="MyPatientsNeoantigenList.csv",quote=F, row.names = F)
run predictions 
Cohort_results <- RunClassIImmunogenicity(pepsFile = "MyPatientsNeoantigenList.csv")
}
}
\arguments{
\item{pepFile}{the full path to the peptide-HLA pairs}
}
\value{
a data frame with the uploaded peptide_HLA pairs with extra columns added by the CIImm output
}
\description{
RunClassIImmunogenicity
It apply the Class I Immunogenicity (CIImm) score (IEDB) to cohort with a list of peptide-HLA pairs.
Up to now only 9-mer peptides
}
