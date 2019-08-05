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
library(stringr)
# library(tidyverse)

path <- 'C:\\Users\\Colin\\Documents\\EDI\\data_sets\\ecocomDP\\knb-lter-hfr-105'
parent_pkg_id <- 'knb-lter-hfr.105.22'
child_pkg_id <- 'edi.261.1'

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
  catvars$definition[use_i] <- 'estimated number of seeds = Seed.mass.g/Ind.mass.g, rounded to nearest integer'
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

convert_tables <- function(path, child_pkg_id, parent_pkg_id){
  
  project_name <- 'seed_bank_in_hemlock_removal'
  
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
  
  seedbank_2004 <- read.csv(file = entity_urls[grep("seedbank-2004",entity_names,value=FALSE)], stringsAsFactors = F)
  understory_2004 <- read.csv(file=entity_urls[grep("understory-2004",entity_names,value=FALSE)], stringsAsFactors = F)
  seedbank_2010 <- read.csv(file=entity_urls[grep("seedbank-2010",entity_names,value=FALSE)], stringsAsFactors = F)
  understory_2010 <- read.csv(file=entity_urls[grep("understory-2010",entity_names,value=FALSE)], stringsAsFactors = F)
  seed_rain <- read.csv(file=entity_urls[grep("rain",entity_names,value=FALSE)], stringsAsFactors = F)
  sample_coord <- read.csv(file=entity_urls[grep("coord",entity_names,value=FALSE)], stringsAsFactors = F)
  species_codes <- read.csv(file=entity_urls[grep("species",entity_names,value=FALSE)], stringsAsFactors = F)
  
  # Gather variable and unit information from metadata ------------------------
  
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
  
  # Create location table -----------------------------------------------------
  
  message("Creating location table")
  
  location <- make_location(sample_coord,cols=c("block","plot","replicate"))
  write.csv(location,file=paste0(path,"/",project_name,"_location.csv"),row.names = FALSE,quote = FALSE)
  
  # Create observation table --------------------------------------------------
  
  message("Creating observation table")	
  
  seedbank_2004$event_id <- seq(1:nrow(seedbank_2004))
  seedbank_2010$event_id <- seq(1:nrow(seedbank_2010))
  understory_2004$event_id <- seq(1:nrow(understory_2004))
  understory_2010$event_id <- seq(1:nrow(understory_2010))
  seed_rain$event_id <- seq(1:nrow(seed_rain))
  
  seedbank_2004_long <- gather(seedbank_2004,key="variable_name",value="value",acru:poaceae)
  understory_2004_long <- gather(understory_2004,key="variable_name",value="value",acru:deob)
  data_2004 <- rbind(seedbank_2004_long,understory_2004_long)
  
  seedbank_2010_long <- gather(seedbank_2010,key="variable_name",value="value",bele:cadw)
  understory_2010_long <- gather(understory_2010,key="variable_name",value="value",depu:cope)
  
  data_2004$block <- sapply(data_2004$simes.plot,function(x) {ifelse(any(x %in% c(1:3,8)),"valley","ridge")})
  
  data_2004$location <- sapply(c(1:nrow(data_2004)),function(x) paste(data_2004$block[x],data_2004$simes.plot[x],data_2004$replicate[x],sep = "_"))
  data_2004$location_id <- location$location_id[match(data_2004$location,location$location_name)]
  data_2004$observation_datetime <- "2004-01-01"
  
  seedbank_2010_long$location_id <- sapply(c(1:nrow(seedbank_2010_long)),function(x) paste(seedbank_2010_long$block[x],seedbank_2010_long$plot[x],seedbank_2010_long$replicate[x],sep="_"))
  seedbank_2010_long$location_id <- location$location_id[match(seedbank_2010_long$location_id,location$location_name)]
  seedbank_2010_long$observation_datetime <- "2010-01-01"
  
  understory_2010_long$location_id <- sapply(c(1:nrow(understory_2010_long)),function(x) paste(understory_2010_long$block[x],understory_2010_long$plot[x],understory_2010_long$replicate[x],sep="_"))
  understory_2010_long$location_id <- location$location_id[match(understory_2010_long$location_id,location$location_name)]
  names(understory_2010_long)[names(understory_2010_long) == 'date'] <- "observation_datetime"
  
  names(seed_rain)[names(seed_rain) == 'date'] <- "observation_datetime"
  seed_rain$location_id <- sapply(c(1:nrow(seed_rain)),function(x) paste(seed_rain$block[x],seed_rain$plot[x],sep="_"))
  seed_rain$location_id <- location$location_id[match(seed_rain$location_id,location$location_name)]
  seed_rain$taxon_name <- sapply(c(1:nrow(seed_rain)),function(x) paste(seed_rain$genus[x],seed_rain$species[x]))
  
  seed_rain_taxa <- as.vector(unique(seed_rain$taxon_name[which(seed_rain$taxon_name %in% species_codes$species.name == FALSE)]))
  code_seed_rain_taxa <- c("besp","pobi","acsp","nysy","qusp","osvir","coal","caum","cosp","vasp","rhsp","vide","amspe","frsp","tssp","viac","prsp","vica","coali","visp","cysp","saal")
  seed_rain_taxa <- data.frame(code_seed_rain_taxa,seed_rain_taxa, stringsAsFactors = F)
  colnames(seed_rain_taxa) <- colnames(species_codes)
  species_codes <- rbind(species_codes,seed_rain_taxa)
  seed_rain$taxon_name <- species_codes$species.code[match(seed_rain$taxon_name,species_codes$species.name)]
  
  event_id <- c(data_2004$event_id,seedbank_2010_long$event_id,understory_2010_long$event_id,seed_rain$event_id)
  package_id <- rep(child_pkg_id,length(event_id))
  observation_datetime <- c(as.vector(data_2004$observation_datetime),as.vector(seedbank_2010_long$observation_datetime),as.vector(understory_2010_long$observation_datetime),as.vector(seed_rain$observation_datetime))
  taxon_id <- c(as.vector(data_2004$variable_name),as.vector(seedbank_2010_long$variable_name),as.vector(understory_2010_long$variable_name),as.vector(seed_rain$taxon_name))
  variable_name <- rep("count",length(event_id))
  value <- c(data_2004$value,seedbank_2010_long$value,understory_2010_long$value,seed_rain$seed.count)
  unit <- rep(NA_character_,length(value))
  observation_id <- c(1:length(event_id))
  location_id <- c(as.vector(data_2004$location_id),as.vector(seedbank_2010_long$location_id),as.vector(understory_2010_long$location_id),as.vector(seed_rain$location_id))
  
  observation <- data.frame(observation_id,event_id,package_id,location_id,observation_datetime,taxon_id,variable_name,value,unit, stringsAsFactors = F)
  
  write.csv(observation,file=paste0(path,"/",project_name,"_observation.csv"),row.names=FALSE,quote=FALSE)
  
  # Create taxon table --------------------------------------------------------
  
  message("Creating taxon table")
  
  species_codes$species.code <- as.vector(species_codes$species.code)
  species.code <- c(species_codes$species.code,"juef","vinu")
  species_codes$species.name <- as.vector(species_codes$species.name)
  species.name <- c(species_codes$species.name,"Juncus effusus","Viburnum nudum")
  species_codes <- data.frame(species.code,species.name, stringsAsFactors = F)
  taxa <- species_codes
  
  taxa <- replace_taxa(x = taxa, col = 'species.name', input="Total number of Poaceae (grasses)", output = "Poaceae")
  taxa <- replace_taxa(x = taxa, col = 'species.name', input="Total number of Rubus (= rufl + rusp)", output = "Rubus")
  taxa <- replace_taxa(x = taxa, col = 'species.name', input="Total number of Betula spp. ", output = "Betula")
  taxa$species.name <-trim_taxa(x = taxa$species.name)
  taxa_resolved <- resolve_sci_taxa(x = taxa$species.name, data.sources = c(3,11))
  taxa_resolved$id <- taxa$species.code
  use_i <- is.na(taxa_resolved$taxa_clean)
  taxa_resolved$taxa_clean[use_i] <- taxa_resolved$taxa[use_i]
  
  taxon_id <- taxa_resolved$id
  taxon_rank <- taxa_resolved$rank
  taxon_name <- taxa_resolved$taxa_clean
  authority_system <- taxa_resolved$authority
  authority_taxon_id <- taxa_resolved$authority_id
  
  taxon <- data.frame(taxon_id,taxon_rank,taxon_name,authority_system,authority_taxon_id, stringsAsFactors = F)
  
  write.csv(taxon,file=paste0(path,"/",project_name,"_taxon.csv"),row.names=FALSE,quote=FALSE)
  
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
  write.csv(dataset_summary,file=paste0(path,"/",project_name,"_dataset_summary.csv"),row.names=FALSE,quote=FALSE)
  
  # Create observation ancillary table ----------------------------------------
  
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
  
  observation_ancillary <- data.frame(observation_ancillary_id,event_id,variable_name,value,unit, stringsAsFactors = F)
  observation_ancillary <- observation_ancillary[-which(observation_ancillary$variable_name == "treatment"),]
  
  # Note where date resolution is inaccurately represented
  use_i <- (observation$observation_datetime == '2004-01-01') | (observation$observation_datetime == '2010-01-01')
  datetime_notes <- data.frame(observation_ancillary_id = seq(max(observation_ancillary$observation_ancillary_id)+1,
                                                              max(observation_ancillary$observation_ancillary_id)+sum(use_i)),
                               event_id = NA_character_,
                               variable_name = NA_character_,
                               value = NA_character_,
                               unit = NA_character_,
                               stringsAsFactors = F)
  datetime_notes$event_id <- observation$event_id[use_i]
  datetime_notes$variable_name <- 'actual_date_resolution'
  datetime_notes$value <- 'YYYY'
  observation$observation_datetime[datetime_notes$event_id]
  observation_ancillary <- rbind(observation_ancillary, datetime_notes)
  
  write.csv(observation_ancillary,file=paste0(path,"/",project_name,"_observation_ancillary.csv"),row.names=FALSE,quote=FALSE)
  
  # Create location ancillary table -------------------------------------------
  
  message("Creating location ancillary table")
  
  location_names <- sapply(c(1:nrow(sample_coord)),function(x) paste(sample_coord$block[x],sample_coord$plot[x],sample_coord$replicate[x],sep="_"))
  sample_coord_names <- data.frame(sample_coord,location_names, stringsAsFactors = F)
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
  location_ancillary <- data.frame(location_ancillary_id,location_id,variable_name,value,unit, stringsAsFactors = F)
  location_ancillary$variable_name <- gsub("treatmetn","treatment",location_ancillary$variable_name)
  
  write.csv(location_ancillary,file=paste0(path,"/",project_name,"_location_ancillary.csv"),row.names=FALSE,quote=FALSE)
  
  # Create variable mapping table ---------------------------------------------
  
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
  # Define 'depth'
  use_i <- variable_mapping$variable_name == 'depth'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/verbatimDepth'
  variable_mapping$mapped_label[use_i] <- 'verbatimDepth'
  
  write.csv(variable_mapping,file=paste0(path,"/",project_name,"_variable_mapping.csv"),row.names=FALSE,quote=FALSE)
  
  
}
