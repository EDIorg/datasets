# This script executes an EMLassemblyline workflow.

# Staging identifier: edi.318
# Production identifier: edi.417

# Initialize workspace
library(EMLassemblyline)
setwd('/Users/csmith/Documents/EDI/datasets/edi_417')

# Template core metadata
EMLassemblyline::template_core_metadata(
  path = '.',
  license = 'CCBY',
  file.type = '.docx'
)

# Template table attributes
EMLassemblyline::template_table_attributes(
  path = '.',
  data.table = 'methane_data_Lambrecht.csv'
)

# Create EML
EMLassemblyline::make_eml(
  path = '.',
  dataset.title = 'Biogeochemical and physical controls on methane fluxes from two ferruginous meromictic lakes', 
  temporal.coverage = c('2017-04-01', '2018-06-01'), 
  geographic.description = 'Two Midwestern ferruginous meromictic lakes',
  geographic.coordinates = c('46.835316', '-87.919807',  '44.966088', '-93.326025'), 
  maintenance.description = 'complete', 
  data.table = 'methane_data_Lambrecht.csv', 
  data.table.description = 'Methane flux data from two Midwestern lakes', 
  user.id = 'csmith',
  user.domain = 'LTER',
  package.id = 'edi.417.1'
)
