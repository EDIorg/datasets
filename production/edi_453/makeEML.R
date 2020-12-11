# This script executes an EMLassemblyline workflow.

library(EMLassemblyline)
library(dplyr)
library(tidyr)
library(stringr)

file_path <- "."

file_names <- c('EDI_data_zooplankton.csv')

dataset_title <- 'Zooplankton paired night and day density and biomass estimates, worldwide literature survey, 1900 - 2016'

file_descriptions <- c('Zooplankton paired night and day density and biomass estimates')

quote_character <- rep("\"",1)

temp_cov <- c('1900-01-01', '2016-12-13')

maint_desc <- "completed"

user_id <- "EDI"

package_id <- "edi.453.1"

#geographic information
#use either this description or a .txt file generated below
#make sure these two paramters are then taken out of make_eml

geog_descr <- 'Worldwide'

coord_south <- -78.0
coord_east <- 180.0
coord_north <- 78.0
coord_west <- -180.0

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

template_taxonomic_coverage(
  path = file_path,
  data.path = file_path,
  taxa.table = 'taxa.csv',
  taxa.col = 'taxa',
  taxa.authority = c(3,11),
  taxa.name.type = 'both'
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
  data.table.description = file_descriptions,
  data.table.quote.character = quote_character,
  user.id = 'edi',
  user.domain = 'EDI',
  package.id = package_id
)
