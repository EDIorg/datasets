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

path <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\villanova_peatland_group\\edi_362\\metadata_templates'
data.path <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\villanova_peatland_group\\edi_362\\data'
eml.path <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\villanova_peatland_group\\edi_362\\eml'

# Run functions

EMLassemblyline::import_templates(
  path = path,
  data.path = data.path,
  data.files = 'Net_N_mineralization.csv',
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
  dataset.title = 'Net N Mineralization Rates in Peat From N-Addition Plots in an Alberta Peatland, 2011-2014',
  data.files = 'Net_N_mineralization.csv',
  data.files.description = 'Net N Mineralization Data',
  temporal.coverage = c('2011-06-01', '2014-07-01'),
  geographic.description = 'Alberta, Canada, 100 km south of Fort McMurray, Canada',
  geographic.coordinates = c('55.895', '-112.094','55.895', '-112.094'),
  maintenance.description = 'completed',
  user.id = c('csmith', 'wiederlab'),
  affiliation = c('LTER','EDI'),
  package.id = 'edi.362.1'
)



