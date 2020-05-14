# This script executes an EMLassemblyline workflow.

# Initialize workspace --------------------------------------------------------

rm(list = ls())
library(EMLassemblyline)
library(taxonomyCleanr)

# Create metadata templates ---------------------------------------------------

EMLassemblyline::template_core_metadata(
  path = "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_513/metadata_templates", 
  license = "CCBY", 
  file.type = ".docx")

EMLassemblyline::template_table_attributes(
  path = "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_513/metadata_templates", 
  data.path = "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_513/data_objects", 
  data.table = c(
    "fish_counts.csv",
    "fish_lengths.csv",
    "habitat_data.csv", 
    "richness_matrix.csv",
    "reserve_features.csv",
    "weight_length.csv"))

EMLassemblyline::template_categorical_variables(
  path = "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_513/metadata_templates",
  data.path = "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_513/data_objects")

tax <- taxonomyCleanr::resolve_sci_taxa(
  x = c(
    "Bangana devdevi",
    "Barilius ornatus",
    "Chagunius baileyi",
    "Channa harcourtbutleri",
    "Channa striata",
    "Crossocheilus burmanicus",
    "Danio albolineatus",
    "Devario",
    "Folifer brevifilis",
    "Garra nasuta",
    "Glyptothorax",
    "Hampala salweenensis",
    "Hemibagrus microphthalmus",
    "Homaloptera",
    "Hypsibarbus salweenensis",
    "Labeo rohita",
    "Mastacembelus armatus",
    "Mystacoleucus argenteus ",
    "nemacheiline loach",
    "Neolissochilus stracheyi",
    "Notopterus notopterus",
    "Parambassis vollmeri",
    "Puntius",
    "Rasbora daniconius",
    "Raiamas guttatus",
    "Scaphiodonichthys burmanicus",
    "Sperata acicularis",
    "Systomus rubripinnus",
    "Tor"), 
  data.sources = c(3,9))

taxonomyCleanr::make_taxonomicCoverage(
  taxa.clean = tax$taxa_clean,
  rank = tax$rank,
  authority = tax$authority, 
  authority.id = tax$authority_id,
  path = "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_513/metadata_templates")


# Make EML --------------------------------------------------------------------

EMLassemblyline::make_eml(
  path = "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_513/metadata_templates",
  data.path = "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_513/data_objects", 
  eml.path = "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_513/eml",
  dataset.title = "Fish richness, density, and biomass data for a network of community-based no-take reserves in northern Thailand.",
  temporal.coverage = c("2018-01-01", "2018-04-01"), 
  geographic.description = "Northwestern Thailand, Sop Moei District, Mae Hong Son Province, Thailand",
  geographic.coordinates = c("17.864758", "98.167804", "17.636179", "97.956861"), 
  maintenance.description = "Complete",
  data.table = c(
    "fish_counts.csv",
    "fish_lengths.csv",
    "habitat_data.csv", 
    "richness_matrix.csv",
    "reserve_features.csv",
    "weight_length.csv"),
  data.table.name = c(
    "Fish counts",
    "Fish lengths",
    "Habitat data", 
    "Richness matrix",
    "Reserve features",
    "Weight length"),
  data.table.description = c(
    "This file contains the count totals made by two observers at 23 study locations (site.id). Observers (obs) counted fish inside community-based no-take reserves (res = Y) and outside no-take reserves (res = N). There were two replicate surveys (rep) conducted by both observers inside and outside of reserves.",
    "This table contains the length estimates for fish by species at each reserve or non-reserve site.",
    "This file contains habitat variables measured at fish survey locations. Data were used to compare potential habitat differences among reserve and non-reserve sites as well as providing general habitat descriptive data for the study.", 
    "This file contains the presence absence matrix used to analyze richness effects of no-take reserves. This table was constructed to simplify interpretation of richness counts. In the fish_counts.csv file, the categorization of YOY.ns, or young-of-year Neolisshochilus stracheyi made straightforward richness calculation in R impossible, as it could result in double counting of species. This matrix provides the data to calculate richness without this underlying issue.",
    "This file contains the predictor variables to determine reserve responses for fish species richness, density, and biomass.",
    "This file contains the weight-length relationships used to convert species-specific length estimates to biomass."), 
  user.id = "csmith",
  user.domain = "EDI",
  package.id = "edi.513.1")
