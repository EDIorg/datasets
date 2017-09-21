
setwd("./ecocomDP/")

library(tidyr)
library(dplyr)
library(geosphere)
library(taxize)
library(reshape2)



infile1  <- "https://pasta.lternet.edu/package/data/eml/knb-lter-mcr/6/55/ac2c7a859ce8595ec1339e8530b9ba50" 
infile1 <- sub("^https","http",infile1) 
dt1 <-read.csv(infile1, header=T, sep=",", as.is = T)

#deleting the last row that seems to contain number of records
dt1 <- filter(dt1, Year > 1900)

#removing erroneously included rows, may not be necessary later
dt1 <- filter(dt1, Habitat != "error")

write.csv(dt1, file = "./data/knb-lter-mcr.6.55.csv", row.names = F)

#read in the table without factors
dt1 <- read.csv("./data/knb-lter-mcr.6.55.csv", header = T, as.is = T)

#******************************************************************************************

#discover location information
locations <- select(dt1, Location, Site, Habitat, Transect, Swath)
locations <- distinct(locations)

sites_1 <- distinct(locations, Site)
write.csv(sites_1, file = "./data/knb-lter-mcr.6.55.locations.csv", row.names = F)

#add lat longs from eml

sites_1 <- read.csv("./data/knb-lter-mcr.6.55.latlongs.csv", header = T, as.is = T)

#put together the sampling location table
location_df <- data.frame(matrix(ncol = 6, nrow = 0))
col_names <- c("sampling_location_id", "sampling_location_name", "latitude", "longitude", "elevation", "parent_sampling_location_id")
colnames(location_df) <- col_names

#calcuclate the center point for each bounding box
#location level 1 - the LTER site
for(i in 1:nrow(sites_1)){
  pol <- rbind(c(sites_1[i,4],sites_1[i,2]), c(sites_1[i,4],sites_1[i,3]), c(sites_1[i,5],sites_1[i,3]), c(sites_1[i,5],sites_1[i,2]), c(sites_1[i,4],sites_1[i,2]))
  if(!is.na(sites_1[i,4])){
    center <- centroid(pol)
    latitude <- center[2]
    longitude <- center[1]
  }
  else{
    latitude <- NA
    longitude <- NA
  }
  sampling_location_id <- sites_1[i,1]
  sampling_location_name <- paste("LTER", sites_1[i,1], sep = " ")
  
  a <- data.frame("sampling_location_id" = sampling_location_id,
                  "sampling_location_name" = sampling_location_name,
                  "latitude" = latitude,
                  "longitude" = longitude,
                  "elevation" = as.numeric(""),
                  "parent_sampling_location_id" = as.character(NA))
  
  location_df <- rbind(location_df, a)
}

#location level 2 habitats within each site
sites_2 <- select(locations, Site, Habitat)
sites_2 <- distinct(sites_2)


a <- data.frame("sampling_location_id" = paste(sites_2$Site, sites_2$Habitat, sep = "_"),
                "sampling_location_name" = paste("LTER", sites_2$Site, sites_2$Habitat),
                "latitude" = NA,
                "longitude" = NA,
                "elevation" = NA,
                "parent_sampling_location_id" = as.character(sites_2$Site))

location_df <- rbind(location_df, a)


#location level 3 transect within each habitat
sites_3 <- select(locations, Site, Habitat, Transect)
sites_3 <- distinct(sites_3)

a <- data.frame("sampling_location_id" = paste(sites_3$Site, sites_3$Habitat, sites_3$Transect, sep = "_"),
                "sampling_location_name" = paste("LTER", sites_3$Site, sites_3$Habitat, sites_3$Transect),
                "latitude" = NA,
                "longitude" = NA,
                "elevation" = NA,
                "parent_sampling_location_id" = as.character(paste(sites_3$Site, sites_3$Habitat, sep = "_")))

location_df <- rbind(location_df, a)

#location level 4 swath within each transect
sites_4 <- locations

a <- data.frame("sampling_location_id" = paste("LTER", sites_4$Site, sites_4$Habitat, sites_4$Transect, sites_4$Swath, sep = "_"),
                "sampling_location_name" = sites_4$Location,
                "latitude" = NA,
                "longitude" = NA,
                "elevation" = NA,
                "parent_sampling_location_id" = as.character(paste(sites_4$Site, sites_4$Habitat, sites_4$Transect, sep = "_")))

location_df <- rbind(location_df, a)

write.csv(location_df, file = "./data/sampling_location.csv", row.names = F)

location_df <- read.csv("./data/sampling_location.csv", header = T, as.is = T)

#add location_id to data table
dt_location_id <- left_join(dt1, location_df, by = c("Location" = "sampling_location_name"))
dt_location_id <- select(dt_location_id, Year:sampling_location_id)

#****************************************************************************************

#discover events

# add a column that can be used to link to an event ID

dt_location_id <- mutate(dt_location_id, event_link = paste(Date, Start, End, Cloud_Cover, Wind_Velocity, Sea_State, Swell, Visibility, Surge, Diver, sep = "_"))
events <- select(dt_location_id, Date, Start, End, Cloud_Cover, Wind_Velocity, Sea_State, Swell, Visibility, Surge, Diver, event_link)
events <-distinct(events)
events$event_id <- seq.int(nrow(events))

dt_location_event_id <- left_join(dt_location_id, events, by = "event_link")
dt_location_event_id <- select(dt_location_event_id, Date.x, Taxonomy:Fine_Trophic, sampling_location_id, event_id)

events <- select(events, -event_link)
events$Date <- as.character(events$Date)
events_final <- gather(events, "variable_name", "value", 1:10)
events_final$record_id <- seq.int(nrow(events_final))
variable_names <- distinct(events_final, variable_name)

