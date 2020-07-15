
construct_pseudo <- function(delta, pred_on, pred_off, prop) {
  num   <- delta*prop*pred_on + (1 - prop)*pred_off
  denom <- delta*prop + 1 - prop
  return(num / denom)
}
