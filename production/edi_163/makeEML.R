library(EMLassemblyline)



file_names <- list.files(path = ".", pattern = "*.csv")

#import_templates(path = ".", license = "CCBY", data.files = file_names)

#define_catvars(path = ".")

dataset_title <- "NH and ME Landsat chlorophyll-a retrieval algorithms and in situ measurements 2000 (Landsat 7), 2013-2015 (Landsat 8)"

file_descriptions <- c("remote sensing parameters",
                       "lake parameters")

quote_character <- rep("\"",2)

temp_cov <- c("2000-08-01","2015-08-31")

maint_desc <- "completed"

user_id <- "EDI"

package_id <- "edi.163.1"

#geographic information

geog_descr <- "Data are geographically located within the states of New Hampshire and Maine, United States. "

geog_coord <- c("45.22", "-69.16", "42.73", "-72.37")

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
