# This script executes an EMLassemblyline workflow.

library(EMLassemblyline)
library(dplyr)
library(tidyr)
library(stringr)

file_path <- "."

file_names <- c('myosotis_mass.csv')

dataset_title <- 'Plant size and spatial pattern in a natural population of Myosotis micrantha'

file_descriptions <- c('Mass and position of individual plants')


quote_character <- rep("\"",1)

temp_cov <- c('1988', '1995')

maint_desc <- "completed"

user_id <- "EDI"

package_id <- "edi.541.1"

#geographic information
#use either this description or a .txt file generated below
#make sure these two paramters are then taken out of make_eml

geog_descr <- 'Campus of Stony Brook University (located in Stony Brook, New York, USA)'

coord_south <- 40.871370
coord_east <- -73.101073
coord_north <- 40.924310
coord_west <- -73.157378

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


template_taxonomic_coverage(
  path = file_path,
  data.path = file_path,
  taxa.table = 'taxon.csv',
  taxa.col = 'taxon',
  taxa.authority = c(3,11),
  taxa.name.type = 'scientific'
)

make_eml(
  path = file_path,
  data.path = file_path,
  eml.path = file_path,
  dataset.title = dataset_title,
  temporal.coverage = temp_cov,
  geographic.description = geog_descr,
  geographic.coordinates = geog_coord,
  maintenance.description = maint_desc,
  data.table = file_names,
  data.table.description = file_descriptions,
  data.table.quote.character = quote_character,
  #other.entity = 'protocol.pdf',
  #other.entity.description = 'methods used for this study',
  user.id = 'edi',
  user.domain = 'EDI',
  package.id = package_id
)
