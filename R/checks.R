
check_for_variables <- function(data, trt, outcome, baseline, nodes) {
  vars <- c(trt, outcome, baseline, unlist(nodes))
  if (!all(vars %in% names(data))) {
    warn <- vars[which(!(vars %in% names(data)))]
    stop("Variable(s) ", paste(warn, collapse = ", "), " not found in data.",
         call. = F)
  }
}

check_folds <- function(V) {
  if (V > 1) {
    on.exit()
  } else {
    stop("The number of folds must be greater than 1.", call. = F)
  }
}

check_time_vary <- function(time_vary = NULL) {
  if (!is.null(time_vary)) {
    if (!is.list(time_vary)) {
      stop("time_vary must be a list.", call. = F)
    }
  }
}

check_estimation_engine <- function(learners_trt, learners_outcome) {
  if (is.null(learners_trt) & is.null(learners_outcome)) {
    set_increment_options("engine", "glm")
  } else {
    set_increment_options("engine", "sl3")
  }
}

check_glm_outcome <- function(outcome_type) {
  if (is.null(outcome_type)) {
    return("gaussian")
  } else if (outcome_type == "continuous") {
    return("gaussian")
  } else if (outcome_type == "binomial") {
    return(outcome_type)
  }
}
