library(EMLassemblyline)

file_path <- "."

file_names <- list.files(path = file_path, pattern = "*.csv")

import_templates(path = file_path, license = "CCBY", data.files = file_names)

define_catvars(path = file_path)

dataset_title <- "Assessing change in ecosystem processes twenty four years after the 1988 Yellowstone Wildfires, 2013"

file_descriptions <- c("Soil, litter and foliage chemical paramaters")

quote_character <- rep("\"",1)

temp_cov <- c("2012-06-01", "2013-08-31")

maint_desc <- "Completed"

user_id <- "EDI"

package_id <- "edi.268.1"

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
