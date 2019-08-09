
# This script performs the following procedures:
# 1. Converts the dataset knb-lter-cap.627 into the ecocomDP
# 2. Validates the ecocomDP tables
# 3. Creates EML for the ecocomDP tables with the package ID edi.192.x
#
# See https://github.com/EDIorg/ecocomDP for more information about the ecocomDP.

# Input arguments:
# data.path - Path to where the ecocomDP tables will be written
# parent_pkg_id - Parent package identifier (e.g. "knb-lter-cap.627.x")
# child_pkg_id - Child package identifier (e.g. "edi.192.x")

data.path <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\thalassa_download\\edi_192_not_uploaded_yet'
parent.pkg.id <- 'knb-lter-cap.627.4'
child.pkg.id <- 'edi.192.3'

# Create ecocomDP tables from parent package ----------------------------------

format_cap627_to_ecocomDP(
  data.path = data.path,
  parent.pkg.id = parent.pkg.id,
  child.pkg.id = child.pkg.id
)

# Validate tables -------------------------------------------------------------

ecocomDP::validate_ecocomDP(
  data.path = data.path
)

# Define categorical variables ------------------------------------------------

# Get variable_names from ecocomDP tables and construct the "cat_vars" object
# for input to the "make_eml" function (below).

criteria <- read.table(
  system.file('validation_criteria.txt', package = 'ecocomDP'),
  header = T,
  sep = "\t",
  as.is = T,
  na.strings = "NA")

L1_table_names <- criteria$table[is.na(criteria$column)]

file_names <- suppressMessages(
  validate_table_names(
    data.path = data.path,
    criteria = criteria
    )
  )

data.list <- lapply(file_names, read_ecocomDP_table, data.path = data.path)

names(data.list) <- unlist(lapply(file_names, is_table_rev, L1_table_names))

cat_vars <- ecocomDP::make_variable_mapping(
  observation = data.list$observation$data,
  observation_ancillary = data.list$observation_ancillary$data,
  taxon_ancillary = data.list$taxon_ancillary$data,
  location_ancillary = data.list$location_ancillary
  )[ , c('variable_name', 'table_name')]

cat_vars$attributeName <- rep('variable_name', nrow(cat_vars))
cat_vars$definition <- NA_character_
cat_vars$unit <- NA_character_

cat_vars <- dplyr::select(
  cat_vars,
  table_name,
  attributeName,
  variable_name,
  definition,
  unit)

colnames(cat_vars) <- c(
  'tableName',
  'attributeName',
  'code', 
  'definition', 
  'unit'
  )

# Get definitions from L0 metadata

# Inputs:
# var.name = (character) variable name
# pkg.id = (character) EDI data package ID (e.g. knb-lter-cap.627.7)
# Outputs:
# Definition, unit
get_var_metadata <- function(var.name, pkg.id){
  scope <- unlist(stringr::str_split(pkg.id, '\\.'))[1]
  identifier <- unlist(stringr::str_split(pkg.id, '\\.'))[2]
  revision <- unlist(stringr::str_split(pkg.id, '\\.'))[3]
  metadata <- xmlParse(paste("http://pasta.lternet.edu/package/metadata/eml",
                             "/",
                             scope,
                             "/",
                             identifier,
                             "/",
                             revision,
                             sep = ""))
  entity_names <- unlist(
    xmlApply(metadata["//dataset/dataTable/entityName"],
             xmlValue)
    )
  
  for (i in 1:length(entity_names)){
    definition <- unlist(
      try(xmlApply(
        metadata[
          paste0("//dataTable[./entityName = '",
                 entity_names[i],
                 "']//attribute[./attributeName = '",
                 var.name,
                 "']//attributeDefinition")],
        xmlValue
        ), silent = TRUE)
      )
    unit <- unlist(
      try(xmlApply(
        metadata[
          paste0("//dataTable[./entityName = '",
                 entity_names[i],
                 "']//attribute[./attributeName = '",
                 var.name,
                 "']//standardUnit")],
        xmlValue
        ), silent = TRUE)
      )
    if (!is.character(definition)){
      definition <- NA_character_
    }
    if (!is.character(unit)){
      unit <- NA_character_
    }
  }
  
  list(
    name = var.name,
    definition = definition,
    unit = unit
    )
  
  
  }

var_metadata <- lapply(
  X = cat_vars$code, 
  FUN = get_var_metadata,
  pkg.id = parent.pkg.id)

#
  



# Provide definitions and units for the variables. 
#
# In most cases units and definitions are supplied by the L0 metadata.
# Find accepted units in the unit dictionary. 
# Open the unit dictionary with the command "EDIutils::view_unit_dictionary()". 
# Search for units and use the value listed under the ID column. NOTE: unit IDs 
# are case sensitive.

# count

# Automate definition extraction ---
fname <- entity_names[str_detect(entity_names, 'site_observations')]
attribute <- 'quantity'
unit <- unlist(
  xmlApply(
    metadata[
      paste0("//dataTable[./entityName = '",
             fname,
             "']//attribute[./attributeName = '",
             attribute,
             "']//attributeDefinition")],
    xmlValue
  )
)
# ---

use_i <- cat_vars$code == 'count'
cat_vars$definition[use_i] <- 'Quantity of the observed taxon'
cat_vars$unit[use_i] <- 'dimensionless'

# time_start

use_i <- cat_vars$code == 'time_start'
cat_vars$definition[use_i] <- 'Plot search start time'
cat_vars$unit[use_i] <- 'dateTime'

# time_end

use_i <- cat_vars$code == 'time_end'
cat_vars$definition[use_i] <- 'Plot search end time'
cat_vars$unit[use_i] <- 'dateTime'

# surveys_notes

use_i <- cat_vars$code == 'surveys_notes'
cat_vars$definition[use_i] <- 'Notes pertaining to a particular observation in or about the plot'
cat_vars$unit[use_i] <- 'NA'

# surveys_observation_notes

use_i <- cat_vars$code == 'surveys_observation_notes'
cat_vars$definition[use_i] <- 'Notes pertaining to a particular specimen observation'
cat_vars$unit[use_i] <- 'NA'

# common_name

use_i <- cat_vars$code == 'common_name'
cat_vars$definition[use_i] <- 'Common name of observed taxon'
cat_vars$unit[use_i] <- 'NA'

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

# Conversion functions called upon by this script -----------------------------