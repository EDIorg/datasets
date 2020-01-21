# This script executes an EMLassemblyline workflow.

# Staging identifier = edi.333
# Production identifier = edi.460

# Initialize workspace --------------------------------------------------------

rm(list = ls())
setwd("/Users/csmith/Documents/EDI/datasets/edi_460")

library(data.table)
library(EMLassemblyline)
library(taxonomyCleanr)

# Inspect data ----------------------------------------------------------------

df <- data.table::fread(
  file = "./data_objects/PAAG_data_veg_experimental_2014_2019.csv"
)

# Create metadata templates ---------------------------------------------------

EMLassemblyline::template_core_metadata(
  path = "./metadata_templates",
  license = "CCBY", 
  file.type = ".docx"
)

EMLassemblyline::template_table_attributes(
  path = "./metadata_templates",
  data.path = "./data_objects",
  data.table = "PAAG_data_veg_experimental_2014_2019.csv"
)

EMLassemblyline::template_categorical_variables(
  path = "./metadata_templates",
  data.path = "./data_objects"
)

# Resolve taxonomic data to authority -----------------------------------------

t <- taxonomyCleanr::resolve_sci_taxa(
  x = c(
    "Littoraria irrorata",
    "Uca spp.",
    "Avicennia germinans",
    "Spartina alterniflora", 
    "Batis maritima",
    "Salicornia spp",
    "Suaeda linearis",
    "Sesuvium portulcastrum",
    "Lycium carolinianum"
  ), 
  data.sources = 3
)

taxonomyCleanr::make_taxonomicCoverage(
  path = "./metadata_templates",
  taxa.clean = t$taxa_clean,
  authority = t$authority, 
  authority.id = t$authority_id
)

# Create EML metadata ---------------------------------------------------------

EMLassemblyline::make_eml(
  path = "./metadata_templates",
  data.path = "./data_objects",
  eml.path = "./eml",
  dataset.title = "Hurricane Harvey: Coastal wetland plant responses and recovery in Texas: 2014-2019", 
  temporal.coverage = c("2014-08-01", "2019-09-30"), 
  geographic.description = "Tidal wetland on Harbor Island, Port Aransas, TX. The study encompasses an area of black mangrove (Avicennia germinans) and marsh (Batis maritima, Salicornia spp., Spartina alterniflora) cover.",
  geographic.coordinates = c(
    "27.869922",
    "-97.052633",
    "27.860224",
    "-97.057103"
  ), 
  maintenance.description = "Ongoing", 
  data.table = "PAAG_data_veg_experimental_2014_2019.csv", 
  data.table.description = "Coastal wetland plant responses", 
  user.id = "csmith",
  user.domain = "LTER",
  package.id = "edi.460.1"
)










