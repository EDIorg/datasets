# This script executes an EMLassemblyline workflow.

# Initialize workspace --------------------------------------------------------

library(EMLassemblyline)

# Define paths for your metadata templates, data, and EML

path_templates <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_682\\metadata_templates"
path_data <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_682\\data_objects"
path_eml <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_682\\eml"

# Create metadata templates ---------------------------------------------------

EMLassemblyline::template_core_metadata(
  path = path_templates,
  license = "CC0",
  file.type = ".docx")

EMLassemblyline::template_table_attributes(
  path = path_templates,
  data.path = path_data,
  data.table = c("Keswick Reservoir Tw Profile Data 2017-19.csv"))

# Make EML from metadata templates --------------------------------------------

# Once all your metadata templates are complete call this function to create 
# the EML.

EMLassemblyline::make_eml(
  path = path_templates,
  data.path = path_data,
  eml.path = path_eml, 
  dataset.title = "Keswick Reservoir Temperature Profile Data (2017-2019)", 
  temporal.coverage = c("2017-09-06", "2019-12-31"), 
  geographic.description = "Temperature profile data was collected upstream of Keswick Dam", 
  geographic.coordinates = c("40.6139", "-122.4455", "40.6139", "-122.4455"), 
  maintenance.description = "Ongoing: Periodic updates of these data are expected", 
  data.table = c("Keswick Reservoir Tw Profile Data 2017-19.csv"), 
  data.table.description = c("This data table includes Keswick Reservoir temperature profile data above Keswick Dam that were collected seasonally over three years (2017-2019)."),
  other.entity = c("Keswick Reservoir Tw Monitoring 2017-2019.pdf"),
  other.entity.description = c("Keswick Reservoir Tw Monitoring Methods"),
  user.id = "csmith",
  user.domain = "EDI", 
  package.id = "edi.117.2")
