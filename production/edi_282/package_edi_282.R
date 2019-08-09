
rm(list = ls())
library(EMLassemblyline)

# Parameterize this script

path <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\mendota_p_cycling\\edi_282\\metadata_templates'
data.path <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\mendota_p_cycling\\edi_282\\data'
eml.path <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\mendota_p_cycling\\edi_282\\eml'

# Import core metadata templates
# This was done manually because EMLassemblyline doesn't yet support import of 
# templates without data.files.

# Translate metadata templates into EML

EMLassemblyline::make_eml(
  path = path,
  data.path = data.path,
  eml.path = eml.path,
  dataset.title = 'Proprietary Sub Bottom Profiler Data for Lake Mendota',
  zip.dir = 'V4LOG.zip',
  zip.dir.description = 'Sediment profile mapping data',
  temporal.coverage = c('2017-06-01', '2017-08-01'),
  geographic.coordinates = c('43.146', '-89.3673', '43.0766', '-89.4837'),
  geographic.description = 'Lake Mendota, Madison, WI',
  maintenance.description = 'completed',
  user.id = 'csmith',
  affiliation = 'LTER',
  package.id = 'edi.274.1'
)
