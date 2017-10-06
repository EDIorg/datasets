# This script reads in dataset knb-lter-mcr.6.55 (level-0) and converts it into the ecocomDP 
# synthesis precursor (level-1; https://github.com/EDIorg/ecocomDP).

# Load libraries --------------------------------------------------------------

library(tidyr)
library(dplyr)
library(geosphere)
library(taxize)
library(reshape2)

# Parameters ------------------------------------------------------------------

rm(list = ls())
working_directory <- "./ecocomDP/"
scope <- "knb-lter-mcm" # Scope of parent data package
identifier <- "6"     # Identifier of parent data package
revision <- "55"         # Revision of parent data package
new_package_id <- "edi.125.1" # Child data package
project_name <- "MCR_Population_Community_Dynamics_Fishes" # Abbreviated project title appended to table names
str_datetime <- "%Y-%m-%d"    # Datetime format string of parent data
taxon_rank_source <- "none" # Source of taxon information. Can be: EML or none

setwd("./ecocomDP/")

#read in the data file
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
#save the raw file and add lat longs for all locations from EML
#write.csv(sites_1, file = "./data/knb-lter-mcr.6.55.locations.csv", row.names = F)

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

write.csv(location_df, file = "./data/MCR_Population_Community_Dynamics_Fishes_sampling_location.csv", row.names = F)

location_df <- read.csv("./data/MCR_Population_Community_Dynamics_Fishes_sampling_location.csv", header = T, as.is = T)

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

#write.csv(variable_names, file = "./data/event_variables.csv", row.names = F)

#add units to variables

variable_names <- read.csv("./data/event_variables.csv", header = T, as.is = T)
events_final <- left_join(events_final, variable_names, by = "variable_name")
events_final <- select(events_final, record_id, event_id, variable_name, value, unit)

write.csv(events_final, file = "./data/MCR_Population_Community_Dynamics_Fishes_event.csv", row.names = F)


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

write.csv(df_taxon_worms, "./data/MCR_Population_Community_Dynamics_Fishes_taxon.csv", row.names = F)

#***************************************************************************************************

# taxon_ancillary table - the trophic behavior of fishes is dependent on size class

df_taxon_ancillary <- select(dt_location_event_id, Taxonomy, Total_Length, Coarse_Trophic, Fine_Trophic)

df_taxon_ancillary <- distinct(df_taxon_ancillary)

#add taxon_ancillary_id to link size classes to trophic behavior
df_taxon_ancillary$taxon_ancillary_id <- seq.int(nrow(df_taxon_ancillary))

df_taxon_ancillary <- gather(df_taxon_ancillary, "variable_name", "value", 2:4)

df_taxon_ancillary <- mutate(df_taxon_ancillary, taxon_id = Taxonomy)

df_taxon_ancillary$datetime <- ""

df_taxon_ancillary$author <- ""

df_taxon_ancillary$record_id <- seq.int(nrow(df_taxon_ancillary))

df_taxon_ancillary <- select(df_taxon_ancillary,record_id, taxon_ancillary_id, taxon_id, datetime, variable_name, value, author)

write.csv(df_taxon_ancillary, file = "./data/MCR_Population_Community_Dynamics_Fishes_taxon_ancillary.csv", row.names = F)

#****************************************************************************************************

# observation table

dt_location_event_taxon_id <- select(dt_location_event_id, sampling_location_id, Date.x, event_id, Taxonomy, Count, Total_Length, Biomass)

#add an observation ID to link count and fish size class and biomass
dt_location_event_taxon_id$observation_id <- seq.int(nrow(dt_location_event_taxon_id))

dt_location_event_taxon_id <- gather(dt_location_event_taxon_id, "variable_name", "value", 5:7)
dt_location_event_taxon_id$package_id <- "1"
dt_location_event_taxon_id$unit[dt_location_event_taxon_id$variable_name == "Biomass"] <- "gram"
dt_location_event_taxon_id$unit[dt_location_event_taxon_id$variable_name == "Total_Length"] <- "millimeter"

dt_location_event_taxon_id <- mutate(dt_location_event_taxon_id, taxon_id = Taxonomy, observation_datetime = Date.x)

dt_location_event_taxon_id$record_id <- seq.int(nrow(dt_location_event_taxon_id))

dt_location_event_taxon_id <- select(dt_location_event_taxon_id,record_id, observation_id, event_id, package_id, sampling_location_id, observation_datetime, taxon_id, variable_name, value, unit)

write.csv(dt_location_event_taxon_id, file = "./data/MCR_Population_Community_Dynamics_Fishes_observation.csv", row.names = F)


#******************************************************************************************************

#Data Summary Table

# Years

dataset_summary <- data.frame(matrix(vector(), 1, 7,
                                     dimnames=list(c(), c("dataset_summary_id", "original_package_id", "length_of_survey_years","number_of_years_samples","std_dev_interval_betw_years","max_num_taxa","geo_extent_bounding_box_m2"))),
                              stringsAsFactors=F)

file_path <- paste("./data/", project_name, "_observation.csv", sep = "")

dataset <- read.csv(file_path, header = T, as.is = T)

file_path <- paste("./data/", project_name, "_taxon.csv", sep = "")

taxon <- read.csv(file_path, header = T, as.is = T)

file_path <- paste("./data/", project_name, "_sampling_location.csv", sep = "")

sampling_location <- read.csv(file_path, header = T, as.is = TRUE)

dataset_summary$dataset_summary_id <- "1"

tmp <- min(as.Date(dataset$observation_datetime, "%Y-%m-%d"))
minyear <- as.numeric(format(tmp,'%Y'))

tmp <- max(as.Date(dataset$observation_datetime, "%Y-%m-%d"))
maxyear <- as.numeric(format(tmp,'%Y')) +1

length_of_survey_years <- maxyear - minyear + 1

dataset_summary$length_of_survey_years <- length_of_survey_years

tmp <- as.Date(dataset$observation_datetime, "%Y-%m-%d")
tmp <- format(tmp, '%Y')
tmp <- unique(tmp)

number_of_years_samples <- length(tmp)

dataset_summary$number_of_years_samples <- number_of_years_samples

tmp <- sort(tmp)
tmp <- sapply(tmp, as.numeric)
interval <- diff(tmp)

stddev <- sd(interval)

dataset_summary$std_dev_interval_betw_years <- stddev

dataset_summary$max_num_taxa <- nrow(taxon)



#calculate area of bounding box
#this min max business still needs some work to figure out which quadrant of the world you are in

lon_west <- min(sampling_location$longitude[!is.na(sampling_location$longitude) == T])
lon_east <- max(sampling_location$longitude[!is.na(sampling_location$longitude) == T])
lat_north <- min(sampling_location$latitude[!is.na(sampling_location$latitude) == T])
lat_south <- max(sampling_location$latitude[!is.na(sampling_location$latitude) == T])

pol <- rbind(c(lon_west, lat_north), c(lon_east, lat_north), c(lon_east, lat_south), c(lon_west, lat_south))

area_m2 <- areaPolygon(pol)

dataset_summary$geo_extent_bounding_box_m2 <- area_m2

#this is the final data summary file
write.csv(dataset_summary, file = "./data/MCR_Population_Community_Dynamics_Fishes_dataset_summary.csv", row.names = FALSE)
