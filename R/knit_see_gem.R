#' Knit SeeGEM with peddy stats
#' 
#' Create the interactive html document
#' 
#' @param rmd Path to a custom R markdown file. A default R markdown file is 
#' provided with this package
#' @param output_file Path and name (I recommend ending in 'html', as this is what the file
#' is) of your output file. 
#' @param GEMINI_data Path to .Rdata data frame which contains the Data Frame 
#' of the GEMINI output that will be plotted. Helper scripts are provided as 
#' \code{\link{gemini_test_wrapper}} and \code{\link{gemini_query_wrapper}} 
#' which will return the GEMINI output as a data frame into your R session. 
#' @param sample_name The name of your sample
#' @param title The title of the document
#' @param peddy_path_prefix Path and prefix for the peddy output
#' @param peddy_id A character vector of the samples you want to highlight in the
#' peddy QC tab
#' @param skip_stats If set to 'yes' this will use an alternate template which
#' has no `peddy QC` tab. 
#' 
#' @return None
#' 
#' @import rmarkdown
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

knit_see_gem <- function(rmd = system.file("rmd/document_template.Rmd", package="SeeGEM"),
                         output_file = '~/SeeGEM_document.html',
                         GEMINI_data = system.file("extdata/GEMINI_data.Rdata", package="SeeGEM"),
                         sample_name = NA,
                         title = "SeeGEM Test Report",
                         peddy_path_prefix = paste0(system.file("extdata/", package="SeeGEM"), "SEE_GEM_PEDDY"),
                         peddy_id = c('1045', '1046', '1265'),
                         skip_stats = 'no'){
  
  if (skip_stats == 'no'){
    rmarkdown::render(system.file("rmd/document_template.Rmd", package="SeeGEM"),
                      output_file = output_file,
                      params = list(GEMINI_data_frame = GEMINI_data,
                                    sample_name = sample_name,
                                    title = title,
                                    peddy_id = peddy_id,
                                    peddy_path_prefix = peddy_path_prefix))
  } else{
    rmarkdown::render(system.file("rmd/document_template_noStats.Rmd", package="SeeGEM"),
                      output_file = output_file,
                      params = list(GEMINI_data_frame = GEMINI_data,
                                    sample_name = sample_name,
                                    title = title))
  }
  
}
