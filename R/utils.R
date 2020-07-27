
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

recombine_prop <- function(prop, folds) {
  Reduce(rbind, lapply(prop, function(x) x[["valid"]]))[order(reorder_validation(folds)), , drop = FALSE]
}

recombine_pseudo <- function(pseudo, folds) {
  lapply(pseudo, function(p) {
    Reduce(rbind, p)[order(reorder_validation(folds)), , drop = FALSE]
  })
}

reorder_validation <- function(folds) {
  Reduce(c, lapply(folds, function(x) x[["validation_set"]]))
}

revert_list <- function(x) {
  apply(do.call(rbind, lapply(x, `[`)), 2, as.list)
}

set_increment_options <- function(option, val) {
  switch (option,
          "engine" = options(increment.engine = val)
  )
}

create_censoring_indicators <- function(data, cens, tau) {

  # when no censoring return TRUE for all obs
  if (is.null(cens)) {
    i <- rep(TRUE, nrow(data))
    j <- rep(TRUE, nrow(data))
    out <- list(i = i, j = j)
    return(out)
  }

  # other wise find censored observations
  i <- data[[cens[tau]]] == 1

  if (tau > 1) {
    j <- data[[cens[tau - 1]]] == 1
  } else {
    j <- rep(TRUE, nrow(data))
  }

  out <- list(i = i, j = j)
  return(out)
}
