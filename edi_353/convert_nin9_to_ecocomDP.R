# Create ecocomDP data tables
#
# This script converts knb-lter-nin.9 to the ecocomDP.

convert_nin9_to_ecocomDP <- function(path, parent_pkg_id, child_pkg_id){
  
  message(paste0('Converting ', parent_pkg_id, ' to ecocomDP (', child_pkg_id, ')' ))
  
  project_name <- 'macrobenthos'
  
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
  
  # Change missing value code -99 to NA
  
  use_i <- c(4:5, 11:91)
  for (i in 1:length(use_i)){
    if (is.numeric(data[ ,i])){
      use_i <- data[ ,i] < 0
      data[use_i,i] <- NA
    }
  }
  
  # Change missing value code 0 to NA
  
  use_i <- c(7:10)
  for (i in 1:length(use_i)){
    if (is.numeric(data[ ,i])){
      use_i <- data[ ,i] == 0
      data[use_i,i] <- NA
    }
  }
  
  # Create observation table --------------------------------------------------
  
  message('Creating table "observation"')	
  
  # observation_datetime
  
  colnames(data)[
    colnames(data) == 'DATE'
    ] <- 'observation_datetime'
  
  data$observation_datetime <- dataCleanr::iso8601_convert(
    data$observation_datetime,
    orders = 'mdy'
  )
  
  # event_id
  
  data$event_id <- paste0(
    'ev_',
    seq(nrow(data))
  )
  
  # location_id
  
  colnames(data)[
    colnames(data) == 'STATION'
    ] <- 'location_id'
  
  # Select
  
  observation <- dplyr::select(
    data,
    -SAMPLE,
    -SAMTIME,
    -REPLICAT,
    -TSTAGE,
    -STEMP,
    -AIRTEMP,
    -SEDWATER,
    -SSAL,
    -REDOX,
    -COREAREA,
    -COREDIAM,
    -SEDVOL,
    -COREDEPA,
    -COREDEPB,
    -COLLECT
  )
  
  # Gather
  
  observation <- tidyr::gather(
    observation,
    'variable_name',
    'value',
    -observation_datetime,
    -location_id,
    -event_id
  )
  
  # package_id
  
  observation$package_id <- child_pkg_id
  
  # taxon_id
  
  map_taxa <- data.frame(
    id = paste0('tx_', seq(unique(observation$variable_name))),
    key = unique(observation$variable_name),
    name = NA_character_,
    stringsAsFactors = F
  )
  
  attr_name <- xml2::xml_text(
    xml2::xml_find_all(
      metadata,
      "//dataset/dataTable/attributeList/attribute/attributeName"
    )
  )
  
  attr_label <- xml2::xml_text(
    xml2::xml_find_all(
      metadata,
      "//dataset/dataTable/attributeList/attribute/attributeLabel"
    )
  )
  attr_label <- trimws(attr_label, 'both')
  
  map_taxa$name <- trimws(
    attr_name[
      match(
        map_taxa$key,
        attr_label
      )
    ]
  )
  
  colnames(observation)[
    colnames(observation) == 'variable_name'
    ] <- 'taxon_id'
  
  observation$taxon_id <- map_taxa$id[
    match(observation$taxon_id, 
          map_taxa$key)
    ]
  
  # variable_name
  
  observation$variable_name <- 'Density'
  
  # unit
  
  observation$unit <- 'numberPerFiveCentimeter'
  
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
  
  # Create observation_ancillary table ----------------------------------------
  
  message('Creating table "observation_ancillary"')
  
  # Select
  
  observation_ancillary <- data[ , c(3:17, 92)]
  
  # Gather
  
  observation_ancillary <- tidyr::gather(
    observation_ancillary,
    'variable_name',
    'value',
    -event_id
  )
  
  # unit
  
  observation_ancillary$unit <- NA_character_
  
  observation_ancillary$unit[
    observation_ancillary$variable_name == 'REPLICAT'
    ] <- 'dimensionless'
  
  observation_ancillary$unit[
    observation_ancillary$variable_name == 'STEMP'
  ] <- 'celsius'
  
  observation_ancillary$unit[
    observation_ancillary$variable_name == 'AIRTEMP'
    ] <- 'celsius'
  
  observation_ancillary$unit[
    observation_ancillary$variable_name == 'SEDWATER'
    ] <- 'celsius'
  
  observation_ancillary$unit[
    observation_ancillary$variable_name == 'SSAL'
    ] <- 'partPerThousand'
  
  observation_ancillary$unit[
    observation_ancillary$variable_name == 'REDOX'
    ] <- 'centimeter'

  observation_ancillary$unit[
    observation_ancillary$variable_name == 'COREAREA'
    ] <- 'squareCentimeters'
  
  observation_ancillary$unit[
    observation_ancillary$variable_name == 'COREDIAM'
    ] <- 'centimeter'
  
  observation_ancillary$unit[
    observation_ancillary$variable_name == 'SEDVOL'
    ] <- 'centimeterCubed'
  
  observation_ancillary$unit[
    observation_ancillary$variable_name == 'COREDEPA'
    ] <- 'centimeter'
  
  observation_ancillary$unit[
    observation_ancillary$variable_name == 'COREDEPB'
    ] <- 'centimeter'
  
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
    taxa = map_taxa$name,
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
  
  # Density
  
  use_i <- variable_mapping$variable_name == 'Density'
  variable_mapping$mapped_system[use_i] <- 'The Ecosystem Ontology'
  variable_mapping$mapped_id[use_i] <- 'http://purl.dataone.org/odo/ECSO_00001201'
  variable_mapping$mapped_label[use_i] <- 'Number Volumetric Density'
  
  # SAMPLE
  
  use_i <- variable_mapping$variable_name == 'SAMPLE'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/eventTime'
  variable_mapping$mapped_label[use_i] <- 'eventTime'
  
  # SAMTIME
  
  use_i <- variable_mapping$variable_name == 'SAMTIME'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/eventTime'
  variable_mapping$mapped_label[use_i] <- 'eventTime'
  
  # TSTAGE
  
  use_i <- variable_mapping$variable_name == 'TSTAGE'
  variable_mapping$mapped_system[use_i] <- 'The Ecosystem Ontology'
  variable_mapping$mapped_id[use_i] <- 'http://purl.dataone.org/odo/ECSO_00001173'
  variable_mapping$mapped_label[use_i] <- 'Tide Height'
  
  # STEMP
  
  use_i <- variable_mapping$variable_name == 'STEMP'
  variable_mapping$mapped_system[use_i] <- 'The Ecosystem Ontology'
  variable_mapping$mapped_id[use_i] <- 'http://purl.dataone.org/odo/ECSO_00001227'
  variable_mapping$mapped_label[use_i] <- 'Water Temperature'
  
  # AIRTEMP
  
  use_i <- variable_mapping$variable_name == 'AIRTEMP'
  variable_mapping$mapped_system[use_i] <- 'The Ecosystem Ontology'
  variable_mapping$mapped_id[use_i] <- 'http://purl.dataone.org/odo/ECSO_00001225'
  variable_mapping$mapped_label[use_i] <- 'Air Temperature'
  
  # SEDWATER
  
  use_i <- variable_mapping$variable_name == 'SEDWATER'
  variable_mapping$mapped_system[use_i] <- 'The Ecosystem Ontology'
  variable_mapping$mapped_id[use_i] <- 'http://ecoinformatics.org/oboe/oboe.1.2/oboe-characteristics.owl#Temperature'
  variable_mapping$mapped_label[use_i] <- 'Temperature'
  
  # SSAL
  
  use_i <- variable_mapping$variable_name == 'SSAL'
  variable_mapping$mapped_system[use_i] <- 'The Ecosystem Ontology'
  variable_mapping$mapped_id[use_i] <- 'http://purl.dataone.org/odo/ECSO_00001164'
  variable_mapping$mapped_label[use_i] <- 'Water Salinity'
  
  # COREAREA
  
  use_i <- variable_mapping$variable_name == 'COREAREA'
  variable_mapping$mapped_system[use_i] <- 'The Ecosystem Ontology'
  variable_mapping$mapped_id[use_i] <- 'http://purl.obolibrary.org/obo/UO_0000047'
  variable_mapping$mapped_label[use_i] <- 'area unit'
  
  # COREDIAM
  
  use_i <- variable_mapping$variable_name == 'COREDIAM'
  variable_mapping$mapped_system[use_i] <- 'The Ecosystem Ontology'
  variable_mapping$mapped_id[use_i] <- 'http://purl.dataone.org/odo/ECSO_00000509'
  variable_mapping$mapped_label[use_i] <- 'diameter'
  
  # SEDVOL
  
  use_i <- variable_mapping$variable_name == 'SEDVOL'
  variable_mapping$mapped_system[use_i] <- 'The Ecosystem Ontology'
  variable_mapping$mapped_id[use_i] <- 'http://ecoinformatics.org/oboe/oboe.1.2/oboe-characteristics.owl#Volume'
  variable_mapping$mapped_label[use_i] <- 'Volume'
  
  # COREDEPA
  
  use_i <- variable_mapping$variable_name == 'COREDEPA'
  variable_mapping$mapped_system[use_i] <- 'The Ecosystem Ontology'
  variable_mapping$mapped_id[use_i] <- 'http://purl.dataone.org/odo/ECSO_00000515'
  variable_mapping$mapped_label[use_i] <- 'depth'
  
  # COREDEPB
  
  use_i <- variable_mapping$variable_name == 'COREDEPB'
  variable_mapping$mapped_system[use_i] <- 'The Ecosystem Ontology'
  variable_mapping$mapped_id[use_i] <- 'http://purl.dataone.org/odo/ECSO_00000515'
  variable_mapping$mapped_label[use_i] <- 'depth'
  
  # COLLECT
  
  use_i <- variable_mapping$variable_name == 'COLLECT'
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
    dataset_summary = dataset_summary,
    variable_mapping = variable_mapping
  )

}
