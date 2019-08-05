
# This script converts the parent data package knb-lter-vcr.70 into the
# ecocomDP tables, validates the tables, defines categorical variables and
# creates EML for the ecocomDP tables.

# Load dependencies

library(ecocomDP)

# Arguments

path <- '/Users/csmith/Documents/EDI/datasets/ecocomDP/edi_323'
parent_pkg_id <- 'knb-lter-vcr.70.24'
child_pkg_id <- 'edi.323.1'

# Convert knb-lter-vcr.70.x to ecocomDP

message('Creating ecocomDP tables')

convert_vcr70_to_ecocomDP(path, parent_pkg_id, child_pkg_id)

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

use_i <- catvars$code == 'Biomass'
catvars$definition[use_i] <- 'Above ground biomass'
catvars$unit[use_i] <- 'gramsPer0.25MetersSquared'

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
  code.files = c('convert_vcr70_to_ecocomDP.R', 'package_edi323.R'),
  parent.package.id = parent_pkg_id,
  child.package.id = child_pkg_id,
  sep = ',',
  cat.vars = catvars,
  user.id = 'csmith',
  affiliation = 'LTER',
  additional.contact = additional_contact
)

