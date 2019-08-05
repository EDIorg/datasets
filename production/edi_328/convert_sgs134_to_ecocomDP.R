# Create ecocomDP data tables
#
# This script converts knb-lter-sgs.134.x to the ecocomDP.

convert_sgs134_to_ecocomDP <- function(path, parent_pkg_id, child_pkg_id){
  
  message(paste0('Converting ', parent_pkg_id, ' to ecocomDP (', child_pkg_id, ')' ))
  
  project_name <- 'arthropods'
  
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
  
  data <- read.table(
    file = data_urls,
    as.is = T,
    header = T,
    sep = '\t'
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
    seq(length(nrow(data)))
  )
  
  # Gather
  
  data <- tidyr::gather(
    data,
    'taxa',
    'count',
    -YEAR,
    -MO_OPENED,
    -DAT_OPENED,
    -MO_CLOSED,
    -DAY_CLOSED,
    -DAYS_OPENED,
    -WEB,
    -TRAP,
    -omit.trap,
    -comments,
    -event_id
  )
  
  # paste dates
  
  data$date_opened <- dataCleanr::iso8601_convert(
    paste0(
      data$YEAR,
      '-',
      data$MO_OPENED,
      '-',
      data$DAT_OPENED
    ),
    orders = 'ymd'
  )
  
  data$date_closed <- dataCleanr::iso8601_convert(
    paste0(
      data$YEAR,
      '-',
      data$MO_CLOSED,
      '-',
      data$DAY_CLOSED
    ),
    orders = 'ymd'
  )
  
  # observation_datetime
  
  data$observation_datetime <- data$date_opened
  
  # location_id
  
  data$location_id <- paste0(
    data$WEB,
    '_',
    data$TRAP
  )
  
  # package_id
  
  data$package_id <- child_pkg_id
  
  # taxon_id
  
  map_taxa <- data.frame(
    id = paste0('tx_', seq(length(unique(data$taxa)))),
    key = unique(data$taxa),
    stringsAsFactors = F
  )
  
  names(data)[
    names(data) == 'taxa'
    ] <- 'taxon_id'
  
  # variable_name
  
  data$variable_name <- 'count'
  
  # value
  
  names(data)[
    names(data) == 'count'
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
  
  message('Creating table observation_ancillary')
  
  observation_ancillary <- dplyr::select(
    data,
    omit.trap,
    comments,
    event_id,
    date_closed,
    DAYS_OPENED
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
  
  observation_ancillary$unit[observation_ancillary$variable_name == 'NO.OBSERV'] <- 'number'
  
  observation_ancillary$unit[observation_ancillary$variable_name == 'END.MILES'] <- 'mile'
  
  observation_ancillary$unit[observation_ancillary$variable_name == 'ODOM_MI'] <- 'mile'
  
  observation_ancillary$unit[observation_ancillary$variable_name == 'DISTANCE_M'] <- 'meter'
  
  observation_ancillary$unit[observation_ancillary$variable_name == 'NO.OBSERV'] <- 'number'
  
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
    cols = c('WEB', 'TRAP', 'location_id')
  )
  
  observation$location_id <- location$location_id[
    match(
      observation$location_id,
      location$location_name)
  ]
  
  # Create taxon table --------------------------------------------------------
  
  message('Creating table "taxon"')
  
  # Read species list and update map_taxa
  # Species list does not contain species codes, and therefore can't be used 
  # with this dataset.
  # Species list = https://mountainscholar.org/handle/10217/100264
  
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
    observation = observation,
    observation_ancillary = observation_ancillary
  )
  
  # count
  
  use_i <- variable_mapping$variable_name == 'count'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/individualCount'
  variable_mapping$mapped_label[use_i] <- 'individualCount'
  
  # comments
  
  use_i <- variable_mapping$variable_name == 'comments'
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
