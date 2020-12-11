# This script executes an EMLassemblyline workflow.

library(EMLassemblyline)
library(dplyr)
library(tidyr)
library(stringr)

file_path <- "."

file_names <- list.files(path = file_path, pattern = "*\\.csv")

dataset_title <- 'Future of Oak Forests experiment - DBH of trees in Black Rock Forest, New York, USA, 2007.'

file_descriptions <- c("Plot, Subplot, Species, DBH for non-oak species",
                       "Plot, Subplot, Species, DBH for oak species",
                       "Species code explanations")

quote_character <- rep("\"",3)

temp_cov <- c("2007-07-01","2007-08-31")

maint_desc <- "ongoing"

user_id <- "EDI"

package_id <- "edi.469.1"

#geographic information
#use either this description or a .txt file generated below
#make sure these two paramters are then taken out of make_eml

geog_descr <- "North slope of the Black Rock Mountain, in Cornwall, New York"

coord_north <- 41.418729
coord_west <- -74.026520 
coord_south <- 41.417319
coord_east <- -74.022308 

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

template_taxonomic_coverage(
  path = file_path,
  data.path = file_path,
  taxa.table = 'species_codes.csv',
  taxa.col = 'scientific_name',
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
  user.id = 'edi',
  user.domain = 'EDI',
  package.id = package_id
)
