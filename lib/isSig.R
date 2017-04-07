isSig <- function (p, alpha = 0.05) {
  ifelse(p < alpha, "significant", "not significant")
}
