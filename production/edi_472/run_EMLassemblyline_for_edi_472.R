# This script executes an EMLassemblyline workflow.

# Package ID in staging = 340
# Package ID in production = 472

# Initialize workspace --------------------------------------------------------

setwd("C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_472")

library(EMLassemblyline)

path = "./metadata_templates"
data.path = "./data_objects"
eml.path = "./eml"
data.table <- c(
  "All_Decomp.csv",
  "Cellulose_Decomposition.csv",
  "Vascular_plant_and_Sphagnum_decomp.csv"
)

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
  dataset.title = "Cellulose, Peat, and Mixed Vegetation in situ Decomposition in a Fen Exposed to Increasing Nitrogen Treatments, 2012-2015", 
  temporal.coverage = c("2012-05-01", "2015-10-01"), 
  geographic.description = ".	Alberta, Canada 100 km south of Fort McMurray, Canada", 
  geographic.coordinates = c("55.897", "-112.094", "55.897", "-112.094"), 
  maintenance.description = "Complete", 
  data.table = data.table,
  data.table.name = c(
    "All decomposition", 
    "Cellulose decomposition", 
    "Vascular plant and Sphagnum decomposition"
  ),
  data.table.description = c(
    "All decomposition", 
    "Cellulose decomposition", 
    "Vascular plant and Sphagnum decomposition"
  ),
  user.id = "csmith",
  user.domain = "LTER", 
  package.id = "edi.472.1"
)
