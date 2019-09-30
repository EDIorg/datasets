# This script executes an EMLassemblyline workflow.

library(remotes)
remotes::install_github("EDIorg/EMLassemblyline")
library(EMLassemblyline)
remotes::install_github("EDIorg/dataCleanr")
library(dataCleanr)
remotes::install_github("EDIorg/taxonomyCleanr")
library(taxonomyCleanr)

setwd("/Users/csmith/Documents/EDI/datasets/edi_435")

# Reformat dates to ISO-8601 standard -----------------------------------------
df <- read.csv(
  file = "./data_objects/GhouseNovInoc2019_LynnETAL.csv", 
  header = TRUE, 
  as.is = TRUE
)
df$date <- dataCleanr::iso8601_convert(
  x = df$date, 
  orders = "mdy"
)
write.csv(
  x = df,
  file = "./data_objects/GhouseNovInoc2019_LynnETAL.csv",
  row.names = FALSE, 
  quote = FALSE
)

# Create taxonomic coverage EML -----------------------------------------------
tf <- taxonomyCleanr::resolve_sci_taxa(
  x = c("Poa alpina", "Festuca brachyphylla", "Elymus scribneri"), 
  data.sources = "3"
)
make_taxonomicCoverage(
  taxa.clean = tf$taxa_clean,
  authority = tf$authority,
  authority.id = tf$authority_id,
  path = "./metadata_templates"
)

# Create metadata templates ---------------------------------------------------
EMLassemblyline::template_core_metadata(
  path = "./metadata_templates",
  license = "CCBY",
  file.type = ".docx"
)

EMLassemblyline::template_table_attributes(
  path = "./metadata_templates", 
  data.path = "./data_objects",
  data.table = "GhouseNovInoc2019_LynnETAL.csv"
)

EMLassemblyline::template_geographic_coverage(
  path = "./metadata_templates",
  empty = TRUE
)

EMLassemblyline::template_categorical_variables(
  path = "./metadata_templates", 
  data.path = "./data_objects"
)

# Make EML --------------------------------------------------------------------
EMLassemblyline::make_eml(
  path = "./metadata_templates",
  data.path = "./data_objects",
  eml.path = "./eml",
  dataset.title = "Data for Lynn et al. “Soil microbes that may accompany climate warming increase alpine plant production”; accepted at Oecologia",
  temporal.coverage = c("2017-09-15", "2018-01-18"),
  maintenance.description = "complete",
  data.table = "GhouseNovInoc2019_LynnETAL.csv",
  data.table.description = "GhouseNovInoc2019_LynnETAL", 
  user.id = "csmith",
  user.domain = "LTER", 
  package.id = "edi.435.1"
)
