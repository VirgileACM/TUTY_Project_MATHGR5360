# Variance ratio test functions

### Push-Response functions
responseCondPush <- function(data, start, delta, shift) {
  index <- which(data>=start & data<(start+delta))
  return (mean(data[index+shift]))
}

pushResponse <- function (data, shift, nbPoints) {
  diffSerie <- diff(data, shift)
  r <- range(diffSerie)
  t <- seq(from=r[1], to=r[2], length.out = nbPoints)
  deltat <- t[2]-t[1]
  y <- apply(matrix(t), 1, FUN=function(t) responseCondPush(diffSerie, t, deltat, shift))
  good <- sort(c(which(!is.nan(y)),which(!is.na(y)))) # don't display intervals for which there is no values
  print(y[good])
  return (list(t[good],y[good]))
}

### Andrew Lo's Variance Ratio Test
VRtestShift <- function(data, shift) {
  diffSerie <- diff(data, shift)
  return(var(diffSerie)/(shift*var(diff(data, 1))))
}

VRtest <- function(data, shifts) {
  return(apply(matrix(shifts), 1, FUN=function(s)VRtestShift(data, s) ))
}







