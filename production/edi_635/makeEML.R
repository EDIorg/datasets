# This script executes an EMLassemblyline workflow.

library(EMLassemblyline)
library(dplyr)
library(tidyr)
library(stringr)


file_path <- "."

file_names <- c('snowpack_depth.csv',
                'soil_n.csv',
                'stream_n.csv',
                'streamflow.csv',
                'temp_movingavg.csv')

table_names <- c('snowpack depth',
                 'soil n',
                 'stream n',
                 'streamflow',
                 'temp movingavg')

dataset_title <- 'Snowmelt periods as hot moments for soil N dynamics: A case study in Maine, USA'

file_descriptions <- c('Snowpack measurements for 2015-16',
                       'Soil extractable nitrogen',
                       'Stream nitrate concentrations',
                       'Streamflow discharge and gage height measurements',
                       'Air and soil temperature 7-day moving averages')

quote_character <- rep("\"",5)

temp_cov <- c('2015', '2016')

maint_desc <- "completed"

user_id <- "EDI"
user_domain = 'EDI'

package_id <- "edi.635.1"

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
  temporal.coverage = temp_cov,
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
