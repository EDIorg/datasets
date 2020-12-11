library(EMLassemblyline)
library(dplyr)
library(tidyr)
library(stringr)

file_path <- "."

file_names <- c('Centaurea_Pres.csv',
                'data.adk.csv',
                'data.li.csv',
                'df.csv')

#better_names <- c('')

dataset_title <- 'The influence of environmental factors on the distribution and density of invasive Centaurea stoebe across Northeastern USA, 2013 - 2018'

file_descriptions <- c('Sites in the Northeastern United States where C. stoebe presence was reported or found by the authors',
                       'Environmental data for study sites in the Adirondacks',
                       'Environmental data for study sites on Long Island',
                       'Environmental data for Northeastern United States')

quote_character <- rep("\"",4)

# other_entity <- c('WRF_output_variables.txt',
#                   'protocol.pdf')
# 
# other_entity_description <- c('output variables',
#                               'formatted methods description')

temp_cov <- c('2013', '2018')

maint_desc <- "completed"

user_id <- "EDI"

user_domain <- 'EDI'

package_id <- "edi.584.1"

#geographic information
#use either this description or a .txt file generated below
#make sure these two paramters are then taken out of make_eml

geog_descr <- 'Northeastern parts of United States of America, including the states of Pennsylvania, New York, New Jersey, Vermont, Maine, Connecticut, Massachusetts, New Hampshire, and Rhode Island'

coord_south <- 39.5818  
coord_east <- -67.9247
coord_north <- 45.0124
coord_west <- -80.6077

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

#get taxon names

# df <- read.csv('phytobenthos_EDI.csv', header = T, as.is = T)
# df_taxon <- distinct(df, taxa)
# write.csv(df_taxon, file = 'taxon.csv', row.names = F)

template_taxonomic_coverage(
  path = file_path,
  data.path = file_path,
  taxa.table = 'taxon.csv',
  taxa.col = 'taxon',
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
  maintenance.description = maint_desc,
  data.table = file_names,
  #data.table.name = better_names,
  data.table.description = file_descriptions,
  data.table.quote.character = quote_character,
  #data.table.url = c('https://lter.limnology.wisc.edu/sites/default/files/data_to_edi/SnowCyclone_manifest.csv'),
  #other.entity = other_entity,
  #other.entity.description = other_entity_description,
  #other.entity.url = c('https://lter.limnology.wisc.edu/sites/default/files/data_to_edi/WRF_output_variables.txt',
  #                     'https://lter.limnology.wisc.edu/sites/default/files/data_to_edi/protocol.pdf'),
  user.id = user_id,
  user.domain = user_domain,
  package.id = package_id
)
