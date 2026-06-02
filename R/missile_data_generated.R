#' Generated missile_launch_database dataset
#'
#' This dataset is generated deterministically for package builds when a
#' pre-saved data/ file is not present. It mirrors data-raw/generate_missile_data.R.
#'
#' @export
missile_launch_database <- local({
  set.seed(42)
  n_samples <- 221

  mach_distribution <- c(
    runif(80, 1, 2.5),
    runif(60, 2.5, 5),
    runif(45, 5, 10),
    runif(36, 10, 22)
  )
  Mach <- head(mach_distribution, n_samples)
  Hypersonic <- as.numeric(Mach >= 5)

  intercept <- -2.7555
  mach_coeff <- 1.0756
  hypersonic_coeff <- 5.5768
  interaction_coeff <- -1.1897

  linear_predictor <- intercept + mach_coeff * Mach + 
    hypersonic_coeff * Hypersonic + 
    interaction_coeff * Mach * Hypersonic

  p_intercept <- 1 / (1 + exp(-linear_predictor))
  Intercept <- rbinom(n_samples, 1, p_intercept)

  LaunchDate <- seq(as.Date("2015-01-01"), as.Date("2023-12-31"), length.out = n_samples)
  MissileType <- sample(c("Cruise", "Ballistic", "Hypersonic Glide", "Air-Breathing Hypersonic"),
                        n_samples,
                        prob = c(0.3, 0.35, 0.2, 0.15),
                        replace = TRUE)
  DefenseSystem <- sample(c("PAC-3", "THAAD", "S-400", "Experimental"),
                          n_samples,
                          prob = c(0.3, 0.25, 0.25, 0.2),
                          replace = TRUE)
  Weather <- sample(c("Clear", "Cloudy", "Rain", "Low Visibility"),
                    n_samples,
                    prob = c(0.35, 0.35, 0.2, 0.1),
                    replace = TRUE)
  Distance_km <- runif(n_samples, 50, 500)
  Altitude_m <- runif(n_samples, 500, 35000)
  RadarSignature <- runif(n_samples, 0, 10)

  df <- data.frame(
    LaunchDate = LaunchDate,
    MissileType = MissileType,
    DefenseSystem = DefenseSystem,
    Weather = Weather,
    Mach = round(Mach, 2),
    Hypersonic = Hypersonic,
    Distance_km = round(Distance_km, 1),
    Altitude_m = round(Altitude_m, 0),
    RadarSignature = round(RadarSignature, 2),
    Intercept = Intercept,
    stringsAsFactors = FALSE
  )

  # introduce missing values to match original script
  df$Mach[sample(1:n_samples, 50)] <- NA
  df$Hypersonic[sample(1:n_samples, 30)] <- NA
  df$Distance_km[sample(1:n_samples, 20)] <- NA

  df
})
