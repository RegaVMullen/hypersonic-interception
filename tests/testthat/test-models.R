test_that("model fitting returns glm object", {
  # Create sample data
  sample_data <- data.frame(
    Mach = c(2, 5, 10, 15, 20),
    Hypersonic = c(0, 0, 1, 1, 1),
    Intercept = c(0, 0, 1, 1, 1)
  )
  
  # Test Mach model
  m1 <- fit_mach_model(sample_data)
  expect_s3_class(m1, "glm")
  expect_equal(m1$family$family, "binomial")
  
  # Test Hypersonic model
  m2 <- fit_hypersonic_model(sample_data)
  expect_s3_class(m2, "glm")
  
  # Test Mach squared model
  m3 <- fit_mach_squared_model(sample_data)
  expect_s3_class(m3, "glm")
  
  # Test interaction model
  m4 <- fit_interaction_model(sample_data)
  expect_s3_class(m4, "glm")
})

test_that("predict_interception returns probabilities", {
  sample_data <- data.frame(
    Mach = c(2, 5, 10, 15, 20),
    Hypersonic = c(0, 0, 1, 1, 1),
    Intercept = c(0, 0, 1, 1, 1)
  )
  
  model <- fit_mach_model(sample_data)
  new_data <- data.frame(Mach = c(5, 10, 15))
  
  preds <- predict_interception(model, new_data)
  
  expect_length(preds, 3)
  expect_true(all(preds >= 0 & preds <= 1))
})

test_that("compare_models returns data frame with AIC and BIC", {
  sample_data <- data.frame(
    Mach = c(2, 5, 10, 15, 20),
    Hypersonic = c(0, 0, 1, 1, 1),
    Intercept = c(0, 0, 1, 1, 1)
  )
  
  m1 <- fit_mach_model(sample_data)
  m2 <- fit_hypersonic_model(sample_data)
  
  comparison <- compare_models(m1, m2)
  
  expect_s3_class(comparison, "data.frame")
  expect_true("AIC" %in% names(comparison))
  expect_true("BIC" %in% names(comparison))
  expect_true("deltaAIC" %in% names(comparison))
  expect_equal(nrow(comparison), 2)
})
