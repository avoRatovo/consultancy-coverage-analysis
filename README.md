# Population-Weighted Coverage Analysis – ANC4 & SBA

## Context

This project was developed as part of a technical evaluation exercise for a consultancy position with UNICEF's Division of Data, Analytics, Planning and Monitoring (DAPM). It focuses on calculating population-weighted coverage for two essential maternal health indicators:

-   **ANC4**: Antenatal care visits (4 or more)
-   **SBA**: Skilled birth attendance

The analysis compares performance between countries **on track** and **off track** toward maternal health targets, using **projected births** as population weights.

------------------------------------------------------------------------

## Positions Applied For

This repository was submitted as part of the technical assessment for the following consultancy positions at UNICEF:

1.  Learning and Skills Data Analyst Consultant (Req: #581598)
2.  Household Survey Data Analyst Consultant (Req: #581656)
3.  Administrative Data Analyst (Req: #581696)
4.  Microdata Harmonization Consultant (Req: #581699)

------------------------------------------------------------------------

## Data Sources

The project uses three datasets:

1.  **ANC4 and SBA Coverage Data (2018–2022)**\
    File: `GLOBAL_DATAFLOW_2018-2022.xlsx`

2.  **Country Classification (On-track vs Off-track)**\
    File: `On-track and off-track countries.xlsx`

3.  **Population Projections**\
    File: `WPP2022_GEN_F01_DEMOGRAPHIC_INDICATORS_COMPACT_REV1.xlsx`\
    Sheets used: `"Estimates"` and `"Projections"`

------------------------------------------------------------------------

# Structure of the Repository

The repository is organized to support a reproducible and automated analysis workflow. At the root level, it includes five key components:

-   data/: Contains all datasets used throughout the workflow, organized into three subfolders:

    -   01_rawdata/: Original input files (e.g., demographic data, countries classification, indicator data).

    -   02_cleaned_data/: Intermediate cleaned and harmonized datasets.

    -   03_output_data/: Final analysis-ready datasets used for reporting.

-   scripts/: Holds all R scripts for processing and analysis:

    -   01_data_preparation.R: Cleans and merges input data.

    -   02_indicator_calculation.R: Computes population-weighted coverage for ANC4 and SBA.

    -   03_Reporting.Rmd: Generates the final report with visualizations and interpretation.

-   run_project.R: Main execution script that runs the full workflow from data preparation to report generation.

-   user_profile.R: Prepares the environment by installing and loading required packages and applying consistent settings.

-   Reporting.html: Automatically generated HTML report summarizing the findings.

------------------------------------------------------------------------

# How to Reproduce the Analysis

To ensure full reproducibility, the entire analysis can be executed from a single script. The following steps describe how to set up and run the workflow.

## Requirements

-   R version 4.0.0 or higher

-   Internet connection (required once, to install packages)

-   Operating system compatible with UTF-8 encoding (Windows, macOS, or Linux)

## R Packages Used

The following R packages are required to run this project:

-   readxl – for reading Excel files

-   dplyr – for data wrangling and manipulation

-   ggplot2 – for visualization

-   rmarkdown – for generating the final report

-   knitr – for rendering the report with dynamic content

-   scales – for formatting numeric labels in plots

All of these packages will be automatically installed if not already available on your machine, using the script user_profile.R. No manual installation is necessary.

## Steps to Run the Analysis

### Option 1 – Run the complete workflow from the console

1- Clone or download the repository to a local machine.

2- Open R or RStudio, and set the working directory to the root of the project.

3- Run the following command in the R console:

``` r
   source("run_project.R") 
```

### Option 2 – Run the script interactively

1- Clone or download the repository to a local machine.

2- Open R or RStudio, and set the working directory to the root of the project.

3- Open the file run_project.R in RStudio.

4- Execute the script line by line or run all lines at once (e.g., using Ctrl+Shift+Enter).

This script will:

-   Prepare the environment and install all required packages (user_profile.R)

-   Run the full data preparation and indicator calculation pipeline

-   Generate the final output report (Reporting.html)

------------------------------------------------------------------------

## Output

After successful execution, the following file will be generated:

-   Reporting.html – A standalone HTML report containing:

    -   Comparative visualization (On-track vs Off-track countries)

    -   Summary interpretation and methodological notes
