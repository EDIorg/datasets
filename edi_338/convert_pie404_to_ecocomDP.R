# Create ecocomDP data tables
#
# This script converts knb-lter-pie.404 to the ecocomDP.

convert_pie404_to_ecocomDP <- function(path, parent_pkg_id, child_pkg_id){
  
  message(paste0('Converting ', parent_pkg_id, ' to ecocomDP (', child_pkg_id, ')' ))
  
  project_name <- 'phytoplankton_survey'
  
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
  
  # Create observation table --------------------------------------------------
  
  message('Creating table "observation"')	
  
  # event_id
  
  data$event_id <- paste0(
    'ev_',
    seq(nrow(data))
  )
  
  # observation_datetime
  
  names(data)[
    names(data) == 'Date'
    ] <- 'observation_datetime'
  
  data$observation_datetime <- dataCleanr::iso8601_convert(
    data$observation_datetime,
    orders = 'dby'
  )
  
  # location_id
  
  names(data)[
    names(data) == 'Site'
    ] <- 'location_id'
  
  # package_id
  
  data$package_id <- child_pkg_id
  
  # Select
  
  observation <- dplyr::select(
    data,
    event_id,
    observation_datetime,
    location_id,
    package_id,
    TotalChlA,
    DiatomsandChrysophytes,
    Cryptophytes,
    Chlorophytes,
    Dinoflagellates,
    Euglenophytes,
    Prasinophytes,
    Haptophytes,
    Prymnesiophytes,
    Cyanobacteria
  )
  
  # Gather
  
  observation <- tidyr::gather(
    observation,
    'variable_name',
    'value',
    -event_id,
    -observation_datetime,
    -location_id,
    -package_id
  )
  
  # taxon_id
  
  map_taxa <- data.frame(
    id = paste0('tx_', seq(length(unique(observation$variable_name)))),
    key = unique(observation$variable_name),
    stringsAsFactors = F
  )
  
  names(observation)[
    names(observation) == 'variable_name'
    ] <- 'taxon_id'
  
  observation$taxon_id <- map_taxa$id[
    match(
      observation$taxon_id, 
      map_taxa$key)
  ]
  
  # variable_name
  
  observation$variable_name <- 'Fraction of total chlorophyll a'
  
  # unit
  
  observation$unit <- 'microgramPerLiter'
  
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
    Latitude,
    Longitude,
    Distance,
    SampleName,
    SubsampleName,
    BottleName,
    SampleType,
    Volume,
    Temp,
    Salinity,
    Comments
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
  
  observation_ancillary$unit <- NA_character_
  
  observation_ancillary$unit[
    observation_ancillary$variable_name == 'Latitude'
  ] <- 'degree'
  
  observation_ancillary$unit[
    observation_ancillary$variable_name == 'Longitude'
    ] <- 'degree'
  
  observation_ancillary$unit[
    observation_ancillary$variable_name == 'Distance'
    ] <- 'kilometer'
  
  observation_ancillary$unit[
    observation_ancillary$variable_name == 'Volume'
    ] <- 'milliliter'
  
  observation_ancillary$unit[
    observation_ancillary$variable_name == 'Temp'
    ] <- 'celsius'
  
  observation_ancillary$unit[
    observation_ancillary$variable_name == 'Salinity'
    ] <- 'partPerThousand'
  
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
    x = data,
    cols = c('location_id', 'location_id')
  )
  
  location <- location[
    !stringr::str_detect(
      location$location_id,
      'lo_2'
    ),
  ]
  
  # location_id (observation)
  
  observation$location_id <- location$location_id[
    match(
      observation$location_id,
      location$location_name)
  ]
  
  # location_id (data)
  
  data$location_id <- location$location_id[
    match(
      data$location_id,
      location$location_name)
    ]
  
  # Create taxon table --------------------------------------------------------
  
  message('Creating table "taxon"')
  
  # Get taxa names
  
  taxon <- ecocomDP::make_taxon(
    taxa = map_taxa$key,
    taxon.id = map_taxa$id,
    name.type = 'scientific',
    data.sources = c(3,9)
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
    observation = observation,
    observation_ancillary = observation_ancillary
  )
  
  # Fraction of total chlorophyll a
  
  use_i <- variable_mapping$variable_name == 'Fraction of total chlorophyll a'
  variable_mapping$mapped_system[use_i] <- 'The Ecosystem Ontology'
  variable_mapping$mapped_id[use_i] <- 'http://purl.dataone.org/odo/ECSO_00001200'
  variable_mapping$mapped_label[use_i] <- 'Biomass Volumetric Density'
  
  # Latitude
  
  use_i <- variable_mapping$variable_name == 'Latitude'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/decimalLatitude'
  variable_mapping$mapped_label[use_i] <- 'decimalLatitude'
  
  # Longitude
  
  use_i <- variable_mapping$variable_name == 'Longitude'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/decimalLongitude'
  variable_mapping$mapped_label[use_i] <- 'decimalLongitude'
  
  # Volume
  
  use_i <- variable_mapping$variable_name == 'Volume'
  variable_mapping$mapped_system[use_i] <- 'The Ecosystem Ontology'
  variable_mapping$mapped_id[use_i] <- 'http://ecoinformatics.org/oboe/oboe.1.2/oboe-characteristics.owl#Volume'
  variable_mapping$mapped_label[use_i] <- 'Volume'
  
  # Temp
  
  use_i <- variable_mapping$variable_name == 'Temp'
  variable_mapping$mapped_system[use_i] <- 'The Ecosystem Ontology'
  variable_mapping$mapped_id[use_i] <- 'http://purl.dataone.org/odo/ECSO_00001227'
  variable_mapping$mapped_label[use_i] <- 'Water Temperature'
  
  # Salinity
  
  use_i <- variable_mapping$variable_name == 'Salinity'
  variable_mapping$mapped_system[use_i] <- 'The Ecosystem Ontology'
  variable_mapping$mapped_id[use_i] <- 'http://purl.dataone.org/odo/ECSO_00001164'
  variable_mapping$mapped_label[use_i] <- 'Water Salinity'
  
  # Comments
  
  use_i <- variable_mapping$variable_name == 'Comments'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/eventRemarks'
  variable_mapping$mapped_label[use_i] <- 'eventRemarks'
  
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
