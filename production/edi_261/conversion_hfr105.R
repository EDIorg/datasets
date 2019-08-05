# This script converts the dataset fom XXXX into a ecocomDP-compliant set of tables
# see https://github.com/EDIorg/ecocomDP for more information

# Input arguments:
# path - the path to where the ecocomDP tables should be written
# scope - scope of parent data (e.g. "knb-lter-cap")
# identifier - identifier of parent data (e.g. "641")
# revision - revision number for the parent data (e.g. "14")
# new_package_id - ID for the child data (e.g. "edi.196.1")
# project_name - the appreviated project name to be added to the table names (e.g. "core_arthropod_survey")


# Load libraries ================================================================================================

library(XML)
library(readr)
library(sf)
library(tidyverse)
library(ecocomDP)
library(lubridate)
library(taxonomyCleanr)

convert_tables <- function(path,scope,identifier,revision,new_package_id, project_name,taxon_rank_source){

# Validate arguments ========================================================================================
	
	message('Validating arguments')
	
	if (missing(path)){
		stop('Input argument "path" is missing! Specify the path to the directory that will be filled with ecocomDP tables.')
	}
	if (missing(scope)){
		stop('Input argument "scope" is missing! Specify the L0 data package scope (e.g. "knb-lter-hfr").')
	}
	if (missing(identifier)){
		stop('Input argument "identifier" is missing! Specify the package identifier number (e.g. "105").')
	}
	if (missing(revision)){
		stop('Input argument "revision" is missing! Specify the package revision number (e.g. "22").')
	}
	if (missing(new_package_id)){
		stop('Input argument "new_package_id" is missing! Specify new package ID (e.g. edi.249.1, or knb-lter-mcr.8.1.')
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
	seedbank_2004 <- read.csv(file = entity_urls[grep("seedbank-2004",entity_names,value=FALSE)])
	understory_2004 <- read.csv(file=entity_urls[grep("understory-2004",entity_names,value=FALSE)])
	seedbank_2010 <- read.csv(file=entity_urls[grep("seedbank-2010",entity_names,value=FALSE)])
	understory_2010 <- read.csv(file=entity_urls[grep("understory-2010",entity_names,value=FALSE)])
	seed_rain <- read.csv(file=entity_urls[grep("rain",entity_names,value=FALSE)])
	sample_coord <- read.csv(file=entity_urls[grep("coord",entity_names,value=FALSE)])
	species_codes <- read.csv(file=entity_urls[grep("species",entity_names,value=FALSE)])
	
# Gather variable and unit information from metadata ===============================================================
	message("Gathering variable and unit information")
	unit_scan <- metadata["//dataset/dataTable/attributeList/attribute"]
	variable_list <- c()
	unit_list <- c()
	
	for (i in 1:length(unit_scan)){
	  if (xmlName(unit_scan[[i]][[3]][[1]]) == "ratio" | xmlName(unit_scan[[i]][[3]][[1]]) == "interval"){
	    variable_list <- c(variable_list,xmlValue(unit_scan[[i]][[1]]))
	    unit_list <- c(unit_list,xmlValue(unit_scan[[i]][[3]][[1]][[1]]))
	  }
	}
	unit_table <- data.frame(variable_list,unit_list)
	
	# Create location table ========================================================================================
	message("Creating location table")
	
	location <- make_location(sample_coord,cols=c("block","plot","replicate"))
	
	write.csv(location,file=paste0(path,"/",project_name,"_location.csv"),row.names = FALSE,quote = FALSE)
		
# Create observation table ==================================================================================
	message("Creating observation table")	
	
	seedbank_2004 <- data.frame(seedbank_2004,c(1:nrow(seedbank_2004)))
	seedbank_2010 <- data.frame(seedbank_2010,c(1:nrow(seedbank_2010))+nrow(seedbank_2004))
	understory_2004 <- data.frame(understory_2004,c(1:nrow(understory_2004))+(nrow(seedbank_2004)+nrow(seedbank_2010)))
	understory_2010 <- data.frame(understory_2010,c(1:nrow(understory_2010))+(nrow(seedbank_2004)+nrow(seedbank_2010)+nrow(understory_2004)))
	seed_rain <- data.frame(seed_rain,c(1:nrow(seed_rain))+(nrow(seedbank_2004)+nrow(seedbank_2010)+nrow(understory_2004)+nrow(understory_2010)))
	
	colnames(seedbank_2004)[47] <- "event_id"
	colnames(seedbank_2010)[58] <- "event_id"
	colnames(understory_2004)[29] <- "event_id"
	colnames(understory_2010)[51] <- "event_id"
	colnames(seed_rain)[17] <- "event_id"
	
	seedbank_2004_long <- gather(seedbank_2004,key="variable_name",value="value",acru:poaceae)
	understory_2004_long <- gather(understory_2004,key="variable_name",value="value",acru:deob)
	data_2004 <- rbind(seedbank_2004_long,understory_2004_long)
	
	seedbank_2010_long <- gather(seedbank_2010,key="variable_name",value="value",bele:cadw)
	understory_2010_long <- gather(understory_2010,key="variable_name",value="value",depu:cope)
	
	data_2004 <- data.frame(data_2004, sapply(data_2004$simes.plot,function(x) {ifelse(any(x %in% c(1:3,8)),"valley","ridge")}))
	colnames(data_2004)[9] <- "block"
	data_2004 <- data.frame(data_2004, sapply(c(1:nrow(data_2004)),function(x) paste(data_2004$block[x],data_2004$simes.plot[x],data_2004$replicate[x],sep = "_")))
	colnames(data_2004)[10] <- "location_id"
	data_2004$location_id <- location$location_id[match(data_2004$location_id,location$location_name)]
	data_2004 <- data.frame(data_2004,rep("2004-01-01T12:00:00"))
	colnames(data_2004)[11] <- "observation_datetime"
	
	seedbank_2010_long <- data.frame(seedbank_2010_long,sapply(c(1:nrow(seedbank_2010_long)),function(x) paste(seedbank_2010_long$block[x],seedbank_2010_long$plot[x],seedbank_2010_long$replicate[x],sep="_")))
	colnames(seedbank_2010_long)[9] <- "location_id"
	seedbank_2010_long$location_id <- location$location_id[match(seedbank_2010_long$location_id,location$location_name)]
	seedbank_2010_long <- data.frame(seedbank_2010_long,rep("2010-01-01T12:00:00"))
	colnames(seedbank_2010_long)[10] <- "observation_datetime"
	
	understory_2010_long <- data.frame(understory_2010_long,sapply(c(1:nrow(understory_2010_long)),function(x) paste(understory_2010_long$block[x],understory_2010_long$plot[x],understory_2010_long$replicate[x],sep="_")))
	colnames(understory_2010_long)[9] <- "location_id"
	understory_2010_long$location_id <- location$location_id[match(understory_2010_long$location_id,location$location_name)]
	understory_2010_long$date <- sapply(understory_2010_long$date,function(x) paste0(x,"T12:00:00"))
	colnames(understory_2010_long)[1] <- "observation_datetime"
	
	colnames(seed_rain)[1] <- "observation_datetime"
	seed_rain <- data.frame(seed_rain,sapply(c(1:nrow(seed_rain)),function(x) paste(seed_rain$block[x],seed_rain$plot[x],sep="_")))
	colnames(seed_rain)[18] <- "location_id"
	seed_rain$location_id <- location$location_id[match(seed_rain$location_id,location$location_name)]
	seed_rain$observation_datetime <- sapply(seed_rain$observation_datetime,function(x) paste0(x,"T12:00:00"))
	seed_rain <- data.frame(seed_rain,sapply(c(1:nrow(seed_rain)),function(x) paste(seed_rain$genus[x],seed_rain$species[x])))
	colnames(seed_rain)[19] <- "taxon_name"
	
	seed_rain_taxa <- as.vector(unique(seed_rain$taxon_name[which(seed_rain$taxon_name %in% species_codes$species.name == FALSE)]))
	code_seed_rain_taxa <- c("besp","pobi","acsp","nysy","qusp","osvir","coal","caum","cosp","vasp","rhsp","vide","amspe","frsp","tssp","viac","prsp","vica","coali","visp","cysp","saal")
	seed_rain_taxa <- data.frame(code_seed_rain_taxa,seed_rain_taxa)
	colnames(seed_rain_taxa) <- colnames(species_codes)
	species_codes <- rbind(species_codes,seed_rain_taxa)
	seed_rain$taxon_name <- species_codes$species.code[match(seed_rain$taxon_name,species_codes$species.name)]
	

	event_id <- c(data_2004$event_id,seedbank_2010_long$event_id,understory_2010_long$event_id,seed_rain$event_id)
	package_id <- rep(new_package_id,length(event_id))
	observation_datetime <- c(as.vector(data_2004$observation_datetime),as.vector(seedbank_2010_long$observation_datetime),as.vector(understory_2010_long$observation_datetime),as.vector(seed_rain$observation_datetime))
	taxon_id <- c(as.vector(data_2004$variable_name),as.vector(seedbank_2010_long$variable_name),as.vector(understory_2010_long$variable_name),as.vector(seed_rain$taxon_name))
	variable_name <- rep("count",length(event_id))
	value <- c(data_2004$value,seedbank_2010_long$value,understory_2010_long$value,seed_rain$seed.count)
	unit <- rep(NA_character_,length(value))
	observation_id <- c(1:length(event_id))
	location_id <- c(as.vector(data_2004$location_id),as.vector(seedbank_2010_long$location_id),as.vector(understory_2010_long$location_id),as.vector(seed_rain$location_id))
	
	observation <- data.frame(observation_id,event_id,package_id,location_id,observation_datetime,taxon_id,variable_name,value,unit)
	
	write.csv(observation,file=paste0(path,"/",project_name,"_observation.csv"),row.names=FALSE,quote=FALSE)
	
# Create taxon table ============================================================================================ 
	message("Creating taxon table")
	
	species_codes$species.code <- as.vector(species_codes$species.code)
	species.code <- c(species_codes$species.code,"juef","vinu")
	species_codes$species.name <- as.vector(species_codes$species.name)
	species.name <- c(species_codes$species.name,"Juncus effusus","Viburnum nudum")
	species_codes <- data.frame(species.code,species.name)
  taxa_map <- create_taxa_map(path=path,x=species_codes,col="species.name")
  taxa_map <- replace_taxa(path=path,input="Total number of Poaceae (grasses)","Poaceae")
  taxa_map <- replace_taxa(path=path,input="Total number of Rubus (= rufl + rusp)","Rubus")
  taxa_map <- replace_taxa(path=path,input="Total number of Betula spp. ","Betula")
  taxa_map <- 
  taxa_map <-trim_taxa(path=path)
  taxa_map <- resolve_sci_taxa(path=path,data.sources = c(3,11))
	taxa_map <- read.csv(paste0(path,"/taxa_map.csv"))
  
	taxon_id <- species_codes$species.code
	taxon_rank <- as.vector(taxa_map$rank)
	taxon_name <- as.vector(taxa_map$taxa_clean)
	authority_system <- as.vector(taxa_map$authority)
	authority_taxon_id <- as.vector(taxa_map$authority_id)
	
	taxon <- data.frame(taxon_id,taxon_rank,taxon_name,authority_system,authority_taxon_id)
	
	write.csv(taxon,file=paste0(path,"/",project_name,"_taxon.csv"),row.names=FALSE,quote=FALSE)
	
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
	
	dt <- observation$observation_datetime[order(observation$observation_datetime)]
	
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
	
	tot_int <- interval(unlist(xmlApply(metadata["//dataset/coverage/temporalCoverage/rangeOfDates/beginDate"],xmlValue)),unlist(xmlApply(metadata["//dataset/coverage/temporalCoverage/rangeOfDates/endDate"],xmlValue)))
	dataset_summary$length_of_survey_years <-  time_length(tot_int,unit="year")

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
	write.csv(dataset_summary,file=paste0(path,"/",project_name,"_dataset_summary.csv"),row.names=FALSE,quote=FALSE)
	
# Create observation ancillary table ============================================================================
	message("Creating observation ancillary table")
	
	seed_rain_anc <- gather(seed_rain,key="variable_name",value="value",c(basket,mass:ind.mass,seeds.m2:note))
	data_2004_anc <- gather(data_2004,key="anc_var",value="anc_val",x:depth)
	seedbank_2010_anc <- gather(seedbank_2010_long,key="anc_var",value="anc_val",c(treatment,depth))
	colnames(understory_2010_long)[4] <- "treatment"
	understory_2010_anc <- gather(understory_2010_long,key="anc_var",value="anc_val",treatment)
	
	event_id <- c(seed_rain_anc$event_id,data_2004_anc$event_id,seedbank_2010_anc$event_id,understory_2010_anc$event_id)
	variable_name <- c(as.vector(seed_rain_anc$variable_name),as.vector(data_2004_anc$anc_var),as.vector(seedbank_2010_anc$anc_var),as.vector(understory_2010_anc$anc_var))
	value <- c(seed_rain_anc$value,data_2004_anc$anc_val,seedbank_2010_anc$anc_val,understory_2010_anc$anc_val)
	unit <- rep("placeholder",length(event_id))
	observation_ancillary_id <- c(1:length(event_id))
	
	observation_ancillary <- data.frame(observation_ancillary_id,event_id,variable_name,value,unit)
	observation_ancillary <- observation_ancillary[-which(observation_ancillary$variable_name == "treatment"),]
	
	write.csv(observation_ancillary,file=paste0(path,"/",project_name,"_observation_ancillary.csv"),row.names=FALSE,quote=FALSE)
	
# Create location ancillary table ===============================================================================
	message("Creating location ancillary table")
	location_names <- sapply(c(1:nrow(sample_coord)),function(x) paste(sample_coord$block[x],sample_coord$plot[x],sample_coord$replicate[x],sep="_"))
	sample_coord_names <- data.frame(sample_coord,location_names)
	sample_coord_names <- gather(sample_coord_names,key="variable_name",value="value",c(treatmetn,xcoord:ycoord))
	location_id <- location$location_id[match(sample_coord_names$location_names,location$location_name)]
  variable_name <- sample_coord_names$variable_name
  value <- sample_coord_names$value
  unit <- rep(NA_character_,nrow(sample_coord_names))
	for (i in 1:length(unit)){
	  if(variable_name[i] != "treatmetn"){
	    unit[i] <- "meters"
	  } 
	} 
  location_ancillary_id <- c(1:nrow(sample_coord_names))
  location_ancillary <- data.frame(location_ancillary_id,location_id,variable_name,value,unit)
  location_ancillary$variable_name <- gsub("treatmetn","treatment",location_ancillary$variable_name)
  
	write.csv(location_ancillary,file=paste0(path,"/",project_name,"_location_ancillary.csv"),row.names=FALSE,quote=FALSE)
	
#Create variable mapping table ==================================================================================
	message("Creating variable mapping table")
	variable_name <- c(unique(observation$variable_name),unique(observation_ancillary$variable_name),unique(location_ancillary$variable_name))
	table_name <- c(rep("observation",length(unique(observation$variable_name))),rep("observation_ancillary",length(unique(observation_ancillary$variable_name))),rep("location_ancillary",length(unique(location_ancillary$variable_name))))
	variable_mapping_id <- c(1:length(variable_name))
	variable_mapping <- data.frame(variable_mapping_id,table_name,variable_name)
	write.csv(variable_mapping,file=paste0(path,"/",project_name,"_variable_mapping.csv"),row.names=FALSE,quote=FALSE)
	
	
}
