# This script executes an EMLassemblyline workflow.

# Initialize workspace --------------------------------------------------------

library(EMLassemblyline)

# Define paths for your metadata templates, data, and EML

path_templates <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_615\\metadata_templates"
path_data <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_615\\data_objects"
path_eml <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_615\\eml"

# Create metadata templates ---------------------------------------------------

EMLassemblyline::template_core_metadata(
  path = path_templates,
  license = "CCBY",
  file.type = ".docx")

EMLassemblyline::template_table_attributes(
  path = path_templates,
  data.path = path_data,
  data.table = c(
    "Phytoplankton_table.csv",
    "Water_chem_table.csv",
    "FTIR_table.csv"))

EMLassemblyline::template_categorical_variables(
  path = path_templates, 
  data.path = path_data)

# Make EML from metadata templates --------------------------------------------

EMLassemblyline::make_eml(
  path = path_templates,
  data.path = path_data,
  eml.path = path_eml, 
  dataset.title = "Phylum level phytoplankton composition and FTIR spectra for body wash microplastics and plant-based scrub particles from a 7-day summer 2016 surface mesocosm experiment in Otsego Lake, NY, USA", 
  temporal.coverage = c("2016-07-06", "2016-07-13"), 
  geographic.description = "Rat Cove behind SUNY Oneonta Biological Field Station on Otsego Lake, Otsego County, NY, USA", 
  geographic.coordinates = c("42.718647", "-74.925608", "42.718647", "-74.925608"), 
  maintenance.description = "Data collection is complete. No updates are expected.", 
  data.table = c(
    "Phytoplankton_table.csv",
    "Water_chem_table.csv",
    "FTIR_table.csv"), 
  data.table.name = c(
    "Phytoplankton table",
    "Water chemistry table",
    "FTIR table"),
  data.table.description = c(
    "Phytoplankton table",
    "Water chemistry table",
    "FTIR table"),
  user.id = "csmith",
  user.domain = "LTER", 
  package.id = "edi.615.1")
