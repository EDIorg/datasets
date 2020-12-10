# This script executes an EMLassemblyline workflow.

library(EMLassemblyline)
library(dplyr)
library(tidyr)
library(stringr)

file_path <- "."

file_names <- c('2000_experiment.csv',
                '2003_experiment.csv')

dataset_title <- 'Effects of experimental manipulation of light and nutrients on establishment of seedlings of native and invasive woody species in Long Island, NY, USA forests 2000 - 2003'

file_descriptions <- c('Data from the experiments conducted in 2000. Each row represents an individual plant used in the experiment.',
                       'Data from the experiments conducted in 2003. Each row represents an individual plant used in the experiment.')

quote_character <- rep("\"",2)

temp_cov <- c('2000-03-10', '2003-08-27')

maint_desc <- "completed"

user_id <- "EDI"

package_id <- "edi.537.1"

#geographic information
#use either this description or a .txt file generated below
#make sure these two paramters are then taken out of make_eml

geog_descr <- 'Long Island, New York, USA'

coord_south <- 40.85227
coord_east <- -72.6449
coord_north <- 40.9429
coord_west <- -73.21052

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
