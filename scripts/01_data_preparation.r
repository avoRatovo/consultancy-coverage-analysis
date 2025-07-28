# Script name 01_data_preparation.R
# Purpose, this script cleans and harmonizes the input datasets used for the coverage analysis

# It processes indicator data, population estimates and projections, and on track status information
# Regional and non country entities are excluded to ensure national level analysis
# Country and year variables are aligned across datasets for accurate merging
# The most recent non missing values per country and indicator are selected
# The final cleaned dataset is saved for use in reporting
# This script is executed automatically by run_project.R


# Step 1, Data cleaning

# a) Clean indicators data
# Remove rows with missing geographic area
# When importing Excel files, extra NA rows are sometimes added at the end.
# In this case, after reviewing the dataset, there is one NA row at the end that needs to be removed.
indicators <- indicators[!is.na(indicators$`Geographic area`), ]


# Remove regional and non country entities
# Vector of non country entities
non_country_entities <- c(
  "(SDGRC) Central Africa", "(SDGRC) Eastern Africa", "(SDGRC) North Africa", "(SDGRC) Southern Africa",
  "(SDGRC) United Nations Economic Commission for Africa", "(SDGRC) West Africa", "Africa", "African Union",
  "Americas", "Arab Maghreb Union (AMU)", "Arab States", "Asia and the Pacific", "Caribbean",
  "Central Africa (African Union)", "Central America", "Central and Southern Asia", "Central Asia",
  "Common Market for Eastern and Southern Africa (COMESA)", "Community of Sahel-Saharan States (CEN-SAD)",
  "East African Community (EAC)", "East and Southern Africa", "East Asia and Pacific", "Eastern Africa",
  "Eastern Africa (African Union)", "Eastern and South-Eastern Asia", "Eastern and Southern Africa", "Eastern Asia",
  "Eastern Europe and Central Asia", "Eastern Mediterranean", "Economic Community of Central African States (ECCAS)",
  "Economic Community of West African States (ECOWAS 2025)", "Economic Community of West African States (ECOWAS)",
  "Europe", "Europe and Central Asia", "Intergovernmental Authority on Development (IGAD)", "Latin America and the Caribbean",
  "Least Developed Countries (LDC)", "Middle Africa", "Middle East and North Africa", "North America",
  "Northern Africa", "Northern Africa (African Union)", "Northern Africa and Western Asia", "Northern America",
  "Oceania", "Oceania (exc. Australia and New Zealand)", "SDG regions - Global", "South-East Asia",
  "South-eastern Asia", "South America", "South Asia", "Southern Africa", "Southern Africa (African Union)",
  "Southern African Development Community (SADC)", "Southern Asia", "Sub-Saharan Africa",
  "UNICEF Programme Regions - Global", "UNICEF reporting regions - Global", "West and Central Africa",
  "Western Africa", "Western Africa (African Union)", "Western Asia", "Western Europe", "Western Pacific",
  "World Bank (high income)", "World Bank (low income)", "World Bank (lower middle income)", "World Bank (upper middle income)"
)

indicators <- indicators %>%
  filter(!`Geographic area` %in% non_country_entities)

# b) Clean population data
# The population Excel files include metadata rows at the top (rows 1 to 12),
# which contain NA, notes and formatting information that are not part of the real dataset.
# The 12th row contains the actual column headers (variable names) we want to use.

# For estimated population data
# Set column names using row 12, then remove the first 12 rows (Excel metadata)
colnames(pop_data_est) <- pop_data_est[12, ]
pop_data_est <- pop_data_est[-c(1:12), ]

# Do the same for projected population data
# Set column names using row 12, then remove the first 12 rows
colnames(pop_data_proj) <- pop_data_proj[12, ]
pop_data_proj <- pop_data_proj[-c(1:12), ]


# The two population datasets (Estimates and Projections) originally contain the same column names.
# In order to merge them into a single dataset while retaining the source of each value, 
# we append a suffix to the columns that differ between the two sources.
# This allows for a clear distinction between estimated and projected figures post-merge.


# Define the list of identifier columns that should not be renamed.
# These columns are consistent across both datasets and will serve as keys during the merge.
id_cols <- c("Index", "Variant", "Region, subregion, country or area *", "Notes",
             "Location code", "ISO3 Alpha-code", "ISO2 Alpha-code", "SDMX code**", "Type",
             "Parent code", "Year")

# Rename all non identifier columns in the 'Estimates' dataset by appending '_est'.
# This ensures that the variables such as Total Population, Crude Birth Rate, etc.,
# are labeled as originating from the Estimates sheet after the merge.
colnames(pop_data_est) <- ifelse(
  colnames(pop_data_est) %in% id_cols,
  colnames(pop_data_est),
  paste0(colnames(pop_data_est), "_est")
)

# Do the same for the 'Projections' dataset, using the '_proj' suffix.
# This ensures consistency and avoids column name conflicts when the datasets are joined.
colnames(pop_data_proj) <- ifelse(
  colnames(pop_data_proj) %in% id_cols,
  colnames(pop_data_proj),
  paste0(colnames(pop_data_proj), "_proj")
)


# Merge the two datasets by the identifier columns
pop_data <- full_join(
  pop_data_est,
  pop_data_proj,
  by = id_cols
)

# As specified, filter for coverage estimates from 2018 to 2022
# Keep only country level data for the years 2018 to 2022
pop_data <- pop_data %>%
  filter(Type == "Country/Area", Year %in% 2018:2022)


# c) Clean status data

# Remove rows with missing ISO3Code
# Although the current dataset does not contain any missing ISO3 codes,
# this precautionary step ensures robustness in case future updates introduce missing values.
status_data <- status_data[!is.na(status_data$ISO3Code), ]

# Normalize Status.U5MR to lowercase and recode as a binary indicator 'On_track_status'
status_data <- status_data %>%
  mutate(
    Status.U5MR = tolower(Status.U5MR),
    On_track_status = case_when(
      Status.U5MR %in% c("achieved", "on track") ~ "On-track",
      Status.U5MR == "acceleration needed" ~ "Off-track",
      TRUE ~ NA_character_
    )
  )

# Step 2, Merge datasets

# a) Merge population data with status data using ISO3 country code
merged <- full_join(
  pop_data,
  status_data,
  by = c("ISO3 Alpha-code" = "ISO3Code")
)

# b) Merge the result with indicators data using country name and year
merged <- full_join(
  merged,
  indicators,
  by = c("Region, subregion, country or area *" = "Geographic area", "Year" = "TIME_PERIOD")
)


# c) Rename the country column for clarity
merged <- merged %>%
  rename(Country = `Region, subregion, country or area *`)

# Step 3, Final filtering
# As specified, Keep the most recent non missing value per Country and Indicator within this range

merged <- merged %>%
  filter(!is.na(Indicator)) %>%
  group_by(Country, Indicator) %>%
  filter(Year == max(Year, na.rm = TRUE)) %>%
  ungroup()

# Save cleaned merged data to CSV
write.csv(
  merged,
  file = "data/02_cleaned_data/merged_latest_by_country_indicator.csv",
  row.names = FALSE
)
