# This script executes an EMLassemblyline workflow.

library(EMLassemblyline)
library(dplyr)
library(tidyr)
library(stringr)

file_path <- "."

file_names <- c('PDen.csv',
                'PGro.csv',
                'PMor.csv')

better_names <- c('density',
                  'growth rate',
                  'mortality')

dataset_title <- 'The Interaction between Competition and Predation: A Meta‐analysis of Field Experiments'

file_descriptions <- c('Data from experiments which used density as the response variable.',
                       'Data from experiments which used growth rate as the response variable.',
                       'Data from experiments which used mortality as the response variable.')

quote_character <- rep("\"",3)

temp_cov <- c('1979','2000')

maint_desc <- "completed"

user_id <- "EDI"

package_id <- "edi.533.1"

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
  other.entity = 'protocol.pdf',
  other.entity.description = 'Formatted methods',
  user.id = 'edi',
  user.domain = 'EDI',
  package.id = package_id
)
