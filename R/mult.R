
compute_multboot <- function(eif, n, reps) {
  psi <- matrix(rep(vapply(eif, function(e) mean(e), FUN.VALUE = 1), n), nrow = n, byrow = TRUE)
  sig <- matrix(rep(vapply(eif, function(e) sqrt(var(e)), FUN.VALUE = 1), n), nrow = n, byrow = TRUE)
  eif <- matrix(unlist(eif), nrow = n, byrow = FALSE)
  mbs <- matrix(2 * rbinom(n * reps, 1, 0.5) -1, nrow = n, ncol = reps)
  sup <- sapply(1:reps, function(i) {
    max(abs(apply(mbs[, i] * ((eif - psi) / sig), 2, sum) / sqrt(n)))
  })
  as.vector(quantile(sup, 0.95))
}
