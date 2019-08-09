
# Script to process SRS Corridor Data with the EMLassemblyline
# Dataset = Herrmann 2018

library(EMLassemblyline)

dataset_dir <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\SRSCorridor\\Herrmann_2018'

# Import templates
import_templates(
  path = dataset_dir,
  license = 'CC0',
  data.files = c('Herrmann_etal_2018.csv')
  )

# Define categorical variables
define_catvars(path = dataset_dir)

# Make EML
make_eml(
  path = dataset_dir,
  dataset.title = 'Mean body size predicts colony performance in the common eastern bumble bee (Bombus impatiens)',
  data.files = c('Herrmann_etal_2018.csv'),
  data.files.description = c('Data for Herrmann et al. 2018'),
  temporal.coverage = c('2013-04-04', '2013-05-24'),
  geographic.coordinates = c('33.372280555555555',
                             '-81.50800833333334',
                             '33.185566666666666',
                             '-81.75708055555556'),
  geographic.description = 'Data were collected at the Savannah River Site (SRS) in South Carolina. SRS is located in Aiken, Barnwell, and Allendale counties, approximately 10 miles south of Aiken, SC.',
  maintenance.description = 'Completed',
  user.id = c('srscorridor', 'csmith'),
  affiliation = c('EDI', 'LTER'),
  package.id = 'edi.51.1'
  )
