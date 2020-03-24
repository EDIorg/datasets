# This script executes an EMLassemblyline workflow.

# Package ID in staging = 343
# Package ID in production = 475

# Initialize workspace --------------------------------------------------------

setwd("C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_475")

library(EMLassemblyline)
library(taxonomyCleanr)

path = "./metadata_templates"
data.path = "./data_objects"
eml.path = "./eml"
data.table <- "Point_Frame_Fen.csv"

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

# Resolve taxa to an authority ------------------------------------------------

tx <- taxonomyCleanr::resolve_sci_taxa(
  x = c(
    "Sphagnum fuscum", 
    "Sphagnum magellanicum", 
    "Sphagnum angustifolium", 
    "Sphagnum russowii", 
    "Pohlia nutans", 
    "Mylia anomala", 
    "Andromeda polifolia", 
    "Chamaedaphne calyculata", 
    "Kalmia polifolia", 
    "Vaccinium oxycoccos", 
    "Picea mariana", 
    "Eriophorum vaginatum", 
    "Scheuchzeria palustris",
    "Drosera rotundifolia", 
    "Smilacina trifolia", 
    "Rubus chamaemorus", 
    "Fungi",
    "Maianthemum trifolia", 
    "Carex aquatilis", 
    "Carex limosa"
  ),
  data.sources = 3
)

test <- taxonomyCleanr::make_taxonomicCoverage(
  taxa.clean = tx$taxa_clean, 
  authority = tx$authority, 
  authority.id = tx$authority_id, 
  path = path,
  write.file = TRUE
)

# Create EML ------------------------------------------------------------------

EMLassemblyline::make_eml(
  path = path,
  data.path = data.path,
  eml.path = eml.path, 
  dataset.title = "Point Frame Measurements of Poor Fen Moss and Vascular Frequencies Under Increasing N Deposition Over Five Years, 2011-2015", 
  temporal.coverage = c("2011-07-17", "2015-07-19"), 
  geographic.description = "Alberta, Canada, 100 km south of Fort McMurray, Canada", 
  geographic.coordinates = c("55.897", "-112.094", "55.897", "-112.094"), 
  maintenance.description = "Complete", 
  data.table = data.table,
  data.table.name = c("Point Frame Fen"),
  data.table.description = c("Point Frame Fen"),
  user.id = "csmith",
  user.domain = "LTER", 
  package.id = "edi.475.1"
)
