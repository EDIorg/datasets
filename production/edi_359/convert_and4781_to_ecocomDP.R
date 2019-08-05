# Create ecocomDP data tables
#
# This script converts knb-lter-and.4781 to the ecocomDP.

convert_and4781_to_ecocomDP <- function(path, parent_pkg_id, child_pkg_id){
  
  message(paste0('Converting ', parent_pkg_id, ' to ecocomDP (', child_pkg_id, ')' ))
  
  project_name <- 'birds'
  
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
  
  data_tables <- xml2::xml_find_all(
    metadata,
    "//dataset/dataTable"
  )
  
  i_data <- stringr::str_detect(data_names, '2402')
  i_survey <- stringr::str_detect(data_names, '2401')
  
  survey <- read.csv(
    file = data_urls[i_survey],
    as.is = T,
    header = T, 
    fill = T
  )
  
  data <- read.csv(
    file = data_urls[i_data],
    as.is = T,
    header = T, 
    fill = T
  )
  
  # Clean data ----------------------------------------------------------------
  
  # Trim white space (data)
  
  for (i in 1:ncol(data)){
    if (is.character(data[ ,i])){
      data[ ,i] <- trimws(data[ ,i], 'both')
    }
  }
  
  # Trim white space (survey)
  
  for (i in 1:ncol(survey)){
    if (is.character(survey[ ,i])){
      survey[ ,i] <- trimws(survey[ ,i], 'both')
    }
  }
  
  # Replace categorical codes with definitions (data)
  
  attributeName_data <- xml2::xml_text(
    xml2::xml_find_all(
      data_tables[i_data],
      "//attributeList/attribute/attributeName"
    )
  )
  
  attribute_data <- xml2::xml_find_all(
    data_tables[i_data],
    "//attributeList/attribute/attributeName"
  )
  
  for (i in ncol(data)){
    
    use_i <- attributeName_data == colnames(data)[i]
    
    
  }
  
  codes_data <- xml2::xml_text(
    xml2::xml_find_all(
      data_tables[i_data],
      "//enumeratedDomain/codeDefinition/code"
    )
  )
  
  definitions_data <- xml2::xml_text(
    xml2::xml_find_all(
      data_tables[i_data],
      "//enumeratedDomain/codeDefinition/definition"
    )
  )
  
  
  
  
  
  
  data$plot <- as.character(data$plot)
  data$plot[data$plot == '1'] <- 'Hubbard Brook'
  data$plot[data$plot == '2'] <- 'Moosilauke'
  data$plot[data$plot == '3'] <- 'Russell'
  data$plot[data$plot == '4'] <- 'Stinson'
  
  data$grid.letter <- paste0(
    'grid_',
    data$grid.letter
  )
  
  data$grid.number <- paste0(
    'grid_',
    data$grid.number
  )
  
  data$tree.spec[data$tree.spec == '1'] <- 'Beech'
  data$tree.spec[data$tree.spec == '2'] <- 'Sugar maple'
  data$tree.spec[data$tree.spec == '3'] <- 'Striped maple'
  data$tree.spec[data$tree.spec == '4'] <- 'Viburnum'
  
  data$lep.species[data$lep.species == '6'] <- 'Other species'
  data$lep.species[data$lep.species == '2'] <- 'Geometrid'
  data$lep.species[data$lep.species == '3'] <- 'Noctuid'
  data$lep.species[data$lep.species == '4'] <- 'Notodontid'
  data$lep.species[data$lep.species == '5'] <- 'Pyraloid, Tortricoid, Coliophorid, Psychid'
  
  # Create observation table --------------------------------------------------
  
  message('Creating table "observation"')	
  
  # observation_datetime
  
  colnames(data)[
    colnames(data) == 'date'
  ] <- 'observation_datetime'
  
  data$observation_datetime <- dataCleanr::iso8601_convert(
    data$observation_datetime,
    orders = 'mdy'
  )
  
  # location_id
  
  data$location_id <- paste0(
    data$plot,
    '_',
    data$grid.letter,
    '_',
    data$grid.number,
    '_',
    data$tree.spec
  )
  
  # event_id
  
  data$event_id <- paste0(
    'ev_',
    seq(nrow(data))
  )

  # taxon_id
  
  colnames(data)[
    colnames(data) == 'lep.species'
  ] <- 'taxon_id'
  
  map_taxa <- data.frame(
    id = paste0('tx_', seq(unique(data$taxon_id))),
    key = unique(data$taxon_id),
    stringsAsFactors = F
  )
  
  # Select
  
  observation <- dplyr::select(
    data,
    event_id,
    taxon_id,
    location_id,
    observation_datetime,
    number.lep,
    lepbio.mass.mg.
  )
  
  # Gather
  
  observation <- tidyr::gather(
    observation,
    'variable_name',
    'value',
    number.lep,
    lepbio.mass.mg.
  )
  
  # package_id
  
  observation$package_id <- child_pkg_id
  
  # variable_name
  
  observation$variable_name[
    observation$variable_name == 'number.lep'
  ] <- 'number lep'
  
  observation$variable_name[
    observation$variable_name == 'lepbio.mass.mg.'
  ] <- 'lepbio mass(mg)'
  
  # unit
  
  observation$unit <- NA_character_
  
  observation$unit[
    observation$variable_name == 'number lep'
  ] <- 'number'
  
  observation$unit[
    observation$variable_name == 'lepbio mass(mg)'
    ] <- 'milligram'
  
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
  
  observation_ancillary <- dplyr::select(
    data,
    event_id,
    tree.rep,
    lep.length
  )
  
  # Gather
  
  observation_ancillary <- tidyr::gather(
    observation_ancillary,
    'variable_name',
    'value',
    -event_id
  )
  
  # variable_name
  
  observation_ancillary$variable_name[
    observation_ancillary$variable_name == 'tree.rep'
    ] <- 'tree rep'
  
  observation_ancillary$variable_name[
    observation_ancillary$variable_name == 'lep.length'
    ] <- 'lep length'
  
  # unit
  
  observation_ancillary$unit <- NA_character_
  
  observation_ancillary$unit[
    observation_ancillary$variable_name == 'tree rep'
  ] <- 'number'
  
  observation_ancillary$unit[
    observation_ancillary$variable_name == 'lep length'
    ] <- 'millimeter'
  
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
    x = data,
    cols = c('plot', 'grid.letter', 'grid.number', 'tree.spec', 'location_id')
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
  
  # Get taxa names
  
  taxon <- ecocomDP::make_taxon(
    taxa = map_taxa$key,
    taxon.id = map_taxa$id,
    name.type = 'scientific',
    data.sources = 3
  )
  
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
  
  # number lep
  
  use_i <- variable_mapping$variable_name == 'number lep'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'http://rs.tdwg.org/dwc/terms/individualCount'
  variable_mapping$mapped_label[use_i] <- 'individualCount'
  
  # lepbio mass(mg)
  
  use_i <- variable_mapping$variable_name == 'lepbio mass(mg)'
  variable_mapping$mapped_system[use_i] <- 'The Ecosystem Ontology'
  variable_mapping$mapped_id[use_i] <- 'http://purl.dataone.org/odo/ECSO_00000513'
  variable_mapping$mapped_label[use_i] <- 'Biomass Measurement Type'
  
  # lep length
  
  use_i <- variable_mapping$variable_name == 'lep length'
  variable_mapping$mapped_system[use_i] <- 'The Ecosystem Ontology'
  variable_mapping$mapped_id[use_i] <- 'http://ecoinformatics.org/oboe/oboe.1.2/oboe-characteristics.owl#Length'
  variable_mapping$mapped_label[use_i] <- 'Length'
  
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
