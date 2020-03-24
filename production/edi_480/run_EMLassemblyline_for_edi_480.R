# This script executes an EMLassemblyline workflow.

# Package ID in staging = 348
# Package ID in production = 480

# Initialize workspace --------------------------------------------------------

setwd("C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_480")

library(EMLassemblyline)

path = "./metadata_templates"
data.path = "./data_objects"
eml.path = "./eml"
data.table <- "Water_chemistry.csv"

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
  dataset.title = "Pore water concentrations of Nitrogen from N-Addition plots in an Alberta Poor Fen, 2011-2015", 
  temporal.coverage = c("2011-05-31", "2015-08-06"), 
  geographic.description = "Alberta, Canada, 100 km south of Fort McMurray, Canada", 
  geographic.coordinates = c("55.897", "-112.094", "55.897", "-112.094"), 
  maintenance.description = "Complete",
  data.table = data.table,
  data.table.name = "Water chemistry",
  data.table.description = "Water chemistry",
  user.id = "csmith",
  user.domain = "LTER", 
  package.id = "edi.480.1"
)
