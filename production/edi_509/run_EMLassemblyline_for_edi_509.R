# This script executes an EMLassemblyline workflow.

# Data package ID in staging = edi.322
# Data package ID in staging = edi.509

# Initialize workspace --------------------------------------------------------

rm(list = ls())
library(EMLassemblyline)
library(data.table)
setwd("C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_509")

# Inspect data ----------------------------------------------------------------

d <- data.table::fread("./data_objects/Grab_Sample_Data_CDWR.csv")
unique(d$Result[is.na(as.numeric(d$Result))])

# Create metadata templates ---------------------------------------------------

EMLassemblyline::template_core_metadata(
  path = "./metadata_templates",
  license = "CCBY", 
  file.type = ".txt")

EMLassemblyline::template_table_attributes(
  path = "./metadata_templates", 
  data.path = "./data_objects",
  data.table = c(
    "Combined_Q_CDWR.csv",
    "Grab_Sample_Data_CDWR.csv",
    "Stations_Table_CDWR.csv",
    "TidalWetland_sonde_data_CDWR.csv"))

EMLassemblyline::template_categorical_variables(
  path = "./metadata_templates", 
  data.path = "./data_objects")

# Make EML --------------------------------------------------------------------

EMLassemblyline::make_eml(
  path = "./metadata_templates",
  data.path = "./data_objects",
  eml.path = "./eml",
  dataset.title = "Mercury Imports and Exports of Four Tidal Wetlands in the Sacramento Valley, California",
  temporal.coverage = c("2014-03-10", "2019-08-05"), 
  geographic.description = "Tidal wetlands in the Sacramento-San Joaquin Delta, Yolo Bypass, and Suisun Marsh, California USA, WGS84",
  geographic.coordinates = c("38.494813", "-121.400309", "38.235174", "-121.919819"), 
  maintenance.description = "Complete", 
  data.table = c(
    "Station_Table_CDWR.csv", 
    "Grab_Sample_Data_CDWR.csv", 
    "TidalWetland_sonde_data_CDWR.csv",
    "Combined_Q_CDWR.csv"),
  data.table.name = c(
    "Sampling stations",
    "Grab samples",
    "Sonde measurements",
    "Flow measurements"),
  data.table.description = c(
    "Sampling Locations at Four Tidal Wetlands in the Sacramento Valley",
    "Grab Sample Mercury, Organic Carbon, Total Suspended Solids, and Chlorophyll Data at Four Tidal Wetlands in the Sacramento Valley",
    "Continuous Water Quality Data at Four Tidal Wetlands in the Sacramento Valley",
    "Continuous Flow, Velocity, and Level Water Data at Four Tidal Wetlands in the Sacramento Valley"), 
  data.table.quote.character = c(
    "\"",
    "\"",
    "\"",
    "\""),
  other.entity = "Final_Report.pdf",
  other.entity.name = "Final report",
  other.entity.description = "This is the final compliance report for this data with some basic analyses. We will be submitting a manuscript to a peer-reviewed journal and will update EDI with the information.", 
  user.id = "csmith",
  user.domain = "LTER", 
  package.id = "edi.509.1")





