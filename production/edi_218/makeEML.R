library(EMLassemblyline)

file_path <- "./animalIsotopes"

file_names <- list.files(path = file_path, pattern = "*.csv")

#import_templates(path = file_path, license = "CCBY", data.files = file_names)

#define_catvars(path = file_path)

dataset_title <- "Five Points Small Mammal Blood Plasma Isotopic Values for Carbon, Nitrogen and Hydrogen"

file_descriptions <- c("Five Points Small Mammal Blood Plasma Isotopic Values for Carbon, Nitrogen and Hydrogen")

quote_character <- rep("\"",1)

temp_cov <- c("2013-07-03","2016-04-10")

maint_desc <- "completed"

user_id <- "EDI"

package_id <- "edi.218.1"

#geographic information

geog_descr <- "Sevilleta Experimental Station"

coord_north <- 34.195
coord_west <- -106.4154
coord_south <- 34.1838
coord_east <- -106.4149

geog_coord <- c(coord_north, coord_east, coord_south, coord_west)

make_eml(path = file_path,
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
