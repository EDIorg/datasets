# Create ecocomDP data tables
#
# This script converts knb-lter-sgs.520 to the ecocomDP.

convert_sgs520_to_ecocomDP <- function(path, parent_pkg_id, child_pkg_id){
  
  message(paste0('Converting ', parent_pkg_id, ' to ecocomDP (', child_pkg_id, ')' ))
  
  project_name <- 'vegitation_stress'
  
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
  
  # Add location details
  
  data$TREATMENT <- paste0(
    'TREATMENT_',
    data$TREATMENT
  )
  
  data$REPLICATE <- paste0(
    'REPLICATE_',
    data$REPLICATE
  )
  
  data$TRANSECT <- paste0(
    'TRANSECT_',
    data$TRANSECT
  )
  
  data$PLOT <- paste0(
    'PLOT_',
    data$PLOT
  )
  
  # Create observation table --------------------------------------------------
  
  message('Creating table "observation"')	
  
  # event_id
  
  data$event_id <- paste0(
    'ev_',
    seq(length(nrow(data)))
  )
  
  # observation_datetime
  
  names(data)[
    names(data) == 'YEAR'
    ] <- 'observation_datetime'
  
  # location_id
  
  data$location_id <- paste0(
    data$TREATMENT,
    '_',
    data$REPLICATE,
    '_',
    data$TRANSECT,
    '_',
    data$PLOT
  )
  
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
  
  # Gather
  
  data <- tidyr::gather(
    data,
    'variable_name',
    'value',
    NUMBER_TOTAL_PER_PLOT
  )
  
  # unit
  
  data$unit <- 'numberPerMeterSquared'
  
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
  
  # Create location table -----------------------------------------------------
  
  message('Creating table "location"')
  
  # Make location table
  
  location <- ecocomDP::make_location(
    x = data,
    cols = c('TREATMENT', 'REPLICATE', 'TRANSECT', 'PLOT', 'location_id')
  )
  
  observation$location_id <- location$location_id[
    match(
      observation$location_id,
      location$location_name)
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
    observation = observation
  )
  
  # NUMBER_TOTAL_PER_PLOT
  
  use_i <- variable_mapping$variable_name == 'NUMBER_TOTAL_PER_PLOT'
  variable_mapping$mapped_system[use_i] <- 'The Ecosystem Ontology'
  variable_mapping$mapped_id[use_i] <- 'http://purl.dataone.org/odo/ECSO_00001160'
  variable_mapping$mapped_label[use_i] <- 'Count Density'
  
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
