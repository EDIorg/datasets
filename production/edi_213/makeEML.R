# This script executes an EMLassemblyline workflow.

library(EMLassemblyline)
library(dplyr)
library(tidyr)
library(stringr)

file_path <- "."

file_names <- list.files(path = file_path, pattern = "*.csv")

dataset_title <- "Distribution and abundance of canopy trees in floodplain forests of the Wisconsin River 1999 - 2001"

file_descriptions <- c("Wisconsin River Floodplain project plot variables.",
                       'Species code definitions',
                       "Tree measurement data")

quote_character <- rep("\"",3)

temp_cov <- c("1999-01-01","2001-12-31")

maint_desc <- "completed"

user_id <- "EDI"

package_id <- "edi.213.1"

#geographic information
#use either this description or a .txt file generated below
#make sure these two paramters are then taken out of make_eml

geog_descr <- "Wisonsin River, Wisconsin, USA."

coord_north <- 45.891
coord_west <- -91.932
coord_south <- 43.013
coord_east <- -89.205

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

template_geographic_coverage(
  path = file_path,
  data.path = file_path,
  data.table = 'sites_lat_long.csv',
  site.col = 'Site',
  lat.col = 'Lat',
  lon.col = 'Long'
)

template_taxonomic_coverage(
  path = file_path,
  data.path = file_path,
  taxa.table = 'WIRF_SpeciesCodes.csv',
  taxa.col = 'Scientific_name',
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

