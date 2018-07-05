#' Knit SeeGEM with peddy stats
#' 
#' Create the interactive html document
#' 
#' @param rmd Path to a custom R markdown file. A default R markdown file is 
#' provided with this package.
#' @param GEMINI_data Path to .Rdata data frame which contains the Data Frame 
#' of the GEMINI output that will be plotted. Helper scripts are provided as 
#' \code{\link{gemini_test_wrapper}} and \code{\link{gemini_query_wrapper}} 
#' which will return the GEMINI output as a data frame into your R session. 
#' @param peddy_stats Path and prefix for the peddy output
#' 
#' @return None
#' 
#' @export

knit_see_gem <- function(rmd = system.file("rmd/document_template.Rmd", package="SeeGEM"),
                         output_file = '~/SeeGEM_document.html',
                         GEMINI_data = system.file("extdata/GEMINI_data.Rdata", package="SeeGEM"),
                         peddy_path_prefix = paste0(system.file("extdata/", package="SeeGEM"), "SEE_GEM_PEDDY"),
                         peddy_id = c('1045', '1046', '1265'),
                         skip_stats = 'no',
                         sample_name = 'BLANK',
                         title = "SeeGEM Test Report"){
  
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
