# This script executes an EMLassemblyline workflow for EDI data package
# edi.378.

# Parameterize ----------------------------------------------------------------

# Load libraries

library(EMLassemblyline)

# Set working directory

setwd('C:\\Users\\Colin\\Documents\\EDI\\data_sets\\villanova_peatland_group\\edi_378')

# Set function arguments

data_table <- c(
  'BioavailabilityProfiles_04Oct2002.csv',
  'C13Bromide_WhiteClayCrPA_02Oct02_Kaplan2008FreshwBiol.csv',
  'C1302_INJMODEL_BROMIDE_EDI_EXPORT'
)

data_table_description <- c(
  'Leachate and streamwater lability profiles',
  '<superscript>13</superscript>C-DOC concentrations in streamwater',
  'Conservative tracer (bromide) concentrations'
)



# Template core metadata ------------------------------------------------------

# template_core_metadata(
#   path = './metadata_templates',
#   license = 'CCBY'
# )

# Template table attributes ---------------------------------------------------

# template_table_attributes(
#   path = './metadata_templates',
#   data.path = './data_objects',
#   data.table = data_table
# )

# Make EML --------------------------------------------------------------------

make_eml(
  path = './metadata_templates',
  data.path = './data_objects',
  eml.path = './eml',
  dataset.title = 'Stable isotope and conservative tracer data used to estimate uptake of stream water dissolved organic carbon (DOC) through a whole-stream addition of a <superscript>13</superscript>C-DOC tracer coupled with laboratory measurements of bioavailability of the tracer and stream water DOC using lability profiling with bioreactors',
  temporal.coverage = c('2002-10-02', '2002-10-04'),
  maintenance.description = 'Completed',
  geographic.description = 'A forested reach of the 3<superscript>rd</superscript>-order White Clay Creek in southeastern Pennsylvania, USA',
  geographic.coordinates = c('39.88333', '-75.78333', '39.88333', '-75.78333'),
  data.table = data_table,
  data.table.description = data_table_description,
  user.id = 'csmith',
  user.domain = 'LTER',
  package.id = 'edi.280.2'
)

