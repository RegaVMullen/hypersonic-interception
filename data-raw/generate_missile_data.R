# Script to generate sample missile launch database
# This creates realistic data for the hypersonicIntercept package demonstration

set.seed(42)

# Realistic missile launch database
# Based on publicly available missile performance data

n_samples <- 221  # Match the original analysis size

# Generate realistic Mach numbers (1-22 range based on hypersonic classifications)
# Most missiles are subsonic to supersonic, fewer hypersonic
mach_distribution <- c(
  runif(80, 1, 2.5),      # Subsonic (Mach 1-2.5)
  runif(60, 2.5, 5),      # Supersonic (Mach 2.5-5)
  runif(45, 5, 10),       # High Supersonic (Mach 5-10)
  runif(36, 10, 22)       # Hypersonic (Mach 10-22)
)

Mach <- head(mach_distribution, n_samples)

# Hypersonic designation (binary: 1 if Mach >= 5, 0 otherwise)
Hypersonic <- as.numeric(Mach >= 5)

# Interception success logistic function
# Based on the analysis from the research:
# Lower speeds are more likely to be intercepted
# Hypersonic designation reduces interception probability
# Interaction effects: Hypersonic status modifies Mach relationship

# Parameters from the analysis (missile_glm4 - best model)
intercept <- -2.7555
mach_coeff <- 1.0756
hypersonic_coeff <- 5.5768
interaction_coeff <- -1.1897

# Calculate probability of successful interception
linear_predictor <- intercept + mach_coeff * Mach + 
                    hypersonic_coeff * Hypersonic + 
                    interaction_coeff * Mach * Hypersonic

# Inverse logit function
p_intercept <- 1 / (1 + exp(-linear_predictor))

# Generate binary interception outcomes
Intercept <- rbinom(n_samples, 1, p_intercept)

# Create additional realistic variables
# Launch date (2015-2023)
LaunchDate <- seq(as.Date("2015-01-01"), 
                  as.Date("2023-12-31"), 
                  length.out = n_samples)

# Missile type (categorical)
MissileType <- sample(c("Cruise", "Ballistic", "Hypersonic Glide", "Air-Breathing Hypersonic"),
                      n_samples, 
                      prob = c(0.3, 0.35, 0.2, 0.15),
                      replace = TRUE)

# Defense system used (categorical)
DefenseSystem <- sample(c("PAC-3", "THAAD", "S-400", "Experimental"),
                        n_samples,
                        prob = c(0.3, 0.25, 0.25, 0.2),
                        replace = TRUE)

# Weather conditions (categorical)
Weather <- sample(c("Clear", "Cloudy", "Rain", "Low Visibility"),
                  n_samples,
                  prob = c(0.35, 0.35, 0.2, 0.1),
                  replace = TRUE)

# Distance to target (kilometers)
Distance_km <- runif(n_samples, 50, 500)

# Altitude at detection (meters)
Altitude_m <- runif(n_samples, 500, 35000)

# Radar cross-section proxy (0-10 scale)
RadarSignature <- runif(n_samples, 0, 10)

# Create the final dataset
missile_launch_database <- data.frame(
  LaunchDate = LaunchDate,
  MissileType = MissileType,
  DefenseSystem = DefenseSystem,
  Weather = Weather,
  Mach = round(Mach, 2),
  Hypersonic = Hypersonic,
  Distance_km = round(Distance_km, 1),
  Altitude_m = round(Altitude_m, 0),
  RadarSignature = round(RadarSignature, 2),
  Intercept = Intercept
)

# Add some missing values to match original data
# Original had 149 missing observations
missile_launch_database$Mach[sample(1:n_samples, 50)] <- NA
missile_launch_database$Hypersonic[sample(1:n_samples, 30)] <- NA
missile_launch_database$Distance_km[sample(1:n_samples, 20)] <- NA

# Save to package data
usethis::use_data(missile_launch_database, overwrite = TRUE)

# Display summary
cat("Missile Launch Database Summary\n")
cat("================================\n")
print(head(missile_launch_database, 10))
cat("\nDimensions:", nrow(missile_launch_database), "x", ncol(missile_launch_database), "\n")
cat("Missing values by column:\n")
print(colSums(is.na(missile_launch_database)))
cat("\nInterception Success Rate:", 
    round(mean(missile_launch_database$Intercept, na.rm = TRUE) * 100, 1), "%\n")
cat("Hypersonic Rate:", 
    round(mean(missile_launch_database$Hypersonic, na.rm = TRUE) * 100, 1), "%\n")
