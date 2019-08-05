
# This script converts the parent data package knb-lter-vcr.166 into the
# ecocomDP tables, validates the tables, defines categorical variables and
# creates EML for the ecocomDP tables.

# Load dependencies

library(ecocomDP)

# Arguments

path <- 'C:/Users/Colin/Documents/EDI/data_sets/ecocomDP/edi_324'
parent_pkg_id <- 'knb-lter-vcr.166.17'
child_pkg_id <- 'edi.324.1'

# Convert knb-lter-vcr.166.x to ecocomDP

message('Creating ecocomDP tables')

convert_vcr166_to_ecocomDP(path, parent_pkg_id, child_pkg_id)

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

use_i <- catvars$code == 'number_of_pairs'
catvars$definition[use_i] <- 'Number of breeding pairs of herons'
catvars$unit[use_i] <- 'count'

use_i <- catvars$code == 'Comments'
catvars$definition[use_i] <- 'Comment'

use_i <- catvars$code == 'latitude'
catvars$definition[use_i] <- 'UTM coordinate, zone 18 North, WGS84'
catvars$unit[use_i] <- 'meter'

use_i <- catvars$code == 'longitude'
catvars$definition[use_i] <- 'UTM X coordinate, Zone 18 North, WGS84'
catvars$unit[use_i] <- 'meter'

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
  code.files = c('convert_vcr166_to_ecocomDP.R', 'package_edi324.R'),
  parent.package.id = parent_pkg_id,
  child.package.id = child_pkg_id,
  sep = ',',
  cat.vars = catvars,
  user.id = 'csmith',
  affiliation = 'LTER',
  additional.contact = additional_contact
)
