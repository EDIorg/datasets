# This script executes an EMLassemblyline workflow.

# Initialize workspace --------------------------------------------------------

path_templates <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_696\\metadata_templates"
path_data <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_696\\data_objects"
path_eml <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_696\\eml"

# Create metadata templates ---------------------------------------------------

EMLassemblyline::template_core_metadata(
  path = path_templates,
  license = "CC0",
  file.type = ".docx")

EMLassemblyline::template_table_attributes(
  path = path_templates,
  data.path = path_data,
  data.table = c("BBWMenzymesopen.csv"))

EMLassemblyline::template_categorical_variables(
  path = path_templates, 
  data.path = path_data)

# Make EML from metadata templates --------------------------------------------

EMLassemblyline::make_eml(
  path = path_templates,
  data.path = path_data,
  eml.path = path_eml, 
  dataset.title = "Soil extracellular enzyme activities in plots dominated by trees that associate with arbuscular mycorrhizal or ectomycorrhizal fungi in the N fertilized and reference watershed at the Bear Brook Watershed in Maine, USA.", 
  temporal.coverage = c("2017-05-01", "2017-09-30"), 
  geographic.description = "Bear Brook Watershed in Maine", 
  geographic.coordinates = c("44.861781", "-68.106971", "44.861781", "-68.106971"), 
  maintenance.description = "Completed: No updates are expected to these data", 
  data.table = c("BBWMenzymesopen.csv"), 
  data.table.name = c("Bear Brook soil enzyme activities "),
  data.table.description = c("Soil extracellular enzyme activities in AM and ECM dominated plots in the N fertilized and reference Watershed at Bear Brook Watershed in Maine USA as measured in 2016."),
  user.id = "csmith",
  user.domain = "EDI", 
  package.id = "edi.696.1")
