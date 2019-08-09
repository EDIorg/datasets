
# Script to process SRS Corridor Data with the EMLassemblyline
# Dataset = craig_landscape_ecology_2011 (edi_251)

rm(list = ls())

library(EMLassemblyline)

dataset_dir <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\SRSCorridor\\edi_251'

# Import templates
import_templates(
  path = dataset_dir,
  license = 'CC0',
  data.files = 'craig_et_al_dataset_for_analyses.csv'
  )

# Define categorical variables
define_catvars(path = dataset_dir)

# Make EML
make_eml(
  path = dataset_dir,
  dataset.title = 'Edge-mediated patterns of seed removal in experimentally connected and fragmented landscapes',
  data.files = 'craig_et_al_dataset_for_analyses.csv',
  data.files.description = 'craig_et_al_dataset_for_analyses',
  temporal.coverage = c('2009-08-18', '2009-02-12'),
  geographic.coordinates = c('33.372280555555555',
                             '-81.50800833333334',
                             '33.185566666666666',
                             '-81.75708055555556'),
  geographic.description = 'Data were collected at the Savannah River Site (SRS) in South Carolina. SRS is located in Aiken, Barnwell, and Allendale counties, approximately 10 miles south of Aiken, SC. The uplands are primarily longleaf pine (Pinus palustris) plantations, loblolly pine (P. taeda) plantations, and longleaf pine savannah.',
  maintenance.description = 'Completed',
  user.id = c('srscorridor', 'csmith'),
  affiliation = c('EDI', 'LTER'),
  package.id = 'edi.255.1'
  )
