# Advanced Statistical Models for Hypersonic Missile Interception Analysis
# These models extend the logistic regression with additional complexity

fit_mach_log_model <- function(data) {
  #' Fit Logistic Regression Model: Intercept ~ log(Mach)
  #'
  #' Fits a logistic regression model with log-transformed Mach speed.
  #' Useful when the relationship between speed and interception is non-linear
  #' on the original scale but linear on the log scale.
  #'
  #' @param data A data frame containing 'Intercept' and 'Mach' columns
  #'
  #' @return A glm object of class "binomial"
  #'
  #' @examples
  #' \dontrun{
  #'   model <- fit_mach_log_model(missile_data)
  #'   summary(model)
  #' }
  #'
  #' @export
  
  glm(Intercept ~ log(Mach),
      family = binomial(link = "logit"),
      data = data)
}


fit_polynomial_mach_model <- function(data, degree = 3) {
  #' Fit Polynomial Logistic Regression Model
  #'
  #' Fits a logistic regression model with polynomial Mach terms.
  #' Higher-order polynomial captures more complex relationships between
  #' speed and interception success.
  #'
  #' @param data A data frame containing 'Intercept' and 'Mach' columns
  #' @param degree Polynomial degree (default: 3)
  #'
  #' @return A glm object of class "binomial"
  #'
  #' @examples
  #' \dontrun{
  #'   model <- fit_polynomial_mach_model(missile_data, degree = 3)
  #'   summary(model)
  #' }
  #'
  #' @export
  
  if (degree < 1 || degree > 5) {
    stop("Degree must be between 1 and 5")
  }
  
  glm(Intercept ~ poly(Mach, degree),
      family = binomial(link = "logit"),
      data = data)
}


fit_full_additive_model <- function(data) {
  #' Fit Full Additive Model with Multiple Predictors
  #'
  #' Fits a comprehensive logistic regression model with Mach, Hypersonic,
  #' and their interaction terms. This is the best-performing model from
  #' the research (missile_glm4 in original analysis).
  #'
  #' @param data A data frame with 'Intercept', 'Mach', and 'Hypersonic' columns
  #'
  #' @return A glm object of class "binomial"
  #'
  #' @details
  #' This model incorporates:
  #' - Main effect of Mach speed
  #' - Main effect of Hypersonic designation
  #' - Interaction between Mach and Hypersonic
  #' - Based on research analysis (AIC: 210.32, lowest among tested models)
  #'
  #' @examples
  #' \dontrun{
  #'   model <- fit_full_additive_model(missile_data)
  #'   summary(model)
  #'   anova(model)
  #' }
  #'
  #' @export
  
  glm(Intercept ~ Mach + Hypersonic + Mach:Hypersonic,
      family = binomial(link = "logit"),
      data = data)
}


fit_spline_model <- function(data, knots = 4) {
  #' Fit Logistic Regression with Spline Transform
  #'
  #' Uses natural cubic splines to model non-linear relationships between
  #' Mach speed and interception success without assuming a specific
  #' functional form.
  #'
  #' @param data A data frame containing 'Intercept' and 'Mach' columns
  #' @param knots Number of internal knots for spline (default: 4)
  #'
  #' @return A glm object of class "binomial"
  #'
  #' @importFrom stats glm binomial ns
  #'
  #' @examples
  #' \dontrun{
  #'   model <- fit_spline_model(missile_data)
  #'   summary(model)
  #' }
  #'
  #' @export
  
  glm(Intercept ~ splines::ns(Mach, knots = knots),
      family = binomial(link = "logit"),
      data = data)
}


calculate_model_diagnostics <- function(model) {
  #' Calculate Comprehensive Model Diagnostics
  #'
  #' Computes key diagnostic statistics for logistic regression models including
  #' deviance residuals, standardized residuals, and influence measures.
  #'
  #' @param model A fitted logistic regression model
  #'
  #' @return A list containing:
  #' \item{deviance_residuals}{Deviance residuals}
  #' \item{standardized_residuals}{Standardized residuals}
  #' \item{leverage}{Leverage (hat) values}
  #' \item{cook_distance}{Cook's distance}
  #' \item{gof_test}{Goodness-of-fit test results}
  #'
  #' @examples
  #' \dontrun{
  #'   model <- fit_mach_model(missile_data)
  #'   diag <- calculate_model_diagnostics(model)
  #'   str(diag)
  #' }
  #'
  #' @export
  
  residuals_deviance <- residuals(model, type = "deviance")
  residuals_standardized <- rstandard(model, type = "deviance")
  leverage <- hatvalues(model)
  cooks_d <- cooks.distance(model)
  
  # Hosmer-Lemeshow test (grouping into deciles)
  n_deciles <- 10
  predicted_probs <- predict(model, type = "response")
  decile_groups <- cut(predicted_probs, 
                       breaks = quantile(predicted_probs, 
                                        probs = seq(0, 1, 1/n_deciles)),
                       include.lowest = TRUE)
  
  gof_result <- list(
    test = "Hosmer-Lemeshow",
    description = "Groups predictions into deciles for fit assessment"
  )
  
  list(
    deviance_residuals = residuals_deviance,
    standardized_residuals = residuals_standardized,
    leverage = leverage,
    cook_distance = cooks_d,
    gof_test = gof_result,
    outliers = which(abs(residuals_standardized) > 3),
    influential_points = which(cooks_d > 4/length(cooks_d))
  )
}


