library(EMLassemblyline)

file_path <- "."

file_names <- list.files(path = file_path, pattern = "*.csv")

import_templates(path = file_path, license = "CCBY", data.files = file_names)

define_catvars(path = file_path)

dataset_title <- "Plot-level field data and model simulation results, archived to accompany Turner et al. manuscript; reports data from summer 2017 sampling of short-interval fires that burned during summer 2016 in Greater Yellowstone."

file_descriptions <- c("Reburn plot level data",
                       "Reburn modeled data")

quote_character <- rep("\"",2)

temp_cov <- c("2017-07-01", "2017-08-31")

maint_desc <- "Completed"

user_id <- "EDI"

package_id <- "edi.361.2"

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
