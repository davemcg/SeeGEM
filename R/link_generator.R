#' Link generator for See GEM interactive report
#'
#' Takes a base url and a column from a data frame to generate a vector of URLs
#'
#'@param base_url The consistent base URL 
#'@param ID The column ID to build the unique part of the URL
#'
#'@return None
#'
#'@examples
#' link_generator()


link_generator <- function(base_url, ID){
  if (is.na(ID) | is.na(base_url) | ID == 'None' | base_url == 'None'){
    url <- NA
  }
  else {
    ends <- strsplit(ID, ',')[[1]]
    url <- ''
    for (end in ends){
      url <- paste(paste0('<a href="', base_url, end, '" target="_blank">', end, '</a> '), url)
    }
    if (ID == 'None') {
      url <- NA
    }
  }
  return(as.character(url))
}
clinvar_link_generator <- function(base_url, ID, clinvar_sig){
  if (clinvar_sig == 'None' | is.na(clinvar_sig) | is.na(ID) | ID == 'None') {
    url <- NA
  }
  else {
    ends <- strsplit(ID, ',')[[1]]
    url <- ''
    for (end in ends){
      url <- paste(paste0('<a href="', base_url, end, '" target="_blank">', as.character(clinvar_sig), '</a> '), url)
    }
  }
  return(as.character(url))
}
google_link_generator <- function(var, gene){
  if (is.na(var) || is.na(gene) || var == 'None' || gene == 'None'){
    output <- NA
  }
  else {
    url = 'https://scholar.google.com/scholar?hl=en&q='
    var <- gsub('>','%3E',var)
    var <- strsplit(var, ':')[[1]][2]
    output <- paste0('<a href="', url, var, '+', gene, '" target="_blank">', 'Feeling&nbspLucky?', '</a>')
  }
  return(output)
}