#write.csv(variable_names, file = "./data/event_variables. csv", row.names = F)

#add units to variables

variable_names <- read.csv("./data/event_variables. csv", header = T, as.is = T)
events_final <- left_join(events_final, variable_names, by = "variable_name")
events_final <- select(events_final, record_id, event_id, variable_name, value, unit)

write.csv(events_final, file = "./data/event.csv", row.names = F)


#************************************************************************************************

#taxonomy

taxa <- select(dt1, Taxonomy)
taxa <- distinct(taxa)

cleaned_species_list <- as.vector(taxa$Taxonomy)

#clean up the taxon name a bit more
for (i in 1:length(cleaned_species_list)){
  cleaned_species_list[i] <- sub(substr(cleaned_species_list[i], 1, 1),toupper(substr(cleaned_species_list[i], 1, 1)),cleaned_species_list[i])
  cleaned_species_list[i] <- gsub(" sp\\.", "", cleaned_species_list[i])
  cleaned_species_list[i] <- gsub(" unidentified", "", cleaned_species_list[i])
  cleaned_species_list[i] <- gsub(" \\(cf\\)", "", cleaned_species_list[i])
  cleaned_species_list[i] <- gsub(" [0-9]+", "", cleaned_species_list[i])
  cleaned_species_list[i] <- trimws(cleaned_species_list[i])
#  print(cleaned_species_list[i])
}

taxa <- cbind(taxa, as.data.frame(cleaned_species_list))
species_list <- unique(cleaned_species_list)


#worms seems to be the best database here. It returns a slightly different format than ITIS, hence slight changes in for loop
# dbs <- c("itis", "ncbi", "worms")
# urls <- c("https://www.itis.gov/", "https://www.ncbi.nlm.nih.gov/Taxonomy", "http://www.marinespecies.org/")

taxon_info_worms <- classification(species_list, db = 'worms')

#create the taxon table to hold the information
df_taxon <- data.frame(matrix(nrow = 0, ncol = 7))
col_names <- c("name", "rank", "value", "authority_system", "rs_taxon_name")
colnames(df_taxon) <- col_names

for (i in 1:length(species_list)) {
  if (length(taxon_info_worms[[i]]) > 1) {
    d <- nrow(melt(taxon_info_worms[i]))
    taxon_record <- as.data.frame(slice(melt(taxon_info_worms[i]), d))
    taxon_record <- select(taxon_record, name, rank, value)
    taxon_record$rs_taxon_name <- species_list[i]
    taxon_record <- mutate(taxon_record, authority_system = "http://www.marinespecies.org/")
  }else{
    taxon_record <- data.frame("rs_taxon_name" = species_list[i],
                               "name" = species_list[i],
                               "rank" = "",
                               "value" = "",
                               "authority_system" = "")
  }
  df_taxon <- rbind(df_taxon, taxon_record)
}

#link this information back up with their taxon ids (their taxon names)
df_taxon_worms <- left_join(df_taxon, taxa, by = c("name" = "cleaned_species_list"))

#rename column headers
df_taxon_worms <- mutate(df_taxon_worms, taxon_id = Taxonomy, taxon_name = name, taxon_rank = rank, authority_taxon_id = value)

#pick the columns needed
df_taxon_worms <- select(df_taxon_worms, taxon_id, taxon_rank, taxon_name, authority_system, authority_taxon_id)

write.csv(df_taxon_worms, "./data/taxon.csv", row.names = F)

#***************************************************************************************************

#discover relationships between trophic behavior and size of fish

df_trophic_size <- select(dt_location_event_id, Taxonomy, Total_Length, Coarse_Trophic, Fine_Trophic )

df_distinct_trophic <- distinct(df_trophic_size, Coarse_Trophic, Fine_Trophic)


# taxon_ancillary table

df_taxon_ancillary <- select(dt_location_event_id, Taxonomy, Coarse_Trophic, Fine_Trophic)

df_taxon_ancillary <- gather(df_taxon_ancillary, "variable_name", "value", 2:3)

df_taxon_ancillary <- distinct(df_taxon_ancillary)

df_taxon_ancillary <- mutate(df_taxon_ancillary, taxon_id = Taxonomy)

df_taxon_ancillary$datetime <- ""

df_taxon_ancillary$author <- ""

df_taxon_ancillary$taxon_ancillary_id <- seq.int(nrow(df_taxon_ancillary))

df_taxon_ancillary <- select(df_taxon_ancillary, taxon_ancillary_id, taxon_id, datetime, variable_name, value, author)

write.csv(df_taxon_ancillary, file = "./data/taxon_ancillary.csv", row.names = F)

#****************************************************************************************************

# observation table

dt_location_event_taxon_id <- select(dt_location_event_id, sampling_location_id, Date.x, event_id, Taxonomy, Count, Total_Length, Biomass)

dt_location_event_taxon_id <- gather(dt_location_event_taxon_id, "variable_name", "value", 5:7)
dt_location_event_taxon_id$package_id <- "1"
dt_location_event_taxon_id$unit[dt_location_event_taxon_id$variable_name == "Biomass"] <- "gram"
dt_location_event_taxon_id$unit[dt_location_event_taxon_id$variable_name == "Total_Length"] <- "millimeter"

dt_location_event_taxon_id <- mutate(dt_location_event_taxon_id, taxon_id = Taxonomy, observation_datetime = Date.x)

dt_location_event_taxon_id$observation_id <- seq.int(nrow(dt_location_event_taxon_id))

dt_location_event_taxon_id <- select(dt_location_event_taxon_id, observation_id, event_id, package_id, sampling_location_id, observation_datetime, taxon_id, variable_name, value, unit)

write.csv(dt_location_event_taxon_id, file = "./data/observation.csv", row.names = F)
