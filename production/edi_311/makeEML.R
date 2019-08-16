library(EMLassemblyline)

file_path <- "."

file_names <- list.files(path = file_path, pattern = "*.csv")

import_templates(path = file_path, license = "CCBY", data.files = file_names)

define_catvars(path = file_path)

dataset_title <- "High-frequency water temperature and dissolved oxygen data and derived stability and metabolism metrics for nine lakes in northeastern North America for months before and after Tropical Cyclone Irene, Fall 2011"

file_descriptions <- c("Daily metrics for stability, respiration, gross primary production, Net ecosystem metabolism",
                       "High frequency DO data",
                       "High frequency water temperature data",
                       "High frequency wind speed data")

quote_character <- rep("\"",4)

temp_cov <- c("2011-08-01", "2011-10-15")

maint_desc <- "Completed"

user_id <- "EDI"

package_id <- "edi.311.5"

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
