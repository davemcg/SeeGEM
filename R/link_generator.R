#' Link generator for See GEM interactive report
#'
#' Takes a base url and a column from a data frame to generate a vector of URLs. 
#' You must use html format to specify special characters and spaces. 
#' Used in See_GEM_formatter function to format specified colums. 
#'
#' @param base_url The consistent base URL 
#' @param ID The column ID to build the unique part of the URL
#' @param split_on What delimiter to split the field on? Defaults to comma.
#' @param link_name What to use for the link name? Defaults to using the row value of the column
#'
#' @return None
#'
#' @export
#'
#' @examples
#' link_generator('https://www.ncbi.nlm.nih.gov/projects/SNP/snp_ref.cgi?rs=', 'rs1800728')


link_generator <- function(base_url, ID, split_on=',', link_name = NA){
  ID <- as.character(ID)
  link_name = as.character(link_name)
  if (is.na(ID) | is.na(base_url) | ID == 'None' | base_url == 'None' | ID == '-1'){
    url <- NA
  }
  else {
    items <- strsplit(ID, split_on)[[1]]
    url <- ''
    # many links have sub-structure (link ClinVar IDs with the |)
    # the strsplit above will break on the delimiter and create multiple links
    for (i in seq_along(items)){
      if (is.na(link_name)){
        url <- paste(paste0('<a href="', base_url, items[i], '" target="_blank">', items[i], '</a> '), url)
      }
      else{
        # check if the link_name also has delimiters like the ID
        if (!is.na(strsplit(link_name, split_on)[[1]][i])){
          link_name = strsplit(link_name, split_on)[[1]][i]
        }
        url <- paste(paste0('<a href="', base_url, items[i], '" target="_blank">', link_name, '</a> '), url)
      }
    }
    # yet another check for missing data
    if (ID == 'None' | ID == '-1') {
      url <- NA
    }
  }
  return(as.character(url))
}
