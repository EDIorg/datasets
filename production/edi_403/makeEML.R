# This script executes an EMLassemblyline workflow.

library(EMLassemblyline)
library(dplyr)
library(tidyr)
library(stringr)

template_core_metadata(
  path = '.',
  license = 'CCBY'
)


template_table_attributes(
  path = '.',
  data.path = '.',
  data.table = c('IowaLake_HighFrequency_EDI.csv')
)

make_eml(
  path = '.',
  data.path = '.',
  eml.path = '.',
  dataset.title = 'Hypereutrophic lake sensor data during summer algae blooms in Iowa, USA, 2014 - 2018',
  temporal.coverage = c('2014-06-10', '2018-09-21'),
  maintenance.description = 'completed',
  data.table = c('IowaLake_HighFrequency_EDI.csv'),
  data.table.description = c('Daily sensor data from three lakes in Iowa'),
  data.table.quote.character = c('\"'),
  user.id = 'edi',
  user.domain = 'EDI',
  package.id = 'edi.403.1'
)
