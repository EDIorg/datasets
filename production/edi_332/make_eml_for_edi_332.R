
rm(list = ls())
library(EMLassemblyline)
library(taxonomyCleanr)

path <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\archbold\\edi_332\\metadata_templates'
data.path <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\archbold\\edi_332\\data'
eml.path <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\archbold\\edi_332\\eml'
data.files <- 'Burn_history_and_attributes.csv'

EMLassemblyline::import_templates(
  path = path,
  data.path = data.path,
  data.files = data.files,
  license = 'CCBY'
)

d <- taxonomyCleanr::resolve_sci_taxa(data.sources = '3', 
                                      x = 'Hypericum cumulicola')
taxonomyCleanr::make_taxonomicCoverage(
  taxa.clean = d$taxa_clean,
  authority = d$authority,
  authority.id = d$authority_id,
  path = path)

EMLassemblyline::make_eml(
  path = path,
  data.path = data.path,
  eml.path = eml.path,
  dataset.title = 'Burn history and patch attributes',
  data.files = data.files,
  data.files.description = 'Fire occurences (1967-2017), area, elevation, and isolation index of 92 study sites',
  temporal.coverage = c('1967-01-01', '2017-12-31'),
  geographic.description = 'Highlands county, Forida, USA',
  geographic.coordinates = c('27.120002', '-81.333713','27.21143', '-81.389753'),
  maintenance.description = 'ongoing',
  user.id = 'csmith',
  affiliation = 'LTER',
  package.id = 'edi.332.1'
)
