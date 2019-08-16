library(EMLassemblyline)

file_path <- "./runs/outputs"

file_names <- list.files(path = file_path, pattern = "*.csv")

#import_templates(path = file_path, license = "CCBY", data.files = file_names)

#catvars still need to run and be filled out
#waiting for explanation of what species LPS is

#define_catvars(path = file_path)

dataset_title <- "It takes a few to tango: Changing climate and fire regimes can cause regeneration failure of two subalpine conifers"

file_descriptions <- c("Douglas fir seed source 1000 m aggregate",
                       "Douglas fir seed source 500 m aggregate",
                       "Douglas fir seed source 50 m aggregate",
                       "Lodgepole Pine seed source 1000 m aggregate",
                       "Lodgepole Pine seed source 500 m aggregate",
                       "Lodgepole Pine seed source 50 m aggregate",
                       "Serotinuos Lodgepole Pine seed source 1000 m aggregate",
                       "Serotinuos Lodgepole Pine seed source 500 m aggregate",
                       "Serotinuos Lodgepole Pine seed source 50 m aggregate")

quote_character <- rep("\"",9)

temp_cov <- c("2017-12-01","2018-06-31")

maint_desc <- "completed"

user_id <- "EDI"

package_id <- "edi.210.1"

#geographic information

geog_descr <- "Data were collected in Yellowstone National Park on the central subalpine plateau."

coord_north <- 44.72
coord_west <- -110.79
coord_south <- 44.18
coord_east <- -110.03

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
