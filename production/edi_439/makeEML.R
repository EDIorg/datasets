# This script executes an EMLassemblyline workflow.

library(EMLassemblyline)
library(dplyr)
library(tidyr)
library(stringr)

file_path <- "."

file_names <- c('Herbivorous_Fish.csv',
                'Sediment_manipulation_experiment.csv',
                'Sediment_Turf_Surveys.csv')

dataset_title <- 'Increased sediment load destabilize algal turf at two different fringing reefs; Evaluating responses across a stress gradient, Moorea, French Polynesia, 2016'

file_descriptions <- c('Herbivorous Fish counts',
                       'Sediment Manipulation Experiment',
                       'Sediment and Turf Surveys')

quote_character <- rep("\"",3)

temp_cov <- c("2016-04-02","2016-07-27")

maint_desc <- "completed"

user_id <- "EDI"

package_id <- "edi.439.1"

#geographic information
#use either this description or a .txt file generated below
#make sure these two paramters are then taken out of make_eml

# geog_descr <- "Marcell Experimental Forest, Minnesota, USA."
# 
# coord_south <- 47.50750
# coord_east <- -93.45444
# coord_north <- 47.50750
# coord_west <- -93.45444
# 
# geog_coord <- c(coord_north, coord_east, coord_south, coord_west)
# 

template_core_metadata(
  path = file_path,
  license = 'CCBY'
)


# romove that stupid special characterat the beginning of the file

# df <- read.csv('VegCoverDataRMBL2014.csv')

# colnames(df)[colnames(df)=="Ã¯..Gradient"] <- "Gradient"

# write.csv(df, file = 'VegCoverDataRMBL2014.csv', row.names = F)

template_table_attributes(
  path = file_path,
  data.path = file_path,
  data.table = file_names
)

template_categorical_variables(
  path = file_path,
  data.path = file_path
)

template_geographic_coverage(
  path = file_path,
  data.path = file_path,
  data.table = 'sites_lat_long.csv',
  site.col = 'Site',
  lat.col = 'Lat',
  lon.col = 'Long'
)

# df <- read.csv('taxonInfo.csv', header = T, as.is = T)
# df <- distinct(df, taxon_name)
# write.csv(df, file = 'taxonInfo.csv', row.names = F)

template_taxonomic_coverage(
  path = file_path,
  data.path = file_path,
  taxa.table = 'taxonInfo.csv',
  taxa.col = 'taxon_name',
  taxa.authority = c(3,11),
  taxa.name.type = 'both'
)

make_eml(
  path = file_path,
  data.path = file_path,
  eml.path = file_path,
  dataset.title = dataset_title,
  temporal.coverage = temp_cov,
#  geographic.description = geog_descr,
#  geographic.coordinates = geog_coord,
  maintenance.description = maint_desc,
  data.table = file_names,
  data.table.description = file_descriptions,
  data.table.quote.character = quote_character,
  user.id = 'edi',
  user.domain = 'EDI',
  package.id = package_id
)
