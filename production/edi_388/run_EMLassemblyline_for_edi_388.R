# This script executes an EMLassemblyline workflow.

library(EMLassemblyline)

setwd('C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_388')

EMLassemblyline::template_core_metadata(
  path = './metadata_templates',
  license = 'CCBY',
  file.type = '.docx'
)

EMLassemblyline::make_eml(
  path = './metadata_templates',
  data.path = './data_objects',
  eml.path = './eml',
  dataset.title = 'Sampling sites where ecological indices were used to assess the impact of different environmental stressors in aquatic environments in Argentina',
  temporal.coverage = c('1996-01-01', '2018-12-31'),
  geographic.description = 'Dataset compilation of all sampling sites where were used ecological indices to assess the impact of different environmental stressors in aquatic environments from Argentina',
  geographic.coordinates = c('-21.78111', '-53.6375', '-55.05583', '-73.56666'),
  maintenance.description = 'completed',
  other.entity = c('Sampling_sites_by_author_year.kml', 'Shapefiles.rar'),
  other.entity.description = c('The kml file containing 78 folders, each containing the studied sampling points by article',
                               'A conversion of the kml archive into a shapefile, with added ecoregions.'),
  user.id = 'csmith',
  user.domain = 'EDI',
  package.id = 'edi.293.3'
)

