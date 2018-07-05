#' GEMINI stat wrapper
#' 
#' Uses GEMINI database to extracts some useful stats from the 
#' `gemini stats` command. Returns list of stats info that 
#' \code{\link{knit_see_gem}} uses to build the stats tab.
#' 
#' @param gemini_db is the name of your GEMINI database (with path, if necessary)
#' @param ID is the family name or sample name to pull stats from
#' @param is_family Defaults to `yes`. The GEMINI databases's ped will be pulled 
#' to find the sample names associated with the family_id. If this is a sample 
#' name, change to 'no'.  
#' 
#' @return None
#'
#' @examples
#' gemini_stat_wrapper('/path/to/gemini.db', 'Sample007', is_family = 'no')

gemini_stat_wrapper <- function(gemini_db, ID, is_family = 'yes'){
  gemini_stats = list()
  if (is_family == 'yes'){
    ped_tmp <- paste0("/tmp/ped", sample(1e6:2e6,1))
    ped_query <- paste("gemini query --header -q \"SELECT * FROM SAMPLES\"", gemini_db, ">", ped_tmp)
    system(ped_query)
    ped <- read_tsv(ped_tmp)
    ID <- ped %>% filter(family_id == ID) %>% pull(name)
    # gemini query --header -q 'select * from samples' 2018_06_28__OGVFB_exomes.GATK.PED_master.gemini.db
  }
  
  # genotype counts by sample
  # gemini stats --gts-by-sample 2018_06_28__OGVFB_exomes.GATK.PED_master.gemini.db
  gemini_stats_tmp <-  paste0('/tmp/gem_stats_', sample(1e6:2e6,1))
  gemini_stats_query <- paste("gemini stats --gts-by-sample", gemini_db, ">", gemini_stats_tmp)
  system(gemini_stats_query)
  gemini_stats <- read_tsv(gemini_stats_tmp)
  
  out <- list()
  out$ID <- ID
  out$gemini_stats <- gemini_stats
  out
}