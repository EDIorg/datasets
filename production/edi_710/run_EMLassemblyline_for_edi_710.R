# This script executes an EMLassemblyline workflow.

# Initialize workspace --------------------------------------------------------

library(EMLassemblyline)
library(taxonomyCleanr)

# Define paths for your metadata templates, data, and EML

path_templates <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_710\\metadata_templates"
path_data <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_710\\data_objects"
path_eml <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_710\\eml"
data_tables <- c(
  "Resin_Deposition_Data_WBEA.csv",
  "Veg_CNS_Data_WBEA.csv",
  "Water_Chem_Data_WBEA.csv")

# Create metadata templates ---------------------------------------------------

template_core_metadata(
  path = "./metadata_templates/",
  license = "CC0", 
  file.type = ".docx")

EMLassemblyline::template_table_attributes(
  path = path_templates,
  data.path = path_data,
  data.table = data_tables)

EMLassemblyline::template_categorical_variables(
  path = path_templates, 
  data.path = path_data)

EMLassemblyline::template_geographic_coverage(
  path = path_templates, 
  empty = T)

r <- taxonomyCleanr::resolve_sci_taxa(
  x = c(
    "Cladonia mitis",
    "Evernia mesomorpha",
    "Rhododendron groenlanicum",
    "Vaccinium oxycoccos",
    "Picea mariana",
    "Rubus chamaemorus",
    "Maianthemum trifolia",
    "Sphagnum capillifolium",
    "Sphagnum fuscum",
    "Vaccinium vitis-idaea"),
  data.sources = 3)

make_taxonomicCoverage(
  path = path_templates, 
  taxa.clean = r$taxa_clean,
  rank = r$rank,
  authority = r$authority,
  authority.id = r$authority_id)

# Make EML from metadata templates --------------------------------------------

EMLassemblyline::make_eml(
  path = path_templates,
  data.path = path_data,
  eml.path = path_eml, 
  dataset.title = "Long-term monitoring of peatlands located near oil sands mining activities surrounding Fort McMurray, Alberta, Canada", 
  temporal.coverage = c("2009-05-23", "2016-10-11"),
  maintenance.description = "Ongoing", 
  data.table = data_tables, 
  data.table.name = c(
    "Resin Deposition Data",
    "Veg CNS Data",
    "Water Chem Data"),
  data.table.description = c(
    "Resin Deposition Data",
    "Veg CNS Data",
    "Water Chem Data"),
  user.id = "csmith",
  user.domain = "LTER", 
  package.id = "edi.710.1")
