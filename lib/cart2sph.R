cart2sph <- function (v, v0 = c(0, 0, 0), units = "rad") {
  # See http://mathworld.wolfram.com/SphericalCoordinates.html and https://en.wikipedia.org/wiki/Spherical_coordinate_system
  # Use ISO convention
  # rho = radial distance
  # theta = polar angle (inclination) bounded between [-pi/2, +pi/2] or [-90, +90]; default units is radians
  # phi = azimuthal angle bounded between [0, 2 * pi] or [0, 360]; default units is radians
  v <- matrix(v, ncol = 3)
  v0 <- matrix(v0, ncol = 3)
  if (nrow(v) != nrow(v0)) {v0 <- matrix(rep(v0, nrow(v)), ncol = 3, byrow = TRUE)}
  vstar <- v - v0
  rho <- sqrt(vstar[, 1]^2 + vstar[, 2]^2 + vstar[, 3]^2)
  theta <- pi / 2 - acos(vstar[, 3] / rho)
  phi <- atan2(vstar[, 2], vstar[, 1]) %% (2 * pi)
  if (units == "deg") {
    k <- 180 / pi
    theta <- theta * k
    phi <- phi * k
  }
  cbind(rho, theta, phi)
}

# cart2sph(matrix(c( 1,  0, 0,  # Reference longitude (e.g., GMT)
#                    0,  1, 0,
#                   -1,  0, 0,
#                    0, -1, 0),
#                 ncol = 3, byrow = TRUE),
#          units = "deg")
# > cart2sph(matrix(c( 1,  0, 0,  # Reference longitude (e.g., GMT)
# +                    0,  1, 0,
# +                   -1,  0, 0,
# +                    0, -1, 0),
# +                 ncol = 3, byrow = TRUE),
# +          units = "deg")
#      rho theta phi
# [1,]   1     0   0
# [2,]   1     0  90
# [3,]   1     0 180
# [4,]   1     0 270

# cart2sph(matrix(c(0, 0, 1,
#                   sqrt(2) / 2, 0, sqrt(2) / 2,
#                   1, 0, 0,
#                   sqrt(2) / 2, 0, -sqrt(2) / 2,
#                   0, 0, -1),
#                 ncol = 3, byrow = TRUE),
#          units = "deg")
# > cart2sph(matrix(c(0, 0, 1,
# +                   sqrt(2) / 2, 0, sqrt(2) / 2,
# +                   1, 0, 0,
# +                   sqrt(2) / 2, 0, -sqrt(2) / 2,
# +                   0, 0, -1),
# +                 ncol = 3, byrow = TRUE),
# +          units = "deg")
#      rho theta phi
# [1,]   1    90   0
# [2,]   1    45   0
# [3,]   1     0   0
# [4,]   1   -45   0
# [5,]   1   -90   0
