
setup_cv <- function(data, id, folds = 10) {
  out <- origami::make_folds(data, cluster_ids = id, V = folds)
  return(out)
}

get_folded_data <- function(data, folds) {
  out <- list()
  for (i in 1:length(folds)) {
    out[[i]] <- list()
    out[[i]][["train"]] <- data[folds[[i]]$training_set, ]
    out[[i]][["valid"]] <- data[folds[[i]]$validation_set, ]
  }
  return(out)
}

cf_r <- function(data, trt, tau, node_list, learners, folds, progress) {
  fopts <- options("increment.engine")
  out <- list()
  for (i in 1:folds) {
    out[[i]] <- future::future({
      options(fopts)
      estimate_r(data[[i]]$train, data[[i]]$valid, trt, tau,
                 node_list, learners, progress)
    })
  }
  out <- future::values(out)
  return(out)
}

cf_m <- function(data, delta, trt, outcome, node_list, max,
                 tau, prop, outcome_type, learners, folds, progress) {

  fopts <- options("increment.engine")
  out <- list()
  for (i in 1:folds) {
    out[[i]] <- future::future({
      options(fopts)
      lapply(delta, function(d) {
        estimate_m(data[[i]]$train, data[[i]]$valid, d, trt,
                   outcome, node_list, max, tau, prop[[i]], NULL,
                   outcome_type, learners, progress)
      })
    })
  }
  out <- future::values(out)
}

