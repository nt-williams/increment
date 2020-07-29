
#' @export
print.increment <- function(x, ...) {
  cli::cli_text("{.strong Incremental propensity score intevention Z-estimator}")
  cat("\n")
  cat("           Confidence level: 95%\n")
  cat("     Multiplier Bootstrap C:", round(x$mult_cv, 2), "\n")
  cat("First 6 increment estimates:\n")
  cat("\n")
  print(head(round(x$estimates, 2)))
}
