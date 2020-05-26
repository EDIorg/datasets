# This script executes an EMLassemblyline workflow.

# Initialize workspace --------------------------------------------------------

rm(list = ls())
library(EMLassemblyline)
setwd("C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_520")

# Inspect data ----------------------------------------------------------------

d <- data.table::fread("./data_objects/Table_1_Data_Values.csv")

# Create metadata templates ---------------------------------------------------

template_core_metadata(
  path = "./metadata_templates",
  license = "CCBY",
  file.type = ".docx")

template_table_attributes(
  path = "./metadata_templates",
  data.path = "./data_objects",
  data.table = "Table_1_Data_Values.csv")

template_categorical_variables(
  path = "./metadata_templates",
  data.path = "./data_objects")

# Make EML --------------------------------------------------------------------

make_eml(
  path = "./metadata_templates",
  data.path = "./data_objects/",
  eml.path = "./eml/", 
  dataset.title = "Missouri Lakes and Reservoirs Long-term Limnological Dataset",
  temporal.coverage = c("1976-06-29", "2018-10-14"), 
  geographic.description = "State of Missouri", 
  geographic.coordinates = c("40.613560", "-95.765645", "36.497722", "-89.485083"),
  maintenance.description = "completed", 
  data.table = "Table_1_Data_Values.csv", 
  data.table.name = "PLACEHOLDER", 
  data.table.description = "PLACEHOLDER", 
  other.entity = c("methods.xlsx", "MU_Historical_Sampling_Sites.kml"),
  other.entity.name = c("Methods", "Sampling sites"),
  other.entity.description = c("Sample analysis methods for each parameter", "Locations of sampling sites"), 
  user.id = "csmith", 
  user.domain = "LTER", 
  package.id = "edi.19.1")
