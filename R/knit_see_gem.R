#' Knit SeeGEM 
#' 
#' Create the interactive html document
#' 
#' @param rmd Path to a custom R markdown file. A default R markdown file is 
#' provided with this package.
#' @param GEMINI_data Path to .Rdata data frame which contains the Data Frame 
#' of the GEMINI output that will be plotted. Helper scripts are provided as 
#' \code{\link{gemini_test_wrapper}} and \code{\link{gemini_query_wrapper}} 
#' which will return the GEMINI output as a data frame into your R session. 
#' 
#' @return None
#' 
#' @export

knit_see_gem <- function(rmd = system.file("rmd/document_template.Rmd", package="SeeGEM"),
                         output_file = 'SeeGEM_document.html',
                         GEMINI_data = system.file("extdata/GEMINI_data.Rdata", package="SeeGEM")){
  rmarkdown::render(system.file("rmd/document_template.Rmd", package="SeeGEM"),
                    output_file = output_file,
                    params = list(GEMINI_data_frame = GEMINI_data,
                                  sample_name = "Sample 007",
                                  title = "SeeGEM Test Report"))
  
}