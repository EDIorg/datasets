# This script executes an EMLassemblyline workflow.

library(EMLassemblyline)
library(dplyr)
library(tidyr)
library(stringr)


file_path <- "."

file_names <- c('borer_etal_2020_ncoms_data_years_2_4.csv',
                'borer_etal_2020_ncoms_data_years_5_7.csv',
                'borer_etal_2020_ncoms_data_years_8_10.csv')

table_names <- c('years 2-4',
                 'years 5-7',
                 'years 8-10')

dataset_title <- 'Data from NUTRIENTS CAUSE GRASSLAND BIOMASS TO OUTPACE HERBIVORY 2008 - 2019'

file_descriptions <- c('location, soil N, herbivory and biomass data years 2 - 4',
                       'location, soil N, herbivory and biomass data years 5 - 7',
                       'location, soil N, herbivory and biomass data years 8 - 10')

quote_character <- rep("\"",3)

temp_cov <- c('2008', '2019')

maint_desc <- "completed"

user_id <- "EDI"
user_domain = 'EDI'

package_id <- "edi.625.1"

#get geolocations

df_loc <- read.csv('borer_etal_2020_ncoms_data_years_2_4.csv', header = T, as.is = T)
df_lat_long <- distinct(df_loc, site, latitude, longitude)

write.csv(df_lat_long, file = 'geog.csv', row.names = F)

#geographic information
#use either this description or a .txt file generated below
#make sure these two paramters are then taken out of make_eml

# geog_descr <- 'Worldwide, but primarily North America and Europe'
# 
# coord_south <- -42.6175
# coord_east <- 180
# coord_north <- 68.2962
# coord_west <- -180
# 
# geog_coord <- c(coord_north, coord_east, coord_south, coord_west)

#Template geographic coverage
template_geographic_coverage(
  path = file_path,
  data.path = file_path,
  data.table = 'geog.csv',
  site.col = 'site',
  lat.col = 'latitude',
  lon.col = 'longitude'
)

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
#   taxa.table = 'taxon_names.csv',
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
  data.table.name = table_names,
  data.table.description = file_descriptions,
  data.table.quote.character = quote_character,
  #other.entity = 'shelter_open_shrub_comparison.Rmd',
  #other.entity.description = 'R markdown codes for analysis.',
  user.id = user_id,
  user.domain = user_domain,
  package.id = package_id
)
