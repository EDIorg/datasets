library(EMLassemblyline)

file_path <- "."

file_names <- list.files(path = file_path, pattern = "*.csv")

import_templates(path = file_path, license = "CCBY", data.files = file_names)

#fix the date column

df_table4 <- read.csv("LSVEG_Table4_Plant_Voucher_Information.csv", as.is = T)
df_table4$CollectionDate <- as.Date(df_table4$CollectionDate, "%d/%m/%Y")
df_table4$DetDate <- as.Date(df_table4$DetDate, "%d/%m/%Y")

write.csv(df_table4, file = "LSVEG_Table4_Plant_Voucher_Information.csv", row.names = F)

define_catvars(path = file_path)

dataset_title <- "Variation in the Composition of Understory Vegetation in a Tropical Rain Forest as a Function of Soil and Topographic Position. 1986 - 1990"

file_descriptions <- c("Environmental information for each site sampled",
                       "La Selva understory vegetation study. Species-by-quadrat data on abundances of plants in the shrub size-class (greater than 1m tall and less than or equal to 5cm dbh) excluding vines and lianas.",
                       "La Selva understory vegetation study. Species by quadrat data on abundances of plants in the small tree size-class (5 - 10 cm dbh at breast height), excluding vines and lianas",
                       "Voucher specimens collected to support identification of the vegetation samples. All specimens are deposited in the herbarium of the La Selva Biological Station, Organization for Tropical Studies, Heredia Province, Costa Rica. The La Selva herbarium also has additional information on the specimens. All vouchers were collected at the La Selva Biological Station, Heredia Province, Sarapiqui, Costa Rica. Identifications made at the time of collection were confirmed or revised in 2015 to reflect recent understanding of the taxonomy and systematics of tropical plants.")

quote_character <- rep("\"",4)

temp_cov <- c("1986-11-01", "1990-10-31")

maint_desc <- "Completed"

user_id <- "EDI"

package_id <- "edi.312.1"

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
