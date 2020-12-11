# This script executes an EMLassemblyline workflow.

library(EMLassemblyline)
library(dplyr)
library(tidyr)
library(stringr)


file_path <- "."

file_names <- c('micro_macro_contrast_corrected.csv')

table_names <- c('Climate data')

dataset_title <- 'Micro-macro Climate Data for shrubs and artificial shelters in Panoche Hills, California, USA, 2019'

file_descriptions <- c('Temperature, radation and soil moisture data for two sites')

quote_character <- rep("\"",1)

temp_cov <- c('2019-05-20', '2019-06-12')

maint_desc <- "completed"

user_id <- "EDI"
user_domain = 'EDI'

package_id <- "edi.617.1"

#geographic information
#use either this description or a .txt file generated below
#make sure these two paramters are then taken out of make_eml

geog_descr <- 'Panoche Hills Management Area, western edge of the San Joaquin, California, USA'
 
coord_south <- 36.692
coord_east <- -120.790
coord_north <- 36.697
coord_west <- -120.800

geog_coord <- c(coord_north, coord_east, coord_south, coord_west)

# Template geographic coverage
# template_geographic_coverage(
#   path = file_path,
#   data.path = file_path,
#   data.table = 'location.csv',
#   site.col = 'site_name',
#   lat.col = 'site_lat',
#   lon.col = 'site_lon'
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
  maintenance.description = 'completed',
  data.table = file_names,
  data.table.name = table_names,
  data.table.description = file_descriptions,
  data.table.quote.character = quote_character,
  other.entity = 'shelter_open_shrub_comparison.Rmd',
  other.entity.description = 'R markdown codes for analysis.',
  user.id = user_id,
  user.domain = user_domain,
  package.id = package_id
)
