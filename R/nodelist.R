
create_node_list <- function(trt, tau, time_vary = NULL, baseline = NULL, k = Inf) {
  if (is.null(k)) {
    k <- Inf
  }

  out <- list(trt = trt_node_list(trt, time_vary, baseline, k, tau),
              outcome = outcome_node_list(trt, time_vary, baseline, k, tau))

  return(out)
}

trt_node_list <- function(trt, time_vary, baseline = NULL, k, tau) {
  out <- list()
  if (!is.null(baseline)) {
    for (i in 1:tau) {
      out[[i]] <- c(baseline)
    }
  }

  if (length(out) == 0) {
    if (length(trt) == tau) {
      for (i in 1:tau) {
        if (i > 1) {
          out[[i]] <- c(time_vary[[i]], trt[i - 1])
        } else {
          out[[i]] <- c(time_vary[[i]])
        }
      }
    } else {
      for (i in 1:tau) {
        out[[i]] <- c(time_vary[[i]])
      }
    }
  } else {
    if (length(trt) == tau) {
      for (i in 1:tau) {
        if (i > 1) {
          out[[i]] <- c(out[[i]], time_vary[[i]], trt[i - 1])
        } else {
          out[[i]] <- c(out[[i]], time_vary[[i]])
        }
      }
    } else {
      for (i in 1:tau) {
        out[[i]] <- c(out[[i]], time_vary[[i]])
      }
    }
  }

  out <- slide_node_list(out, k)
  return(out)
}

outcome_node_list <- function(trt, time_vary, baseline = NULL, k, tau) {
  out <- list()
  if (length(trt) == tau) {
    for (i in 1:tau) {
      out[[i]] <- c(time_vary[[i]], trt[i])
    }
  } else {
    for (i in 1:tau) {
      out[[i]] <- c(time_vary[[i]], trt)
    }
  }

  out <- slide_node_list(out, k)

  if (!is.null(baseline)) {
    for (i in 1:tau) {
      out[[i]] <- c(baseline, out[[i]])
    }
  }
  return(out)
}

slide_node_list <- function(time_vary, k) {
  out <- paste(lapply(time_vary, function(x) paste(x, collapse = ",")))
  out <- slider::slide(out, ~ .x, .before = k)
  out <- lapply(out, function(x) {
    . <- strsplit(x, ",")
    if (k == 0) unlist(.)
    else unique(unlist(.))
  })
  return(out)
}
