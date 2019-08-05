# Create ecocomDP data package
#
# This script converts knb-lter-hbr.126.x to the ecocomDP, validates the 
# resultant tables, and creates the associated EML record.

# Initialize workspace --------------------------------------------------------

library(reshape2)
library(stringr)
library(openssl)
library(Rcpp)
library(EDIutils)
library(XML)
library(readr)
library(sf)
library(tidyr)
library(dplyr)
library(ecocomDP)
library(lubridate)
library(taxonomyCleanr)
library(dataCleanr)

path <- '/Users/csmith/Downloads/edi_263'
parent_pkg_id <- 'knb-lter-hbr.126.4'
child_pkg_id <- 'edi.263.1'

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
if ('count' %in% catvars$code){
  use_i <- catvars$code == 'count'
  catvars$definition[use_i] <- 'Number of individuals observed'
}

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
  
  project_name <- 'gastropod_abundance'
  
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
  
  westBoundingCoordinate <- min(as.numeric(
    unlist(
      xmlApply(
        metadata["//dataset/coverage/geographicCoverage/boundingCoordinates/westBoundingCoordinate"], 
        xmlValue
      )
    )
  ))
  
  
  eastBoundingCoordinate <- max(as.numeric(
    unlist(
      xmlApply(
        metadata["//dataset/coverage/geographicCoverage/boundingCoordinates/eastBoundingCoordinate"], 
        xmlValue
      )
    )
  ))
  
  southBoundingCoordinate <- min(as.numeric(
    unlist(
      xmlApply(
        metadata["//dataset/coverage/geographicCoverage/boundingCoordinates/southBoundingCoordinate"], 
        xmlValue
      )
    )
  ))
  
  northBoundingCoordinate <- max(as.numeric(
    unlist(
      xmlApply(
        metadata["//dataset/coverage/geographicCoverage/boundingCoordinates/northBoundingCoordinate"], 
        xmlValue
      )
    )
  ))
  
  # Get tables from parent data -----------------------------------------------
  
  message("Retreiving tables from parent data")
  
  dt1 <- read.csv(file = entity_urls, as.is = T)
  # FIX DATA
  #missing values were entered as -9999 for N_slugs and N-snails, 00000000 for DATE. Replace with NA
  dt1$N_SNAILS[dt1$N_SNAILS<0]<-NA
  dt1$N_SLUGS[dt1$N_SLUGS<0]<-NA
  dt1$DATE[dt1$DATE==00000000]<-NA
  dt1$DATE<-as.Date(as.character(dt1$DATE), "%Y%m%d")
  dt1$DATE <- as.character(dt1$DATE)
  data <- dt1
  
  # Create observation table --------------------------------------------------
  
  message("Creating observation table")	
  
  data <- gather(data, 'taxa', 'value', N_SNAILS, N_SLUGS)
  data$variable_name <- 'count'
  names(data)[names(data) == 'DATE'] <- "observation_datetime"
  names(data)[names(data) == 'N_SNAILS'] <- "value"
  data$unit <- 'number'
  
  # Add key for location table
  data$WATERSHED <- trimws(data$WATERSHED, which = 'both')
  data$ELEV_BAND <- trimws(data$ELEV_BAND, which = 'both')
  data$CARDBOARD <- trimws(data$CARDBOARD, which = 'both')
  data$location_id <- paste0(data$WATERSHED, '_', data$ELEV_BAND, '_', data$CARDBOARD)
  
  # Add key for event
  i_event <- data.frame(
    date = unique(data$observation_datetime),
    event_id = paste0('ev_', seq(length(unique(data$observation_datetime)))),
    stringsAsFactors = F
  )
  data$event_id <- i_event$event_id[match(data$observation_datetime, i_event$date)]
  
  # Add package_id
  data$package_id <- child_pkg_id
  
  # Add taxon_id
  i_taxon <- data.frame(
    taxa = unique(data$taxa),
    taxon_id = paste0('tx_', seq(length(unique(data$taxa)))),
    stringsAsFactors = F
  )
  data$taxon_id <- i_taxon$taxon_id[match(data$taxa, i_taxon$taxa)]
  
  # Add observation_id
  data$observation_id <- paste0('ob_', seq(nrow(data)))
  
  # Select columns
  observation <- select(data, observation_id, event_id, package_id, 
                        location_id, observation_datetime, taxon_id, 
                        variable_name, value, unit)
  
  # Create location table -----------------------------------------------------
  
  message("Creating location table")
  
  location_table <- make_location(x = data, cols = c('WATERSHED','ELEV_BAND','CARDBOARD'))
  location_table$elevation[str_detect(location_table$location_name, '_L')] <- 520
  location_table$elevation[str_detect(location_table$location_name, '_M')] <- 610
  location_table$elevation[str_detect(location_table$location_name, '_U')] <- 700
  location_table$elevation <- as.numeric(location_table$elevation)
  location <- location_table
  
  write.csv(location,file=paste0(path,"/",project_name,"_location.csv"),quote=FALSE,row.names=FALSE)
  
  # Update observation --------------------------------------------------------
  
  use_i <- match(observation$location_id,location$location_name)
  observation$location_id <- location$location_id[use_i]
  
  write.csv(observation,file=paste0(path,"/",project_name,"_observation.csv"),quote=FALSE,row.names=FALSE)
  
  # Create taxon table --------------------------------------------------------
  
  message("Creating taxon table")
  
  taxon <- data.frame(
    taxon_id = rep(NA_character_, 2),
    taxon_rank = rep(NA_character_, 2),
    taxon_name = rep(NA_character_, 2),
    authority_system = rep(NA_character_, 2),
    authority_taxon_id = rep(NA_character_, 2),
    stringsAsFactors = F)
  
  taxon$taxon_id <- paste0('tx_', seq(2))
  taxa_resolved <- taxonomyCleanr::resolve_comm_taxa(data.sources = 3, x = c('snails', 'slugs'))
  taxon$taxon_rank <- taxa_resolved$rank
  taxon$taxon_name <- taxa_resolved$taxa_clean
  taxon$authority_system <- taxa_resolved$authority
  taxon$authority_taxon_id <- taxa_resolved$authority_id
  
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
  
  # Create location ancillary table ----------------------------------------
  
  message("Creating location ancillary table")
  
  # Note reference sites
  use_i <- stringr::str_detect(location$location_name, 'West_of')
  
  # Add notes about coerced datetimes reported in the location table
  location_ancillary <- data.frame(
    location_ancillary_id = rep(NA_character_, length(use_i)),
    location_id = rep(NA_character_, length(use_i)),
    datetime = rep(NA_character_, length(use_i)),
    variable_name = rep(NA_character_, length(use_i)),
    value = rep(NA_character_, length(use_i)),
    unit = rep(NA_character_, length(use_i)),
    stringsAsFactors = F)
  
  # Populate fields
  location_ancillary$location_ancillary_id <- paste0(
    'loan_',
    seq(nrow(location_ancillary))
  )
  location_ancillary$location_id <- location$location_id
  location_ancillary$variable_name <- 'experimental state'
  location_ancillary$value[use_i] <- 'reference'
  location_ancillary$value[!use_i] <- 'treatment'
  
  write.csv(location_ancillary,file=paste0(path,"/",project_name,"_location_ancillary.csv"),quote=FALSE,row.names=FALSE)
  
  # Create variable mapping table ----------------------------------------------
  
  message("Creating variable mapping table")
  
  variable_mapping <- make_variable_mapping(
    observation = observation,
    location_ancillary = location_ancillary
  )
  # Define 'count'
  use_i <- variable_mapping$variable_name == 'count'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/individualCount'
  variable_mapping$mapped_label[use_i] <- 'individualCount'
  
  write.csv(variable_mapping,file=paste0(path,"/",project_name,"_variable_mapping.csv"),quote=FALSE,row.names=FALSE)
  
  
}



