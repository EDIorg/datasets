# This script executes an EMLassemblyline workflow.

library(EMLassemblyline)
library(dplyr)
library(tidyr)
library(stringr)

file_path <- "."

file_names <- c('Arizona_dat.csv')

better_names <- c('growth and reproduction data')

dataset_title <- 'Experiment on Competition and the Local Distribution of the Grass Stipa neomexicana, Arizona, 1979 - 1986'

file_descriptions <- c('Data from the removal experiment, on growth and reproduction of focal plants after treatment application.')

quote_character <- rep("\"",1)

temp_cov <- c('1979','1986')

maint_desc <- "completed"

user_id <- "EDI"

package_id <- "edi.532.1"

#geographic information
#use either this description or a .txt file generated below
#make sure these two paramters are then taken out of make_eml

geog_descr <- 'a grassland near Sonoita, Santa Cruz County, Arizona, USA'

coord_south <- 31.610085
coord_east <- -110.461668
coord_north <- 31.731638
coord_west <- -110.799498

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
  taxa.table = 'taxa.csv',
  taxa.col = 'taxa',
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
