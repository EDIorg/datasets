# This script executes an EMLassemblyline workflow.

library(EMLassemblyline)
library(dplyr)
library(tidyr)
library(stringr)

dir_path <- "../dataSubset2019"

template_core_metadata(
  path = dir_path,
  license = 'CCBY'
)


template_table_attributes(
  path = dir_path,
  data.path = dir_path,
  data.table = c('lupin.csv')
)

template_taxonomic_coverage(
  path = dir_path,
  data.path = dir_path,
  taxa.table = 'taxon_name.csv',
  taxa.col = 'taxon_name',
  taxa.authority = c(3,11),
  taxa.name.type = 'both'
)

coordinate_north <- 46.25523389177687
coordinate_east <- -122.14879213053968
coordinate_south <- 46.224547252168136
coordinate_west <- -122.18236056450512

make_eml(
  path = dir_path,
  data.path = dir_path,
  eml.path = dir_path,
  dataset.title = 'Insect herbivore impact on a keystone plant colonist in primary succession at Mount St. Helens from 1994 to 2017',
  temporal.coverage = c('1994-08-01', '2017-09-15'),
  geographic.description = 'General-- Skamania County, Washington. Gifford Pinchot National Forest, Mount St. Helens National Volcanic Monument. Specific—The Pumice Plain located on lahar, blast scour, pyroclastic flow, and debris flow surfaces immediately north (2 km) of the crater of Mount St. Helens volcano and south (0.2 km) of Spirit Lake.',
  geographic.coordinates = c(coordinate_north, coordinate_east, coordinate_south, coordinate_west),
  maintenance.description = 'ongoing',
  data.table = c('lupin.csv'),
  data.table.description = c('Long term survey of of Lupinus lepidus and herbivore damage, Mount St. Helens, WA, USA.'),
  data.table.quote.character = c('\"'),
  user.id = 'edi',
  user.domain = 'EDI',
  package.id = 'edi.406.2'
)
