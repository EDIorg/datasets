library(EMLassemblyline)

file_path <- "."

file_names <- list.files(path = file_path, pattern = "*.csv")

import_templates(path = file_path, license = "CCBY", data.files = file_names)


define_catvars(path = file_path)

dataset_title <- "Experimentally evaluating effects of postfire drought on establishment, growth and survival of two widespread western conifer species; lodgepole pine and Douglas-fir"

file_descriptions <- c("site arnica planting year 2014 climate measurements",
                       "site arnica planting year 2015 climate measurements",
                       "site blacktail planting year 2014 climate measurements",
                       "site blacktail planting year 2015 climate measurements",
                       "site cygnet planting year 2014 climate measurements",
                       "site cygnet planting year 2015 climate measurements",
                       "site le hardy planting year 2014 climate measurements",
                       "site le hardy planting year 2015 climate measurements",
                       "site old gardiner planting year 2014 climate measurements",
                       "site old gardiner planting year 2015 climate measurements",
                       "site quarry planting year 2014 climate measurements",
                       "site quarry planting year 2015 climate measurements",
                       "seedling data",
                       "site setup")

quote_character <- rep("\"",14)

temp_cov <- c("2013-06-01","2017-10-31")

maint_desc <- "completed"

user_id <- "EDI"

package_id <- "edi.207.1"

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
