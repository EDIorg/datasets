# This script executes an EMLassemblyline workflow.

# Package identifier (production) = edi.442
# Package identifier (staging) = edi.321

# Install and load required packages ------------------------------------------

# remotes::install_github("EDIorg/EMLassemblyline")
library(EMLassemblyline)
# remotes::install_github("EDIorg/dataCleanr")
library(dataCleanr)

# Fix data issues -------------------------------------------------------------
# Combine tables, gather into long format, and convert dates

setwd("/Users/csmith/Downloads/8 Estonian Lakes")

# Read tables
f <- list.files(".", full.names = TRUE)
d <- lapply(
  f,
  readr::read_csv,
  col_names = TRUE
)

# Get lake names for long table
lke <- stringr::str_extract(f, "(?<=Lake).*(?=_)")

# Create long table
d <- dplyr::bind_rows(
  lapply(
    seq_along(d),
    function(x) {
      g <- tidyr::gather(
        d[[x]], 
        key = "variable", 
        value = "value",
        -"Date/Time_(GMT+3)_DD/MM/YYYY hh:mm"
      )
      g$lake <- lke[x]
      g
    }
  )
)

# Convert datetime data to ISO-8601 format
d$`Date/Time_(GMT+3)_DD/MM/YYYY hh:mm` <- dataCleanr::iso8601_convert(
  d$`Date/Time_(GMT+3)_DD/MM/YYYY hh:mm`,
  orders = "d/m/Y H:M"
)
d$`Date/Time_(GMT+3)_DD/MM/YYYY hh:mm` <- stringr::str_replace(
  d$`Date/Time_(GMT+3)_DD/MM/YYYY hh:mm`,
  "T",
  " "
)

# Add depth column
d$depth <- NA
d$depth[stringr::str_detect(d$variable, "0.5")] <- 0.5
d$depth[stringr::str_detect(d$variable, "1.5")] <- 1.5
d$depth[stringr::str_detect(d$variable, "1.0")] <- 1.0

# Add new variable column
d$variable_new <- NA_character_
d$variable_new[stringr::str_detect(d$variable, "CO2_.*_uatm")] <- "co2_uatm"
d$variable_new[stringr::str_detect(d$variable, "CO2_water")] <- "co2_water"
d$variable_new[stringr::str_detect(d$variable, "Temp")] <- "temp"
d$variable_new[stringr::str_detect(d$variable, "DO_.*_%")] <- "do_sat"
d$variable_new[stringr::str_detect(d$variable, "DO_.*_mg/L")] <- "do"
d$variable_new[stringr::str_detect(d$variable, "Sal")] <- "sal"
d$variable_new[stringr::str_detect(d$variable, "pH")] <- "ph"

# Add unit column
d$unit <- NA_character_
d$unit[stringr::str_detect(d$variable, "CO2_.*_uatm")] <- "microAtmosphere"
d$unit[stringr::str_detect(d$variable, "CO2_water")] <- "milligramsPerLiter"
d$unit[stringr::str_detect(d$variable, "Temp")] <- "celsius"
d$unit[stringr::str_detect(d$variable, "DO_.*_%")] <- "percent"
d$unit[stringr::str_detect(d$variable, "DO_.*_mg/L")] <- "milligramsPerLiter"
d$unit[stringr::str_detect(d$variable, "Sal")] <- "partsPerThousand"
d$unit[stringr::str_detect(d$variable, "pH")] <- "dimensionless"

# Add precision column
d$precision <- NA_character_
d$precision[stringr::str_detect(d$variable, "CO2_.*_uatm")] <- "0.000001"
d$precision[stringr::str_detect(d$variable, "CO2_water")] <- "0.00000001"
d$precision[stringr::str_detect(d$variable, "Temp")] <- "0.01"
d$precision[stringr::str_detect(d$variable, "DO_.*_%")] <- "0.1"
d$precision[stringr::str_detect(d$variable, "DO_.*_mg/L")] <- "0.01"
d$precision[stringr::str_detect(d$variable, "Sal")] <- "0.01"
d$precision[stringr::str_detect(d$variable, "pH")] <- "0.01"

# Rename and order columns

d <- dplyr::select(
  d,
  "lake",
  "Date/Time_(GMT+3)_DD/MM/YYYY hh:mm",
  "depth",
  "variable_new",
  "value",
  "unit",
  "precision"
)

names(d) <- c(
  "lake",
  "datetime",
  "depth",
  "variable",
  "value",
  "unit",
  "precision"
)

# Sort rows
d <- dplyr::arrange(d, lake, datetime)

# Write to file
readr::write_csv(
  d, 
  "/Users/csmith/Documents/EDI/datasets/edi_442/data_objects/lake_data.csv",
  col_names = T
)

# Template metadata -----------------------------------------------------------

setwd("/Users/csmith/Documents/EDI/datasets/edi_442")

# Template core metadata and manually complete
template_core_metadata(
  path = "./metadata_templates", 
  license = "CCBY",
  file.type = ".docx"
)

# Template table attributes and manully complete
template_table_attributes(
  path = "./metadata_templates",
  data.path = "./data_objects",
  data.table = "lake_data.csv"
)

# Template categorical variables listed in table_attributes.txt
template_categorical_variables(
  path = "./metadata_templates",
  data.path = "./data_objects"
)

# Create EML ------------------------------------------------------------------

make_eml(
  path = "./metadata_templates",
  data.path = "./data_objects",
  eml.path = "./eml",
  dataset.title = "Short-term high-frequency water dissolved carbon dioxide, temperature, dissolved oxygen, salinity and pH data from 8 Estonian lakes in year 2014",
  temporal.coverage = c("2014-07-15", "2014-09-16"), 
  geographic.description = "Lakes in Estonia",
  geographic.coordinates = c(
    "59.4221454961",
    "27.8811820576",
    "57.9779604752",
    "22.340163588"
  ), 
  maintenance.description = "Completed", 
  data.table = "8_Estonian_lakes_data.csv",
  data.table.description = "Short-term high-frequency water measurements in 8 Estonian lakes", 
  user.id = "csmith",
  user.domain = "LTER",
  package.id = "edi.442.1"
)
