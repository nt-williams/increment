
construct_weights <- function(data, trt, delta, prop, tau) {
  n <- nrow(data)
  w <- matrix(nrow = n, ncol = tau)

  lapply(delta, function(d) {
    for (t in 1:tau) {
      # current time point
      current_trt  <- data[[trt[t]]]
      current_prop <- prop[, t]

      # weight calculation
      num    <- (d*current_trt) + 1 - current_trt
      denom  <- (d*current_prop) + 1 - current_prop
      w[, t] <- num / denom
    }

    # returns
    matrix(t(apply(w, 1, cumprod)),
           nrow = nrow(w),
           ncol = ncol(w))
  })
}
