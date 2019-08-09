
# Script to process SRS Corridor Data with the EMLassemblyline
# Dataset = Resasco 2012

library(EMLassemblyline)

dataset_dir <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\SRSCorridor\\Resasco_2012'

# Import templates
import_templates(
  path = dataset_dir,
  license = 'CC0',
  data.files = c('Resasco_et_al_2012_Ecosphere_data.csv')
  )

# Define categorical variables
define_catvars(path = dataset_dir)

# Make EML
make_eml(
  path = dataset_dir,
  dataset.title = 'Habitat corridors alter relative trophic position of fire ants',
  data.files = c('Resasco_et_al_2012_Ecosphere_data.csv'),
  data.files.description = c('Data for Resasco et al. 2012'),
  temporal.coverage = c('2008-08-01', '2008-08-31'),
  geographic.coordinates = c('33.372280555555555',
                             '-81.50800833333334',
                             '33.185566666666666',
                             '-81.75708055555556'),
  geographic.description = 'Data were collected at the Savannah River Site (SRS) in South Carolina. SRS is located in Aiken, Barnwell, and Allendale counties, approximately 10 miles south of Aiken, SC.',
  maintenance.description = 'Completed',
  user.id = c('srscorridor', 'csmith'),
  affiliation = c('EDI', 'LTER'),
  package.id = 'edi.103.1'
  )
