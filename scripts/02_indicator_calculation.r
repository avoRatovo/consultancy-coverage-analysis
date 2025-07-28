# Step 1 – Create a simplified dataset with only the required variables for weighted coverage analysis

weighted_data <- merged %>%
  # Filter to retain only the two target indicators: ANC4 and SBA
  # These indicators are required to compute population-weighted coverage between 2018–2022
  filter(Indicator %in% c(
    "Antenatal care 4+ visits - percentage of women (aged 15-49 years) attended at least four times during pregnancy by any provider",
    "Skilled birth attendant - percentage of deliveries attended by skilled health personnel"
  )) %>%
  # Select relevant columns:
  # - Country identifiers
  # - Indicator name and value (OBS_VALUE)
  # - Projected births (used as weights)
  # - Group classification (On-track or Off-track)
  select(
    Country,
    `ISO3 Alpha-code`,
    Indicator,
    Year,
    OBS_VALUE,
    `Births (thousands)_proj`,   # Used as population weights
    On_track_status              # To disaggregate results by status group
  )


# Step 2 – Get projected births for 2022 from the projections sheet
# Note: Although the instructions mention using 2022 projections, the original merged dataset used projections from the corresponding year of the indicator.
# Here we correct that by explicitly extracting 2022 projections for all countries.
pop_2022_proj <- pop_data_proj %>%
  filter(Year == 2022, Type == "Country/Area") %>%
  select(`ISO3 Alpha-code`, `Births (thousands)_proj`)  # More reliable population weight

# Step 3 – Merge 2022 projected births with the simplified indicators dataset
weighted_data <- weighted_data %>%
  left_join(pop_2022_proj, by = "ISO3 Alpha-code") %>%
  rename(weight_2022 = `Births (thousands)_proj.y`)  # Rename to clarify it's the 2022 projection

# Optional: Remove the original 'Births' column from the indicator year as no longer needed
weighted_data <- weighted_data %>%
  select(-`Births (thousands)_proj.x`)

# Convert relevant columns to numeric for calculations
weighted_data <- weighted_data %>%
  mutate(
    weight_2022 = as.numeric(weight_2022),
    OBS_VALUE = as.numeric(OBS_VALUE)
  )