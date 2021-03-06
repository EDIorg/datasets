# Create ecocomDP data tables
#
# This script converts knb-lter-vcr.67 to the ecocomDP.

convert_vcr67_to_ecocomDP <- function(path, parent_pkg_id, child_pkg_id){
  
  message(paste0('Converting ', parent_pkg_id, ' to ecocomDP (', child_pkg_id, ')' ))
  
  project_name <- 'Powdermill_mammals'
  
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
    skip = 21,
    as.is = T,
    header = F, 
    fill = T
  )
  
  colnames(data) <- c(
    'ID',
    'NEW',
    'SPECIES',
    'PERIOD',
    'TIME',
    'DATE',
    'QUADR',
    'SEX',
    'NO',
    'WEIGHT',
    'OT',
    'SC',
    'IN',
    'PR',
    'OP',
    'LG'
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
  
  # observation_datetime
  
  colnames(data)[
    colnames(data) == 'DATE'
    ] <- 'observation_datetime'
  
  data$observation_datetime <- dataCleanr::iso8601_convert(
    data$observation_datetime,
    orders = 'ymd'
  )
  
  # location_id
  
  colnames(data)[
    colnames(data) == 'QUADR'
    ] <- 'location_id'
  
  # event_id
  
  data$event_id <- paste0(
    'ev_',
    seq(nrow(data))
  )
  
  # package_id
  
  data$package_id <- child_pkg_id
  
  # taxon_id
  
  map_taxa <- data.frame(
    id = paste0('tx_', seq(unique(data$SPECIES))),
    key = unique(data$SPECIES),
    stringsAsFactors = F
  )
  
  data$taxon_id <- map_taxa$id[
    match(data$SPECIES, 
      map_taxa$key)
  ]
  
  # variable_name
  
  data$variable_name <- 'Count'
  
  # value
  
  data$value <- 1
  
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
    data,
    event_id,
    ID,
    NEW,
    PERIOD,
    TIME,
    SEX,
    NO,
    WEIGHT,
    OT,
    SC,
    IN,
    PR,
    OP,
    LG
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
    observation_ancillary$variable_name == 'WEIGHT'
  ] <- 'gram'
  
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
  
  # Create taxon table --------------------------------------------------------
  
  message('Creating table "taxon"')
  
  # Converte taxa codes to names
  
  codes <- xml2::xml_text(
    xml2::xml_find_all(
      metadata,
      "//dataset/dataTable/attributeList/attribute/measurementScale/nominal/nonNumericDomain/enumeratedDomain/codeDefinition/code"
    )
  )
  
  defs <- xml2::xml_text(
    xml2::xml_find_all(
      metadata,
      "//dataset/dataTable/attributeList/attribute/measurementScale/nominal/nonNumericDomain/enumeratedDomain/codeDefinition/definition"
    )
  )
  
  map_taxa$name <- defs[
    match(
      map_taxa$key,
      codes
    )
  ]
  
  # Get taxa names
  
  taxon <- ecocomDP::make_taxon(
    taxa = map_taxa$name,
    taxon.id = map_taxa$id,
    name.type = 'scientific',
    data.sources = 3
  )
  
  taxon$taxon_name[
    is.na(taxon$taxon_name)
  ] <- map_taxa$key[is.na(taxon$taxon_name)]
  
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
  
  # ID
  
  use_i <- variable_mapping$variable_name == 'ID'
  variable_mapping$mapped_system[use_i] <- 'The Ecosystem Ontology'
  variable_mapping$mapped_id[use_i] <- 'http://purl.dataone.org/odo/ECSO_00001217'
  variable_mapping$mapped_label[use_i] <- 'Tag Number'
  
  # NEW
  
  use_i <- variable_mapping$variable_name == 'NEW'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/eventRemarks'
  variable_mapping$mapped_label[use_i] <- 'eventRemarks'
  
  # TIME
  
  use_i <- variable_mapping$variable_name == 'TIME'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/eventTime'
  variable_mapping$mapped_label[use_i] <- 'eventTime'
  
  # SEX
  
  use_i <- variable_mapping$variable_name == 'SEX'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/iri/sex'
  variable_mapping$mapped_label[use_i] <- 'sex'
  
  # WEIGHT
  
  use_i <- variable_mapping$variable_name == 'WEIGHT'
  variable_mapping$mapped_system[use_i] <- 'The Ecosystem Ontology'
  variable_mapping$mapped_id[use_i] <- 'http://purl.obolibrary.org/obo/UO_0000002'
  variable_mapping$mapped_label[use_i] <- 'mass unit'
  
  # SC
  
  use_i <- variable_mapping$variable_name == 'SC'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/reproductiveCondition'
  variable_mapping$mapped_label[use_i] <- 'reproductiveCondition'
  
  # PR
  
  use_i <- variable_mapping$variable_name == 'PR'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/reproductiveCondition'
  variable_mapping$mapped_label[use_i] <- 'reproductiveCondition'
  
  # OP
  
  use_i <- variable_mapping$variable_name == 'OP'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/reproductiveCondition'
  variable_mapping$mapped_label[use_i] <- 'reproductiveCondition'
  
  # LG
  
  use_i <- variable_mapping$variable_name == 'LG'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/reproductiveCondition'
  variable_mapping$mapped_label[use_i] <- 'reproductiveCondition'
  
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
