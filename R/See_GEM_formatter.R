#' GEMINI data formatter
#' 
#' Formats data for reactive knit document 
#' 
#' @param GEMINI_data The data frame / tibble of your GEMINI data. All tests 
#' (e.g. autosomal_recessive, compound_het) collapsed into a single data frame 
#' with the GEMINI sub command test given in a `test` column. 
#' @param core_fields These are the columns that will be shown by default
#' @param linkify Do you want to turn format fields as hyperlinks? Hard-coded to 
#' position id (gnomAD), gene (OMIM), ClinVar ID (ClinVar), rs_id (dbSNP).
#' @return None
#' 
#' @examples 
#' GEMINI_data <- data.table::rbindlist(gemini_caller('/path/to/gemini.db', 'autosomal_recessive'),
#' gemini_caller('/path/to/gemini.db', 'autosomal_dominant', "aaf < 0.05 AND aaf_esp_all < 0.001 AND aaf_1kg_all < 0.001 AND af_exac_all < 0.001 AND (is_coding=1 OR is_splicing=1 OR impact_severity='HIGH') AND filter is NULL"))
#' See_GEM_formatter(GEMINI_data)

See_GEM_formatter <- function(GEMINI_data, 
                      core_fields = c("test", "pos_id", "gene", "transcript", 
                                      "hgvsc", "hgvsp", "aaf", "gno_af_all", 
                                      "exac_num_hom_alt", "clinvar_id", "rs_ids", 
                                      "Google Scholar"),
                      linkify = 'yes'
                      ){
  #load('inst/extdata/gemini.Rdata')
  #GEMINI_data <- data.table::rbindlist(x) %>% data.frame()
  
  # build pos_id
  GEMINI_data$pos_id <- apply(GEMINI_data, 1, 
                              function(x) paste(x['chrom'], 
                                                as.numeric(x['end']), 
                                                x['ref'], 
                                                x['alt'], 
                                                sep = '-'))

  # linkify
  if (linkify == 'yes'){
    GEMINI_data$pos_id <- sapply(GEMINI_data$pos_id, 
                                function(x) link_generator('http://gnomad.broadinstitute.org/variant/', x))
    GEMINI_data$clinvar_id <- apply(GEMINI_data, 1, 
                                   function(x) link_generator('https://www.ncbi.nlm.nih.gov/clinvar?term=', 
                                                              ID = x['clinvar_id'], 
                                                              link_name = x['clinvar_sig'], 
                                                              split_on = '\\|'))
    GEMINI_data$rs_ids <- sapply(GEMINI_data$rs_ids, 
                               function(x) link_generator('https://www.ncbi.nlm.nih.gov/projects/SNP/snp_ref.cgi?rs=', x))
    GEMINI_data$'Google Scholar' <- apply(GEMINI_data, 1, 
                                         function(x) link_generator('https://scholar.google.com/scholar?hl=en&q=', 
                                                                    paste0(strsplit(gsub('>', '%3E',x['hgvsc']), ':')[[1]][2],'&nbsp', x['gene']), 
                                                                    link_name = 'Feeling lucky?'))
    GEMINI_data$gene <- sapply(GEMINI_data$gene, 
                              function(x) link_generator('https://www.omim.org/search/?search=', x))
  }
  
  # indices of all columns
  all_cols <- seq(1,ncol(GEMINI_data))
  # indices of core_fields
  core_index <- match(core_fields, colnames(GEMINI_data))
  # indices of not core_fields
  neg_core_index <- setdiff(all_cols, core_index)

  # reorder to match core_field order
  GEMINI_data <- GEMINI_data[,c(core_index, neg_core_index)]

  core_index <- match(core_fields, colnames(GEMINI_data))
  neg_core_index <- setdiff(all_cols, core_index)
  

  out <- list()
  out$GEMINI_data <- GEMINI_data
  out$all_cols <- all_cols
  out$core_index <- core_index
  out$neg_core_index <- neg_core_index
  out
}