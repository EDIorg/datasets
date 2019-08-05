# Create ecocomDP data package
#
# This script converts knb-lter-bnz.504.x to the ecocomDP, validates the 
# resultant tables, and creates the associated EML record.

# Initialize workspace --------------------------------------------------------

library(XML)
library(readr)
library(sf)
library(tidyr)
library(dplyr)
library(ecocomDP)
library(lubridate)
library(taxonomyCleanr)
library(dataCleanr)

path <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\ecocomDP\\knb-lter-bnz-504'
parent_pkg_id <- 'knb-lter-bnz.504.7'
child_pkg_id <- 'edi.251.1'

# Create ecocomDP tables ------------------------------------------------------

convert_tables(path, parent_pkg_id, child_pkg_id)

# Validate tables -------------------------------------------------------------
# Correct each error and rerun until no more errors occur.

ecocomDP::validate_ecocomDP(
  data.path = path
)

# Define categorical variables ------------------------------------------------

catvars <- ecocomDP::define_variables(
  data.path = path,
  parent.pkg.id = parent_pkg_id
)
if ('Notes' %in% catvars$code){
  use_i <- catvars$code == 'Notes'
  catvars$definition[use_i] <- 'Notes'
}
if ('Lure' %in% catvars$code){
  use_i <- catvars$code == 'Lure'
  catvars$definition[use_i] <- 'Bait used to attract insects'
}
if ('count' %in% catvars$code){
  use_i <- catvars$code == 'count'
  catvars$definition[use_i] <- 'Count of individuals for species'
}
use_i <- catvars$code == 'actual_date_resolution'
catvars$definition[use_i] <- 'Actual date resolution is year. -01-01 was appended to these years to make a consistent date format required by the EML metadata.'

# Contact information for creator of this script ------------------------------

additional_contact <- data.frame(
  givenName = 'Colin',
  surName = 'Smith',
  organizationName = 'Environmental Data Initiative',
  electronicMailAddress = 'colin.smith@wisc.edu',
  stringsAsFactors = FALSE
)

# Make EML --------------------------------------------------------------------

ecocomDP::make_eml(
  data.path = path,
  code.path = path,
  parent.package.id = parent_pkg_id,
  child.package.id = child_pkg_id,
  sep = ',',
  cat.vars = catvars,
  user.id = 'csmith',
  affiliation = 'LTER',
  intellectual.rights = 'CC0',
  code.file.extension = '.R',
  additional.contact = additional_contact
)

# Conversion function ---------------------------------------------------------
  
