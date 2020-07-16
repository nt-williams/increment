
compute_rho <- function(data, trt, outcome, delta, prop,
                        weights, preds, tau) {
  weights[, tau]*data[[outcome]] +
    nuisance(weights,
             compute_v(data, trt, prop, delta, tau),
             preds,
             tau)[, 1]
}

compute_v <- function(data, trt, prop, delta, tau) {
  # setup
  out <- matrix(nrow = nrow(data), ncol = tau)

  for (t in 1:tau) {
    # current time point
    current_trt  <- data[[trt[t]]]
    current_prop <- prop[, t]

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

compute_psi <- function(x) {
  out <- list(
    estimates = data.frame(
      increment = x$delta,
      estimate = mean(x$eif),
      std.error = sqrt(var(x$eif)) / sqrt(length(x$eif)),
      conf.low = mean(x$eif) - 1.96*sqrt(var(x$eif)) / sqrt(length(x$eif)),
      conf.high = mean(x$eif) + 1.96*sqrt(var(x$eif)) / sqrt(length(x$eif))
    ),
    eif = x$eif - mean(x$eif)
  )
  class(out) <- "increment"
  out
}
