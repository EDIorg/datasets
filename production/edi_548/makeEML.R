# This script executes an EMLassemblyline workflow.

library(EMLassemblyline)
library(dplyr)
library(tidyr)
library(stringr)

file_path <- "."

file_names <- c('DataS1_SystematicReviewDatabase.csv',
                'DataS2_MetaAnalysisDatabase.csv',
                'DataS3_ExperimentalStudiesDatabase.csv')

dataset_title <- 'Correlation of native and exotic species richness: a global meta‐analysis finds no invasion paradox across scales'

file_descriptions <- c('data used only in the systematic review, not the meta-analysis. Each entry describes a single case.',
                       'data used in all meta-analyses. Each entry describes a single case, and each case includes all covariates used in meta-analytic models.',
                       'data from experimental studies that were not included in meta-analyses. These studies were, however, included in the systematic review.')


quote_character <- rep("\"",3)

temp_cov <- c('1994', '2018')

maint_desc <- "completed"

user_id <- "EDI"

package_id <- "edi.548.1"

#geographic information
#use either this description or a .txt file generated below
#make sure these two paramters are then taken out of make_eml

geog_descr <- 'Global'

coord_south <- -80.0
coord_east <- 180.0
coord_north <- 80.0
coord_west <- -180.0

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
  data.table.description = file_descriptions,
  data.table.quote.character = quote_character,
  other.entity = 'RCodeS2_MetaAnalysis.R',
  other.entity.description = 'R code used to run all analyses.',
  user.id = 'edi',
  user.domain = 'EDI',
  package.id = package_id
)
