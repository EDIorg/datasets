library(EMLassemblyline)

file_path <- "."

file_names <- list.files(path = file_path, pattern = "*.csv")

import_templates(path = file_path, license = "CCBY", data.files = file_names)

define_catvars(path = file_path)

dataset_title <- "Data from: Diversity and composition of viral communities: coinfection of barley and cereal yellow dwarf viruses in California grasslands 2000 - 2005"

file_descriptions <- c("bydv viral CA data output temporal subset, used for cross-site comparisons",
                       "bydv viral CA data output temporal subset, used for temporal trends.",
                       "bydv viral CA data output")

quote_character <- rep("\"",3)

temp_cov <- c("2000-01-01", "2005-12-31")

maint_desc <- "Completed"

user_id <- "EDI"

package_id <- "edi.316.1"

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