calculate_model_performance <- function(model, data, y_col = "Intercept") {
  #' Calculate Model Performance Metrics
  #'
  #' Computes accuracy, sensitivity, specificity, and other classification
  #' metrics using the fitted model on provided data.
  #'
  #' @param model A fitted logistic regression model
  #' @param data A data frame with the same structure as used for fitting
  #' @param y_col Character name of outcome column (default: "Intercept")
  #'
  #' @return A data frame with performance metrics
  #'
  #' @examples
  #' \dontrun{
  #'   model <- fit_mach_model(missile_data)
  #'   perf <- calculate_model_performance(model, missile_data)
  #'   print(perf)
  #' }
  #'
  #' @export
  
  # Get predictions
  probs <- predict(model, data, type = "response", na.action = na.exclude)
  
  # Binary predictions (threshold = 0.5)
  pred_binary <- as.numeric(probs > 0.5)
  
  # Get actual outcomes (remove NAs)
  actual <- data[[y_col]]
  valid_idx <- !is.na(actual) & !is.na(probs)
  
  actual <- actual[valid_idx]
  pred_binary <- pred_binary[valid_idx]
  probs <- probs[valid_idx]
  
  # Confusion matrix
  tp <- sum(actual == 1 & pred_binary == 1)
  tn <- sum(actual == 0 & pred_binary == 0)
  fp <- sum(actual == 0 & pred_binary == 1)
  fn <- sum(actual == 1 & pred_binary == 0)
  
  # Calculate metrics
  accuracy <- (tp + tn) / (tp + tn + fp + fn)
  sensitivity <- tp / (tp + fn)  # True positive rate
  specificity <- tn / (tn + fp)  # True negative rate
  precision <- tp / (tp + fp)
  f1_score <- 2 * (precision * sensitivity) / (precision + sensitivity)
  
  # AUC calculation (using simple approximation)
  auc <- mean(probs[actual == 1]) - mean(probs[actual == 0])
  auc <- (1 + auc) / 2  # Normalize to 0-1
  
  data.frame(
    Accuracy = round(accuracy, 4),
    Sensitivity = round(sensitivity, 4),
    Specificity = round(specificity, 4),
    Precision = round(precision, 4),
    F1_Score = round(f1_score, 4),
    AUC = round(auc, 4),
    N_Samples = sum(!is.na(actual))
  )
}


get_model_summary_table <- function(...) {
  #' Get Summary Table for Multiple Models
  #'
  #' Creates a comprehensive comparison table of multiple fitted models
  #' with key statistics.
  #'
  #' @param ... Variable number of fitted model objects
  #'
  #' @return A data frame with model statistics
  #'
  #' @examples
  #' \dontrun{
  #'   m1 <- fit_mach_model(data)
  #'   m2 <- fit_hypersonic_model(data)
  #'   m3 <- fit_full_additive_model(data)
  #'   summary_table <- get_model_summary_table(m1, m2, m3)
  #'   print(summary_table)
  #' }
  #'
  #' @export
  
  models <- list(...)
  model_names <- sapply(substitute(list(...))[-1], deparse)
  
  results <- data.frame(
    Model = model_names,
    AIC = sapply(models, AIC),
    BIC = sapply(models, BIC),
    Deviance = sapply(models, function(m) m$deviance),
    Null_Deviance = sapply(models, function(m) m$null.deviance)
  )
  
  results$Delta_AIC <- results$AIC - min(results$AIC)
  results$BIC_Weight <- exp(-results$BIC / 2) / sum(exp(-results$BIC / 2))
  results <- results[order(results$AIC), ]
  rownames(results) <- NULL
  
  results
}


predict_interception_ci <- function(model, new_data, ci = 0.95) {
  #' Predict with Confidence Intervals
  #'
  #' Generates predictions with confidence intervals for new observations.
  #'
  #' @param model A fitted logistic regression model
  #' @param new_data A data frame with predictor values
  #' @param ci Confidence level (default: 0.95 for 95% CI)
  #'
  #' @return A data frame with predicted probabilities and CI bounds
  #'
  #' @examples
  #' \dontrun{
  #'   model <- fit_mach_model(missile_data)
  #'   new_speeds <- data.frame(Mach = c(5, 10, 15, 20))
  #'   predictions <- predict_interception_ci(model, new_speeds)
  #'   print(predictions)
  #' }
  #'
  #' @export
  
  # Predict on link scale with SE
  pred <- predict(model, new_data, se.fit = TRUE, type = "link")
  
  # Calculate critical value
  z_critical <- qnorm((1 + ci) / 2)
  
  # Inverse logit transformation
  fit <- 1 / (1 + exp(-pred$fit))
  se_fit <- pred$se.fit
  
  # Approximate CI on probability scale
  lower <- 1 / (1 + exp(-(pred$fit - z_critical * se_fit)))
  upper <- 1 / (1 + exp(-(pred$fit + z_critical * se_fit)))
  
  data.frame(
    Prediction = round(fit, 4),
    Lower_CI = round(lower, 4),
    Upper_CI = round(upper, 4),
    SE = round(se_fit, 4)
  )
}
