# Create ecocomDP data tables
#
# This script converts knb-lter-knz.26 to the ecocomDP.

convert_knz26_to_ecocomDP <- function(path, parent_pkg_id, child_pkg_id){
  
  message(paste0('Converting ', parent_pkg_id, ' to ecocomDP (', child_pkg_id, ')' ))
  
  project_name <- 'Konza_Prairie_bird_survey'
  
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
  
  # Align column names with EML
  
  colnames(data) <- c(
    'DataCode',
    'RecType',
    'RecYear',
    'RecMonth',
    'RecDay',
    'Season',
    'Transnum',
    'Watershed',
    'Obsnum',
    'Specname',
    'AOUcode',
    'Common.name',
    'Distance',
    'Count',
    'Sex',
    'Status',
    'Comments',
    'Time',
    'Duration',
    'Observer'
  )
  
  # Trim white space
  
  for (i in 1:ncol(data)){
    if (is.character(data[ ,i])){
      data[ ,i] <- trimws(data[ ,i], 'both')
    }
  }
  
  # Standardize missing value codes to NA
  
  data$Distance[data$Distance == 'NULL'] <- NA
  data$Comments[data$Comments == 'NULL'] <- NA
  
  
  # Create observation table --------------------------------------------------
  
  message('Creating table "observation"')	
  
  # event_id
  
  data$event_id <- paste0(
    'ev_',
    seq(nrow(data))
  )
  
  # observation_datetime
  
  data$observation_datetime <- paste0(
    data$RecYear,
    '-',
    data$RecMonth,
    '-',
    data$RecDay
  )
  
  data$observation_datetime <- dataCleanr::iso8601_convert(
    data$observation_datetime,
    orders = 'ymd'
  )
  
  # location_id
  
  data$Transnum <- paste0(
    'Transnum_',
    data$Transnum
  )
  
  data$Watershed <- paste0(
    'Watershed_',
    data$Watershed
  )
  
  data$location_id <- paste0(
    data$Transnum,
    '_',
    data$Watershed
  )
  
  # package_id
  
  data$package_id <- child_pkg_id
  
  # taxon_id
  
  map_taxa <- unique.data.frame(
    data.frame(
      id = NA_character_,
      specname = data$Specname,
      aoucode = data$AOUcode,
      commname = data$Common.name,
      stringsAsFactors = F
    )
  )
  
  map_taxa$id <- paste0(
    'tx_',
    seq(nrow(map_taxa))
  )
  
  data$taxon_id <- map_taxa$id[
    match(
      data$Specname, 
      map_taxa$specname)
  ]
  
  # variable_name
  
  data$variable_name <- 'Count'
  
  # value
  
  names(data)[
    names(data) == 'Count'
    ] <- 'value'
  
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
  
  # Create observation_ancillary ----------------------------------------------
  
  message('Creating table "observation_ancillary"')
  
  # Select
  
  observation_ancillary <- dplyr::select(
    data,
    event_id,
    DataCode,
    RecType,
    Season,
    Obsnum,
    Distance,
    Sex,
    Status,
    Comments,
    Time,
    Duration,
    Observer
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
    observation_ancillary$variable_name == 'Distance'
  ] <- 'dimensionless'
  
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
    cols = c('Transnum', 'Watershed', 'location_id')
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
  
  # Create taxon table --------------------------------------------------------
  
  message('Creating table "taxon"')
  
  # Get taxa names
  
  map_taxa$commname <- taxonomyCleanr::trim_taxa(
    x = map_taxa$commname
  )
  
  taxon <- ecocomDP::make_taxon(
    taxa = map_taxa$commname,
    taxon.id = map_taxa$id,
    name.type = 'common',
    data.sources = 3
  )
  
  # Create taxon_ancillary table ----------------------------------------------
  
  message('Creating table "taxon_ancillary"')
  
  # Select
  
  taxon_ancillary <-  dplyr::select(
    map_taxa,
    id,
    commname,
    specname,
    aoucode
  )
  
  colnames(taxon_ancillary)[
    colnames(taxon_ancillary) == 'commname'
  ] <- 'Common name'
  
  colnames(taxon_ancillary)[
    colnames(taxon_ancillary) == 'specname'
    ] <- 'Specname'
  
  colnames(taxon_ancillary)[
    colnames(taxon_ancillary) == 'aoucode'
    ] <- 'AOUcode'
  
  # Gather
  
  taxon_ancillary <- tidyr::gather(
    taxon_ancillary,
    'variable_name',
    'value',
    -id
  )
  
  names(taxon_ancillary)[
    names(taxon_ancillary) == 'id'
    ] <- 'taxon_id'
  
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
  
  # Count
  
  use_i <- variable_mapping$variable_name == 'Count'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/individualCount'
  variable_mapping$mapped_label[use_i] <- 'individualCount'
  
  # Sex
  
  use_i <- variable_mapping$variable_name == 'Sex'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/iri/sex'
  variable_mapping$mapped_label[use_i] <- 'sex'
  
  # Time
  
  use_i <- variable_mapping$variable_name == 'Time'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/eventTime'
  variable_mapping$mapped_label[use_i] <- 'eventTime'
  
  # Observer
  
  use_i <- variable_mapping$variable_name == 'Observer'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/recordedBy'
  variable_mapping$mapped_label[use_i] <- 'recordedBy'
  
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
