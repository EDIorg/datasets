# This file is for you to script out your operations on the assembly line
# thus making it easier to reproduce your work and trouble shoot any issues
# that may arise.

library(EMLassemblyline)

# Import templates

import_templates(
  path = "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\Shaoda_USGS_water_quality",
  license = "CC0",
  data.files = c(
    'coor_sites',
    'HUC',
    'lm_vQ',
    'NHDplus_slopeSO',
    'water_quality',
    'watersheds_area'
    )
  )

# Make EML

make_eml(
  path = 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\Shaoda_USGS_water_quality',
  dataset.title = 'Water quality measurements, stream order, channel slope and hydraulic equations of conterminous USGS sites: 1919-2009.',
  data.files = c(
    'coor_sites',
    'HUC',
    'lm_vQ',
    'NHDplus_slopeSO',
    'water_quality',
    'watersheds_area'
  ),
  data.files.description = c(
    'Site coordinates',
    'USGS Hydrologic Unit Code (HUC) information',
    'Hydraulic geometry equations',
    'Site stream order and slope information',
    'Water quality',
    'Watershed area'
  ),
  temporal.coverage = c(
    '1919-05-31',
    '2009-07-02'),
  geographic.coordinates = c(
    50,
    -66.5,
    25,
    -125
    ),
  geographic.description = 'Conterminous United States',
  maintenance.description = 'Completed',
  user.id = 'csmith',
  affiliation = 'LTER',
  package.id = 'edi.116.1'
  )
