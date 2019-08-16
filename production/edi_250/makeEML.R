library(EMLassemblyline)

file_path <- "."

file_names <- list.files(path = file_path, pattern = "*.csv")

import_templates(path = file_path, license = "CCBY", data.files = file_names)

define_catvars(path = file_path)

dataset_title <- "Raw count data from repeated surveys of a guild of Plethodon salamanders in an old-growth forest in southeastern Kentucky 2016, with GIS and in situ environmental data"

file_descriptions <- c("Count of two Plethodon species and environmental paramaters")

quote_character <- rep("\"",1)

temp_cov <- c("2016-10-15", "2016-11-13")

maint_desc <- "Completed"

user_id <- "EDI"

package_id <- "edi.250.1"

#geographic information

make_eml(path = file_path,
         dataset.title = dataset_title,
         data.files = file_names,
         data.files.description = file_descriptions,
         data.files.quote.character = quote_character,
         temporal.coverage = temp_cov,
         maintenance.description = maint_desc,
         user.id = user_id,
         affiliation = "EDI",
         package.id = package_id)
