# This script creates EML metadata for the IEP dataset:
# "Discrete dissolved oxygen monitoring in the Stockton Deep Water Ship Channel"

# Clear workspace and load required packages ----------------------------------

rm(list = ls())
library(EMLassemblyline)
library(taxonomyCleanr)

# Define arguments used by multiple functions ---------------------------------

path_to_templates <- 'D:\\edi\\DataPackages\\production\\edi_276'
path_to_data <- 'D:\\edi\\DataPackages\\production\\edi_276'
path_to_eml <- 'D:\\edi\\DataPackages\\production\\edi_276'
data_file_names <- c('IEP_DOSDWSC_1997_2018.csv', 'IEP_DOSDWSC_site_locations_latitude_and_longitude.csv')


# Import metadata templates ---------------------------------------------------
# Import metadata templates to be manually filled out according to 
# EMLassemblyline documentation (https://github.com/EDIorg/EMLassemblyline/blob/master/documentation/instructions.md)
# This step only needs to be done once at the beginning of the workflow. 
# Subsequent execution of this function doesn't overwrite your work, but is a
# good practice to comment it out.

EMLassemblyline::import_templates(
  path = path_to_templates,
  data.path = path_to_data,
  data.files = data_file_names,
  license = 'CCBY'
)

# Define categorical variables ------------------------------------------------
# Which variables are considered categorical are listed in the attributes.txt 
# files. This step only needs to be done once, but subsequent execution of this
# function doesn't overwrite your work.

EMLassemblyline::define_catvars(
  path = path_to_templates,
  data.path = path_to_data
)

# Resolve taxa ----------------------------------------------------------------
# Use the taxonomyCleanr R library function to resolve taxa to ITIS and create
# the taxonomicCoverage EML element.

df <- taxonomyCleanr::resolve_sci_taxa(
  data.sources = '3', 
  x = 'Microcystis aeruginosa'
)

taxonomyCleanr::make_taxonomicCoverage(
  taxa.clean = df$taxa_clean,
  authority = df$authority,
  authority.id = df$authority_id,
  path = path_to_templates
)

# Make EML --------------------------------------------------------------------
# Translate information stored in the metadata template files into EML.
# NOTE: The data package identifier needs to increase incrementally with every
# new revision (e.g. next revision of this example would be 'edi.276.2').

EMLassemblyline::make_eml(
  path = path_to_templates,
  data.path = path_to_data,
  eml.path = path_to_eml,
  dataset.title = 'Interagency Ecological Program: Discrete dissolved oxygen monitoring in the Stockton Deep Water Ship Channel, collected by the Environmental Monitoring Program, 1997-2018',
  data.table = data_file_names,
  data.table.description = c('Water quality data from the Stockton Deep Water Ship Channel', 'Geospatial data'),
  temporal.coverage = c('1997-08-04', '2018-11-08'),
  maintenance.description = 'Ongoing',
  user.id = c('iep', 'csmith'),
  user.domain = c('EDI', 'LTER'),
  package.id = 'edi.276.2'
)


