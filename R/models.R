import_missile_data <- function(file_path, na = "N/A") {
  #' Load Missile Launch Database
  #'
  #' Imports the missile launch database from an Excel file with proper NA handling.
  #'
  #' @param file_path Character string specifying path to the Excel file
  #' @param na Character vector specifying NA representation in the data (default: "N/A")
  #'
  #' @return A data frame with missile launch data
  #'
  #' @importFrom readxl read_excel
  #'
  #' @examples
  #' \dontrun{
  #'   data <- import_missile_data("MissileLaunchDatabase.xlsx")
  #' }
  #'
  #' @export
  
  readxl::read_excel(file_path, na = na)
}


fit_mach_model <- function(data) {
  #' Fit Logistic Regression Model: Intercept ~ Mach
  #'
  #' Fits a logistic regression model predicting interception success based on Mach number.
  #'
  #' @param data A data frame containing 'Intercept' and 'Mach' columns
  #'
  #' @return A glm object of class "binomial"
  #'
  #' @examples
  #' \dontrun{
  #'   model <- fit_mach_model(missile_data)
  #'   summary(model)
  #' }
  #'
  #' @export
  
  glm(Intercept ~ Mach, 
      family = binomial(link = "logit"), 
      data = data)
}


fit_hypersonic_model <- function(data) {
  #' Fit Logistic Regression Model: Intercept ~ Hypersonic
  #'
  #' Fits a logistic regression model predicting interception success based on hypersonic designation.
  #'
  #' @param data A data frame containing 'Intercept' and 'Hypersonic' columns
  #'
  #' @return A glm object of class "binomial"
  #'
  #' @examples
  #' \dontrun{
  #'   model <- fit_hypersonic_model(missile_data)
  #'   summary(model)
  #' }
  #'
  #' @export
  
  glm(Intercept ~ Hypersonic, 
      family = binomial(link = "logit"), 
      data = data)
}


fit_mach_squared_model <- function(data) {
  #' Fit Logistic Regression Model: Intercept ~ I(Mach^2)
  #'
  #' Fits a logistic regression model with squared Mach term for non-linear relationship.
  #'
  #' @param data A data frame containing 'Intercept' and 'Mach' columns
  #'
  #' @return A glm object of class "binomial"
  #'
  #' @examples
  #' \dontrun{
  #'   model <- fit_mach_squared_model(missile_data)
  #'   summary(model)
  #' }
  #'
  #' @export
  
  glm(Intercept ~ I(Mach^2), 
      family = binomial(link = "logit"), 
      data = data)
}


fit_interaction_model <- function(data) {
  #' Fit Logistic Regression Model: Intercept ~ Mach * Hypersonic
  #'
  #' Fits a logistic regression model with interaction between Mach and Hypersonic.
  #'
  #' @param data A data frame containing 'Intercept', 'Mach', and 'Hypersonic' columns
  #'
  #' @return A glm object of class "binomial"
  #'
  #' @examples
  #' \dontrun{
  #'   model <- fit_interaction_model(missile_data)
  #'   summary(model)
  #' }
  #'
  #' @export
  
  glm(Intercept ~ Mach * Hypersonic, 
      family = binomial(link = "logit"), 
      data = data)
}


predict_interception <- function(model, new_data) {
  #' Predict Interception Success Probability
  #'
  #' Generates probability predictions for interception success given model and new data.
  #'
  #' @param model A fitted logistic regression model from hypersonicIntercept
  #' @param new_data A data frame with same predictors as used in model fitting
  #'
  #' @return A vector of predicted probabilities
  #'
  #' @examples
  #' \dontrun{
  #'   model <- fit_mach_model(data)
  #'   new_speeds <- data.frame(Mach = seq(1, 22, by = 0.5))
  #'   probs <- predict_interception(model, new_speeds)
  #' }
  #'
  #' @export
  
  predict(model, new_data, type = "response")
}


compare_models <- function(...) {
  #' Compare Multiple Models Using AIC
  #'
  #' Compares fitted models using Akaike Information Criterion (AIC).
  #'
  #' @param ... Variable number of fitted model objects
  #'
  #' @return A data frame with model comparison statistics
  #'
  #' @examples
  #' \dontrun{
  #'   m1 <- fit_mach_model(data)
  #'   m2 <- fit_hypersonic_model(data)
  #'   m3 <- fit_interaction_model(data)
  #'   compare_models(m1, m2, m3)
  #' }
  #'
  #' @export
  
  models <- list(...)
  model_names <- sapply(substitute(list(...))[-1], deparse)
  
  comparison <- data.frame(
    Model = model_names,
    AIC = sapply(models, AIC),
    BIC = sapply(models, BIC)
  )
  
  comparison$deltaAIC <- comparison$AIC - min(comparison$AIC)
  comparison <- comparison[order(comparison$AIC), ]
  rownames(comparison) <- NULL
  
  return(comparison)
}


plot_model_fit <- function(data, model, x_col, x_label) {
  #' Plot Model Fit Against Data
  #'
  #' Creates a scatter plot of observed data with fitted logistic curve.
  #'
  #' @param data A data frame containing the original data
  #' @param model A fitted logistic regression model
  #' @param x_col Character name of the predictor column in data
  #' @param x_label Character label for x-axis
  #'
  #' @return Invisibly returns the plot coordinates (creates side effect of plotting)
  #'
  #' @examples
  #' \dontrun{
  #'   model <- fit_mach_model(missile_data)
  #'   plot_model_fit(missile_data, model, "Mach", "Mach Speed")
  #' }
  #'
  #' @export
  
  x_seq <- seq(min(data[[x_col]], na.rm = TRUE), 
               max(data[[x_col]], na.rm = TRUE), 
               length.out = 100)
  pred_data <- data.frame(x_seq)
  names(pred_data) <- x_col
  
  y_pred <- predict(model, pred_data, type = "response")
  
  plot(data[[x_col]], data$Intercept, 
       pch = 16, 
       xlab = x_label, 
       ylab = "Interception Success (Y/N)",
       main = "Logistic Model Fit")
  
  lines(x_seq, y_pred, col = "red", lwd = 2)
  
  invisible(list(x = x_seq, y = y_pred))
}
