library(EMLassemblyline)

file_path <- "."

file_names <- list.files(path = file_path, pattern = "*.csv")

import_templates(path = file_path, license = "CCBY", data.files = file_names)

define_catvars(path = file_path)

dataset_title <- "Photosynthetic data on experimentally warmed tree species in northern Minnesota, 2009-2011, used in the paper Reich et al Nature 2018."

file_descriptions <- c("Photosynthesis and plant water relations measurements")

quote_character <- rep("\"",1)

temp_cov <- c("2009-06-11", "2011-09-26")

maint_desc <- "For data used in the paper and included in this data set dat collection is completed. Overall experiment is ongoing."

user_id <- "EDI"

package_id <- "edi.229.2"

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
