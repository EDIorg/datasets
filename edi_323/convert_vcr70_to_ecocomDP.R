# Create ecocomDP data tables
#
# This script converts knb-lter-vcr.70.x to the ecocomDP.

convert_vcr70_to_ecocomDP <- function(path, parent_pkg_id, child_pkg_id){
  
  message(paste0('Converting ', parent_pkg_id, ' to ecocomDP (', child_pkg_id, ')' ))
  
  project_name <- 'dune_biomass'
  
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
    skip = 20,
    as.is = T,
    header = T
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
  
  names(data)[
    names(data) == 'ISOdate'
    ] <- 'observation_datetime'

  # location_id

  data$location_id <- paste0(
    data$SITE,
    '_',
    data$PLOT
  )
  
  # event_id
  
  data$event_id <- paste0(
    data$observation_datetime,
    data$location_id
  )
  
  event_id_map <- data.frame(
    key = unique(data$event_id),
    id = paste0('ev_', seq(length(unique(data$event_id)))),
    stringsAsFactors = F
  )
  
  data$event_id <- event_id_map$id[match(data$event_id, event_id_map$key)]
  
  # package_id
  
  data$package_id <- child_pkg_id
  
  # taxon_id
  
  names(data)[
    names(data) == 'Species'
    ] <- 'taxon_id'

  # Select
  
  observation <- dplyr::select(
    data,
    observation_datetime,
    event_id,
    location_id,
    taxon_id,
    TOTBIO,
    Biomass,
    package_id
  )
  
  # Gather
  
  observation <- tidyr::gather(
    observation,
    'variable_name',
    'value',
    TOTBIO,
    Biomass
  )
  
  # unit
  
  observation$unit <- NA_character_
  
  observation$unit[observation$variable_name == 'TOTBIO'] <- 'gram'
  
  observation$unit[observation$variable_name == 'Biomass'] <- 'gramsPer0.25MeterSquared'
  
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
  
  # Create location table -----------------------------------------------------
  
  message('Creating table "location"')
  
  # Make location table
  
  location <- ecocomDP::make_location(
    x = data,
    cols = c('SITE', 'PLOT', 'location_id')
  )

  # location_id (observation table)
  
  observation$location_id <- location$location_id[
    match(observation$location_id, location$location_name)
  ]
  
  # Create taxon table --------------------------------------------------------
  
  # Get taxa names
  
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

  taxon <- ecocomDP::make_taxon(
    taxa = defs[match(unique(observation$taxon_id), codes)],
    taxon.id = unique(observation$taxon_id),
    name.type = 'scientific',
    data.sources = 3
  )
  
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
    observation = observation
  )
  
  # TOTBIO
  
  use_i <- variable_mapping$variable_name == 'TOTBIO'
  variable_mapping$mapped_system[use_i] <- 'The Ecosystem Ontology'
  variable_mapping$mapped_id[use_i] <- 'http://purl.dataone.org/odo/ECSO_00000513'
  variable_mapping$mapped_label[use_i] <- 'Biomass Measurement Type'
  
  # Biomass
  
  use_i <- variable_mapping$variable_name == 'Biomass'
  variable_mapping$mapped_system[use_i] <- 'The Ecosystem Ontology'
  variable_mapping$mapped_id[use_i] <- 'http://purl.dataone.org/odo/ECSO_00001135'
  variable_mapping$mapped_label[use_i] <- 'Aboveground Biomass'
  
  # Write tables to file ------------------------------------------------------
  
  ecocomDP::write_ecocomDP_tables(
    path = path,
    sep = ',',
    study.name = project_name,
    observation = observation,
    location = location,
    taxon = taxon,
    dataset_summary = dataset_summary,
    variable_mapping = variable_mapping
  )

}
