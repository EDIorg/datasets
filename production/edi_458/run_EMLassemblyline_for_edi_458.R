# This script executes an EMLassemblyline workflow.

# Staging ID = edi.329
# Production ID = edi.458

# Initialize workspace --------------------------------------------------------

library(dataCleanr)
library(data.table)
library(EMLassemblyline)

path <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_458\\metadata_templates"
data_path <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_458\\data_objects"
eml_path <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_458\\eml"

# Inspect data ----------------------------------------------------------------

df <- data.table::fread("C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_458\\data_objects/EMP_Discrete_Water_Quality_Stations_1975-2020.csv")

use_i <- is.na(as.numeric(df$Latitude))
unique(df$Latitude[use_i])

# Create metadata templates ---------------------------------------------------

EMLassemblyline::template_core_metadata(
  path = path, 
  license = "CCBY",
  file.type = ".docx")

EMLassemblyline::template_table_attributes(
  path = path,
  data.path = data_path,
  data.table = c("SACSJ_delta_water_quality_1975_2019.csv",
                 "EMP_Discrete_Water_Quality_Stations_1975-2019.csv"))

EMLassemblyline::template_categorical_variables(
  path = path,
  data.path = data_path)

# Create EML ------------------------------------------------------------------

EMLassemblyline::make_eml(
  path = path,
  data.path = data_path,
  eml.path = eml_path,
  dataset.title = "Interagency Ecological Program: Discrete water quality monitoring in the Sacramento-San Joaquin Bay-Delta, collected by the Environmental Monitoring Program, 1975-2020.", 
  temporal.coverage = c("1975-01-07", "2020-12-04"),
  geographic.description = "San Pablo Bay to the eastern Sacramento-San Joaquin Delta",
  geographic.coordinates = c("38.369", "-121.262", "37.678", "-122.393"), 
  maintenance.description = "Ongoing: Updates to these data are expected", 
  data.table = c("SACSJ_delta_water_quality_1975_2020.csv",
    "EMP_Discrete_Water_Quality_Stations_1975-2020.csv"),
  data.table.description = c(
    "Water quality data from the California Bay-Delta watershed",
    "Sampling station coordinates"), 
  data.table.quote.character = c("\"", "\""),
  other.entity = "IEP_EMP_DWQN_metadata_methods.pdf",
  other.entity.name = "Methods tables",
  other.entity.description = "Methods tables",
  user.id = c("csmith", "iep"),
  user.domain = c("EDI", "EDI"), 
  package.id = "edi.90.6")
