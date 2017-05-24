

# Reconstruct EML for MSB CSI LAGOS


# Parameterize function -------------------------------------------------------

path <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\msb_csi_lagos\\WI_L_POSITION_CHEM"
dataset.name <- "WI_L_POSITION_CHEM"
table.name <- "WI_L_POSITION_CHEM.csv"
xml.file.name <- "WI_L_POSITION_CHEM.xml"

data.package.id <- "edi.76.2"

table_names <- trimws(c(table.name))

num_header_lines <- trimws(c("1"))
record_delimeter <- trimws(c("\\r\\n"))
attribute_orientation <- trimws(c("column"))
field_delimeter <- trimws(c(","))

# Additional parameters, don't change these.

intellectual.rights <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\blank\\datasetname_cc0_1_intellectual_rights.md"

root.system <- "https://pasta.lternet.edu"

schema.location <- "eml://ecoinformatics.org/eml-2.1.1  http://nis.lternet.edu/schemas/EML/eml-2.1.1/eml.xsd"

server_root_directory <- "https://lter.limnology.wisc.edu/sites/default/files/data/LAGOS_NE_LIMNO_RAWDATA"

fname_table_attributes <- c()
for (i in 1:length(table_names)){
  fname_table_attributes[i] <- paste(
    substr(table_names[i], 1, nchar(table_names[i]) - 4),
    "_attributes.xlsx",
    sep = "")
}

fname_table_factors <- c()
for (i in 1:length(table_names)){
  fname_table_factors[i] <- paste(
    substr(table_names[i], 1, nchar(table_names[i]) - 4),
    "_factors.xlsx",
    sep = "")
}

#

# Build dataset ---------------------------------------------------------------

# Load dependencies

library("EML")
library("xlsx")
library("rmarkdown")
library("methods")
library("stringr")
library("tools")

# Deconstruct EML document. Use first .xml file for dataset attributes

elements <- deconstruct_eml(path = path, xml.file.name = xml.file.name)

# Initialize data entity storage (tables and spatial vectors)

data_tables_stored <- list()

access_order <- trimws("allowFirst")

access_scope <- trimws("document")

author_system <- "edi"

allow_principals <- trimws(c("uid=csmith,o=LTER,dc=ecoinformatics,dc=org",
                             "public"))

allow_permissions <- trimws(c("all",
                              "read")) # order follows allow_principals

# Build eml access

access <- new("access",
              scope = access_scope,
              order = access_order,
              authSystem = author_system)

allow <- list()
for (i in 1:length(allow_principals)){
  allow[[i]] <- new("allow",
                    principal = allow_principals[i],
                    permission = allow_permissions[i])
}

access@allow <- new("ListOfallow",
                    c(allow))

# Build dataset

dataset <- new("dataset",
               title = elements[["title"]])

# Add creators

dataset@creator <- as(elements[["creator"]], "ListOfcreator")

# Add publicaton date

dataset@pubDate <- as(format(Sys.time(), "%Y-%m-%d"), "pubDate")

# Add abstract

if (identical((elements[["abstract"]] != "NA"), logical(0))){
  dataset@abstract <- elements[["abstract"]]
}

# Add keywords

dataset@keywordSet <- elements[["keyword_set"]]

# Add intellectual rights

# if (length(elements[["intellectual_rights"]]@para) != 0){
#   
#   dataset@intellectualRights <- elements[["intellectual_rights"]]
#   
# } else {
  
  dataset@intellectualRights <- as(
    set_TextType(intellectual.rights),
    "intellectualRights")

# }

# Add coverage

dataset@coverage <- elements[["coverage"]]

# Add contacts

list_of_contacts <- list()

for (i in 1:length(elements[["contact"]])){
# for (i in 1){
  
  new_contact <- new("contact")
  
  contact <- elements[["contact"]][i]
  
  reference <- eml_get(elements[["contact"]][i], element = "references")
  
  if (length(reference) == 0){
    
    list_of_contacts[[i]] <- elements[["contact"]][i]$contact
    
  } else {
    
    useI <- match(reference, elements[["reference_numbers"]])
    
    for (j in 1:length(elements[["base_elements"]][[useI]])){
      
      if (!identical(elements[["base_elements"]][[useI]][[j]], NULL)){
        
        slot(new_contact, elements[["base_elements"]][[useI]][[j]][[1]]) <- elements[["base_elements"]][[useI]][[j]][[2]]

      }

    }

    list_of_contacts[[i]] <- new_contact
    
  }
  
}

dataset@contact <- as(list_of_contacts, "ListOfcontact")

# Add methods

dataset@methods <- elements[["methods"]]

