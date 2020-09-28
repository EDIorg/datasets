# This script executes an EMLassemblyline workflow.

# Initialize workspace --------------------------------------------------------

library(EMLassemblyline)

path_templates <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_616\\metadata_templates"
path_data <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_616\\data_objects"
path_eml <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_616\\eml"

# Create metadata templates ---------------------------------------------------

EMLassemblyline::template_core_metadata(
  path = path_templates,
  license = "CCBY",
  file.type = ".docx")

EMLassemblyline::template_table_attributes(
  path = path_templates,
  data.path = path_data,
  data.table = c("Nugent_et_al_MS3_data.csv"))

EMLassemblyline::template_categorical_variables(
  path = path_templates, 
  data.path = path_data)

# Make EML from metadata templates --------------------------------------------

# Once all your metadata templates are complete call this function to create 
# the EML.

EMLassemblyline::make_eml(
  path = path_templates,
  data.path = path_data,
  eml.path = path_eml, 
  dataset.title = "Post-extraction restored peatland methane production and emission", 
  temporal.coverage = c("2016-04-01", "2016-10-31"), 
  geographic.description = "Southeast Quebec, Canada", 
  geographic.coordinates = c("47.967208", "-69.428639", "47.967208", "-69.428639"), 
  maintenance.description = "Data collection is complete. No updates are expected.", 
  data.table = c("Nugent_et_al_MS3_data.csv"), 
  data.table.name = c("Dataset 1"),
  data.table.description = c("Dataset 1"),
  user.id = "csmith",
  user.domain = "LTER", 
  package.id = "edi.616.1")
