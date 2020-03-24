# This script executes an EMLassemblyline workflow.

# Package ID in staging = 347
# Package ID in production = 479

# Initialize workspace --------------------------------------------------------

setwd("C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_479")

library(EMLassemblyline)

path = "./metadata_templates"
data.path = "./data_objects"
eml.path = "./eml"
data.table <- "Vascular_Plant_N_concentrations.csv"

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
  dataset.title = "Peatland Vascular Plant Leaf N Concentrations (5 species) From Leaves collected from N-Addition plots in an Alberta Poor Fen, 2011-2015", 
  temporal.coverage = c("2011-07-01", "2015-07-31"), 
  geographic.description = "Alberta, Canada, 100 km south of Fort McMurray, Canada", 
  geographic.coordinates = c("55.897", "-112.094", "55.897", "-112.094"), 
  maintenance.description = "Complete",
  data.table = data.table,
  data.table.name = "Vascular Plant N concentrations",
  data.table.description = "Vascular Plant N concentrations",
  user.id = "csmith",
  user.domain = "LTER", 
  package.id = "edi.479.1"
)
