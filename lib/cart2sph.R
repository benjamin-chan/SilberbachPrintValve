cart2sph <- function (v, v0 = data.frame(x= 0, y = 0, z = 0), units = "rad") {
  # See http://mathworld.wolfram.com/SphericalCoordinates.html and https://en.wikipedia.org/wiki/Spherical_coordinate_system
  # Use ISO convention
  # rho = radial distance
  # theta = polar angle (inclination) bounded between [0, pi] or [0, 180]; default units is radians
  # phi = azimuthal angle bounded between [0, 2 * pi] or [0, 360]; default units is radians
  x <- v[, 1] - v0[, 1]
  y <- v[, 2] - v0[, 2]
  z <- v[, 3] - v0[, 3]
  rho <- sqrt(x^2 + y^2 + z^2)
  theta <- acos(z / rho)
  phi <- atan2(y, x) + pi
  if (units == "deg") {
    k <- 180 / pi
    theta <- theta * k
    phi <- phi * k
  }
  data.frame(radial = rho, polar = theta, azimuthal = phi)
}
