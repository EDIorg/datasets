# This script executes an EMLassemblyline workflow.

library(EMLassemblyline)
library(dplyr)
library(tidyr)
library(stringr)

file_path <- "."

file_names <- list.files(path = file_path, pattern = "*\\.csv")

dataset_title <- 'High Frequency Meteorological, Drift-Corrected Dissolved Oxygen, and Thermistor Temperature Data - Lake Sunapee Buoy, NH, USA, 2007 – 2013'

file_descriptions <- c('High frequency data',
                       'Buoy location within lake Sunapee')

quote_character <- rep("\"",2)

temp_cov <- c("2007-08-27","2013-10-23")

maint_desc <- "completed"

user_id <- "EDI"

package_id <- "edi.463.1"

#geographic information
#use either this description or a .txt file generated below
#make sure these two paramters are then taken out of make_eml

#geog_descr <- "Aero Club facility at the Travis Air Force Base, Fairfield, California, USA"

#coord_north <- 38.27136
#coord_west <- -121.97523
#coord_south <- 38.26689
#coord_east <- -121.96893

#geog_coord <- c(coord_north, coord_east, coord_south, coord_west)


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

template_geographic_coverage(
   path = file_path,
   data.path = file_path,
   empty = T
)

# template_taxonomic_coverage(
#   path = file_path,
#   data.path = file_path,
#   taxa.table = 'plant_species.csv',
#   taxa.col = 'species_name',
#   taxa.authority = c(3,11),
#   taxa.name.type = 'both'
# )

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
#  geographic.description = geog_descr,
#  geographic.coordinates = geog_coord,
  maintenance.description = maint_desc,
  other.entity = c('script Sunapee 2012 MergeDataDOproofing.R'),
  other.entity.description = c('Dissolved oxygen drift-correction code'),
  data.table = file_names,
  data.table.description = file_descriptions,
  data.table.quote.character = quote_character,
  user.id = 'edi',
  user.domain = 'EDI',
  package.id = package_id
)
