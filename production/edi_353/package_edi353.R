# This script converts the parent data package knb-lter-nin.9 into the
# ecocomDP tables, validates the tables, defines categorical variables and
# creates EML for the ecocomDP tables.

# Load dependencies

library(ecocomDP)

# Arguments

path <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\ecocomDP\\edi_353'
parent_pkg_id <- 'knb-lter-nin.9.1'
child_pkg_id <- 'edi.353.1'

# Convert to ecocomDP

message('Creating ecocomDP tables')

convert_nin9_to_ecocomDP(path, parent_pkg_id, child_pkg_id)

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

use_i <- catvars$code == 'Density'
catvars$definition[use_i] <- 'Total number of taxon per 5 cm of core length'
catvars$unit[use_i] <- 'numberPerFiveCentimeter'

use_i <- catvars$code == 'SAMTIME'
catvars$definition[use_i] <- 'Sample Period'
catvars$unit[use_i] <- ''

use_i <- catvars$code == 'REPLICAT'
catvars$definition[use_i] <- 'Replicate'
catvars$unit[use_i] <- 'dimensionless'

use_i <- catvars$code == 'TSTAGE'
catvars$definition[use_i] <- 'Stage of the tide In this case it is always low tide which is indicated by a zero.'
catvars$unit[use_i] <- ''

use_i <- catvars$code == 'AIRTEMP'
catvars$definition[use_i] <- 'Temperature of the air'
catvars$unit[use_i] <- 'celsius'

use_i <- catvars$code == 'SEDWATER'
catvars$definition[use_i] <- 'Temperature of the Sediment-water interface'
catvars$unit[use_i] <- 'celsius'

use_i <- catvars$code == 'REDOX'
catvars$definition[use_i] <- 'Redox depth'
catvars$unit[use_i] <- 'centimeter'

use_i <- catvars$code == 'COREAREA'
catvars$definition[use_i] <- 'Area of the extracted core'
catvars$unit[use_i] <- 'squareCentimeters'

use_i <- catvars$code == 'COREDIAM'
catvars$definition[use_i] <- 'Diameter of the extracted core'
catvars$unit[use_i] <- 'centimeter'

use_i <- catvars$code == 'SEDVOL'
catvars$definition[use_i] <- 'Volume of sediment'
catvars$unit[use_i] <- 'centimeterCubed'

use_i <- catvars$code == 'COREDEPA'
catvars$definition[use_i] <- 'Depth of the core A'
catvars$unit[use_i] <- 'centimeter'

use_i <- catvars$code == 'COREDEPB'
catvars$definition[use_i] <- 'Depth of the core B'
catvars$unit[use_i] <- 'centimeter'

use_i <- catvars$code == 'COLLECT'
catvars$definition[use_i] <- 'Initials of the collectors name'
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
  code.files = c('convert_nin9_to_ecocomDP.R', 'package_edi353.R'),
  parent.package.id = parent_pkg_id,
  child.package.id = child_pkg_id,
  sep = ',',
  cat.vars = catvars,
  user.id = 'csmith',
  affiliation = 'LTER',
  additional.contact = additional_contact
)
