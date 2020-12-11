# This script executes an EMLassemblyline workflow.

library(EMLassemblyline)
library(dplyr)
library(tidyr)
library(stringr)

file_path <- "."

file_names <- c('EDI_Data_Metadata_JumpingWorms.csv')

dataset_title <- 'Madison community science field campaign to assess abundance and distribution of invasive jumping worms.'

file_descriptions <- c('Individual counts of different jumping worm species')

quote_character <- rep("\"",1)

temp_cov <- c('2017-09-10', '2017-09-10')

maint_desc <- "completed"

user_id <- "NTL"

package_id <- "knb-lter-ntl.387.1"

#geographic information
#use either this description or a .txt file generated below
#make sure these two paramters are then taken out of make_eml

geog_descr <- 'City of Madison, Wisconsin, USA'

coord_south <- 43.011288
coord_east <- -89.268166
coord_north <- 43.156871
coord_west <- -89.518760

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
  maintenance.description = 'completed',
  data.table = file_names,
  data.table.description = file_descriptions,
  data.table.quote.character = quote_character,
  #other.entity = 'QRF_script.R',
  #other.entity.description = 'R code which builds a quantile regression forest model using observational chloride data and predictor variables found in lakeCL_trainingData.csv',
  user.id = 'ntl',
  user.domain = 'NTL',
  package.id = package_id
)
