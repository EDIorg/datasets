# This script executes an EMLassemblyline workflow.

# Data package identifier in staging = edi.323
# Data package identifier in production = edi.444

# Initialize workspace --------------------------------------------------------

rm(list = ls())
library(EMLassemblyline)
library(taxonomyCleanr)
setwd("/Users/csmith/Documents/EDI/datasets/edi_444")

# Align taxonomic entities ----------------------------------------------------

df <- taxonomyCleanr::resolve_sci_taxa(
  x = c(
    "Acer rubrum",
    "Acer saccharum",
    "Aesculus flava",
    "Amelanchier arborea",
    "Carya cordiformis",
    "Carya glabra",
    "Carya ovata",
    "Carya tomentosa",
    "Cercis Canadensis",
    "Cornus florida",
    "Fagus grandifolia",
    "Fraxinus Americana",
    "Juglans nigra",
    "Liriodendron tulipifera",
    "Nyssa sylvatica",
    "Ostrya virginiana",
    "Oxydendrum arboretum",
    "Pinus resinosa",
    "Populus grandidentata",
    "Prunus serotine",
    "Quercus alba",
    "Quercus coccinea",
    "Quercus prinus",
    "Quercus rubra",
    "Quercus velutina",
    "Sassafras albidum",
    "Tilia Americana",
    "Ulmus rubra"
  ),
  data.sources = 3
)

taxonomyCleanr::make_taxonomicCoverage(
  taxa.clean = df$taxa_clean,
  authority = df$authority,
  authority.id = df$authority_id,
  path = "./metadata_templates"
)

# Create metadata templates ---------------------------------------------------

EMLassemblyline::template_core_metadata(
  path = "./metadata_templates", 
  license = "CC0", 
  file.type = ".docx"
)

EMLassemblyline::template_table_attributes(
  path = "./metadata_templates", 
  data.path = "./data_objects", 
  data.table = c(
    "Soil_Data_DeForest.csv",
    "Tree_Data_DeForest.csv"
  )
)

EMLassemblyline::template_categorical_variables(
  path = "./metadata_templates",
  data.path = "./data_objects"
)

EMLassemblyline::template_geographic_coverage(
  path = "./metadata_templates",
  empty = TRUE
)

# Make EML --------------------------------------------------------------------

EMLassemblyline::make_eml(
  path = "./metadata_templates",
  data.path = "./data_objects",
  eml.path = "./eml",
  dataset.title = "Data and R code for “Tree growth response to shifting soil nutrient economy depends on mycorrhizal associations”, New Phytologist, 2019.", 
  temporal.coverage = c(
    "2010-01-01", 
    "2018-01-01"
  ), 
  maintenance.description = "Complete",
  data.table = c(
    "Soil_Data_DeForest.csv",
    "Tree_Data_DeForest.csv"
  ), 
  data.table.description = c(
    "Soil data",
    "Tree data"
  ), 
  other.entity = "DeForest_Snell_newPhyt_2019.R",
  other.entity.description = "All the statistical code used for the publication", 
  user.id = "csmith",
  user.domain = "LTER", 
  package.id = "edi.444.1"
)
