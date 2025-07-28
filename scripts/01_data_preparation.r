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
