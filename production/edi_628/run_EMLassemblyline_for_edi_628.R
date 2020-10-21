# This script executes an EMLassemblyline workflow.

# Initialize workspace --------------------------------------------------------

rm(list = ls())
library(EMLassemblyline)

# Define paths for your metadata templates, data, and EML

path_templates <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_628\\metadata_templates"
path_data <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_628\\data_objects"
path_eml <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_628\\eml"

# Fix tables ------------------------------------------------------------------

# Add quote characters to all character classed fields
d <- data.table::fread(
  paste0(path_data, "/SERDP_Site_Soil_Veg_Database_Field_Descriptions_Metadata.csv"))
data.table::fwrite(
  d,
  paste0(path_data, "/SERDP_Site_Soil_Veg_Database_Field_Descriptions_Metadata_revised.csv"),
  quote = TRUE)

d <- data.table::fread(
  paste0(path_data, "/Tanana_Flats_Fen_Site_Environmental_Data.csv"))
data.table::fwrite(
  d,
  paste0(path_data, "/Tanana_Flats_Fen_Site_Environmental_Data.csv"),
  quote = TRUE)

# Create metadata templates ---------------------------------------------------

EMLassemblyline::template_core_metadata(
  path = path_templates,
  license = "CCBY",
  file.type = ".docx")

EMLassemblyline::template_table_attributes(
  path = path_templates,
  data.path = path_data,
  data.table = c("Tanana_Flats_Fen_Vegetation_Cover_2001_2012.csv",
                 "Fairbanks_Alaska_Climate_Data_2011_to_2016.csv",
                 "Tanana_Flats_Fen_Water_Level_and_Temperature_2011_to_2014.csv",
                 "Tanana_Flats_Fen_Site_Environmental_Data.csv"))

EMLassemblyline::template_categorical_variables(
  path = path_templates, 
  data.path = path_data)

EMLassemblyline::template_geographic_coverage(
  path = path_templates, 
  data.path = path_data,
  empty = TRUE)

# Make EML from metadata templates --------------------------------------------

EMLassemblyline::make_eml(
  path = path_templates,
  data.path = path_data,
  eml.path = path_eml, 
  dataset.title = "Site environmental, climate, water levels and temperatures, vegetation cover, and GIS change detection for assessing permafrost change in fens on the Tanana Flats, central Alaska", 
  temporal.coverage = c("2011-09-25", "2016-05-24"), 
  maintenance.description = "", 
  data.table = c("Fairbanks_Alaska_Climate_Data_2011_to_2016.csv",
                 "Tanana_Flats_Fen_Vegetation_Cover_2001_2012.csv",
                 "Tanana_Flats_Fen_Water_Level_and_Temperature_2011_to_2014.csv",
                 "Tanana_Flats_Fen_Site_Environmental_Data.csv"), 
  data.table.name = c("Fairbanks Climate Data",
                      "Tanana Flats Vegetation Data",
                      "Tanana Flats Water Monitoring",
                      "Tanana Flats Environmental Data"),
  data.table.description = c("Fairbanks Alaska Climate Data 1904-2019",
                             "Tanana Flats Vegetation Cover Data 2002-2012",
                             "Tanana Flats Fen Hourly Water Levels and Temperatures at Six Stations 2011 to 2014",
                             "Tanana Flats Environmental Data"),
  data.table.quote.character = c('"', '"', '"', '"'),
  other.entity = c("Tanana_Flats_Fen_Change_Airphoto_Analysis_GIS_files_2019.zip",
                   "Tanana_Flats_Fen_Change_Airphoto_Analysis_GIS_files_2019_EDI_metadata.pdf",
                   "ELS_Arctic_Boreal_Site_Soil_Veg_Code_Sheet.pdf"),
  other.entity.description = c("Tanana Flats Fen Change Airphoto Analysis 2020",
                               "Metadata for Tanana_Flats_Fen_Change_Airphoto_Analysis_GIS_files_2019.zip",
                               "Coding system for site environmental data fields"),
  user.id = "csmith",
  user.domain = "LTER", 
  package.id = "edi.628.1")
