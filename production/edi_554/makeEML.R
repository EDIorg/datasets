# This script executes an EMLassemblyline workflow.

library(EMLassemblyline)

#these libraries are helpful but not necessary to run EMLassemblyline
library(dplyr)
library(tidyr)
library(stringr)

#------------------------------------------------------------
# parameters to enter directly into the R script that do not go into templates

file_path <- "."

dataset_title <- 'Middle Loire River (France) hydrochemistry, biology, and metabolism data, 1980–2018 '

file_names <- c('corbicula_data.csv',
                'macrophyte_data.csv',
                'metabolism_data.csv',
                'solute_data.csv')

file_labels <- c('corbicular data',
                 'Marcophyte data',
                 'metabolism data',
                 'dolute data')

file_descriptions <- c('corbicular data',
                       'Marcophyte data',
                       'metabolism data',
                       'solute data')


quote_character <- rep("\"",4)

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

temp_cov <- c('1980', '2018')

maint_desc <- "completed"

user_id <- "edi"

user_domain <- "EDI"

package_id <- "edi.554.1"

#geographic information
#use either this description or a .txt file generated via geographic template

geog_descr <- 'middle Loire River (France)'

coord_south <- 46.99
coord_east <- 3.06
coord_north <- 47.86
coord_west <- 1.80

geog_coord <- c(coord_north, coord_east, coord_south, coord_west)

#-----------------------------------------------------------------
# fix those European date formats

df <- read.csv('solute_data.csv', header = T, as.is = T)

df$date <- as.Date(df$date, "%d/%m/%Y")

write.csv(df, file = 'solute_data.csv', row.names = F)

#get taxon names

df <- read.csv('macrophyte_data.csv', header = T, as.is = T)

df <- select(df, species)
df <- distinct(df, species)
write.csv(df, file = 'taxon.csv', row.names = F)
#-----------------------------------------------------------------
#generate templates

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


# example for taxonomic coverage, geographic coverage would be similar if 
# generated from csv file of locations

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

