library(EMLassemblyline)

file_path <- "."

file_names <- list.files(path = file_path, pattern = "*.csv")

import_templates(path = file_path, license = "CCBY", data.files = file_names)

define_catvars(path = file_path)

dataset_title <- "Soil electrical conductivity measurements across the city of Madison, WI, 2015 and 2018"

file_descriptions <- c("Soil electrical conductivity and other soil parameters")

quote_character <- rep("\"",1)

temp_cov <- c("2015-01-01", "2018-12-31")

maint_desc <- "Completed"

user_id <- "EDI"

package_id <- "edi.377.1"

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
