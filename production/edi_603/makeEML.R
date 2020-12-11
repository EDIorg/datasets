# This script executes an EMLassemblyline workflow.

library(EMLassemblyline)
library(dplyr)
library(tidyr)
library(stringr)

file_path <- "."

# file_names <- list.files(path = file_path, pattern = "*\\.csv")

file_names <- c('Gill_etal_Ecology_EDI_data.csv')

dataset_title <- 'Conifer seed delivery after the Berry Fire Grand Teton National Park, USA, 2018'

file_descriptions <- c('Metadata for seed delivery, wind, and forest structure and demographics data. These data were collected to study the influence of fire regime change on conifer seed delivery in P. contorta forests.')

quote_character <- rep("\"",1)

temp_cov <- c("2018-07-12","2018-10-21")

maint_desc <- "completed"

user_id <- "EDI"

package_id <- "edi.603.1"

#geographic information
#use either this description or a .txt file generated below
#make sure these two paramters are then taken out of make_eml

geog_descr <- "Greater Yellowstone Ecosystem (GYE), USA, in subalpine forests in Grand Teton National Park (northwest Wyoming, USA) that burned at high severity in the 2016 Berry Fire."

coord_north <- 44.121
coord_west <- -110.809
coord_south <- 43.962
coord_east <- -110.641

geog_coord <- c(coord_north, coord_east, coord_south, coord_west)

# template_geographic_coverage(
#   path = file_path,
#   data.path = file_path,
#   data.table = 'lat_longs.csv',
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

template_taxonomic_coverage(
  path = file_path,
  data.path = file_path,
  taxa.table = 'taxa.csv',
  taxa.col = 'taxa',
  taxa.authority = c(3,11),
  taxa.name.type = 'both'
)

#test for table problems
for (i in 1:length(file_names)) {
  
  df <- as.data.frame(
    data.table::fread(
      file = file_names[i],
      fill = TRUE,
      blank.lines.skip = TRUE
    )
  )
  print(file_names[i])
}

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
  #other.entity = c('format_to_original.R'),
  #other.entity.description = c('reformats files Henning_et_al_2020_fungal_samples.csv and Henning_et_al_2020_fungal_OTU_counts.csv back to originally analyzed matrix'),
  #provenance = c('edi.390.1'),
  user.id = 'edi',
  user.domain = 'EDI',
  package.id = package_id
)
