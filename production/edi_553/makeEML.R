# This script executes an EMLassemblyline workflow.

library(EMLassemblyline)
library(dplyr)
library(tidyr)
library(stringr)

file_path <- "."

file_names <- c('foodwaste_proportion.csv',
                'foodwaste_disposalrate.csv',
                'data_used.csv')

file_better_names <- c('foodwaste proportion',
                       'foodwaste disposal rate',
                       'datasets used in meta analysis')

dataset_title <- 'Quantification of Food Waste Disposal in the United States: A Meta-Analysis'

file_descriptions <- c('Data on proportion food waste (proportion of MSW that is food waste), taken from studies on municipal food waste generated in the United States, carried out between 1989 and 2013.',
                       'Data on food waste disposal rate (weight of food waste produced per person per day), taken from studies on municipal food waste generated in the United States, carried out between 1989 and 2013.',
                       'list of datasets used in meta anlysis')


quote_character <- rep("\"",3)

temp_cov <- c('1989', '2013')

maint_desc <- "completed"

user_id <- "EDI"

package_id <- "edi.553.1"

#geographic information
#use either this description or a .txt file generated below
#make sure these two paramters are then taken out of make_eml

geog_descr <- 'United States of America'

coord_south <- 25.0
coord_east <- -66.9
coord_north <- 50.0
coord_west <- -125.0

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
  maintenance.description = maint_desc,
  data.table = file_names,
  data.table.name = file_better_names,
  data.table.description = file_descriptions,
  data.table.quote.character = quote_character,
  #other.entity = 'RCodeS2_MetaAnalysis.R',
  #other.entity.description = 'R code used to run all analyses.',
  user.id = 'edi',
  user.domain = 'EDI',
  package.id = package_id
)
