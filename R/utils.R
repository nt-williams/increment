
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
