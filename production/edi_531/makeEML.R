# This script executes an EMLassemblyline workflow.

library(EMLassemblyline)
library(dplyr)
library(tidyr)
library(stringr)

file_path <- "."

file_names <- c('mycorrhizae_cost.csv')

better_names <- c('carbon cost of mycorrhizae')

dataset_title <- 'C allocation to the fungus is not a cost to the plant in ectomycorrhizae (a meta-analysis)'

file_descriptions <- c('Data from studies on carbon cost of mycorrhizae to plants')

quote_character <- rep("\"",1)

temp_cov <- c('1990','2011')

maint_desc <- "completed"

user_id <- "EDI"

package_id <- "edi.531.1"

#geographic information
#use either this description or a .txt file generated below
#make sure these two paramters are then taken out of make_eml

geog_descr <- 'Global'

coord_south <- -80
coord_east <- 180
coord_north <- 80
coord_west <- -180

geog_coord <- c(coord_north, coord_east, coord_south, coord_west)

template_core_metadata(
  path = file_path,
  license = 'CCBY'
)


template_table_attributes(
  path = file_path,
  data.path = file_path,
  data.table = file_names
)

template_categorical_variables(
  path = file_path,
  data.path = file_path
)


make_eml(
  path = file_path,
  data.path = file_path,
  eml.path = file_path,
  dataset.title = dataset_title,
  temporal.coverage = temp_cov,
  geographic.description = geog_descr,
  geographic.coordinates = geog_coord,
  maintenance.description = 'completed',
  data.table = file_names,
  data.table.name = better_names,
  data.table.description = file_descriptions,
  data.table.quote.character = quote_character,
  #other.entity = 'protocol.pdf',
  #other.entity.description = 'Formatted methods',
  user.id = 'edi',
  user.domain = 'EDI',
  package.id = package_id
)
