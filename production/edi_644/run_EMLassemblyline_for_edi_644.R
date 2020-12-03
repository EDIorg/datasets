# This script executes an EMLassemblyline workflow.

# Initialize workspace --------------------------------------------------------

library(EMLassemblyline)
library(taxonomyCleanr)

path_templates <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_644\\metadata_templates"
path_data <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_644\\data_objects"
path_eml <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_644\\eml"

# Create metadata templates ---------------------------------------------------

EMLassemblyline::template_core_metadata(
  path = path_templates,
  license = "CCBY",
  file.type = ".docx")

EMLassemblyline::template_table_attributes(
  path = path_templates,
  data.path = path_data,
  data.table = c("bnut.csv"))

EMLassemblyline::template_categorical_variables(
  path = path_templates, 
  data.path = path_data)

# Make EML from metadata templates --------------------------------------------

EMLassemblyline::make_eml(
  path = path_templates,
  data.path = path_data,
  eml.path = path_eml, 
  dataset.title = "Brazil nut fruit production and growth from two sites in Acre, Brazil 2010-2019", 
  temporal.coverage = c("2010-02-01", "2019-02-01"), 
  geographic.description = "The Filipinas study site was located in one unlogged 420-ha extractivist landholding in the southeastern portion of Extractive Reserve Chico Mendes (Colocação Rio de Janeiro in Seringal Filipinas). The Reserve maintains 92% forest cover. Filipinas is dominated by open forest with bamboo and/or palms, with a small area classified as dense forest 2. Our second study site was located in the Chico Mendes Agro-Extractive Settlement Project (informally known as Cachoeira), which maintains 90% forest cover. This site shares similar forest types as Filipinas, but in different proportions. Cachoeira is dominated by dense forest with a smaller area classified as open forest with bamboo and/or palms", 
  geographic.coordinates = c("-10.82", "-68.38", "-10.84", "-68.67"), 
  maintenance.description = "Ongoing: Updates to these data are expected", 
  data.table = c("bnut.csv"), 
  data.table.name = c("Brazil nut"),
  data.table.description = c("Study data"),
  user.id = "csmith",
  user.domain = "LTER", 
  package.id = "edi.644.1")
