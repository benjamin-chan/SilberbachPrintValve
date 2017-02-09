cart2sph <- function (v, v0 = data.frame(x= 0, y = 0, z = 0), units = "rad") {
  # See http://mathworld.wolfram.com/SphericalCoordinates.html and https://en.wikipedia.org/wiki/Spherical_coordinate_system
  # Use ISO convention
  # rho = radial distance
  # phi = azimuthal angle bounded between [0, 2 * pi] or [0, 360]; default units is radians
  # theta = polar angle (inclination) bounded between [-pi / 2, pi / 2] or [-90, +90]; default units is radians
  x <- v[, 1] - v0[, 1]
  y <- v[, 2] - v0[, 2]
  z <- v[, 3] - v0[, 3]
  rho <- sqrt(x^2 + y^2 + z^2)
  phi <- atan2(y, x) + pi
  theta <- (pi / 2) - acos(z / rho)
  if (units == "deg") {
    k <- 180 / pi
    theta <- theta * k
    phi <- phi * k
  }
  data.frame(radial = rho, polar = theta, azimuthal = phi)
}
