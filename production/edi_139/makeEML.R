
library(EMLassemblyline)

file_names <- list.files(path = ".", pattern = "*.csv")

import_templates(path = ".", license = "CCBY", data.files = file_names)

define_catvars(path = ".")

dataset_title <- "Net primary production (NPP) and climate data from Sevilleta LTER core and control sites in desert grassland and shrubland ecosystems, 1999 - 2017"

file_descriptions <- c("This data set includes net primary production (NPP) data from 1m2 quadrats throughout desert grassland and shrubland ecosystems. Data include NPP values from the Sevilleta LTER core sites (blue grama grassland, black grama grassland, creosote shrubland, mixed grass-shrub, mixed blue-black grassland) along with control plots from multiple experiments in these areas (EDGE, monsoon variability).")

quote_character <- rep("\"",1)

temp_cov <- c("1999-01-01","2014-12-31")

maint_desc <- "ongoing"

user_id <- "EDI"

package_id <- "edi.139.1"

#geographic information

geog_descr <- "Sevilleta Wildlife Refuge, New Mexico, US"

geog_coord <- c("34.30657222", "-106.7157472", "34.30657222", "-106.7157472")

make_eml(path = ".",
         dataset.title = dataset_title,
         data.files = file_names,
         data.files.description = file_descriptions,
         data.files.quote.character = quote_character,
         temporal.coverage = temp_cov,
         geographic.description = geog_descr,
         geographic.coordinates = geog_coord,
         maintenance.description = maint_desc,
         user.id = user_id,
         package.id = package_id)
