# This script executes an EMLassemblyline workflow.

library(EMLassemblyline)
library(dplyr)
library(tidyr)
library(stringr)

file_path <- "."

user_id <- "mobrien"
user_domain <- 'EDI'
package_id <- "edi.437.1"

dataset_title <- 'TO DO: Dataset title'

# if more than one, use a quoted, comma-separated list
file_names <- c('Synthesis_Master_2019_Marine.csv')

# if more than one, use a quoted, comma-sep list, same order as file_names
file_descriptions <- c('Synthesis samples from 5 field locations for Synchrony Working Group (LTER)')

# as for file name and description, an array of one per entity. 
# quote_character <- rep("\"",3)
quote_character <- c("\"")

temp_cov <- c("2000-01-01", "2000-01-01")

maint_desc <- "completed"

make_eml(
  path = file_path,
  data.path = file_path,
  eml.path = file_path,
  dataset.title = dataset_title,
  temporal.coverage = temp_cov,
 # geographic.description = geog_descr,
 # geographic.coordinates = geog_coord,
  maintenance.description = maint_desc,
  data.table = file_names,
  data.table.description = file_descriptions,
  data.table.quote.character = quote_character,
  user.id = user_id,
  user.domain = user_domain,
  package.id = package_id
)
