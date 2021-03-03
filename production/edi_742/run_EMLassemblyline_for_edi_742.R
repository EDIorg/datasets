# This script executes an EMLassemblyline workflow.

# Initialize workspace --------------------------------------------------------

path_templates <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_742\\metadata_templates"
path_data <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_742\\data_objects"
path_eml <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_742\\eml"

# Create metadata templates ---------------------------------------------------


EMLassemblyline::template_core_metadata(
  path = path_templates,
  license = "CC0",
  file.type = ".docx")

EMLassemblyline::template_table_attributes(
  path = path_templates,
  data.path = path_data,
  data.table = c("beetle_processed.csv",
                 "fish_processed.csv",
                 "macroinv_processed.csv",
                 "mammal_processed.csv"))

EMLassemblyline::template_categorical_variables(
  path = path_templates, 
  data.path = path_data)

EMLassemblyline::template_taxonomic_coverage(path = path_templates, empty = TRUE)
beetles <- data.table::fread(paste0(path_data, "/beetle_processed.csv"))
fish <- data.table::fread(paste0(path_data, "/fish_processed.csv"))
inverts <- data.table::fread(paste0(path_data, "/macroinv_processed.csv"))
mammals <- data.table::fread(paste0(path_data, "/mammal_processed.csv"))

taxcov <- data.frame(
  name = c(unique(beetles$scientificName), unique(fish$scientificName), 
           unique(inverts$scientificName), unique(mammals$scientificName)),
  name_type = "scientific",
  name_resolved = c(unique(beetles$scientificName), unique(fish$scientificName), 
                    unique(inverts$scientificName), unique(mammals$scientificName)),
  authority_system = NA_character_,
  authority_id = NA_character_,
  stringsAsFactors = F)

utils::write.table(
  taxcov,
  paste0(path_templates, "/", "taxonomic_coverage.txt"),
  sep = "\t",
  row.names = F,
  quote = F,
  fileEncoding = "UTF-8")


# Make EML from metadata templates --------------------------------------------

EMLassemblyline::make_eml(
  path = path_templates,
  data.path = path_data,
  eml.path = path_eml, 
  dataset.title = "temporalNEON: Repository containing raw and cleaned-up organismal data from the National Ecological Observatory Network (NEON) useful for evaluating the links between change in biodiversity and ecosystem stability", 
  temporal.coverage = c("2013-06-19", "2019-11-21"), 
  geographic.description = "USA", 
  geographic.coordinates = c("48.0", "-70.0", "28.0", "-123.0"), 
  maintenance.description = "Completed: No updates to these data are expected", 
  data.table = c("beetle_processed.csv",
                 "fish_processed.csv",
                 "macroinv_processed.csv",
                 "mammal_processed.csv"),
  data.table.description = c("abundance records for ground beetles",
                             "abundance records for fish",
                             "abundance records for freshwater macroinvertebrates",
                             "abundance records for small mammals"),
  data.table.quote.character = c('"', '"', '"', '"'),
  other.entity = c("beetle_raw.rds",
                   "fish_raw.rds",
                   "macroinvert_raw.rds",
                   "mammal_raw.rds",
                   "00_data_processing.R"),
  other.entity.description = c("Data object containing NEON data for ground beetles",
                               "Data object containing NEON data for fish",
                               "Data object containing NEON data for macro invertebrates",
                               "Data object containing NEON data for small mammals",
                               "R code used to process these 'raw' organismal data"),
  user.id = "csmith",
  user.domain = "EDI", 
  package.id = "edi.742.1")


x <- template_arguments(path = path_templates)
View(x$x)
