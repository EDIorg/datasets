
rm(list = ls())
library(EMLassemblyline)

EMLassemblyline::import_templates(
  path = 'C:/Users/Colin/Documents/EDI/data_sets/melanie_arnold/edi_264/metadata_templates',
  data.path = 'C:/Users/Colin/Documents/EDI/data_sets/melanie_arnold/edi_264/data',
  data.files = 'WCCDOC_1977to2017',
  license = 'CCBY'
)

EMLassemblyline::define_catvars(
  path = 'C:/Users/Colin/Documents/EDI/data_sets/melanie_arnold/edi_264/metadata_templates',
  data.path = 'C:/Users/Colin/Documents/EDI/data_sets/melanie_arnold/edi_264/data'
)

EMLassemblyline::make_eml(
  path = 'C:/Users/Colin/Documents/EDI/data_sets/melanie_arnold/edi_264/metadata_templates',
  data.path = 'C:/Users/Colin/Documents/EDI/data_sets/melanie_arnold/edi_264/data',
  eml.path = 'C:/Users/Colin/Documents/EDI/data_sets/melanie_arnold/edi_264/eml',
  dataset.title = 'Dissolved organic carbon concentrations in White Clay Creek, Pennsylvania, 1977-2017',
  data.files = 'WCCDOC_1977to2017',
  data.files.description = 'White Clay Creek 1977-2017 DOC',
  temporal.coverage = c('1977-10-28', '2017-12-21'),
  geographic.description = 'White Clay Creek at Stroud Water Research Center',
  geographic.coordinates = c('39.86066', '-75.78381','39.8594', '-75.783855'),
  maintenance.description = 'Ongoing',
  user.id = 'csmith',
  affiliation = 'LTER',
  package.id = 'edi.6.3'
)


