# Create ecocomDP data tables
#
# This script converts knb-lter-bes.543.x to the ecocomDP.

convert_mcr4_to_ecocomDP <- function(path, parent_pkg_id, child_pkg_id){
  
  message(paste0('Converting ', parent_pkg_id, ' to ecocomDP (', child_pkg_id, ')' ))
  
  project_name <- 'corals'
  
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
    file = entity_info$urls[stringr::str_detect(entity_info$names, 'Long Table')], 
    header = T, 
    as.is = T
  )
  
  # Create observation table --------------------------------------------------
  
  message('Creating table "observation"')	
  
  # observation_datetime
  # Temporal resolution is YYYY-MM. Default each observation to the first day
  # of the month, and note this in the observation_ancillary table.
  
  data$Date <- paste0(
    data$Date,
    '-01'
  )
  
  data$Date <- suppressWarnings(
    dataCleanr::iso8601_convert(
      data$Date, 
      orders = 'ymd'
    )
  )
  
  names(data)[
    names(data) == 'Date'
    ] <- 'observation_datetime'
  
  # event_id
  
  data$event_id <- paste0(
    data$observation_datetime,
    trimws(data$Location, 'both')
  )
  
  event_id_map <- data.frame(
    key = unique(data$event_id),
    id = paste0('ev_', seq(length(unique(data$event_id)))),
    stringsAsFactors = F
  )
  
  data$event_id <- event_id_map$id[match(data$event_id, event_id_map$key)]
  
  # package_id
  
  data$package_id <- child_pkg_id
  
  # location_id
  # Trim white space
  # Use "unknown" for empty values
  
  data$Site <- trimws(data$Site, 'both')
  data$Habitat <- trimws(data$Habitat, 'both')
  data$Section_of_Transect <- trimws(data$Section_of_Transect, 'both')
  data$Quadrat <- trimws(data$Quadrat, 'both')
  
  data$Site[data$Site == ''] <- 'Unknown'
  data$Habitat[data$Habitat == ''] <- 'Unknown'
  data$Section_of_Transect[is.na(data$Section_of_Transect)] <- 'Unknown'
  data$Quadrat[is.na(data$Quadrat)] <- 'Unknown'
  
  data$location_id <- paste0(
    data$Site,
    '_',
    data$Habitat,
    '_',
    data$Section_of_Transect,
    '_',
    data$Quadrat
  )
  
  location_id_map <- data.frame(
    key = unique(data$location_id),
    id = paste0('lo_', seq(length(unique(data$location_id)))),
    stringsAsFactors = F
  )
  
  data$location_id <- location_id_map$id[
    match(data$location_id, location_id_map$key)
    ]
  
  # taxon_id
  # Use NA to fill empty record
  
  data$Taxonomy_Substrate_or_Functional_Group <- trimws(data$Taxonomy_Substrate_or_Functional_Group, 'both')
  
  data$Taxonomy_Substrate_or_Functional_Group[data$Taxonomy_Substrate_or_Functional_Group == ''] <- NA_character_
  
  taxon_id_map <- data.frame(
    key = unique(data$Taxonomy_Substrate_or_Functional_Group),
    id = paste0('tx_', seq(length(unique(data$Taxonomy_Substrate_or_Functional_Group)))),
    stringsAsFactors = F
  )
  
  data$taxon_id <- taxon_id_map$id[
    match(data$Taxonomy_Substrate_or_Functional_Group, taxon_id_map$key)
  ]
  
  # Gather
  
  observation <- dplyr::select(
    data,
    observation_datetime,
    location_id,
    taxon_id,
    Percent_Cover,
    event_id,
    package_id
  )
  
  # variable_name and value
  
  names(observation)[
    names(observation) == 'Percent_Cover'
    ] <- 'value'
  
  observation$variable_name <- 'Percent_Cover'
  
  # unit
  
  observation$unit <- 'dimensionless'
  
  # observation_id
  
  observation$observation_id <- paste0(
    'ob_',
    seq(nrow(observation))
  )
  
  # Select
  
  observation <- select(
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
    cols = c('Site', 'Habitat', 'Section_of_Transect', 'Quadrat')
  )

  # Update observation table --------------------------------------------------
  
  # location_id
  
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
  
  # Create observation_ancillary table ----------------------------------------
  
  message('Creating table "observation_ancillary"')
  
  # Select
  
  observation_ancillary <- unique.data.frame(
    select(
      data,
      event_id
    )
  )
  
  # observation_ancillary_id
  
  observation_ancillary$observation_ancillary_id <- paste0(
    'oban_',
    seq(nrow(observation_ancillary))
  )
  
  # variable_name
  
  observation_ancillary$variable_name <- 'actual_temporal_resolution'
  
  # value
  
  observation_ancillary$value <- 'YYYY-MM'
  
  # Select
  
  observation_ancillary <- dplyr::select(
    observation_ancillary,
    observation_ancillary_id,
    event_id,
    variable_name,
    value
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
    observation = observation,
    observation_ancillary = observation_ancillary
  )
  
  # Percent_Cover
  
  use_i <- variable_mapping$variable_name == 'Percent_Cover'
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
    observation_ancillary = observation_ancillary,
    variable_mapping = variable_mapping
  )

}
