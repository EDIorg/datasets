# This script converts the parent data package knb-lter-pie.405 into the
# ecocomDP tables, validates the tables, defines categorical variables and
# creates EML for the ecocomDP tables.

# Load dependencies

library(ecocomDP)

# Arguments

path <- 'C:/Users/Colin/Documents/EDI/data_sets/ecocomDP/edi_337'
parent_pkg_id <- 'knb-lter-pie.405.1'
child_pkg_id <- 'edi.337.1'

# Convert to ecocomDP

message('Creating ecocomDP tables')

convert_pie405_to_ecocomDP(path, parent_pkg_id, child_pkg_id)

# Validate ecocomDP tables

message('Validating ecocomDP tables')

ecocomDP::validate_ecocomDP(
  data.path = path
)

# Define variables found in the ecocomDP tables

message('Defining ecocomDP variables')

catvars <- ecocomDP::define_variables(
  data.path = path,
  parent.pkg.id = parent_pkg_id
)

use_i <- catvars$code == 'SAMPLE.NAME'
catvars$definition[use_i] <- 'Zooplankton specific subsample name'

use_i <- catvars$code == 'COUNT.START'
catvars$definition[use_i] <- 'count of flowmeter revolutions marking starting point of net tow'
catvars$unit[use_i] <- 'number'

use_i <- catvars$code == 'COUNT.END'
catvars$definition[use_i] <- 'count of flowmeter revolutions marking end point of net tow'
catvars$unit[use_i] <- 'number'

use_i <- catvars$code == 'COUNT.DIFF'
catvars$definition[use_i] <- 'difference in start and end counts on flowmeter, used to calculate volume'
catvars$unit[use_i] <- 'number'

use_i <- catvars$code == 'TOW.TIME'
catvars$definition[use_i] <- 'duration of tow (sec)'
catvars$unit[use_i] <- 'second'

use_i <- catvars$code == 'SIZE.FRACTION'
catvars$definition[use_i] <- 'either > 150µ or > 335µ size classes'

use_i <- catvars$code == 'SUBSAMPLE.FRAC'
catvars$definition[use_i] <- 'fraction of entire sample volume counted'
catvars$unit[use_i] <- 'dimensionless'

use_i <- catvars$code == 'NUMBER.COUNTED'
catvars$definition[use_i] <- 'number of individuals counted in subsample'
catvars$unit[use_i] <- 'number'

use_i <- catvars$code == 'STATION.NAME.KM'
catvars$definition[use_i] <- 'station name indicating distance upstream from mouth of Plum Island Sound (km 0)'

# Add contact information for the creator of this script

additional_contact <- data.frame(
  givenName = 'Colin',
  surName = 'Smith',
  organizationName = 'Environmental Data Initiative',
  electronicMailAddress = 'colin.smith@wisc.edu',
  stringsAsFactors = FALSE
)

# Make EML

message('Creating EML')

ecocomDP::make_eml(
  data.path = path,
  code.path = path,
  code.files = c('convert_pie405_to_ecocomDP.R', 'package_edi337.R'),
  parent.package.id = parent_pkg_id,
  child.package.id = child_pkg_id,
  sep = ',',
  cat.vars = catvars,
  user.id = 'csmith',
  affiliation = 'LTER',
  additional.contact = additional_contact
)
