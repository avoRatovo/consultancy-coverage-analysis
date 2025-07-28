# Script name user_profile.R
# This script prepares the R environment to ensure smooth execution of the analysis workflow
# It defines the list of required packages and installs any that are missing
# It loads all necessary libraries silently to avoid cluttering the console
# It sets the locale and UTF-8 encoding to handle special characters consistently across systems
# This script should be sourced before running any other component of the project
# It is automatically called at the beginning of run_project.R


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