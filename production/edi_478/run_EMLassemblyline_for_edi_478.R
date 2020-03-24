# This script executes an EMLassemblyline workflow.

# Package ID in staging = 346
# Package ID in production = 478

# Initialize workspace --------------------------------------------------------

setwd("C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_478")

library(EMLassemblyline)

path = "./metadata_templates"
data.path = "./data_objects"
eml.path = "./eml"
data.table <- "Sphagnum_combined.csv"

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
  dataset.title = "Sphagnum fuscum Growth and N Concentration in an Alberta Poor Fen Subjected to Increasing Nitrogen Deposition, 2011-2015", 
  temporal.coverage = c("2011-05-31", "2015-09-20"), 
  geographic.description = "Alberta, Canada, 100 km south of Fort McMurray, Canada", 
  geographic.coordinates = c("55.897", "-112.094", "55.897", "-112.094"), 
  maintenance.description = "Complete",
  data.table = data.table,
  data.table.name = "Sphagnum combined",
  data.table.description = "Sphagnum combined",
  user.id = "csmith",
  user.domain = "LTER", 
  package.id = "edi.478.1"
)
