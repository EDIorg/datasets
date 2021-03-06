# This script executes an EMLassemblyline workflow.

library(EMLassemblyline)
library(dplyr)
library(tidyr)
library(stringr)


file_path <- "."

file_names <- c('bbwm_airtemp_3hour.csv',
                'bbwm_soiltemp_min10_3hour.csv',
                'bbwm_soiltemp_min25_3hour.csv',
                'bbwm_soiltemp_org_3hour.csv')

table_names <- c('Air temperature',
                 'Mineral soil temperature (10 cm depth)',
                 'Mineral soil temperature (25 cm depth)',
                 'Organic soil temperature')

dataset_title <- 'The Bear Brook Watershed in Maine, USA: Long-term soil temperature 2001 - 2016'

file_descriptions <- c('Air temperature at a three-hour interval',
                       'Mineral soil temperature (10 cm depth) at a three-hour interval',
                       'Mineral soil temperature (25 cm depth) at a three-hour interval',
                       'Organic soil temperature at a three-hour interval')

quote_character <- rep("\"",4)

temp_cov <- c('2001', '2016')

maint_desc <- "ongoing"

user_id <- "EDI"
user_domain = 'EDI'

package_id <- "edi.623.1"

#geographic information
#use either this description or a .txt file generated below
#make sure these two paramters are then taken out of make_eml

geog_descr <- 'BBWM is located in eastern Maine, USA at an elevation of 450.8 m. Soils are coarse-loamy, mixed, frigid Typic and Aquic Haplorthods. Bedrock consists dominantly of quartzite, phyllite, and calc-silicate low-grade metasediments, and minor granite dikes. The lower elevations are dominated by hardwood stands, and the upper elevations are dominated by softwood stands. The site is located in the Acadian Plains and Hills (82) Level III Ecoregion (Omernik et al. https://www.epa.gov/eco-research/ecoregions).'

coord_south <- 44.870000
coord_east <- -68.100000
coord_north <- 44.870000
coord_west <- -68.100000

geog_coord <- c(coord_north, coord_east, coord_south, coord_west)

# Template geographic coverage
# template_geographic_coverage(
#   path = file_path,
#   data.path = file_path,
#   data.table = 'location.csv',
#   site.col = 'site_name',
#   lat.col = 'site_lat',
#   lon.col = 'site_lon'
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
  #other.entity = 'shelter_open_shrub_comparison.Rmd',
  #other.entity.description = 'R markdown codes for analysis.',
  user.id = user_id,
  user.domain = user_domain,
  package.id = package_id
)
