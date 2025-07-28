# Load environment and dependencies
source("user_profile.R")

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


# Execute data preparation script
source("scripts/01_data_preparation.R")

# Execute indicator calculation script
source("scripts/02_indicator_calculation.R")

# Render the final R Markdown report
rmarkdown::render(
  input = "scripts/03_Reporting.Rmd",
  output_file = "../Reporting.html",
  quiet = TRUE
)