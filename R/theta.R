
compute_rho <- function(data, trt, outcome, delta, propensity,
                        weights, preds, tau) {
  weights[, tau]*data[[outcome]] +
    nuisance(weights,
             compute_v(data, trt, propensity$propensity, delta, tau),
             preds$preds,
             tau)[, 1]
}

compute_v <- function(data, trt, propensity, delta, tau) {
  # setup
  out <- matrix(nrow = nrow(data), ncol = tau)

  for (t in 1:tau) {
    # current time point
    current_trt  <- data[[trt[t]]]
    current_prop <- propensity[, t]

    # calculation
    num      <- current_trt*(1 - current_prop) - (1 - current_trt)*delta*current_prop
    denom    <- delta / (delta - 1)
    out[, t] <- num / denom
  }

  return(out)
}

nuisance <- function(weights, v, preds, tau) {
  to_sum <- lapply(1:tau, function(t) {
    matrix(weights[, t]*v[, t]*preds[, t], nrow = nrow(weights), ncol = 1)
  })

  out <- matrix(nrow = nrow(weights), ncol = 1)
  for (i in 1:nrow(Reduce(cbind, to_sum))) {
    out[i, 1] <- sum(Reduce(cbind, to_sum)[i, ])
  }

  return(out)
}

compute_psi <- function(rho) {
  mean(rho)
}