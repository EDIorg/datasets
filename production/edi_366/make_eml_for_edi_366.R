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

path <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\villanova_peatland_group\\edi_366\\metadata_templates'
data.path <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\villanova_peatland_group\\edi_366\\data'
eml.path <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\villanova_peatland_group\\edi_366\\eml'

# Run functions

EMLassemblyline::import_templates(
  path = path,
  data.path = data.path,
  data.files = 'Point_frame_data.csv',
  license = 'CC0'
)

EMLassemblyline::define_catvars(
  path = path,
  data.path = data.path
)

d <- taxonomyCleanr::resolve_sci_taxa(data.sources = c('3', '11'),
                                      x = c('Sphagnum fuscum',
                                            'Sphagnum magellanicum',
                                            'Sphagnum angustifolium',
                                            'Polytricum strictum',
                                            'Pleurozium schreberi',
                                            'Dicranum undulatum',
                                            'Mylia anomala',
                                            'Andromeda polifolia',
                                            'Chamaedaphne calyculata',
                                            'Kalmia polifolia',
                                            'Vaccinium oxycoccos',
                                            'Vaccinium vitis-idaea',
                                            'Rhododendron groenlandicum',
                                            'Picea mariana',
                                            'Eriophorum vaginatum',
                                            'Drosera rotundifolia',
                                            'Maianthemum trifolium',
                                            'Rubus chamaemorus',
                                            'Fungi'))
taxonomyCleanr::make_taxonomicCoverage(
  taxa.clean = d$taxa_clean,
  authority = d$authority,
  authority.id = d$authority_id,
  path = path)

EMLassemblyline::make_eml(
  path = path,
  data.path = data.path,
  eml.path = eml.path,
  dataset.title = 'Point Frame Measurements of Moss and Vascular Frequencies Under Increasing N Deposition Over Five Years, 2011-2015',
  data.files = 'Point_frame_data.csv',
  data.files.description = 'Point Frame Data',
  temporal.coverage = c('2011-07-17', '2015-07-19'),
  geographic.description = 'Alberta, Canada, 100 km south of Fort McMurray, Canada',
  geographic.coordinates = c('55.895', '-112.094','55.895', '-112.094'),
  maintenance.description = 'completed',
  user.id = c('csmith', 'wiederlab'),
  affiliation = c('LTER','EDI'),
  package.id = 'edi.366.1'
)

