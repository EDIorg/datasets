# Create ecocomDP data tables
#
# This script converts knb-lter-sgs.140.x to the ecocomDP.

convert_sgs140_to_ecocomDP <- function(path, parent_pkg_id, child_pkg_id){
  
  message(paste0('Converting ', parent_pkg_id, ' to ecocomDP (', child_pkg_id, ')' ))
  
  project_name <- 'veg_cover_on_trapping_webs'
  
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
  
  header_lines <- xml2::xml_text(
    xml2::xml_find_all(
      metadata,
      "//dataset/dataTable/physical/dataFormat/textFormat/numHeaderLines"
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
  
  # observation_datetime
  
  names(data)[
    names(data) == 'YEAR'
    ] <- 'observation_datetime'
  
  # location_id
  
  data$location_id <- paste0(
    data$WEB,
    '_',
    data$TRANS,
    '_',
    data$PT
  )
  
  # event_id
  
  data$event_id <- paste0('ev_', seq(nrow(data)))
  
  # package_id
  
  data$package_id <- child_pkg_id
  
  # taxon_id
  
  map_taxa <- data.frame(
    id = paste0('tx_', seq(length(unique(data$SPECIES)))),
    key = unique(data$SPECIES),
    stringsAsFactors = F
  )
  
  names(data)[
    names(data) == 'SPECIES'
    ] <- 'taxon_id'
  
  # variable_name
  
  data$variable_name <- 'PCT.COVER'
  
  # value
  
  names(data)[
    names(data) == 'PCT.COVER'
    ] <- 'value'
  
  # unit
  
  data$unit <- 'percent'
  
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
    event_id,
    RECORDER,
    Comments,
    KIND
  )
  
  # Gather
  
  observation_ancillary <- tidyr::gather(
    observation_ancillary,
    'variable_name',
    'value',
    RECORDER,
    Comments,
    KIND
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
    cols = c('WEB', 'TRANS', 'PT', 'location_id')
  )

  # location_id (observation table)
    
  observation$location_id <- location$location_id[
    match(observation$location_id, location$location_name)
  ]
  
  # Create taxon table --------------------------------------------------------
  
  message('Creating table "taxon"')
  
  # Read species list and update map_taxa
  
  taxa_list <- read.table(
    'https://mountainscholar.org/bitstream/handle/10217/80451/SGS_LTER_plants.txt?sequence=1&isAllowed=y',
    header = T,
    sep = '\t',
    as.is = T
  )
  
  for (i in 1:ncol(taxa_list)){
    if (is.character(taxa_list[ ,i])){
      taxa_list[ ,i] <- trimws(taxa_list[ ,i], 'both')
    }
  }
  
  taxa_list$LTER.SpeciesCode <- tolower(taxa_list$LTER.SpeciesCode)
  
  use_i <- match(tolower(map_taxa$key), taxa_list$LTER.SpeciesCode)
  
  taxa_list <- taxa_list[
    use_i[!is.na(use_i)], 
  ]
  
  map_taxa$index <- match(
    tolower(map_taxa$key),
    taxa_list$LTER.SpeciesCode
  )
  
  map_taxa$name <- NA_character_
  
  map_taxa$name[!is.na(map_taxa$index)] <- taxa_list$Scientific.Name[
    use_i[!is.na(use_i)]
  ]
  
  # Get taxa names
  
  taxon <- ecocomDP::make_taxon(
    taxa = map_taxa$name,
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
    sample.dates = as.character(observation$observation_datetime),
    taxon.table = taxon
  )
  
  # Create variable_mapping table ---------------------------------------------
  
  message('Creating table "variable_mapping"')
  
  variable_mapping <- ecocomDP::make_variable_mapping(
    observation = observation,
    observation_ancillary = observation_ancillary
  )
  
  # PCT.COVER
  
  use_i <- variable_mapping$variable_name == 'PCT.COVER'
  variable_mapping$mapped_system[use_i] <- 'The Ecosystem Ontology'
  variable_mapping$mapped_id[use_i] <- 'http://purl.dataone.org/odo/ECSO_00001197'
  variable_mapping$mapped_label[use_i] <- 'Plant Cover Percentage'
  
  # RECORDER
  
  use_i <- variable_mapping$variable_name == 'RECORDER'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/recordedBy'
  variable_mapping$mapped_label[use_i] <- 'recordedBy'
  
  # Comments
  
  use_i <- variable_mapping$variable_name == 'Comments'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/occurrenceRemarks'
  variable_mapping$mapped_label[use_i] <- 'occurrenceRemarks'
  
  # KIND
  
  use_i <- variable_mapping$variable_name == 'KIND'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/organismScope'
  variable_mapping$mapped_label[use_i] <- 'organismScope'
  
  
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
