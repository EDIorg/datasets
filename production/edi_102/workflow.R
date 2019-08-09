
# Script to process SRS Corridor Data with the EMLassemblyline
# Dataset = Herrmann 2018

library(EMLassemblyline)

dataset_dir <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\SRSCorridor\\Levey_2016'

# Import templates
import_templates(
  path = dataset_dir,
  license = 'CC0',
  data.files = c('Levey_Ecology_2016_data.csv')
  )

# Define categorical variables
define_catvars(path = dataset_dir)

# Make EML
make_eml(
  path = dataset_dir,
  dataset.title = 'Disentangling fragmentation effects on herbivory in understory plants of longleaf pine savanna',
  data.files = c('Levey_Ecology_2016_data.csv'),
  data.files.description = c('Data for Levey Ecology 2016'),
  temporal.coverage = c('2009-05-30', '2009-09-23'),
  geographic.coordinates = c('33.372280555555555',
                             '-81.50800833333334',
                             '33.185566666666666',
                             '-81.75708055555556'),
  geographic.description = 'Data were collected at the Savannah River Site (SRS) in South Carolina. SRS is located in Aiken, Barnwell, and Allendale counties, approximately 10 miles south of Aiken, SC.',
  maintenance.description = 'Completed',
  user.id = c('srscorridor', 'csmith'),
  affiliation = c('EDI', 'LTER'),
  package.id = 'edi.102.1'
  )
