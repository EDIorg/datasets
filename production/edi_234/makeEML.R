library(EMLassemblyline)

file_path <- "."

file_names <- list.files(path = file_path, pattern = "*.csv")

import_templates(path = file_path, license = "CCBY", data.files = file_names)

define_catvars(path = file_path)

dataset_title <- "Lake Sunapee High Frequency Weather Data measured on buoy - 2007-2017"

file_descriptions <- c("Air temperature",
                       "Photosyntetic active radiation",
                       "Wind direction and speed")

quote_character <- rep("\"",3)

temp_cov <- c("2007-08-27", "2017-12-31")

maint_desc <- "Data collection ongoing. Starting winter of 2010, buoy is moved to harbor to prevent ice damage. Date of move is determined by weather and LSPA staff availability."

user_id <- "EDI"

package_id <- "edi.234.2"

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
