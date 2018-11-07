#' GEMINI query wrapper
#' 
#' A barebones GEMINI wrapper which passes on your GEMINI command to `gemini query 
#' --header -q` on the command line. I imagine this will mostly be used for users 
#' with already functional `gemini query --header -q` commands. You \strong{must} 
#' escape (append \) your quote marks.
#' 
#' @param gemini_db is the name of your GEMINI database (with path, if necessary)
#' @param output By default the data frame will be returned. If you give path/name.tsv
#' a tab separate file will be written
#' @param test_name The identifying name given to your query. Will be used in the 
#' interative document to filter query/GEMINI sub command types
#' @param ... Your GEMINI command, past `gemini query -q`
#' 
#' @return None
#' 
#' @importFrom data.table fread
#' @import readr
#' 
#' @export
#' 
#' @examples
#' \dontrun{
#' gemini_query_wrapper('/path/to/your/gemini.db', ... = "\"SELECT * FROM 
#' variants WHERE (aaf_esp_all < 0.01 AND IMPACT_SO LIKE '%STOP%' AND 
#' filter is NULL) LIMIT 20\"")
#' }


gemini_query_wrapper <- function(gemini_db, test_name="CUSTOM1", output = NA, ...){
  
  tmp_file <- paste0('/tmp/gem', sample(1e6:2e6,1))

  gemini_query <- paste("gemini query --header -q", 
                        ...,
                        gemini_db, ">", tmp_file)
  cat(gemini_query)
  cat('')
  system(gemini_query)
  input <- fread(tmp_file)
  # force chromosomes as characters, to avoid issues with X, Y
  if (nrow(input)>0 & 'chrom' %in% colnames(input)){
    input$chrom <- as.character(input$chrom)
    # also set test name
    input$test <- test_name
  }
  if (is.na(output)){
    input
  } else{
    write_tsv(input, path = output)
  }
  
}