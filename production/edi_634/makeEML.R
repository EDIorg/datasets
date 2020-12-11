# This script executes an EMLassemblyline workflow.

library(EMLassemblyline)
library(dplyr)
library(tidyr)
library(stringr)


file_path <- "."

file_names <- c('fenton_adsorption_weoc.csv',
                'postfenton_hardwood.csv',
                'postfenton_softwood.csv',
                'prefenton_hardwood.csv',
                'prefenton_softwood.csv',
                'soil_key.csv')

table_names <- c('fenton_adsorption weoc',
                 'postfenton hardwood',
                 'postfenton softwood',
                 'prefenton hardwood',
                 'prefenton softwood',
                 'soil key')

dataset_title <- 'Reactive oxygen species alter chemical composition and adsorptive fractionation of soil-derived organic matter'

file_descriptions <- c('Water extractable organic carbon (WEOC) data, measured as non-purgeable organic carbon (NPOC) on a Shimadzu TOC analyzer',
                       'FT-ICR-MS data for the Post-Fenton hardwood soil extracts',
                       'FT-ICR-MS data for the Post-Fenton softwood soil extracts',
                       'FT-ICR-MS data for the Pre-Fenton hardwood soil extracts',
                       'FT-ICR-MS data for the Pre-Fenton softwood soil extracts',
                       'Sample key')

quote_character <- rep("\"",6)

#temp_cov <- c('1988', '2018')

maint_desc <- "completed"

user_id <- "EDI"
user_domain = 'EDI'

package_id <- "edi.634.1"

#geographic information
#use either this description or a .txt file generated below
#make sure these two paramters are then taken out of make_eml

geog_descr <- 'BBWM is located in eastern Maine, USA at an elevation of 450.8 m. Soils are coarse-loamy, mixed, frigid Typic and Aquic Haplorthods. Bedrock consists dominantly of quartzite, phyllite, and calc-silicate low-grade metasediments, and minor granite dikes. The lower elevations are dominated by hardwood stands, and the upper elevations are dominated by softwood stands.'

coord_south <- 44.870000
coord_east <- -68.100000
coord_north <- 44.870000
coord_west <- -68.100000

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
  #temporal.coverage = temp_cov,
  geographic.description = geog_descr,
  geographic.coordinates = geog_coord,
  maintenance.description = maint_desc,
  data.table = file_names,
  data.table.name = table_names,
  data.table.description = file_descriptions,
  data.table.quote.character = quote_character,
  user.id = user_id,
  user.domain = user_domain,
  package.id = package_id
)
