# This script executes an EMLassemblyline workflow.

library(EMLassemblyline)
library(dplyr)
library(tidyr)
library(stringr)

file_path <- "."

file_names <- c('weedcropdat.csv')

dataset_title <- 'Responses of agricultural weed community in a corn-soybean intercrop'

file_descriptions <- c('Data on characteristics of the weed community and of the crops under different fertilization and crop type treatments.')

quote_character <- rep("\"",1)

temp_cov <- c('1993-06-30', '1998-12-31')

maint_desc <- "completed"

user_id <- "EDI"

package_id <- "edi.536.1"

#geographic information
#use either this description or a .txt file generated below
#make sure these two paramters are then taken out of make_eml

geog_descr <- 'W.K. Kellogg Biological Station, Michigan State University, Michigan, USA'

coord_south <- 42.420265
coord_east <- -85.366857
coord_north <- 42.420265
coord_west <- -85.366857

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
