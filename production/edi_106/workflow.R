
# Script to process SRS Corridor Data with the EMLassemblyline
# Dataset = Wells 2009

library(EMLassemblyline)

dataset_dir <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\SRSCorridor\\Wells_2009'

# Import templates
import_templates(
  path = dataset_dir,
  license = 'CC0',
  data.files = c('AlleleFrequencyData_Wells_2009_data.csv')
  )

# Define categorical variables
define_catvars(path = dataset_dir)

# Make EML
make_eml(
  path = dataset_dir,
  dataset.title = 'Effects of Corridors on Genetics of a Butterfly in a Landscape Experiment',
  data.files = c('AlleleFrequencyData_Wells_2009_data.csv'),
  data.files.description = c('Allele frequency data for Wells 2009'),
  temporal.coverage = c('2002-05-01', '2002-06-01'),
  geographic.coordinates = c('33.372280555555555',
                             '-81.50800833333334',
                             '33.185566666666666',
                             '-81.75708055555556'),
  geographic.description = 'Data were collected at the Savannah River Site (SRS) in South Carolina. SRS is located in Aiken, Barnwell, and Allendale counties, approximately 10 miles south of Aiken, SC. ',
  maintenance.description = 'Completed',
  user.id = c('srscorridor', 'csmith'),
  affiliation = c('EDI', 'LTER'),
  package.id = 'edi.106.1'
  )
