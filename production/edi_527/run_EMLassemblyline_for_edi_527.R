# This script executes an EMLassemblyline workflow.

# Initialize workspace --------------------------------------------------------

rm(list = ls())
library(EMLassemblyline)
library(taxonomyCleanr)

# Define paths for your metadata templates, data, and EML

path_templates <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_527\\metadata_templates"
path_data <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_527\\data_objects"
path_eml <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_527\\eml"

# Inspect data ----------------------------------------------------------------

d <- data.table::fread(paste0(path_data, "/SKT_Catch.csv"))

# Create metadata templates ---------------------------------------------------

EMLassemblyline::template_core_metadata(
  path = path_templates,
  license = "CCBY",
  file.type = ".docx")

EMLassemblyline::template_table_attributes(
  path = path_templates,
  data.path = path_data,
  data.table = c("SKT_Catch.csv", "SKT_Stations.csv"))

EMLassemblyline::template_categorical_variables(
  path = path_templates, 
  data.path = path_data)

r <- taxonomyCleanr::resolve_sci_taxa(
  x = c(
  "Clevelandia ios",
  "Lepidogobius lepidus",
  "Percina macrolepida",
  "Lepomis macrochirus",
  "Symphurus atricaudus",
  "Cyprinus carpio",
  "Ictalurus punctatus",
  "Ilypnus gilberti",
  "Oncorhynchus tshawytscha",
  "Hypomesus transpacificus",
  "Parophrys vetulus",
  "Menidia beryllina",
  "Atherinopsis californiensis",
  "Spirinchus thaleichthys",
  "Gillichthys mirabilis",
  "Gambusia affinis",
  "Engraulis mordax",
  "Clupea pallasii",
  "Leptocottus armatus",
  "Porichthys notatus",
  "Cottus asper",
  "Lucania parva",
  "Lepomis microlophus",
  "Catostomus occidentalis",
  "Tridentiger bifasciatus",
  "Tridentiger barbatus",
  "Citharichthys stigmaeus",
  "Pogonichthys macrolepidotus",
  "Micropterus punctulatus",
  "Morone saxatilis",
  "Dorosoma petenense",
  "Gasterosteus aculeatus",
  "Atherinops affinis",
  "Hypomesus nipponensis",
  "Ameiurus catus",
  "Genyonemus lineatus",
  "Acipenser transmontanus",
  "Acanthogobius flavimanus"), 
  data.sources = 3)

taxonomyCleanr::make_taxonomicCoverage(
  path = path_templates,
  taxa.clean = r$taxa_clean,
  rank = r$rank, 
  authority = r$authority, 
  authority.id = r$authority_id)

# Make EML from metadata templates --------------------------------------------

# Once all your metadata templates are complete call this function to create 
# the EML.

EMLassemblyline::make_eml(
  path = path_templates,
  data.path = path_data,
  eml.path = path_eml, 
  dataset.title = "Interagency Ecological Program San Francisco Estuary Spring Kodiak Trawl Survey 2002 - 2020", 
  temporal.coverage = c("2002-01-07", "2020-06-16"), 
  geographic.description = "Lower Napa River, eastern San Pablo Bay, Carquinez Strait upstream throughout Suisun Bay; San Joaquin River to Stockton, Old and Middle Rivers in the south Delta to West Canal; Sacramento River into the Sacramento Deep-water Ship Channel.", 
  geographic.coordinates = c("38.3335", "-121.368556", "37.859", "-122.309278"), 
  maintenance.description = "Ongoing", 
  data.table = c("SKT_Catch.csv", "SKT_Stations.csv"), 
  data.table.name = c("Catch data", "Location data"),
  data.table.description = c(
    "Spring Kodiak Trawl data file contains all historical catch data from 2002 through 2020",
    "Location data"),
  user.id = "csmith",
  user.domain = "LTER", 
  package.id = "edi.527.1")