convert_tables <- function(path, parent_pkg_id, child_pkg_id){
  
  project_name <- 'beetle_survey'
    
  # Validate arguments --------------------------------------------------------
  
  message('Validating arguments')
  
  if (missing(path)){
    stop('Input argument "path" is missing! Specify the path to the directory that will be filled with ecocomDP tables.')
  }
  if (missing(parent_pkg_id)){
    stop('Input argument "child_pkg_id" is missing! Specify new package ID (e.g. edi.245.1')
  }
  if (missing(child_pkg_id)){
    stop('Input argument "project.name" is missing! Specify the project name of the L0 dataset.')
  }
  
  # Parse arguments -----------------------------------------------------------
  
  scope <- unlist(str_split(parent_pkg_id, '\\.'))[1]
  identifier <- unlist(str_split(parent_pkg_id, '\\.'))[2]
  revision <- unlist(str_split(parent_pkg_id, '\\.'))[3]
  
  # Load EML and extract information ------------------------------------------
  
  message('Loading EML of parent data package')
  
  # EML
  
  metadata <- xmlParse(paste("http://pasta.lternet.edu/package/metadata/eml",
                             "/",
                             scope,
                             "/",
                             identifier,
                             "/",
                             revision,
                             sep = ""))
  
  # File names
  
  entity_names <- c(unlist(
    xmlApply(metadata["//dataset/dataTable/entityName"], 
             xmlValue)
  ),unlist(xmlApply(metadata["//dataset/otherEntity/entityName"],xmlValue)))
  
  # Table delimiters
  
  entity_delimiters <- unlist(
    xmlApply(metadata["//dataset/dataTable/physical/dataFormat/textFormat/simpleDelimited/fieldDelimiter"], 
             xmlValue)
  )
  
  # File URLs
  
  entity_urls <- c(unlist(
    xmlApply(metadata["//dataset/dataTable/physical/distribution/online/url"], 
             xmlValue)),unlist(xmlApply(metadata["//dataset/otherEntity/physical/distribution/online/url"],xmlValue)))
  
  # Dataset title
  
  entity_title <- unlist(
    xmlApply(metadata["//dataset/title"], 
             xmlValue)
  )
  
  # Geographic coverage of study
  
  westBoundingCoordinate <- as.numeric(
    unlist(
      xmlApply(
        metadata["//dataset/coverage/geographicCoverage/boundingCoordinates/westBoundingCoordinate"], 
        xmlValue
      )
    )
  )
  
  eastBoundingCoordinate <- as.numeric(
    unlist(
      xmlApply(
        metadata["//dataset/coverage/geographicCoverage/boundingCoordinates/eastBoundingCoordinate"], 
        xmlValue
      )
    )
  )
  
  southBoundingCoordinate <- as.numeric(
    unlist(
      xmlApply(
        metadata["//dataset/coverage/geographicCoverage/boundingCoordinates/southBoundingCoordinate"], 
        xmlValue
      )
    )
  )
  
  northBoundingCoordinate <- as.numeric(
    unlist(
      xmlApply(
        metadata["//dataset/coverage/geographicCoverage/boundingCoordinates/northBoundingCoordinate"], 
        xmlValue
      )
    )
  )
  
  # Get tables from parent data -----------------------------------------------
  
  message("Retreiving tables from parent data")
  beetle_data <- read.csv(file = entity_urls[grep("Beetles",entity_names,value=FALSE)], as.is = T)
  
  # Gather variable and unit information from metadata ------------------------
  
  message("Gathering variable and unit information")
  unit_scan <- metadata["//dataset/dataTable/attributeList/attribute"]
  variable_list <- c()
  unit_list <- c()
  
  for (i in 1:length(unit_scan)){
    if (xmlName(unit_scan[[i]][[4]][[1]]) == "ratio"){
      variable_list <- c(variable_list,xmlValue(unit_scan[[i]][[1]]))
      unit_list <- c(unit_list,xmlValue(unit_scan[[i]][[4]][[1]][[1]]))
    }
  }
  unit_table <- data.frame(variable_list,unit_list)
  
  # Create location table -----------------------------------------------------
  
  message("Creating location table")
  
  location_name <- as.vector(unique(beetle_data$Location))
  location_id <- c(1:length(location_name))
  latitude <- as.vector(beetle_data$North[match(location_name,beetle_data$Location)])
  longitude <- as.vector(beetle_data$West[match(location_name,beetle_data$Location)])
  location <- data.frame(location_id,location_name,latitude,longitude, stringsAsFactors = F)
  location$latitude[location$latitude == 'N/A'] <- NA_character_
  location$longitude[location$longitude == 'N/A'] <- NA_character_
  location$parent_location_id <- NA_character_
  location$parent_location_id[2:nrow(location)] <- 1
  
  write.csv(location,file=paste0(path,"/",project_name,"_location.csv"),quote=FALSE,row.names=FALSE)
  
  # Create observation table --------------------------------------------------
  
  message("Creating observation table")	
  
  event_id <- c(1:nrow(beetle_data))
  temp <- data.frame(beetle_data,c(1:nrow(beetle_data)))
  colnames(temp)[20] <- "event_id"
  temp2 <- gather(temp,key="taxon_id",value="value",4:16,na.rm=TRUE)
  temp2$value[temp2$value == 'N/A'] <- NA_character_
  location_id <- location$location_id[match(temp2$Location,location$location_name)]
  observation_datetime <- as.vector(temp2$Date)
  
  # Observation datetimes are of different formats. Converge on common format
  # and note differences in observation_ancillary table.
  index_years <- suppressWarnings(is.na(dataCleanr::iso8601_char(x = observation_datetime, 'ymd')))
  observation_datetime[index_years] <- paste0(observation_datetime[index_years], '-01-01')
  
  variable_name <- rep("count",nrow(temp2))
  unit <- rep(NA_character_,nrow(temp2))
  package_id <- rep(child_pkg_id,nrow(temp2))
  
  observation <- data.frame(c(1:nrow(temp2)),temp2$event_id,package_id,location_id,observation_datetime,temp2$taxon_id,variable_name,temp2$value,unit, stringsAsFactors = F)
  colnames(observation) <- c("observation_id","event_id","package_id","location_id","observation_datetime","taxon_id","variable_name","value","unit")
  
  write.csv(observation,file=paste0(path,"/",project_name,"_observation.csv"),quote=FALSE,row.names=FALSE)
  
  # Create taxon table --------------------------------------------------------
  
  message("Creating taxon table")
  
  taxon_id <- as.vector(unique(observation$taxon_id))
  taxon_list <- as.vector(unique(observation$taxon_id))
  taxon_list_fixed <- gsub(pattern = ".",replacement = " ",taxon_list,fixed=TRUE)
  taxon_list_fixed <- gsub(pattern = "Other ",replacement="",taxon_list_fixed,fixed=TRUE)
  taxon_list_fixed[which(taxon_list_fixed == "Buprestid")] <- "Buprestidae"
  taxon_list_fixed[which(taxon_list_fixed == "Cerambicid")] <- "Cerambycidae"                 
  
  taxon_table <- taxon_list_fixed
  taxon_table <- taxonomyCleanr::trim_taxa(x = taxon_table)
  taxa_map <- taxonomyCleanr::resolve_sci_taxa(x = taxon_table, data.sources = c(3,1,11))
  
  taxon_rank <- taxa_map$rank
  taxon_name <- taxa_map$taxa_clean
  taxon_name[is.na(taxon_name)] <- taxa_map$taxa[is.na(taxon_name)]
  authority_system <- taxa_map$authority
  authority_taxon_id <- taxa_map$authority_id
  
  taxon <- data.frame(taxon_id,taxon_rank,taxon_name,authority_system,authority_taxon_id, stringsAsFactors = F)
  
  write.csv(taxon,file=paste0(path,"/",project_name,"_taxon.csv"),quote=FALSE,row.names=FALSE)
  
  # Create dataset summary table ----------------------------------------------
  
  message("Creating dataset summary table")
  # Initialize dataset_summary table
  dataset_summary <- data.frame(
    package_id = rep(NA_character_, length(child_pkg_id)),
    original_package_id = rep(NA_character_, length(child_pkg_id)),
    length_of_survey_years = rep(NA, length(child_pkg_id)),
    number_of_years_sampled = rep(NA, length(child_pkg_id)),
    std_dev_interval_betw_years = rep(NA, length(child_pkg_id)),
    max_num_taxa = rep(NA, length(child_pkg_id)),
    geo_extent_bounding_box_m2 = rep(NA, length(child_pkg_id)),
    stringsAsFactors = FALSE
  )
  
  # Create column: package_id
  
  dataset_summary$package_id <- child_pkg_id
  
  # Create column: original_package_id
  
  dataset_summary$original_package_id <- paste(
    scope,
    identifier,
    revision,
    sep = '.'
  )
  
  # Create column: number_of_years_sampled
  
  dt <- lubridate::ymd(observation$observation_datetime)
  
  dt <- dt[order(dt)]
  
  dt <- dt[
    !is.na(
      dt
    )
    ]
  
  dt_int <- interval(
    dt[1],
    dt[length(dt)]
  )
  
  dataset_summary$number_of_years_sampled <- floor(
    time_length(
      dt_int,
      "year"
    )
  )
  
  # Create column: length_of_survey_years
  
  dataset_summary$length_of_survey_years <-  lubridate::time_length(interval(min(dt),max(dt)), unit = 'year')
  
  # Create column: std_dev_interval_betw_years
  
  dt_uni <- unique(dt)
  
  dt_uni <- dt_uni[order(dt_uni)]
  
  dataset_summary$std_dev_interval_betw_years <- sd(diff(dt_uni)/365)
  
  # Create column: max_num_taxa
  
  dataset_summary$max_num_taxa <- nrow(taxon)
  
  # Create column: geo_extent_bounding_box_m2
  
  # geo_extent_bounding_box_m2
  # https://stackoverflow.com/questions/27928/calculate-distance-between-two-latitude-longitude-points-haversine-formula
  
  getDistanceFromLatLonInKm<-function(lat1,lon1,lat2,lon2) {
    R <- 6371; # Radius of the earth in km
    dLat <- deg2rad(lat2-lat1);	# deg2rad below
    dLon = deg2rad(lon2-lon1); 
    a <- sin(dLat/2) * sin(dLat/2) + cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * sin(dLon/2) * sin(dLon/2) 
    c <- 2 * atan2(sqrt(a), sqrt(1-a)) 
    d <- R * c # Distance in km
    return(d)
  }
  
  deg2rad<-function(deg) {
    return(deg * (pi/180))
  }
  
  get_area_square_meters<-function(lon_west,lon_east,lat_north,lat_south) {
    xdistN<-1000*getDistanceFromLatLonInKm(lat_north,lon_east,lat_north,lon_west) 
    xdistS<-1000*getDistanceFromLatLonInKm(lat_south,lon_east,lat_south,lon_west) 
    ydist<-1000*getDistanceFromLatLonInKm(lat_north,lon_east,lat_south,lon_east)
    area<-ydist*(xdistN+xdistS/2)
    return(area)
  }
  
  dataset_summary$geo_extent_bounding_box_m2 <- round(get_area_square_meters(westBoundingCoordinate,eastBoundingCoordinate,northBoundingCoordinate,southBoundingCoordinate))
  write.csv(dataset_summary,file=paste0(path,"/",project_name,"_dataset_summary.csv"),quote=FALSE,row.names=FALSE)
  
  # Create observation ancillary table ----------------------------------------
  
  message("Creating observation ancillary table")
  
  temp3 <- temp2[which(temp2$Lure != "" | temp2$Notes != ""),]
  temp3 <- gather(temp3,key="variable_name",value="value",na.rm = TRUE,c(Notes,Lure))
  temp3 <- temp3[which(temp3$value != ""),]
  
  observation_ancillary <- data.frame(c(1:nrow(temp3)),temp3$event_id,temp3$variable_name,temp3$value,rep(NA_character_,nrow(temp3)), stringsAsFactors = F)
  colnames(observation_ancillary) <- c("observation_ancillary_id","event_id","variable_name","value","unit")
  observation_ancillary$value <- gsub(",",";",observation_ancillary$value)
  
  # Add notes about coerced datetimes reported in the observation table
  datetime_notes <- data.frame(observation_ancillary_id = seq(max(observation_ancillary$observation_ancillary_id)+1,
                                                              max(observation_ancillary$observation_ancillary_id)+sum(index_years)),
                               event_id = NA_character_,
                               variable_name = NA_character_,
                               value = NA_character_,
                               unit = NA_character_,
                               stringsAsFactors = F)
  datetime_notes$event_id <- observation$event_id[index_years]
  datetime_notes$variable_name <- 'actual_date_resolution'
  datetime_notes$value <- 'YYYY'
  observation$observation_datetime[datetime_notes$event_id]
  observation_ancillary <- rbind(observation_ancillary, datetime_notes)
  
  write.csv(observation_ancillary,file=paste0(path,"/",project_name,"_observation_ancillary.csv"),quote=FALSE,row.names=FALSE)
  
  # Create variable mapping table ----------------------------------------------
  
  message("Creating variable mapping table")
  
  variable_mapping <- make_variable_mapping(
    observation = observation,
    observation_ancillary = observation_ancillary
  )
  # Define 'count'
  use_i <- variable_mapping$variable_name == 'count'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/individualCount'
  variable_mapping$mapped_label[use_i] <- 'individualCount'
  # Define 'notes'
  use_i <- variable_mapping$variable_name == 'Notes'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/fieldNotes'
  variable_mapping$mapped_label[use_i] <- 'fieldNotes'
  
  
  write.csv(variable_mapping,file=paste0(path,"/",project_name,"_variable_mapping.csv"),quote=FALSE,row.names=FALSE)
  
  
}

