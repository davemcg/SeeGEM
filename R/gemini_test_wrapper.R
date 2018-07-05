#' GEMINI test (sub command) wrapper
#' 
#' Calls GEMINI's built in tools (e.g. autosomal_dominant, comp_hets) to retrieve proband/trio specific variants. Returns a tibble of all of the columns available in your GEMINI database. 
#' 
#' @param gemini_db is the name of your GEMINI database (with path, if necessary)
#' @param test is the name of the GEMINI sub command to call. Accepted tests are 
#' autosomal_dominant, autosomal_recessive, comp_hets, mendel_errors, x_linked_de_novo,
#' x_linked_dominant, x_linked_recessive. Use \code{\link{gemini_query_wrapper}} if you want to
#' run a `gemini query -q` style command. 
#' @param filter if you want to change the default filtering criteria
#' @param min_gq minimum genotype quality (default is set at 20)
#' @param families family name that GEMINI will use to identify proband, mother, and father
#' @param ... add other GEMINI commands not listed here
#' 
#' @return None
#' 
#' @export
#' 
#' @examples
#' gemini_test_wrapper('/path/to/your/gemini.db', 'autosomal_dominant', families = 'fam007')


gemini_test_wrapper <- function(gemini_db, 
                          test = "autosomal_recessive",
                          filter = "aaf < 0.1 AND aaf_esp_all < 0.01 AND \
                        aaf_1kg_all < 0.01 AND af_exac_all < 0.01 AND \
                        (is_coding=1 OR is_splicing=1 OR impact_severity='HIGH') \
                        AND filter is NULL",
                          min_gq = 20,
                          families = NA,
                          ...){
  
  if (!test %in% c('autosomal_dominant','autosomal_recessive','comp_hets',
                   'de_novo','mendel_errors','x_linked_de_novo','x_linked_dominant',
                   'x_linked_recessive')){
    stop('Not an allowed GEMINI sub command!')
  }
  tmp_file <- paste0('/tmp/gem', sample(1e6:2e6,1))
  
  if (is.na(families)){
    gemini_query <- paste("gemini", test, 
                          "--filter \"", filter, "\"",
                          "--min-gq", min_gq,
                          gemini_db, ">", tmp_file)
  }
  else{
    gemini_query <- paste("gemini", test, 
                          "--filter \"", filter, "\"",
                          "--min-gq", min_gq,
                          "--families ", families, 
                          gemini_db, ">", tmp_file)
  }
  system(gemini_query)
  # if no output from gemini, return empty tibble
  input <- tryCatch(fread(tmp_file), error = function(e) tibble())
  input <- tibble(input)
  # force chromosomes as characters, to avoid issues with X, Y
  if (nrow(input)>0){
    input$chrom <- as.character(input$chrom)
    input$test <- test
  }
  input
}