# Script name 02_indicator_calculation.R
# Purpose, this script calculates the population weighted coverage for two maternal health indicators ANC4 and SBA

# It uses the cleaned dataset produced by the script 01_data_preparation.R and isolates only the variables required for the analysis
# It ensures that projected births from the year 2022 are used as consistent weights for all years
# It filters out any rows with missing values in coverage observations group classification or projected births
# It computes the weighted average coverage separately for On track and Off track groups using projected births as weights
# The weighted coverage is calculated as the sum of coverage multiplied by weight divided by the total weight for each group and indicator
# It outputs a single summary table stored in data/03_output_data/coverage_weighted_final.csv
# This result is used directly in the final reporting step and supports comparison between country groups
# This script is run automatically from run_project.R and assumes that the data preparation step in 01_data_preparation.R has been completed successfully


# Step 1, Create a simplified dataset with only the required variables for weighted coverage analysis

weighted_data <- merged %>%
  # Filter to retain only the two target indicators, ANC4 and SBA
  # These indicators are required to compute population weighted coverage between 2018 and 2022
  filter(Indicator %in% c(
    "Antenatal care 4+ visits - percentage of women (aged 15-49 years) attended at least four times during pregnancy by any provider",
    "Skilled birth attendant - percentage of deliveries attended by skilled health personnel"
  )) %>%
  # Select relevant columns
  # Country identifiers
  # Indicator name and value (OBS_VALUE)
  # Projected births (used as weights)
  # Group classification (On track or Off track)
  select(
    Country,
    `ISO3 Alpha-code`,
    Indicator,
    Year,
    OBS_VALUE,
    `Births (thousands)_proj`,   # Used as population weights
    On_track_status              # To disaggregate results by status group
  )


# Step 2, Get projected births for 2022 from the projections sheet
# Although the instructions mention using 2022 projections, the original merged dataset used projections from the corresponding year of the indicator.
# Here we correct that by explicitly extracting 2022 projections for all countries.
pop_2022_proj <- pop_data_proj %>%
  filter(Year == 2022, Type == "Country/Area") %>%
  select(`ISO3 Alpha-code`, `Births (thousands)_proj`)  # More reliable population weight

# Step 3, Merge 2022 projected births with the simplified indicators dataset
weighted_data <- weighted_data %>%
  left_join(pop_2022_proj, by = "ISO3 Alpha-code") %>%
  rename(weight_2022 = `Births (thousands)_proj.y`)  # Rename to clarify it's the 2022 projection

# Remove the original 'Births' column from the indicator year as no longer needed
weighted_data <- weighted_data %>%
  select(-`Births (thousands)_proj.x`)

# Convert relevant columns to numeric for calculations
weighted_data <- weighted_data %>%
  mutate(
    weight_2022 = as.numeric(weight_2022),
    OBS_VALUE = as.numeric(OBS_VALUE)
  )


# Step 4, Filter the dataset to include only valid rows
# Non missing coverage value (OBS_VALUE)
# Non missing projected births for 2022 (weight_2022)
# Non missing group classification (On_track_status)
# Each row in this dataset represents a country indicator year observation.
# Only countries with all three fields filled are included in the weighted average.

weighted_data <- weighted_data %>%
  filter(!is.na(OBS_VALUE), !is.na(weight_2022), !is.na(On_track_status))

# Step 5, Calculate population weighted coverage
# Weighted average coverage is computed as
# sum of (country coverage times projected births in 2022) divided by total projected births
# This approach ensures that countries contribute proportionally to their estimated number of births

weighted_data <- weighted_data %>%
  group_by(On_track_status, Indicator) %>%
  summarise(
    weighted_coverage = sum(OBS_VALUE * weight_2022, na.rm = TRUE) /
      sum(weight_2022, na.rm = TRUE),
    .groups = "drop"
  )

# Step 6, Save final result

# Create output folder if it doesn't exist
if (!dir.exists("data/03_output_data")) dir.create("data/03_output_data", recursive = TRUE)

# Write weighted_data to CSV
write.csv(weighted_data, "data/03_output_data/coverage_weighted_final.csv", row.names = FALSE)