
library(EMLassemblyline)

file_names <- list.files(path = ".", pattern = "*.csv")

import_templates(path = ".", license = "CCBY", data.files = file_names)

define_catvars(path = ".")

dataset_title <- "Interaction of waves with idealized high-relief bottom roughness, model parameters and code"

file_descriptions <- c("fake file")

quote_character <- rep("\"",1)

temp_cov <- c("2015-11-01","2018-03-15")

maint_desc <- "completed"

user_id <- "EDI"

package_id <- "edi.179.2"

#no geographic information for this model

geog_descr <- "Idealized modeling study of wave-driven flow over high relief topography"

geog_coord <- c("90", "180", "-90", "-180")

make_eml(path = ".",
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
