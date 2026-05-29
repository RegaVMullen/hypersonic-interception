# Project Structure Guide

This document explains the organization of the `hypersonicIntercept` package.

## Directory Layout

```
hypersonic-interception/
├── .github/
│   └── workflows/
│       └── R-CMD-check.yaml       # GitHub Actions CI/CD workflow
├── R/
│   └── models.R                    # Main package functions
├── tests/
│   ├── testthat.R                  # Test configuration
│   └── testthat/
│       └── test-models.R           # Unit tests for models
├── vignettes/
│   └── getting-started.Rmd         # User tutorials
├── man/                            # Generated documentation (roxygen)
├── data-raw/                       # Raw data processing scripts
├── .gitignore                      # Git configuration
├── DESCRIPTION                     # Package metadata
├── NAMESPACE                       # Package exports
├── LICENSE                         # MIT License
├── README.md                       # User-facing overview
├── DEPLOYMENT.md                   # GitHub deployment guide
└── PROJECT_STRUCTURE.md            # This file
```

## Key Files Explained

### `DESCRIPTION`
Package metadata including:
- Package name, version, title
- Authors and dependencies
- License and URL information

### `NAMESPACE`
Specifies which functions are exported (public API) and which packages are imported.

### `R/models.R`
Core functionality containing:
- `import_missile_data()` - Load data from Excel
- `fit_mach_model()` - Logistic regression on Mach speed
- `fit_hypersonic_model()` - Logistic regression on hypersonic designation
- `fit_mach_squared_model()` - Non-linear model with Mach^2
- `fit_interaction_model()` - Model with Mach × Hypersonic interaction
- `predict_interception()` - Generate predictions
- `compare_models()` - Compare models via AIC/BIC
- `plot_model_fit()` - Visualization of fitted models

### `tests/testthat/test-models.R`
Unit tests validating:
- Model fitting returns correct glm objects
- Predictions are valid probabilities (0-1)
- Model comparison produces expected outputs

### `vignettes/getting-started.Rmd`
Tutorial demonstrating:
- Data loading workflow
- Model fitting examples
- Making predictions
- Comparing models
- Visualization

## Development Workflow

### Adding New Features

1. **Add function to `R/models.R`**
   ```r
   #' Descriptive Title
   #' 
   #' Longer description...
   #' @param arg1 Description of arg1
   #' @return Description of return value
   #' @export
   my_new_function <- function(arg1) {
     # implementation
   }
   ```

2. **Add tests to `tests/testthat/test-models.R`**
   ```r
   test_that("my_new_function does X", {
     expect_true(my_new_function(input) == output)
   })
   ```

3. **Document and build**
   ```r
   devtools::document()  # Generate roxygen docs
   devtools::test()      # Run all tests
   devtools::check()     # Full package check
   ```

4. **Commit and push**
   ```bash
   git add .
   git commit -m "Add new_function for X purpose"
   git push origin main
   ```

### Git Workflow

```bash
# Create feature branch
git checkout -b feature/new-model

# Make changes, test locally
devtools::check()

# Commit with clear message
git commit -m "Add exponential model variant"

# Push to GitHub
git push origin feature/new-model

# Create pull request on GitHub
# Merge after GitHub Actions passes
```

## Extending the Package

### Adding a New Model

1. Create fitting function in `R/models.R`
2. Add roxygen documentation
3. Add unit tests
4. Add example vignette
5. Update README with new model

### Adding Sample Data

1. Process data and save in `data/` directory:
   ```r
   missile_data <- import_missile_data("path/to/original.xlsx")
   usethis::use_data(missile_data)
   ```

2. Document in `R/data.R`:
   ```r
   #' Missile Launch Database
   #' 
   #' Sample dataset containing...
   #' @format Data frame with X rows and Y columns
   "missile_data"
   ```

### Adding More Vignettes

1. Create new `.Rmd` file in `vignettes/`
2. Include YAML frontmatter with title and index entry
3. Use `usethis::use_vignette()` helper
4. Build with `devtools::build_vignettes()`

## Dependencies

Current dependencies (in DESCRIPTION):
- **Required:** `readxl` (data import), `car` (diagnostics)
- **Testing:** `testthat`
- **Documentation:** `roxygen2` (implicit via devtools)

Add new dependencies with:
```r
usethis::use_package("new_package", type = "Imports")
```

## Documentation Generation

Documentation is generated from roxygen2 comments using `devtools::document()`. Key tags:

- `@title` - Function title
- `@description` - Longer description
- `@param` - Parameter documentation
- `@return` - Return value description
- `@examples` - Code examples
- `@export` - Marks function as public API
- `@importFrom pkg func` - Import from another package

## GitHub Integration

### Actions Workflow

The `.github/workflows/R-CMD-check.yaml` automatically:
- Runs on push to main branches and pull requests
- Tests on R 4.0+, release, and development versions
- Tests on Windows, macOS, and Linux
- Uploads failure artifacts for debugging

### Status Badges

Add to README:
```markdown
[![R-CMD-check](https://github.com/yourusername/hypersonic-interception/workflows/R-CMD-check/badge.svg)](https://github.com/yourusername/hypersonic-interception/actions)
```

## Next Steps

See `DEPLOYMENT.md` for instructions on:
1. Pushing to GitHub
2. Setting up GitHub Actions (already configured)
3. Publishing documentation
4. Submitting to CRAN (optional)
