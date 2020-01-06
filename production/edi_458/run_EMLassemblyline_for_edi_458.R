# This script executes an EMLassemblyline workflow.

# Staging ID = edi.329
# Production ID = edi.458

# Initialize workspace --------------------------------------------------------

library(dataCleanr)
library(data.table)
library(EMLassemblyline)

setwd("/Users/csmith/Documents/EDI/datasets/edi_458")

# Inspect data ----------------------------------------------------------------

df <- data.table::fread("./data_objects/SACSJ_delta_water_quality_2000_2018_character.csv")

# Create metadata templates ---------------------------------------------------

EMLassemblyline::template_core_metadata(
  path = "./metadata_templates", 
  license = "CCBY",
  file.type = ".docx"
)

EMLassemblyline::template_table_attributes(
  path = "./metadata_templates",
  data.path = "./data_objects",
  data.table = "SACSJ_delta_water_quality_2000_2018.csv"
)

# Create EML ------------------------------------------------------------------

EMLassemblyline::make_eml(
  path = "./metadata_templates",
  data.path = "./data_objects",
  eml.path = "./eml",
  dataset.title = "Interagency Ecological Program: Discrete water quality monitoring in the Sacramento-San Joaquin Bay-Delta, collected by the Environmental Monitoring Program, 2000-2018.", 
  temporal.coverage = c("2000-01-10", "2018-12-19"),
  geographic.description = "San Pablo Bay to the eastern Sacramento-San Joaquin Delta",
  geographic.coordinates = c("38.369", "121.262", "37.678", "122.393"), 
  maintenance.description = "Ongoing", 
  data.table = "SACSJ_delta_water_quality_2000_2018.csv", 
  data.table.description = "Water quality data from the California Bay-Delta watershed", 
  data.table.quote.character = "\"", 
  user.id = c("csmith", "iep"),
  user.domain = c("LTER", "EDI"), 
  package.id = "edi.458.1"
)






