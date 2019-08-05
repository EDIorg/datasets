# Create ecocomDP data tables
#
# This script converts edi.291 to the ecocomDP.

convert_edi291_to_ecocomDP <- function(path, parent_pkg_id, child_pkg_id){
  
  message(paste0('Converting ', parent_pkg_id, ' to ecocomDP (', child_pkg_id, ')' ))
  
  project_name <- 'Scleractinian_corals'
  
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
  
  data_names <- xml2::xml_text(
    xml2::xml_find_all(
      metadata,
      "//dataset/dataTable/physical/objectName"
    )
  )
  
  data <- read.csv(
    file = data_urls[
      stringr::str_detect(data_names, 'yawzi')
      ],
    as.is = T,
    header = T, 
    fill = T
  )
  
  rand <- read.csv(
    file = data_urls[
      stringr::str_detect(data_names, 'random')
      ],
    as.is = T,
    header = T, 
    fill = T
  )
  
  # Clean data ----------------------------------------------------------------
  
  # Fix column names
  
  colnames(data)[
    colnames(data) == 'ï..Date'
  ] <- 'date'
  
  colnames(rand)[
    colnames(rand) == 'ï..site'
    ] <- 'site'
  
  # Trim white space
  
  for (i in 1:ncol(data)){
    if (is.character(data[ ,i])){
      data[ ,i] <- trimws(data[ ,i], 'both')
    }
  }
  
  for (i in 1:ncol(rand)){
    if (is.character(rand[ ,i])){
      rand[ ,i] <- trimws(rand[ ,i], 'both')
    }
  }
  
  # Change missing value code nd to NA
  
  use_i <- c(5:7)
  for (i in use_i){
    data[ ,i] <- as.numeric(data[ ,i])
  }
  
  use_i <- c(2, 4:26)
  for (i in use_i){
    rand[ ,i] <- as.numeric(rand[ ,i])
  }
  
  # Align column names for join
  
  colnames(rand)[
    colnames(rand) == 'year'
  ] <- 'date'
  
  rand$transect <- NA_character_
  
  colnames(rand)[
    colnames(rand) == 'percentCover_all'
    ] <- 'percentCover_allCoral'
  
  rand$quadrat <- as.character(rand$quadrat)
  
  # Create observation table --------------------------------------------------
  
  message('Creating table "observation"')	
  
  # observation_datetime
  
  colnames(data)[
    colnames(data) == 'date'
    ] <- 'observation_datetime'
  
  data$observation_datetime <- dataCleanr::iso8601_convert(
    data$observation_datetime,
    orders = 'ymd'
  )
  
  colnames(rand)[
    colnames(rand) == 'date'
    ] <- 'observation_datetime'
  
  rand$observation_datetime <- paste0(
    rand$observation_datetime,
    '-01-01'
  )
  
  rand$observation_datetime <- dataCleanr::iso8601_convert(
    rand$observation_datetime,
    orders = 'ymd'
  )
  
  # Join
  
  data <- dplyr::bind_rows(
    data,
    rand
  )
  
  # location_id
  
  data$location_id <- paste0(
    data$site,
    '_',
    data$transect,
    '_',
    data$quadrat
  )
  
  # event_id
  
  data$event_id <- paste0(
    'ev_',
    seq(nrow(data))
  )
  
  # Select
  
  observation <- dplyr::select(
    data,
    -site,
    -transect,
    -quadrat
  )
  
  # Gather
  
  observation <- tidyr::gather(
    observation,
    'variable_name',
    'value',
    -observation_datetime,
    -location_id,
    -event_id
  )

  # package_id
  
  observation$package_id <- child_pkg_id
  
  # taxon_id
  
  map_taxa <- data.frame(
    id = paste0('tx_', seq(unique(observation$variable_name))),
    key = unique(observation$variable_name),
    name = NA_character_,
    stringsAsFactors = F
  )
  
  colnames(observation)[
    colnames(observation) == 'variable_name'
    ] <- 'taxon_id'
  
  # variable_name
  
  observation$variable_name <- 'Percent cover'
  
  # unit
  
  observation$unit <- 'percent'
  
  # observation_id
  
  observation$observation_id <- paste0(
    'ob_',
    seq(nrow(observation))
  )
  
  # Select
  
  observation <- dplyr::select(
    observation,
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
  
  # Create observation_ancillary table ----------------------------------------
  
  message('Creating table "observation_ancillary"')
  
  # Select
  
  observation_ancillary <- dplyr::select(
    data,
    event_id,
    site
  )
  
  # Filter
  
  observation_ancillary <- dplyr::filter(
    observation_ancillary,
    site == 'Yawzi' | site == 'Tektite'
  )
  
  # variable_name
  
  observation_ancillary$variable_name <- 'Actual temporal resolution'
  
  # value
  
  observation_ancillary$value <- 'YYYY'
  
  # observation_ancillary_id
  
  observation_ancillary$observation_ancillary_id <- paste0(
    'oban_',
    seq(nrow(observation_ancillary))
  )
  
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
    cols = c('site', 'transect', 'quadrat', 'location_id'),
    parent.package.id = parent_pkg_id
  )
  
  # location_id (observation)
  
  observation$location_id <- location$location_id[
    match(
      observation$location_id,
      location$location_name)
  ]

  # Create taxon table --------------------------------------------------------
  
  message('Creating table "taxon"')
  
  # Get taxa names
  
  taxon <- ecocomDP::make_taxon(
    taxa = map_taxa$key,
    taxon.id = map_taxa$id,
    name.type = 'scientific',
    data.sources = c(3, 9)
  )
  
  # taxon_id (observation)
  
  observation$taxon_id <- taxon$taxon_id[
    match(
      observation$taxon_id,
      taxon$taxon_name)
    ]
  
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
    observation = observation,
    observation_ancillary = observation_ancillary
  )
  
  # Percent cover
  
  use_i <- variable_mapping$variable_name == 'Percent cover'
  variable_mapping$mapped_system[use_i] <- 'The Ecosystem Ontology'
  variable_mapping$mapped_id[use_i] <- 'http://purl.dataone.org/odo/ECSO_00001190'
  variable_mapping$mapped_label[use_i] <- 'Aerial Cover Percentage'

  # Write tables to file ------------------------------------------------------
  
  ecocomDP::write_ecocomDP_tables(
    path = path,
    sep = ',',
    study.name = project_name,
    observation = observation,
    observation_ancillary = observation_ancillary,
    location = location,
    taxon = taxon,
    dataset_summary = dataset_summary,
    variable_mapping = variable_mapping
  )

}
