# This script executes an EMLassemblyline workflow.

library(EMLassemblyline)
library(dplyr)
library(tidyr)
library(stringr)

file_path <- "."

file_names <- c('VegCoverDataRMBL2014.csv', 'geographicInfo.csv')

dataset_title <- 'Plant composition data from 67 grassland sites of the Upper Gunnison Basin, CO, USA, 2014'

file_descriptions <- c('visual cover estimates of plant communities',
                       'lat longs for all plots')

quote_character <- rep("\"",2)

temp_cov <- c("2014-06-01","2014-10-31")

maint_desc <- "completed"

user_id <- "EDI"

package_id <- "edi.418.1"

#geographic information
#use either this description or a .txt file generated below
#make sure these two paramters are then taken out of make_eml

geog_descr <- "67 sites within the Upper Gunnison Basin of the Colorado Rocky Mountains, USA."

coord_south <- 38.8475871
coord_east <- -106.777765
coord_north <- 39.0113075
coord_west <- -107.128365

geog_coord <- c(coord_north, coord_east, coord_south, coord_west)


template_core_metadata(
  path = file_path,
  license = 'CCBY'
)


# romove that stupid special characterat the beginning of the file

df <- read.csv('VegCoverDataRMBL2014.csv')

colnames(df)[colnames(df)=="ï..Gradient"] <- "Gradient"

write.csv(df, file = 'VegCoverDataRMBL2014.csv', row.names = F)

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
df <- read.csv('taxonInfo.csv', header = T, as.is = T)
df <- distinct(df, taxon_name)
write.csv(df, file = 'taxonInfo.csv', row.names = F)

template_taxonomic_coverage(
  path = file_path,
  data.path = file_path,
  taxa.table = 'taxonInfo.csv',
  taxa.col = 'taxon_name',
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
  maintenance.description = maint_desc,
  data.table = file_names,
  data.table.description = file_descriptions,
  data.table.quote.character = quote_character,
  user.id = 'edi',
  user.domain = 'EDI',
  package.id = package_id
)
