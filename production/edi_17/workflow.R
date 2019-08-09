
# Script to process SRS Corridor Data with the EMLassemblyline
# Dataset = Brudvig_2012

library(EMLassemblyline)

dataset_dir <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\SRSCorridor\\Brudvig_2012'

# Import templates
import_templates(
  path = dataset_dir,
  license = 'CC0',
  data.files = 'Brudvig_etal_2012-EcolApps-Data.csv'
  )

# Define categorical variables
define_catvars(path = dataset_dir)

# Make EML
make_eml(
  path = dataset_dir,
  dataset.title = 'Corridors promote fire via connectivity and edge effects',
  data.files = 'Brudvig_etal_2012-EcolApps-Data.csv',
  data.files.description = 'Data for Brudvig et al. 2012',
  temporal.coverage = c('2009-01-31', '2009-03-23'),
  geographic.coordinates = c('33.372280555555555',
                             '-81.50800833333334',
                             '33.185566666666666',
                             '-81.75708055555556'),
  geographic.description = 'Data were collected at the Savannah River Site (SRS) in South Carolina. SRS is located in Aiken, Barnwell, and Allendale counties, approximately 10 miles south of Aiken, SC.',
  maintenance.description = 'Completed',
  user.id = c('srscorridor', 'csmith'),
  affiliation = c('EDI', 'LTER'),
  package.id = 'edi.17.1'
  )
