#' Link generator for See GEM interactive report
#'
#' Takes a base url and a column from a data frame to generate a vector of URLs. 
#' You must use html format to specify special characters and spaces. 
#' Used in See_GEM_formatter function to format specified colums. 
#'
#'@param base_url The consistent base URL 
#'@param ID The column ID to build the unique part of the URL
#'@param split_on What delimiter to split the field on? Defaults to comma.
#'@param link_name What to use for the link name? Defaults to using the row value of the column
#'
#'@return None
#'
#'@examples
#' GEMINI_data$rs_ids <- sapply(gem_view$rs_ids, 
#' function(x) 
#' link_generator('https://www.ncbi.nlm.nih.gov/projects/SNP/snp_ref.cgi?rs=', as.character(x)) )


link_generator <- function(base_url, ID, split_on=',', link_name = NA){
  ID <- as.character(ID)
  link_name = as.character(ID)
  if (is.na(ID) | is.na(base_url) | ID == 'None' | base_url == 'None'){
    url <- NA
  }
  else {
    ends <- strsplit(ID, split_on)[[1]]
    url <- ''
    for (end in ends){
      if (is.na(link_name)){
        url <- paste(paste0('<a href="', base_url, end, '" target="_blank">', end, '</a> '), url)
      }
      else{
        url <- paste(paste0('<a href="', base_url, end, '" target="_blank">', link_name, '</a> '), url)
      }
    }
    if (ID == 'None') {
      url <- NA
    }
  }
  return(as.character(url))
}