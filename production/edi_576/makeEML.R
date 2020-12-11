library(EMLassemblyline)
library(dplyr)
library(tidyr)
library(stringr)

file_path <- "."

file_names <- c('LTREB_1998-2018_to_EDI.csv')

better_names <- c('hare recapture data')

dataset_title <- 'Snowshoe Hare Mark-Recapture Trapping Data from western Montana Summer 1998-2018'

file_descriptions <- c('Snowshoe Hare Mark-Recapture Trapping Data')

quote_character <- rep("\"",1)

#other_entity <- c('')

#other_entity_description <- c('')

temp_cov <- c('1998-05-21', '2018-08-15')

maint_desc <- "ongoing"

user_id <- "edi"

user_domain <- "EDI"

package_id <- "edi.576.1"

#geographic information
#use either this description or a .txt file generated below
#make sure these two paramters are then taken out of make_eml

# geog_descr <- 'North America'
# 
# coord_south <- 18
# coord_east <- -65
# coord_north <- 69
# coord_west <- -150
# 
# geog_coord <- c(coord_north, coord_east, coord_south, coord_west)

# template_geographic_coverage(
#   path = file_path,
#   data.path = file_path,
#   data.table = 'geogr.csv',
#   site.col = 'site_name',
#   lat.col = 'site_lat',
#   lon.col = 'site_long'
# )

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

# template_taxonomic_coverage(
#   path = file_path,
#   data.path = file_path,
#   taxa.table = 'taxon.csv',
#   taxa.col = 'taxon',
#   taxa.authority = c(3,11),
#   taxa.name.type = 'scientific'
# )

make_eml(
  path = file_path,
  data.path = file_path,
  eml.path = file_path,
  dataset.title = dataset_title,
  temporal.coverage = temp_cov,
  #geographic.description = geog_descr,
  #geographic.coordinates = geog_coord,
  maintenance.description = maint_desc,
  data.table = file_names,
  data.table.name = better_names,
  data.table.description = file_descriptions,
  data.table.quote.character = quote_character,
  #other.entity = other_entity,
  #other.entity.description = other_entity_description,
  user.id = user_id,
  user.domain = user_domain,
  package.id = package_id
)
