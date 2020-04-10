# This script executes an EMLassemblyline workflow.

# Staging version = edi.295
# Production version = edi.494

# Parameterize ----------------------------------------------------------------

rm(list = ls())
library(EMLassemblyline)
library(taxonomyCleanr)
setwd("C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_494")

path <- "./metadata_templates"
data_path <- "./data objects"
eml_path <- "./eml"
data_table <- c(
  "Zooplankton_Data.csv", 
  "YB_TaxonomyTable.csv",
  "YB_StationCoordinates.csv")

# Create metadata templates ---------------------------------------------------

template_core_metadata(
  path = path, 
  license = "CCBY", 
  file.type = ".docx")

template_table_attributes(
  path = path, 
  data.path = data_path, 
  data.table = data_table)

r <- resolve_sci_taxa(
  x = c("Annelida", "Arthropoda", "Chordata", "Mollusca", "Rotifera", "Branchiopoda", 
  "Hexanauplia", "Insecta", "Malacostraca",  "Ostracoda", "Pelecypoda", "Amphipoda", 
  "Calanoida", "Cladocera", "Cyclopoida", "Diptera", "Harpacticoida"), 
  data.sources = 3)

tc <- make_taxonomicCoverage(
  taxa.clean = r$taxa_clean, 
  authority = r$authority, 
  authority.id = r$authority_id, 
  path = path)

# Create EML ------------------------------------------------------------------

make_eml(
  path = path,
  data.path = data_path,
  eml.path = eml_path, 
  dataset.title = "Interagency Ecological Program: Zooplankton catch and water quality data from the Sacramento River floodplain and tidal slough, collected by the Yolo Bypass Fish Monitoring Program, 1998-2018.", 
  temporal.coverage = c("1999-03-04", "2018-12-31"), 
  geographic.coordinates = c("38.531881", "-121.527912", "38.531881", "-121.527912"), 
  geographic.description = "Yolo Bypass tidal slough and seasonal floodplain and Sacramento River at Sherwood Harbor in West Sacramento, California, USA.", 
  maintenance.description = "Ongoing", 
  data.table = data_table, 
  data.table.name = c(
    "Zooplankton data",
    "Zooplankton taxonomic tree",
    "Sampling locations"), 
  data.table.description = c(
    "Zooplankton catch and water quality from the Yolo Bypass Fish Monitoring Program",
    "Zooplankton Taxonomic Tree",
    "Zooplankton sampling station locations"), 
  other.entity = c(
    "methods.pdf",
    "Zooplankton_QAQC.Rmd",
    "LTPhysicalData_QAQC.Rmd"), 
  other.entity.name = c(
    "Methods for these data",
    "Zooplankton data QAQC script",
    "LT Physical data QAQC script"),
  other.entity.description = c(
    "Details on field collection methods, sample processing and tracking, quality assurance & control, data storage, calculations and analysis, historical changes.",
    "Merges Zooplankton tables from Microsoft Access Database to include Water Quality, Zooplankton Sampling and Catch data into one file. Data are visualized, flagged, and some values (flowmeter difference and CPUE) are re-calculated if deemed useful.",
    "Physical water quality data are visualized and outliers are flagged."), 
  user.id = c("iep", "csmith"),
  user.domain = c("EDI", "LTER"), 
  package.id = "edi.494.1")
