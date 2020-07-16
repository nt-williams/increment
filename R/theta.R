
compute_rho <- function(data, trt, outcome, delta, prop,
                        weights, preds, tau) {
  mapply(function(w, d, p) {
    w[, tau]*data[[outcome]] +
      nuisance(w,
               compute_v(data, trt, prop, d, tau),
               p,
               tau)[, 1]
  }, w = weights, d = delta, p = preds,
  SIMPLIFY = FALSE)
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
      estimate = vapply(x$eif, function(e) mean(e), FUN.VALUE = 1),
      std.error = vapply(x$eif, function(e) sqrt(var(e)) / sqrt(length(e)), FUN.VALUE = 1),
      conf.low = vapply(x$eif, function(e) mean(e) - 1.96*sqrt(var(e)) / sqrt(length(e)), FUN.VALUE = 1),
      conf.high = vapply(x$eif, function(e) mean(e) + 1.96*sqrt(var(e)) / sqrt(length(e)), FUN.VALUE = 1)
    ),
    eif = lapply(x$eif, function(e) e - mean(e))
  )
  class(out) <- "increment"
  out
}
