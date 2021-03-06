#' Smooth for THieF
#'
#' This function is a wrapper for \code{smooth} package models to work with the \code{thief} package.
#'
#' @param data Vector or ts object, containing data needed to be forecasted.
#' @param h Forecast horizon.
#' @param type Type of model to use. \code{type} can be: \code{es} (Exponential Smoothing), 
#' \code{ssarima} (ARIMA) and \code{ces} (Complex Exponential Smoothing).
#' @param ... Additional arguments to be passed to model. See \code{\link{es}}, 
#' \code{\link{auto.ssarima}} and \code{\link{auto.ces}} for details.
#'
#' @return Returns object of class "smooth.forecast", which contains:
#'
#' \itemize{
#' \item \code{model} - the estimated model.
#' \item \code{fitted} - fitted values of the model.
#' \item \code{x} - actuals provided in the call of the model.
#' \item \code{mean} - point forecasts of the model
#' (conditional mean).
#' }
#' @author Nikolaos Kourentzes, \email{nikolaos@@kourentzes.com}
#' @seealso \code{\link{es}, \code{\link{auto.ssarima}}, \code{\link{auto.ces}}}
#' @references Athanasopoulos, G., Hyndman, R.J., Kourentzes N., Petropoulos F. 
#' (2017) Forecasting with Temporal Hierarchies. European Journal of Operational Research.
#' \url{http://kourentzes.com/forecasting/2017/02/27/forecasting-with-temporal-hierarchies-3/}
#' @keywords forecast ts thief
#' @examples
#'
#' ## **Not run:** 
#' library(thief)
#' frc <- thief(referrals,forecastfunction=smooth.thief,type="es")
#' plot(frc)
#' ## End(**Not run**)
#'
#' @export smooth.thief

smooth.thief <- function(data,h,type=c("es","ssarima","ces","ges"),...){
# This is a wrapper function to create smooth thieves
    
  # Check if thief is loaded. If not give an error to the user
  if ("package:thief" %in% search()){
  
    type <- match.arg(type,c("es","ssarima","ces","ges"))
    switch(type,
           "es" = {
             fit <- es(data,silent=TRUE,...)
           },
           "ssarima" = {
             fit <- auto.ssarima(data,silent=TRUE,...)
           },
           "ces" = {
             fit <- auto.ces(data,silent=TRUE,...)
           },
           "ges" = {stop("No automatic GES model fitting yet")})
    
    fc <- forecast(fit,h=h)
    fc$lower <- fc$upper <- fc$level <- fc$forecast <- fc$intervals <- fc$residuals <- fc$method <- fc$xname <- fc$actuals <- NULL
  
  } else {
    
    stop("Package thief must be loaded first and this function is to be used as an argument in thief, not as a standalone. See example in help.")
    
  } 
    
  return(fc)
  
}