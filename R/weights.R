
construct_weights <- function(data, trt, delta, propensity, tau) {

  n    <- nrow(data)
  w    <- matrix(nrow = n, ncol = tau)
  prop <- propensity$propensity

  for (t in 1:tau) {
    # current time point
    current_trt  <- data[[trt[t]]]
    current_prop <- prop[, t]

    # weight calculation
    num    <- (delta*current_trt) + 1 - current_trt
    denom  <- (delta*current_prop) + 1 - current_prop
    w[, t] <- num / denom
  }

  # returns
  matrix(t(apply(w, 1, cumprod)),
         nrow = nrow(w),
         ncol = ncol(w))
}
