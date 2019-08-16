library(EMLassemblyline)

file_names <- list.files(path = ".", pattern = "*.csv")

import_templates(path = ".", license = "CCBY", data.files = file_names)

define_catvars(path = ".")

dataset_title <- "Concentrations of cyanotoxins in fresh water and fish"

file_descriptions <- c("Cyanotoxin data gathered from literature sources",
                       "Metadata for literature sources")

quote_character <- rep("\"",2)

temp_cov <- c("2004-01-01","2017-12-31")

maint_desc <- "completed"

user_id <- "EDI"

package_id <- "edi.160.2"

#geographic information

geog_descr <- "Global"

extract_geocoverage(path = ".",
                    data.file = "lakelocations.csv",
                    lat.col = "lat",
                    lon.col = "long",
                    site.col = "water_body")



geog_coord <- c("65", "180", "-40", "-125")

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
