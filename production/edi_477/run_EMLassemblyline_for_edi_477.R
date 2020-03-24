# This script executes an EMLassemblyline workflow.

# Package ID in staging = 345
# Package ID in production = 477

# Initialize workspace --------------------------------------------------------

setwd("C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_477")

library(EMLassemblyline)

path = "./metadata_templates"
data.path = "./data_objects"
eml.path = "./eml"
data.table <- c("Root_Biomass.csv", "Root_Production.csv")

# Create metadata templates ---------------------------------------------------

EMLassemblyline::template_core_metadata(
  path = path, 
  license = "CC0", 
  file.type = ".docx"
)

EMLassemblyline::template_table_attributes(
  path = path,
  data.path = data.path,
  data.table = data.table
)

EMLassemblyline::template_categorical_variables(
  path = path, 
  data.path = data.path
)

# Create EML ------------------------------------------------------------------

EMLassemblyline::make_eml(
  path = path,
  data.path = data.path,
  eml.path = eml.path, 
  dataset.title = "Vascular Root Biomass and Production at Two Depths in an Alberta Poor Fen Subjected to Increasing Nitrogen Deposition, 2014-2015", 
  temporal.coverage = c("2014-05-31", "2015-09-23"), 
  geographic.description = "Alberta, Canada, 100 km south of Fort McMurray, Canada", 
  geographic.coordinates = c("55.897", "-112.094", "55.897", "-112.094"), 
  maintenance.description = "Complete",
  data.table = data.table,
  data.table.name = c("Root Biomass", "Root Production"),
  data.table.description = c("Root Biomass", "Root Production"),
  user.id = "csmith",
  user.domain = "LTER", 
  package.id = "edi.477.1"
)
