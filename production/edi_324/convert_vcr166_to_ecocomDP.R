# Create ecocomDP data tables
#
# This script converts knb-lter-vcr.166.x to the ecocomDP.

convert_vcr166_to_ecocomDP <- function(path, parent_pkg_id, child_pkg_id){
  
  message(paste0('Converting ', parent_pkg_id, ' to ecocomDP (', child_pkg_id, ')' ))
  
  project_name <- 'heron_counts'
  
  # Load libraries
  
  library(xml2)
  library(tidyr)
  library(dplyr)
  library(ecocomDP)
  library(lubridate)
  library(taxonomyCleanr)
  library(dataCleanr)
  library(stringr)
  
  # Validate arguments --------------------------------------------------------
  
  if (missing(path)){
    stop('Input argument "path" is missing! Specify the path to the directory that will be filled with ecocomDP tables.')
  }
  if (missing(child_pkg_id)){
    stop('Input argument "child_pkg_id" is missing! Specify new package ID (e.g. edi.249.1, or knb-lter-mcr.8.1.')
  }
  if (missing(parent_pkg_id)){
    stop('Input argument "parent_pkg_id" is missing! Specify the project name of the L0 dataset.')
  }
  
  # Load EML and extract information ------------------------------------------
  
  message('Loading data')
  
  metadata <- EDIutils::api_read_metadata(parent_pkg_id)
  
  data_urls <- xml2::xml_text(
    xml2::xml_find_all(
      metadata,
      "//dataset/dataTable/physical/distribution/online/url"
    )
  )
  
  header_lines <- xml2::xml_text(
    xml2::xml_find_all(
      metadata,
      "//dataset/dataTable/physical/dataFormat/textFormat/numHeaderLines"
    )
  )
  
  data <- read.csv(
    file = data_urls,
    skip = (as.numeric(header_lines) - 1),
    as.is = T,
    header = T
  )
  
  # Clean data ----------------------------------------------------------------
  
  # Trim white space
  
  for (i in 1:ncol(data)){
    if (is.character(data[ ,i])){
      data[ ,i] <- trimws(data[ ,i], 'both')
    }
  }
  
  # Convert comment in GE column to NA
  
  data$BC[stringr::str_detect(data$BC, 'survey')] <- NA
  data$BC <- as.numeric(data$BC)
  
  # Gather
  
  data <- tidyr::gather(
    data,
    'variable_name',
    'value',
    -Colony,
    -Year,
    -UTMX,
    -UTMY,
    -Comment,
    -Total
  )
  
  # Create observation table --------------------------------------------------
  
  message('Creating table "observation"')	
  
  # observation_datetime
  
  names(data)[
    names(data) == 'Year'
    ] <- 'observation_datetime'
  
  # location_id
  
  map_location <- data.frame(
    id = paste0('lo_', seq(unique(data$Colony))),
    key = unique(data$Colony),
    stringsAsFactors = F
  )
  
  data$location_id <- map_location$id[match(data$Colony, map_location$key)]
  
  # event_id
  
  data$event_id <- paste0('ev_', seq(nrow(data)))
  
  # package_id
  
  data$package_id <- child_pkg_id
  
  # taxon_id
  
  map_taxa <- data.frame(
    id = unique(data$variable_name),
    key = NA_character_,
    stringsAsFactors = F
  )
  
  names(data)[
    names(data) == 'variable_name'
    ] <- 'taxon_id'
  
  # variable_name
  
  data$variable_name <- 'number_of_pairs'
  
  # unit
  
  data$unit <- 'count'
  
  # observation_id
  
  data$observation_id <- paste0(
    'ob_',
    seq(nrow(data))
  )
  
  # Select
  
  observation <- dplyr::select(
    data,
    observation_id,
    event_id,
    package_id,
    location_id,
    observation_datetime,
    taxon_id,
    variable_name,
    value,
    unit
  )
  
  # Create observation_ancillary ----------------------------------------------
  
  message('Creating table observation_ancillary')
  
  observation_ancillary <- dplyr::select(
    data,
    event_id,
    Comment
  )
  
  # observation_ancillary_id
  
  observation_ancillary$observation_ancillary_id <- paste0(
    'oban_',
    seq(nrow(observation_ancillary))
  )
  
  # variable_name
  
  observation_ancillary$variable_name <- 'Comments'
  
  # value
  
  names(observation_ancillary)[
    names(observation_ancillary) == 'Comment'
    ] <- 'value'
  
  # Select
  
  observation_ancillary <- dplyr::select(
    observation_ancillary,
    observation_ancillary_id,
    event_id,
    variable_name,
    value
  )
  
  # Create location table -----------------------------------------------------
  
  message('Creating table "location"')
  
  # Make location table
  
  location <- ecocomDP::make_location(
    x = data,
    cols = c('Colony', 'Colony')
  )
  
  location <- location[stringr::str_detect(location$location_id, 'lo_1'), ]
  
  location$location_id <- paste0(
    'lo_',
    seq(nrow(location))
  )
  
  # Create location_ancillary -------------------------------------------------
  
  message('Creating table "location_ancillary"')
  
  location_ancillary <- location
  
  location_ancillary$latitude <- unique(data$UTMY)
  
  location_ancillary$longitude <- unique(data$UTMX)
  
  # Gather
  
  location_ancillary <- tidyr::gather(
    location_ancillary,
    'variable_name',
    'value',
    latitude,
    longitude
  )
  
  # unit
  
  location_ancillary$unit <- 'meter'

  # location_ancillary_id
  
  location_ancillary$location_ancillary_id <- paste0(
    'loan_',
    seq(nrow(location_ancillary))
  )
  
  # Select
  
  location_ancillary <- dplyr::select(
    location_ancillary,
    location_ancillary_id,
    location_id,
    variable_name,
    value,
    unit
  )
  
  # Create taxon table --------------------------------------------------------
  
  # Get taxa names
  
  map_taxa$key[map_taxa$id == 'BC'] <- 'Black Crowned Night Heron'
  map_taxa$key[map_taxa$id == 'GE'] <- 'Great Egret'
  map_taxa$key[map_taxa$id == 'SE'] <- 'Snowy Egret'
  map_taxa$key[map_taxa$id == 'CE'] <- 'Cattle Egret'
  map_taxa$key[map_taxa$id == 'TH'] <- 'Tricolored Heron'
  map_taxa$key[map_taxa$id == 'LH'] <- 'Little Blue Heron'
  map_taxa$key[map_taxa$id == 'GI'] <- 'Glossy Ibis'
  map_taxa$key[map_taxa$id == 'WI'] <- 'White Ibis'
  
  taxon <- ecocomDP::make_taxon(
    taxa = map_taxa$key,
    taxon.id = map_taxa$id,
    name.type = 'common',
    data.sources = 3
  )
  
  # Create dataset_summary table ----------------------------------------------
  
  message('Creating table "dataset_summary"')
  
  dataset_summary <- ecocomDP::make_dataset_summary(
    parent.package.id = parent_pkg_id,
    child.package.id = child_pkg_id,
    sample.dates = as.character(observation$observation_datetime),
    taxon.table = taxon
  )
  
  # Create variable_mapping table ---------------------------------------------
  
  message('Creating table "variable_mapping"')
  
  variable_mapping <- ecocomDP::make_variable_mapping(
    observation = observation
  )
  
  # Write tables to file ------------------------------------------------------
  
  ecocomDP::write_ecocomDP_tables(
    path = path,
    sep = ',',
    study.name = project_name,
    observation = observation,
    observation_ancillary = observation_ancillary,
    location = location,
    location_ancillary = location_ancillary,
    taxon = taxon,
    dataset_summary = dataset_summary,
    variable_mapping = variable_mapping
  )
  

}
