
sw <- function(x) {
  suppressWarnings(x)
}

turn_on <- function(data, trt) {
  for (i in trt) {
    data[, i] <- 1
  }
  return(data)
}

turn_off <- function(data, trt) {
  for (i in trt) {
    data[, i] <- 0
  }
  return(data)
}

determine_tau <- function(trt) {
  length(trt)
}
