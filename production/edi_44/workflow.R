
# Script to process SRS Corridor Data with the EMLassemblyline
# Dataset = Herrmann 2016

library(EMLassemblyline)

dataset_dir <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\SRSCorridor\\Herrmann_2016'

# Import templates
import_templates(
  path = dataset_dir,
  license = 'CC0',
  data.files = 'Herrmann_etal_2016.csv'
  )

# Define categorical variables
define_catvars(path = dataset_dir)

# Make EML
make_eml(
  path = dataset_dir,
  dataset.title = 'Connectivity from a different perspective: comparing seed dispersal kernels in connected vs. unfragmented landscapes.',
  data.files = 'Herrmann_etal_2016.csv',
  data.files.description = 'Data for Herrmann et al. 2016',
  temporal.coverage = c('2012-03-01', '2013-03-01'),
  geographic.coordinates = c('33.372280555555555',
                             '-81.50800833333334',
                             '33.185566666666666',
                             '-81.75708055555556'),
  geographic.description = 'Data were collected at the Savannah River Site (SRS) in South Carolina. SRS is located in Aiken, Barnwell, and Allendale counties, approximately 10 miles south of Aiken, SC.',
  maintenance.description = 'Completed',
  user.id = c('srscorridor', 'csmith'),
  affiliation = c('EDI', 'LTER'),
  package.id = 'edi.44.1'
  )
