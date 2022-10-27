## To build this data sets, they should be saved using save function

#' ITSNdb
#' 
#' The New Immunogenic Tumor Specific Neoantigens database
#' holding only neoantigens whose MCH-I binding was experimentally validated and resulted positive, with immunogenicity assay performed
#' 
#' \itemize{
#' \item Tumor: Tumor where the neoantigen was reported
#' \item Author: Name of the first author in reference manuscript
#' \item Paper: URL of the reference manuscript
#' \item Neoantigen: Aminoacid sequence of the mutated neoantigen
#' \item WT: Aminoacid sequence of the wild type peptide originating the neoantigen
#' \item HLA: HLA associated to the neoantigen
#' \item NeoType: Positive if the neoantigen immunogenicity assay resulted positive, Negative otherwise
#' \item mutPosition: Position of the mutation in the neoantigen aminoacid sequence
#' \item PositionType: Position type of the mutation, Anchor position if MutPosition = 2 or 9, non-Anchor otherwise
#' \item GeneSymbol: Symbol of the gene that codes for the protein of origin
#' \item Length: Neoantigen length
#' }
#' @docType data
#' @keywords datasets
#' @name ITSNdb
#' @usage data(ITSNdb)
#' @format A data frame with 199 rows (neoantigens) and 11 variables (neoantigens info)
NULL

#' MHC_allele_names.txt
#' 
#' the New Immunogenic Tumor Specific Neoantigens database
#' Only neoantigens whose MCH-I binding was experimentally validated and resulted positive and they also have the immunologic assay performed
#' 
#' \itemize{
#' \item Alleles : all the possible alleles names for MHC-I
#' }
#' @docType data
#' @keywords datasets
#' @name MHC_allele_names
#' @usage data(MHC_allele_names)
#' @format A data frame with 1 column and 3584 rows
NULL

#' TNB_dataset
#' 
#' Clinical ICB cohort 
#' containing putative neoantigens from patients of 6 different clinical cohorts, associated with immunotherapy response 
#' 
#' \itemize{
#' \item Sample: Patient where the neoantigen was reported
#' \item Neoantigen: Aminoacid sequence of the mutated putative neoantigen
#' \item HLA: HLA associated to the putative neoantigen
#' \item Response: Clinical response to ICB
#' \item Cohort: Cohort where the patient was reported
#' }
#' @docType data
#' @keywords datasets
#' @name TNB_dataset
#' @usage data(TNB_dataset)
#' @format A data frame with 99489 rows (neoantigens) and 5 variables (neoantigens metadata)
NULL

#' Val_dataset
#' 
#' Validation dataset, real scenario simulation 
#' containing 113 non-immunogenic neopeptides and 7 immunogenic neoantigens from genomic rearrengements different than SNVs 
#' 
#' \itemize{
#' \item Sample: Negative or positive immunogenicity
#' \item Neoantigen: Aminoacid sequence of the mutated neoantigen
#' \item HLA: HLA associated to the neoantigen
#' \item Author: Name of the first author in reference manuscript
#' \item Origin: Genomic event that originated the neoantigen
#' }
#' @docType data
#' @keywords datasets
#' @name Val_dataset
#' @usage data(TNB_dataset)
#' @format A data frame with 120 rows (neoantigens) and 5 variables (neoantigens metadata)
NULL