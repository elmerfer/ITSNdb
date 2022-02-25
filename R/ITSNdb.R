#' ITSNdb
#' 
#' the New Immunogenic Tumor Specific Neoantigens database
#' Only neoantigens whose MCH-I binding was experimentally validated and resulted positive and they also have the immunologic assay performed
#' 
#' \itemize{
#' \item Paper : URL of the reference manuscript
#' \item Author : Name of the first author
#' \item Sequence : Aminoacid sequence of the mutated neoantigen
#' \item WT : Aminoacid sequence of the wild type peptide orginating the neoantigen (only for SNV neoantigens)
#' \item MutPosition : Position of the mutation in the neoantigen
#' \item PositionType : Position type of the mutation regarding its position, Anchor position if MutPosition = 2 or 9, non-Anchor otherwise
#' \item Gene : Gene symbol of the protein
#' \item Tumor : Tumor where the neoantigen was reported
#' \item HLA : HLA associated to the neoantigen
#' \item Class : Positive if the neoantigen immunogenicity was positive, Negative otherwise
#' }
#' @docType data
#' @keywords datasets
#' @name ITSNdb
#' @format A data frame with 61 rows (neoantigens) and 10 variables (neoantigens info)
NULL