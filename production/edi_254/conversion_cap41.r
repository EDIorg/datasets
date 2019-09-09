# This script converts the dataset fom XXXX into a ecocomDP-compliant set of tables
# see https://github.com/EDIorg/ecocomDP for more information

# Input arguments:
# path - the path to where the ecocomDP tables should be written
# parent_pkg_id - Parent package identifier (e.g. "knb-lter-cap.41.1")
# child_pkg_id - Child package identifier (e.g. "edi.254.1")


# Load libraries ================================================================================================
library(ecocomDP)
library(XML)
library(readr)
library(sf)
library(lubridate)
library(taxonomyCleanr)
library(stringr)
library(EDIutils)

convert_tables <- function(path, parent_pkg_id, child_pkg_id){

  project_name <- 'core_arthropod_survey'
  
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
	exclude <- c(grep("sites",entity_names,value=FALSE),grep("locations",entity_names,value=FALSE))
	arthro_data <- read.csv(file = entity_urls[-exclude])
	sites_data <- read.csv(file=entity_urls[grep("sites",entity_names,value=FALSE)])
	kml <- st_read(entity_urls[grep("locations",entity_names,value=FALSE)])
	
# Create location table ========================================================================================
	message("Creating location table")
	location_table <- data.frame(sites_data$site_code,sites_data$lat,sites_data$long)
	colnames(location_table) <- c("location_id","latitude","longitude")
	write.csv(location_table,file=paste0(path,"/",project_name,"_location.csv"),row.names = FALSE)
		
# Create observation table ==================================================================================
	message("Creating observation table")	
	
	event_tbl <- data.frame(unique(arthro_data[,c(1,2,4)]),c(1:nrow(unique(arthro_data[,c(1,2,4)]))))
	colnames(event_tbl)[4] <- "event_id"
	temp <- gather(arthro_data,key="variable_name",value="value",lt2mm:unsized,na.rm=TRUE)
	temp2 <- unique(temp[,8:13])
	taxa_tbl <- data.frame(temp2,c(1:nrow(temp2)))
	colnames(taxa_tbl)[7] <- "taxon_id"
	
	temp3 <- merge(taxa_tbl,temp)
	temp3 <- merge(event_tbl,temp3)
	
	observation <- data.frame(c(1:nrow(temp3)),temp3$event_id,rep(child_pkg_id,nrow(temp3)),temp3$site_code,temp3$sample_date,temp3$taxon_id,rep("count",nrow(temp3)),temp3$value,rep("number",nrow(temp3)))
	colnames(observation) <- c("observation_id","event_id","package_id","location_id","observation_datetime","taxon_id","variable_name","value","unit")
	
	observation$observation_datetime <- EDIutils::datetime_to_iso8601(as.character(observation$observation_datetime),
	                                                                  orders = c('ymd'))
	
	write.csv(observation,file=paste0(path,"/",project_name,"_observation.csv"),row.names = FALSE)
	
# Create taxon table ============================================================================================ 
	message("Creating taxon table")
	
	clean_taxa_list <- unlist(lapply(strsplit(as.character(taxa_tbl$display_name)," (",fixed = TRUE),'[[', 1))
	clean_taxa_list <- unlist(lapply(strsplit(clean_taxa_list,">",fixed = TRUE),'[[', 1))
	clean_taxa_list <- unlist(lapply(strsplit(clean_taxa_list,"(",fixed = TRUE),'[[', 1))
	
	taxa_tbl <- data.frame(taxa_tbl,clean_taxa_list)
	taxa_map <- create_taxa_map(path=path,taxa_tbl,col="clean_taxa_list")
	taxa_map <- replace_taxa(path=path,input = "Lizard",output="Squamata")
	taxa_map <- replace_taxa(path=path,input = "Scale Insects",output="Coccoidea")
	taxa_map <- trim_taxa(path=path)
	taxa_map <- resolve_sci_taxa(path = path,data.sources = c(3,1,11))
	taxa_map <- read_csv(file=paste0(path,"/taxa_map.csv"))
	
	taxon_rank <- c(1:nrow(taxa_tbl))
	taxon_name <- taxa_tbl$display_name
	authority_system <- taxon_rank
	authority_taxon_id <- taxon_rank
	
	for (i in 1:nrow(taxa_tbl)){
	  taxon_rank[i] <- taxa_map$rank[match(taxa_tbl$clean_taxa_list[i],taxa_map$taxa_raw)]
	  authority_system[i] <- taxa_map$authority[match(taxa_tbl$clean_taxa_list[i],taxa_map$taxa_raw)]
	  authority_taxon_id[i] <- taxa_map$authority_id[match(taxa_tbl$clean_taxa_list[i],taxa_map$taxa_raw)]
	}
	taxon <- data.frame(taxa_tbl$taxon_id,taxon_rank,taxon_name,authority_system,authority_taxon_id)
	colnames(taxon)[1] <- "taxon_id"
	
	write.csv(taxon,file=paste0(path,"/",project_name,"_taxon.csv"),row.names = FALSE)
	
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
	write.csv(dataset_summary,file=paste0(path,"/",project_name,"_dataset_summary.csv"),row.names = FALSE)
	
# Create observation ancillary table ============================================================================
	message("Creating observation ancillary table")
	
  observation_ancillary <- temp3[,c(4,12:15)]	
	observation_ancillary <- gather(observation_ancillary,key="variable_name",value="value",observer:trap_count)
	observation_ancillary <- data.frame(c(1:nrow(observation_ancillary)),observation_ancillary,unit_table[match(observation_ancillary$variable_name,unit_table$variable_list,nomatch = NA_character_),2])
	colnames(observation_ancillary)[5] <- "unit"
	colnames(observation_ancillary)[1] <- "observation_ancillary_id"
	
	observation_ancillary$value <- str_replace_all(observation_ancillary$value,pattern="\r\n",replacement = " ")
	observation_ancillary$value <- str_replace_all(observation_ancillary$value,pattern="\t",replacement="")
	
	write.csv(observation_ancillary,file=paste0(path,"/",project_name,"_observation_ancillary.csv"),row.names = FALSE)
	
# Create location ancillary table ===============================================================================
	message("Creating location ancillary table")
	temp <- sites_data
	temp$gps_date <- as.character(temp$gps_date)
	temp$start_date <- as.character(temp$start_date)
	temp$end_date <- as.character(temp$end_date)
	temp <- gather(temp,key="variable_name",value="value",c(location,gps_date:comments),na.rm = TRUE) # gathers info into key-value pairs
	value <- temp$value # saves the value column
	variable_name <- temp$variable_name
	unit <- rep(NA,length(variable_name)) # creates an empty list for unit
	for (i in 1:length(unit)){	# changes the date variables to have the "date" unit entry
	  if (variable_name[i]=="gps_date"|variable_name[i]=="start_date"|variable_name[i]=="end_date"){ 
	    unit[i] <- "date"
	  }
	}
	location_ancillary_id <- c(1:length(variable_name))
	location_id <- temp$site_code
	location_ancillary <- data.frame(location_ancillary_id,location_id,variable_name,value,unit)
	
	location_ancillary$value <- str_replace_all(location_ancillary$value,pattern="\r\n",replacement = " ")
	location_ancillary$value <- str_replace_all(location_ancillary$value,pattern="\n",replacement = " ")
	
	write.csv(location_ancillary,file=paste0(path,"/",project_name,"_location_ancillary.csv"),row.names = FALSE)
	
# Create taxon ancillary table ===================================================================================
	message("Creating taxon ancillary table")
	
	colnames(taxa_tbl)[6] <- "size_category"
	temp <- gather(taxa_tbl,key="variable_name",value="value",c(arth_class:arth_genus_subgenus,size_category))
	taxon_ancillary_id <- c(1:nrow(temp))
	taxon_id <- temp$taxon_id
	variable_name <- temp$variable_name
	value <- temp$value
	
	taxon_ancillary <- data.frame(taxon_ancillary_id,taxon_id,variable_name,value)
	
	write.csv(taxon_ancillary,file=paste0(path,"/",project_name,"_taxon_ancillary.csv"),row.names = FALSE)
	
#Create variable mapping table ==================================================================================
	message("Creating variable mapping table")
	variable_name <- c(unique(observation$variable_name),unique(observation_ancillary$variable_name),unique(location_ancillary$variable_name))
	table_name <- c(rep("observation",length(unique(observation$variable_name))),rep("observation_ancillary",length(unique(observation_ancillary$variable_name))),rep("location_ancillary",length(unique(location_ancillary$variable_name))))
	variable_mapping_id <- c(1:length(variable_name))
	variable_mapping <- data.frame(variable_mapping_id,table_name,variable_name)
	write.csv(variable_mapping,file=paste0(path,"/",project_name,"_variable_mapping.csv"),row.names = FALSE)

}