library(EMLassemblyline)

file_path <- "."

file_names <- list.files(path = file_path, pattern = "*.csv")

import_templates(path = file_path, license = "CCBY", data.files = file_names)


define_catvars(path = file_path)

dataset_title <- "Postfire aspen presence, persistence and size in subalpine forests of Yellowstone National Park, USA. 1996 - 2014"

file_descriptions <- c("Aspen Biomass 2014",
                       "Aspen Presence 1999",
                       "Aspen Size 1996")

quote_character <- rep("\"",3)

temp_cov <- c("1996-06-01","2014-08-31")

maint_desc <- "completed"

user_id <- "EDI"

package_id <- "edi.206.1"

#geographic information

geog_descr <- "Data were collected in Yellowstone National Park on the central subalpine plateau."

coord_north <- 44.72
coord_west <- -110.79
coord_south <- 44.18
coord_east <- -110.03

geog_coord <- c(coord_north, coord_east, coord_south, coord_west)

make_eml(path = file_path,
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
