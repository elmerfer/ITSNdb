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
# netMHCpan version 4.1
The ITSNdb library allows the installation and use of the netMHCpan version 4.1 software to predict peptide binding affinity to MHC-I molecules.
(up to now only available for Linux, Mac in progress)
### Check if the appropriate C shell is installed in your machine
To verify if you have it in your machine, please type from a console terminal the following command 
'tsch --version'
if succeed you will see something like this:
![tsch output](https://github.com/elmerfer/RAPInetMHCpan/blob/master/tsch.shell.png)
if not installed try 'sudo apt-get install tcsh' and verify. 

## Installation
```
install.packages("devtools")
library(devtools)
install_github("elmerfer/ITSNdb")
#load library
library(ITSNdb)
install_netMHCPan(choolse.file(), )
```


## Authors
* **Elmer A. Fernández - *Idea* - [Profile](https://www.researchgate.net/profile/Elmer_Fernandez) - [CIDIE]- [CONICET](http://www.conicet.gov.ar) - [UCC](http://www.ucc.edu.ar) 
* **Guadalupe Nibeyro - Curator and Developer - [CIDIE]- [CONICET](http://www.conicet.gov.ar) - [UCC](http://www.ucc.edu.ar) 
