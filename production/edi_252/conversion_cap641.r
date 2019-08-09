# This script converts the dataset from knb-lter-cap.641 into a ecocomDP-compliant set of tables
# see https://github.com/EDIorg/ecocomDP for more information

# Input arguments:
# data.path - the data.path to where the ecocomDP tables should be written
# scope - scope of parent data (e.g. "knb-lter-cap")
# identifier - identifier of parent data (e.g. "641")
# revision - revision number for the parent data (e.g. "3")
# child_pkg_id - ID for the child data (e.g. "edi.204.1")
# project_name - the appreviated project name to be added to the table names (e.g. "birds)

# Load libraries ================================================================================================

library(XML)
library(readr)
library(sf)
library(dplyr)
library(lubridate)
library(taxonomyCleanr)
library(stringr)
library(EDIutils)

convert_tables <- function(data.path, parent_pkg_id, child_pkg_id){

  project_name <- 'bird_survey'
  
# Validate arguments ========================================================================================
	
  message('Validating arguments')
  
  if (missing(data.path)){
    stop('Input argument "data.path" is missing! Specify the data.path to the directory that will be filled with ecocomDP tables.')
  }
  if (missing(parent_pkg_id)){
    stop('Input argument "parent_pkg_id" is missing!')
  }
  if (missing(child_pkg_id)){
    stop('Input argument "child_pkg_id" is missing!')
  }

  # Parse arguments ===========================================================================================
  
  scope <- unlist(str_split(parent_pkg_id, '\\.'))[1]
  identifier <- unlist(str_split(parent_pkg_id, '\\.'))[2]
  revision <- unlist(str_split(parent_pkg_id, '\\.'))[3]
  
# Load EML and extract information ==========================================================================
	
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

# Gather variable and unit information from metadata ===============================================================
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
	
#Get tables from parent data =================================================================================
	message("Retreiving tables from parent data")
	bird_info <- read.csv(file = entity_urls[grep("birds",entity_names,value=FALSE)])
	reach_info <- read.csv(file=entity_urls[grep("reach",entity_names,value=FALSE)])
	kml <- st_read(entity_urls[grep("locations",entity_names,value=FALSE)])

# Create location table ========================================================================================
	message("Creating location table")
	location <- make_location(bird_info,cols=c("reach","site_code"),kml=kml,col="reach")
	write.csv(location,file=paste0(data.path,"/",project_name,"_location.csv"),row.names=FALSE)
		
# Create observation table ==================================================================================
	message("Creating observation table")	
  
  observation <- data.frame(c(1:nrow(bird_info)),c(1:nrow(bird_info)),rep(child_pkg_id,nrow(bird_info)),location[as.vector(sapply(bird_info$site_code, function(x) grep(x,location$location_name,value=FALSE))),1],bird_info$survey_date,bird_info$code,rep("count",nrow(bird_info)),bird_info$bird_count,rep("number",nrow(bird_info)))
  colnames(observation) <- c("observation_id","event_id","package_id","location_id","observation_datetime","taxon_id","variable_name","value","unit")
	
  observation$observation_datetime <- EDIutils::datetime_to_iso8601(as.character(observation$observation_datetime),
                                                                    orders = 'ymd')
  
  write.csv(observation,file=paste0(data.path,"/",project_name,"_observation.csv"),row.names=FALSE)

# Create taxon table ============================================================================================ 
	message("Creating taxon table")
	
	taxa_tbl <- data.frame(unique(bird_info[,16]),rep("species",length(unique(bird_info$code))),unique(bird_info[,17]))
	colnames(taxa_tbl) <- c("taxon_id","taxon_rank","taxon_name")
	
	#There are names in this dataset listed as "unidentified ___", which will not match with any database
	#In the future, someone can change them to the taxa that represents the intent of the name
	# e.g. "Unidentified Buteo" to "Buteo" or "Unidentified cowbird" to "Molothrus"
	#then those taxa names can be searched using a seperate resolve_sci_taxa
	
	taxa_map <- create_taxa_map(path=data.path,x=taxa_tbl,col="taxon_name")
	taxa_map <- resolve_comm_taxa(path=data.path,data.sources = c(3,12)) #not working?
	taxa_map <- read_csv(file=paste0(data.path,"/taxa_map.csv"))
	
	taxon <- data.frame(taxa_tbl$taxon_id,taxa_map$rank,taxa_map$taxa_raw,taxa_map$authority,taxa_map$authority_id)
	colnames(taxon) <- c("taxon_id","taxon_rank","taxon_name","authority_system","authority_taxon_id")
	
	  write.csv(taxon,file=paste0(data.path,"/",project_name,"_taxon.csv"),row.names=FALSE)
	
# Create dataset summary table ==================================================================================
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
	
	dt <- lubridate::ymd_hms(observation$observation_datetime)
	
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
	
	get_area_square_meters<-function(lon_west,lon_east,lat_north,lat_south){
		xdistN<-1000*getDistanceFromLatLonInKm(lat_north,lon_east,lat_north,lon_west) 
		xdistS<-1000*getDistanceFromLatLonInKm(lat_south,lon_east,lat_south,lon_west) 
		ydist<-1000*getDistanceFromLatLonInKm(lat_north,lon_east,lat_south,lon_east)
		area<-ydist*(xdistN+xdistS/2)
		return(area)
	}
	
	dataset_summary$geo_extent_bounding_box_m2 <- round(get_area_square_meters(westBoundingCoordinate,eastBoundingCoordinate,northBoundingCoordinate,southBoundingCoordinate))
	write.csv(dataset_summary,file=paste0(data.path,"/",project_name,"_dataset_summary.csv"),row.names=FALSE)
	
		
# Create observation ancillary table ============================================================================
	message("Creating observation ancillary table")
	observation_ancillary <- data.frame(c(1:nrow(bird_info)),bird_info[,-c(1,3,19,17,16)])
	observation_ancillary <- gather(observation_ancillary,key="variable_name",value="value",reach:QCcomment)
	observation_ancillary <- data.frame(c(1:nrow(observation_ancillary)),observation_ancillary,unit_table[match(observation_ancillary$variable_name,unit_table$variable_list,nomatch=NA_character_),2])
	colnames(observation_ancillary) <- c("observation_ancillary_id","event_id","variable_name","value","unit")
	observation_ancillary$value <- str_replace_all(observation_ancillary$value,pattern="\r\n",replacement = " ")
	write.csv(observation_ancillary,file=paste0(data.path,"/",project_name,"_observation_ancillary.csv"),row.names=FALSE)
	
# Create location ancillary table ===============================================================================
	message("Creating location ancillary table")
	reach_info$site_code <- as.vector(reach_info$site_code)
	for (i in 1:nrow(reach_info)){
	  reach_info$site_code[i] <- location$location_id[grep(reach_info$site_code[i],location$location_name,value=FALSE)]
	}
	temp <- gather(reach_info[,-2],key="variable_name",value="value",urbanized:water)
	location_ancillary <- data.frame(c(1:nrow(temp)),temp[,1:3],rep(NA,nrow(temp)))
	colnames(location_ancillary) <- c("location_ancillary_id","location_id","variable_name","value","unit")
	write.csv(location_ancillary,file=paste0(data.path,"/",project_name,"_location_ancillary.csv"),row.names=FALSE)
	
#Create variable mapping table ==================================================================================
	message("Creating variable mapping table")
	variable_name <- c(unique(observation$variable_name),unique(observation_ancillary$variable_name),unique(location_ancillary$variable_name))
	table_name <- c(rep("observation",length(unique(observation$variable_name))),rep("observation_ancillary",length(unique(observation_ancillary$variable_name))),rep("location_ancillary",length(unique(location_ancillary$variable_name))))
	variable_mapping_id <- c(1:length(variable_name))
	variable_mapping <- data.frame(variable_mapping_id,table_name,variable_name)
	write.csv(variable_mapping,file=paste0(data.path,"/",project_name,"_variable_mapping.csv"),row.names=FALSE)
	
}
