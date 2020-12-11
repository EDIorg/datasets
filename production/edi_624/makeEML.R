# This script executes an EMLassemblyline workflow.

library(EMLassemblyline)
library(dplyr)
library(tidyr)
library(stringr)


file_path <- "."

file_names <- c('Epilimnion_Derived_Stats.csv',
                'Hypolimnion_Derived_Stats.csv',
                'Lake_information.csv',
                'Meteorological_Data.csv',
                'Secchi.csv')

table_names <- c('Epilimnion Derived Stats',
                 'Hypolimnion Derived Stats',
                 'Lake information',
                 'Meteorological Data',
                 'Secchi')

dataset_title <- 'Widespread deoxygenation of temperate lakes: companion dataset 1980 - 2017'

file_descriptions <- c('Derived statistics for epilimnion',
                       'Derived statistics for hypolimnion',
                       'Lake information and location',
                       'Meteorological data',
                       'Secchi data')

quote_character <- rep("\"",5)

temp_cov <- c('1980', '2017')

maint_desc <- "completed"

user_id <- "EDI"
user_domain = 'EDI'

package_id <- "edi.624.1"

#geographic information
#use either this description or a .txt file generated below
#make sure these two paramters are then taken out of make_eml

geog_descr <- 'Worldwide, but primarily North America and Europe'

coord_south <- -42.6175
coord_east <- 180
coord_north <- 68.2962
coord_west <- -180

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

template_provenance(
  path = file_path
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
  #other.entity = 'shelter_open_shrub_comparison.Rmd',
  #other.entity.description = 'R markdown codes for analysis.',
  provenance = c('knb-lter-ntl.29.25', 
                 'knb-lter-ntl.31.28', 
                 'knb-lter-ntl.38.24',
                 'knb-lter-ntl.35.28',
                 'edi.186.2',
                 'edi.520.1',
                 'knb-lter-arc.10581.4',
                 'knb-lter-arc.10584.4',
                 'knb-lter-arc.10583.4',
                 'knb-lter-arc.10582.3',
                 'edi.256.1',
                 'edi.184.1',
                 'edi.237.1'),
  user.id = user_id,
  user.domain = user_domain,
  package.id = package_id
)
