# The Immunenogenic Tumor Specific Neoantigen database
The ITSNdb is a new  neoantigen database with know immunogenic and non immunogenic tumor specific antigenic peptides derived from genomic rearrangements such as single nucleotide variants (SNVs),  nucleotide insertions or deletions (INDELS), alternative splicing and/or gene fusion, among others, that may produce dysfunctional proteins by either non-synonymous alterations or changes in open reading frames. Then, processed by the proteasome they mey be presented on the cell surface bound to the MHC-I molecule (i.e., neoantigens) and, potentially, triggering an immune response if recognized by T cell receptors.

The ITSNdb is a manually curated neoantigen database created by means of a novel approach, where the peptide inclusion criteria are: 

* peptides derived from non-silent somatic SNVs with their wild type (WT) peptide sequence counterpart referenced protein sequence
* Experimentally validated binding to the MHC-I complex
* Tested on immunogenic assays (i.e. tetramer titration and IFN-γ or TNF ELISPOT®). 

Therefore, all peptides in the database have experimental confirmation of their positive/negative immunogenicity (classified as “Positive” and “Negative” neoantigens respectively).The neoantigens were collected and curated from published articles searched on PubMedTM using “neoantigen'' or “neoepitopes” as keywords. The ITSNdb only includes neoantigens whose inclusion criteria were explicitly described in its reference bibliography. 

# Version 022022
This novel Immunogenic Tumor Specific Neoantigen Database, ITSNdb, holds 9-mer SNV derived neoantigens together with its WT peptide counterpart. For each neoantigen, their restricted HLA information, gene, tumor tissue and reference were included. Figure 1A describes the current peptides distribution among tumor types, immunogenicity, mutation position and mutation position type (i.e. MHC anchor position if the amino acid change was located at position 2 or 9 in the sequence and MHC non-anchor position). In Figure 1B, the peptide count distribution for HLA restriction type is shown, whereas HLA A02:01 represents 63.93% of the HLA restricted peptides.

## Getting Started


## Installation
```
install.packages("devtools")
library(devtools)
install_github("elmerfer/ITSNdb")
##load the data 
load(ITSNdb)
```

## Authors
* **Elmer A. Fernández - *Idea* - [Profile](https://www.researchgate.net/profile/Elmer_Fernandez) - [CIDIE]- [CONICET](http://www.conicet.gov.ar) - [UCC](http://www.ucc.edu.ar) 
* **Guadalupe Nibeyro - Curator and Developer - [CIDIE]- [CONICET](http://www.conicet.gov.ar) - [UCC](http://www.ucc.edu.ar) 
