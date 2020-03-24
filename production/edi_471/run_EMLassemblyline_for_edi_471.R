# This script executes an EMLassemblyline workflow.

# Package ID in staging = 339
# Package ID in production = 471

# Initialize workspace --------------------------------------------------------

setwd("C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_471")

library(EMLassemblyline)

path = "./metadata_templates"
data.path = "./data_objects"
eml.path = "./eml"
data.table <- "Acetylene_Reduction_and_N2_Fixation.csv"

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

EMLassemblyline::template_taxonomic_coverage(
  path = path,
  data.path = path,
)

# Create EML ------------------------------------------------------------------

EMLassemblyline::make_eml(
  path = path,
  data.path = data.path,
  eml.path = eml.path, 
  dataset.title = "Nitrogen Fixation Responses in Sphagnum Mosses to N-Additions to an Alberta Poor Fen, 2012-2015", 
  temporal.coverage = c("2012-11-06", "2015-08-06"), 
  geographic.description = "Alberta, Canada, 100 km south of Fort McMurray, Canada", 
  geographic.coordinates = c("55.897", "-112.094", "55.897", "-112.094"), 
  maintenance.description = "Complete", 
  data.table = data.table,
  data.table.name = "Nitrogen Fixation Fen ARA Data",
  data.table.description = "Nitrogen Fixation Fen ARA Data",
  user.id = "csmith",
  user.domain = "LTER", 
  package.id = "edi.471.1"
)
