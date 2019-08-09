
# Script to process SRS Corridor Data with the EMLassemblyline
# Dataset = Herrmann 2017

library(EMLassemblyline)

dataset_dir <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\SRSCorridor\\Herrmann_2017'

# Import templates
import_templates(
  path = dataset_dir,
  license = 'CC0',
  data.files = c('Herrmann_etal_2017.csv',
                 'Herrmann_etal_2017_b.csv')
  )

# Define categorical variables
define_catvars(path = dataset_dir)

# Make EML
make_eml(
  path = dataset_dir,
  dataset.title = 'Testing the relative importance of local resources and landscape connectivity on Bombus impatiens (Hymenoptera, Apidae) colonies',
  data.files = c('Herrmann_etal_2017.csv',
                 'Herrmann_etal_2017_b.csv'),
  data.files.description = c('Data for Herrmann et al. 2017 (table 1)',
                             'Data for Herrmann et al. 2017 (table 2)'),
  temporal.coverage = c('2013-04-01', '2013-06-01'),
  geographic.coordinates = c('33.372280555555555',
                             '-81.50800833333334',
                             '33.185566666666666',
                             '-81.75708055555556'),
  geographic.description = 'Data were collected at the Savannah River Site (SRS) in South Carolina. SRS is located in Aiken, Barnwell, and Allendale counties, approximately 10 miles south of Aiken, SC.',
  maintenance.description = 'Completed',
  user.id = c('srscorridor', 'csmith'),
  affiliation = c('EDI', 'LTER'),
  package.id = 'edi.45.1'
  )
