# Create ecocomDP data tables
#
# This script converts knb-lter-bes.543.x to the ecocomDP.

convert_sbc50_to_ecocomDP <- function(path, parent_pkg_id, child_pkg_id){
  
  message(paste0('Converting ', parent_pkg_id, ' to ecocomDP (', child_pkg_id, ')' ))
  
  project_name <- 'all_species_biomass'
  
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
  
  data <- read.csv(file = data_urls, header = T, as.is = T)
  
  # Create observation table --------------------------------------------------
  
  message('Creating table "observation"')	
  
  # observation_datetime
  
  names(data)[
    names(data) == 'DATE'
    ] <- 'observation_datetime'
  
  # event_id
  
  data$event_id <- paste0(
    data$observation_datetime,
    '_',
    data$SITE
  )
  
  event_id_map <- data.frame(
    key = unique(data$event_id),
    id = paste0('ev_', seq(length(unique(data$event_id)))),
    stringsAsFactors = F
  )
  
  data$event_id <- event_id_map$id[match(data$event_id, event_id_map$key)]
  
  # package_id
  
  data$package_id <- child_pkg_id
  
  # location_id
  
  data$location_id <- paste0(
    trimws(data$SITE, 'both'),
    '_',
    as.character(data$TRANSECT)
  )
  
  # taxon_id
  # Create taxon_id for these data, since referential integrity is not valid 
  # in this dataset
  
  data$SCIENTIFIC_NAME <- trimws(data$SCIENTIFIC_NAME, 'both')
  
  taxon_id_map <- data.frame(
    key = unique(data$SCIENTIFIC_NAME),
    id = paste0('tx_', seq(length(unique(data$SCIENTIFIC_NAME)))),
    stringsAsFactors = F
  )
  
  data$taxon_id <- taxon_id_map$id[
    match(data$SCIENTIFIC_NAME, taxon_id_map$key)
  ]
  
  # Gather
  
  observation <- dplyr::select(
    data,
    observation_datetime,
    location_id,
    taxon_id,
    PERCENT_COVER,
    DENSITY,
    WM_GM2,
    DRY_GM2,
    SFDM,
    AFDM,
    event_id,
    package_id
  )
  
  observation <- tidyr::gather(
    observation,
    'variable_name',
    'value',
    PERCENT_COVER,
    DENSITY,
    WM_GM2,
    DRY_GM2,
    SFDM,
    AFDM
  )
  
  # Convert missing value code -99999 to NA
  
  observation$value[observation$value < 0] <- NA
  
  # unit
  
  observation$unit <- NA_character_
  
  observation$unit[observation$variable_name == 'PERCENT_COVER'] <- 'percent'
  
  observation$unit[observation$variable_name == 'DENSITY'] <- 'numberPerMeterSquared'
  
  observation$unit[observation$variable_name == 'WM_GM2'] <- 'gramPerMeterSquared'
  
  observation$unit[observation$variable_name == 'DM_GM2'] <- 'gramPerMeterSquared'
  
  observation$unit[observation$variable_name == 'SFDM'] <- 'gramPerMeterSquared'
  
  observation$unit[observation$variable_name == 'AFDM'] <- 'gramPerMeterSquared'
  
  # observation_id
  
  observation$observation_id <- paste0(
    'ob_',
    seq(nrow(observation))
  )
  
  # Select
  
  observation <- select(
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
    cols = c('SITE', 'location_id')
  )

  # Update observation table --------------------------------------------------
  
  # location_id
  
  observation$location_id <- location$location_id[
    match(observation$location_id, location$location_name)
  ]
  
  # Create taxon table --------------------------------------------------------
  
  taxon <- ecocomDP::make_taxon(
    taxa = taxon_id_map$key,
    taxon.id = taxon_id_map$id,
    name.type = 'scientific',
    data.sources = c(3, 9)
  )
  
  # Create taxon_ancillary table ----------------------------------------------
  
  message('Creating table "taxon_ancillary"')
  
  # Select
  
  taxon_ancillary <- unique.data.frame(
    select(
      data,
      taxon_id,
      COMMON_NAME,
      GROUP,
      MOBILITY,
      GROWTH_MORPH,
      COARSE_GROUPING
    )
  )
  
  taxon_ancillary <- taxon_ancillary[!duplicated(taxon_ancillary$taxon_id), ]
  
  # Convert missing value -99999 to NA
  
  taxon_ancillary$COMMON_NAME[taxon_ancillary$COMMON_NAME == '-99999'] <- NA_character_
  
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
  
  dataset_summary <- make_dataset_summary(
    parent.package.id = parent_pkg_id,
    child.package.id = child_pkg_id,
    sample.dates = observation$observation_datetime,
    taxon.table = taxon
  )
  
  # Create variable_mapping table ---------------------------------------------
  
  message('Creating table "variable_mapping"')
  
  variable_mapping <- make_variable_mapping(
    observation = observation,
    taxon_ancillary = taxon_ancillary
  )
  
  # define PERCENT_COVER
  
  use_i <- variable_mapping$variable_name == 'PERCENT_COVER'
  variable_mapping$mapped_system[use_i] <- 'The Ecosystem Ontology'
  variable_mapping$mapped_id[use_i] <- 'http://purl.dataone.org/odo/ECSO_00001197'
  variable_mapping$mapped_label[use_i] <- 'Plant Cover Percentage'
  
  # define DENSITY
  
  use_i <- variable_mapping$variable_name == 'DENSITY'
  variable_mapping$mapped_system[use_i] <- 'The Ecosystem Ontology'
  variable_mapping$mapped_id[use_i] <- 'http://purl.dataone.org/odo/ECSO_00001168'
  variable_mapping$mapped_label[use_i] <- 'Areal Density Measurement Type'

  # define WM_GM2
  
  # use_i <- variable_mapping$variable_name == 'WM_GM2'
  # variable_mapping$mapped_system[use_i] <- ''
  # variable_mapping$mapped_id[use_i] <- ''
  # variable_mapping$mapped_label[use_i] <- ''

  # define DRY_GM2
  
  # use_i <- variable_mapping$variable_name == 'DRY_GM2'
  # variable_mapping$mapped_system[use_i] <- ''
  # variable_mapping$mapped_id[use_i] <- ''
  # variable_mapping$mapped_label[use_i] <- ''

  # # SFDM
  # 
  # use_i <- variable_mapping$variable_name == 'SFDM'
  # variable_mapping$mapped_system[use_i] <- ''
  # variable_mapping$mapped_id[use_i] <- ''
  # variable_mapping$mapped_label[use_i] <- ''
  
  # # AFDM
  # 
  # use_i <- variable_mapping$variable_name == 'AFDM'
  # variable_mapping$mapped_system[use_i] <- ''
  # variable_mapping$mapped_id[use_i] <- ''
  # variable_mapping$mapped_label[use_i] <- ''
  
  # # GROUP
  # 
  # use_i <- variable_mapping$variable_name == 'GROUP'
  # variable_mapping$mapped_system[use_i] <- ''
  # variable_mapping$mapped_id[use_i] <- ''
  # variable_mapping$mapped_label[use_i] <- ''
  
  # # MOBILITY
  # 
  # use_i <- variable_mapping$variable_name == 'MOBILITY'
  # variable_mapping$mapped_system[use_i] <- ''
  # variable_mapping$mapped_id[use_i] <- ''
  # variable_mapping$mapped_label[use_i] <- ''
  
  # # GROWTH_MORPH
  # 
  # use_i <- variable_mapping$variable_name == 'GROWTH_MORPH'
  # variable_mapping$mapped_system[use_i] <- ''
  # variable_mapping$mapped_id[use_i] <- ''
  # variable_mapping$mapped_label[use_i] <- ''
  
  # # COARSE_GROUPING
  # 
  # use_i <- variable_mapping$variable_name == 'COARSE_GROUPING'
  # variable_mapping$mapped_system[use_i] <- ''
  # variable_mapping$mapped_id[use_i] <- ''
  # variable_mapping$mapped_label[use_i] <- ''
  
  # Write tables to file ------------------------------------------------------
  
  ecocomDP::write_ecocomDP_tables(
    path = path,
    sep = ',',
    study.name = project_name,
    observation = observation,
    location = location,
    taxon = taxon,
    dataset_summary = dataset_summary,
    taxon_ancillary = taxon_ancillary,
    variable_mapping = variable_mapping
  )

}
