
#' @export
print.increment <- function(x) {
  cat("\n")
  cli::cli_text("{.strong Incremental Z estimator}")
  cat("\n")
  print(x$estimates)
  cat("\n")
  cli::cli_text("{.strong Reference}")
  cli::cli_text("Nonparametric Causal Effects Based on Incremental Propensity Score Interventions (Kennedy, 2019)")
  cat("\n")
}
