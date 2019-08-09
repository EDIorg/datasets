
rm(list = ls())
library(EMLassemblyline)

# Import templates

import_templates(path = "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\NHSB_species", 
                 license = 'CC0', 
                 data.files = c("NHSB_SpeciesData.csv"))

# Define categorical variables

define_catvars(path = "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\NHSB_species")

# Make EML

make_eml(
  path = "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\NHSB_species",
  dataset.title = 'McMurdo Sound, Antarctica: Benthic macrofaunal abundances in Explorers Cove in 1970s and 2010 and in Salmon Bay in 1988-89 and 2010',
  data.files = c("NHSB_SpeciesData.csv"),
  data.files.description = c('Benthic invertebrate of McMurdo Sound, Antarctica'),
  temporal.coverage = c('1974-10-01', '2010-12-01'),
  geographic.coordinates = c('-77.546409', '164.673326', '-77.931341', '163.455125'),
  geographic.description = 'Explorers Cove and Salmon Bay, McMurdo Sound, Antarctica',
  maintenance.description = 'Completed',
  user.id = 'csmith',
  affiliation = 'LTER',
  package.id = 'edi.108.1'
)
