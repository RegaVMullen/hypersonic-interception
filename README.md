# hypersonic-interception

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

An R package for statistical modeling and prediction of hypersonic missile interception success rates.

## Overview

`hypersonicIntercept` provides tools for analyzing and predicting the effectiveness of air defense systems against hypersonic threats. Built from rigorous statistical analysis of missile launch data, it includes multiple logistic regression models examining relationships between missile speed characteristics (Mach number, hypersonic designation) and interception outcomes.

## Installation

You can install the development version directly from GitHub:

```r
# install.packages("devtools")
devtools::install_github("yourusername/hypersonic-interception")
```

## Quick Start

```r
library(hypersonicIntercept)

# Load your missile launch data
data <- import_missile_data("path/to/MissileLaunchDatabase.xlsx")

# Fit a model based on Mach speed
model_mach <- fit_mach_model(data)
summary(model_mach)

# Make predictions for new Mach speeds
new_speeds <- data.frame(Mach = seq(1, 22, by = 0.5))
predictions <- predict_interception(model_mach, new_speeds)

# Compare multiple models
m1 <- fit_mach_model(data)
m2 <- fit_hypersonic_model(data)
m3 <- fit_interaction_model(data)
compare_models(m1, m2, m3)

# Visualize model fit
plot_model_fit(data, model_mach, "Mach", "Mach Speed")
```

## Available Models

- **`fit_mach_model()`** - Logistic regression: Intercept ~ Mach
- **`fit_hypersonic_model()`** - Logistic regression: Intercept ~ Hypersonic  
- **`fit_mach_squared_model()`** - Non-linear model: Intercept ~ I(Mach^2)
- **`fit_interaction_model()`** - Interaction model: Intercept ~ Mach * Hypersonic

## Features

- 📊 Multiple logistic regression models for interception prediction
- 🔍 Model comparison using AIC/BIC criteria
- 📈 Built-in visualization for model diagnostics
- 🎯 Probability-based predictions for new observations
- 🔬 Rigorous statistical foundation from peer research

## Documentation

Full documentation available via `?function_name` in R. See the vignettes for detailed examples:

```r
vignette("getting-started", package = "hypersonicIntercept")
vignette("model-comparison", package = "hypersonicIntercept")
```

## Dependencies

- `readxl` - for reading Excel data files
- `car` - for model diagnostics

## Citation

If you use this package in your research, please cite:
```
Mullen, R. (2023). Hypersonic Missile Interception Analysis. R package.
```

## License

MIT License - see LICENSE file for details

## Contributing

Contributions are welcome! Please submit issues or pull requests to the GitHub repository.

## Contact

For questions or feedback, please open an issue on GitHub.
