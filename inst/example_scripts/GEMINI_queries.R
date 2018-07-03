# Generate a full series of GEMINI queries for a sample/trio
args = commandArgs(trailingOnly=TRUE)

gemini_db <- args[1]
family_name <- args[2]

library(data.table)

GEMINI_list <- list()
GEMINI_list$ar <- gemini_test_wrapper(gemini_db, 
                                      test = 'autosomal_recessive', 
                                      min_gq = 20, 
                                      filter = "aaf < 0.1 AND aaf_esp_all < 0.01 AND 
                    aaf_1kg_all < 0.01 AND af_exac_all < 0.01 AND 
                    (is_coding=1 OR is_splicing=1 OR impact_severity='HIGH') 
                    AND filter IS NULL",
                                      families = family_name)

GEMINI_list$ad <- gemini_test_wrapper(gemini_db, 
                                      test = 'autosomal_dominant', 
                                      min_gq = 20, 
                                      filter = "aaf < 0.1 AND aaf_esp_all < 0.0001 AND 
                                      aaf_1kg_all < 0.0001 AND af_exac_all < 0.0001 AND 
                                      (is_coding=1 OR is_splicing=1 OR impact_severity='HIGH') 
                                      AND filter IS NULL",
                                      families = family_name)

GEMINI_list$dn <- gemini_test_wrapper(gemini_db, 
                                      test = 'de_novo', 
                                      min_gq = 20, 
                                      filter = "aaf < 0.1 AND aaf_esp_all < 0.005 AND 
                                      aaf_1kg_all < 0.005 AND af_exac_all < 0.005 AND 
                                      (is_coding=1 OR is_splicing=1 OR impact_severity='HIGH') 
                                      AND filter IS NULL",
                                      families = family_name)

GEMINI_list$xlr <- gemini_test_wrapper(gemini_db, 
                                       test = 'x_linked_recessive', 
                                       min_gq = 20, 
                                       filter = "aaf < 0.1 AND aaf_esp_all < 0.005 AND 
                                       aaf_1kg_all < 0.005 AND af_exac_all < 0.005 AND 
                                       (is_coding=1 OR is_splicing=1 OR impact_severity='HIGH') 
                                       AND filter IS NULL",
                                       families = family_name)

GEMINI_list$xld <- gemini_test_wrapper(gemini_db, 
                                       test = 'x_linked_dominant', 
                                       min_gq = 20, 
                                       filter = "aaf < 0.1 AND aaf_esp_all < 0.005 AND 
                                       aaf_1kg_all < 0.005 AND af_exac_all < 0.005 AND 
                                       (is_coding=1 OR is_splicing=1 OR impact_severity='HIGH') 
                                       AND filter IS NULL",
                                       families = family_name)

GEMINI_list$xldn <- gemini_test_wrapper(gemini_db, 
                                        test = 'x_linked_de_novo', 
                                        min_gq = 20, 
                                        filter = "aaf < 0.1 AND aaf_esp_all < 0.005 AND 
                                       aaf_1kg_all < 0.005 AND af_exac_all < 0.005 AND 
                                       (is_coding=1 OR is_splicing=1 OR impact_severity='HIGH') 
                                       AND filter IS NULL",
                                        families = family_name)

GEMINI_list$me <- gemini_test_wrapper(gemini_db, 
                                      test = 'mendel_errors', 
                                      min_gq = 20, 
                                      filter = "aaf < 0.1 AND aaf_esp_all < 0.005 AND 
                                        aaf_1kg_all < 0.005 AND af_exac_all < 0.005 AND 
                                        (is_coding=1 OR is_splicing=1 OR impact_severity='HIGH') 
                                        AND filter IS NULL",
                                      families = family_name)

GEMINI_list$ch <- gemini_test_wrapper(gemini_db, 
                                      test = 'comp_hets', 
                                      min_gq = 20, 
                                      filter = "aaf < 0.1 AND aaf_esp_all < 0.01 AND 
                                      aaf_1kg_all < 0.01 AND af_exac_all < 0.01 AND 
                                      (is_coding=1 OR is_splicing=1 OR impact_severity='HIGH') 
                                      AND filter IS NULL",
                                      families = family_name)

acmg_genes = c('ACTA2','ACTC1','APC','APOB','ATP7B','BMPR1A','BRCA1','BRCA2',
               'CACNA1S','COL3A1','DSC2','DSG2','DSP','FBN1','GLA','KCNH2','KCNQ1',
               'LDLR','LMNA','MEN1','MLH1','MSH2','MSH6','MUTYH','MYBPC3','MYH11',
               'MYH7','MYL2','MYL3','NF2','OTC','PCSK9','PKP2','PMS2','PRKAG2',
               'PTEN','RB1','RET','RYR1','RYR2','SCN5A','SDHAF2','SDHB','SDHC',
               'SDHD','SMAD3','SMAD4','STK11','TGFBR1','TGFBR2','TMEM43','TNNI3',
               'TNNT2','TP53','TPM1','TSC1','TSC2','VHL','WT1')

GEMINI_list$acmg <- gemini_query_wrapper(gemini_db,
                                         ... = paste0("\"SELECT * FROM variants WHERE (gene IN (\'",
                                                      paste(acmg_genes, collapse="\',\'"),
                                                      "\')) AND ((clinvar_sig LIKE '%pathogenic%' OR impact_severity='HIGH') 
                                                     AND (aaf < 0.1 AND aaf_esp_all < 0.01 AND
                                                     aaf_1kg_all < 0.01 AND af_exac_all < 0.01))
                                                     AND filter IS NULL\""),
                                         test_name = 'ACMG59')

# rbindlist will collapse each element of the list into one data frame
# gemini_query_wrapper() and gemini_test_wrapper() will add the test name
# to each query, so you can distinguish them later
GEMINI_data <- rbindlist(GEMINI_list)
save(GEMINI_data, file='~/GEMINI_data.Rdata')

