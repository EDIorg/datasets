# This script converts the dataset from knb-lter.643 into a ecocomDP-compliant set of tables 
# see https://github.com/EDIorg/ecocomDP for more information

# Input arguments:
# path - the path to where the ecocomDP tables should be written
# parent_pkg_id - Parent package identifier (e.g. "knb-lter-cap.643.1")
# child_pkg_id - Child package identifier (e.g. "edi.205.1")


# Load libraries ================================================================================================

library(XML)
library(readr)
library(sf)
library(tidyr)
library(ecocomDP)
library(lubridate)
library(taxonomyCleanr)
library(stringr)
library(EDIutils)

convert_tables <- function(path, parent_pkg_id, child_pkg_id){

  project_name <- 'arthropod_survey'
  
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
	pitfall <- read.csv(file = entity_urls[grep("pitfall",entity_names,value=FALSE)])
	vegetation <- read.csv(file=entity_urls[grep("vegetation",entity_names,value=FALSE)])
	location_data <- read.csv(file=entity_urls[grep("sites",entity_names,value=FALSE)])
	kml <- st_read(entity_urls[grep("locations",entity_names,value=FALSE)])
	
	# Create location table ========================================================================================
	message("Creating location table")
	kml$Name <- c("Bell_Gateway","DixieMine_Prospector","Rincon_Sunrise","Dixileta_LoneMtn","TomThumb_Paraiso") #NOT AUTOMATED, needs revision if possible
	temp <- data.frame(rep(NA,length(unique(pitfall$site_code))),unique(pitfall$site_code)) #assumes pitfall has sampling that represents all sites
	colnames(temp) <- c("area","site")
	for (i in 1:nrow(temp)){
	  temp$area[i] <- grep(temp$site[i],kml$Name,value=TRUE)
	}
	location_table <- make_location(temp,cols=c("area","site"),kml=kml,col="area")
	location_table$location_name[6:15] <- c("Bell","Dixileta","Gateway","LoneMtn","Paraiso","TomThumb","Mine","Prospector","Rincon","Sun")
	write.csv(location_table,file=paste0(path,"/",project_name,"_location.csv"),row.names=FALSE)
	
# Create observation table ==================================================================================
	message("Creating observation table")	
	
	pitfall[, ] <- lapply(pitfall[, ],as.vector)
	vegetation[, ] <- lapply(vegetation[, ],as.vector)
	pitfall_event <- data.frame(unique(pitfall[,c(1,2,4)]),rep(NA_character_,nrow(unique(pitfall[,c(1,2,4)]))))
	colnames(pitfall_event)[4] <- "plant_scientific_name"
	vegetation_event <- data.frame(unique(vegetation[,c(1,2,7)]),rep(NA_character_,nrow(unique(vegetation[,c(1,2,7)]))),stringsAsFactors = FALSE)
	colnames(vegetation_event)[4] <- "trap_name"
	event_tbl <- data.frame(c(pitfall_event$site_code,vegetation_event$site_code),c(pitfall_event$sample_date,vegetation_event$sample_date),c(pitfall_event$trap_name,vegetation_event$trap_name),c(pitfall_event$plant_scientific_name,vegetation_event$plant_scientific_name),stringsAsFactors = FALSE)
	event_tbl <- data.frame(event_tbl,c(1:nrow(event_tbl)),stringsAsFactors = FALSE)
	colnames(event_tbl) <- c("site_code","sample_date","trap_name","plant_scientific_name","event_id")
	
	pitfall_temp <- data.frame(pitfall,as.vector(rep(NA_character_,nrow(pitfall))),as.vector(rep(NA_character_,nrow(pitfall))),as.vector(rep(NA_character_,nrow(pitfall))),as.vector(rep(NA_character_,nrow(pitfall))),as.vector(rep(NA_character_,nrow(pitfall))),stringsAsFactors = FALSE)
	colnames(pitfall_temp) <- c(colnames(pitfall),colnames(vegetation)[which(colnames(vegetation) %in% colnames(pitfall) == FALSE)])
	vegetation_temp <- data.frame(vegetation,as.vector(rep(NA_character_,nrow(vegetation))),as.vector(rep(NA_character_,nrow(vegetation))),as.vector(rep(NA_character_,nrow(vegetation))),as.vector(rep(NA_character_,nrow(vegetation))),stringsAsFactors = FALSE)
	colnames(vegetation_temp) <- c(colnames(vegetation),colnames(pitfall)[which(colnames(pitfall) %in% colnames(vegetation) == FALSE)])
	
	data <- rbind(pitfall_temp,vegetation_temp,stringsAsFactors=FALSE)
	data[, ] <- lapply(data[, ],as.vector)
	temp <- gather(data,key="variable_name",value="value",lt2mm:unsized,na.rm=TRUE)
	temp2 <- merge(temp,event_tbl,all=FALSE)
	
	taxa_tbl <- data.frame(unique(temp2[,c(9:12,13,18)]),c(1:nrow(unique(temp2[,c(13,18)]))))
	colnames(taxa_tbl)[7] <- "taxon_id"
	
	temp3 <- merge(temp2,taxa_tbl,all=FALSE)
	
	observation <- data.frame(c(1:nrow(temp3)),temp3$event_id,rep(child_pkg_id,nrow(temp3)),temp3$site_code,temp3$sample_date,temp3$taxon_id,temp3$variable_name,temp3$value,rep("number",nrow(temp3)),stringsAsFactors = FALSE)
	colnames(observation) <- c("observation_id","event_id","package_id","location_id","observation_datetime","taxon_id","variable_name","value","unit")
	
	observation$observation_datetime <- EDIutils::datetime_to_iso8601(observation$observation_datetime,
	                                                                  orders = 'ymd')
	
	write.csv(observation,file=paste0(path,"/",project_name,"_observation.csv"),row.names=FALSE)
	

# Create taxon table ============================================================================================ 
	message("Creating taxon table")
	
	taxa_tbl$display_name <- as.character(taxa_tbl$display_name)
	clean_taxa_list <- unlist(lapply(strsplit(taxa_tbl$display_name," (",fixed = TRUE),'[[', 1))
	clean_taxa_list <- unlist(lapply(strsplit(clean_taxa_list,">",fixed = TRUE),'[[', 1))
	clean_taxa_list <- unlist(lapply(strsplit(clean_taxa_list,"(",fixed = TRUE),'[[', 1))
	clean_taxa_list[which(is.na(clean_taxa_list))] <- "none"
	clean_taxa_list <- unlist(lapply(strsplit(clean_taxa_list," immature",fixed=TRUE),'[[',1))
	
	taxa_tbl <- data.frame(taxa_tbl,clean_taxa_list)
	# taxa_map <- create_taxa_map(path=path,taxa_tbl,col="clean_taxa_list")
	# taxa_map <- replace_taxa(path=path,input = "Scale Insects",output="Coccoidea")
	# taxa_map <- trim_taxa(path=path)
	# taxa_map <- resolve_sci_taxa(path=path,data.sources = c(3,11,1))
	taxa_map <- read.csv(file=paste0(path,"/taxa_map.csv"),stringsAsFactors = FALSE)
	
	taxon_rank <- taxa_map$rank[match(taxa_tbl$clean_taxa_list,taxa_map$taxa_raw)]
	taxon_name <- taxa_tbl$display_name
	authority_system <- taxa_map$authority[match(taxa_tbl$clean_taxa_list,taxa_map$taxa_raw)]
	authority_taxon_id <- taxa_map$authority_id[match(taxa_tbl$clean_taxa_list,taxa_map$taxa_raw)]
	
	taxon <- data.frame(as.vector(taxa_tbl$taxon_id),as.vector(taxon_rank),as.vector(taxon_name),as.vector(authority_system),as.vector(authority_taxon_id))
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
	pitfall2 <- data.frame(pitfall$observer,pitfall$trap_name,pitfall$trap_sampling_events_comments,pitfall$trap_sampling_events_flags,pitfall$trap_count,c(1:nrow(pitfall)))
	colnames(pitfall2) <- c("observer","trap_name","trap_sampling_events_comments","trap_sampling_events_flags","trap_count","event_id")
	vegetation2 <- data.frame(vegetation$observer,vegetation$plant_sampling_events_comments,vegetation$plant_sampling_events_flags,vegetation$plant_count,vegetation$plant_scientific_name,vegetation$plant_common_name,c((nrow(pitfall)+1),(nrow(pitfall)+1+nrow(vegetation))))
	colnames(vegetation2) <- c("observer","plant_sampling_events_comments","plant_sampling_events_flags","plant_count","plant_scientific_name","plant_common_name","event_id")
	pitfall2 <- gather(pitfall2,key="variable_name",value="value",observer:trap_count,na.rm=TRUE)
	vegetation2 <- gather(vegetation2, key="variable_name",value="value",observer:plant_common_name,na.rm=TRUE)
	observation_ancillary <- data.frame(c(1:sum(nrow(pitfall2),nrow(vegetation2))),c(pitfall2$event_id,vegetation2$event_id),c(pitfall2$variable_name,vegetation2$variable_name),c(pitfall2$value,vegetation2$value),rep(NA,sum(nrow(pitfall2),nrow(vegetation2))))
	colnames(observation_ancillary) <- c("observation_ancillary_id","event_id","variable_name","value","unit")
	observation_ancillary$value <- str_replace_all(observation_ancillary$value,pattern="\n",replacement = " ")
	observation_ancillary$value <- str_replace_all(observation_ancillary$value,pattern="\r",replacement = " ")
	observation_ancillary$value <- str_replace_all(observation_ancillary$value,pattern="  ",replacement = " ")
	write.csv(observation_ancillary,file=paste0(path,"/",project_name,"_observation_ancillary.csv"),row.names=FALSE)
	
# Create location ancillary table ===============================================================================
	message("Creating location ancillary table")
	temp <- location_data
	temp$site_code <- as.character(temp$site_code)
	temp$start_date <- as.character(temp$start_date)
	temp$end_date <- as.character(temp$end_date)
	for (i in 1:nrow(temp)){
	  temp$site_code[i] <- location_table[match(as.character(temp$site_code[i]),location_table$location_name),1]
	}
	location_ancillary <- gather(temp,key="variable_name",value="value",site_type:comments,na.rm=TRUE,convert=TRUE)
	location_ancillary <- data.frame(c(1:nrow(location_ancillary)),location_ancillary$site_code,location_ancillary$variable_name,location_ancillary$value,rep(NA,nrow(location_ancillary)))
	colnames(location_ancillary) <- c("location_ancillary_id","location_id","variable_name","value","unit")
	write.csv(location_ancillary,file=paste0(path,"/",project_name,"_location_ancillary.csv"),row.names=FALSE)

# Create taxon ancillary table ===================================================================================
	message("Creating taxon ancillary table")
	
	colnames(taxa_tbl)[6] <- "size_category"
	temp <- gather(taxa_tbl,key="variable_name",value="value",c(arth_class:arth_genus_subgenus,size_category))
	taxon_ancillary_id <- c(1:nrow(temp))
	taxon_id <- temp$taxon_id
	variable_name <- temp$variable_name
	value <- temp$value
	
	taxon_ancillary <- data.frame(taxon_ancillary_id,taxon_id,variable_name,value)
	
	write.csv(taxon_ancillary,file=paste0(path,"/",project_name,"_taxon_ancillary.csv"),row.names=FALSE)
	
#Create variable mapping table ==================================================================================
	message("Creating variable mapping table")
	variable_name <- c(unique(observation$variable_name),unique(observation_ancillary$variable_name),unique(location_ancillary$variable_name))
	table_name <- c(rep("observation",length(unique(observation$variable_name))),rep("observation_ancillary",length(unique(observation_ancillary$variable_name))),rep("location_ancillary",length(unique(location_ancillary$variable_name))))
	variable_mapping_id <- c(1:length(variable_name))
	variable_mapping <- data.frame(variable_mapping_id,table_name,variable_name)
	write.csv(variable_mapping,file=paste0(path,"/",project_name,"_variable_mapping.csv"),row.names=FALSE)
	
}

