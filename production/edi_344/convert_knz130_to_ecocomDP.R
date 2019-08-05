# Create ecocomDP data tables
#
# This script converts knb-lter-knz.130 to the ecocomDP.

convert_knz130_to_ecocomDP <- function(path, parent_pkg_id, child_pkg_id){
  
  message(paste0('Converting ', parent_pkg_id, ' to ecocomDP (', child_pkg_id, ')' ))
  
  project_name <- 'Konza_Prairie_fish_and_crayfish'
  
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
  
  # Align column names with EML
  
  colnames(data)[
    colnames(data) == 'dataset'
    ] <- 'datacode'
  
  # Create observation table --------------------------------------------------
  
  message('Creating table "observation"')	
  
  # event_id
  
  data$event_id <- paste0(
    'ev_',
    seq(nrow(data))
  )
  
  # observation_datetime
  
  colnames(data)[
    colnames(data) == 'Date'
    ] <- 'observation_datetime'
  
  data$observation_datetime <- dataCleanr::iso8601_convert(
    data$observation_datetime,
    orders = 'mdy'
  )
  
  # location_id
  
  data$Site <- paste0(
    'Site_',
    data$Site
  )
  
  colnames(data)[
    colnames(data) == 'Site'
    ] <- 'location_id'
  
  # package_id
  
  data$package_id <- child_pkg_id
  
  # taxon_id
  
  map_taxa <- unique.data.frame(
    data.frame(
      id = paste0('tx_', seq(unique(data$Species))),
      key = unique(data$Species),
      stringsAsFactors = F
    )
  )
  
  data$taxon_id <- map_taxa$id[
    match(data$Species, 
      map_taxa$key)
  ]
  
  # variable_name
  
  data$variable_name <- 'Count'
  
  # value
  
  colnames(data)[
    colnames(data) == 'Count'
    ] <- 'value'
  
  # unit
  
  data$unit <- 'dimensionless'
  
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
    Habitat,
    Rep,
    Length,
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
    observation_ancillary$variable_name == 'Length'
  ] <- 'millimeter'
  
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
    !stringr::str_detect(location$location_id, 'lo_2'),
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
  
  # Read taxa list from knz.87
  
  md <- EDIutils::api_read_metadata('knb-lter-knz.87.6')
  
  data_urls <- xml2::xml_text(
    xml2::xml_find_all(
      md,
      "//dataset/dataTable/physical/distribution/online/url"
    )
  )
  
  data_names <- xml2::xml_text(
    xml2::xml_find_all(
      md,
      "//dataset/dataTable/physical/objectName"
    )
  )
  
  use_i <- stringr::str_detect(data_names, '011')
  
  taxa <- read.csv(
    file = data_urls[use_i],
    as.is = T,
    header = T, 
    fill = T
  )
  
  # Get taxa names
  
  map_taxa$CommonName <- taxa$CommonName[
    match(
      map_taxa$key,
      taxa$AbName
    )
  ]
  
  map_taxa$ScienceName <- taxa$ScienceName[
    match(
      map_taxa$key,
      taxa$AbName
    )
    ]
  
  taxon <- ecocomDP::make_taxon(
    taxa = map_taxa$CommonName,
    taxon.id = map_taxa$id,
    name.type = 'common',
    data.sources = 3
  )
  
  # Common search on 'NA' returns authority information. Nothing should be 
  # returned.
  
  taxon$taxon_rank[is.na(taxon$taxon_name)] <- NA_character_
  taxon$authority_system[is.na(taxon$taxon_name)] <- NA_character_
  taxon$authority_taxon_id[is.na(taxon$taxon_name)] <- NA_character_
  
  # Create taxon_ancillary table ----------------------------------------------
  
  message('Creating table "taxon_ancillary"')
  
  # Select
  
  taxon_ancillary <-  dplyr::select(
    map_taxa,
    id,
    ScienceName
  )
  
  # taxon_id
  
  names(taxon_ancillary)[
    names(taxon_ancillary) == 'id'
    ] <- 'taxon_id'
  
  # variable_name
  
  taxon_ancillary$variable_name <- 'ScienceName'
  
  # value
  
  colnames(taxon_ancillary)[
    colnames(taxon_ancillary) == 'ScienceName'
  ] <- 'value'
  
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
  
  # Habitat
  
  use_i <- variable_mapping$variable_name == 'Habitat'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/habitat'
  variable_mapping$mapped_label[use_i] <- 'habitat'
  
  # Length
  
  use_i <- variable_mapping$variable_name == 'Length'
  variable_mapping$mapped_system[use_i] <- 'The Ecosystem Ontology'
  variable_mapping$mapped_id[use_i] <- 'http://ecoinformatics.org/oboe/oboe.1.2/oboe-characteristics.owl#Length'
  variable_mapping$mapped_label[use_i] <- 'Length'
  
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
    taxon_ancillary = taxon_ancillary,
    dataset_summary = dataset_summary,
    variable_mapping = variable_mapping
  )

}
