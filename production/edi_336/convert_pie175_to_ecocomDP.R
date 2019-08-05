# Create ecocomDP data tables
#
# This script converts knb-lter-pie.175 to the ecocomDP.

convert_pie175_to_ecocomDP <- function(path, parent_pkg_id, child_pkg_id){
  
  message(paste0('Converting ', parent_pkg_id, ' to ecocomDP (', child_pkg_id, ')' ))
  
  project_name <- 'breeding_birds'
  
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
    orders = 'ymd'
  )
  
  # location_id
  
  data$location_id <- paste0(
    data$Sanc_Code,
    '_',
    data$CIRCLE
  )
  
  # package_id
  
  data$package_id <- child_pkg_id
  
  # taxon_id
  
  data$taxon_id <- paste0(
    data$Genus,
    ' ',
    data$Species
  )
  
  map_taxa <- data.frame(
    id = paste0('tx_', seq(length(unique(data$taxon_id)))),
    key = unique(data$taxon_id),
    stringsAsFactors = F
  )
  
  # Select
  
  observation <- dplyr::select(
    data,
    event_id,
    package_id,
    location_id,
    observation_datetime,
    taxon_id,
    IN_0.50m,
    IN_50.100m,
    IN_Total,
    OUT_Total,
    Flyover
  )
  
  # Gather
  
  observation <- tidyr::gather(
    observation,
    'variable_name',
    'value',
    IN_0.50m,
    IN_50.100m,
    IN_Total,
    OUT_Total,
    Flyover
  )
  
  # unit
  
  observation$unit <- 'number'
  
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
    PRIMARY_OBSERVER,
    SECONDARY_OBSERVER,
    TIME_START,
    TIME_END,
    COMMENTS
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
    cols = c('Sanc_Code', 'CIRCLE', 'location_id')
  )
  
  # Update location_id (observation)
  
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
    data.sources = 3
  )
  
  # taxon_id (observation)
  
  observation$taxon_id <- map_taxa$id[
    match(
      observation$taxon_id,
      map_taxa$key
    )
  ]
  
  # Create taxon ancillary table ----------------------------------------------
  
  message('Creating table "taxon_ancillary"')
  
  # taxon_id (data)
  
  data$taxon_id <- map_taxa$id[
    match(
      data$taxon_id,
      map_taxa$key)
  ]
  
  # Select
  
  taxon_ancillary <- unique.data.frame(
      dplyr::select(
      data,
      taxon_id,
      Alpha_Code,
      Common_Name
    )
  )
  
  # Remove duplicates
  
  taxon_ancillary <- taxon_ancillary[!duplicated(taxon_ancillary$taxon_id), ]
  
  # Gather
  
  taxon_ancillary <- tidyr::gather(
    taxon_ancillary,
    'variable_name',
    'value',
    -taxon_id
  )
  
  # taxon_ancillary_id
  
  taxon_ancillary$taxon_ancillary_id <- paste0(
    'txan_',
    seq(nrow(taxon_ancillary))
  )
  
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
    observation_ancillary = observation_ancillary
  )
  
  # IN_0.50m
  
  use_i <- variable_mapping$variable_name == 'IN_0.50m'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/individualCount'
  variable_mapping$mapped_label[use_i] <- 'individualCount'
  
  # IN_50.100m
  
  use_i <- variable_mapping$variable_name == 'IN_50.100m'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/individualCount'
  variable_mapping$mapped_label[use_i] <- 'individualCount'
  
  # IN_Total
  
  use_i <- variable_mapping$variable_name == 'IN_Total'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/individualCount'
  variable_mapping$mapped_label[use_i] <- 'individualCount'
  
  # OUT_Total
  
  use_i <- variable_mapping$variable_name == 'OUT_Total'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/individualCount'
  variable_mapping$mapped_label[use_i] <- 'individualCount'
  
  # Flyover
  
  use_i <- variable_mapping$variable_name == 'Flyover'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/individualCount'
  variable_mapping$mapped_label[use_i] <- 'individualCount'
  
  # PRIMARY_OBSERVER
  
  use_i <- variable_mapping$variable_name == 'PRIMARY_OBSERVER'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/recordedBy'
  variable_mapping$mapped_label[use_i] <- 'recordedBy'
  
  # SECONDARY_OBSERVER
  
  use_i <- variable_mapping$variable_name == 'SECONDARY_OBSERVER'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/recordedBy'
  variable_mapping$mapped_label[use_i] <- 'recordedBy'
  
  # TIME_START
  
  use_i <- variable_mapping$variable_name == 'TIME_START'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'https://dwc.tdwg.org/terms/#dwc:eventTime'
  variable_mapping$mapped_label[use_i] <- 'eventTime'
  
  # TIME_END
  
  use_i <- variable_mapping$variable_name == 'TIME_END'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'https://dwc.tdwg.org/terms/#dwc:eventTime'
  variable_mapping$mapped_label[use_i] <- 'eventTime'
  
  # COMMENTS
  
  use_i <- variable_mapping$variable_name == 'COMMENTS'
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
    taxon_ancillary = taxon_ancillary,
    dataset_summary = dataset_summary,
    variable_mapping = variable_mapping
  )

}
