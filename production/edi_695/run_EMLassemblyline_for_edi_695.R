# This script executes an EMLassemblyline workflow.

# Initialize workspace --------------------------------------------------------

path_templates <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_695\\metadata_templates"
path_data <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_695\\data_objects"
path_eml <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_695\\eml"

# Create metadata templates ---------------------------------------------------

EMLassemblyline::template_core_metadata(
  path = path_templates,
  license = "CCBY",
  file.type = ".docx")

EMLassemblyline::template_table_attributes(
  path = path_templates,
  data.path = path_data,
  data.table = c("Nitrous oxide dataset for East Qinghai-Tibet Plateau waterways.csv"))

# Make EML from metadata templates --------------------------------------------

# Once all your metadata templates are complete call this function to create 
# the EML.

EMLassemblyline::make_eml(
  path = path_templates,
  data.path = path_data,
  eml.path = path_eml, 
  dataset.title = "Nitrous oxide dataset for East Qinghai-Tibet Plateau waterways", 
  temporal.coverage = c("2016", "2018"), 
  geographic.description = "The Qinghai-Tibet Plateau, or ‘Third Pole’ of the Earth, with an average elevation of over 4000 m, is the cradle of ten large Asian rivers and the largest cryosphere outside the Arctic and Antarctic.", 
  geographic.coordinates = c("36", "105", "28", "90"), 
  maintenance.description = "Completed: Updates to these data are not expected", 
  data.table = c("Nitrous_oxide_dataset_for_East_Qinghai_Tibet_Plateau_waterways.csv"), 
  data.table.name = c("Nitrous oxide dataset for East Qinghai-Tibet Plateau waterways"),
  data.table.description = c("Nitrous oxide dataset for East Qinghai-Tibet Plateau waterways"),
  other.entity = c("Monte_Carlo_Simulation_and_regression_tree_Zhang_et_al_2021.zip",
                   "Basins.pdf"),
  other.entity.name = c("Monte Carlo Simulation and regression tree-Zhang et al 2021",
                        "Geographic coordinates of sampling sites"),
  other.entity.description = c("The MATLAB code is used for regional N2O upscaling and regression tree analysis",
                               "Geographic coordinates of sampling sites"),
  user.id = "csmith",
  user.domain = "EDI",
  package.id = "edi.695.1")