if (file.exists(paste(path, "/", "geographic_coverage.xlsx", sep = ""))){
  
  df_geographic_coverage <- xlsx::read.xlsx2(paste(path,
                                                   "/",
                                                   "geographic_coverage.xlsx",
                                                   sep = ""),
                                             sheetIndex = 1)
  
  df_geographic_coverage$latitude <- as.character(df_geographic_coverage$latitude)
  
  df_geographic_coverage$longitude <- as.character(df_geographic_coverage$longitude)
  
  df_geographic_coverage$site <- as.character(df_geographic_coverage$site)
  
  list_of_coverage <- list()
  
  for (i in 1:dim(df_geographic_coverage)[1]){
    
    coverage <- new("coverage")
    
    geographic_description <- new("geographicDescription", df_geographic_coverage$site[i])
    
    bounding_coordinates <- new("boundingCoordinates",
                                westBoundingCoordinate = df_geographic_coverage$longitude[i],
                                eastBoundingCoordinate = df_geographic_coverage$longitude[i],
                                northBoundingCoordinate = df_geographic_coverage$latitude[i],
                                southBoundingCoordinate = df_geographic_coverage$latitude[i])
    
    geographic_coverage <- new("geographicCoverage",
                               geographicDescription = geographic_description,
                               boundingCoordinates = bounding_coordinates)
    
    coverage@geographicCoverage <- as(list(geographic_coverage), "ListOfgeographicCoverage")
    
    list_of_coverage[[i]] <- coverage
    
  }
  
  sampling <- eml_get(dataset@methods, element = "sampling")
  
  sampling_description <- eml_get(dataset@methods, element = "samplingDescription")
  
  if (is.null(sampling)){
    
    sampling <- new("sampling")
    
    sampling@studyExtent@coverage <- as(list_of_coverage, "ListOfcoverage")
    
    dataset@methods@sampling <- as(list(sampling), "ListOfsampling")
    
  } else if (!is.null(sampling_description)){
    
    sampling <- new("sampling")
    
    sampling@studyExtent@coverage <- as(list_of_coverage, "ListOfcoverage")
    
    sampling@samplingDescription <- sampling_description
    
    dataset@methods@sampling <- as(list(sampling), "ListOfsampling")
    
  }
  
}

# Add project and funding

if (!is.na(elements[["project"]])){
  dataset@project <- elements[["project"]]
}

# Add associated party

list_of_associated_party <- list()

for (i in 1:length(elements[["associated_party"]])){
  
  if (!is.na(elements[["associated_party"]][i])){
    
    new_associated_party <- new("associatedParty")
    
    associated_party <- elements[["associated_party"]][i]
    
    reference <- eml_get(elements[["associated_party"]][i], element = "references")
    
    if (length(reference) == 0){
      
      list_of_associated_party[[i]] <- associated_party$associatedParty
      
    } else {
      
      useI <- match(reference, elements[["reference_numbers"]])
      
      for (j in 1:length(elements[["base_elements"]][[useI]])){
        
        if (!identical(elements[["base_elements"]][[useI]][[j]], NULL)){
          
          slot(new_associated_party, elements[["base_elements"]][[useI]][[j]][[1]]) <- elements[["base_elements"]][[useI]][[j]][[2]]
          
        }
        
      }
      
      list_of_associated_party[[i]] <- new_associated_party
      
    }
    
  }
  
}

dataset@associatedParty <- as(list_of_associated_party, "ListOfassociatedParty")


# Compile table attributes ----------------------------------------------------

data_tables_stored <- list()

