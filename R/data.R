#' Missile Launch Database
#'
#' A realistic sample dataset containing information about missile launches
#' and air defense interception attempts. Based on publicly available data
#' and research analysis of hypersonic weapon system performance.
#'
#' @format A data frame with 221 rows and 10 columns:
#' \describe{
#'   \item{LaunchDate}{Date of missile launch (Date)}
#'   \item{MissileType}{Type of missile - "Cruise", "Ballistic", "Hypersonic Glide", or "Air-Breathing Hypersonic" (character)}
#'   \item{DefenseSystem}{Air defense system used for interception attempt - "PAC-3", "THAAD", "S-400", or "Experimental" (character)}
#'   \item{Weather}{Weather conditions at time of launch - "Clear", "Cloudy", "Rain", or "Low Visibility" (character)}
#'   \item{Mach}{Speed of missile in Mach numbers (numeric, range 1-22)}
#'   \item{Hypersonic}{Binary indicator of hypersonic status: 1 if Mach >= 5, 0 otherwise (numeric, 0 or 1)}
#'   \item{Distance_km}{Distance to target in kilometers (numeric)}
#'   \item{Altitude_m}{Altitude of missile at detection in meters (numeric)}
#'   \item{RadarSignature}{Radar cross-section proxy on 0-10 scale (numeric)}
#'   \item{Intercept}{Binary outcome: 1 if interception successful, 0 if failed (numeric, 0 or 1)}
#' }
#'
#' @details
#' This dataset is designed for training and testing logistic regression models
#' that predict the probability of successful interception based on missile
#' characteristics. Contains 149 observations with missing data (marked as NA)
#' to reflect real-world data collection challenges.
#'
#' Key statistics:
#' \itemize{
#'   \item Overall interception success rate: ~73%
#'   \item Hypersonic missiles: ~36% of sample
#'   \item Speed range: Mach 1.0 to Mach 21.8
#' }
#'
#' @source Generated from research analysis of air defense effectiveness
#' against hypersonic weapons (Mullen, 2023-2024)
#'
#' @examples
#' data(missile_launch_database)
#' head(missile_launch_database)
#'
#' # Summary statistics
#' summary(missile_launch_database)
#'
#' # Fit a basic model
#' model <- fit_mach_model(missile_launch_database)
#' summary(model)
#'
#' # Make predictions
#' new_speeds <- data.frame(Mach = seq(5, 20, by = 5))
#' predictions <- predict_interception(model, new_speeds)
#' print(predictions)
#'
#' @export
"missile_launch_database"
