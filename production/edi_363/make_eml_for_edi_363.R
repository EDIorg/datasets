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

path <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\villanova_peatland_group\\edi_363\\metadata_templates'
data.path <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\villanova_peatland_group\\edi_363\\data'
eml.path <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\villanova_peatland_group\\edi_363\\eml'

# Run functions

EMLassemblyline::import_templates(
  path = path,
  data.path = data.path,
  data.files = 'Nitrogen_fixation.csv',
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
  dataset.title = 'Nitrogen Fixation Responses in Sphagnum fuscum to N-Additions to an Alberta Peatland, 2012-2015',
  data.files = 'Nitrogen_fixation.csv',
  data.files.description = 'Nitrogen Fixation Data',
  temporal.coverage = c('2012-06-11', '2015-08-06'),
  geographic.description = 'Alberta, Canada, 100 km south of Fort McMurray, Canada',
  geographic.coordinates = c('55.895', '-112.094','55.895', '-112.094'),
  maintenance.description = 'completed',
  user.id = c('csmith', 'wiederlab'),
  affiliation = c('LTER','EDI'),
  package.id = 'edi.363.1'
)



