# Create ecocomDP data package
#
# This script converts knb-lter-cdr.386.x to the ecocomDP.

# Arguments:
# path = Directory in which the ecocomDP tables will be written
# parent_pkg_id = The parent (level-0) package ID from the EDI Data Repository
#                 (e.g. knb-lter-cdr.386.x)
# child_pkg_id = The child (edi.124.x)

path <- 'C:\\Users\\Colin\\Downloads\\edi_124'
parent_pkg_id <- 'knb-lter-cdr.386.8'
child_pkg_id <- 'edi.124.4'

convert_bnz501_to_ecocomDP <- function(path, parent_pkg_id, child_pkg_id){

  message(paste0('Converting ', parent_pkg_id, ' to ecocomDP (', child_pkg_id, ')' ))
  
  project_name <- "plant_biomass_biodiversity_and_climate"
  
  # Load libraries --------------------------------------------------------------
  
  library(XML)
  library(EDIutils)
  library(taxonomyCleanr)
  library(stringr)
  library(dataCleanr)
  library(tidyr)
  
  # Read EML and extract required elements --------------------------------------
  
  # All EML
  
  metadata <- EDIutils::pkg_eml(parent_pkg_id)
  
  # Table names
  
  entity_names <- unlist(
    xmlApply(metadata["//dataset/dataTable/entityName"], 
             xmlValue)
  )
  
  # Table delimiters
  
  entity_delimiters <- unlist(
    xmlApply(metadata["//dataset/dataTable/physical/dataFormat/textFormat/simpleDelimited/fieldDelimiter"], 
             xmlValue)
  )
  
  # Table URLs
  
  entity_urls <- unlist(
    xmlApply(metadata["//dataset/dataTable/physical/distribution/online/url"], 
             xmlValue)
  )
  
  # Bounding coordinates
  
  west <- as.numeric(
    unlist(
      xmlApply(metadata["//dataset/coverage/geographicCoverage/boundingCoordinates/westBoundingCoordinate"], 
               xmlValue)
    )
  )
  east <- as.numeric(
    unlist(
      xmlApply(metadata["//dataset/coverage/geographicCoverage/boundingCoordinates/eastBoundingCoordinate"], 
               xmlValue)
    )
  )
  north <- as.numeric(
    unlist(
      xmlApply(metadata["//dataset/coverage/geographicCoverage/boundingCoordinates/northBoundingCoordinate"], 
               xmlValue)
    )
  )
  south <- as.numeric(
    unlist(
      xmlApply(metadata["//dataset/coverage/geographicCoverage/boundingCoordinates/southBoundingCoordinate"], 
               xmlValue)
    )
  )
  
  # Read data into a list with table names as attributes ------------------------
  
  data <- read.table(
    sub("^https", "http", entity_urls),
    header = T, 
    sep="\t",
    as.is = T,
    fill = T
  )
  
  # Create observation table --------------------------------------------------
  
  # observation_id
  
  data$observation_id <- paste0(
    'ob_',
    seq(nrow(data))
  )
  
  # observation_datetime
  
  names(data)[names(data) == 'Sample.Date'] <- 'observation_datetime'
  
  data$observation_datetime <- dataCleanr::iso8601_char(
    x = data$observation_datetime,
    orders = 'mdy_HM'
  )
  
  # event_id
  
  event_id_map <- data.frame(
    datetime = unique(data$observation_datetime),
    key = paste0('ev_', seq(length(unique(data$observation_datetime)))),
    stringsAsFactors = F
  )
  
  data$event_id <- event_id_map$key[
    match(
      data$observation_datetime, 
      event_id_map$datetime
    )
  ]
  
  # package_id
  
  data$package_id <- child_pkg_id
  
  # location_id
  
  data$Plot <- trimws(data$Plot, which = 'both')
  data$Heat.Treatment <- trimws(data$Heat.Treatment, which = 'both')
  
  data$location_id <- paste0(
    data$Plot,
    '_', 
    data$Heat.Treatment
  )
  
  # taxon_id
  
  map_taxon <- data.frame(
    id = paste0('tx_', seq(length(unique(data$Species)))),
    taxa = unique(data$Species),
    stringsAsFactors = F
  )
  
  data$taxon_id <- map_taxon$id[match(data$Species, map_taxon$taxa)]
  
  # Gather
  
  observation <- tidyr::gather(data, 'variable_name', 'value', Mass..g.m2.)
  
  # unit
  
  observation$unit <- 'gramsPerSquareMeter'
  
  # Select columns
  
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
  
  # Make taxon table ------------------------------------------------------------
  
  # Resolve taxa
  
  taxa_resolved <- taxonomyCleanr::resolve_sci_taxa(
    data.sources = c(3, 11), 
    x = map_taxon$taxa
  )
  
  # Initialize storage
  
  use_i <- match(taxa_resolved$taxa, map_taxon$taxa)
  
  taxon <- data.frame(
    taxon_id = map_taxon$id,
    taxon_rank = taxa_resolved$rank[use_i],
    taxon_name = taxa_resolved$taxa[use_i],
    authority_system = taxa_resolved$authority[use_i],
    authority_taxon_id = taxa_resolved$authority_id[use_i],
    stringsAsFactors = F
  )
  
  # Make location table -------------------------------------------------------
  
  location <- ecocomDP::make_location(
    x = data,
    cols = c(
      'Plot',
      'Heat.Treatment'
    )
  )
  
  # Update observation table
  
  observation$location_id <- location$location_id[match(observation$location_id, location$location_name)]
  
  # Make location_ancillary ---------------------------------------------------
  
  # Build location_ancillary around treatments
  
  use_i <- stringr::str_detect(location$location_name, '_')
  
  location_ancillary <- data.frame(
    location_ancillary_id = paste0('loan_', seq(sum(use_i))),
    location_id = location$location_id[use_i],
    datetime = rep(NA_character_, sum(use_i)),
    variable_name = rep(NA_character_, sum(use_i)),
    value = rep(NA_character_, sum(use_i)),
    unit = rep(NA_character_, sum(use_i)),
    stringsAsFactors = F
  )
  
  # variable_name
  
  location_ancillary$variable_name <- 'treatment'
  
  # value
  
  nms <- location$location_name[use_i]
  
  location_ancillary$value[stringr::str_detect(nms, '_C')] <- 'Control'
  
  location_ancillary$value[stringr::str_detect(nms, '_L')] <- 'Low'
  
  location_ancillary$value[stringr::str_detect(nms, '_H')] <- 'High'
  
  
  
  # Make dataset_summary table --------------------------------------------------
  
  dataset_summary <- ecocomDP::make_dataset_summary(
    parent.package.id = parent_pkg_id,
    child.package.id = child_pkg_id,
    sample.dates = observation$observation_datetime, 
    taxon.table = taxon
  )
  
  # Create variable mapping table ---------------------------------------------
  
  message('Creating table "variable_mapping"')	
  
  variable_mapping <- make_variable_mapping(
    observation = observation,
    location_ancillary = location_ancillary
  )
  
  # Define 'Mass..g.m2.'
  use_i <- variable_mapping$variable_name == 'Mass..g.m2.'
  variable_mapping$mapped_system[use_i] <- 'BioPortal'
  variable_mapping$mapped_id[use_i] <- 'http://purl.dataone.org/odo/ECSO_00000513'
  variable_mapping$mapped_label[use_i] <- 'Biomass Measurement Type'
  # Define 'treatment'
  use_i <- variable_mapping$variable_name == 'treatment'
  variable_mapping$mapped_system[use_i] <- 'BioPortal'
  variable_mapping$mapped_id[use_i] <- 'http://purl.dataone.org/odo/ECSO_00000506'
  variable_mapping$mapped_label[use_i] <- 'Manipulative experiment'
  
  # Write tables to file --------------------------------------------------------
  
  # taxon
  
  write.table(
    taxon,
    file = paste0(
      path,
      "/",
      project_name,
      "_taxon.txt"
    ),
    col.names = T,
    row.names = F,
    sep = "\t",
    quote = F
  )
  
  
  # location
  
  write.table(
    location,
    file = paste0(
      path,
      "/",
      project_name,
      "_location.txt"
    ),
    col.names = T,
    row.names = F,
    sep = "\t",
    quote = F
  )
  
  # location_ancillary
  
  write.table(
    location_ancillary,
    file = paste0(
      path,
      "/",
      project_name,
      "_location_ancillary.txt"
    ),
    col.names = T,
    row.names = F,
    sep = "\t",
    quote = F
  )

  # dataset_summary

  write.table(
    dataset_summary,
    file = paste0(
      path,
      "/",
      project_name,
      "_dataset_summary.txt"
    ),
    col.names = T,
    row.names = F,
    sep = "\t",
    quote = F
  )

  # observation
  
  write.table(
    observation,
    file = paste0(
      path,
      "/",
      project_name,
      "_observation.txt"
    ),
    col.names = T,
    row.names = F,
    sep = "\t",
    quote = F
  )
  
  # variable_mapping
  
  write.table(
    variable_mapping,
    file = paste0(
      path,
      "/",
      project_name,
      "_variable_mapping.txt"
    ),
    col.names = T,
    row.names = F,
    sep = "\t",
    quote = F
  )

}

