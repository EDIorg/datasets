

# Initialize workspace --------------------------------------------------------

library(XML)
library(lubridate)
library(dplyr)
library(tidyr)
library(lubridate)
library(ecocomDP)
library(readr)
library(sf)
library(stringr)
library(EDIutils)
library(taxonomyCleanr)


# Input arguments:
# data.path - Path to where the ecocomDP tables will be written
# parent.pkg.id - Parent package identifier (e.g. "knb-lter-cap.627.x")
# child.pkg.id - Child package identifier (e.g. "edi.192.x")

format_cap627_to_ecocomDP <- function(data.path, parent.pkg.id, child.pkg.id){

  # Parameterize --------------------------------------------------------------

  # Set table name prefix
  
  table_prefix <- 'herpetofauna_survey'
  
  # Validate arguments

  message('Validating arguments')

  if (missing(data.path)){
    stop('Input argument "data.path" is missing! Specify the data.path to the directory that will be filled with ecocomDP tables.')
  }
  if (missing(parent.pkg.id)){
    stop('Input argument "parent.pkg.id" is missing!')
  }
  if (missing(child.pkg.id)){
    stop('Input argument "child.pkg.id" is missing!')
  }

  EDIutils::validate_path(data.path)

  # Parse parent.pkg.id

  scope <- unlist(stringr::str_split(parent.pkg.id, '\\.'))[1]
  identifier <- unlist(stringr::str_split(parent.pkg.id, '\\.'))[2]
  revision <- unlist(stringr::str_split(parent.pkg.id, '\\.'))[3]

  # Load EML and extract elements -----------------------------------------------

  message('Loading EML of parent data package')

  # EML

  metadata <- xmlParse(paste("http://pasta.lternet.edu/package/metadata/eml",
                             "/",
                             scope,
                             "/",
                             identifier,
                             "/",
                             revision,
                             sep = ""))

  # File names

  entity_names <- unlist(
    xmlApply(metadata["//dataset/dataTable/entityName"],
             xmlValue)
  )

  entity_names[length(entity_names)+1] <- unlist(
    xmlApply(metadata["//dataset/otherEntity/entityName"],
             xmlValue)
  )

  # Table delimiters

  entity_delimiters <- unlist(
    xmlApply(metadata["//dataset/dataTable/physical/dataFormat/textFormat/simpleDelimited/fieldDelimiter"],
             xmlValue)
  )

  # File URLs

  entity_urls <- unlist(
    xmlApply(metadata["//dataset/dataTable/physical/distribution/online/url"],
             xmlValue)
  )

  entity_urls[length(entity_urls)+1] <- unlist(
    xmlApply(metadata["//dataset/otherEntity/physical/distribution/online/url"],
             xmlValue)
  )

  # Dataset title

  entity_title <- unlist(
    xmlApply(metadata["//dataset/title"],
             xmlValue)
  )

  # Geographic coverage of study

  westBoundingCoordinate <- as.numeric(
    unlist(
      xmlApply(
        metadata["//dataset/coverage/geographicCoverage/boundingCoordinates/westBoundingCoordinate"],
        xmlValue
      )
    )
  )

  eastBoundingCoordinate <- as.numeric(
    unlist(
      xmlApply(
        metadata["//dataset/coverage/geographicCoverage/boundingCoordinates/eastBoundingCoordinate"],
        xmlValue
      )
    )
  )

  southBoundingCoordinate <- as.numeric(
    unlist(
      xmlApply(
        metadata["//dataset/coverage/geographicCoverage/boundingCoordinates/southBoundingCoordinate"],
        xmlValue
      )
    )
  )

  northBoundingCoordinate <- as.numeric(
    unlist(
      xmlApply(
        metadata["//dataset/coverage/geographicCoverage/boundingCoordinates/northBoundingCoordinate"],
        xmlValue
      )
    )
  )
  
  # Read data into a list with table names as attributes ------------------------

  message(
    'Loading data'
  )

  entity_data <-  vector(mode = "list",
                         length = length(entity_names))

  for (i in 1:(length(entity_names)-1)){
    if (entity_delimiters[i] == ","){
      entity_data[[i]] <-read.table(sub("^https", "http", entity_urls[i]),
                                    header = T,
                                    sep=",",
                                    as.is = T,
                                    fill = T)
      attr(entity_data[[i]], "table_name") <- entity_names[i]
    } else if (entity_delimiters[i] == "\\t"){
      entity_data[[i]] <-read.table(sub("^https", "http", entity_urls[i]),
                                    header = T,
                                    sep="\t",
                                    as.is = T,
                                    fill = T)
      attr(entity_data[[i]], "table_name") <- entity_names[i]
    }
  }



  # Load data -------------------------------------------------------------------

  conditions <- entity_data[[1]]
  data <- entity_data[[2]]
  locations <- st_read(sub("^https", "http", entity_urls[3]))



  # Create observation table --------------------------------------------------

  message(
    'Building observation table (1 of 2)'
  )

  # Initialize observation table

  observation <- data.frame(
    observation_id = rep(NA_character_, nrow(data)),
    event_id = rep(NA_character_, nrow(data)),
    package_id = rep(NA_character_, nrow(data)),
    location_id = rep(NA_character_, nrow(data)),
    observation_datetime = rep(NA_character_, nrow(data)),
    taxon_id = rep(NA_character_, nrow(data)),
    variable_name = rep(NA_character_, nrow(data)),
    value = rep(NA, nrow(data)),
    unit = rep(NA_character_, nrow(data)),
    stringsAsFactors = FALSE)

  # Create column: observation_id

  observation$observation_id <- paste0(
    'ob_',
    seq(
      nrow(
        observation
      )
    )
  )

  # Create column: observation_datetime

  observation$observation_datetime <- EDIutils::datetime_to_iso8601(
    x = data$observation_date,
    orders = 'ymd'
  )

  # Create column: variable_name

  observation$variable_name <- rep(
    'quantity',
    nrow(
      data
    )
  )

  # Create column: value

  observation$value <- data$quantity
  
  # Create column: unit
  
  # Get units for count (a.k.a. 'quantity' in the original data table '*site_observations*)
  
  fname <- entity_names[str_detect(entity_names, 'site_observations')]
  attribute <- 'quantity'
  unit <- unlist(
    xmlApply(
      metadata[
        paste0("//dataTable[./entityName = '",
               fname,
               "']//attribute[./attributeName = '",
               attribute,
               "']//standardUnit")],
      xmlValue
    )
  )
  
  observation$unit <- rep(unit, nrow(observation))

  # Make taxon table ----------------------------------------------------------

  message(
    'Building taxon table'
  )

  # Combine common_name and scientific_name columns

  taxa_key <- select(
    data,
    common_name,
    scientific_name
  )

  taxa_key$key <- apply(
    taxa_key,
    1,
    paste,
    collapse = '_'
  )

  data$taxa_key <- taxa_key$key

  # Unique taxa

  u_tx <- unique.data.frame(
    taxa_key
  )

  # Initialize taxon table

  taxon <- data.frame(
    taxon_id = rep(NA_character_, nrow(u_tx)),
    taxon_rank = rep(NA_character_, nrow(u_tx)),
    taxon_name = rep(NA_character_, nrow(u_tx)),
    authority_system = rep(NA_character_, nrow(u_tx)),
    authority_taxon_id = rep(NA_character_, nrow(u_tx)),
    stringsAsFactors = FALSE
  )

  # Create column: taxon_id

  taxon$taxon_id <- paste0(
    'tx_',
    seq(
      nrow(
        taxon
      )
    )
  )

  # Create column: taxon_name

  taxon$taxon_name <- u_tx$scientific_name

  # Add taxon_id to observation

  use_i <- match(
    data$taxa_key,
    u_tx$key
  )

  observation$taxon_id <- taxon$taxon_id[use_i]
  
  # Trim taxa strings
  
  taxon$taxon_name <- taxonomyCleanr::trim_taxa(x = taxon$taxon_name)
  
  # Resolve taxa to authority system
  
  taxa_resolved <- taxonomyCleanr::resolve_sci_taxa(
    x = taxon$taxon_name,
    data.sources = c(3, 1)
    )
  
  # Add resolved data to taxon table
  
  taxon$taxon_rank <- taxa_resolved$rank
  taxon$authority_system <- taxa_resolved$authority
  taxon$authority_taxon_id <- taxa_resolved$authority_id

  # Make location table -------------------------------------------------------

  message(
    'Building location table'
  )

  # Create column: key
  # A key in 'data' and for identifying unique locations

  data$reach <- trimws(
    data$reach,
    which = 'both'
  )

  data$transect <- trimws(
    data$transect,
    which = 'both'
  )

  data$location <- trimws(
    data$location,
    which = 'both'
  )

  data$key_loc <- apply(
    data[ , c('reach', 'transect', 'location')],
    1,
    paste,
    collapse = "_"
  )

  # Make location table (run function)

  location_table <- make_location(
    x = data,
    cols = c(
      'reach',
      'transect',
      'location'
    )
  )

  location <- location_table

  # Create column: location_id

  # location$location_id <- paste0(
  #   'lo_',
  #   location$location_id
  # )

  # location$parent_location_id <- paste0(
  #   'lo_',
  #   location$parent_location_id
  # )

  # location$parent_location_id[location$parent_location_id == 'lo_NA'] <- NA_character_

  # Link tables: location to observation

  use_i <- match(
    data$key_loc,
    location$location_name
  )

  observation$location_id <- location$location_id[use_i]

  # # Nest spatial polygon points under 'reach'
  # # Name data is missing in the .kml of revisions >= 3. Uncomment this code when fixed.
  # 
  # use_i <- match(
  #   location$location_name,
  #   locations$Name
  # )
  # 
  # use_i <- use_i[!is.na(use_i)]
  # 
  # r <- length(
  #   unlist(
  #     locations$geometry
  #   )
  # )/2
  # 
  # location_id <- c()
  # location_name <- c()
  # latitude <- c()
  # longitude <- c()
  # elevation <- c()
  # parent_location_id <- c()
  # 
  # for (i in 1:length(use_i)){
  # 
  #   location_name <- c(
  #     location_name,
  #     paste0(
  #       as.character(locations$Name[use_i[i]]),
  #       '_outerBoundaryls_',
  #       seq(
  #         (length(unlist(locations$geometry[use_i[i]]))/2)
  #       )
  #     )
  #   )
  # 
  #   poly_coord <- unlist(
  #     locations$geometry[use_i[i]]
  #   )
  # 
  #   longitude <- c(
  #     longitude,
  #     poly_coord[1:(length(poly_coord)/2)]
  #   )
  # 
  #   latitude <- c(
  #     latitude,
  #     poly_coord[((length(poly_coord)/2)+1):length(poly_coord)]
  #   )
  # 
  #   elevation <- c(
  #     elevation,
  #     rep(
  #       NA,
  #       length(location_name)
  #     )
  #   )
  # 
  #   index <- location$location_name == as.character(locations$Name[use_i[i]])
  # 
  #   parent_location_id <- c(
  #     parent_location_id,
  #     rep(
  #       location$location_id[index],
  #       length(unlist(locations$geometry[use_i[i]]))/2
  #     )
  #   )
  # 
  # }
  # 
  # location_id <- paste0(
  #   'lo_p_',
  #   seq(
  #     length(
  #       location_name
  #     )
  #   )
  # )
  # 
  # location_poly <- data.frame(
  #   location_id,
  #   location_name,
  #   latitude,
  #   longitude,
  #   elevation,
  #   parent_location_id,
  #   stringsAsFactors = F
  # )
  # 
  # location <- rbind(
  #   location,
  #   location_poly
  # )



  # Make dataset_summary table --------------------------------------------------

  message(
    'Building dataset_summary table'
  )

  # Initialize dataset_summary table

  dataset_summary <- data.frame(
    package_id = rep(NA_character_, length(child.pkg.id)),
    original_package_id = rep(NA_character_, length(child.pkg.id)),
    length_of_survey_years = rep(NA, length(child.pkg.id)),
    number_of_years_sampled = rep(NA, length(child.pkg.id)),
    std_dev_interval_betw_years = rep(NA, length(child.pkg.id)),
    max_num_taxa = rep(NA, length(child.pkg.id)),
    geo_extent_bounding_box_m2 = rep(NA, length(child.pkg.id)),
    stringsAsFactors = FALSE
  )

  # Create column: package_id

  dataset_summary$package_id <- child.pkg.id

  # Create column: original_package_id

  dataset_summary$original_package_id <- paste(
    scope,
    identifier,
    revision,
    sep = '.'
  )

  # Create column: number_of_years_sampled
  
  dt <- EDIutils::iso8601_to_datetime(observation$observation_datetime)
  
  dt <- dt[order(dt)]
  
  dt <- dt[
    !is.na(
      dt
    )
    ]
  
  dt_int <- interval(
    dt[1],
    dt[length(dt)]
  )
  
  dataset_summary$number_of_years_sampled <- floor(
    time_length(
      dt_int,
      "year"
    )
  )
  
  # Create column: length_of_survey_years
  
  dataset_summary$length_of_survey_years <-  lubridate::time_length(interval(min(dt),max(dt)), unit = 'year')
  
  # Create column: std_dev_interval_betw_years
  
  dt_uni <- unique(dt)
  
  dt_uni <- dt_uni[order(dt_uni)]
  
  dataset_summary$std_dev_interval_betw_years <- sd(diff(dt_uni)/365)

  # Create column: max_num_taxa

  dataset_summary$max_num_taxa <- nrow(taxon)

  # Create column: geo_extent_bounding_box_m2

  # geo_extent_bounding_box_m2
  # https://stackoverflow.com/questions/27928/calculate-distance-between-two-latitude-longitude-points-haversine-formula

  getDistanceFromLatLonInKm<-function(lat1,lon1,lat2,lon2) {
    R <- 6371; # Radius of the earth in km
    dLat <- deg2rad(lat2-lat1);  # deg2rad below
    dLon = deg2rad(lon2-lon1);
    a <- sin(dLat/2) * sin(dLat/2) + cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * sin(dLon/2) * sin(dLon/2)
    c <- 2 * atan2(sqrt(a), sqrt(1-a))
    d <- R * c # Distance in km
    return(d)
  }

  deg2rad<-function(deg) {
    return(deg * (pi/180))
  }

  get_area_square_meters<-function(lon_west,lon_east,lat_north,lat_south){
    xdistN<-1000*getDistanceFromLatLonInKm(lat_north,lon_east,lat_north,lon_west)
    xdistS<-1000*getDistanceFromLatLonInKm(lat_south,lon_east,lat_south,lon_west)
    ydist<-1000*getDistanceFromLatLonInKm(lat_north,lon_east,lat_south,lon_east)
    area<-ydist*(xdistN+xdistS/2)
    return(area)
  }

  dataset_summary$geo_extent_bounding_box_m2 <- round(
    get_area_square_meters(
      westBoundingCoordinate,
      eastBoundingCoordinate,
      northBoundingCoordinate,
      southBoundingCoordinate
    )
  )

  # Update table: observation$package_id

  observation$package_id <- rep(
    dataset_summary$package_id,
    nrow(
      observation
    )
  )

  # Update observation table --------------------------------------------------

  # Create column: event_id

  event <- select(
    observation,
    location_id,
    observation_datetime
  )

  event$key <- apply(
    event,
    1,
    paste,
    collapse = '_'
  )

  event_id <- unique(
    select(
      event,
      location_id,
      observation_datetime
    )
  )

  event_id$event_id <- paste0(
    'ev_',
    seq(
      nrow(
        event_id
      )
    )
  )

  event_id$key <- apply(
    event_id[ , 1:2],
    1,
    paste,
    collapse = '_'
  )

  use_i <- match(
    event$key,
    event_id$key
  )

  observation$event_id <- event_id$event_id[use_i]



  # Make location_ancillary table ---------------------------------------------

  message(
    'Building location_ancillary table'
  )

  # Use ancillary location info from data. Ancillary information may change
  # with time.

  use_i <- str_detect(string = location$location_id, pattern = 'lo_1')

  L1_names <- location[use_i, 1:2]

  location_ancillary <- select(
    data,
    reach,
    urbanized,
    restored,
    water,
    observation_date
  )

  for (i in 1:nrow(L1_names)){
    use_i <- location_ancillary$reach == L1_names$location_name[[i]]
    location_ancillary$reach[use_i] <- L1_names$location_id[i]
  }

  # Gather

  location_ancillary <- gather(
    location_ancillary,
    key = variable_name,
    value = value, urbanized, restored, water
  )

  # Create column: location_ancillary_id

  location_ancillary$location_ancillary_id <- paste0(
    'loan_',
    seq(
      nrow(
        location_ancillary
      )
    )
  )

  # Create column: unit

  location_ancillary$unit <- rep(
    NA_character_,
    nrow(
      location_ancillary
    )
  )

  # Reorder columns

  location_ancillary <- select(
    location_ancillary,
    location_ancillary_id,
    reach,
    observation_date,
    variable_name,
    value,
    unit
  )

  # Rename columns

  colnames(location_ancillary) <- c(
    'location_ancillary_id',
    'location_id',
    'datetime',
    'variable_name',
    'value',
    'unit'
  )
  

  # Make taxon_ancillary table ------------------------------------------------

  message(
    'Building taxon_ancillary table'
  )

  taxon_ancillary <- u_tx

  taxon_ancillary$taxon_id <- taxon$taxon_id

  # Create column: datetime

  taxon_ancillary$datetime <- rep(
    NA_character_,
    nrow(
      taxon_ancillary
    )
  )

  # Create column: variable_name

  taxon_ancillary$variable_name <- rep(
    'common_name',
    nrow(
      taxon_ancillary
    )
  )

  # Create column: taxon_ancillary_id

  taxon_ancillary$taxon_ancillary_id <- paste0(
    'txan_',
    seq(
      nrow(
        taxon_ancillary
      )
    )
  )

  # Create column: author

  taxon_ancillary$author <- rep(
    NA_character_,
    nrow(
      taxon_ancillary
    )
  )

  # Order table columns

  taxon_ancillary <- select(
    taxon_ancillary,
    taxon_ancillary_id,
    taxon_id,
    datetime,
    variable_name,
    common_name,
    author
  )

  # Rename columns

  colnames(taxon_ancillary) <- c(
    'taxon_ancillary_id',
    'taxon_id',
    'datetime',
    'variable_name',
    'value',
    'author'
  )
  

  # Make observation ancillary table ------------------------------------------

  message(
    'Building observation ancillary table'
  )

  # Add column to data: event_id

  use_i <- match(
    event$key,
    event_id$key
  )

  data$event_id <- event_id$event_id[use_i]

  # Select columns

  observation_ancillary <- select(
    data,
    time_start,
    time_end,
    surveys_notes,
    surveys_observation_notes,
    event_id
  )

  # Gather

  observation_ancillary <- gather(
    observation_ancillary,
    key = variable_name,
    value = value, time_start, time_end, surveys_notes, surveys_observation_notes
  )

  # Add column: observation_ancillary_id

  observation_ancillary$observation_ancillary_id <- paste0(
    'oban_',
    seq(
      nrow(
        observation_ancillary
      )
    )
  )

  # Add column: unit

  observation_ancillary$unit <- rep(
    NA_character_,
    nrow(
      observation_ancillary
    )
  )

  # Arrange columns

  observation_ancillary <- select(
    observation_ancillary,
    observation_ancillary_id,
    event_id,
    variable_name,
    value,
    unit
  )
  
  # Make variable_mapping table -----------------------------------------------

  message(
    'Building variable_mapping table'
  )
  
  # Initialize variable_mapping table
  
  variable_mapping <- ecocomDP::make_variable_mapping(
    observation = observation,
    observation_ancillary = observation_ancillary,
    location_ancillary = location_ancillary,
    taxon_ancillary = taxon_ancillary
  )
  
  # Define variables:
  
  # count
  
  use_i <- variable_mapping$variable_name == 'quantity'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'https://dwc.tdwg.org/terms/#individualCount'
  variable_mapping$mapped_label[use_i] <- 'individualCount'
  
  # common_name
  
  use_i <- variable_mapping$variable_name == 'common_name'
  variable_mapping$mapped_system[use_i] <- 'Darwin Core'
  variable_mapping$mapped_id[use_i] <- 'https://dwc.tdwg.org/terms/#vernacularName'
  variable_mapping$mapped_label[use_i] <- 'vernacularName'
  
  # Can't find systems to map other variables to at this time. Add this content
  # later.
  
  # Write tables to file --------------------------------------------------------

  message(
    'Writing tables to file'
  )

  # Write observation table

  write_csv(
    observation,
    path = paste0(data.path,
                  "/",
                  table_prefix,
                  '_observation.csv')
  )

  # Write taxon table

  write_csv(
    taxon,
    path = paste0(data.path,
                  "/",
                  table_prefix,
                  "_taxon.csv")
  )

  # Write location table

  write_csv(
    location,
    path = paste0(data.path,
                  "/",
                  table_prefix,
                  "_location.csv")
  )

  # Write dataset_summary table

  write_csv(
    dataset_summary,
    path = paste0(data.path,
                  "/",
                  table_prefix,
                  "_dataset_summary.csv")
  )

  # Write location_ancillary table

  write_csv(
    location_ancillary,
    path = paste0(data.path,
                  "/",
                  table_prefix,
                  "_location_ancillary.csv")
  )

  # Write taxon_ancillary table

  write_csv(
    taxon_ancillary,
    path = paste0(data.path,
                  "/",
                  table_prefix,
                  "_taxon_ancillary.csv")
  )

  # Write observation_ancillary table

  write_csv(
    observation_ancillary,
    path = paste0(data.path,
                  "/",
                  table_prefix,
                  "_observation_ancillary.csv")
  )
  
  # Write variable_mapping table
  
  write_csv(
    variable_mapping,
    path = paste0(data.path,
                  "/",
                  table_prefix,
                  "_variable_mapping.csv")
  )

  message('Done')

}









