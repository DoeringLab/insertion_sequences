# Load necessary libraries
library(tidyverse)

# copied from https://github.com/GreshamLab/labtools

#' Make a gff from a snap gene file
#'
#' this is a function that takes a csv with features generated from snapgene, and converts it into a gff format
#' when exporting features from snapgene, export all feature data (csv should have 5 columns)
#'
#' @param file_path the file_path is the name of the csv which has the snapgene feature output
#' @param chromosome is the chromosome the features are on.
#' @param feature_source is what you want in the source column
#' @param output is what you want your output gff to be called (should be .gff)
#' @examples
#' \dontrun{
#' labtools::make_gff_from_snap("~/Projects/Data/SnapBarcodeLibrary1.csv", chromosome = "II", feature_source = "levy_bc", output = "./Bc.gff")
#' }
#' @return A file formatted as a gff

make_gff_from_snap <- function(file_path, chromosome, feature_source, output) {
  feats <- readr::read_csv(file_path, col_names = FALSE)
  feats_edit <- feats %>%
    dplyr::mutate(seqid = chromosome, source = feature_source, score = '.', phase = '.') %>%
    dplyr::mutate(strand = dplyr::case_when(X4 == '<=' ~ '-', X4 == '==' ~ '+', X4 == '=>' ~ '+')) %>%
    tidyr::separate(X2, c("start", "end"), "\\..") %>%
    dplyr::rename(attributes = X1, type = X5) %>%
    dplyr::select(seqid, source, type, start, end, score, strand, phase, attributes)

  readr::write_tsv(feats_edit, file = output, col_names = FALSE)
}

args <- commandArgs(trailingOnly = TRUE)
make_gff_from_snap(args[1], args[2], args[3], args[4])

