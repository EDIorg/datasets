# This script uses EMLassemblyline and taxonomyCleanr to create EML metadata
# for archive in the Environmental Data Initiative Data Repository.
#
# EMLassemblyline installation and use instructions are on GitHub:
# https://github.com/EDIorg/EMLassemblyline
#
# taxonomyCleanr installation and use instructions are on GitHub:
# https://github.com/EDIorg/taxonomyCleanr

# Initialize workspace

rm(list = ls())
library(EMLassemblyline)
library(taxonomyCleanr)

# Parameterize functions

path <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\villanova_peatland_group\\edi_371\\metadata_templates'
data.path <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\villanova_peatland_group\\edi_371\\data'
eml.path <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\villanova_peatland_group\\edi_371\\eml'

# Import metadata templates

EMLassemblyline::import_templates(
  path = path,
  data.path = data.path,
  data.files = 'Sphagnum_fuscum_cranked_wire_data.csv',
  license = 'CC0'
)

# Import template for defining categorical variables used in the dataset

EMLassemblyline::define_catvars(
  path = path,
  data.path = path
)

# Use taxonomyCleanr R library to resolve taxa to ITIS and create the 
# taxonomicCoverage EML node. This is not required by EMLassemblyline, rather
# it is a value added step for making the dataset findable when searching on
# taxonomic rank.

d <- taxonomyCleanr::resolve_sci_taxa(
  data.sources = '3',
  x = c('Sphagnum fuscum')
)

taxonomyCleanr::make_taxonomicCoverage(
  taxa.clean = d$taxa_clean,
  authority = d$authority,
  authority.id = d$authority_id,
  path = path
)

# Render content of the metadata templates and taxonomicCoverage.xml into an 
# EML file for archive along with the dataset.

EMLassemblyline::make_eml(
  path = path,
  data.path = data.path,
  eml.path = eml.path,
  dataset.title = 'Sphagnum fuscum Growth under Increasing Nitrogen Additions as Measured by the Cranked Wire Method, 2011-2015',
  data.files = 'Sphagnum_fuscum_cranked_wire_data.csv',
  data.files.description = 'Sphagnum fuscum Cranked Wire Data',
  temporal.coverage = c('2011-05-31', '2015-09-20'),
  geographic.description = 'Alberta, Canada, 100 km south of Fort McMurray, Canada',
  geographic.coordinates = c('55.895', '-112.094','55.895', '-112.094'),
  maintenance.description = 'completed',
  user.id = c('csmith', 'wiederlab'),
  affiliation = c('LTER','EDI'),
  package.id = 'edi.371.1'
)


