#' Knit SeeGEM from tidy data
#' 
#' Create the interactive html document from a data frame / tibble
#' 
#' @param rmd Path to a custom R markdown file. A default R markdown file is 
#' provided with this package
#' @param output_file Output name (I recommend ending in 'html', as this is what the file
#' is) of your output file. 
#' @param output_directory Directory the output file will be written to. 
#' Defaults to your working directory.
#' @param table_data Data frame (or tibble) to be knit 
#' @param sample_name The name of your sample
#' @param title The title of the document
#' 
#' @return None
#' 
#' @import rmarkdown
#' @import tidyr
#' @import ggplot2
#' @import knitr
#' 
#' @export
#' 
#' @examples 
#' \dontrun{
#' # will output just the example document to ~/SeeGEM_document.html
#' knit_see_gem()
#' # more realistic example which does an automsal recessive test 
#' knit_see_gem(GEMINI_data = 
#' gemini_test_wrapper('2018_06_28__OGVFB_exomes.GATK.PED_master.gemini.db', 
#' test = 'autosomal_recessive', 
#' families = 'DDL003'), 
#' output_file='~/quick_SeeGEM.html', 
#' skip_stats = 'yes')
#' }

knit_see_gem_from_table <- function(rmd = system.file("rmd/document_template_from_table.Rmd", package="SeeGEM"),
                         output_file = 'SeeGEM_document.html',
                         output_directory = getwd(),
                         table_data, 
                         sample_name = NA,
                         title = "SeeGEM Test Report"){
  
  rmarkdown::render(system.file("rmd/document_template_from_vcf.Rmd", package="SeeGEM"),
                    output_file = output_file,
                    output_dir = output_directory,
                    params = list(data_frame = table_data,
                                  sample_name = sample_name,
                                  title = title))
  
  
}