for (i in 1:length(table_names)){
  
  # Print progress to screen
  
  print(paste(
    "Now building attributes for ... ",
    table_names[i],
    sep = ""))
  
  # Deconstruct EML of target data table
  
  elements <- deconstruct_eml(path = path, xml.file.name = xml.file.name)
  
  # Read attributes file (encoding necessitates read/write/read)
  
  attributes <- read.xlsx2(paste(
    path,
    "/",
    fname_table_attributes[i], sep = ""),
    sheetIndex = 1,
    colClasses = c(rep("character",9)),
    stringsAsFactors = F)
  
  write.table(
    attributes,
    paste(
      path,
      "/",
      substr(fname_table_attributes[i],
             1,
             nchar(fname_table_attributes[i]) - 5),
      ".txt",
      sep=""),
    sep = "\t",
    row.names = F,
    quote = F,
    fileEncoding = "UTF-8")
  
  attributes <- read.table(
    paste(
      path,
      "/",
      substr(fname_table_attributes[i],
             1,
             nchar(fname_table_attributes[i]) - 5),
      ".txt",
      sep = ""),
    header = TRUE,
    sep = "\t",
    as.is = TRUE,
    na.strings = "")
  for (j in 1:9){
    attributes[ ,j] <- as.character(attributes[ ,j])
  }
  
  # Read factors file (encoding necessitates read/write/read)
  
  fname_expected_factors <- paste(
    substr(table_names[i], 1, nchar(table_names[i]) - 4),
    "_factors.xlsx",
    sep = "")
  
  if (!is.na(match(fname_expected_factors, list.files(path)))){
    
    factors <- read.xlsx2(paste(
      path,
      "/",
      fname_table_factors[i], sep = ""),
      sheetIndex = 1,
      colClasses = c(rep("character",3)))
    
    if (dim(factors)[1] > 0){
      
      for (j in 1:dim(factors)[2]){
        factors[ ,j] <- as.character(factors[ ,j])
      }
      
      non_blank_rows <- nrow(factors) - sum(factors$attributeName == "")
      factors <- factors[1:non_blank_rows, 1:3]
      
      write.table(
        factors,
        paste(
          path,
          "/",
          substr(fname_table_factors[i],
                 1,
                 nchar(fname_table_factors[i]) - 5),
          ".txt",
          sep=""),
        sep = "\t",
        row.names = F,
        quote = F,
        fileEncoding = "UTF-8")
      
      factors <- read.table(
        paste(
          path,
          "/",
          substr(fname_table_factors[i],
                 1,
                 nchar(fname_table_factors[i]) - 5),
          ".txt",
          sep=""),
        header = TRUE,
        sep = "\t",
        as.is = TRUE,
        na.strings = "NA")
      
      # Clean extraneous white spaces from factors tables
      
      if (dim(factors)[1] != 0){
        for (j in 1:ncol(factors)){
          if (class(factors[ ,j]) == "character" ||
              (class(factors[ ,j]) == "factor")){
            factors[ ,j] <- trimws(factors[ ,j])
          }
        }
      }
      
    }
    
  }
  
  # Clean extraneous white spaces from attributes
  
  for (j in 1:ncol(attributes)){
    if (class(attributes[ ,j]) == "character" ||
        (class(attributes[ ,j]) == "factor")){
      attributes[ ,j] <- trimws(attributes[ ,j])
    }
  }
  
  # Get the column classes into a vector
  
  col_classes <- attributes[ ,"columnClasses"]
  
  # Create the attributeList element
  
  if (!is.na(match(fname_expected_factors, list.files(path)))){
    
    if (dim(factors)[1] != 0){
      attributeList <- set_attributes(attributes,
                                      factors = factors,
                                      col_classes = col_classes)
    } else {
      attributeList <- set_attributes(attributes,
                                      col_classes = col_classes)
    }
  } else {
    
    attributeList <- set_attributes(attributes,
                                    col_classes = col_classes)
  }
  
  # Set physical
  
  physical <- set_physical(table_names[i],
                           numHeaderLines = num_header_lines[i],
                           recordDelimiter = record_delimeter[i],
                           attributeOrientation = attribute_orientation[i],
                           fieldDelimiter = field_delimeter[i],
                           quoteCharacter = "\"")
  
  physical@size <- new("size",
                       unit = "bytes",
                       as.character(
                         file.size(
                           paste(path,
                                 "/",
                                 table_names[i],
                                 sep = ""))))
  
  match_info <- regexpr("[^\\]*$", path)
  
  directory_name <- substr(path, start = match_info[1], stop = nchar(path))
  
  distribution <- new("distribution",
                      online = new("online",
                                   url = paste(server_root_directory,
                                               "/",
                                               directory_name,
                                               "/",
                                               table_names[i],
                                               sep = "")))
  
  physical@distribution <- new("ListOfdistribution",
                               c(distribution))
  
  # Pull together information for the data table
  
  data_table <- new("dataTable",
                    entityName = table_names[i],
                    entityDescription = elements[["entity_description"]],
                    physical = physical,
                    attributeList = attributeList)
  
  data_tables_stored[[i]] <- data_table
  
}

# Add custom units (if present) -----------------------------------------------

# Are custom units present in these tables?

custom_units_df <- read.xlsx2(
  paste(path,
        "/",
        substr(table_names[1], 1, nchar(table_names[1]) - 4),
        "_custom_units.xlsx",
        sep = ""),
  sheetIndex = 1,
  colClasses = c("character",
                 "character",
                 "character",
                 "numeric",
                 "character"))

if (nrow(custom_units_df) == 1 & sum(is.na(custom_units_df)) > 1){
  custom_units <- "no"
} else {
  custom_units <- "yes"
}

# Clean white spaces from custom_units and units_types

