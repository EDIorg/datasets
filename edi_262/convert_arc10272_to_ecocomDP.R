# Create ecocomDP data package
#
# This script converts knb-lter-arc.10272.x to the ecocomDP, validates the 
# resultant tables, and creates the associated EML record.

# Initialize workspace --------------------------------------------------------

library(stringr)
library(reshape2)
library(Rcpp)
library(stringi)
library(XML)
library(readr)
library(sf)
library(tidyr)
library(dplyr)
library(ecocomDP)
library(lubridate)
library(taxonomyCleanr)
library(dataCleanr)

path <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\ecocomDP\\knb-lter-arc.10272'
parent_pkg_id <- 'knb-lter-arc.10272.4'
child_pkg_id <- 'edi.262.1'

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
if ('density' %in% catvars$code){
  use_i <- catvars$code == 'density'
  catvars$definition[use_i] <- 'Density of taxon in vertical tow'
  catvars$unit[use_i] <- 'numberPerLiter'
}
if ('DepthOfTow' %in% catvars$code){
  use_i <- catvars$code == 'DepthOfTow'
  catvars$definition[use_i] <- 'Depth of vertical tow of 0.3 m diameter plankton net'
  catvars$unit[use_i] <- 'meter'
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
  
  project_name <- '2003-2011ArcLTERZoops'
    
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
  
  original_data <- read.csv(file = entity_urls[grep("_csv",entity_names,value=FALSE)], as.is = T)
  
  # Format date to R date
  original_data$Date <- as.Date(original_data$Date,"%d-%b-%Y")
  
  # Make into long format
  # Make data into long format
  long_data <- original_data %>%
    gather(taxon,numberPerlitter, Daphnia.midd:Heterocope)
  
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
  
  # Make location table: ------------------------------------------------------
  
  message('Building location table')
  
  # Create column: 
  long_data$Site <- trimws(
    long_data$Site,
    which = 'both'
  )
  
  
  long_data$Station.number <- trimws(
    long_data$Station.number,
    which = 'both'
  )
  
  
  #Combines my three location identifiers into a single column for a key
  long_data$key_loc <- apply(
    long_data[ , c('Site', 'Station.number')],
    1,
    paste,
    collapse = "_"
  )
  
  
  # Make location table  
  
  location_table <- make_location(
    x = long_data, 
    cols = c(
      'Site', #Most broad location
      'Station.number' #more  specific location
      
    ) 
  )
  
  location <- location_table
  
  
  
  # Adds longitude for sites (got from original metadata)
  location$longitude <- ifelse(grepl("103",location$location_name),-149.607,
                               ifelse(grepl("107",location$location_name),-149.642,
                                      ifelse(grepl("111",location$location_name),-149.588,
                                             ifelse(grepl("112",location$location_name),-149.566,
                                                    ifelse(grepl("113",location$location_name),-149.584,
                                                           ifelse(grepl("114",location$location_name),-149.584,
                                                                  ifelse(grepl("115",location$location_name),-149.59,
                                                                         ifelse(grepl("116",location$location_name),-149.593,
                                                                                ifelse(grepl("117",location$location_name),-149.597,
                                                                                       ifelse(grepl("118",location$location_name),-149.582,
                                                                                              ifelse(grepl("120",location$location_name),-149.601,
                                                                                                     ifelse(grepl("146",location$location_name),-149.555,
                                                                                                            ifelse(grepl("156",location$location_name),-149.651,
                                                                                                                   ifelse(grepl("171",location$location_name),-149.599,
                                                                                                                          ifelse(grepl("388",location$location_name),-149.566,
                                                                                                                                 ifelse(grepl("431",location$location_name),-149.623,NA))))))))))))))))
  
  # Adds latitude for sites
  location$latitude <-  ifelse(grepl("103",location$location_name),68.6399,
                               ifelse(grepl("107",location$location_name),68.629,
                                      ifelse(grepl("111",location$location_name),68.5687,
                                             ifelse(grepl("112",location$location_name),68.5713,
                                                    ifelse(grepl("113",location$location_name),68.5755,
                                                           ifelse(grepl("114",location$location_name),68.6796,
                                                                  ifelse(grepl("115",location$location_name),68.5874,
                                                                         ifelse(grepl("116",location$location_name),68.5966,
                                                                                ifelse(grepl("117",location$location_name),68.6009,
                                                                                       ifelse(grepl("118",location$location_name),68.6102,
                                                                                              ifelse(grepl("120",location$location_name),68.6108,
                                                                                                     ifelse(grepl("146",location$location_name),68.6262,
                                                                                                            ifelse(grepl("156",location$location_name),68.6301,
                                                                                                                   ifelse(grepl("171",location$location_name),68.6526,
                                                                                                                          ifelse(grepl("388",location$location_name),68.5563,
                                                                                                                                 ifelse(grepl("431",location$location_name),68.5821,NA))))))))))))))))
  
  
  # Adds elevation for sites
  location$elevation <- ifelse(grepl("103",location$location_name),719,
                               ifelse(grepl("107",location$location_name),731,
                                      ifelse(grepl("111",location$location_name),785,
                                             ifelse(grepl("112",location$location_name),785,
                                                    ifelse(grepl("113",location$location_name),774,
                                                           ifelse(grepl("114",location$location_name),770,
                                                                  ifelse(grepl("115",location$location_name),767,
                                                                         ifelse(grepl("116",location$location_name),754,
                                                                                ifelse(grepl("117",location$location_name),742,
                                                                                       ifelse(grepl("118",location$location_name),744,
                                                                                              ifelse(grepl("120",location$location_name),736,
                                                                                                     ifelse(grepl("146",location$location_name),762,
                                                                                                            ifelse(grepl("156",location$location_name),750,
                                                                                                                   ifelse(grepl("171",location$location_name),747,
                                                                                                                          ifelse(grepl("388",location$location_name),801,
                                                                                                                                 ifelse(grepl("431",location$location_name),806,NA))))))))))))))))
  
  # Make taxon table ----------------------------------------------------------
  
  message('Building taxon table')
  
  # Create vectors to use as columns (got names from metadata)
  taxon_name <- c("Bosmina longirostris","Cyclops scutifer","Daphnia longiremis","Daphnia middendorffiana",
                  "Diaptomus pribilofensis","Heterocope septentrionalis","Holopedium gibberum")
  taxa_resolved <- taxonomyCleanr::resolve_sci_taxa(data.sources = c(3, 9), x = taxon_name)
  
  taxon_name <- taxa_resolved$taxa_clean
  taxon_rank <- taxa_resolved$rank
  taxon_id <- paste0('taxon', seq(1:length(taxon_name)))
  authority_system <- taxa_resolved$authority
  authority_taxon_id <- taxa_resolved$authority_id
  
  # Combine vectors into a dataframe
  taxon <- data.frame(taxon_id, taxon_rank, taxon_name, authority_system, authority_taxon_id, stringsAsFactors = F) 
  
  # Create observation table ---------------------------------------------------------------------------------------
  
  message('Building observation table')
  
  # make taxon_id column
  long_data$taxon_id <- with(long_data,ifelse(taxon =="Bosmina","taxon1",
                                              ifelse(taxon=="Cyclops","taxon2",
                                                     ifelse(taxon=="Daphnia.long","taxon3",
                                                            ifelse(taxon=="Daphnia.midd","taxon4",
                                                                   ifelse(taxon=="Diaptomus","taxon5",
                                                                          ifelse(taxon=="Heterocope","taxon6",
                                                                                 ifelse(taxon=="Holopedium","taxon7",NA))))))))
  
  # make observation_datetime column
  long_data$observation_datetime <- as.Date(long_data$Date,"%d-%b-%y")
  
  # make parent_id column
  long_data$package_id <- rep(parent_pkg_id,length(long_data$Site))
  
  # make event_id column
  long_data$event_id <- paste0("event",rownames(long_data))
  
  # make observation_id column
  long_data$observation_id <- paste0("obs",rownames(long_data))
  
  # make variable_name column
  long_data$variable_name <- rep("density", length(long_data$Site))
  
  # make unit column
  long_data$unit <- rep("numberPerLiter",length(long_data$Site))
  
  # rename numberPerlitter column to value
  long_data <-long_data %>%
    rename(value = numberPerlitter)
  
  # Link tables: location to observation 
  use_i <- match(
    long_data$key_loc,
    location$location_name
  )
  
  long_data$location_id <- location$location_id[use_i]
  
  
  # remove extra columns and reorganize to make observation table
  observation <-long_data %>%
    select(c(observation_id,event_id,package_id,location_id,observation_datetime,taxon_id,variable_name,
             value,unit))
  
  # Make observation ancillary table ------------------------------------------
  
  # make value, unit, event_id, and variable_name columns
  observation_ancillary <- long_data %>%
    select(c(event_id,Depth.of.tow)) %>%
    rename(value = Depth.of.tow) %>%
    mutate(unit = "meters", variable_name = "DepthOfTow")
  
  # make observation_ancillary_id
  observation_ancillary$observation_ancillary_id <- paste0("obs_a",rownames(observation_ancillary))
  
  # reorder columns        
  observation_ancillary <- observation_ancillary[c(5,1,4,2,3)]
  
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
  
  dataset_summary$geo_extent_bounding_box_m2 <- round(
    get_area_square_meters(
      min(westBoundingCoordinate),
      max(eastBoundingCoordinate),
      max(northBoundingCoordinate),
      min(southBoundingCoordinate)
      )
    )
  
  # Update table: observation$package_id----------------------------------------
  
  observation$package_id <- rep(
    dataset_summary$package_id,
    nrow(
      observation
    )
  )
  
  # Create variable mapping table ----------------------------------------------
  
  message("Creating variable mapping table")
  
  variable_mapping <- make_variable_mapping(
    observation = observation,
    observation_ancillary = observation_ancillary
  )
  # Define 'notes'
  use_i <- variable_mapping$variable_name == 'DepthOfTow'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/verbatimDepth'
  variable_mapping$mapped_label[use_i] <- 'verbatimDepth'
  
  # Write tables to file ----------------------------------------------------
  
  message(
    'Writing tables to file'
  )
  
  # Write observation table
  
  write_csv(
    observation,
    path = paste0(path,
                  "/",
                  project_name,
                  '_observation.csv')
  )
  
  # Write taxon table
  
  write_csv(
    taxon,
    path = paste0(path,
                  "/",
                  project_name,
                  "_taxon.csv")
  )
  
  # Write location table
  
  write_csv(
    location,
    path = paste0(path,
                  "/",
                  project_name,
                  "_location.csv")
  )
  
  # Write location_ancillary table
  
  write_csv(
    observation_ancillary,
    path = paste0(path,
                  "/",
                  project_name,
                  "_observation_ancillary.csv")
  )
  
  
  # Write dataset_summary table
  
  write_csv(
    dataset_summary,
    path = paste0(path,
                  "/",
                  project_name,
                  "_dataset_summary.csv")
  )
  
  # Write variable_mapping table
  
  write.csv(variable_mapping,file=paste0(path,"/",project_name,"_variable_mapping.csv"),quote=FALSE,row.names=FALSE)
  
  
  message('Done')
  
}

