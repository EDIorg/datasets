# This script executes an EMLassemblyline workflow.

library(EMLassemblyline)
library(dplyr)
library(tidyr)
library(stringr)

file_path <- "."

file_names <- c('caradonna_rmbl_flowering_phenology_data_EDI.csv', 
                'caradonna_rmbl_interaction_networks_data_EDI.csv')

dataset_title <- 'Temporal variation in plant-pollinator interactions, Rocky Mountain Biological Laboratory, CO, USA, 2013 - 2015 '

file_descriptions <- c('the flowering phenology data ', 
                       'primary plant-pollinator interaction data')

quote_character <- rep("\"",2)

temp_cov <- c('2013-05-01', '2015-09-30')

maint_desc <- "completed"

user_id <- "EDI"

package_id <- "edi.512.1"

#geographic information
#use either this description or a .txt file generated below
#make sure these two paramters are then taken out of make_eml

geog_descr <- 'Gunnison Basin, Colorado, USA'

coord_south <- 37.933364
coord_east <- -106.252863
coord_north <- 39.150357
coord_west <- -107.9038794

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

# get taxonomic names
tn <- read.csv('caradonna_rmbl_interaction_networks_data_EDI.csv', header = T, as.is = T)
tn_plants <- distinct(tn, plant)
tn_pollinators <- distinct(tn, pollinator)
tn_plants <- rename(tn_plants, 'taxon_name' = 'plant')
tn_pollinators <- rename(tn_pollinators, 'taxon_name' = 'pollinator')
tn_all <- rbind(tn_plants, tn_pollinators)

tn_all <- mutate(tn_all, 'taxon' = str_replace(tn_all$taxon_name, '_', ' '))
write.csv(tn_all, file = 'taxon_names.csv', row.names = F)

#edit the taxonomic names to get rid of spp sp and numbers

tn_clean <- read.csv('taxon_names_edited.csv', header = T, as.is = T)
tn_clean <- distinct(tn_clean, taxon)
write.csv(tn_clean, file = 'taxon_names.csv', row.names = F)

template_taxonomic_coverage(
  path = file_path,
  data.path = file_path,
  taxa.table = 'taxon_names.csv',
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
  maintenance.description = 'completed',
  data.table = file_names,
  data.table.description = file_descriptions,
  data.table.quote.character = quote_character,
  #other.entity = 'QRF_script.R',
  #other.entity.description = 'R code which builds a quantile regression forest model using observational chloride data and predictor variables found in lakeCL_trainingData.csv',
  user.id = 'edi',
  user.domain = 'EDI',
  package.id = package_id
)
