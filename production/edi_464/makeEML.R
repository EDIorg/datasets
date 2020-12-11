# This script executes an EMLassemblyline workflow.

library(EMLassemblyline)
library(dplyr)
library(tidyr)
library(stringr)

file_path <- "."

file_names <- list.files(path = file_path, pattern = "*\\.csv")

dataset_title <- 'Institutional Collaboration in the US LTER Network based on bibliometric information (1981-2018)'

file_descriptions <- c('List of investigated ecological journals',
                       'List of investigated articles supported by the US LTER',
                       'Temporal pattern of institutional collaborations in LTER',
                       'Spatial pattern of institutional collaborations in LTER')

quote_character <- rep("\"",4)

temp_cov <- c("1981-01-01","2018-12-31")

maint_desc <- "completed"

user_id <- "EDI"

package_id <- "edi.464.1"

#geographic information
#use either this description or a .txt file generated below
#make sure these two paramters are then taken out of make_eml

geog_descr <- "US Long-Term Ecological Research Sites"

coord_north <- 72.8
coord_west <- -171
coord_south <- -79
coord_east <- 177

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

# template_geographic_coverage(
#   path = file_path,
#   data.path = file_path,
#   empty = T
# )

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
  geographic.description = geog_descr,
  geographic.coordinates = geog_coord,
  maintenance.description = maint_desc,
#  other.entity = c('script Sunapee 2012 MergeDataDOproofing.R'),
#  other.entity.description = c('Dissolved oxygen drift-correction code'),
  data.table = file_names,
  data.table.description = file_descriptions,
  data.table.quote.character = quote_character,
  user.id = 'edi',
  user.domain = 'EDI',
  package.id = package_id
)
