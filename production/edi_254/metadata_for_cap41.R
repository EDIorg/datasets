# This script validates and creates EML for a set of ecocomDP tables
# Level-0 = knb-lter-cap.41.x
# Level-1 = edi.254.x


# Initialize workspace --------------------------------------------------------

rm(list = ls())
library(ecocomDP)
path <- "C:\\Users\\Colin\\Downloads\\knb-lter-cap-41"
parent_pkg_id <- 'knb-lter-cap.41.14'
child_pkg_id <- 'edi.254.1'

# Create ecocomDP -------------------------------------------------------------

convert_tables(
  path = path,
  parent_pkg_id = parent_pkg_id,
  child_pkg_id = child_pkg_id
  )

# Read data tables ------------------------------------------------------------
# For easy exploration and trouble shooting.

criteria <- read.table(
  system.file('validation_criteria.txt', package = 'ecocomDP'),
  header = T,
  sep = "\t",
  as.is = T,
  na.strings = "NA")

L1_table_names <- criteria$table[is.na(criteria$column)]

file_names <- validate_table_names(
  data.path = path,
  criteria = criteria
  )

data.list <- lapply(file_names, read_ecocomDP_table, data.path = path)

names(data.list) <- unlist(lapply(file_names, is_table_rev, L1_table_names))

# Validate tables -------------------------------------------------------------
# Correct each error and rerun until no more errors occur.

ecocomDP::validate_ecocomDP(
  data.path = path
  )

# Define categorical variables ------------------------------------------------

ecocomDP::define_variables(
  data.path = data.path,
  sep = ','
)

# Make EML --------------------------------------------------------------------

ecocomDP::make_eml(
  data.path = path,
  code.path = path,
  parent.package.id = parent_pkg_id,
  child.package.id = child_pkg_id,
  sep = ',',
  user.id = 'csmith',
  affiliation = 'LTER',
  intellectual.rights = 'CC0',
  datetime.format = 'YYYY-MM-DDThh:mm:ss',
  code.file.extension = '.R'
)
