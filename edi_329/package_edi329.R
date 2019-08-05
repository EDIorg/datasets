
# This script converts the parent data package knb-lter-sgs.137 into the
# ecocomDP tables, validates the tables, defines categorical variables and
# creates EML for the ecocomDP tables.

# Load dependencies

library(ecocomDP)

# Arguments

path <- 'C:/Users/Colin/Documents/EDI/data_sets/ecocomDP/edi_329'
parent_pkg_id <- 'knb-lter-sgs.137.17'
child_pkg_id <- 'edi.329.1'

# Convert to ecocomDP

message('Creating ecocomDP tables')

convert_sgs137_to_ecocomDP(path, parent_pkg_id, child_pkg_id)

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

use_i <- catvars$code == 'count'
catvars$definition[use_i] <- 'Number of individuals'
catvars$unit[use_i] <- 'number'

use_i <- catvars$code == 'SAMPLE'
catvars$definition[use_i] <- 'Sample'

use_i <- catvars$code == 'SESSION'
catvars$definition[use_i] <- 'Trapping Session'

use_i <- catvars$code == 'VEG'
catvars$definition[use_i] <- 'Vegetation or Habitat'

use_i <- catvars$code == 'NIGHT'
catvars$definition[use_i] <- 'Traps are set for 4 consecutive nights'
catvars$unit[use_i] <- 'dimensionless'

use_i <- catvars$code == 'CAPT'
catvars$definition[use_i] <- 'Captured'

use_i <- catvars$code == 'TAG'
catvars$definition[use_i] <- 'Tag number'

use_i <- catvars$code == 'AGE'
catvars$definition[use_i] <- 'Age of Species'

use_i <- catvars$code == 'SEX'
catvars$definition[use_i] <- 'Sex of Species'

use_i <- catvars$code == 'REPROD'
catvars$definition[use_i] <- 'Reproductive Status'

use_i <- catvars$code == 'WT'
catvars$definition[use_i] <- 'Weight of species'
catvars$unit[use_i] <- 'gram'

use_i <- catvars$code == 'NOTES'
catvars$definition[use_i] <- 'Indicates missing value'

use_i <- catvars$code == 'Stapp.comments'
catvars$definition[use_i] <- 'Comments from PI, Paul Stapp'

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
  code.files = c('convert_sgs137_to_ecocomDP.R', 'package_edi329.R'),
  parent.package.id = parent_pkg_id,
  child.package.id = child_pkg_id,
  sep = ',',
  cat.vars = catvars,
  user.id = 'csmith',
  affiliation = 'LTER',
  additional.contact = additional_contact
)
