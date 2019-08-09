# This script uses EMLassemblyline and taxonomyCleanr to create EML metadata
# for archive in the Environmental Data Initiative Data Repository.
#
# EMLassemblyline installation and use instructions are on GitHub:
# https://github.com/EDIorg/EMLassemblyline
#
# taxonomyCleanr installation and use instructions are on GitHub:
# https://github.com/EDIorg/taxonomyCleanr

# Initialize workspace

rm(list = ls())
library(EMLassemblyline)
library(taxonomyCleanr)

# Parameterize functions

path <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\villanova_peatland_group\\edi_373\\metadata_templates'
data.path <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\villanova_peatland_group\\edi_373\\data'
eml.path <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\villanova_peatland_group\\edi_373\\eml'

# Run functions

rm(list = ls())
library(EMLassemblyline)

EMLassemblyline::import_templates(
  path = path,
  data.path = data.path,
  data.files = c('Water_chemistry.csv'),
  license = 'CC0'
)

EMLassemblyline::define_catvars(
  path = path,
  data.path = data.path
)

EMLassemblyline::make_eml(
  path = path,
  data.path = data.path,
  eml.path = eml.path,
  dataset.title = 'Pore Water Concentrations of Nitrogen From N-Addition Plots in an Alberta Peatland, 2011-2015',
  data.files = 'Water_chemistry.csv',
  data.files.description = 'Pore Water Chemistry Data',
  temporal.coverage = c('2011-05-31', '2015-08-06'),
  geographic.description = 'Alberta, Canada, 100 km south of Fort McMurray, Canada',
  geographic.coordinates = c('55.895', '-112.094','55.895', '-112.094'),
  maintenance.description = 'completed',
  user.id = c('csmith', 'wiederlab'),
  affiliation = c('LTER','EDI'),
  package.id = 'edi.373.1'
)
