# This script executes an EMLassemblyline workflow.

library(EMLassemblyline)
library(dplyr)
library(tidyr)
library(stringr)

file_path <- "."

file_names <- list.files(path = file_path, pattern = "*\\.csv")

dataset_title <- 'High resolution stream temperature, pressure, and estimated depth from transducers in six streams in the Lake Sunapee watershed, New Hampshire, USA 2010-2014'

file_descriptions <- c("LSPA reference (#101)",
                       "Otter Pond Brook (tributary #505)",
                       "Chandler Johnson (tributary #665)",
                       "Blodgett Brook South (tributary #788)",
                       "Blodgett Brook North (tributary #790) ",
                       "King Hill (tributary #805)",
                       "Herrick South (tributary #830)",
                       "sunapee transducer locations")

quote_character <- rep("\"",8)

temp_cov <- c("2010-04-01","2014-05-08")

maint_desc <- "ongoing"

user_id <- "EDI"

package_id <- "edi.466.1"

#geographic information
#use either this description or a .txt file generated below
#make sure these two paramters are then taken out of make_eml

geog_descr <- "lake and watershed: Lake Sunapee is located in the Sugar River watershed within Sullivan and Merrimack Counties, New Hampshire, USA. There are sixteen streams (including ephemeral streams) which flow into Lake Sunapee and a single outlet from the lake.  The Lake Sunapee watershed covers approximately 12094 hectares including Lake Sunapee itself, which is approximately 1667 hectares. The transducers are located in six inflows to the lake: Otter Pond Brook (tributary #505; sub-watershed is 7661 hectares), Chandler Johnson (tributary #665; sub-watershed is 2170 hectares), Blodgett Brook South Branch (tributary #788; sub-watershed is 359 hectares), Blodgett Brook North Branch (tributary #790; sub watershed is 954 hectares), King Hill (tributary #805; sub-watershed is 923 hectares) and Herrick South (tributary #830; sub watershed is 314 hectares). The sub-watersheds listed here are smaller watersheds within the Lake Sunapee watershed delineated in ArcGIS using the watershed tool from the Lake Sunapee Protective Association’s long term monitoring.  A reference transducer used to track atmospheric barometric pressure is located on land near the lake outlet at Sunapee Harbor."

coord_north <- 43.4903
coord_west <- -72.1041
coord_south <- 43.3085
coord_east <- -71.9912

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
  other.entity = c('input_505_Otter_2332745_14Feb16.R',
                   'input_665_ChandJohn_2332741_14Feb16.R',
                   'input_788_BlodS_2332742_14Feb16.R',
                   'input_790_BlodN_2332743_14Feb2016.R',
                   'input_805_Kinglow_2332746_14Feb2016.R',
                   'input_830_HerrickS_2325799_14Feb16.R',
                   'input_LSPA_2332744_14Feb2016.R'),
  other.entity.description = c('Code to collate and clean transducer files for stream 505, Otter Pond',
                               'Code to collate and clean transducer files for stream 665, Chandler Johnson',
                               'Code to collate and clean transducer files for stream 788, Blodgett South',
                               'Code to collate and clean transducer files for stream 790, Blodgett North',
                               'Code to collate and clean transducer files for stream 805, King Hill',
                               'Code to collate and clean transducer files for stream 830, Herrick South',
                               'Code to collate and clean transducer files for the reference transducer'),
  data.table = file_names,
  data.table.description = file_descriptions,
  data.table.quote.character = quote_character,
  user.id = 'edi',
  user.domain = 'EDI',
  package.id = package_id
)
