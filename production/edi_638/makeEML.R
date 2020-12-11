# This script executes an EMLassemblyline workflow.

library(EMLassemblyline)
library(dplyr)
library(tidyr)
library(stringr)


file_path <- "."

file_names <- list.files(path = file_path, pattern = '*\\.csv')

table_names <- str_replace_all(file_names, '\\.csv', '')
table_names <- str_replace_all(table_names, '_', ' ' )

dataset_title <- 'Stream temperatures in the upper Little Tennessee and Chattooga River watersheds, Macon County, North Carolina, USA'

file_descriptions <- str_replace(table_names, '^', 'Water temperature in ')
file_descriptions <- str_replace(file_descriptions, 'Water temperature in Stream Temp Site Info', 'Stream Temperature Site information')
file_descriptions <- str_replace(file_descriptions, '\\d\\d\\d\\d \\d\\d \\d\\d', '')

#fix the date format

for (val in file_names) {
  df <- read.csv(val, header = T, as.is = T)
  df$DateTime <- as.POSIXct(df$DateTime, tz = 'EST', '%m/%d/%Y %H:%M')

  write.csv(df, file = val, row.names = F)
}

quote_character <- rep("\"",12)

temp_cov <- c('2020-01-01', '2020-11-21')

maint_desc <- "completed"

user_id <- "EDI"
user_domain = 'EDI'

package_id <- "edi.638.1"

#geographic information
#use either this description or a .txt file generated below
#make sure these two paramters are then taken out of make_eml

geog_descr <- 'The upper Little Tennessee River watershed and the upper Chattooga River watershed, southern Blue Ridge Mountains, Macon County, North Carolina, U.S.A.'

coord_south <- 35.033131
coord_east <- -83.162898
coord_north <- 35.211960
coord_west <- -83.362044

geog_coord <- c(coord_north, coord_east, coord_south, coord_west)

#Template geographic coverage
# template_geographic_coverage(
#   path = file_path,
#   data.path = file_path,
#   data.table = 'geog.csv',
#   site.col = 'site',
#   lat.col = 'latitude',
#   lon.col = 'longitude'
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
  geographic.description = geog_descr,
  geographic.coordinates = geog_coord,
  maintenance.description = maint_desc,
  data.table = file_names,
  data.table.name = table_names,
  data.table.description = file_descriptions,
  data.table.quote.character = quote_character,
  #other.entity = file_names,
  #other.entity.name = table_names,
  #other.entity.description = file_descriptions,
  user.id = user_id,
  user.domain = user_domain,
  package.id = package_id
)
