
# Script to process SRS Corridor Data with the EMLassemblyline
# Dataset = Resasco 2012

library(EMLassemblyline)

dataset_dir <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\SRSCorridor\\Sullivan_2011'

# Import templates
import_templates(
  path = dataset_dir,
  license = 'CC0',
  data.files = c('Sullivan_et_al_2011_LespedezaLeafDiseaseData.csv',
                 'Sullivan_gallsanddisease_patchavg.csv')
  )

# Define categorical variables
define_catvars(path = dataset_dir)

# Make EML
make_eml(
  path = dataset_dir,
  dataset.title = 'Can dispersal mode predict corridor effects on plant parasites?',
  data.files = c('Sullivan_et_al_2011_LespedezaLeafDiseaseData.csv',
                 'Sullivan_gallsanddisease_patchavg.csv'),
  data.files.description = c('Lespedeza leaf disease data',
                             'Galls and disease patch average'),
  temporal.coverage = c('2007-06-01', '2009-08-01'),
  geographic.coordinates = c('33.372280555555555',
                             '-81.50800833333334',
                             '33.185566666666666',
                             '-81.75708055555556'),
  geographic.description = 'Data were collected at the Savannah River Site (SRS) in South Carolina. SRS is located in Aiken, Barnwell, and Allendale counties, approximately 10 miles south of Aiken, SC. ',
  maintenance.description = 'Completed',
  user.id = c('srscorridor', 'csmith'),
  affiliation = c('EDI', 'LTER'),
  package.id = 'edi.105.1'
  )
