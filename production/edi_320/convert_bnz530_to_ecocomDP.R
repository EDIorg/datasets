# Create ecocomDP data tables
#
# This script converts knb-lter-bnz.530.x to the ecocomDP.

convert_bnz530_to_ecocomDP <- function(path, parent_pkg_id, child_pkg_id){
  
  message(paste0('Converting ', parent_pkg_id, ' to ecocomDP (', child_pkg_id, ')' ))
  
  project_name <- 'shrub_seedling_sapling'
  
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
    file = entity_info$urls[stringr::str_detect(entity_info$names, 'ShrubSeedlingSapling')], 
    header = T, 
    as.is = T
  )
  
  # Clean data ----------------------------------------------------------------
  
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
    names(data) == 'Sample.Date'
    ] <- 'observation_datetime'
  
  data$observation_datetime <- dataCleanr::iso8601_convert(
    x = data$observation_datetime,
    orders = 'mdy'
  )
  
  # location_id
  
  names(data)[
    names(data) == 'Site'
    ] <- 'location_id'
  
  # event_id
  
  data$event_id <- paste0(
    'ev_',
    seq(nrow(data))
  )
  
  # package_id
  
  data$package_id <- child_pkg_id
  
  # taxon_id
  
  names(data)[
    names(data) == 'Species'
    ] <- 'taxon_id'
  
  # Select
  
  observation <- dplyr::select(
    data,
    observation_datetime,
    event_id,
    location_id,
    taxon_id,
    Count,
    X..ha,
    package_id
  )
  
  # gather
  
  observation <- tidyr::gather(
    observation,
    'variable_name',
    'value',
    Count,
    X..ha
  )
  
  # unit
  
  observation$unit <- NA_character_
  
  observation$unit[observation$variable_name == 'Count'] <- 'dimensionless'
  
  observation$unit[observation$variable_name == 'X..ha'] <- 'numberPerHectare'
  
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
    cols = c('location_id', 'location_id')
  )

  location <- location[!stringr::str_detect(location$location_id, 'lo_2'), ]
  
  # observation table location_id
  
  observation$location_id <- location$location_id[
    match(observation$location_id, location$location_name)
  ]
  
  # Create taxon table --------------------------------------------------------
  
  taxon <- ecocomDP::make_taxon(
    taxa = unique(observation$taxon_id),
    taxon.id = unique(observation$taxon_id),
    name.type = 'scientific',
    data.sources = 3
  )
  
  # Create observation_ancillary table ----------------------------------------
  
  observation_ancillary <- dplyr::select(
    data,
    event_id,
    Method
  )
  
  # variable_name
  
  names(observation_ancillary)[
    names(observation_ancillary) == 'Method'
    ] <- 'value'
  
  # value
  
  observation_ancillary$variable_name <- 'Method'
  
  # unit
  
  observation_ancillary$unit <- NA_character_
  
  # observation_anciallary_id
  
  observation_ancillary$observation_ancillary_id <- paste0(
    'oban_',
    seq(nrow(observation_ancillary))
  )
  
  # select
  
  observation_ancillary <- dplyr::select(
    observation_ancillary,
    observation_ancillary_id,
    event_id,
    variable_name,
    value,
    unit
  )
  
  # Create dataset_summary table ----------------------------------------------
  
  message('Creating table "dataset_summary"')
  
  dataset_summary <- make_dataset_summary(
    parent.package.id = parent_pkg_id,
    child.package.id = child_pkg_id,
    sample.dates = observation$observation_datetime,
    taxon.table = taxon
  )

  # Create variable_mapping table ---------------------------------------------
  
  message('Creating table "variable_mapping"')
  
  variable_mapping <- make_variable_mapping(
    observation = observation
  )
  
  # Count
  
  use_i <- variable_mapping$variable_name == 'Count'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/individualCount'
  variable_mapping$mapped_label[use_i] <- 'individualCount'
  
  # X..ha
  
  use_i <- variable_mapping$variable_name == 'X..ha'
  variable_mapping$mapped_system[use_i] <- 'The Ecosystem Ontology'
  variable_mapping$mapped_id[use_i] <- 'http://purl.dataone.org/odo/ECSO_00001168'
  variable_mapping$mapped_label[use_i] <- 'Areal Density Measurement Type'
  
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
