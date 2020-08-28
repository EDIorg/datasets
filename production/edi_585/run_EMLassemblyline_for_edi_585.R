# This script executes an EMLassemblyline workflow.

# Initialize workspace --------------------------------------------------------

# Update EMLassemblyline and load

remotes::install_github("EDIorg/EMLassemblyline")
library(EMLassemblyline)
library(taxonomyCleanr)

# Define paths for your metadata templates, data, and EML

path_templates <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_585\\metadata_templates"
path_data <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_585\\data_objects"
path_eml <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_585\\eml"

# Create metadata templates ---------------------------------------------------

EMLassemblyline::template_core_metadata(
  path = path_templates,
  license = "CC0",
  file.type = ".docx")

EMLassemblyline::template_table_attributes(
  path = path_templates,
  data.path = path_data,
  data.table = c("vonHolle_etal_AoB_Plants.csv"))

EMLassemblyline::template_categorical_variables(
  path = path_templates, 
  data.path = path_data)

EMLassemblyline::template_geographic_coverage(
  path = path_templates, 
  empty = TRUE)

r <- taxonomyCleanr::resolve_sci_taxa(
  x = c("Eugenia foetida", "Eugenia axillaris", "Eugenia uniflora"),
  data.sources = 3)

taxonomyCleanr::make_taxonomicCoverage(
  taxa.clean = r$taxa_clean,
  authority = r$authority,
  authority.id = r$authority_id,
  path = path_templates)

# Make EML from metadata templates --------------------------------------------

EMLassemblyline::make_eml(
  path = path_templates,
  data.path = path_data,
  eml.path = path_eml, 
  dataset.title = "Total biomass of two native and one nonnative Eugenia congeners from growth chamber experiment with site, soil microbe, and temperature treatments to test biotic interaction effects of range expansion.", 
  temporal.coverage = c("2011-12-17", "2012-12-06"), 
  maintenance.description = "Data collection is complete. No updates to these data are expected.", 
  data.table = c("vonHolle_etal_AoB_Plants.csv"), 
  data.table.name = c("Study data"),
  data.table.description = c("Eugenia biomass"),
  user.id = "csmith",
  user.domain = "EDI", 
  package.id = "edi.585.1")
