# This script converts the parent data package knb-lter-pie.33 into the
# ecocomDP tables, validates the tables, defines categorical variables and
# creates EML for the ecocomDP tables.

# Load dependencies

library(ecocomDP)

# Arguments

path <- 'C:/Users/Colin/Documents/EDI/data_sets/ecocomDP/edi_335'
parent_pkg_id <- 'knb-lter-pie.33.16'
child_pkg_id <- 'edi.335.1'

# Convert to ecocomDP

message('Creating ecocomDP tables')

convert_pie33_to_ecocomDP(path, parent_pkg_id, child_pkg_id)

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

use_i <- catvars$code == 'biomass'
catvars$definition[use_i] <- 'Biomass of live taxa (dry weight)'
catvars$unit[use_i] <- 'gramPerMeterSquared'

use_i <- catvars$code == 'LIVE.biomass'
catvars$definition[use_i] <- 'Biomass of all live vegitation (dry weight)'
catvars$unit[use_i] <- 'gramPerMeterSquared'

use_i <- catvars$code == 'DEAD.biomass'
catvars$definition[use_i] <- 'Biomass of all dead vegitation (dry weight)'
catvars$unit[use_i] <- 'gramPerMeterSquared'

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
  code.files = c('convert_pie33_to_ecocomDP.R', 'package_edi335.R'),
  parent.package.id = parent_pkg_id,
  child.package.id = child_pkg_id,
  sep = ',',
  cat.vars = catvars,
  user.id = 'csmith',
  affiliation = 'LTER',
  additional.contact = additional_contact
)
