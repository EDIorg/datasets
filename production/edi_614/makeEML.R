# This script executes an EMLassemblyline workflow.

library(EMLassemblyline)

#these libraries are helpful but not necessary to run EMLassemblyline
library(dplyr)
library(tidyr)
library(stringr)

file_path <- "."

dataset_title <- 'Temperature datasets for stock tanks and natural sites at High, Medium, and Low elevations, as part of the LTREB Swordtail project in Hidalgo, Mexico, 2015 - 2025'

file_names <- c('Natural_Sites.csv',
                'Stock_Tanks.csv')

file_labels <- c('temperature at natural sites',
                 'temperature at stock tanks')

file_descriptions <- c('hobo temperature recordings at natural sites',
                       'hobo temperature recordings at stock tanks')


quote_character <- rep("\"",2)

# other_entity <- c('configurations.zip',
#                   'output.zip',
#                   'Source.zip')
# 
# other_entity_name <- c('all configuration files',
#                        'output netCDF file',
#                        'model source code')
# 
# other_entity_description <- c('glm3 - Model configuration, aed2 - Water quality configuration, aed2_phyto_pars_NEW_30Jan19 - Phytoplankton configuration',
#                               'output in netCDF format',
#                               'GLM-AED General Lake Model Aquatic Ecodynamics source code')

temp_cov <- c('2015', '2025')

maint_desc <- "ongoing"

user_id <- "edi"

user_domain <- "EDI"

package_id <- "edi.614.1"

#geographic information
#use either this description or a .txt file generated via geographic template

# geog_descr <- 'middle Loire River (France)'
# 
# coord_south <- 46.99
# coord_east <- 3.06
# coord_north <- 47.86
# coord_west <- 1.80
# 
# geog_coord <- c(coord_north, coord_east, coord_south, coord_west)

#generate templates
template_geographic_coverage(
  path = '.',
  data.path = '.',
  data.table = 'sites.csv',
  site.col = 'site_name',
  lat.col = 'site_lat',
  lon.col = 'site_lon'
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

# edit the attribute templates first before running categorical variables template

template_categorical_variables(
  path = file_path,
  data.path = file_path
)

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
  #geographic.description = geog_descr,
  #geographic.coordinates = geog_coord,
  maintenance.description = maint_desc,
  data.table = file_names,
  data.table.name = file_labels,
  data.table.description = file_descriptions,
  data.table.quote.character = quote_character,
  #other.entity = other_entity,
  #other.entity.name = other_entity_name,
  #other.entity.description = other_entity_description,
  user.id = user_id,
  user.domain = user_domain,
  package.id = package_id
)

