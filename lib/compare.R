compare <- function (var, label) {
  summary <- 
    D %>% 
    group_by(type) %>% 
    summarize_(n = sprintf("length(%s)", var),
               mean = sprintf("mean(%s, na.rm = TRUE)", var),
               sd = sprintf("sd(%s, na.rm = TRUE)", var),
               min = sprintf("min(%s, na.rm = TRUE)", var),
               max = sprintf("max(%s, na.rm = TRUE)", var)) %>% 
    mutate(meanSD = sprintf("%.03f (%.03f)", mean, sd),
           range = sprintf("(%.03f, %.03f)", min, max)) %>% 
    mutate(variable = label) %>% 
    select(variable, everything())
  formula <- sprintf("%s ~ type", var)
  statistics <-
    D %>% 
    mutate(type = factor(type, levels = c("Control", "Case"))) %>%
    lm(eval(formula), .) %>% 
    summary %>% 
    coef %>% 
    data.frame %>% 
    filter(grepl("^type", row.names(.))) %>% 
    rename(difference = Estimate,
           seDiff = Std..Error,
           tStatistic = t.value, 
           pValue = Pr...t..)
  results <-
    merge(summary %>% filter(type == "Case"), 
          summary %>% filter(type == "Control"),
          by = "variable") %>% 
    select(matches("variable|^n|meanSD|range")) %>% 
    rename(nCases = n.x,
           meanSDCases = meanSD.x,
           rangeCases = range.x,
           nControls = n.y,
           meanSDControls = meanSD.y,
           rangeControls = range.y) %>% 
    cbind(., statistics)
  results
}
