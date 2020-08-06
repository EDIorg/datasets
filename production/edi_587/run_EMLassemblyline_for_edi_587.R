# This script executes an EMLassemblyline workflow.

# Initialize workspace --------------------------------------------------------

rm(list = ls())
library(EMLassemblyline)

# Define paths for your metadata templates, data, and EML

path_templates <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_587\\metadata_templates"
path_data <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_587\\data_objects"
path_eml <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_587\\eml"

# Re-write data ---------------------------------------------------------------
# Quote all elements in character vectors

d <- data.table::fread(
  paste0(path_data, "/Socioecological_monitoring_data.csv"))
data.table::fwrite(
  d, 
  paste0(path_data, "/Socioecological_monitoring_data.csv"), 
  quote = TRUE)

# Create metadata templates ---------------------------------------------------

EMLassemblyline::template_core_metadata(
  path = path_templates,
  license = "CCBY",
  file.type = ".docx")

EMLassemblyline::template_table_attributes(
  path = path_templates,
  data.path = path_data,
  data.table = c("Socioecological_monitoring_data.csv"))

EMLassemblyline::template_categorical_variables(
  path = path_templates, 
  data.path = path_data)

EMLassemblyline::template_geographic_coverage(
  path = path_templates, 
  data.path = path_data, 
  empty = TRUE)

# Make EML from metadata templates --------------------------------------------

EMLassemblyline::make_eml(
  path = path_templates,
  data.path = path_data,
  eml.path = path_eml, 
  dataset.title = "Sacramento-San Joaquin Delta Socioecological Monitoring", 
  temporal.coverage = c("2017-07-07", "2018-03-13"), 
  maintenance.description = "Data collection is complete. Updates are not expected.", 
  data.table = c("Socioecological_monitoring_data.csv"), 
  data.table.name = c("Socioecological monitoring data"),
  data.table.description = c("Socioecological monitoring data"),
  data.table.quote.character = "\\\"",
  user.id = "csmith",
  user.domain = "EDI", 
  package.id = "edi.587.1")
