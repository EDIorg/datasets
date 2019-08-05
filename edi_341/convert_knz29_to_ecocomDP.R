# Create ecocomDP data tables
#
# This script converts knb-lter-knz.29 to the ecocomDP.

convert_knz29_to_ecocomDP <- function(path, parent_pkg_id, child_pkg_id){
  
  message(paste0('Converting ', parent_pkg_id, ' to ecocomDP (', child_pkg_id, ')' ))
  
  project_name <- 'grasshoppers'
  
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
  
  use_i <- stringr::str_detect(data_names, 'R021')
  
  envi <- read.csv(
    file = data_urls[use_i],
    as.is = T,
    header = T, 
    fill = T
  )
  
  use_i <- stringr::str_detect(data_names, 'R022')
  
  data <- read.csv(
    file = data_urls[use_i],
    as.is = T,
    header = T, 
    fill = T
  )
  
  use_i <- stringr::str_detect(data_names, 'R023')
  
  taxa <- read.csv(
    file = data_urls[use_i],
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
  for (i in 1:ncol(envi)){
    if (is.character(envi[ ,i])){
      envi[ ,i] <- trimws(envi[ ,i], 'both')
    }
  }
  for (i in 1:ncol(taxa)){
    if (is.character(taxa[ ,i])){
      taxa[ ,i] <- trimws(taxa[ ,i], 'both')
    }
  }
  
  # Align column names with EML
  
  colnames(data)[
    colnames(data) == 'DATACODE'
    ] <- 'DataCode'
  
  colnames(data)[
    colnames(data) == 'RECTYPE'
    ] <- 'RecType'
  
  colnames(data)[
    colnames(data) == 'RECYEAR'
    ] <- 'RecYear'
  
  colnames(data)[
    colnames(data) == 'RECMONTH'
    ] <- 'RecMonth'
  
  colnames(data)[
      colnames(data) == 'RECDAY'
    ] <- 'RecDay'
  
  colnames(data)[
    colnames(data) == 'WATERSHED'
    ] <- 'WaterShed'
  
  colnames(data)[
    colnames(data) == 'SOILTYPE'
    ] <- 'Soiltype'
  
  colnames(data)[
    colnames(data) == 'REPSITE'
    ] <- 'Repsite'
  
  colnames(data)[
    colnames(data) == 'SPCODE'
    ] <- 'Spcode'
  
  colnames(data)[
    colnames(data) == 'SPECIES'
    ] <- 'Species'
  
  colnames(data)[
    colnames(data) == 'TOTAL'
    ] <- 'Total'
  
  colnames(data)[
    colnames(data) == 'COMMENTS'
    ] <- 'Comments'
  
  colnames(taxa) <- stringr::str_to_title(colnames(taxa))
  
  colnames(taxa)[
    colnames(taxa) == 'Datacode'
    ] <- 'DataCode'
  
  colnames(taxa)[
    colnames(taxa) == 'Rectype'
    ] <- 'RecType'
  
  colnames(taxa)[
    colnames(taxa) == 'Recyear'
    ] <- 'RecYear'
  
  colnames(taxa)[
    colnames(taxa) == 'Recmonth'
    ] <- 'RecMonth'
  
  colnames(taxa)[
    colnames(taxa) == 'Recday'
    ] <- 'RecDay'
  
  colnames(taxa)[
    colnames(taxa) == 'Firstinstar'
    ] <- 'FirstInstar'
  
  colnames(taxa)[
    colnames(taxa) == 'Secthirdinstar'
    ] <- 'SecThirdInstar'
  
  colnames(taxa)[
    colnames(taxa) == 'Forthinstar'
    ] <- 'ForthInstar'
  
  colnames(taxa)[
    colnames(taxa) == 'Fifthinstar'
    ] <- 'FifthInstar'
  
  # Convert missing value codes to NA
  
  envi$Wind <- suppressWarnings(as.numeric(envi$Wind))
  
  envi$AirTemp <- suppressWarnings(as.numeric(envi$AirTemp))
  
  envi$Cloudcov <- suppressWarnings(as.numeric(envi$Cloudcov))
  
  numcols <- c('S1', 'S2', 'S3', 'S4', 'S5', 'S6', 'S7', 'S8', 'S9', 'S10', 'Total')
  for (i in 1:length(numcols)){
    data[ , numcols[i]] <- suppressWarnings(as.numeric(data[ , numcols[i]]))
  }
  
  # Coerce categorical codes of tables to those defined in EML
  
  envi$Repsite <- stringr::str_to_upper(envi$Repsite)
  data$Repsite <- stringr::str_to_upper(data$Repsite)
  taxa$Repsite <- stringr::str_to_upper(taxa$Repsite)
  
  envi$Watershed <- stringr::str_to_upper(envi$Watershed)
  data$WaterShed <- stringr::str_to_upper(data$WaterShed)
  taxa$Watershed <- stringr::str_to_upper(taxa$Watershed)
  
  # Create composite key to link tables
  
  envi$datetime <- paste0(
    envi$RecYear,
    '-',
    envi$RecMonth,
    '-',
    envi$RecDay
  )
  
  data$datetime <- paste0(
    data$RecYear,
    '-',
    data$RecMonth,
    '-',
    data$RecDay
  )
  
  taxa$datetime <- paste0(
    taxa$RecYear,
    '-',
    taxa$RecMonth,
    '-',
    taxa$RecDay
  )
  
  envi$key <- paste0(
    envi$datetime,
    envi$Watershed,
    envi$Repsite
  )
  
  data$key <- paste0(
    data$datetime,
    data$WaterShed,
    data$Repsite
  )
  
  taxa$key <- paste0(
    taxa$datetime,
    taxa$Watershed,
    taxa$Repsite
  )
  
  # Remove ancillary observations not directly linking to a primary observation
  
  use_i <- match(envi$key, data$key)
  envi <- envi[!is.na(use_i), ]
  
  use_i <- match(taxa$key, data$key)
  taxa <- taxa[!is.na(use_i), ]
  
  # Add details to locations
  
  envi$Watershed <- paste0(
    'Watershed_',
    envi$Watershed
  )
  
  data$WaterShed <- paste0(
    'Watershed_',
    data$WaterShed
  )
  
  taxa$Watershed <- paste0(
    'Watershed_',
    taxa$Watershed
  )
  
  envi$Repsite <- paste0(
    'Repsite_',
    envi$Repsite
  )
  
  data$Repsite <- paste0(
    'Repsite_',
    data$Repsite
  )
  
  taxa$Repsite <- paste0(
    'Repsite_',
    taxa$Repsite
  )
  
  # Create observation table --------------------------------------------------
  
  message('Creating table "observation"')	
  
  # event_id
  
  map_event <- data.frame(
    id = paste0('ev_', seq(length(unique(data$key)))),
    key = unique(data$key),
    stringsAsFactors = F
  )
  
  data$key <- map_event$id[
    match(
      data$key,
      map_event$key
    )
  ]
  
  envi$key <- map_event$id[
    match(
      envi$key,
      map_event$key
    )
  ]
  
  taxa$key <- map_event$id[
    match(
      taxa$key,
      map_event$key
    )
  ]
  
  colnames(data)[
    colnames(data) == 'key'
  ] <- 'event_id'
  
  colnames(envi)[
    colnames(envi) == 'key'
  ] <- 'event_id'
  
  colnames(taxa)[
    colnames(taxa) == 'key'
  ] <- 'event_id'
  
  # observation_datetime
  
  colnames(data)[
    colnames(data) == 'datetime'
  ] <- 'observation_datetime'
  
  data$observation_datetime <- dataCleanr::iso8601_convert(
    data$observation_datetime,
    orders = 'ymd'
  )
  
  colnames(envi)[
    colnames(envi) == 'datetime'
    ] <- 'observation_datetime'
  
  envi$observation_datetime <- dataCleanr::iso8601_convert(
    envi$observation_datetime,
    orders = 'ymd'
  )
  
  colnames(taxa)[
    colnames(taxa) == 'datetime'
    ] <- 'observation_datetime'
  
  taxa$observation_datetime <- dataCleanr::iso8601_convert(
    taxa$observation_datetime,
    orders = 'ymd'
  )
  
  # location_id
  
  data$location_id <- paste0(
    data$WaterShed,
    '_',
    data$Repsite
  )

  envi$location_id <- paste0(
    envi$Watershed,
    '_',
    envi$Rectype
  )
  
  taxa$location_id <- paste0(
    taxa$Watershed,
    '_',
    taxa$Rectype
  )
  
  # package_id
  
  data$package_id <- child_pkg_id
  
  # taxon_id

  map_taxa <- unique.data.frame(
    data.frame(
      id = NA_character_,
      key = data$Spcode,
      name = data$Species,
      stringsAsFactors = F
    )
  )
  
  map_taxa$id <- paste0(
    'tx_',
    seq(nrow(map_taxa))
  )
  
  map_taxa$name_clean <- taxonomyCleanr::trim_taxa(
    x = stringr::str_to_sentence(
      map_taxa$name
    )
  )

  data$taxon_id <- map_taxa$id[
    match(data$Species, 
      map_taxa$name)
  ]
  
  taxa$taxon_id <- map_taxa$id[
    match(taxa$Species, 
          map_taxa$name)
  ]
  
  # variable_name
  
  data$variable_name <- 'Count'
  
  # value
  
  colnames(data)[
    colnames(data) == 'Total'
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
  
  # Join
  
  envitaxa <- dplyr::full_join(
    envi,
    taxa,
    by = 'event_id'
  )
  
  envidatataxa <- dplyr::full_join(
    envitaxa,
    data,
    by = 'event_id'
  )

  # Select
  
  observation_ancillary <- dplyr::select(
    envidatataxa,
    event_id,
    Soiltype.y,
    Comments.y,
    RecTime,
    Wind,
    AirTemp,
    Relhum,
    Cloudcov,
    FirstInstar,
    SecThirdInstar,
    ForthInstar,
    FifthInstar,
    Female,
    Male,
    Comments.x
  )
  
  # Rename columns
  
  colnames(observation_ancillary)[
    colnames(observation_ancillary) == 'Soiltype.y'
  ] <- 'Soiltype'
  
  colnames(observation_ancillary)[
    colnames(observation_ancillary) == 'Comments.y'
    ] <- 'Comments_about_individuals'
  
  colnames(observation_ancillary)[
    colnames(observation_ancillary) == 'Comments.x'
    ] <- 'Comments_about_instars'
  
  # Gather
  
  observation_ancillary <- tidyr::gather(
    observation_ancillary,
    'variable_name',
    'value',
    -event_id
  )
  
  observation_ancillary <- observation_ancillary[!is.na(observation_ancillary$value), ]
  
  # observation_ancillary_id
  
  observation_ancillary$observation_ancillary_id <- paste0(
    'oban_',
    seq(nrow(observation_ancillary))
  )
  
  # unit
  
  observation_ancillary$unit <- NA_character_
  
  observation_ancillary$unit[
    observation_ancillary$variable_name == 'Wind'
  ] <- 'dimensionless'
  
  observation_ancillary$unit[
    observation_ancillary$variable_name == 'AirTemp'
    ] <- 'dimensionless'
  
  observation_ancillary$unit[
    observation_ancillary$variable_name == 'Cloudcov'
    ] <- 'dimensionless'
  
  observation_ancillary$unit[
    observation_ancillary$variable_name == 'FirstInstar'
    ] <- 'number'
  
  observation_ancillary$unit[
    observation_ancillary$variable_name == 'SecThirdInstar'
    ] <- 'number'
  
  observation_ancillary$unit[
    observation_ancillary$variable_name == 'ForthInstar'
    ] <- 'number'
  
  observation_ancillary$unit[
    observation_ancillary$variable_name == 'FifthInstar'
    ] <- 'number'
  
  observation_ancillary$unit[
    observation_ancillary$variable_name == 'Female'
    ] <- 'number'
  
  observation_ancillary$unit[
    observation_ancillary$variable_name == 'Male'
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
    cols = c('WaterShed', 'Repsite', 'location_id')
  )
  
  # location_id (observation)
  
  observation$location_id <- location$location_id[
    match(
      observation$location_id,
      location$location_name)
  ]
  
  # Create taxon table --------------------------------------------------------
  
  message('Creating table "taxon"')
  
  # Get taxa names
  
  taxon <- ecocomDP::make_taxon(
    taxa = map_taxa$name_clean,
    taxon.id = map_taxa$id,
    name.type = 'scientific',
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
    observation = observation,
    observation_ancillary = observation_ancillary
  )
  
  # Count
  
  use_i <- variable_mapping$variable_name == 'Count'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/individualCount'
  variable_mapping$mapped_label[use_i] <- 'individualCount'
  
  # Comments_about_individuals
  
  use_i <- variable_mapping$variable_name == 'Comments_about_individuals'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/eventRemarks'
  variable_mapping$mapped_label[use_i] <- 'eventRemarks'
  
  # Comments_about_instars
  
  use_i <- variable_mapping$variable_name == 'Comments_about_instars'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/eventRemarks'
  variable_mapping$mapped_label[use_i] <- 'eventRemarks'
  
  # RecTime
  
  use_i <- variable_mapping$variable_name == 'RecTime'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/eventTime'
  variable_mapping$mapped_label[use_i] <- 'eventTime'
  
  # Wind
  
  use_i <- variable_mapping$variable_name == 'Wind'
  variable_mapping$mapped_system[use_i] <- 'The Ecosystem Ontology'
  variable_mapping$mapped_id[use_i] <- 'http://purl.dataone.org/odo/ECSO_00001233'
  variable_mapping$mapped_label[use_i] <- 'Wind Speed'
  
  # AirTemp
  
  use_i <- variable_mapping$variable_name == 'AirTemp'
  variable_mapping$mapped_system[use_i] <- 'The Ecosystem Ontology'
  variable_mapping$mapped_id[use_i] <- 'http://purl.dataone.org/odo/ECSO_00001225'
  variable_mapping$mapped_label[use_i] <- 'Air Temperature'
  
  # FirstInstar
  
  use_i <- variable_mapping$variable_name == 'FirstInstar'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/lifeStage'
  variable_mapping$mapped_label[use_i] <- 'lifeStage'
  
  # SecThirdInstar
  
  use_i <- variable_mapping$variable_name == 'SecThirdInstar'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/lifeStage'
  variable_mapping$mapped_label[use_i] <- 'lifeStage'
  
  # ForthInstar
  
  use_i <- variable_mapping$variable_name == 'ForthInstar'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/lifeStage'
  variable_mapping$mapped_label[use_i] <- 'lifeStage'
  
  # FifthInstar
  
  use_i <- variable_mapping$variable_name == 'FifthInstar'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/lifeStage'
  variable_mapping$mapped_label[use_i] <- 'lifeStage'
  
  # Female
  
  use_i <- variable_mapping$variable_name == 'Female'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/iri/sex'
  variable_mapping$mapped_label[use_i] <- 'sex'
  
  # Male
  
  use_i <- variable_mapping$variable_name == 'Male'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/iri/sex'
  variable_mapping$mapped_label[use_i] <- 'sex'
  
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
