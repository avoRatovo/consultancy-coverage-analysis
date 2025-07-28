# Load required libraries
library(readxl)
library(dplyr)
library(rmarkdown)

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