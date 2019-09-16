# This script executes an EMLassemblyline workflow.

library(EMLassemblyline)
library(dplyr)
library(tidyr)
library(stringr)

file_path <- "."

file_names <- c('SwanLake_SpatialRaw_EDI.csv')

dataset_title <- 'Hypereutrophic lake spatial sensor data during summer bloom, Swan Lake, Iowa, USA 2018'

file_descriptions <- c('Weekly measurements of parameters in 65 meter grid across the entire lake')

quote_character <- rep("\"",1)

temp_cov <- c("2018-05-15", "2018-09-21")

maint_desc <- "completed"

user_id <- "EDI"

package_id <- "edi.420.1"

#geographic information
#use either this description or a .txt file generated below
#make sure these two paramters are then taken out of make_eml

geog_descr <- "Swan Lake in Iowa, USA."

coord_south <- 42.03439384
coord_east <- -94.83860214
coord_north <- 42.04083023
coord_west <- -94.85042648

geog_coord <- c(coord_north, coord_east, coord_south, coord_west)


template_core_metadata(
  path = file_path,
  license = 'CCBY'
)


# romove that stupid special character at the beginning of the file
# 
# df <- read.csv('VegCoverDataRMBL2014.csv')
# 
# colnames(df)[colnames(df)=="ï..Gradient"] <- "Gradient"
# 
# write.csv(df, file = 'VegCoverDataRMBL2014.csv', row.names = F)

template_table_attributes(
  path = file_path,
  data.path = file_path,
  data.table = file_names
)

template_categorical_variables(
  path = file_path,
  data.path = file_path
)

# template_geographic_coverage(
#   path = file_path,
#   data.path = file_path,
#   data.table = 'sites_lat_long.csv',
#   site.col = 'Site',
#   lat.col = 'Lat',
#   lon.col = 'Long'
# )
# 

# df <- read.csv('taxonInfo.csv', header = T, as.is = T)
# df <- distinct(df, taxon_name)
# write.csv(df, file = 'taxonInfo.csv', row.names = F)
# 
# template_taxonomic_coverage(
#   path = file_path,
#   data.path = file_path,
#   taxa.table = 'taxonInfo.csv',
#   taxa.col = 'taxon_name',
#   taxa.authority = c(3,11),
#   taxa.name.type = 'both'
# )

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
  user.id = 'edi',
  user.domain = 'EDI',
  package.id = package_id
)
