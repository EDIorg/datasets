library(EMLassemblyline)
library(dplyr)
library(tidyr)
library(stringr)

file_path <- "."

file_names <- c('SnowCyclone_manifest.csv')

#better_names <- c('')

dataset_title <- 'Projected Snow Cover Reductions and Mid-latitude Cyclone Responses in the North American Great Plains, 1986 - 2005'

file_descriptions <- c('Manifest file with metadata for off-line netCDF files')

quote_character <- rep("\"",1)

other_entity <- c('WRF_output_variables.txt',
                  'protocol.pdf')

other_entity_description <- c('output variables',
                              'formatted methods description')

temp_cov <- c('1986-01-17', '2005-11-11')

maint_desc <- "completed"

user_id <- "edi"

user_domain <- 'EDI'

package_id <- "edi.580.1"

#geographic information
#use either this description or a .txt file generated below
#make sure these two paramters are then taken out of make_eml

geog_descr <- 'Continental United States (CONUS) and surrounding regions, lambert conformal projection centered at 43.5 N 98 W with resolution of 30 km.'

coord_south <- 19.306 
coord_east <- -46.001
coord_north <- 63.041
coord_west <- -149.991

geog_coord <- c(coord_north, coord_east, coord_south, coord_west)

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
  geographic.description = geog_descr,
  geographic.coordinates = geog_coord,
  maintenance.description = 'completed',
  data.table = file_names,
  #data.table.name = better_names,
  data.table.description = file_descriptions,
  data.table.quote.character = quote_character,
  data.table.url = c('https://lter.limnology.wisc.edu/sites/default/files/data_to_edi/SnowCyclone_manifest.csv'),
  other.entity = other_entity,
  other.entity.description = other_entity_description,
  other.entity.url = c('https://lter.limnology.wisc.edu/sites/default/files/data_to_edi/WRF_output_variables.txt',
                       'https://lter.limnology.wisc.edu/sites/default/files/data_to_edi/protocol.pdf'),
  user.id = user_id,
  user.domain = user_domain,
  package.id = package_id
)
