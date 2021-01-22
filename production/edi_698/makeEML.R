# This script executes an EMLassemblyline workflow.

library(EMLassemblyline)
library(dplyr)
library(tidyr)
library(stringr)


file_path <- "."

file_names <- c('Collaborator_Info_Data.csv',
                'Elevation_Data.csv',
                'Hydrolakes_Data.csv',
                'Info_Data.csv',
                'Interpolated_Data.csv',
                'Metadata_Data.csv',
                'Name_Data.csv',
                'Productivity_Data.csv',
                'Raw_Data.csv',
                'Secchi_Data.csv',
                'Use_Data.csv')

table_names <- c('Collaborator Information',
                 'Elevation',
                 'Hydrolakes',
                 'Information',
                 'Interpolated Data',
                 'Metadata',
                 'Lake Names',
                 'Productivity',
                 'Raw Data',
                 'Secchi Depth',
                 'Landuse Use')


dataset_title <- 'Long-term lake dissolved oxygen and temperature data, 1941-2018'

file_descriptions <- c('Information of data contributors, including contact information when available.',
                       'Elevation of most lakes.',
                       'Associated HydroLAKES data.',
                       'Data frame with lake geographic, morphometric data, and general classifications.',
                       'Temperature and dissolved oxygen profile data interpolated to 0.5 m depth intervals.',
                       'Meta data for nutrient and chlorophyll data.',
                       'Data frame containing the name of each lake',
                       'Nutrient and productivity data for a subset of all lakes.',
                       'Raw temperature and dissolved oxygen profile data.',
                       'Water clarity data in the form of Secchi disk depth.',
                       'Watershed land use characteristics for lakes in the USA.')


quote_character <- rep("\"",11)

temp_cov <- c('1941', '2018')

maint_desc <- "completed"

user_id <- "EDI"
user_domain = 'EDI'

package_id <- "edi.698.1"

#geographic information
#use either this description or a .txt file generated below
#make sure these two paramters are then taken out of make_eml

geog_descr <- "Global, but predominately North America and Europe"

coord_south <- -42.6175
coord_east <- 176.4339
coord_north <- 68.2962
coord_west <- -122.384

geog_coord <- c(coord_north, coord_east, coord_south, coord_west)

#Template geographic coverage
# template_geographic_coverage(
#   path = file_path,
#   data.path = file_path,
#   data.table = 'sites.csv',
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

#df_taxa <- read.csv('taxa.csv', header = T, as.is = T)
#df_taxa <- distinct(df_taxa)
#write.csv(df_taxa, file = 'taxa.csv', row.names = F)

# template_taxonomic_coverage(
#   path = file_path,
#   data.path = file_path,
#   taxa.table = 'taxa.csv',
#   taxa.col = 'taxon',
#   taxa.authority = c(3,11),
#   taxa.name.type = 'scientific'
# )

template_provenance(
  path = file_path,
  empty = TRUE,
  write.file = TRUE,
  return.obj = FALSE
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
  data.table.name = table_names,
  data.table.description = file_descriptions,
  data.table.quote.character = quote_character,
  user.id = user_id,
  user.domain = user_domain,
  package.id = package_id
)
