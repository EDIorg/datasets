# Create ecocomDP data package
#
# This script converts knb-lter-bnz.502.x to the ecocomDP, validates the 
# resultant tables, and creates the associated EML record.

# Initialize workspace --------------------------------------------------------

library(XML)
library(readr)
library(reshape2)
library(sf)
library(tidyr)
library(dplyr)
library(ecocomDP)
library(lubridate)
library(taxonomyCleanr)
library(dataCleanr)
library(stringr)

path <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\ecocomDP\\edi_264'
parent_pkg_id <- 'knb-lter-bnz.502.16'
child_pkg_id <- 'edi.264.1'

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

convert_tables <- function(path, child_pkg_id, parent_pkg_id){
  
  project_name <- 'DryPEHR_biomass'
  
  # Validate arguments --------------------------------------------------------
  
  message('Validating arguments')
  
  if (missing(path)){
    stop('Input argument "path" is missing! Specify the path to the directory that will be filled with ecocomDP tables.')
  }
  if (missing(child_pkg_id)){
    stop('Input argument "child_pkg_id" is missing! Specify new package ID (e.g. edi.249.1, or knb-lter-mcr.8.1.')
  }
  if (missing(parent_pkg_id)){
    stop('Input argument "parent_pkg_id" is missing! Specify the project name of the L0 dataset.')
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
  
  # Get tables from parent data ------------------------------------------------
  
  message("Retreiving tables from parent data")
  
  data <- read.csv(entity_urls, header = T, as.is = T)
  
  # Create observation table --------------------------------------------------
  
  message("Creating observation table")	
  
  # Rename fields
  
  names(data)[names(data) == 'year'] <- 'observation_datetime'
  
  # Add fields
  
  data$package_id <- child_pkg_id
  data$location_id <- paste0(data$plot, '_', data$block, '_', data$fence)
  data$taxon_id <- data$species
  
  # Convert to long format
  
  data <- gather(data, 'variable_name', 'value', avghits, biomass)
  
  # Add more fields
  
  data$observation_id <- paste0('obs_', seq(nrow(data)))
  data$unit[data$variable_name == 'avghits'] <- 'dimensionless'
  data$unit[data$variable_name == 'biomass'] <- 'gramsPerSquareMeter'
  data$event_id <- paste0('ev_', seq(nrow(data)))
  
  # Select fields
  
  observation <- select(data, observation_id, event_id, package_id, location_id,
                        observation_datetime, taxon_id, variable_name, value, 
                        unit)
  
  # Create location table -----------------------------------------------------
  
  message("Creating location table")
  
  location <- make_location(data, cols=c("plot","block","fence"))
  
  # Update observation table with location_id
  
  observation$location_id <- location$location_id[
    match(observation$location_id, location$location_name)
  ]
  
  # Create taxon table --------------------------------------------------------
  
  message("Creating taxon table")
  
  # Initialize table
  
  taxon <- data.frame(
    taxon_id = rep(NA_character_, length(unique(observation$taxon_id))),
    taxon_rank = rep(NA_character_, length(unique(observation$taxon_id))),
    taxon_name = rep(NA_character_, length(unique(observation$taxon_id))),
    authority_system = rep(NA_character_, length(unique(observation$taxon_id))),
    authority_taxon_id = rep(NA_character_, length(unique(observation$taxon_id))),
    stringsAsFactors = F
  )
  
  # Get taxa names
  
  taxa_name_map <- data.frame(taxa_codes = unique(observation$taxon_id),
                     names = c('AMS',
                               'Andromeda prolifolia',
                               'Betula nana',
                               'Carex bigelowii',
                               'Empetrum nigrum',
                               'Eriophorum vaginatum',
                               'LED',
                               'Lichen',
                               'Oxycoccus microcarpus',
                               'Rubus chamaemorus',
                               'Vaccinium uliginosum',
                               'Vaccinium vitisidaea',
                               'Aulucomnium',
                               'Dicranum',
                               'FEMO',
                               'Rhododendron subarcticum',
                               'moss',
                               'Polytrichum',
                               'Sphagnum'))
  
  # Add fields
  
  taxon$taxon_id <- paste0('tx_', seq(nrow(taxon)))
  resolved_taxa <- taxonomyCleanr::resolve_sci_taxa(data.sources = 3, 
                                                    x = taxa_name_map$names)
  taxon$taxon_rank <- resolved_taxa$rank
  taxon$taxon_name <- resolved_taxa$taxa
  taxon$authority_system <- resolved_taxa$authority
  taxon$authority_taxon_id <- resolved_taxa$authority_id
  
  # Update observation table with taxon_id
  
  observation$taxon_id <- taxon$taxon_id[
    match(observation$taxon_id, taxa_name_map$taxa_codes)]
  
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
  
  dataset_summary$number_of_years_sampled <- max(observation$observation_datetime) - min(observation$observation_datetime)
  
  # Create column: length_of_survey_years
  
  dataset_summary$length_of_survey_years <- max(observation$observation_datetime) - min(observation$observation_datetime)
  
  # Create column: std_dev_interval_betw_years
  
  dt_uni <- unique(observation$observation_datetime)
  
  dt_uni <- dt_uni[order(dt_uni)]
  
  dataset_summary$std_dev_interval_betw_years <- sd(diff(dt_uni)/1)
  
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
  
  # Create location ancillary table -------------------------------------------
  
  message("Creating location ancillary table")
  
  # Initialize table
  
  location_ancillary <- data.frame(
    location_ancillary_id = rep(NA_character_, nrow(location)),
    location_id = rep(NA_character_, nrow(location)),
    datetime = rep(NA_character_, nrow(location)),
    variable_name = rep(NA_character_, nrow(location)),
    value = rep(NA_character_, nrow(location)),
    unit = rep(NA_character_, nrow(location)),
    stringsAsFactors = F
  )
  
  # Add fields
  
  location_ancillary$location_ancillary_id <- paste0(
    'loan_', 
    seq(nrow(location_ancillary))
  )
  location_ancillary$location_id <- location$location_id
  location_ancillary$variable_name <- 'treatment'
  location_ancillary$value[stringr::str_detect(location$location_name, '^B')] <- 'drying'
  location_ancillary$value[stringr::str_detect(location$location_name, '^C')] <- 'warming'
  location_ancillary$value[stringr::str_detect(location$location_name, '^D')] <- 'drying & warming'
  
  # Create variable mapping table ---------------------------------------------
  
  message("Creating variable mapping table")
  
  variable_mapping <- make_variable_mapping(
    observation = observation,
    location_ancillary = location_ancillary
  )
  # Define 'biomass'
  use_i <- variable_mapping$variable_name == 'biomass'
  variable_mapping$mapped_system[use_i] <- 'BioPortal'
  variable_mapping$mapped_id[use_i] <- 'http://purl.dataone.org/odo/ECSO_00000513'
  variable_mapping$mapped_label[use_i] <- 'Biomass Measurement Type'
  # Define 'depth'
  use_i <- variable_mapping$variable_name == 'treatment'
  variable_mapping$mapped_system[use_i] <- 'BioPortal'
  variable_mapping$mapped_id[use_i] <- 'http://purl.dataone.org/odo/ECSO_00000506'
  variable_mapping$mapped_label[use_i] <- 'Manipulative experiment'
  
  # Write tables to file --------------------------------------------------
  
  write.csv(taxon,file=paste0(path,"/",project_name,"_taxon.csv"),row.names=FALSE,quote=FALSE)
  write.csv(observation,file=paste0(path,"/",project_name,"_observation.csv"),row.names=FALSE,quote=FALSE)
  write.csv(location,file=paste0(path,"/",project_name,"_location.csv"),row.names=FALSE,quote=FALSE)
  write.csv(dataset_summary,file=paste0(path,"/",project_name,"_dataset_summary.csv"),row.names=FALSE,quote=FALSE)
  write.csv(location_ancillary,file=paste0(path,"/",project_name,"_location_ancillary.csv"),row.names=FALSE,quote=FALSE)
  write.csv(variable_mapping,file=paste0(path,"/",project_name,"_variable_mapping.csv"),row.names=FALSE,quote=FALSE)
  
}

