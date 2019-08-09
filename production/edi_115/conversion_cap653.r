# This script converts the dataset fom XXXX into a ecocomDP-compliant set of tables
# see https://github.com/EDIorg/ecocomDP for more information

# Input arguments:
# path - the path to where the ecocomDP tables should be written
# scope - scope of parent data (e.g. "knb-lter-cap")
# identifier - identifier of parent data (e.g. "653")
# revision - revision number for the parent data (e.g. "2")
# new_package_id - ID for the child data (e.g. "edi.211.1")
# project_name - the appreviated project name to be added to the table names (e.g. "land_survey")

# Load libraries ================================================================================================

library(XML)
library(readr)
library(sf)
library(tidyr)
library(ecocomDP)
library(lubridate)
library(taxonomyCleanr)
library(EDIutils)

convert_tables <- function(path,scope,identifier,revision,new_package_id, project_name,taxon_rank_source){

# Validate arguments ========================================================================================
	
	message('Validating arguments')
	
	if (missing(path)){
		stop('Input argument "path" is missing! Specify the path to the directory that will be filled with ecocomDP tables.')
	}
	if (missing(scope)){
		stop('Input argument "scope" is missing! Specify the L0 data package scope (e.g. "knb-lter-cap").')
	}
	if (missing(identifier)){
		stop('Input argument "identifier" is missing! Specify the package identifier number (e.g. "653").')
	}
	if (missing(revision)){
		stop('Input argument "revision" is missing! Specify the package revision number (e.g. "2").')
	}
	if (missing(new_package_id)){
		stop('Input argument "new_package_id" is missing! Specify new package ID (e.g. edi.100.1, or knb-lter-mcr.8.1.')
	}
	if (missing(project_name)){
		stop('Input argument "project.name" is missing! Specify the project name of the L0 dataset.')
	}

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

#Get tables from parent data =================================================================================
	message("Retreiving tables from parent data")
	parcel <- read.csv(file = entity_urls[grep("parcel",entity_names,value=FALSE)])
	human_indicators <- read.csv(file=entity_urls[grep("human",entity_names,value=FALSE)])
	landscape <- read.csv(file=entity_urls[grep("landscape",entity_names,value=FALSE)])
	perennials <- read.csv(file=entity_urls[grep("perennials",entity_names,value=FALSE)])
	landuse <- read.csv(file=entity_urls[grep("landuse",entity_names,value=FALSE)])
	neighborhood <- read.csv(file=entity_urls[grep("neighborhood",entity_names,value=FALSE)])
	sampling_events <- read.csv(file=entity_urls[grep("sampling",entity_names,value=FALSE)])
	
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
	
	# Create location table ========================================================================================
	message("Creating location table")
	location_id <- unique(sampling_events$site_code)
	elevation <- sampling_events$elevation[match(location_id,sampling_events$site_code)]
	location <- data.frame(location_id,elevation)
	
	write.csv(location,file=paste0(path,"/",project_name,"_location.csv"),row.names=FALSE)
		
# Create observation table ==================================================================================
	message("Creating observation table")	
	
	event_tbl <- data.frame(c(1:nrow(perennials)),perennials)
	colnames(event_tbl)[1] <- "event_id"
	
	taxa_tbl <- data.frame(unique(perennials$vegetation_scientific_name),c(1:length(unique(perennials$vegetation_scientific_name))))
	colnames(taxa_tbl) <- c("vegetation_scientific_name","taxon_id")
	
	observation <- gather(event_tbl,key="variable_name",value="value",number_plants)
	observation <- data.frame(observation[,-5],taxa_tbl$taxon_id[match(observation$vegetation_scientific_name,taxa_tbl$vegetation_scientific_name)])
	observation <- observation[,-4]
	observation <- data.frame(c(1:nrow(observation)),observation$event_id,rep(new_package_id,nrow(observation)),observation$site_code,observation$sample_date,observation$taxa_tbl.taxon_id.match.observation.vegetation_scientific_name..,observation$variable_name,observation$value,rep("number",nrow(observation)))
	colnames(observation) <- c("observation_id","event_id","package_id","location_id","observation_datetime","taxon_id","variable_name","value","unit")
	observation$observation_datetime <- EDIutils::datetime_to_iso8601(x = as.character(observation$observation_datetime), orders = 'ymd')
	
	write.csv(observation,file=paste0(path,"/",project_name,"_observation.csv"),row.names=FALSE)
	
# Create taxon table ============================================================================================ 
	message("Creating taxon table")
	
	#taxa_map <- create_taxa_map(path=path,x=taxa_tbl,col = "vegetation_scientific_name")
	#taxa_map <- trim_taxa(path=path)
	#taxa_map <- resolve_sci_taxa(path=path,data.sources = c(1,3,9))
	taxa_map <- read.csv(file=paste0(path,"/taxa_map.csv"))
	
	taxon_rank <- as.vector(taxa_map$rank[unlist(sapply(taxa_tbl$vegetation_scientific_name, function(x) match(x,taxa_map$taxa_raw)))])
	taxon_name <- as.vector(taxa_tbl$vegetation_scientific_name)
	authority_system <- as.vector(taxa_map$authority[unlist(sapply(taxa_tbl$vegetation_scientific_name, function(x) match(x,taxa_map$taxa_raw)))])
	authority_taxon_id <- as.vector(taxa_map$authority_id[unlist(sapply(taxa_tbl$vegetation_scientific_name, function(x) match(x,taxa_map$taxa_raw)))])
	
	taxon <- data.frame(taxa_tbl$taxon_id,taxon_rank,taxon_name,authority_system,authority_taxon_id)
	colnames(taxon)[1] <- "taxon_id"
	
	write.csv(taxon,file=paste0(path,"/",project_name,"_taxon.csv"),row.names=FALSE)
	
# Create dataset summary table ==================================================================================
	message("Creating dataset summary table")
	# Initialize dataset_summary table
	dataset_summary <- data.frame(
		package_id = rep(NA_character_, length(new_package_id)),
		original_package_id = rep(NA_character_, length(new_package_id)),
		length_of_survey_years = rep(NA, length(new_package_id)),
		number_of_years_sampled = rep(NA, length(new_package_id)),
		std_dev_interval_betw_years = rep(NA, length(new_package_id)),
		max_num_taxa = rep(NA, length(new_package_id)),
		geo_extent_bounding_box_m2 = rep(NA, length(new_package_id)),
		stringsAsFactors = FALSE
	)
	
	# Create column: package_id
	
	dataset_summary$package_id <- new_package_id

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
	write.csv(dataset_summary,file=paste0(path,"/",project_name,"_dataset_summary.csv"),row.names=FALSE)
	
# Create location ancillary table ===============================================================================
	message("Creating location ancillary table")
	
	temp <- merge(parcel,human_indicators,all=TRUE)
	temp <- merge(temp,landscape,all=TRUE)
	temp <- merge(temp,landuse,all=TRUE)
	temp <- merge(temp,neighborhood,all=TRUE)
	temp<- merge(temp,sampling_events,all=TRUE)
	
	temp2 <- gather(temp,key="variable_name",value="value",presence_of_other:general_description)
	
	location_ancillary <- data.frame(c(1:nrow(temp2)),temp2$site_code,temp2$sample_date,temp2$variable_name,temp2$value,unit_table$unit_list[match(temp2$variable_name,unit_table$variable_list)])
	colnames(location_ancillary) <- c("location_ancillary_id","location_id","datetime","variable_name","value","unit")
	location_ancillary <- location_ancillary[-which(location_ancillary$variable_name == "elevation"),]
	location_ancillary$datetime <- EDIutils::datetime_to_iso8601(x = as.character(location_ancillary$datetime), orders = 'ymd')
	
	write.csv(location_ancillary,file=paste0(path,"/",project_name,"_location_ancillary.csv"),row.names=FALSE)
	
# Create taxon ancillary table ====================================================================================
	message("Creating taxon ancillary table")
	
	common_name <- as.vector(unique(perennials$common_name[which(is.na(perennials$common_name)==FALSE)]))
	common_name <- common_name[-which(common_name==" ")]
	scientific_name <- as.vector(perennials$vegetation_scientific_name[match(common_name,perennials$common_name)])
	taxon_anc_taxon_id <- taxa_tbl$taxon_id[match(scientific_name,taxa_tbl$vegetation_scientific_name)]
	
	taxon_ancillary <- data.frame(c(1:length(common_name)),taxon_anc_taxon_id,rep("common_name",length(common_name)),common_name,rep(NA_character_,length(common_name)))
	colnames(taxon_ancillary) <- c("taxon_ancillary_id","taxon_id","variable_name","value","unit")
	
	write.csv(taxon_ancillary,file=paste0(path,"/",project_name,"_taxon_ancillary.csv"),row.names=FALSE)
	
#Create variable mapping table ==================================================================================
	message("Creating variable mapping table")
	variable_name <- c(unique(observation$variable_name),unique(location_ancillary$variable_name))
	table_name <- c(rep("observation",length(unique(observation$variable_name))),rep("location_ancillary",length(unique(location_ancillary$variable_name))))
	variable_mapping_id <- c(1:length(variable_name))
	variable_mapping <- data.frame(variable_mapping_id,table_name,variable_name)
	write.csv(variable_mapping,file=paste0(path,"/",project_name,"_variable_mapping.csv"),row.names=FALSE)
	
	
}
convert_tables(path = path,scope=scope,revision=revision,identifier=identifier,project_name = "land_survey",new_package_id = new_package_id)









