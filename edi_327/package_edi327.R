
# This script converts the parent data package knb-lter-sgs.136 into the
# ecocomDP tables, validates the tables, defines categorical variables and
# creates EML for the ecocomDP tables.

# Load dependencies

library(ecocomDP)

# Arguments

path <- 'C:/Users/Colin/Documents/EDI/data_sets/ecocomDP/edi_327'
parent_pkg_id <- 'knb-lter-sgs.136.17'
child_pkg_id <- 'edi.327.1'

# Convert to ecocomDP

message('Creating ecocomDP tables')

convert_sgs136_to_ecocomDP(path, parent_pkg_id, child_pkg_id)

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

use_i <- catvars$code == 'NUMBER'
catvars$definition[use_i] <- 'Number of animals observed'
catvars$unit[use_i] <- 'dimensionless'

use_i <- catvars$code == 'NO.OBSERV'
catvars$definition[use_i] <- 'Number of people counting rabbits'
catvars$unit[use_i] <- 'number'

use_i <- catvars$code == 'OBSERVERS'
catvars$definition[use_i] <- 'Initials of the observers'
catvars$unit[use_i] <- ''

use_i <- catvars$code == 'STARTTIME'
catvars$definition[use_i] <- 'Time observation started'
catvars$unit[use_i] <- ''

use_i <- catvars$code == 'ENDTIME'
catvars$definition[use_i] <- 'Time observation ended'
catvars$unit[use_i] <- ''

use_i <- catvars$code == 'END.MILES'
catvars$definition[use_i] <- 'Mileage at end of observations'
catvars$unit[use_i] <- 'mile'

use_i <- catvars$code == 'ODOM_MI'
catvars$definition[use_i] <- 'Distance along the transect'
catvars$unit[use_i] <- 'mile'

use_i <- catvars$code == 'DISTANCE_M'
catvars$definition[use_i] <- 'Where the rabbit was spotted perpendicular to the road'
catvars$unit[use_i] <- 'meter'

use_i <- catvars$code == 'TIME'
catvars$definition[use_i] <- 'Time species was observed'
catvars$unit[use_i] <- 'dimensionless'

use_i <- catvars$code == 'DIRECTION'
catvars$definition[use_i] <- 'Direction of rabbit off transect'
catvars$unit[use_i] <- ''

use_i <- catvars$code == 'TOPOCODE'
catvars$definition[use_i] <- 'Topography of where species was observed'
catvars$unit[use_i] <- ''

use_i <- catvars$code == 'VEGCODE'
catvars$definition[use_i] <- 'Vegetation of where species was observed'
catvars$unit[use_i] <- ''

use_i <- catvars$code == 'COMMENTS'
catvars$definition[use_i] <- 'Comments and landmarks noted by observers'
catvars$unit[use_i] <- ''

use_i <- catvars$code == 'WEATHER'
catvars$definition[use_i] <- 'Weather conditions during observation'
catvars$unit[use_i] <- ''

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
  code.files = c('convert_sgs136_to_ecocomDP.R', 'package_edi327.R'),
  parent.package.id = parent_pkg_id,
  child.package.id = child_pkg_id,
  sep = ',',
  cat.vars = catvars,
  user.id = 'csmith',
  affiliation = 'LTER',
  additional.contact = additional_contact
)
