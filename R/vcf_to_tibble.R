#' VCF to tibble
#' 
#' Creates a tidy tibble from a VCF file
#' 
#' @param VCF Path to a VCF
#' 
#' @return None
#' 
#' @import vcfR
#' @import dplyr
#' 
#' @export
#' 
#' @examples 
#' 
#' vcf_to_tibble(system.file("extdata/example.vcf.gz", package="SeeGEM"))
#' 

vcf_to_tibble <- function(VCF){
  vcf <- vcfR2tidy(read.vcfR(VCF))
  fix_and_gt <-  cbind(vcf$fix, vcf$gt[,!names(vcf$gt) %in% c('ChromKey','POS')])
  fix_and_gt
}
