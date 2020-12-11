# This script executes an EMLassemblyline workflow.

library(EMLassemblyline)
library(dplyr)
library(tidyr)
library(stringr)


file_path <- "."

file_names <- c('micro_within_macro_synthesis.csv')

table_names <- c('physically protected carbon')

dataset_title <- 'Mechanisms influencing physically sequestered soil carbon in temperate restored grasslands in South Africa and North America'

file_descriptions <- c('Data from three sites (southeast Nebraska, USA; northeast Kansas, USA; northeast Free State, South Africa) were synthesized. Data were used to create a mixed model regression of microaggregate-within-macroaggregate carbon increase with age among all site, with site as a random effect. Data were also used to fit structural equation models explaining predominant mechanism of microaggregate-within-macroaggregate carbon accumulation in each site and all combined sites.')

quote_character <- rep("\"",1)

temp_cov <- c('2005-09-01', '2013-05-31')

maint_desc <- "completed"

user_id <- "EDI"

package_id <- "edi.514.2"

#geographic information
#use either this description or a .txt file generated below
#make sure these two paramters are then taken out of make_eml

# geog_descr <- 'Northeast Kansas (Konza Prairie), USA'
# 
# coord_south <- 39.08333
# coord_east <- -96.58333
# coord_north <- 39.08333
# coord_west <- -96.58333
# 
# geog_coord <- c(coord_north, coord_east, coord_south, coord_west)

# Template geographic coverage
template_geographic_coverage(
  path = file_path,
  data.path = file_path,
  data.table = 'location.csv',
  site.col = 'site_name',
  lat.col = 'site_lat',
  lon.col = 'site_lon'
)

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

# template_taxonomic_coverage(
#   path = file_path,
#   data.path = file_path,
#   taxa.table = 'taxon_names.csv',
#   taxa.col = 'taxon',
#   taxa.authority = c(3,11),
#   taxa.name.type = 'scientific'
# )

make_eml(
  path = file_path,
  data.path = file_path,
  eml.path = file_path,
  dataset.title = dataset_title,
  temporal.coverage = temp_cov,
  #geographic.description = geog_descr,
  #geographic.coordinates = geog_coord,
  maintenance.description = 'completed',
  data.table = file_names,
  data.table.name = table_names,
  data.table.description = file_descriptions,
  data.table.quote.character = quote_character,
  other.entity = 'Biogeochemistry 2020 code.R',
  other.entity.description = 'Code for linear mixed models, structural equation models, and linear models with estimated marginal means',
  user.id = 'edi',
  user.domain = 'EDI',
  package.id = package_id
)
