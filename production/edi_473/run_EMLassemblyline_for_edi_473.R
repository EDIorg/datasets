# This script executes an EMLassemblyline workflow.

# Package ID in staging = 341
# Package ID in production = 473

# Initialize workspace --------------------------------------------------------

setwd("C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_473")

library(EMLassemblyline)

path = "./metadata_templates"
data.path = "./data_objects"
eml.path = "./eml"
data.table <- "Net_N_Mineralization.csv"

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
  dataset.title = "Net N mineralization rates in peat from N-Addition plots in an Alberta Poor Fen, 2011-2014", 
  temporal.coverage = c("2011-06-01", "2014-07-01"), 
  geographic.description = "Alberta, Canada, 100 km south of Fort McMurray, Canada", 
  geographic.coordinates = c("55.897", "-112.094", "55.897", "-112.094"), 
  maintenance.description = "Complete", 
  data.table = data.table,
  data.table.name = c("Net N Mineralization"),
  data.table.description = c("Net N Mineralization"),
  user.id = "csmith",
  user.domain = "LTER", 
  package.id = "edi.473.1"
)
