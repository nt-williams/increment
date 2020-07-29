
<!-- README.md is generated from README.Rmd. Please edit that file -->

# increment

<!-- badges: start -->

[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
<!-- badges: end -->

> Non-Parametric Causal Effects Based on Incremental Propensity Score
> Interventions

## Scope

An implementation of the incremental propensity score intervention
Z-estimator described in [Kennedy
(2019)](https://doi.org/10.1080/01621459.2017.1422737). Nuisance
parameters are estimated using the Super Learner from the
[`sl3`](https://github.com/tlverse/sl3) package and sample splitting is
used. The UI is implemented in the same manner as the
[`lmtp`](https://github.com/nt-williams/lmtp) package and provides a
compliment to the main objective of
[`lmtp`](https://github.com/nt-williams/lmtp) for when
treatment/exposure is binary.

### To do

  - Extend ability to right-censored data and time-varying exposure as
    described in [Kim et al. (2019)](https://arxiv.org/abs/1907.04004)
  - Implement hypothesis testing
  - Return super learner weights
  - Provide plotting function
  - Refine returned output

## Installation

*Note that `increment` is under active development.*

You can install the development version of `increment` from
[GitHub](https://github.com/) with:

``` r
devtools::install_github("nt-williams/increment")
```

## Example

``` r
library(increment)
library(sl3)
library(future)

n <- 250
W <- matrix(rnorm(n*3), ncol=3)
A <- rbinom(n,1, 1/(1+exp(-(.2*W[,1] - .1*W[,2] + .4*W[,3]))))
Y <- A + 2*W[,1] + W[,3] + W[,2]^2 + rnorm(n)
ex <- data.frame(W, A, Y)

# sl3 learner stack
lrnrs <- make_learner_stack(Lrnr_glm_fast, 
                                 Lrnr_ranger, 
                                 Lrnr_xgboost)

plan(multiprocess)

# increment function
increment(ex, "A", "Y", c("X1", "X2", "X3"), delta = seq(0.1, 5, length.out = 10), 
          outcome_type = "continuous", learners_outcome = lrnrs, learners_trt = lrnrs)
# Incremental propensity score intevention Z-estimator
# 
#            Confidence level: 95%
#      Multiplier Bootstrap C: 2.37 
# First 6 increment estimates:
# 
# # A tibble: 6 x 7
#   increment estimate std.error conf.low conf.high mult.conf.low mult.conf.high
#       <dbl>    <dbl>     <dbl>    <dbl>     <dbl>         <dbl>          <dbl>
# 1      0.1      1.18      0.36     0.48      1.88          0.33           2.03
# 2      0.64     1.4       0.19     1.03      1.76          0.96           1.84
# 3      1.19     1.53      0.19     1.15      1.91          1.07           1.98
# 4      1.73     1.62      0.22     1.18      2.05          1.09           2.14
# 5      2.28     1.67      0.25     1.19      2.16          1.09           2.26
# 6      2.82     1.72      0.27     1.19      2.24          1.08           2.35
```

## Contributing

Contributions are not only welcome but encouraged.

Please note that the increment project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.

## References

Edward H. Kennedy (2019) Nonparametric Causal Effects Based on
Incremental Propensity Score Interventions, Journal of the American
Statistical Association, 114:526, 645-656, DOI:
10.1080/01621459.2017.1422737

Kwangho Kim and Edward H. Kennedy and Ashley I. Naimi (2019) Incremental
Intervention Effects in Studies with Many Timepoints, Repeated Outcomes,
and Dropout, arXiv: 1907.04004
