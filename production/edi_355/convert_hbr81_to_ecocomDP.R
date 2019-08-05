# Create ecocomDP data tables
#
# This script converts knb-lter-hbr.81 to the ecocomDP.

convert_hbr81_to_ecocomDP <- function(path, parent_pkg_id, child_pkg_id){
  
  message(paste0('Converting ', parent_pkg_id, ' to ecocomDP (', child_pkg_id, ')' ))
  
  project_name <- 'bird_abundances'
  
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
  
  hb <- read.csv(
    file = data_urls[stringr::str_detect(data_names, 'hb_')],
    as.is = T,
    header = T, 
    fill = T
  )
  
  mk <- read.csv(
    file = data_urls[stringr::str_detect(data_names, 'mk_')],
    as.is = T,
    header = T, 
    fill = T
  )
  
  rp <- read.csv(
    file = data_urls[stringr::str_detect(data_names, 'rp_')],
    as.is = T,
    header = T, 
    fill = T
  )
  
  sm <- read.csv(
    file = data_urls[stringr::str_detect(data_names, 'sm_')],
    as.is = T,
    header = T, 
    fill = T
  )
  
  # Create observation table --------------------------------------------------
  
  message('Creating table "observation"')	
  
  # Gather
  
  hb <- tidyr::gather(
    hb,
    'variable_name',
    'value',
    -Bird.Species
  )
  
  mk <- tidyr::gather(
    mk,
    'variable_name',
    'value',
    -Bird.Species
  )
  
  rp <- tidyr::gather(
    rp,
    'variable_name',
    'value',
    -Bird.Species
  )
  
  sm <- tidyr::gather(
    sm,
    'variable_name',
    'value',
    -Bird.Species
  )
  
  # observation_datetime
  
  colnames(hb)[
    colnames(hb) == 'variable_name'
    ] <- 'observation_datetime'
  
  hb$observation_datetime <- stringr::str_remove_all(
    hb$observation_datetime,
    'X'
  )
  
  colnames(mk)[
    colnames(mk) == 'variable_name'
    ] <- 'observation_datetime'
  
  mk$observation_datetime <- stringr::str_remove_all(
    mk$observation_datetime,
    'X'
  )
  
  colnames(rp)[
    colnames(rp) == 'variable_name'
    ] <- 'observation_datetime'
  
  rp$observation_datetime <- stringr::str_remove_all(
    rp$observation_datetime,
    'X'
  )
  
  colnames(sm)[
    colnames(sm) == 'variable_name'
    ] <- 'observation_datetime'
  
  sm$observation_datetime <- stringr::str_remove_all(
    sm$observation_datetime,
    'X'
  )
  
  # location_id
  
  hb$location_id <- 'hb'
  
  mk$location_id <- 'mk'
  
  rp$location_id <- 'rp'
  
  sm$location_id <- 'sm'
  
  # cbind
  
  data <- rbind(
    hb,
    mk,
    rp,
    sm
  )
  
  # event_id
  
  data$event_id <- paste0(
    'ev_',
    seq(nrow(data))
  )
  
  # package_id
  
  data$package_id <- child_pkg_id
  
  # taxon_id
  
  map_taxa <- data.frame(
    id = paste0('tx_', seq(unique(data$Bird.Species))),
    key = unique(data$Bird.Species),
    stringsAsFactors = F
  )
  
  data$taxon_id <- map_taxa$id[
    match(data$Bird.Species, 
      map_taxa$key)
  ]
  
  # variable_name
  
  data$variable_name <- 'Areal density'
  
  # unit
  
  data$unit <- 'number'
  
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
  
  # Create observation_ancillary table ----------------------------------------
  
  message('Creating table "observation_ancillary"')
  
  # Select
  
  observation_ancillary <- dplyr::select(
    observation,
    event_id,
    variable_name,
    value,
    unit
  )
  
  # Isolate data codes
  
  observation_ancillary <- observation_ancillary[
    observation_ancillary$value == 't',
  ]
  
  # variable_name
  
  observation_ancillary$variable_name <- 'data code'
  
  # value
  
  observation_ancillary$value <- 'Species present but occurring at very low numbers (<0.5 individuals/10 ha)'
  
  observation_ancillary$unit <- NULL
  
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
  
  # value (observation)
  
  observation$value <- as.numeric(
    observation$value
  )
  
  # Create location table -----------------------------------------------------
  
  message('Creating table "location"')
  
  # Make location table
  
  map_loc <- data.frame(
    id = NA_character_,
    key = c('hb', 'mk', 'rp', 'sm'),
    name = c('Hubbard Brook',
             'Moosilauke',
             'Russell Pond',
             'Stinson Mountain'),
    stringsAsFactors = F
  )
  
  map_loc$id <- paste0('lo_', seq(nrow(map_loc)))
  
  location <- ecocomDP::make_location(
    x = map_loc,
    cols = c('name', 'name')
  )
  
  location <- location[
    !stringr::str_detect(location$location_id, 'lo_2'),
  ]
  
  map_loc$id <- location$location_id
  
  # location_id (observation)
  
  observation$location_id <- map_loc$id[
    match(
      observation$location_id,
      map_loc$key)
  ]
  
  # Create taxon table --------------------------------------------------------
  
  message('Creating table "taxon"')
  
  # Get taxa names
  
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
  
  # Areal density
  
  use_i <- variable_mapping$variable_name == 'Areal density'
  variable_mapping$mapped_system[use_i] <- 'The Ecosystem Ontology'
  variable_mapping$mapped_id[use_i] <- 'http://purl.dataone.org/odo/ECSO_00001169'
  variable_mapping$mapped_label[use_i] <- 'Non-Plant Material Count Aerial Density'
  
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
