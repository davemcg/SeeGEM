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
#' @param underscore_to_space Do you want to replace underscores with spaces?
#' 
#' @return None
#' 
#' @export
#' 
#' @examples 
#' GEMINI_data <- data.table::rbindlist(gemini_caller('/path/to/gemini.db', 'autosomal_recessive'),
#' gemini_caller('/path/to/gemini.db', 'autosomal_dominant', "aaf < 0.05 AND aaf_esp_all < 0.001 AND aaf_1kg_all < 0.001 AND af_exac_all < 0.001 AND (is_coding=1 OR is_splicing=1 OR impact_severity='HIGH') AND filter is NULL"))
#' See_GEM_formatter(GEMINI_data)

See_GEM_formatter <- function(GEMINI_data, 
                              core_fields = c("test", "pos_id", "gene", "impact_so",
                                              "hgvsc", "hgvsp", "aaf", "gno_af_all", 
                                              "exac_num_hom_alt", "clinvar_id", "rs_ids", 
                                              "GoogleScholar"),
                              linkify = 'yes',
                              underscore_to_space = 'yes'){
  # add Deleterious label for DT
  if ('impact_severity' %in% colnames(GEMINI_data) & 'clinvar_sig' %in% colnames(GEMINI_data) & 'gno_af_all' %in% colnames(GEMINI_data)){
    GEMINI_data <- GEMINI_data %>% mutate(Mark1 = ifelse((impact_severity=='HIGH' | grepl('pathog', clinvar_sig)) & as.numeric(gno_af_all) < 0.01, 'Candidate', NA))
  } else {GEMINI_data$Mark1 = NA}
  # synonymous
  GEMINI_data <- GEMINI_data %>% mutate(Mark2 = case_when(impact_so == 'synonymous_variant' ~ 'Candidate',
                                                          TRUE ~ NA_character_))
  
  
  #load('inst/extdata/gemini.Rdata')
  #GEMINI_data <- data.table::rbindlist(x) %>% data.frame()
  # replace all underscores with a space
  if (underscore_to_space == 'yes'){
    GEMINI_data <- GEMINI_data %>% mutate_if(is.character, stringr::str_replace_all, pattern = '_', replacement = ' ') %>% 
      mutate_if(is.factor, stringr::str_replace_all, pattern = '_', replacement = ' ')
  }
  
  # set test column as factor
  GEMINI_data$test <- as.factor(GEMINI_data$test)
  # set impact_so to factor
  if ('impact_so' %in% colnames(GEMINI_data)){
    GEMINI_data$impact_so <- as.factor(GEMINI_data$impact_so)
  }
  # replace 'None' with -1
  GEMINI_data[GEMINI_data == 'None'] <- -1
  # build pos_id
  GEMINI_data$pos_id <- apply(GEMINI_data, 1, 
                              function(x) paste(x['chrom'], 
                                                as.numeric(x['end']), 
                                                x['ref'], 
                                                x['alt'], 
                                                sep = '-'))
  # add spacing to hgvs_c and hgvs_p
  if ('hgvsc' %in% colnames(GEMINI_data)){
    GEMINI_data$hgvsc <- gsub(':',': ', GEMINI_data$hgvsc)
  }
  if ('hgvsp' %in% colnames(GEMINI_data)){
    GEMINI_data$hgvsp <- gsub(':',': ', GEMINI_data$hgvsp)
    GEMINI_data$hgvsp <- gsub('%3','>', GEMINI_data$hgvsp)
  }
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
    GEMINI_data$GoogleScholar <- apply(GEMINI_data, 1, 
                                       function(x) link_generator('https://scholar.google.com/scholar?hl=en&q=', 
                                                                  paste0(strsplit(gsub('>', '%3E',x['hgvsc']), ':')[[1]][2],'%20', x['gene']), 
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
  GEMINI_data <- data.frame(GEMINI_data)
  GEMINI_data <- GEMINI_data[,c(core_index, neg_core_index)]
  
  core_index <- match(core_fields, colnames(GEMINI_data))
  neg_core_index <- setdiff(all_cols, core_index)
  
  # build output
  out <- list()
  out$GEMINI_data <- data.frame(GEMINI_data)
  out$all_cols <- all_cols
  out$core_index <- core_index
  out$neg_core_index <- neg_core_index
  out
}
