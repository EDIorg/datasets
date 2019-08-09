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

path <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\villanova_peatland_group\\edi_273\\metadata_templates'
data.path <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\villanova_peatland_group\\edi_273\\data'
eml.path <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\villanova_peatland_group\\edi_273\\eml'

# Run functions

EMLassemblyline::import_templates(
  path = path,
  data.path = data.path,
  data.files = 'Leaf_needle_N_concentrations.csv',
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
                                            'Picea mariana',
                                            'Vaccinium oxycoccos',
                                            'Rubus chamaemorus',
                                            'Maianthemum trifolium',
                                            'Eriophorum vaginatum',
                                            'Vaccinium vitis-idaea',
                                            'Kalmia polifolia'))
taxonomyCleanr::make_taxonomicCoverage(
  taxa.clean = d$taxa_clean,
  authority = d$authority,
  authority.id = d$authority_id,
  path = path)

EMLassemblyline::make_eml(
  path = path,
  data.path = data.path,
  eml.path = eml.path,
  dataset.title = 'Peatland Vascular Plant Leaf N Concentrations (10 Species) From Leaves Collected From N-Addition Plots in an Alberta Peatland, 2011-2015',
  data.files = 'Leaf_needle_N_concentrations.csv',
  data.files.description = 'Leaf Needle N Concentrations',
  temporal.coverage = c('2011-07-01', '2015-07-01'),
  geographic.description = 'Alberta, Canada, 100 km south of Fort McMurray, Canada',
  geographic.coordinates = c('55.895', '-112.094','55.895', '-112.094'),
  maintenance.description = 'completed',
  user.id = c('csmith', 'wiederlab'),
  affiliation = c('LTER','EDI'),
  package.id = 'edi.273.1'
)


