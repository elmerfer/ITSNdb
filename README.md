# The Immunenogenic Tumor Specific Neoantigen database
The ITSNdb is a new  neoantigen database with know immunogenic and non immunogenic tumor specific antigenic peptides derived from genomic rearrangements such as single nucleotide variants (SNVs),  nucleotide insertions or deletions (INDELS), alternative splicing and/or gene fusion, among others, that may produce dysfunctional proteins by either non-synonymous alterations or changes in open reading frames. Then, processed by the proteasome they mey be presented on the cell surface bound to the MHC-I molecule (i.e., neoantigens) and, potentially, triggering an immune response if recognized by T cell receptors.

The ITSNdb is a manually curated neoantigen database created by means of a novel approach, where the peptide inclusion criteria are: 

* peptides derived from non-silent somatic SNVs with their wild type (WT) peptide sequence counterpart referenced protein sequence
* Experimentally validated binding to the MHC-I complex
* Tested on immunogenic assays (i.e. tetramer titration and IFN-γ or TNF ELISPOT®). 

Therefore, all peptides in the database have experimental confirmation of their positive/negative immunogenicity (classified as “Positive” and “Negative” neoantigens respectively).The neoantigens were collected and curated from published articles searched on PubMedTM using “neoantigen'' or “neoepitopes” as keywords. The ITSNdb only includes neoantigens whose inclusion criteria were explicitly described in its reference bibliography. 

## Getting Started


## Installation
```
install.packages("devtools")
library(devtools)
install_github("elmerfer/ITSNdb")
##load library
library(ITSNdb)
##load the data 
data(ITSNdb)
```
## Run the netMHCpan version 4.1 in R using the ITSNdb
The ITSNdb library allows the installation and use of the netMHCpan version 4.1 software to predict peptide binding affinity to MHC-I molecules.
(up to now only available for Linux, Mac in progress)
### Check if the appropriate C shell is installed in your machine
To verify if you have it in your machine, please type from a console terminal the following command 
'tsch --version'
if succeed you will see something like this:
![tsch output](https://github.com/elmerfer/ITSNdb/blob/main/tsch.shell.png)

if not installed try 'sudo apt-get install tcsh' and verify. 

### Installation of netMHCpan and netMHCIIpan with RAPInetMHCpan into R
Follow the instructions and fill the form to receive the rights to download [netMHCpan](https://services.healthtech.dtu.dk/service.php?NetMHCpan-4.1) 
and save it to your favorite directory.
![Download](https://github.com/elmerfer/ITSNdb/blob/main/DownloadV4.1.png)

#### Up to now only the linux version.

Onpen an R session or RStudio and type:
```R
install.packages("devtools")
library(devtools)
install_github("elmerfer/ITSNdb")
#load library
library(ITSNdb)
#choose.file() will open a window selector to look for the downloaded file
install_netMHCPan(choose.file(), dir = "/where i whant to install it/dir")
#if success, the following message should appear
netMHCpan Installation OK
```

### Estimate binding affinity from a peptide
```R
data(ITSNdb)
ITSNdb$Neoantigen[1]
[1] "GRIAFFLKY"
ITSNdb$HLA[1:2]
[1] "HLA-B27:05" "HLA-B35:03"
results <- RunNetMHCPan_peptides(peps=ITSNdb$Neoantigen[1], alleles = ITSNdb$HLA[1:2])
results
$`HLA-B27:05`
  Pos         MHC   Peptide      Core Of Gp Gl Ip Il     Icore Identity  Score_EL %Rank_EL Score_BA %Rank_BA Aff(nM) BindLevel
1   1 HLA-B*27:05 GRIAFFLKY GRIAFFLKY  0  0  0  0  0 GRIAFFLKY  PEPLIST 0.9810120    0.009 0.659218    0.103   39.93        SB

$`HLA-B35:03`
  Pos         MHC   Peptide      Core Of Gp Gl Ip Il     Icore Identity  Score_EL %Rank_EL Score_BA %Rank_BA  Aff(nM) BindLevel
1   1 HLA-B*35:03 GRIAFFLKY GRIAFFLKY  0  0  0  0  0 GRIAFFLKY  PEPLIST 0.0000600   31.333 0.009315   55.345 45206.31      <NA>
```
### Predict peptide-MHC-I binding affinities from a cohort study
```R
## we will build a simulated cohort study with two subjects
df.to.test <- data.frame(Sample = c("Subject1","Subject1","Subject2"), Neoantigen=ITSNdb$Neoantigen[1:3],HLA = ITSNdb$HLA[1:3])
df.to.test
    Sample Neoantigen        HLA
1 Subject1  GRIAFFLKY HLA-B27:05
2 Subject1  LPIQYEPVL HLA-B35:03
3 Subject2  KLILWRGLK HLA-A03:01
# we will save it in a comma separated text file in the working directory
write.csv(df.to.test,file="MyPatientsNeoantigenList.csv",quote=F, row.names = F)
#run predictions 
Cohort_results <- RunNetMHCPan_pMHC(pMHCfile = "MyPatientsNeoantigenList.csv")
Cohort_results
  Neoantigen   Sample        HLA Pos         MHC      Core Of Gp Gl Ip Il     Icore Identity  Score_EL %Rank_EL Score_BA %Rank_BA Aff(nM) BindLevel
1  GRIAFFLKY Subject1 HLA-B27:05   1 HLA-B*27:05 GRIAFFLKY  0  0  0  0  0 GRIAFFLKY  PEPLIST 0.9810120    0.009 0.659218    0.103   39.93        SB
2  LPIQYEPVL Subject1 HLA-B35:03   1 HLA-B*35:03 LPIQYEPVL  0  0  0  0  0 LPIQYEPVL  PEPLIST 0.9816510    0.004 0.690369    0.008   28.51        SB
3  KLILWRGLK Subject2 HLA-A03:01   1 HLA-A*03:01 KLILWRGLK  0  0  0  0  0 KLILWRGLK  PEPLIST 0.7217850    0.184 0.733193    0.049   17.94        SB
```


## Authors
* **Elmer A. Fernández - *Idea* - [Profile](https://www.researchgate.net/profile/Elmer_Fernandez) - [CIDIE]- [CONICET](http://www.conicet.gov.ar) - [UCC](http://www.ucc.edu.ar) 
* **Guadalupe Nibeyro - Curator and Developer - [CIDIE]- [CONICET](http://www.conicet.gov.ar) - [UCC](http://www.ucc.edu.ar) 
