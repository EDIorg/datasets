# This script executes an EMLassemblyline workflow.

library(EMLassemblyline)
library(dplyr)
library(tidyr)
library(stringr)


file_path <- "."

file_names <- c('annual_fire_forest_risk.csv',
                'annual_fuels_treatment_comparison.csv',
                'summary_fire_risk.csv')

table_names <- c('annual fire forest risk',
                 'annual fuels treatment comparison',
                 'summary fire risk')

dataset_title <- 'Can we manage a future with more fire? Effectiveness of defensible space treatment depends on housing amount and configuration'

file_descriptions <- c('Annual area burned, forest characteristics, and fire risk for each replicate of each scenario. Data are aggregated across the entire landscape for each year. No area burned or fire risk for year 0 of the simulation (1980).',
                       'Annual fuel loads and fuel characteristics for each replicate of each scenario. Data are aggregated for areas that are treated and areas that are untreated across the entire landscape for each year. Fuel loads in a given year are used to estimate fire intensity for fires that burn in the subsequent year.',
                       'Summarized fire risk for each replicate of each scenario. Data are aggregated across all years in the simulation experiment, so each scenario has n=20 observations. These data were used for analyses associated with objective/question 2.')

quote_character <- rep("\"",3)

temp_cov <- c('2018-01-28', '2020-05-29')

maint_desc <- "completed"

user_id <- "EDI"
user_domain = 'EDI'

package_id <- "edi.627.1"

#geographic information
#use either this description or a .txt file generated below
#make sure these two paramters are then taken out of make_eml

geog_descr <- 'Subalpine, lodgepole-pine dominated forests in the Greater Yellowstone Ecosystem, USA'

coord_south <- 42
coord_east <-  -108.5
coord_north <- 49.0
coord_west <- -119.5

geog_coord <- c(coord_north, coord_east, coord_south, coord_west)

#Template geographic coverage
# template_geographic_coverage(
#   path = file_path,
#   data.path = file_path,
#   data.table = 'geog.csv',
#   site.col = 'site',
#   lat.col = 'latitude',
#   lon.col = 'longitude'
# )

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
  geographic.description = geog_descr,
  geographic.coordinates = geog_coord,
  maintenance.description = maint_desc,
  data.table = file_names,
  data.table.name = table_names,
  data.table.description = file_descriptions,
  data.table.quote.character = quote_character,
  data.table.url = c('https://lter.limnology.wisc.edu/sites/default/files/annual_fire_forest_risk.csv',
                     'https://lter.limnology.wisc.edu/sites/default/files/annual_fuels_treatment_comparison.csv',
                     'https://lter.limnology.wisc.edu/sites/default/files/summary_fire_risk.csv'),
  other.entity = 'model_scripts.zip',
  other.entity.description = 'This file contains everything needed to rerun the iLand model for all scenarios and replicates described in this study, to generate the model outputs deposited here, and to perform analyses associated with the published manuscript. This includes the model itself (including source code) and associated bash and R scripts. The “readme.md” file describes folder contents and steps for recreating output in more detail, and iLand is extensively documented online (http:// iland.boku.ac.at/).',
  other.entity.url = 'https://lter.limnology.wisc.edu/sites/default/files/model_scripts.zip',
  user.id = user_id,
  user.domain = user_domain,
  package.id = package_id
)
