dist <- function (x, y, x0 = 0, y0 = 0) {
  x <- x - x0
  y <- y - y0
  sqrt(x^2 + y^2)
}
