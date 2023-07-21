# The Immunenogenic Tumor Specific Neoantigen database
The **ITSNdb** is a new  neoantigen database with know immunogenic and non immunogenic tumor specific antigenic peptides derived from genomic rearrangements, such as single nucleotide variants (SNVs), that satisfy the following criteria:
1. The wild type counterpart has been identified in the source protein
2. The MHC-I presentation has been experimentally validated
3. The positive or negative immunogenicity has been experimentally validated by, for instance, ELISPOT® 

In this sence, all peptides in the database have experimental confirmation of their positive/negative immunogenicity (classified as “Positive” and “Negative” neoantigens respectively) as well as their cell surface presentation.The neoantigens were collected and curated from published articles searched on PubMedTM using “neoantigen'' or “neoepitopes” as keywords. The ITSNdb only includes neoantigens whose inclusion criteria were explicitly described in its reference bibliography. 

## Cite

Nibeyro et al. [Unraveling Tumor Specific Neoantigen immunogenicity prediction: a comprehensive analysis](https://www.frontiersin.org/articles/10.3389/fimmu.2023.1094236/abstract) Front. Immunol.Sec. Cancer Immunity and Immunotherapy Volume 14 - 2023 | doi: 10.3389/fimmu.2023.1094236 

Nibeyro et al. [MHC-I binding affinity derived metrics fail to predict tumor specific neoantigen immunogenicity](https://doi.org/10.1101/2022.03.14.484285) BioRxiv

## Getting Started

## Requirements
In order to install the ITSNdb R library the following tools are required:

* The Multiple Sequence Alignment ([msa](https://bioconductor.org/packages/release/bioc/html/msa.html)) R library available on [Bioconductor](https://bioconductor.org/) 

## Installation
```
install.packages("remotes")
library(remotes)
install.packages("devtools")
library(devtools)
install_github("elmerfer/ITSNdb")
##load library
library(ITSNdb)
##load the data 
data(ITSNdb)
```
## Datasets for software performance evaluation included in ITSNdb package
* Val_dataset: validation dataset that simulates a patient neoantigen landscape, which includes 113 non-immunogenic neopeptides-HLA pairs with unvalidated MHC-I presentation; and 7 immunogenic, non-SNV derived, neoantigens-HLA pairs with both MHC-I presentation and immunogenicity experimentally validated.
  - References: [Robbins, P. *et al.*](https://pubmed.ncbi.nlm.nih.gov/23644516/), [Ehx, G. *et al.*](https://pubmed.ncbi.nlm.nih.gov/33740418/), [Huang, J. *et al.*](https://pubmed.ncbi.nlm.nih.gov/15128789/) and [Yang, W. *et al.*](https://pubmed.ncbi.nlm.nih.gov/31011208/).
  - Main usage: performance validation, prioritization evaluation.

* TNB_dataset: dataset containing a list of candidates tumor specific neoantigens predicted to bind to the MHC-I complex, of patients from six immune checkpoint blockade immunotherapy (ICB) treated cohorts, one non–small cell lung and five melanoma cancer cohorts, with ICB response association and TMB evaluation. 
  - References: [Rizvi, N. A. *et al.*](https://pubmed.ncbi.nlm.nih.gov/25765070/), [Van Allen, E. M. *et al.*](https://pubmed.ncbi.nlm.nih.gov/26359337/), [Snyder, A. *et al.*](https://pubmed.ncbi.nlm.nih.gov/25409260/), [Riaz, N. *et al.*](https://pubmed.ncbi.nlm.nih.gov/29033130/).
  - Main usage: biomarker applicability evaluation. 

### Usage

Once ITSNdb installed
```R
## Load library
library(ITSNdb)
## Load the data
data(Val_dataset)
data(TNB_dataset)
```

## Peptide binding affinity and/or immunogenicity predictors included in the ITSNdb package 
Here, in order to facilitate the exploration of state of the art tools for binding affinity prediction or immunogenicity score prediction, we implement easy to use interfaces for peptide-HLA binding affinity or immunogenicity prediction:

* Through R: [netMHCpan](https://services.healthtech.dtu.dk/service.php?NetMHCpan-4.1), [PRIME & mixMHCpred](https://github.com/GfellerLab/PRIME) and The [Class I Immunogenicity IEDB predictor](http://tools.iedb.org/immunogenicity/result/)
* Through [Colab](https://colab.research.google.com/) : [MHCflurry](https://openvax.github.io/mhcflurry/intro.html), [DeepImmune](https://github.com/frankligy/DeepImmuno) and [DeepHLApan](https://github.com/jiujiezz/deephlapan). 

In all cases the same file can be used to feed any platform, thus allowing easy comparison of the different methods. The R and Colab interfaces were implemented to facilitate the analisis of subject specific peptide-HLA pair list.

### Data Format [See Sample](https://github.com/elmerfer/ITSNdb/blob/main/MyPatientsNeoantigenList.csv)
In order to feed the methods, the file should contain peptide-HLA pairs with the following format

![DataFormat](https://github.com/elmerfer/ITSNdb/blob/main/DataFormat.png)


## Run the netMHCpan version 4.1 in R using the ITSNdb
The ITSNdb library allows the installation and use of the netMHCpan version 4.1 software to predict peptide binding affinity to MHC-I molecules.
(up to now only available for Linux, Mac in progress)
### Check if the appropriate C shell is installed in your machine
To verify if you have it in your machine, please type from a console terminal the following command 
'tcsh --version'
if succeed you will see something like this:
![tsch output](https://github.com/elmerfer/ITSNdb/blob/main/tsch.shell.png)

if not installed try 'sudo apt-get install tcsh' and verify. 

### Installation of netMHCpan with ITSNdb into R
Follow the instructions and fill the form to receive the rights to download [netMHCpan](https://services.healthtech.dtu.dk/service.php?NetMHCpan-4.1) 
and save it in your favorite directory.
![Download](https://github.com/elmerfer/ITSNdb/blob/main/DownloadV4.1.png)

#### Up to now only the linux version.

Onpen an R session or RStudio and type:
```R
install.packages("devtools")
library(devtools)
install_github("elmerfer/ITSNdb")
#load library
library(ITSNdb)
#file.choose() will open a window selector to look for the downloaded file
Install_netMHCPan(file.choose(), dir = "/where i whant to install it/dir")
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
Cohort_results <- RunNetMHCPan(pepFile = "MyPatientsNeoantigenList.csv")
Cohort_results
  Neoantigen   Sample        HLA NetMCpan_Pos NetMCpan_MHC NetMCpan_Core NetMCpan_Of NetMCpan_Gp NetMCpan_Gl NetMCpan_Ip NetMCpan_Il
1  GRIAFFLKY Subject1 HLA-B27:05            1  HLA-B*27:05     GRIAFFLKY           0           0           0           0           0
2  LPIQYEPVL Subject1 HLA-B35:03            1  HLA-B*35:03     LPIQYEPVL           0           0           0           0           0
3  KLILWRGLK Subject2 HLA-A03:01            1  HLA-A*03:01     KLILWRGLK           0           0           0           0           0
  NetMCpan_Icore NetMCpan_Identity NetMCpan_Score_EL NetMCpan_%Rank_EL NetMCpan_Score_BA NetMCpan_%Rank_BA NetMCpan_Aff(nM)
1      GRIAFFLKY           PEPLIST         0.9810120             0.009          0.659218             0.103            39.93
2      LPIQYEPVL           PEPLIST         0.9816510             0.004          0.690369             0.008            28.51
3      KLILWRGLK           PEPLIST         0.7217850             0.184          0.733193             0.049            17.94
  NetMCpan_BindLevel
1                 SB
2                 SB
3                 SB
```
## Installation of [PRIME](https://github.com/GfellerLab/PRIME) (PRedictor of class I IMmunogenic Epitopes) in R using the ITSNdb
PRIME is a PRedictor of class I IMmunogenic Epitopes. It combines predictions of binding to HLA-I molecules and propensity for TCR recognition.

Here we provide an R interface to install and use PRIME in your local machine.

### Install PRIME and its dependencies
#### Up to now only the linux version.

Onpen an R session or RStudio and type:
```R
install.packages("devtools")
library(devtools)
install_github("elmerfer/ITSNdb")
#load library
library(ITSNdb)
Install_PRIME(dir = "/where i whant to install it/dir")
#if success, the following message should appear
PRIME Installation OK
```
### Predict peptide-MHC-I binding affinities and immunogenicity scores from a cohort study
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
Cohort_results <- RunPRIME(pepFile = "MyPatientsNeoantigenList.csv")
Cohort_results
  Neoantigen   Sample        HLA PRIME_Rank_bestAllele PRIME_Score_bestAllele PRIME_RankBinding_bestAllele PRIME_BestAllele PRIME_Rank
1  GRIAFFLKY Subject1 HLA-B27:05                 0.001               0.302405                        0.012            B2705      0.001
2  LPIQYEPVL Subject1 HLA-B35:03                 0.001               0.312395                        0.001            B3503      0.001
3  KLILWRGLK Subject2 HLA-A03:01                 0.132               0.108694                        0.336            A0301      0.132
  PRIME_Score PRIME_RankBinding
1    0.302405             0.012
2    0.312395             0.001
3    0.108694             0.336
```

### You can also predict only binding affinity scores trough mixMHCpred (automatically installed when installing PRIME)
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
Cohort_results <- RunMixMHCpred(pepFile = "MyPatientsNeoantigenList.csv")
Cohort_results
    Neoantigen   Sample        HLA MixMHCpred_Score_bestAllele MixMHCpred_BestAllele MixMHCpred_Rank_bestAllele MixMHCpred_Score
1  GRIAFFLKY Subject1 HLA-B27:05                    0.498937                 B2705                  0.0118114         0.498937
2  LPIQYEPVL Subject1 HLA-B35:03                    1.243759                 B3503                  0.0010000         1.243759
3  KLILWRGLK Subject2 HLA-A03:01                   -0.428836                 A0301                  0.3362680        -0.428836
  MixMHCpred_Rank
1       0.0118114
2       0.0010000
3       0.3362680
```

## Estimating immunogenicity score by means of the Class I Immunogenicity IEDB function developped by [Calis et al](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3808449/)
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
Cohort_results <- RunClassIImmunogenicity(pepFile = "MyPatientsNeoantigenList.csv")
Cohort_results
    Sample Neoantigen        HLA   CIImm
1 Subject1  GRIAFFLKY HLA-B27:05 0.17141
2 Subject1  LPIQYEPVL HLA-B35:03 0.03205
3 Subject2  KLILWRGLK HLA-A03:01 0.31858
```

## Estimate immunogenic scores or affinities of peptide-HLA pairs from ITSNdb or cohort studies by using DeepHLApan, DeepImmune and MHCflurry in Colab environments

Each colab session allows to upload only one file, to upload a second one please terminate the current session and start a new one

## Running DeepImmuno
[![Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/elmerfer/ITSNdb/blob/main/Colab/DeepImmuno_Colab.ipynb)
## Running MHCFlurry
[![Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/elmerfer/ITSNdb/blob/main/Colab/MHCFlurry_Colab.ipynb)
## Running DeepHLApan
[![Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/elmerfer/ITSNdb/blob/main/Colab/DeepHLApan_Colab.ipynb)

## Authors
* **Elmer A. Fernández - *Idea* and Developer - [Profile](https://www.researchgate.net/profile/Elmer_Fernandez) - [CONICET](http://www.conicet.gov.ar) - [FPM](https://fpmlab.org.ar/) 
* **Guadalupe Nibeyro - Curator and Developer - [CONICET](http://www.conicet.gov.ar) - [FPM](https://fpmlab.org.ar/) 
* **Juan Ignacio Folco - Python and Colab Developer - 
* **Verónica Baronetto - Tester - [CONICET](http://www.conicet.gov.ar) - [FPM](https://fpmlab.org.ar/)
* **Pablo Pastore - Advisor - [AnyoneAI](https://anyoneai.com/)
