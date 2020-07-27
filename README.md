
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
n <- 250
W <- matrix(rnorm(n*3), ncol=3)
A <- rbinom(n,1, 1/(1+exp(-(.2*W[,1] - .1*W[,2] + .4*W[,3]))))
Y <- A + 2*W[,1] + W[,3] + W[,2]^2 + rnorm(n)
ex <- data.frame(W, A, Y)

# sl3 learner stack
library(sl3)
lrnrs <- sl3::make_learner_stack(Lrnr_glm_fast, 
                                 Lrnr_ranger, 
                                 Lrnr_xgboost)

# increment function
increment(ex, "A", "Y", c("X1", "X2", "X3"), delta = seq(0.1, 5, length.out = 10), 
          outcome_type = "continuous", learners_outcome = lrnrs, learners_trt = lrnrs)
#> Incremental Z estimator
#> 
#>    increment  estimate std.error  conf.low conf.high
#> 1  0.1000000 0.9183776 0.3649177 0.2031389  1.633616
#> 2  0.6444444 1.2064158 0.1919722 0.8301502  1.582681
#> 3  1.1888889 1.3609284 0.1873993 0.9936257  1.728231
#> 4  1.7333333 1.4608922 0.2099085 1.0494716  1.872313
#> 5  2.2777778 1.5309389 0.2321637 1.0758981  1.985980
#> 6  2.8222222 1.5820198 0.2504068 1.0912225  2.072817
#> 7  3.3666667 1.6236070 0.2654183 1.1033871  2.143827
#> 8  3.9111111 1.6508011 0.2773495 1.1071960  2.194406
#> 9  4.4555556 1.6756341 0.2877440 1.1116559  2.239612
#> 10 5.0000000 1.7007632 0.2959063 1.1207869  2.280740
#> 
#> Reference
#> Nonparametric Causal Effects Based on Incremental Propensity Score Interventions (Kennedy, 2019)
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
