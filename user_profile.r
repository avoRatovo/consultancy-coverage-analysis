# Step 1, Define and install required packages
required_packages <- c("readxl", "dplyr", "rmarkdown", "ggplot2", "knitr", "scales")

installed <- required_packages %in% rownames(installed.packages())
if (any(!installed)) {
  install.packages(required_packages[!installed])
}

# Step 2, Load all packages
invisible(lapply(required_packages, library, character.only = TRUE))

# Step 3, Set a consistent locale and encoding (optional but helps with special characters)
Sys.setlocale("LC_ALL", "C")
options(encoding = "UTF-8")