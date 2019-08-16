library(EMLassemblyline)

file_path <- "./newdata_8_13_2018"

file_names <- c("EMLSdata_10Aug_afterRev.csv")

#change German formatted date to ISO

datafile <- read.csv(paste(file_path, file_names, sep = "/"), as.is = T)
datafile$Date <- as.Date(datafile$Date, "%d.%m.%Y")
write.csv(datafile, file = "./newdata_8_13_2018/EMLSdata_10Aug_afterRev_dateformated.csv", row.names = F)

#get coordinates
coord_north <- max(datafile$Latitude)
coord_south <- min(datafile$Latitude)
coord_west <- min(datafile$Longitude)
coord_east <- max(datafile$Longitude)

#make geo coverage file
extract_geocoverage(path = file_path,
                    data.file = "EMLSdata_10Aug_afterRev_dateformated.csv",
                    lat.col = "Latitude",
                    lon.col = "Longitude",
                    site.col = "LakeName")

#change to new file name

file_names <- "EMLSdata_10Aug_afterRev_dateformated.csv"

import_templates(path = file_path, license = "CCBY", data.files = file_names)

define_catvars(path = file_path)

dataset_title <- "The European Multi Lake Survey (EMLS) dataset of physical, chemical, algal pigments and cyanotoxin parameters 2015."

file_descriptions <- c("physical, chemical, algal pigments and cyanotoxin parameters for each lake")

quote_character <- rep("\"",1)

temp_cov <- c("2015-06-09","2015-10-05")

maint_desc <- "completed"

user_id <- "EDI"

package_id <- "edi.176.5"

#geographic information

geog_descr <- "Northern Hemisphere"

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
