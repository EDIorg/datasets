# This script executes an EMLassemblyline workflow.

library(EMLassemblyline)
library(dplyr)
library(tidyr)
library(stringr)

file_path <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_535"

file_names <- c('qry_EDI_20mm-catch_10122020.csv', 
                '20mm_Station_file.csv')

dataset_title <- 'Interagency Ecological Program San Francisco Estuary 20mm Survey 1995 - 2020'

file_descriptions <- c('species occurrence data', 
                       'station locations')

quote_character <- rep("\"",2)

temp_cov <- c('1995-04-24', '2020-08-06')

maint_desc <- "ongoing"

user_id <- "EDI"

package_id <- "edi.535.2"

#geographic information
#use either this description or a .txt file generated below
#make sure these two paramters are then taken out of make_eml

geog_descr <- 'Lower Napa River, eastern San Pablo Bay, Carquinez Strait upstream throughout Suisun Bay; San Joaquin River to Stockton, Old and Middle Rivers in the south Delta to West Canal; Sacramento River into the Sacramento Deep-water Ship Channel.'

coord_south <- 37.859
coord_east <- -121.368556
coord_north <- 38.3335
coord_west <- -122.309278

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
  user.id = 'edi',
  user.domain = 'EDI',
  package.id = package_id
)
