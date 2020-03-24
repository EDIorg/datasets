# This script executes an EMLassemblyline workflow.

# Package ID in staging = 342
# Package ID in production = 474

# Initialize workspace --------------------------------------------------------

setwd("C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_474")

library(EMLassemblyline)

path = "./metadata_templates"
data.path = "./data_objects"
eml.path = "./eml"
data.table <- "PLFA.csv"

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
  dataset.title = "Phospholipid Fatty Acid Profiles of Bacteria and Fungi in Poor Fen Peat Exposed to Experimentally Increased N Deposition, 2015", 
  temporal.coverage = c("2015-07-01", "2015-07-31"), 
  geographic.description = "Alberta, Canada, 100 km south of Fort McMurray, Canada", 
  geographic.coordinates = c("55.897", "-112.094", "55.897", "-112.094"), 
  maintenance.description = "Complete", 
  data.table = data.table,
  data.table.name = c("Net N Mineralization"),
  data.table.description = c("Net N Mineralization"),
  user.id = "csmith",
  user.domain = "LTER", 
  package.id = "edi.474.1"
)
