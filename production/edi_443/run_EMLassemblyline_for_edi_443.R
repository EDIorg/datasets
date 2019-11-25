# This script executes an EMLassemblyline workflow.

# Identifier in staging = edi.332
# Identifier in produciton = edi.443

# Initialize workspace --------------------------------------------------------

rm(list = ls())
setwd("/Users/csmith/Documents/EDI/datasets/edi_443")

# Load required packages
library(EMLassemblyline)

# Create metadata templates ---------------------------------------------------

template_core_metadata(
  path = "./metadata_templates", 
  license = "CCBY", 
  file.type = ".docx"
)

template_table_attributes(
  path = "./metadata_templates",
  data.path = "./data_objects",
  data.table = c(
    "Buffalo.csv",
    "Croche.csv",
    "Harp2013.csv",
    "Harp2014.csv",
    "Lillsjolidtjarnen.csv",
    "Mangstrettjarn.csv",
    "Nastjarn.csv",
    "OvreBjorntjarn.csv",
    "Simoncouche.csv",
    "Stortjarn.csv",
    "Struptjarn.csv",
    "Vortjarv.csv" 
  )
)

# Make EML --------------------------------------------------------------------
make_eml(
  path = "./metadata_templates",
  data.path = "./data_objects",
  eml.path = "./eml", 
  dataset.title = "Summer high frequency measurements of dissolved O2 and CO2 concentrations and water temperature at the surface of 11 northern lakes", 
  temporal.coverage = c("2011-07-01", "2014-08-01"),
  geographic.description = "11 lakes situated in the Northern Hemisphere (Canada, Estonia and Sweden)", 
  geographic.coordinates = c(
    "64.26",
    "26.09",
    "45.38",
    "-105.5"
  ), 
  maintenance.description = "Complete", 
  data.table = c(
    "Buffalo.csv",
    "Croche.csv",
    "Harp2013.csv",
    "Harp2014.csv",
    "Lillsjolidtjarnen.csv",
    "Mangstrettjarn.csv",
    "Nastjarn.csv",
    "OvreBjorntjarn.csv",
    "Simoncouche.csv",
    "Stortjarn.csv",
    "Struptjarn.csv",
    "Vortjarv.csv" 
  ), 
  data.table.description = c(
    "Buffalo lake data",
    "Croche lake data",
    "Harp2013 lake data",
    "Harp2014 lake data",
    "Lillsjolidtjarnen lake data",
    "Mangstrettjarn lake data",
    "Nastjarn lake data",
    "OvreBjorntjarn lake data",
    "Simoncouche lake data",
    "Stortjarn lake data",
    "Struptjarn lake data",
    "Vortjarv lake data" 
  ), 
  other.entity = c(
    "methods.pdf",
    "O2CO2metrics.r",
    "lake1.txt"
  ), 
  other.entity.description = c(
    "Methods for these data",
    "Script to calculate cloud metrics using time series of dissolved O2 and CO2 departure measurements",
    "Example input data for O2CO2metrics.r"
  ), 
  user.id = "csmith",
  user.domain = "LTER",
  package.id = "edi.443.2"
)


