
rm(list = ls())
library(EMLassemblyline)

# Import templates

import_templates(path = "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\CA_species", 
                 license = 'CC0', 
                 data.files = c("CA_PhotoMetadata.csv", "CA_SpeciesData.csv"))

# Define categorical variables

define_catvars(path = "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\CA_species")

# Make EML

make_eml(
  path = "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\CA_species",
  dataset.title = 'McMurdo Sound, Antarctica: Cape Armitage, sponge abundance and cover and photo ID information for 1968 and 2010',
  data.files = c("CA_PhotoMetadata.csv", "CA_SpeciesData.csv"),
  data.files.description = c('Benthic invertebrate photo metadata of McMurdo Sound, Antarctica',
                             'Benthic invertebrates of McMurdo Sound, Antarctica'),
  temporal.coverage = c('1968-09-01', '2010-12-01'),
  geographic.coordinates = c('-77.859626', '166.702327', '-77.863072', '166.675889'),
  geographic.description = 'Cape Armitage, McMurdo Sound, Antarctica',
  maintenance.description = 'Completed',
  user.id = 'csmith',
  affiliation = 'LTER',
  package.id = 'edi.107.1'
)