if (custom_units == "yes"){
  
  # for (j in 1:ncol(unitType_df)){
  #   if (class(unitType_df[ ,j]) == "character" ||
  #       (class(unitType_df[ ,j]) == "factor")){
  #     unitType_df[ ,j] <- trimws(unitType_df[ ,j])
  #   }
  # }
  
  # custom_units_df <- read.xlsx2(
  #   paste(path,
  #         "/",
  #         substr(template, 1, nchar(template) - 14),
  #         "_custom_units.xlsx", sep = ""),
  #   sheetIndex = 1,
  #   colClasses = c("character",
  #                  "character",
  #                  "character",
  #                  "numeric",
  #                  "character"))
  
  write.table(custom_units_df,
              paste(path,
                    "/",
                    substr(table_names[1], 1, nchar(table_names[1]) - 4),
                    "_custom_units.txt",
                    sep = ""),
              sep = "\t",
              row.names = F,
              quote = F,
              fileEncoding = "UTF-8")
  
  custom_units_df <- read.table(
    paste(path,
          "/",
          substr(table_names[1], 1, nchar(table_names[1]) - 4),
          "_custom_units.txt",
          sep = ""),
    header = TRUE,
    sep = "\t",
    as.is = TRUE,
    na.strings = "")
  
  for (j in 1:ncol(custom_units_df)){
    if (class(custom_units_df[ ,j]) == "character" ||
        (class(custom_units_df[ ,j]) == "factor")){
      custom_units_df[ ,j] <- trimws(custom_units_df[ ,j])
    }
  }
  
  unitsList <- set_unitList(custom_units_df)
}

# Add R code ------------------------------------------------------------------

# Name of script files

match_info <- regexpr("[^\\]*$", path)
directory_name <- substr(path, start = match_info[1], stop = nchar(path))

files <- list.files(path = path)

code_names <- files[attr(regexpr("*.R$", files), "match.length") != -1]

list_of_other_entity <- list()

for (i in 1:length(code_names)){
  
  # Create new other entity element
  
  other_entity <- new("otherEntity")
  
  # Add code file names
  
  other_entity@entityName <- code_names[i]
  
  # Add description
  
  code_description <- "Imports data for the LAke multi-scaled GeOSpatial database (LAGOS)"
  
  other_entity@entityDescription <- code_description
  
  #  Build physical
  
  num_header_lines_code <- trimws(c("0"))
  record_delimeter_code <- trimws(c("\\r\\n"))
  attribute_orientation_code <- trimws(c("column"))
  field_delimeter_code <- ""
  quote_character <- trimws(c("\""))
  code_urls <- paste(server_root_directory, "/", directory_name, "/", code_names[i], sep = "")
  entity_type_code <- "R code"
  
  physical <- set_physical(code_names[i],
                           numHeaderLines = num_header_lines_code,
                           recordDelimiter = record_delimeter_code,
                           attributeOrientation = attribute_orientation_code,
                           fieldDelimiter = field_delimeter_code,
                           quoteCharacter = quote_character)
  
  physical@size <- new("size", unit = "bytes", as(as.character(file.size(paste(path, "\\", code_names[i], sep = ""))), "size"))
  
  distribution <- new("distribution",
                      online = new("online",
                                   url = code_urls))
  
  physical@distribution <- new("ListOfdistribution",
                               c(distribution))
  
  # data_table <- new("dataTable",
  #                   entityName = table_names[i],
  #                   entityDescription = elements[["entity_description"]],
  #                   physical = physical,
  #                   attributeList = attributeList)
  # 
  # data_tables_stored[[i]] <- data_table
  
  other_entity@physical <- as(c(physical), "ListOfphysical")
  
  # Add entity type
  
  other_entity@entityType <- entity_type_code
  
  # Add other entity to list
  
  list_of_other_entity[[i]] <- other_entity

}

# Compile information for for writting eml ------------------------------------

# Compile data tables

dataset@dataTable <- new("ListOfdataTable",
                         data_tables_stored)

dataset@otherEntity <- new("ListOfotherEntity",
                           list_of_other_entity)

# Build EML -------------------------------------------------------------------

if (custom_units == "yes"){
  eml <- new("eml",
             schemaLocation = schema.location,
             packageId = data.package.id,
             system = root.system,
             access = access,
             dataset = dataset,
             additionalMetadata = as(unitsList, "additionalMetadata"))
} else {
  eml <- new("eml",
             schemaLocation = schema.location,
             packageId = data.package.id,
             system = root.system,
             access = access,
             dataset = dataset)
}

# Validate EML

# print("Validating EML ...")
# 
# validation_result <- eml_validate(eml)
# 
# # Write EML
# 
# if (validation_result == "TRUE"){
  print("Writing EML ...")
  write_eml(eml, paste(path, "/", data.package.id, ".xml", sep = ""))
# } else {
#   print("EML validaton failed. EML was not written to file.")
# }





