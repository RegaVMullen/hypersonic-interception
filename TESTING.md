# Testing the hypersonicIntercept Package Locally

This guide walks you through testing the R package on your machine.

## Prerequisites

You'll need:
- R 4.0 or later
- RStudio (optional but recommended)
- Development tools for your OS:
  - **Linux/Mac**: Xcode Command Line Tools (`xcode-select --install`)
  - **Windows**: Rtools (https://cran.r-project.org/bin/windows/Rtools/)

## Installation

### 1. Install Development Dependencies

In R, run:
```r
install.packages(c("devtools", "testthat", "readxl", "car", "splines", "roxygen2", "knitr", "rmarkdown"))
```

### 2. Load Package in Development Mode

```r
# Set working directory to package root
setwd("/path/to/hypersonic-interception")

# Install and load with development tools
devtools::load_all()
```

Or simply:
```r
devtools::install()
```

## Testing Steps

### Step 1: Run Unit Tests

```r
devtools::test()
```

This will run all tests in `tests/testthat/`. You should see output like:
```
✓ test-models.R (5.2s)
  ✓ model fitting returns glm object
  ✓ predict_interception returns probabilities
  ✓ compare_models returns data frame with AIC and BIC
  ✓ calculate_model_performance returns metrics
  ✓ predict_interception_ci returns CI bounds
```

### Step 2: Check Package Integrity

```r
devtools::check()
```

This runs the full R CMD CHECK suite and will:
- Validate package structure
- Check documentation
- Run tests
- Look for warnings and errors

Expected output should show **0 errors, 0 warnings**.

### Step 3: Test with Sample Data

```r
library(hypersonicIntercept)

# Load the included sample dataset
data(missile_launch_database)

# Quick exploration
head(missile_launch_database)
summary(missile_launch_database)

# Fit a simple model
model <- fit_mach_model(missile_launch_database)
summary(model)

# Make predictions
new_data <- data.frame(Mach = seq(5, 20, by = 5))
predictions <- predict_interception(model, new_data)
print(predictions)

# Test advanced functions
perf <- calculate_model_performance(model, missile_launch_database)
print(perf)

diag <- calculate_model_diagnostics(model)
print(paste("Outliers found:", length(diag$outliers)))
```

### Step 4: Test All Models

```r
library(hypersonicIntercept)
data(missile_launch_database)

# Fit all model types
m1 <- fit_mach_model(missile_launch_database)
m2 <- fit_hypersonic_model(missile_launch_database)
m3 <- fit_mach_squared_model(missile_launch_database)
m4 <- fit_mach_log_model(missile_launch_database)
m5 <- fit_polynomial_mach_model(missile_launch_database, degree=3)
m6 <- fit_spline_model(missile_launch_database)
m7 <- fit_full_additive_model(missile_launch_database)

# Compare all models
comparison <- compare_models(m1, m2, m3, m4, m5, m6, m7)
print(comparison)

# Get detailed summary
summary_table <- get_model_summary_table(m1, m2, m3, m4, m5, m6, m7)
print(summary_table)
```

### Step 5: Test Visualization

```r
library(hypersonicIntercept)
data(missile_launch_database)

model <- fit_mach_model(missile_launch_database)

# Create visualization
plot_model_fit(missile_launch_database, model, "Mach", "Mach Speed")

# For Hypersonic model
model2 <- fit_hypersonic_model(missile_launch_database)
plot_model_fit(missile_launch_database, model2, "Hypersonic", "Hypersonic Status")
```

### Step 6: Build Vignette

```r
devtools::build_vignettes()
```

Then view the vignette:
```r
vignette("getting-started", package = "hypersonicIntercept")
```

## Building Documentation

Generate roxygen2 documentation:

```r
devtools::document()
```

This creates the `.Rd` files in the `man/` directory from roxygen comments.

## Building Package

Create a source package tarball:

```r
devtools::build()
```

This creates `hypersonic-interception_0.1.0.tar.gz` ready for distribution.

## Troubleshooting

### "Package not found" error
```r
# Make sure you're in the right directory
setwd("/path/to/hypersonic-interception")

# Try reloading
devtools::load_all()
```

### Test failures
- Check that all dependencies are installed: `devtools::install_deps()`
- Look at specific test file: `devtools::test_file("tests/testthat/test-models.R")`
- Run individual tests for debugging

### Documentation not updated
```r
# Regenerate all documentation
devtools::document()
```

## Expected Test Results

When all tests pass, you should see:
```
✓ test-models.R (X.Xs)
  ✓ model fitting returns glm object
  ✓ predict_interception returns probabilities
  ✓ compare_models returns data frame with AIC and BIC
  ✓ calculate_model_performance returns metrics
  ✓ predict_interception_ci returns CI bounds

Test summary
✓ 5 tests passed
```

And `devtools::check()` should return:
```
── R CMD check results ───────────────────────
Status: OK
```

## Next Steps After Testing

Once all tests pass locally:

1. **Commit changes**: 
   ```bash
   git add .
   git commit -m "Add advanced models, sample data, and expanded tests"
   git push origin main
   ```

2. **Monitor GitHub Actions**: Check that tests pass on GitHub Actions workflow

3. **Build pkgdown website** (optional):
   ```r
   pkgdown::build_site()
   ```

4. **Prepare for CRAN submission** (optional):
   - Run `devtools::check(remote = TRUE, manual = TRUE)`
   - Review CRAN policy: https://cran.r-project.org/web/packages/policies.html
   - Submit via: https://cran.r-project.org/submit.html

## Quick Reference

```r
# Essential commands
devtools::load_all()              # Load package for testing
devtools::test()                  # Run all tests
devtools::check()                 # Full package check
devtools::document()              # Generate documentation
devtools::build()                 # Build package tarball
devtools::install()               # Install package locally
```

## Questions?

For issues or questions about specific functions, use:
```r
?function_name       # View documentation
help(function_name)  # View help page
```

All functions are documented with examples via roxygen2.
