# Create ecocomDP data tables
#
# This script converts knb-lter-mcr.1038.x to the ecocomDP.

convert_mcr1038_to_ecocomDP <- function(path, parent_pkg_id, child_pkg_id){
  
  message(paste0('Converting ', parent_pkg_id, ' to ecocomDP (', child_pkg_id, ')' ))
  
  project_name <- 'coral_cover'
  
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
  
  entity_names <- EDIutils::api_read_data_entity_names(parent_pkg_id)
  
  data_urls <- xml2::xml_text(
    xml2::xml_find_all(
      metadata,
      "//dataset/dataTable/physical/distribution/online/url"
    )
  )
  
  entity_info <- data.frame(
    names = entity_names,
    urls = data_urls,
    stringsAsFactors = F
  )
  
  data <- read.csv(
    file = entity_info$urls[stringr::str_detect(tolower(entity_info$names), 'long')], 
    header = T, 
    as.is = T
  )
  
  # Clean data ----------------------------------------------------------------
  
  # Remove invalid year values
  
  data$year[stringr::str_detect(data$year, 'rows')] <- NA_character_
  
  # Trim white space
  
  for (i in 1:ncol(data)){
    if (is.character(data[ ,i])){
      data[ ,i] <- trimws(data[ ,i], 'both')
    }
  }

  # Create observation table --------------------------------------------------
  
  message('Creating table "observation"')	
  
  # observation_datetime
  
  names(data)[
    names(data) == 'year'
    ] <- 'observation_datetime'

  # location_id

  data$location_id <- paste0(
    data$site,
    '_',
    data$patch,
    '_',
    data$quad
  )
  
  # event_id
  
  data$event_id <- paste0(
    data$observation_datetime,
    data$location_id
  )
  
  event_id_map <- data.frame(
    key = unique(data$event_id),
    id = paste0('ev_', seq(length(unique(data$event_id)))),
    stringsAsFactors = F
  )
  
  data$event_id <- event_id_map$id[match(data$event_id, event_id_map$key)]
  
  # package_id
  
  data$package_id <- child_pkg_id
  
  # taxon_id
  
  taxon_id_map <- data.frame(
    key = unique(data$benthic_category),
    id = paste0('tx_', seq(length(unique(data$benthic_category)))),
    stringsAsFactors = F
  )
  
  data$taxon_id <- taxon_id_map$id[
    match(data$benthic_category, taxon_id_map$key)
  ]
  
  # Select
  
  observation <- dplyr::select(
    data,
    observation_datetime,
    event_id,
    location_id,
    taxon_id,
    percent_cover,
    package_id
  )
  
  # variable_name and value
  
  names(observation)[
    names(observation) == 'percent_cover'
    ] <- 'value'
  
  observation$variable_name <- 'percent_cover'
  
  # unit
  
  observation$unit <- 'dimensionless'
  
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
  
  # Create location table -----------------------------------------------------
  
  message('Creating table "location"')
  
  # Make location table
  
  location <- ecocomDP::make_location(
    x = data,
    cols = c('site', 'patch', 'quad', 'location_id')
  )

  # location_id (observation table)
  
  observation$location_id <- location$location_id[
    match(observation$location_id, location$location_name)
  ]
  
  # Create taxon table --------------------------------------------------------
  
  taxon <- ecocomDP::make_taxon(
    taxa = taxon_id_map$key,
    taxon.id = taxon_id_map$id,
    name.type = 'scientific',
    data.sources = c(3, 9)
  )
  
  # Create dataset_summary table ----------------------------------------------
  
  message('Creating table "dataset_summary"')
  
  dataset_summary <- ecocomDP::make_dataset_summary(
    parent.package.id = parent_pkg_id,
    child.package.id = child_pkg_id,
    sample.dates = observation$observation_datetime,
    taxon.table = taxon
  )
  
  # Create variable_mapping table ---------------------------------------------
  
  message('Creating table "variable_mapping"')
  
  variable_mapping <- ecocomDP::make_variable_mapping(
    observation = observation
  )
  
  # Percent_Cover
  
  use_i <- variable_mapping$variable_name == 'percent_cover'
  variable_mapping$mapped_system[use_i] <- 'The Ecosystem Ontology'
  variable_mapping$mapped_id[use_i] <- 'http://purl.dataone.org/odo/ECSO_00001190'
  variable_mapping$mapped_label[use_i] <- 'Aerial Cover Percentage'
  
  # Write tables to file ------------------------------------------------------
  
  ecocomDP::write_ecocomDP_tables(
    path = path,
    sep = ',',
    study.name = project_name,
    observation = observation,
    location = location,
    taxon = taxon,
    dataset_summary = dataset_summary,
    variable_mapping = variable_mapping
  )

}
