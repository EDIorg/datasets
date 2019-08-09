
# Script to process SRS Corridor Data with the EMLassemblyline
# Dataset = Herrmann 2018

library(EMLassemblyline)

dataset_dir <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\SRSCorridor\\Johnson_2011'

# Import templates
import_templates(
  path = dataset_dir,
  license = 'CC0',
  data.files = c('Johnson_Ecology_2011_Experiment_1.csv',
                 'Johnson_Ecology_2011_Experiment_2.csv',
                 'Johnson_Ecology_2011_Experiment_3.csv')
  )

# Define categorical variables
define_catvars(path = dataset_dir)

# Make EML
make_eml(
  path = dataset_dir,
  dataset.title = 'Edge effects, not connectivity, determine the incidence and development of a foliar fungal plant disease',
  data.files = c('Johnson_Ecology_2011_Experiment_1.csv',
                 'Johnson_Ecology_2011_Experiment_2.csv',
                 'Johnson_Ecology_2011_Experiment_3.csv'),
  data.files.description = c('Data for Johnson 2011, from experiment 1',
                             'Data for Johnson 2011, from experiment 2',
                             'Data for Johnson 2011, from experiment 3'),
  temporal.coverage = c('2008-06-04', '2009-07-14'),
  geographic.coordinates = c('33.372280555555555',
                             '-81.50800833333334',
                             '33.185566666666666',
                             '-81.75708055555556'),
  geographic.description = 'Data were collected at the Savannah River Site (SRS) in South Carolina. SRS is located in Aiken, Barnwell, and Allendale counties, approximately 10 miles south of Aiken, SC.',
  maintenance.description = 'Completed',
  user.id = c('srscorridor', 'csmith'),
  affiliation = c('EDI', 'LTER'),
  package.id = 'edi.90.1'
  )
