library(EMLassemblyline)

file_path <- "."

file_names <- list.files(path = file_path, pattern = "*.csv")

import_templates(path = file_path, license = "CCBY", data.files = file_names)

define_catvars(path = file_path)

dataset_title <- "Carbon quality regulates the temperature dependence of aquatic ecosystem respiration"

file_descriptions <- c("daily ecosystem respiration (ER), gross primary production (GPP), and net ecosystem production (NEP) estimates for each mesocosm",
                       "resulting DOC concentrations and absorbance characteristics",
                       "PME miniDOT high frequency dissolved oxygen sensor",
                       "shortwave radiation was measured using a pyranometer attached to a buoy located on Lake George approximately 3,000 m from the study site.",
                       "Wind speed measured at a gauge located in proximity to the study site on the shore of Lake George")

quote_character <- rep("\"",5)

temp_cov <- c("2016-09-01","2018-05-31")

maint_desc <- "completed"

user_id <- "EDI"

package_id <- "edi.195.3"

#geographic information

geog_descr <- "Experiment was conducted on the shore of Lake George in the town of Bolton Landing, NY. However, this is not site specific research."

coord_north <- 43.565631
coord_west <- -73.657297
coord_south <- 43.52295
coord_east <- -73.609184

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
