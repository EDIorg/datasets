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

path <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\villanova_peatland_group\\edi_319\\metadata_templates'
data.path <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\villanova_peatland_group\\edi_319\\data'
eml.path <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\villanova_peatland_group\\edi_319\\eml'

# Run functions

EMLassemblyline::import_templates(
  path = path,
  data.path = data.path,
  data.files = 'Capitulum_N_data.csv',
  license = 'CC0'
)

EMLassemblyline::define_catvars(
  path = path,
  data.path = data.path
)

d <- taxonomyCleanr::resolve_sci_taxa(data.sources = '3', 
                                      x = 'Sphagnum fuscum')
taxonomyCleanr::make_taxonomicCoverage(
  taxa.clean = d$taxa_clean,
  authority = d$authority,
  authority.id = d$authority_id,
  path = path)

EMLassemblyline::make_eml(
  path = path,
  data.path = data.path,
  eml.path = eml.path,
  dataset.title = 'Sphagnum fuscum Capitulum Density, Mass, and N Concentrations From N-Addition Plots in an Alberta Peatland, 2013-2015',
  data.files = 'Capitulum_N_data.csv',
  data.files.description = 'Sphagnum fuscum Capitulum Data',
  temporal.coverage = c('2013-07-01', '2015-10-01'),
  geographic.description = 'Alberta, Canada, 100 km south of Fort McMurray, Canada',
  geographic.coordinates = c('55.895', '-112.094','55.895', '-112.094'),
  maintenance.description = 'completed',
  user.id = c('csmith', 'wiederlab'),
  affiliation = c('LTER','EDI'),
  package.id = 'edi.319.1'
)
