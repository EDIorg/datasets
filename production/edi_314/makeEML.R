library(EMLassemblyline)

file_path <- "."

file_names <- list.files(path = file_path, pattern = "*.csv")

#fix dates

df_fixdates <- read.csv("Ziter_UrbanTemp_Dataset_S1.csv", as.is = T)
df_fixdates$DATE <- as.Date(df_fixdates$DATE, "%y-%m-%d")
write.csv(df_fixdates, file ="Ziter_UrbanTemp_Dataset_S1.csv", row.names = F, quote = F)

df_fixdates <- read.csv("Ziter_UrbanTemp_Dataset_S2.csv", as.is = T)
df_fixdates$DATE <- as.Date(df_fixdates$DATE, "%y-%m-%d")
write.csv(df_fixdates, file ="Ziter_UrbanTemp_Dataset_S2.csv", row.names = F, quote = F)

df_fixdates <- read.csv("Ziter_UrbanTemp_Dataset_S3.csv", as.is = T)
df_fixdates$DATE <- as.Date(df_fixdates$DATE, "%y-%m-%d")
write.csv(df_fixdates, file ="Ziter_UrbanTemp_Dataset_S3.csv", row.names = F, quote = F)

import_templates(path = file_path, license = "CCBY", data.files = file_names)

define_catvars(path = file_path)

dataset_title <- "Scale-dependent interactions between tree canopy cover and impervious surfaces reduce daytime urban heat during summer"

file_descriptions <- c("Descriptive variables, summary statistics, and weather conditions for 64 daytime and 12 nighttime mobile transects",
                       "Mobile temperature data for 64 daytime rides in Madison, WI",
                       "Mobile temperature data for 12 nighttime rides in Madison, WI")

quote_character <- rep("\"",3)

temp_cov <- c("2016-06-24", "2016-09-05")

maint_desc <- "Completed"

user_id <- "EDI"

package_id <- "edi.314.2"

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
