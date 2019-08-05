# Create ecocomDP data tables
#
# This script converts knb-lter-knz.88 to the ecocomDP.
#
# NOTE: Summary information is being discarded for the time being. Only data of 
# higher granularity will be added to the ecocomDP version of this dataset.

convert_knz88_to_ecocomDP <- function(path, parent_pkg_id, child_pkg_id){
  
  message(paste0('Converting ', parent_pkg_id, ' to ecocomDP (', child_pkg_id, ')' ))
  
  project_name <- 'small_mammals'
  
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
  
  use_i <- stringr::str_detect(data_names, '012')
  
  data <- read.csv(
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
  
  # Create observation table --------------------------------------------------
  
  message('Creating table "observation"')	
  
  # event_id
  
  data$event_id <- paste0(
    'ev_',
    seq(nrow(data))
  )
  
  # observation_datetime
  
  data$observation_datetime <- paste0(
    data$Recyear,
    '-',
    data$RecMonth,
    '-',
    data$Recday
  )
  
  data$observation_datetime <- dataCleanr::iso8601_convert(
    data$observation_datetime,
    orders = 'ymd'
  )
  
  # location_id
  
  data$Watershed <- stringr::str_to_upper(data$Watershed)
  
  data$Line <- stringr::str_to_upper(data$Line)
  
  data$location_id <- paste0(
    data$Watershed,
    '_',
    data$Line,
    '_',
    data$Sta
  )
  
  # package_id
  
  data$package_id <- child_pkg_id
  
  # taxon_id
  
  data$Species <- stringr::str_to_title(data$Species)
  
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
  
  message('Creating table "observation_ancillary"')
  
  # Select
  
  observation_ancillary <- dplyr::select(
    data,
    event_id,
    DataCode,
    RecType,
    Season,
    TrapDay,
    Sex,
    Age,
    Preg,
    Cond,
    Mass,
    Status,
    ToeClip,
    HairClip,
    REarTag,
    LEarTag,
    TailLength,
    HindFoot,
    comments,
    TakenBy
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
    observation_ancillary$variable_name == 'Mass'
  ] <- 'gram'
  
  observation_ancillary$unit[
    observation_ancillary$variable_name == 'TailLength'
    ] <- 'millimeter'
  
  observation_ancillary$unit[
    observation_ancillary$variable_name == 'HindFoot'
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
    cols = c('Watershed', 'Line', 'Sta', 'location_id')
  )
  
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
  
  # Manually populate species names
  
  map_taxa$name <- NA_character_
  
  map_taxa$name[map_taxa$key == 'Rmeg'] <- 'Reithrodontomys megalotis'
  map_taxa$name[map_taxa$key == 'Sh'] <- 'Sigmodon hispidus'
  map_taxa$name[map_taxa$key == 'Bh'] <- 'Blarina hylophaga'
  map_taxa$name[map_taxa$key == 'Rmon'] <- 'Reithrodontomys montanus'
  map_taxa$name[map_taxa$key == 'St'] <- 'Spermophilus tridecemlineatus'
  map_taxa$name[map_taxa$key == 'Mo'] <- 'Microtus ochrogaster'
  map_taxa$name[map_taxa$key == 'Pl'] <- 'Peromyscus leucopus'
  map_taxa$name[map_taxa$key == 'Ch'] <- 'Chaetodipus hispidus'
  map_taxa$name[map_taxa$key == 'Mm'] <- 'Mus musculus'
  map_taxa$name[map_taxa$key == 'Nf'] <- 'Neotoma floridana'
  map_taxa$name[map_taxa$key == 'Sc'] <- 'Synaptomys cooperi'
  map_taxa$name[map_taxa$key == 'Zh'] <- 'Zapus hudsonius'
  map_taxa$name[map_taxa$key == 'Cp'] <- 'Cryptotis parva'
  map_taxa$name[map_taxa$key == 'Mp'] <- 'Microtus pinetorum'
  map_taxa$name[map_taxa$key == 'Pm'] <- 'Peromyscus maniculatus'
  
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
  
  # Count
  
  use_i <- variable_mapping$variable_name == 'Count'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/individualCount'
  variable_mapping$mapped_label[use_i] <- 'individualCount'
  
  # Sex
  
  use_i <- variable_mapping$variable_name == 'Sex'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/iri/sex'
  variable_mapping$mapped_label[use_i] <- 'sex'
  
  # Preg
  
  use_i <- variable_mapping$variable_name == 'Preg'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/reproductiveCondition'
  variable_mapping$mapped_label[use_i] <- 'reproductiveCondition'
  
  # Mass
  
  use_i <- variable_mapping$variable_name == 'Mass'
  variable_mapping$mapped_system[use_i] <- 'The Ecosystem Ontology'
  variable_mapping$mapped_id[use_i] <- 'http://purl.obolibrary.org/obo/UO_0000002'
  variable_mapping$mapped_label[use_i] <- 'mass unit'
  
  # Comments
  
  use_i <- variable_mapping$variable_name == 'comments'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/eventRemarks'
  variable_mapping$mapped_label[use_i] <- 'eventRemarks'
  
  # TakenBy
  
  use_i <- variable_mapping$variable_name == 'TakenBy'
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
