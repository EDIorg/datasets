# This script executes an EMLassemblyline workflow.
library(EMLassemblyline)

# Parameterize
base_path <- '/Users/csmith/Documents/EDI/datasets/edi_404'

# # Template table attributes
# EMLassemblyline::template_table_attributes(
#   path = paste0(base_path, '/metadata_templates'), 
#   data.path = paste0(base_path, '/data_objects'), 
#   data.table = 'SOM_at_three_forest_types_in_Taiwan.csv'
# )
# 
# # Template core metadata
# EMLassemblyline::template_core_metadata(
#   path = paste0(base_path, '/metadata_templates'),
#   license = 'CCBY',
#   file.type = '.docx'
# )
# 
# # Template categorical variables
# EMLassemblyline::template_categorical_variables(
#   path = paste0(base_path, '/metadata_templates'),
#   data.path = paste0(base_path, '/data_objects')
# )

# Make EML
EMLassemblyline::make_eml(
  path = paste0(base_path, '/metadata_templates'),
  data.path = paste0(base_path, '/data_objects'),
  eml.path = paste0(base_path, '/eml'),
  dataset.title = 'Response of humic acids and soil organic matter to vegetation replacement in subtropical high mountain forests',
  temporal.coverage = c('2014-02-01', '2014-02-01'),
  geographic.coordinates = c(
    '23.65472',
    '120.8081',
    '23.65472',
    '120.8081'
  ),
  geographic.description = 'The study was conducted in the Shitou Experimental Forest of National Taiwan University in Nantou County, central Taiwan',
  maintenance.description = 'Complete',
  data.table = 'SOM_at_three_forest_types_in_Taiwan.csv',
  data.table.description = 'SOM at three forest types in Taiwan',
  user.id = 'csmith',
  user.domain = 'LTER',
  package.id = 'edi.404.1'
)
