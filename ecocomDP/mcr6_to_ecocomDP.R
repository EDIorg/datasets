
setwd("./ecocomDP/")

library(tidyr)
library(dplyr)
library(geosphere)




infile1  <- "https://pasta.lternet.edu/package/data/eml/knb-lter-mcr/6/55/ac2c7a859ce8595ec1339e8530b9ba50" 
infile1 <- sub("^https","http",infile1) 
dt1 <-read.csv(infile1, header=T, sep=",", as.is = T)
write.csv(dt1, file = "./data/knb-lter-mcr.6.55.csv", row.names = F)

#deleting the last row

#read in the edited table
dt1 <- read.csv("./data/knb-lter-mcr.6.55.csv", header = T, as.is = T)
# attempting to convert dt1$Date dateTime string to R date structure (date or POSIXct)                                
tmpDateFormat<-"%Y-%m-%d"
dt1$Date<-as.Date(dt1$Date,format=tmpDateFormat)

#discover events
events <- select(dt1, Date, Cloud_Cover, Wind_Velocity, Sea_State, Swell, Visibility, Surge, Diver)
events <-distinct(events)

#discover locations
locations <- select(dt1, Location, Site, Habitat, Transect, Swath)
locations <- distinct(locations)
sites_1 <- read.csv("./data/knb-lter-mcr.6.55.latlongs.csv", header = T, as.is = T)

#put together the sampling location table
location_df <- data.frame(matrix(ncol = 6, nrow = 0))
col_names <- c("sampling_location_id", "sampling_location_name", "latitude", "longitude", "elevation", "parent_sampling_location_id")
colnames(location_df) <- col_names

#calcuclate the center point for each bounding box
for(i in 1:nrow(sites_1)){
  pol <- rbind(c(sites_1[i,4],sites_1[i,2]), c(sites_1[i,4],sites_1[i,3]), c(sites_1[i,5],sites_1[i,3]), c(sites_1[i,5],sites_1[i,2]), c(sites_1[i,4],sites_1[i,2]))
  center <- centroid(pol)
  sampling_location_id <- sites_1[i,1]
  sampling_location_name <- paste("LTER", sites_1[i,1], sep = " ")
  latitude <- center[2]
  longitude <- center[1]
  
  a <- data.frame("sampling_location_id" = sampling_location_id,
                  "sampling_location_name" = sampling_location_name,
                  "latitude" = latitude,
                  "longitude" = longitude,
                  "elevation" = as.numeric(""),
                  "parent_sampling_location_id" = as.character(NA))
  
  location_df <- rbind(location_df, a)
}

sites_2 <- select(locations, Site, Habitat)
sites_2 <- distinct(sites_2)


a <- data.frame("sampling_location_id" = paste(sites_2$Site, sites_2$Habitat),
                "sampling_location_name" = paste("LTER", sites_2$Site, sites_2$Habitat),
                "latitude" = NA,
                "longitude" = NA,
                "elevation" = NA,
                "parent_sampling_location_id" = as.character(sites_2$Site))

location_df <- rbind(location_df, a)

