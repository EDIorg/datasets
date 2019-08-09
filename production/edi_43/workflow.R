
# Script to process SRS Corridor Data with the EMLassemblyline
# Dataset = Evans_2013a

library(EMLassemblyline)

dataset_dir <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\SRSCorridor\\Evans_2013a'

# Import templates
import_templates(
  path = dataset_dir,
  license = 'CC0',
  data.files = 'Evansetal_Ecological Restoration_2013a.csv'
  )

# Define categorical variables
define_catvars(path = dataset_dir)

# Make EML
make_eml(
  path = dataset_dir,
  dataset.title = 'Landscape Corridors Promote Long Distance Seed Dispersal by Birds During Winter but Not During Summer at an Experimentally Fragmented Restoration Site',
  data.files = 'Evansetal_Ecological Restoration_2013a.csv',
  data.files.description = 'Data for Evans et al. 2013',
  temporal.coverage = c('2009-05-09', '2010-03-27'),
  geographic.coordinates = c('33.372280555555555',
                             '-81.50800833333334',
                             '33.185566666666666',
                             '-81.75708055555556'),
  geographic.description = 'Data were collected at the Savannah River Site (SRS) in South Carolina. SRS is located in Aiken, Barnwell, and Allendale counties, approximately 10 miles south of Aiken, SC. The uplands are primarily longleaf pine (Pinus elliotii) plantations, loblolly pine (P. taeda) plantations, and longleaf pine savannah.',
  maintenance.description = 'Completed',
  user.id = c('srscorridor', 'csmith'),
  affiliation = c('EDI', 'LTER'),
  package.id = 'edi.43.1'
  )
