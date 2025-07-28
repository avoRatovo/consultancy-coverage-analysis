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

