# This script executes an EMLassemblyline workflow.

library(EMLassemblyline)
library(dplyr)
library(tidyr)
library(stringr)

file_path <- "."

file_names <- c('Hall_etal_Ecology_2020_Soil_Respiration_Isotope_Data.csv')

dataset_title <- 'Respiration, isotope composition, and carbon source partitioning from incubations of soil amended with litter and isotope-labeled lignin'

file_descriptions <- c('Respiration, isotope composition, and carbon source partitioning data and incubations treatments')

quote_character <- rep("\"",1)

temp_cov <- c('2017-02-01', '2019-02-28')

maint_desc <- "completed"

user_id <- "EDI"

package_id <- "edi.519.2"

#geographic information
#use either this description or a .txt file generated below
#make sure these two paramters are then taken out of make_eml

geog_descr <- '10 forest soils collected across North America'

coord_south <- 18.28
coord_east <- -65.79
coord_north <- 49.05
coord_west <- -125.68

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
