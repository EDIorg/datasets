# This script executes an EMLassemblyline workflow.

library(EMLassemblyline)
library(dplyr)
library(tidyr)
library(stringr)

#get years and lat longs
df_npp <- read.csv('nutnet-npp-div-data-output.csv', header = T, as.is = T)
max_year <- max(df_npp$year)
min_year <- min(df_npp$year)

df_geog <- distinct(df_npp, latitude, longitude, site)
write.csv(df_geog, file = 'lat_longs.csv', row.names = F)

file_path <- "."

# file_names <- list.files(path = file_path, pattern = "*\\.csv")

file_names <- c('nutnet-npp-div-data-output.csv')

dataset_title <- 'Effects of chronic nutrient enrichment on plant diversity and ecosystem productivity, 2008-2019'

file_descriptions <- c('Biomass, diversity and richness measures for 47 plots')

quote_character <- rep("\"",1)

temp_cov <- c("2008","2019")

maint_desc <- "completed"

user_id <- "EDI"

package_id <- "edi.599.1"

#geographic information
#use either this description or a .txt file generated below
#make sure these two paramters are then taken out of make_eml

# geog_descr <- "Cedar Creek LTER, Experimental ecological reserve containing oak savannas, prairies, hardwood and pine forests, ash and cedar swamps, acid bogs, marshes, and sedge meadows. Subset of the Nutrient Network. East Bethel, MN, USA."
# 
# coord_north <- 45.43
# coord_west <- -93.21
# coord_south <- 45.43
# coord_east <- -93.21
# 
# geog_coord <- c(coord_north, coord_east, coord_south, coord_west)

template_geographic_coverage(
  path = file_path,
  data.path = file_path,
  data.table = 'lat_longs.csv',
  site.col = 'site',
  lat.col = 'latitude',
  lon.col = 'longitude'
)

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
  taxa.table = 'plant_species.csv',
  taxa.col = 'species_name',
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
  #geographic.description = geog_descr,
  #geographic.coordinates = geog_coord,
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
