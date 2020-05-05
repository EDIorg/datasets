# This script executes an EMLassemblyline workflow.

# Data package ID in staging = edi.322
# Data package ID in staging = edi.509

# Initialize workspace --------------------------------------------------------

rm(list = ls())
library(EMLassemblyline)
setwd("C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_509")


# Create metadata templates ---------------------------------------------------

EMLassemblyline::template_core_metadata(
  path = "./metadata_templates",
  license = "CCBY", 
  file.type = ".txt")

EMLassemblyline::template_table_attributes(
  path = "./metadata_templates", 
  data.path = "./data_objects",
  data.table = c(
    "Combined_Q.csv",
    "Grab_Sample.csv",
    "Stations.csv",
    "TidalWetland_sonde.csv"))

# Make EML --------------------------------------------------------------------
