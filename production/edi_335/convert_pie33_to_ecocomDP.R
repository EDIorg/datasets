# Create ecocomDP data tables
#
# This script converts knb-lter-pie.33 to the ecocomDP.

convert_pie33_to_ecocomDP <- function(path, parent_pkg_id, child_pkg_id){
  
  message(paste0('Converting ', parent_pkg_id, ' to ecocomDP (', child_pkg_id, ')' ))
  
  project_name <- 'spartina_biomass'
  
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
  
  data <- read.csv(
    file = data_urls,
    as.is = T,
    header = T, 
    fill = T
  )
  
  # Clean data ----------------------------------------------------------------
  
  # Trim white space
  
  for (i in 1:ncol(data)){
    if (is.character(data[ ,i])){
      data[ ,i] <- trimws(data[ ,i], 'both')
    }
  }
  
  # Add location details
  
  data$PLOT <- paste0(
    'PLOT_',
    data$PLOT
  )
  
  # Create observation table --------------------------------------------------
  
  message('Creating table "observation"')	
  
  # event_id
  
  data$event_id <- paste0(
    'ev_',
    seq(nrow(data))
  )
  
  # observation_datetime
  
  data$observation_datetime <- paste0(
    data$YEAR,
    '-',
    data$MONTH,
    '-',
    data$DAY
  )
  
  data$observation_datetime <- dataCleanr::iso8601_convert(
    data$observation_datetime,
    orders = 'ymd'
  )
  
  # location_id
  
  names(data)[
    names(data) == 'PLOT'
    ] <- 'location_id'
  
  # package_id
  
  data$package_id <- child_pkg_id
  
  # Select
  
  observation <- dplyr::select(
    data,
    location_id,
    SP.biomass,
    DS.biomass,
    SE.biomass,
    SA.biomass,
    event_id,
    observation_datetime,
    package_id
  )
  
  # Gather
  
  observation <- tidyr::gather(
    observation,
    'variable_name',
    'value',
    SP.biomass,
    DS.biomass,
    SA.biomass,
    SE.biomass
  )
  
  # taxon_id
  
  observation$taxon_id <- observation$variable_name
  
  map_taxa <- data.frame(
    id = paste0('tx_', seq(length(unique(observation$taxon_id)))),
    key = unique(observation$taxon_id),
    stringsAsFactors = F
  )
  
  # variable_name
  
  observation$variable_name <- 'biomass'

  # unit
  
  observation$unit <- 'gramPerMeterSquared'
  
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
  
  # Create observation_ancillary ----------------------------------------------
  
  message('Creating table "observation_ancillary"')
  
  # Select
  
  observation_ancillary <- dplyr::select(
    data,
    event_id,
    LIVE.biomass,
    DEAD.biomass
  )
  
  # Gather
  
  observation_ancillary <- tidyr::gather(
    observation_ancillary,
    'variable_name',
    'value',
    -event_id
  )
  
  # observation_ancillary_id
  
  observation_ancillary$observation_ancillary_id <- paste0(
    'oban_',
    seq(nrow(observation_ancillary))
  )
  
  # unit
  
  observation_ancillary$unit <- 'gramPerMeterSquared'
  
  # Select
  
  observation_ancillary <- dplyr::select(
    observation_ancillary,
    observation_ancillary_id,
    event_id,
    variable_name,
    value,
    unit
  )
  
  # Create location table -----------------------------------------------------
  
  message('Creating table "location"')
  
  # Make location table
  
  location <- ecocomDP::make_location(
    x = observation,
    cols = c('location_id', 'location_id')
  )
  
  location <- location[
    !stringr::str_detect(location$location_id, 'lo_2'),
  ]
  
  # Update location_id (observation)
  
  observation$location_id <- location$location_id[
    match(
      observation$location_id,
      location$location_name)
  ]
  
  # Update location_id (data)
  
  data$location_id <- location$location_id[
    match(
      data$location_id,
      location$location_name)
    ]
  
  # Create location_ancillary table -------------------------------------------
  
  message('Creating table "location"')
  
  # Select

  location_ancillary <- dplyr::select(
    data,
    location_id,
    TRT
  )
  
  # location_ancillary_id
  
  location_ancillary$location_ancillary_id <- paste0(
    'loan_',
    seq(nrow(location_ancillary))
  )
  
  # variable_name
  
  location_ancillary$variable_name <- 'TRT'
  
  # value
  
  names(location_ancillary)[
    names(location_ancillary) == 'TRT'
    ] <- 'value'
  
  # Select
  
  location_ancillary <- dplyr::select(
    location_ancillary,
    location_ancillary_id,
    location_id,
    variable_name,
    value
  )
  
  # Create taxon table --------------------------------------------------------
  
  message('Creating table "taxon"')
  
  # Manually define species names
  
  map_taxa$names <- NA_character_
  map_taxa$names[map_taxa$key == 'SP.biomass'] <- 'Spartina patens'
  map_taxa$names[map_taxa$key == 'DS.biomass'] <- 'Distichlis spicata'
  map_taxa$names[map_taxa$key == 'SA.biomass'] <- 'Spartina alterniflora'
  map_taxa$names[map_taxa$key == 'SE.biomass'] <- 'Salicornia europa'
  
  # Get taxa names
  
  taxon <- ecocomDP::make_taxon(
    taxa = map_taxa$names,
    taxon.id = map_taxa$id,
    name.type = 'scientific',
    data.sources = 3
  )
  
  # taxon_id (observation)
  
  observation$taxon_id <- map_taxa$id[
    match(
      observation$taxon_id,
      map_taxa$key
    )
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
  
  # biomass
  
  use_i <- variable_mapping$variable_name == 'biomass'
  variable_mapping$mapped_system[use_i] <- 'The Ecosystem Ontology'
  variable_mapping$mapped_id[use_i] <- 'http://purl.dataone.org/odo/ECSO_00001135'
  variable_mapping$mapped_label[use_i] <- 'Aboveground Biomass'
  
  # LIVE.biomass
  
  use_i <- variable_mapping$variable_name == 'LIVE.biomass'
  variable_mapping$mapped_system[use_i] <- 'The Ecosystem Ontology'
  variable_mapping$mapped_id[use_i] <- 'http://purl.dataone.org/odo/ECSO_00001135'
  variable_mapping$mapped_label[use_i] <- 'Aboveground Biomass'
  
  # DEAD.biomass
  
  use_i <- variable_mapping$variable_name == 'DEAD.biomass'
  variable_mapping$mapped_system[use_i] <- 'The Ecosystem Ontology'
  variable_mapping$mapped_id[use_i] <- 'http://purl.dataone.org/odo/ECSO_00001135'
  variable_mapping$mapped_label[use_i] <- 'Aboveground Biomass'
  
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
