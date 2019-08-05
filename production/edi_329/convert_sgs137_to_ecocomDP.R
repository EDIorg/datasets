# Create ecocomDP data tables
#
# This script converts knb-lter-sgs.137 to the ecocomDP.

convert_sgs137_to_ecocomDP <- function(path, parent_pkg_id, child_pkg_id){
  
  message(paste0('Converting ', parent_pkg_id, ' to ecocomDP (', child_pkg_id, ')' ))
  
  project_name <- 'small_mammal_trapping'
  
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
  
  # observation_datetime
  
  data$observation_datetime <- dataCleanr::iso8601_convert(
    paste0(
      data$YEAR,
      '-',
      data$MONTH,
      '-',
      data$DAY
    ),
    orders = 'ymd'
  )
  
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
    id = paste0('tx_', seq(length(unique(data$SPP)))),
    key = unique(data$SPP),
    stringsAsFactors = F
  )
  
  names(data)[
    names(data) == 'SPP'
    ] <- 'taxon_id'
  
  # variable_name
  
  data$variable_name <- 'count'
  
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
  
  # Create observation_ancillary ----------------------------------------------
  
  message('Creating table observation_ancillary')
  
  observation_ancillary <- dplyr::select(
    data,
    event_id,
    SAMPLE,
    SESSION,
    VEG,
    NIGHT,
    CAPT,
    TAG,
    AGE,
    SEX,
    REPROD,
    WT,
    NOTES,
    Stapp.comments
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
  
  observation_ancillary$unit[observation_ancillary$variable_name == 'WT'] <- 'gram'
  
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
    cols = c('WEB', 'TRAP', 'location_id')
  )
  
  observation$location_id <- location$location_id[
    match(
      observation$location_id,
      location$location_name)
  ]
  
  # Create taxon table --------------------------------------------------------
  
  message('Creating table "taxon"')
  
  # Create species list and update map_taxa
  
  map_taxa$names <- NA_character_
  map_taxa$names[map_taxa$key == 'DIOR'] <- 'Microtus ochrogaster'
  map_taxa$names[map_taxa$key == 'ONLE'] <- 'Peromyscus maniculatus'
  map_taxa$names[map_taxa$key == 'PEMA'] <- 'Thomomys talpoides'
  map_taxa$names[map_taxa$key == 'REMO'] <- 'Reithrodontomys megalotis'
  map_taxa$names[map_taxa$key == 'REME'] <- 'Onychomys leucogaster'
  map_taxa$names[map_taxa$key == 'SPTR'] <- 'Chaetodipus hispidus'
  map_taxa$names[map_taxa$key == 'CHHI'] <- 'Dipodomys ordii'
  map_taxa$names[map_taxa$key == 'MIOC'] <- 'Reithrodontomys montanus'
  
  
  # Get taxa names
  
  taxon <- ecocomDP::make_taxon(
    taxa = map_taxa$names,
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
  
  # VEG
  
  use_i <- variable_mapping$variable_name == 'VEG'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/organismScope'
  variable_mapping$mapped_label[use_i] <- 'organismScope'
  
  # TAG
  
  use_i <- variable_mapping$variable_name == 'TAG'
  variable_mapping$mapped_system[use_i] <- 'The Ecosystem Ontology'
  variable_mapping$mapped_id[use_i] <- 'http://purl.dataone.org/odo/ECSO_00001217'
  variable_mapping$mapped_label[use_i] <- 'Tag Number'
  
  # AGE
  
  use_i <- variable_mapping$variable_name == 'AGE'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/lifeStage'
  variable_mapping$mapped_label[use_i] <- 'lifeStage'
  
  # SEX
  
  use_i <- variable_mapping$variable_name == 'SEX'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/sex'
  variable_mapping$mapped_label[use_i] <- 'sex'
  
  # REPROD
  
  use_i <- variable_mapping$variable_name == 'REPROD'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/lifeStage'
  variable_mapping$mapped_label[use_i] <- 'reproductiveCondition'
  
  # WT
  
  use_i <- variable_mapping$variable_name == 'WT'
  variable_mapping$mapped_system[use_i] <- 'The Ecosystem Ontology'
  variable_mapping$mapped_id[use_i] <- 'http://purl.obolibrary.org/obo/PATO_0000128'
  variable_mapping$mapped_label[use_i] <- 'weight'
  
  # NOTES
  
  use_i <- variable_mapping$variable_name == 'NOTES'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/eventRemarks'
  variable_mapping$mapped_label[use_i] <- 'eventRemarks'
  
  # Stapp.comments
  
  use_i <- variable_mapping$variable_name == 'Stapp.comments'
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
