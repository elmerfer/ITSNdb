## To build this data sets, they should be saved using save function

#' ITSNdb
#' 
#' the New Immunogenic Tumor Specific Neoantigens database
#' Only neoantigens whose MCH-I binding was experimentally validated and resulted positive and they also have the immunologic assay performed
#' 
#' \itemize{
#' \item Paper : URL of the reference manuscript
#' \item Author : Name of the first author
#' \item Sequence : Aminoacid sequence of the mutated neoantigen
#' \item WT : Aminoacid sequence of the wild type peptide originating the neoantigen (only for SNV neoantigens)
#' \item MutPosition : Position of the mutation in the neoantigen
#' \item PositionType : Position type of the mutation regarding its position, Anchor position if MutPosition = 2 or 9, non-Anchor otherwise
#' \item Gene : Gene symbol of the protein
#' \item Tumor : Tumor where the neoantigen was reported
#' \item HLA : HLA associated to the neoantigen
#' \item Class : Positive if the neoantigen immunogenicity was positive, Negative otherwise
#' \item NeoantigenType : The genomic rearrangement that generate the neoantigen i.e "SNV", "Fusion", "INS", "DEL"
#' \Item Length : neoantígen length
#' }
#' @docType data
#' @keywords datasets
#' @name ITSNdb
#' @usage load(ITSNdb)
#' @format A data frame with 61 rows (neoantigens) and 10 variables (neoantigens info)
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
#' @usage load(MHC_allele_names)
#' @format A data frame with 1 column and 3584 rows
NULL