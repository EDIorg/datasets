# Create ecocomDP data tables
#
# This script converts knb-lter-pie.175 to the ecocomDP.

convert_pie405_to_ecocomDP <- function(path, parent_pkg_id, child_pkg_id){
  
  message(paste0('Converting ', parent_pkg_id, ' to ecocomDP (', child_pkg_id, ')' ))
  
  project_name <- 'zooplankton_survey'
  
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
    names(data) == 'DATE'
    ] <- 'observation_datetime'
  
  data$observation_datetime <- dataCleanr::iso8601_convert(
    data$observation_datetime,
    orders = 'dby'
  )
  
  # location_id
  
  data$location_id <- paste0(
    data$STATION.NAME.KM,
    '_',
    data$SITE
  )
  
  # package_id
  
  data$package_id <- child_pkg_id
  
  # taxon_id
  
  map_taxa <- data.frame(
    id = NA_character_,
    key = unique(data$TAXON),
    stringsAsFactors = F
  )
  
  map_taxa$id <- paste0(
    'tx_',
    seq(nrow(map_taxa))
  )
  
  data$taxon_id <- map_taxa$id[
    match(
      data$TAXON, 
      map_taxa$key)
  ]
  
  map_taxa$name <- NA_character_
  
  map_taxa$name <- stringr::str_remove_all(
    map_taxa$key,
    '[:space:]*\\([:alnum:]*\\)$'
  )
  
  map_taxa$name <- stringr::str_remove_all(
    map_taxa$name,
    '[:space:]*copepodite'
  )
  
  map_taxa$name <- taxonomyCleanr::trim_taxa(
    x = map_taxa$name
  )
  
  # variable_name
  
  data$variable_name <- 'ABUNDANCE'
  
  # value
  
  names(data)[
    names(data) == 'ABUNDANCE'
    ] <- 'value'
  
  # unit
  
  data$unit <- 'numberPerMeterCubed'
  
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
  
  message('Creating table "observation_ancillary"')
  
  # Select
  
  observation_ancillary <- dplyr::select(
    data,
    event_id,
    LAT,
    LON,
    SAMPLE.NAME,
    TIME,
    TEMP,
    SAL,
    COND,
    COUNT.START,
    COUNT.END,
    COUNT.DIFF,
    TOW.TIME,
    VOLUME,
    SIZE.FRACTION,
    SUBSAMPLE.FRAC,
    NUMBER.COUNTED,
    NUMBERperTOW
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
    observation_ancillary$variable_name == 'LAT'
  ] <- 'degree'
  
  observation_ancillary$unit[
    observation_ancillary$variable_name == 'LON'
    ] <- 'degree'
  
  observation_ancillary$unit[
    observation_ancillary$variable_name == 'TEMP'
    ] <- 'celsius'
  
  observation_ancillary$unit[
    observation_ancillary$variable_name == 'SAL'
    ] <- 'partPerThousand'
  
  observation_ancillary$unit[
    observation_ancillary$variable_name == 'COND'
    ] <- 'millisiemenPerCentimeter'
  
  observation_ancillary$unit[
    observation_ancillary$variable_name == 'COUNT.START'
    ] <- 'number'
  
  observation_ancillary$unit[
    observation_ancillary$variable_name == 'COUNT.END'
    ] <- 'number'
  
  observation_ancillary$unit[
    observation_ancillary$variable_name == 'COUNT.DIFF'
    ] <- 'number'
  
  observation_ancillary$unit[
    observation_ancillary$variable_name == 'TOW.TIME'
    ] <- 'second'
  
  observation_ancillary$unit[
    observation_ancillary$variable_name == 'VOLUME'
    ] <- 'liter'
  
  observation_ancillary$unit[
    observation_ancillary$variable_name == 'SUBSAMPLE.FRAC'
    ] <- 'dimensionless'
  
  observation_ancillary$unit[
    observation_ancillary$variable_name == 'NUMBER.COUNTED'
    ] <- 'number'
  
  observation_ancillary$unit[
    observation_ancillary$variable_name == 'NUMBERperTOW'
    ] <- 'number'
  
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
    cols = c('STATION.ID', 'SITE', 'location_id')
  )
  
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
  
  # Create location_ancillary table -------------------------------------------
  
  message('Creating table "location_ancillary"')
  
  # Select
  
  location_ancillary <- unique.data.frame(
    dplyr::select(
      data,
      location_id,
      STATION.NAME.KM,
      DIST
    )
  )
  
  # Gather
  
  location_ancillary <- tidyr::gather(
    location_ancillary,
    'variable_name',
    'value',
    -location_id
  )
  
  # unit
  
  location_ancillary$unit <- NA_character_
  
  location_ancillary$unit[
    location_ancillary$variable_name == 'DIST'
  ] <- 'degree'
  
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
  
  message('Creating table "taxon"')
  
  # Get taxa names
  
  taxon <- ecocomDP::make_taxon(
    taxa = map_taxa$name,
    taxon.id = map_taxa$id,
    name.type = 'scientific',
    data.sources = c(3,9)
  )
  
  # Create taxon ancillary table ----------------------------------------------
  
  message('Creating table "taxon_ancillary"')
  
  # Select
  
  taxon_ancillary <- unique.data.frame(
    dplyr::select(
      data,
      taxon_id,
      TAXON
    )
  )
  
  # taxon_ancillary_id
  
  taxon_ancillary$taxon_ancillary_id <- paste0(
    'txan_',
    seq(nrow(taxon_ancillary))
  )
  
  # variable_name
  
  taxon_ancillary$variable_name <- 'TAXON'
  
  # value
  
  names(taxon_ancillary)[
    names(taxon_ancillary) == 'TAXON'
    ] <- 'value'
  
  # Select
  
  taxon_ancillary <- dplyr::select(
    taxon_ancillary,
    taxon_ancillary_id,
    taxon_id,
    variable_name,
    value
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
    observation_ancillary = observation_ancillary,
    location_ancillary = location_ancillary,
    taxon_ancillary = taxon_ancillary
  )
  
  # ABUNDANCE
  
  use_i <- variable_mapping$variable_name == 'ABUNDANCE'
  variable_mapping$mapped_system[use_i] <- 'The Ecosystem Ontology'
  variable_mapping$mapped_id[use_i] <- 'http://purl.dataone.org/odo/ECSO_00001200'
  variable_mapping$mapped_label[use_i] <- 'Biomass Volumetric Density'
  
  # LAT
  
  use_i <- variable_mapping$variable_name == 'LAT'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/decimalLatitude'
  variable_mapping$mapped_label[use_i] <- 'decimalLatitude'
  
  # LON
  
  use_i <- variable_mapping$variable_name == 'LON'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/decimalLongitude'
  variable_mapping$mapped_label[use_i] <- 'decimalLongitude'
  
  # TIME
  
  use_i <- variable_mapping$variable_name == 'TIME'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/eventTime'
  variable_mapping$mapped_label[use_i] <- 'eventTime'
  
  # TEMP
  
  use_i <- variable_mapping$variable_name == 'TEMP'
  variable_mapping$mapped_system[use_i] <- 'The Ecosystem Ontology'
  variable_mapping$mapped_id[use_i] <- 'http://purl.dataone.org/odo/ECSO_00001227'
  variable_mapping$mapped_label[use_i] <- 'Water Temperature'
  
  # SAL
  
  use_i <- variable_mapping$variable_name == 'SAL'
  variable_mapping$mapped_system[use_i] <- 'The Ecosystem Ontology'
  variable_mapping$mapped_id[use_i] <- 'http://purl.dataone.org/odo/ECSO_00001164'
  variable_mapping$mapped_label[use_i] <- 'Water Salinity'
  
  # COND
  
  use_i <- variable_mapping$variable_name == 'COND'
  variable_mapping$mapped_system[use_i] <- 'The Ecosystem Ontology'
  variable_mapping$mapped_id[use_i] <- 'http://ecoinformatics.org/oboe/oboe.1.2/oboe-characteristics.owl#Conductivity'
  variable_mapping$mapped_label[use_i] <- 'Conductivity'
  
  # TOW.TIME
  
  use_i <- variable_mapping$variable_name == 'TOW.TIME'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/eventTime'
  variable_mapping$mapped_label[use_i] <- 'eventTime'
  
  # NUMBER.COUNTED
  
  use_i <- variable_mapping$variable_name == 'NUMBER.COUNTED'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/individualCount'
  variable_mapping$mapped_label[use_i] <- 'individualCount'
  
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
    taxon_ancillary = taxon_ancillary,
    dataset_summary = dataset_summary,
    variable_mapping = variable_mapping
  )

}
