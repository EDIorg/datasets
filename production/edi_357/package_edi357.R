# This script converts the parent data package edi.291 into the
# ecocomDP tables, validates the tables, defines categorical variables and
# creates EML for the ecocomDP tables.

# Load dependencies

library(ecocomDP)

# Arguments

path <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\ecocomDP\\edi_357'
parent_pkg_id <- 'edi.291.1'
child_pkg_id <- 'edi.357.1'

# Convert to ecocomDP

message('Creating ecocomDP tables')

convert_edi291_to_ecocomDP(path, parent_pkg_id, child_pkg_id)

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

use_i <- catvars$code == 'Percent cover'
catvars$definition[use_i] <- 'Percent coverage of taxa'
catvars$unit[use_i] <- 'percent'

use_i <- catvars$code == 'Actual temporal resolution'
catvars$definition[use_i] <- 'Actual temporal resolution of observations were YYYY but changed to YYYY-MM-DD to accord with the temporal resolution of this dataset. Day and month were assigned arbitrary values 1 and 1 repectively'
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
  code.files = c('convert_edi291_to_ecocomDP.R', 'package_edi357.R'),
  parent.package.id = parent_pkg_id,
  child.package.id = child_pkg_id,
  sep = ',',
  cat.vars = catvars,
  user.id = 'csmith',
  affiliation = 'LTER',
  additional.contact = additional_contact
)
