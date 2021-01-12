# This script executes an EMLassemblyline workflow.

# Production data package identifier = edi.468
# Staging data package identifier = edi.338

# Initialize workspace --------------------------------------------------------

library(EMLassemblyline)

setwd("C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_468")

# Clean up Sampling_sites.csv -------------------------------------------------

# Convert degrees, minutes, seconds to decimal degrees

df <- data.table::fread("./data_objects/Sampling_sites_raw.csv")

df$Longitude_E <- biogeo::dms2dd(
  dd = as.numeric(stringr::str_extract(df$Longitude_E, "^[:digit:]*")),
  mm = as.numeric(stringr::str_extract(df$Longitude_E, "[:digit:]*(?=[:punct:])")),
  ss = as.numeric(stringr::str_extract(df$Longitude_E, "[:digit:]*(?=\")")),
  ns = rep("E", length(ss))
)

df$Latitude_N <- biogeo::dms2dd(
  dd = as.numeric(stringr::str_extract(df$Latitude_N, "^[:digit:]*")),
  mm = as.numeric(stringr::str_extract(df$Latitude_N, "[:digit:]*(?=[:punct:])")),
  ss = as.numeric(stringr::str_extract(df$Latitude_N, "[:digit:]*(?=\")")),
  ns = rep("E", length(ss))
)

data.table::fwrite(
  x = df, 
  file = "./data_objects/Sampling_sites.csv", 
  sep = ","
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
  data.table = c("Methane_dataset_for_EQTP_waterways.csv", "Sampling_sites.csv")
)

EMLassemblyline::template_categorical_variables(
  path = "./metadata_templates",
  data.path = "./data_objects"
)

# Create EML metadata ---------------------------------------------------------

EMLassemblyline::make_eml(
  path = "./metadata_templates",
  data.path = "./data_objects", 
  eml.path = "./eml",
  dataset.title = "A dataset for methane concentrations and fluxes for alpine permafrost streams and rivers on the East Qinghai-Tibet Plateau", 
  temporal.coverage = c("2016-01-01", "2018-01-01"), 
  geographic.description = "The Qinghai-Tibet Plateau, or 'Third Pole' of the Earth, with an average elevation of over 4000 m, is the cradle of ten large Asian rivers and the largest cryosphere outside the Arctic and Antarctic.", 
  geographic.coordinates = c("36", "105", "28", "90"), 
  maintenance.description = "Completed", 
  data.table = c("Methane_dataset_for_East_Qinghai_Tibet_Plateau_waterways.csv", "Sampling_sites.csv"),
  data.table.name = c("Methane dataset for East Qinghai-Tibet Plateau waterways", "Sampling sites"),
  data.table.description = c("Methane dataset for East Qinghai-Tibet Plateau waterways", "Sampling site coordinates and descriptions"), 
  other.entity = "Monte_Carlo_Simulation_for_Zhang_et_al_2020.zip",
  other.entity.name = "Monte Carlo Simulation for Zhang et al 2020",
  other.entity.description = "Monte Carlo Simulation for the paper Zhang et al 2020", 
  user.id = "csmith", 
  user.domain = "LTER", 
  package.id = "edi.468.2"
)
