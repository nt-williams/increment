
Meta <- R6::R6Class(
  "Meta",
  public = list(
    data = NULL,
    data_on = NULL,
    data_off = NULL,
    trt = NULL,
    node_list = NULL,
    n = NULL,
    tau = NULL,
    id = NULL,
    outcome_type = NULL,
    folds = NULL,
    weights_m = NULL,
    weights_r = NULL,
    initialize = function(data, trt, outcome, baseline, time_vary, k,
                          delta, learners_trt, learners_outcome, id,
                          outcome_type = NULL, folds = 10) {

      tau <- determine_tau(trt)

      # initial checks
      # check_for_variables(data, trt, outcome, baseline, time_vary)
      # check_missing_data(data, trt, outcome, time_vary, baseline)
      # check_folds(folds)
      # check_time_vary(time_vary)
      # check_estimation_engine(learners_trt, learners_outcome)

      # general setup
      self$n            <- nrow(data)
      self$tau          <- tau
      self$trt          <- trt
      self$node_list    <- create_node_list(trt, tau, time_vary, baseline, k)
      self$outcome_type <- outcome_type
      # self$id           <- data[[id]]

      # will change with cross fitting
      self$data     <- data
      self$data_on  <- turn_on(data, trt)
      self$data_off <- turn_off(data, trt)

    #   # cross validation setup
    #   self$folds <- folds <- setup_cv(data, data[["lmtp_id"]], V)
    #   self$m <-
    #     get_folded_data(cbind(matrix(
    #       nrow = nrow(data), ncol = tau
    #     ), scale_y_continuous(data[[final_outcome(outcome)]],
    #                           y_bounds(data[[final_outcome(outcome)]],
    #                                    outcome_type,
    #                                    bounds))),
    #     folds)
    #   self$data <-
    #     get_folded_data(
    #       fix_censoring_ind(
    #         add_scaled_y(data,
    #                      scale_y_continuous(data[[final_outcome(outcome)]],
    #                                         y_bounds(data[[final_outcome(outcome)]],
    #                                                  outcome_type,
    #                                                  bounds))),
    #         cens, tau), folds
    #     )
    #
    #   self$shifted_data <-
    #     get_folded_data(
    #       fix_censoring_ind(
    #         add_scaled_y(shift_data(data, trt, cens, shift),
    #                      scale_y_continuous(data[[final_outcome(outcome)]],
    #                                         y_bounds(data[[final_outcome(outcome)]],
    #                                                  outcome_type,
    #                                                  bounds))),
    #         cens, tau), folds
    #     )
    #
    #   self$weights_m <- hold_lrnr_weights(V)
    #   self$weights_r <- hold_lrnr_weights(V)
    }
  )
)
