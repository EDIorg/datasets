# This script executes an EMLassemblyline workflow.

# Production package ID edi.502
# Staging package ID edi.315

# Initialize workspace --------------------------------------------------------

rm(list = ls())
library(EMLassemblyline)
setwd("C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_502")

# Parameterize ----------------------------------------------------------------

path <- "./metadata_templates"
data.path <- "./data_objects"
eml.path <- "./eml"

# Create templates ------------------------------------------------------------

template_core_metadata(
  path = path, 
  license = "CCBY", 
  file.type = ".txt")

template_table_attributes(
  path = path, 
  data.path = data.path, 
  data.table = "KentETAL2020_data.csv")

template_categorical_variables(
  path = path, 
  data.path = data.path)

template_geographic_coverage(
  path = path, 
  empty = T)

# Create EML ------------------------------------------------------------------

make_eml(
  path = path, 
  data.path = data.path, 
  eml.path = eml.path, 
  dataset.title = "Data for 'Weak latitudinal gradients in insect herbivory for dominant rangeland grasses of North America'",
  temporal.coverage = c("2015-06-29", "2015-09-05"), 
  maintenance.description = "Completed", 
  data.table = "KentETAL2020_data.csv", 
  data.table.name = "Data for Kent et al. 2020",
  data.table.description = "Data for the article Kent et al. 2020 'Weak latitudinal gradients in insect herbivory for dominant rangeland grasses of North America'", 
  user.id = "csmith", 
  user.domain = "LTER",
  package.id = "edi.502.1")
