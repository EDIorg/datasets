# This script converts the dataset fom XXXX into a ecocomDP-compliant set of tables
# see https://github.com/EDIorg/ecocomDP for more information

# Input arguments:
# path - the path to where the ecocomDP tables should be written
# parent_pkg_id - Parent package identifier (e.g. "knb-lter-cap.632.1")
# child_pkg_id - Child package identifier (e.g. "edi.253.1")


# Load libraries ================================================================================================

library(XML)
library(readr)
library(sf)
library(tidyverse)
library(ecocomDP)
library(lubridate)
library(taxonomyCleanr)
library(EDIutils)

convert_tables <- function(path, parent_pkg_id, child_pkg_id){

  project_name <- 'desert_fertilization'
  
# Validate arguments ========================================================================================
	
  message('Validating arguments')
  
  if (missing(path)){
    stop('Input argument "path" is missing! Specify the path to the directory that will be filled with ecocomDP tables.')
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

#Get tables from parent data =================================================================================
	message("Retreiving tables from parent data")
	biomass <- read.csv(file = entity_urls[grep("biomass",entity_names,value=FALSE)])
	composition <- read.csv(file=entity_urls[grep("composition",entity_names,value=FALSE)])
	fertilizer <- read.csv(file=entity_urls[grep("fertilizer",entity_names,value=FALSE)])
	kml <- st_read(xmlApply(metadata["//dataset/otherEntity/physical/distribution/online/url"],xmlValue)[[2]])
	
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
	
	plot <- unique(composition$plot_id)
	site <- composition[match(plot,composition$plot_id),1]
	temp <- data.frame(site,plot)
	location <- make_location(temp,kml=kml,cols=c("site","plot"),col="site")
	location$location_name <- sapply(location$location_name,function(x) gsub(" ","",x,fixed = TRUE))
	write.csv(location,file=paste0(path,"/",project_name,"_location.csv"),row.names=FALSE)
		
# Create observation table ==================================================================================
	message("Creating observation table")	
	
	temp <- merge(biomass,composition,all=TRUE)
	temp <- data.frame(c(1:nrow(temp)),temp,stringsAsFactors = FALSE)
	colnames(temp)[1] <- "event_id"
	temp$date <- as.vector(temp$date)
	temp$cover_type <- as.vector(temp$cover_type)
	for (i in 1:nrow(temp)){
	  if (is.na(temp$date[i])==TRUE){
	    temp$date[i] <- temp$year[i]
	  }
	}
	
	location_id_list <- sapply(c(1:nrow(temp)),function(x) paste(temp$site_code[x],temp$plot_id[x],sep="_"))
	location_id_list <- location[match(location_id_list,location$location_name),1]
	
	temp2 <- data.frame(location_id_list,temp$event_id,temp$date,temp$cover_amount,temp$mass)
	colnames(temp2) <- c("location_id","event_id","observation_datetime","cover_amount","biomass")
	temp2 <- gather(temp2,key="variable_name",value="value",cover_amount:biomass,na.rm=TRUE)
	taxon_id_list <- c(1:nrow(temp2))
	taxon_id_list <- sapply(c(1:nrow(temp2)),function(x) if(temp2$variable_name[x]=="biomass") taxon_id_list[x] <- "annual_plant" else taxon_id_list[x] <- temp$cover_type[match(temp2$event_id[x],temp$event_id)])
	
	observation <- data.frame(c(1:nrow(temp2)),temp2$event_id,rep(child_pkg_id,nrow(temp2)),temp2$location_id,temp2$observation_datetime,taxon_id_list,temp2$variable_name,temp2$value,unit_table[match(temp2$variable_name,unit_table$variable_list),2])
	colnames(observation) <- c("observation_id","event_id","package_id","location_id","observation_datetime","taxon_id","variable_name","value","unit")
	
	observation$observation_datetime <- EDIutils::datetime_to_iso8601(as.character(observation$observation_datetime),
	                                                                  orders = c('ymd'))
	
	write.csv(observation,file=paste0(path,"/",project_name,"_observation.csv"),row.names=FALSE)
	
# Create taxon table ============================================================================================ 
	message("Creating taxon table")
  
	taxon_list <- unique(observation$taxon_id)
	odd_taxa <- c(as.vector(unique(composition$cover_type[which(composition$cover_category == "plot characteristic")])),"annual_plant","sampled",grep("unidentified",taxon_list,value=TRUE))
	need_fixing <- odd_taxa[c(grep("_base",odd_taxa,value=FALSE),grep("_cover",odd_taxa,value=FALSE),grep("_stem",odd_taxa,value=FALSE))]
	need_fixing <- need_fixing[-which(need_fixing=="total_shrub_cover")]
	taxon_list_clean <- as.vector(taxon_list[-which(taxon_list %in% odd_taxa == TRUE)])
	fixed_big <- unlist(strsplit(unlist(strsplit(unlist(strsplit(need_fixing,"_stem")),"_cover")),"_base"))
	fixed <- unique(fixed_big)
	taxon_list_clean <- c(taxon_list_clean,fixed,"Plantae")
	
	taxon_table <- data.frame(taxon_list_clean)
	fname <- "taxa_map.csv"
	taxa_map <- create_taxa_map(path=path,taxon_table,col=colnames(taxon_table)[1])
	taxa_map <- trim_taxa(path=path)
	taxa_map <- resolve_sci_taxa(path=path,data.sources = c(3,1))
	taxon_list <- as.vector(taxon_list)
	taxon_list_fake <- taxon_list
	for (i in 1:length(taxon_list_fake)){
	  if (taxon_list_fake[i] %in% need_fixing == TRUE){
	    taxon_list_fake[i] <- fixed_big[which(need_fixing == taxon_list_fake[i])]
	  }
	  if (taxon_list_fake[i] %in% grep("unidentified",taxon_list,value=TRUE) == TRUE | taxon_list_fake[i] == "annual_plant"){
	    taxon_list_fake[i] <- "Plantae"
	  }
	}
	taxa_map <- read_csv(file=paste0(path,"/taxa_map.csv"))
	taxon_rank <- c(1:length(taxon_list))
	taxon_rank <- sapply(c(1:length(taxon_rank)),function(x) if(taxon_list_fake[x] %in% odd_taxa == FALSE) taxon_rank[x] <- taxa_map$rank[match(taxon_list_fake[x],taxa_map$rank)] else taxon_rank[x] <- NA_character_)
	
	taxon_name <- as.vector(sapply(taxon_list_fake,function(x) if(x %in% taxa_map$taxa_raw == TRUE) x <- taxa_map$taxa_clean[which(taxa_map$taxa_raw == x)] else x <- NA_character_))
	taxon_authority <- as.vector(sapply(taxon_list_fake,function(x) if(x %in% taxa_map$taxa_raw == TRUE) x <- taxa_map$authority[which(taxa_map$taxa_raw == x)] else x <- NA_character_))
	taxon_auth_id <- as.vector(sapply(taxon_list_fake,function(x) if(x %in% taxa_map$taxa_raw == TRUE) x <- taxa_map$authority_id[which(taxa_map$taxa_raw == x)] else x <- NA_character_))
	
	taxon <- data.frame(taxon_list,taxon_rank,taxon_name,taxon_authority,taxon_auth_id)
	colnames(taxon) <- c("taxon_id","taxon_rank","taxon_name","authority_system","authority_taxon_id")
	
	write.csv(taxon,file=paste0(path,"/",project_name,"_taxon.csv"),row.names=FALSE)
	
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
	
# Create observation ancillary table ============================================================================
	message("Creating observation ancillary table")
	
	#what to do with the year column?
	
	temp3 <- temp[,-c(2,3,7,8,10,13,15)]
	observation_ancillary <- gather(temp3,key="variable_name",value="value",treatment_code:cover_category)
	observation_ancillary_id <- c(1:nrow(observation_ancillary))
	unit <- unit_table[match(observation_ancillary$variable_name,unit_table$variable_list,nomatch = NA_character_),2]
	observation_ancillary <- data.frame(observation_ancillary_id,observation_ancillary,unit)
	
	write.csv(observation_ancillary,file=paste0(path,"/",project_name,"_observation_ancillary.csv"),row.names=FALSE)
	
# Create location ancillary table ===============================================================================
	message("Creating location ancillary table")
	
	location_id <- location[match(fertilizer$site_code,location$location_name),1]
	location_ancillary <- data.frame(c(1:length(location_id)),location_id,fertilizer$application_date,fertilizer$nitrogen,fertilizer$phosphorus)
	colnames(location_ancillary) <- c("location_ancillary_id","location_id","datetime","nitrogen","phosphorus")
	location_ancillary <- gather(location_ancillary,key="variable_name",value="value",nitrogen:phosphorus)
	location_ancillary <- data.frame(location_ancillary,unit_table[match(location_ancillary$variable_name,unit_table$variable_list),2])
	colnames(location_ancillary) <- c("location_ancillary_id","location_id","datetime","variable_name","value","unit")
	
	location_ancillary$datetime <- EDIutils::datetime_to_iso8601(
	  as.character(location_ancillary$datetime),
	  orders = 'ymd'
	)
	
	location_ancillary$location_ancillary_id <- seq(nrow(location_ancillary))
	
	write.csv(location_ancillary,file=paste0(path,"/",project_name,"_location_ancillary.csv"),row.names=FALSE)
	
# Create taxon ancillary table ===================================================================================
	message("Creating taxon ancillary table")
	
	taxon_anc_id <- c(1:length(need_fixing))
	definition_metadata <- metadata["//dataset/dataTable"]
	base_definition <- unlist(strsplit(xmlValue(definition_metadata[[2]][[4]][[9]][[4]][[1]][[1]][[1]][[1]]),"Ambrosia_base"))[2]
	cover_definition <- unlist(strsplit(xmlValue(definition_metadata[[2]][[4]][[9]][[4]][[1]][[1]][[1]][[2]]),"Ambrosia_cover"))[2]
	stem_definition <- unlist(strsplit(xmlValue(definition_metadata[[2]][[4]][[9]][[4]][[1]][[1]][[1]][[3]]),"Ambrosia_stem"))[2]

	definitions <- c(1:length(need_fixing))
	definitions[grep("base",need_fixing,value=FALSE)] <- base_definition
	definitions[grep("cover",need_fixing,value=FALSE)] <- cover_definition
	definitions[grep("stem",need_fixing,value=FALSE)] <- stem_definition
	
	taxon_ancillary <- data.frame(taxon_anc_id,need_fixing,rep("definition",length(taxon_anc_id)),definitions,rep(NA_character_,length(taxon_anc_id)))
	colnames(taxon_ancillary) <- c("taxon_ancillary_id","taxon_id","variable_name","value","unit")
	
	write.csv(taxon_ancillary,file=paste0(path,"/",project_name,"_taxon_ancillary.csv"),row.names=FALSE)
	
#Create variable mapping table ==================================================================================
	message("Creating variable mapping table")
	variable_name <- c(unique(observation$variable_name),unique(observation_ancillary$variable_name),unique(location_ancillary$variable_name))
	table_name <- c(rep("observation",length(unique(observation$variable_name))),rep("observation_ancillary",length(unique(observation_ancillary$variable_name))),rep("location_ancillary",length(unique(location_ancillary$variable_name))))
	variable_mapping_id <- c(1:length(variable_name))
	variable_mapping <- data.frame(variable_mapping_id,table_name,variable_name)
	write.csv(variable_mapping,file=paste0(path,"/",project_name,"_variable_mapping.csv"),row.names=FALSE)
	
	
}
