# 1. Import datasets
# a) ANC4 and SBA coverage data (2018–2022)
indicators <- read_excel("data/01_rawdata/GLOBAL_DATAFLOW_2018-2022.xlsx")

# b) Country classification (on-track / off-track)
status_data <- read_excel("data/01_rawdata/On-track and off-track countries.xlsx")

# c) Population projections (estimated births in 2022)
# Import Estimates sheet
pop_data_est <- read_excel("data/01_rawdata/WPP2022_GEN_F01_DEMOGRAPHIC_INDICATORS_COMPACT_REV1.xlsx", sheet = "Estimates")

# Import Projections sheet
pop_data_proj <- read_excel("data/01_rawdata/WPP2022_GEN_F01_DEMOGRAPHIC_INDICATORS_COMPACT_REV1.xlsx", sheet = "Projections")


# 2. Data cleaning

# a) Clean indicators data
# Remove rows with missing geographic area
# (Note: When importing Excel files, extra NA rows are sometimes added at the end.
# In this case, after reviewing the dataset, there is one NA row at the end that needs to be removed.)
indicators <- indicators[!is.na(indicators$`Geographic area`), ]


# Remove regional and non-country entities
# Vector of non-country entities
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
  filter(!`Geographic area` %in% non_country_entities & !is.na(`Geographic area`))
