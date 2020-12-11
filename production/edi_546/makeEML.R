# This script executes an EMLassemblyline workflow.

library(EMLassemblyline)

#these libraries are helpful but not necessary to run EMLassemblyline
library(dplyr)
library(tidyr)
library(stringr)

#------------------------------------------------------------
# parameters to enter directly into the R script that do not go into templates

file_path <- "."

dataset_title <- 'The Interaction between Soil Nutrients and Leaf Loss during Early Establishment in Plant Invasion, 2004'

file_names <- c('Growth_and_damage_2004.csv')

file_labels <- c('Growth and damage 2004')

file_descriptions <- c('Data on growth of, and damage suffered by the study plants during the experiment')


quote_character <- rep("\"",1)

temp_cov <- c('1996', '2007')

maint_desc <- "completed"

user_id <- "EDI"

package_id <- "edi.546.1"

#geographic information
#use either this description or a .txt file generated via geographic template

geog_descr <- 'Long Island, New York, United States of America'

coord_south <- 40.85227
coord_east <- -72.64490
coord_north <- 40.90850
coord_west <- -73.21052

geog_coord <- c(coord_north, coord_east, coord_south, coord_west)


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
  #other.entity = 'protocol.pdf',
  #other.entity.description = 'methods used for this study',
  user.id = 'edi',
  user.domain = 'EDI',
  package.id = package_id
)

