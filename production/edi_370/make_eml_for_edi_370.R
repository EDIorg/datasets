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

path <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\villanova_peatland_group\\edi_370\\metadata_templates'
data.path <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\villanova_peatland_group\\edi_370\\data'
eml.path <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\villanova_peatland_group\\edi_370\\eml'

# Run functions

EMLassemblyline::import_templates(
  path = path,
  data.path = data.path,
  data.files = 'Sphagnum_and_vascular_plant_decomposition_data.csv',
  license = 'CC0'
)

EMLassemblyline::define_catvars(
  path = path,
  data.path = data.path
)

d <- taxonomyCleanr::resolve_sci_taxa(data.sources = '3',
                                      x = c('Rhododendron groenlandicum',
                                            'Andromeda polifolia',
                                            'Chamaedaphne calyculata',
                                            'Maianthemum trifolium',
                                            'Rubus chamaemorus',
                                            'Sphagnum fuscum'))
taxonomyCleanr::make_taxonomicCoverage(
  taxa.clean = d$taxa_clean,
  authority = d$authority,
  authority.id = d$authority_id,
  path = path)

EMLassemblyline::make_eml(
  path = path,
  data.path = data.path,
  eml.path = eml.path,
  dataset.title = 'Sphagnum and Vascular Plant Decomposition under Increasing Nitrogen Additions: 2014-2015',
  data.files = 'Sphagnum_and_vascular_plant_decomposition_data.csv',
  data.files.description = 'Sphagnum and Vascular Plant Decomposition Data',
  temporal.coverage = c('2014-05-01', '2015-10-31'),
  geographic.description = 'Alberta, Canada, 100 km south of Fort McMurray, Canada',
  geographic.coordinates = c('55.895', '-112.094','55.895', '-112.094'),
  maintenance.description = 'completed',
  user.id = c('csmith', 'wiederlab'),
  affiliation = c('LTER','EDI'),
  package.id = 'edi.370.1'
)


