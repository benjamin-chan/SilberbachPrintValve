pContrast <- function(M, K) {
  require(magrittr, quietly = TRUE)
  require(multcomp, quietly = TRUE)
  glht(M, linfct = K) %>% 
    summary %>% 
    .[["test"]] %>% 
    .[["pvalues"]] %>% 
    as.numeric
}
