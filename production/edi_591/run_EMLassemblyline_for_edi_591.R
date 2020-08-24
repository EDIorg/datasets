# This script executes an EMLassemblyline workflow.

# Initialize workspace --------------------------------------------------------

# Update EMLassemblyline and load

remotes::install_github("EDIorg/EMLassemblyline")
library(EMLassemblyline)

# Define paths for your metadata templates, data, and EML

path_templates <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_591\\metadata_templates"
path_data <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_591\\data_objects"
path_eml <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_591\\eml"

# Diagnose data issues --------------------------------------------------------

f <- paste0(path_data, "/StationSensorMetadata.csv")

d <- data.table::fread(f)

# Create metadata templates ---------------------------------------------------

EMLassemblyline::template_core_metadata(
  path = path_templates,
  license = "CCBY",
  file.type = ".docx")

EMLassemblyline::template_table_attributes(
  path = path_templates,
  data.path = path_data,
  data.table = c("StationSensorMetadata.csv",
                 "StationsMetadata.csv",
                 "Temp_all_H.csv",
                 "Temp_filtered.csv",
                 "Temp_flagged.csv"))

EMLassemblyline::template_categorical_variables(
  path = path_templates, 
  data.path = path_data)

EMLassemblyline::template_geographic_coverage(
  path = path_templates, 
  data.path = path_data, 
  data.table = "StationsMetadata.csv", 
  lat.col = "Latitude",
  lon.col = "Longitude",
  site.col = "StationName")

# Make EML from metadata templates --------------------------------------------

# Once all your metadata templates are complete call this function to create 
# the EML.

EMLassemblyline::make_eml(
  path = path_templates,
  data.path = path_data,
  eml.path = path_eml, 
  dataset.title = "Hourly water temperature from the San Francisco Estuary, 1986 - 2019", 
  temporal.coverage = c("1986-06-13", "2019-12-31"), 
  geographic.description = "San Francisco Estuary", 
  geographic.coordinates = c("38.79356", "-121.1104965", "37.65470", "-122.1404877"), 
  maintenance.description = "Data collection is complete. No updates are expected.", 
  data.table = c("StationSensorMetadata.csv",
                 "StationsMetadata.csv",
                 "Temp_all_H.csv",
                 "Temp_filtered.csv",
                 "Temp_flagged.csv"), 
  data.table.name = c("Water Temperature Sensor Metadata",
                      "Stations Metadata",
                      "Raw Hourly Water Temperature Data from CDEC",
                      "Filtered Hourly Water Temperature Data",
                      "Flagged Hourly Water Temperature Data"),
  data.table.description = c("Metadata regarding water temperature sensors from CDEC stations. Table lists contacts from each monitoring group, and information provided by contacts regarding current and historical sensors used for water temperature monitoring.",
                             "List of stations included in dataset with accompany information regarding start and end date, and station and sensor location.",
                             "Integrated raw water temperature data from CDEC. This data includes hourly data only.",
                             "Integrated water temperature data from CDEC. Each water temperature value was subjected to multiple quality control (QC) tests and marked as either flagged or not flagged for each filter. Values that were flagged under any of the QC filters were removed from this dataset. While values were removed, no values were altered.",
                             "Integrated water temperature data from CDEC. Each water temperature value was subjected to multiple quality control (QC) tests and marked as either flagged or not flagged for each filter. All values and flag results were kept in this dataset, and no values were altered."),
  data.table.quote.character = c("\"",
                                 "\"",
                                 "\"",
                                 "\"",
                                 "\""), 
  data.table.url = c("https://regan.edirepository.org/data/edi_77/StationSensorMetadata.csv",
                     "https://regan.edirepository.org/data/edi_77/StationsMetadata.csv",
                     "https://regan.edirepository.org/data/edi_77/Temp_all_H.csv",
                     "https://regan.edirepository.org/data/edi_77/Temp_filtered.csv",
                     "https://regan.edirepository.org/data/edi_77/Temp_flagged.csv"), 
  other.entity = c("EDI_Metadata_WaterTempSynthesis.pdf",
                   "SummarySheet_WaterTempSynthesis_QCDetail.pdf",
                   "app.R",
                   "Temp_all_H.rds",
                   "DownloadData_CDEC.Rmd",
                   "WaterTemp_QC.Rmd"),
  other.entity.name = c("Water Temperature Synthesis Metadata",
                        "Water Temperature Synthesis Summary Sheet",
                        "Shiny app code",
                        "Raw Hourly Water Temperature Data from CDEC, RDS version",
                        "Download code",
                        "Data cleaning code"),
  other.entity.description = c("PDF version of metadata, including background, methods, and units.",
                               "Summary Sheet describing the water temperature synthesis project and steps used to clean the data.",
                               "Shiny app code, which takes raw hourly data and applies user-specified quality control filters to individual station data, which can then be downloaded with applied flags or filters. ",
                               "Same as Temp_all_H.csv, but in .rds format, which is a compressed format used in R. This file is used as the data source for both the R Shiny app and the QC R code. You could use the .csv to run both of these, but it is slower loading the file.",
                               "Code used to download data from CDEC and convert all forms of data to Celsius hourly data.",
                               "Code used to clean data. See six QC filters described in methods."),
  other.entity.url = c("https://regan.edirepository.org/data/edi_77/EDI_Metadata_WaterTempSynthesis.pdf",
                       "https://regan.edirepository.org/data/edi_77/SummarySheet_WaterTempSynthesis_QCDetail.pdf",
                       "https://regan.edirepository.org/data/edi_77/app.R",
                       "https://regan.edirepository.org/data/edi_77/Temp_all_H.rds",
                       "https://regan.edirepository.org/data/edi_77/DownloadData_CDEC.Rmd",
                       "https://regan.edirepository.org/data/edi_77/WaterTemp_QC.Rmd"),
  user.id = "csmith",
  user.domain = "LTER", 
  package.id = "edi.591.2")
