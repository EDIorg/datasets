#' Deconstruct EML into arbitrary base elements
#'
#' @description  A function to extract target elements from an EML file.
#'
#' @usage deconstruct_eml(path, file.name)
#'
#' @param path Path to the directory containing the .xml file.
#' @param xml.file.name File name of the .xml file to be deconstructed.
#'
#' @return Warnings written to deconstruction_log.txt. 
#' Information provided in this file includes:
#' 1. The date and time of the function was called.
#' 2. The names of expected but missing elements.
#'


deconstruct_eml <- function(path, xml.file.name){
  
  # Dependencies
  
  library("EML")
  library("methods")
  library("xlsx")
  
  # Create deconstruction file
  
  fileConn <- file(description = paste(path,
                                       "/",
                                       "deconstruction_log.txt",
                                       sep = ""),
                   open = "wt",
                   encoding = "UTF-8")
  
  writeLines(text = format(Sys.time(), "%Y-%m-%d %H:%M:%S"),
             con = fileConn)
  
  # Load .xml file
  
  xml_in <- read_eml(
    paste(path,
          "/",
          xml.file.name,
          sep = ""))
  
  # Create lists to add reference id numbers and values of associated eml 
  # elements to. Initialize a counter for list entries.
  
  ref_numbers <- c()
  
  ref_values <- list()
  
  counter <- 1
  
  # Get title
  
  title_in <- eml_get(xml_in@dataset, element = "title")
  
  if (length(title_in) == 0){
    
    writeLines(text = "<dataset><title> is empty.",
               con = fileConn)
    
    title_out <- new("ListOftitle", list(as("NA", "title")))
    
  } else {
    
    title_out <- title_in
    
  }
  
  # Get creator(s)
  
  creator_in <- eml_get(xml_in@dataset, element = "creator")
  
  if (length(creator_in) == 0){
    
    writeLines(text = "<dataset><creator> is empty.",
               con = fileConn)
    
    creator_out <- new("ListOfcreator", list(as("NA", "creator")))
    
  } else {
    
    for (i in 1:length(creator_in)){
      
      id <- eml_find(creator_in[[i]], "id")
      
      references <- eml_get(creator_in[[i]], element = "references")
      
      if (length(id) > 0){
        
        id <- as.character(id)
        
        ref_numbers[counter] <- id
        
        ref_values[[counter]] <- creator_in[[i]]
        
        counter <- counter + 1
        
      } else if (length(references) > 0){
        
        references <- as.character(references)
        
        ref_numbers[counter] <- references
        
        ref_values[[counter]] <- creator_in[[i]]@references@.Data
        
        counter <- counter + 1
        
      }
      
    }
    
    creator_out <- creator_in
    
  }
  
  # Get associated party(s)
  
  associated_party_in <- eml_get(xml_in@dataset, element = "associatedParty")
  
  if (length(associated_party_in) == 0){
    
    writeLines(text = "<dataset><associated_party> is empty.",
               con = fileConn)
    
    associated_party_out <- NA
    
  } else {
    
    for (i in 1:length(associated_party_in)){
      
      id <- eml_find(associated_party_in[[i]], "id")
      
      references <- eml_get(associated_party_in[[i]], element = "references")
      
      if (length(id) > 0){
        
        id <- as.character(id)
        
        ref_numbers[counter] <- id
        
        ref_values[[counter]] <- associated_party_in[[i]]
        
        counter <- counter + 1
        
      } else if (length(references) > 0){
        
        references <- as.character(references)
        
        ref_numbers[counter] <- references
        
        ref_values[[counter]] <- associated_party_in[[i]]@references@.Data
        
        counter <- counter + 1
        
      }
      
    }
    
    associated_party_out <- associated_party_in
    
  }
  
  # Get abstract
  
  abstract_in <- eml_get(xml_in@dataset, element = "abstract")
  
  if (length(abstract_in@para) == 0){
    
    writeLines(text = "<dataset><abstract> is empty.",
               con = fileConn)
    
    abstract_out <- as("NA", "abstract")
    
  } else {
    
    abstract_out <- abstract_in
    
  }
  
  # Get keyword set
  
  keyword_set_in <- eml_get(xml_in@dataset, element = "keywordSet")
  
  if (length(keyword_set_in) == 0){
    
    writeLines(text = "<dataset><keywordSet> is empty.",
               con = fileConn)
    
    keyword_set_out <- new("ListOfkeywordSet", c(new("keywordSet", "NA")))
    
  } else {
    
    keyword_set_out <- keyword_set_in
    
  }
  
  # Get additional info
  
  additional_info_in <- eml_get(xml_in@dataset, element = "additionalInfo")
  
  if (length(additional_info_in) == 0){
    
    additional_info_out <- "NA"
    
  } else {
    
    additional_info_out <- additional_info_in
    
  }
  
  # Get intellectual rights. Replace with cc0 if not present
  
  intellectual_rights_in <- eml_get(xml_in@dataset, element = "intellectualRights")
  
  if (length(intellectual_rights_in@para) == 0){
    
    writeLines(text = "<dataset><intellectualRights> is empty.",
               con = fileConn)
    
    intellectual_rights_out <- as("NA", "intellectualRights")
    
  } else {
    
    intellectual_rights_out <- intellectual_rights_in
    
  }
  
  # Get geographic coverage

  coverage_in <- eml_get(xml_in@dataset, element = "coverage")

  if (length(coverage_in@geographicCoverage) == 0){

    writeLines(text = "<dataset><coverage> is empty.",
               con = fileConn)

    geographic_coverage_out <- as("NA", "coverage")

  } else {

    coverage_out <- coverage_in

  }
  
  # Get maintenance information
  
  maintenance_in <- eml_get(xml_in@dataset, element = "maintenance")
  
  if (length(maintenance_in@description) == 0){
    
    writeLines(text = "<dataset><maintenance> is empty.",
               con = fileConn)
    
    maintenance_out <- as("NA", "maintenance")
    
  } else {
    
    maintenance_out <- maintenance_in
    
  }
  
  # Get contact information
  
  contact_in <- eml_get(xml_in@dataset, element = "contact")
  
  if (length(contact_in) == 0){
    
    writeLines(text = "<dataset><contact> is empty.",
               con = fileConn)
    
    contact_out <- new("ListOfcontact", list(as("NA", "contact")))
    
  } else {
    
    for (i in 1:length(contact_in)){
      
      id <- eml_find(contact_in[[i]], "id")
      
      references <- eml_get(contact_in[[i]], element = "references")
      
      if (length(id) > 0){
        
        id <- as.character(id)
        
        ref_numbers[counter] <- id
        
        ref_values[[counter]] <- contact_in[[i]]
        
        counter <- counter + 1
        
      } else if (length(references) > 0){
        
        references <- as.character(references)
        
        ref_numbers[counter] <- references
        
        ref_values[[counter]] <- contact_in[[i]]@references@.Data
        
        counter <- counter + 1
        
      }
      
    }
    
    contact_out <- contact_in
    
  }
  
  # Get methods
  
  methods_in <- eml_get(xml_in@dataset, element = "methods")
  
  if (length(methods_in@methodStep) == 0){
    
    writeLines(text = "<dataset><methods> is empty.",
               con = fileConn)
    
    methods_out <- as("NA", "methods")
    
  } else {
    
    methods_out <- methods_in
    
  }
  
  # Get project information
  
  project_in <- eml_get(xml_in@dataset, element = "project")
  
  if (length(project_in@title) == 0){
    
    writeLines(text = "<dataset><project> is empty.",
               con = fileConn)
    
    project_out <- NA
    
  } else {
    
    project_out <- project_in
    
  }
  
  # Get entity name
  
  entity_name_in <- eml_get(xml_in@dataset, element = "entityName")
  
  if (length(entity_name_in) == 0){
    
    writeLines(text = "<dataset><dataTable><entityName> is empty.",
               con = fileConn)
    
    entity_name_out <- new("entityName", "NA")
    
  } else {
    
    entity_name_out <- entity_name_in
    
  }
  
  # Get entity description
  
  entity_description_in <- eml_get(xml_in@dataset, element = "entityDescription")
  
  if (length(entity_description_in) == 0){
    
    writeLines(text = "<dataset><dataTable><entityDescription> is empty.",
               con = fileConn)
    
    entity_description_out <- new("entityDescription", "NA")
    
  } else {
    
    definition_raw <- entity_description_in
    
    definition_raw <- gsub("[\r\t\n]", " ", definition_raw)
    
    definition_clean <- gsub("\\s+", " ", definition_raw)
    
    entity_description_out <- definition_clean
    
  }
  
  # Get entity name
  
  storage_type_in <- eml_get(xml_in@dataset, element = "storageType")
  
  if (length(storage_type_in) == 0){
    
    writeLines(text = "<dataset><dataTable><entityName> is empty.",
               con = fileConn)
    
    storage_type_out <- new("entityName", "NA")

    
  } else {
    
    storage_type_out <- storage_type_in
    
  }
  
  # Get additional metadata
  
  additional_metadata_in <- eml_get(xml_in, element = "additionalMetadata")
  
  if (length(additional_metadata_in) == 0){
    
    writeLines(text = "<dataset><additionalMetadata> is empty.",
               con = fileConn)
    
    additional_metadata_out <- new("entityDescription", "NA")
    
  } else {
    
    additional_metadata_out <- additional_metadata_in
    
  }
  
  # Close warnings log file
  
  close(fileConn)
  
  # Remove duplicate entries from reference id list
  
  ref_values_out <- list()
  ref_numbers_out <- c()
  counter <- 1
  
  for (i in 1:length(ref_numbers)){
    
    if (class(ref_numbers[i]) != class(ref_values[[i]])){
      
      ref_numbers_out[i] <- ref_numbers[i]
      
      ref_values_out[[i]] <- ref_values[[i]]
      
      counter <- counter + 1

    }
    
  }
  
  # Remove top level element from reference id list
  
  base_elements_out <- list()
  
  for (i in 1:length(ref_values_out)){
    
    base_elements <- list()
    
    element_class <- class(ref_values_out[[i]])[1]
    
    element_slot_pairs <- getSlots(element_class)
    
    element_names <- slotNames(element_class)

    for (j in 1:length(element_names)){

      match_info <- regexpr("ListOf", element_slot_pairs[[j]])
      
      if (attr(match_info, "match.length") > 0){
        
        base_elements[[j]] <- list(element_names[j], eml_get(ref_values_out[[i]], element = element_names[j]))
        
      }

    }
    
    base_elements_out[[i]] <- base_elements

  }
  
  # List function outputs -----------------------------------------------------
  
  list("title" = title_out,
       "creator" = creator_out,
       "associated_party" = associated_party_out,
       "abstract" = abstract_out,
       "keyword_set" = keyword_set_out,
       "additional_info" = additional_info_out,
       "intellectual_rights"= intellectual_rights_out,
       "coverage" = coverage_out,
       "maintenance" = maintenance_out,
       "contact" = contact_out,
       "methods" = methods_out,
       "project" = project_out,
       "entity_name" = entity_name_out,
       "entity_description" = entity_description_out,
       "storage_type" = storage_type_out,
       "reference_definitions" = ref_values_out,
       "reference_numbers" = ref_numbers_out,
       "base_elements" = base_elements_out)
  
}

