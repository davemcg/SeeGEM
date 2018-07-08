#' GEMINI data formatter
#' 
#' Formats data for reactive knit document made with \code{\link{knit_see_gem}}
#' 
#' @param GEMINI_data The data frame / tibble of your GEMINI data. All tests 
#' (e.g. autosomal_recessive, compound_het) collapsed into a single data frame 
#' with the GEMINI sub command test given in a `test` column. 
#' @param core_fields These are the columns that will be shown by default
#' @param in_silico These are in silico consequence columns (e.g CADD, SIFT)
#' @param genotypes These columns show the full genotype information for each person
#' in the family.
#' @param extra_columns_to_retain These are columns not selected above that will be 
#' retained. This is a regular expression, so you can give this something like 
#' '^gno|rankscore$|*num*' and all columns starting with `gno` or ending with `rankscore`
#' or containing `num` will be selected.
#' @param linkify Do you want to turn format fields as hyperlinks? Hard-coded to 
#' position id (gnomAD), gene (OMIM), ClinVar ID (ClinVar), rs_id (dbSNP).
#' @param underscore_to_space Do you want to replace underscores with spaces?
#' 
#' @return None
#' 
#' @import dplyr
#' @import stringr
#' 
#' @export
#' 
#' @examples 
#' GEMINI_data <- data.table::rbindlist(gemini_test_wrapper('/path/to/gemini.db', 'autosomal_recessive', families = 'the_fam'),
#' gemini_test_wrapper('/path/to/gemini.db', 'autosomal_dominant', filter = "aaf < 0.05 AND aaf_esp_all < 0.001 AND aaf_1kg_all < 0.001 AND af_exac_all < 0.001 AND (is_coding=1 OR is_splicing=1 OR impact_severity='HIGH') AND filter is NULL"), families = 'the_fam')
#' See_GEM_formatter(GEMINI_data)

See_GEM_formatter <- function(GEMINI_data, 
                              core_fields = c("test", "pos_id", "impact_so", "gene", 
                                              "hgvsc", "hgvsp", "aaf", "gno_af_all", 
                                              "exac_num_hom_alt", "clinvar_id", "rs_ids", 
                                              "GoogleScholar"),
                              in_silico = c("test", "pos_id", "gene", "impact_so", 
                                            "cadd_phred", "ccr_pct_v1", "revel", 
                                            "polyphen_score", "sift_score", 
                                            "metalr_rankscore", "genesplicer", 
                                            "spliceregion","linsight"),
                              genotypes = c("test", "pos_id", "gene", "impact_so", "family_members", "family_genotypes"),
                              extra_columns_to_retain = '^gno|rankscore$|*num*|^clin|*domain*|*codon*',
                              linkify = 'yes',
                              underscore_to_space = 'yes',
                              cut_down){
  # add color labeling
  GEMINI_data <- GEMINI_data %>% 
    mutate(Color = case_when(impact_severity == 'MED' ~ 1,
                             impact_severity=='HIGH' | ((grepl('pathog', clinvar_sig)) & as.numeric(gno_af_all) < 0.01) ~ 2,
                             TRUE ~ 0))
  
  #load('inst/extdata/gemini.Rdata')
  #GEMINI_data <- data.table::rbindlist(x) %>% data.frame()
  # replace all underscores with a space
  if (underscore_to_space == 'yes'){
    GEMINI_data <- GEMINI_data %>% mutate_if(is.character, str_replace_all, pattern = '_', replacement = ' ') %>% 
      mutate_if(is.factor, str_replace_all, pattern = '_', replacement = ' ')
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
  
  # add spacing to family_members
  GEMINI_data$family_members <- gsub(',','<br/>', GEMINI_data$family_members)
  GEMINI_data$family_genotypes <- gsub(',','<br/>', GEMINI_data$family_genotypes)
  
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
  # do the same for in silico and then genotypes
  in_silico_index <- match(in_silico, colnames(GEMINI_data))
  neg_in_silico_index <- setdiff(all_cols, in_silico_index)
  genotypes_index <- match(genotypes, colnames(GEMINI_data))
  neg_genotypes_index <- setdiff(all_cols, genotypes_index)
  
  # reorder to match core_field order
  GEMINI_data <- data.frame(GEMINI_data)
  GEMINI_data <- GEMINI_data %>% select(one_of(core_fields, genotypes, in_silico, 'Color'),
                                        matches(extra_columns_to_retain)) 
  # find the new indexes
  all_cols <- seq(1,ncol(GEMINI_data))
  core_index <- match(core_fields, colnames(GEMINI_data))
  neg_core_index <- setdiff(all_cols, core_index)
  in_silico_index <- match(in_silico, colnames(GEMINI_data))
  neg_in_silico_index <- setdiff(all_cols, in_silico_index)
  genotypes_index <- match(genotypes, colnames(GEMINI_data))
  neg_genotypes_index <- setdiff(all_cols, genotypes_index)

  # round numeric nums down
  GEMINI_data <- GEMINI_data %>% 
    mutate_if(is.numeric, funs(ifelse(is.na(.), -1, .))) %>% 
    mutate_if(is.numeric, funs(as.numeric(formatC(., format = "e", digits = 2))))
  
  # build output
  out <- list()
  out$GEMINI_data <- data.frame(GEMINI_data)
  out$all_cols <- all_cols
  out$core_index <- core_index
  out$neg_core_index <- neg_core_index
  out$in_silico_index <- in_silico_index
  out$neg_in_silico_index <- neg_in_silico_index
  out$genotypes_index <- genotypes_index
  out$neg_genotypes_index <- neg_genotypes_index
  out
}
