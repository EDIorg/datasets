#' Write reconstructed table attributes
#'
#' @description  A function to compile deconstructed data table elements from
#' an input EML file and write these attributes to file.
#'
#' @usage write_reconstructed_attributes(path, dataset.name, table.name)
#'
#' @param path Path to the directory containing the .xml file.
#' @param dataset.name Name of the dataset you are compiling.
#' @param table.name Name of the input data table to be deconstructed and
#' @param xml.file.name The .xml file to be deconstructed (including file extension)
#' written to an attributes file.
#'
#' @return A file named datasetname_attributes_draft.xlsx
#' @return A file named datasetname_attributes.xlsx
#' @return A file named datasetname_attributes.txt
#'


write_reconstructed_attributes <- function(path, table.name, dataset.name, xml.file.name){
  
  # Issue warning
  
  answer <- readline(
    "Are you sure you want to build new attributes? This will overwrite your previous work! (y or n):  ")

  if (answer == "y"){
    
    # Load dependencies
    
    library("EML")
    library("xlsx")
    library("rmarkdown")
    
    # Deconstruct .xml file
    
    elements <- deconstruct_eml(path = path, xml.file.name = xml.file.name)
    
    # Get system information
    
    sysinfo <- Sys.info()["sysname"]
    if (sysinfo == "Darwin"){
      os <- "mac"
    } else {
      os <- "win"
    }
    
    # Partially deconstruct the attributes list and write to .xlsx file
    
    dataset_files <- list.files(path, all.files = T)
    
    metadata_file <- dataset_files[attr(regexpr(".xml", dataset_files), "match.length") != -1]
    
    # Load .xml file
    
    xml_in <- read_eml(
      paste(path,
            "/",
            metadata_file,
            sep = ""))
    
    # Get attributes
    
    attributes_in <- eml_get(xml_in@dataset, element = "attributeList")
    
    rows <- length(attributes_in[[1]][["attributeName"]])
    
    attributes_out <- data.frame(columnName = attributes_in[[1]][["attributeName"]],
                                 description = attributes_in[[1]][["attributeDefinition"]],
                                 unitOrCodeExplanationOrDateFormat = attributes_in[[1]][["unit"]],
                                 emptyValueCode = character(rows),
                                 stringsAsFactors = FALSE)
    
    # Remove special character representations as \n\t\....
    
    for (i in 1:length(attributes_out$description)){
      
      definition_raw <- attributes_out$description[i]
      
      definition_raw <- gsub("[\r\t\n]", " ", definition_raw)
      
      definition_clean <- gsub("\\s+", " ", definition_raw)
      
      attributes_out$description[i] <- definition_clean
      
    }
    
    # Write attributes draft
    
    data_file_base <- gsub("\\.[^\\.]*$", "", table.name)
    
    template <- paste(data_file_base,
                      "_template.docx",
                      sep = "")
    
    write.xlsx(attributes_out,
               paste(path,
                     "/",
                     data_file_base,
                     "_attributes_draft.xlsx",
                     sep = ""),
               col.names = T,
               row.names = F,
               showNA = F)
    
    # Edit the attributes draft file
    
    # if (os == "mac"){
    #   system(paste("open",
    #                paste(path,
    #                      "/",
    #                      data_file_base,
    #                      "_attributes_draft.xlsx",
    #                      sep = "")))
    #   
    # } else if (os == "win"){
    #   
    #   shell.exec(paste(path,
    #                    "/",
    #                    data_file_base,
    #                    "_attributes_draft.xlsx",
    #                    sep = ""))
    #   
    # }
    # 
    # readline(
    #   prompt = "Edit *_attributes_draft.xlsx. Save, close, and press enter.")
    
    # Set file names
    
    fname_table_attributes <- paste(substr(table.name, 1, nchar(table.name) - 4),
                                    "_attributes.xlsx", sep = "")
    
    # Initialize custom unit files
    
    custom_units <- data.frame(id = character(1),
                               unitType = character(1),
                               parentSI = character(1),
                               multiplierToSI = character(1),
                               description = character(1),
                               stringsAsFactors = FALSE)
    
    xlsx::write.xlsx(custom_units,
                     paste(path,
                           "/",
                           dataset.name,
                           "_custom_units.xlsx", sep = ""),
                     col.names = T,
                     row.names = F,
                     showNA = F)
    
    # Create the attributes file
      
    print(paste("Now building attributes for ... ",
                table.name, sep = ""))
    
    # What is the file extension?
    
    match_info <- regexpr("\\.[^\\.]*$", table.name)
    file_extension <- substr(table.name, start = match_info[1], stop = nchar(table.name)) 
    
    # Read data table
    
    if (file_extension == ".csv"){
      
      df_table <- read.csv(
        paste(path, "/", table.name, sep = ""),
        header=TRUE,
        sep=",",
        quote="\"",
        as.is=TRUE)
      
    } else if (file_extension == ".xls|.xlsx"){
      
      df_table <- xlsx::read.xlsx2(
        paste(
          path,
          "/",
          table.name,
          sep = ""),
        sheetIndex = 1)
      
    }
    
    # List .xml attributes not in the table
    
    xml_attribute_names <- attributes_out$columnName
    
    table_column_names <- colnames(df_table)
    
    attributes_not_as_columns <- c()
    
    for (k in 1:length(xml_attribute_names)){
      
      if (sum(xml_attribute_names[k] == table_column_names) == 0){
        
        attributes_not_as_columns[k] <- xml_attribute_names[k]
        
      }
      
    }
    
    attributes_not_as_columns[k+1] <- paste("Attribute length = ", as.character(length(xml_attribute_names)),
                                            "Column length = ", as.character(length(table_column_names)))
    
    print("EML attributes not in the table. NA = no discrepancy.")
    
    print(attributes_not_as_columns)
    
    # List table columns not in .xml
    
    columns_not_as_attributes <- c()
    
    for (k in 1:length(table_column_names)){
      
      if (sum(table_column_names[k] == xml_attribute_names) == 0){
        
        columns_not_as_attributes[k] <- table_column_names[k]
        
      }
      
    }
    
    columns_not_as_attributes[k+1] <- paste("Attribute length = ", as.character(length(xml_attribute_names)),
                                            "Column length = ", as.character(length(table_column_names)))
    
    print("EML attributes not in the table. NA = no discrepancy.")
    
    print(columns_not_as_attributes)
    
    # Edit the attributes draft file and the data file if necessary
    
    if (os == "mac"){
      system(paste("open",
                   paste(path,
                         "/",
                         data_file_base,
                         "_attributes_draft.xlsx",
                         sep = "")))
      
    } else if (os == "win"){
      
      shell.exec(paste(path,
                       "/",
                       data_file_base,
                       "_attributes_draft.xlsx",
                       sep = ""))
      
    }
    
    readline(
      prompt = "Press <enter> once discrepancies between attributes and column names are resolved.")
    
    # Re-Read data table (incase any changes were made)
    
    if (file_extension == ".csv"){
      
      df_table <- read.csv(
        paste(path, "/", table.name, sep = ""),
        header=TRUE,
        sep=",",
        quote="\"",
        as.is=TRUE)
      
    } else if (file_extension == ".xls|.xlsx"){
      
      df_table <- xlsx::read.xlsx2(
        paste(
          path,
          "/",
          table.name,
          sep = ""),
        sheetIndex = 1)
      
      readline(
        prompt = "Excel file encountered. Note dataset name and process later.")
      
    }
    
    table_column_names <- colnames(df_table)
    
    # Initialize attribute table
    
    rows <- ncol(df_table)
    attributes <- data.frame(attributeName = character(rows),
                             formatString = character(rows),
                             unit = character(rows),
                             numberType = character(rows),
                             definition = character(rows),
                             attributeDefinition = character(rows),
                             columnClasses = character(rows),
                             missingValueCode = character(rows),
                             missingValueCodeExplanation = character(rows),
                             stringsAsFactors = FALSE)
    
    # Set names
    
    attributes$attributeName <- names(df_table)
    
    # Set number type
    
    attributes$columnClasses <- sapply(df_table, class)
    
    is_integer <- which(attributes$columnClasses == "integer")
    
    is_numeric <- which(attributes$columnClasses == "numeric")
    
    is_character <- which(attributes$columnClasses == "character")
    
    for (j in 1:length(is_integer)){
      if (min(df_table[ ,is_integer[j]], na.rm = T) > 0){
        attributes$numberType[is_integer[j]] <- "natural"
      } else if (min(df_table[ ,is_integer[j]], na.rm = T) < 0){
        attributes$numberType[is_integer[j]] <- "integer"
      } else {
        attributes$numberType[is_integer[j]] <- "whole"
      }
    }
    
    for (j in 1:length(is_numeric)){
      raw <- df_table[ ,is_numeric[j]]
      rounded <- floor(df_table[ ,is_numeric[j]])
      if (length(raw) - sum(raw == rounded, na.rm = T) > 0){
        attributes$numberType[is_numeric[j]] <- "real"
      }
    }
    
    for (j in 1:length(is_character)){
      attributes$numberType[is_character[j]] <- "character"
    }
    
    # Set missing value code "NA"
    
    for (j in 1:nrow(attributes)){
      if (sum(is.na(df_table[ ,j])) > 0){
        attributes$missingValueCode[j] <- "NA"
      }
    }
    
    attributes$missingValueCodeExplanation[
      attributes$missingValueCode == "NA"] <- "not available"
    
    # Set column classes
    
    attributes$columnClasses[
      attributes$columnClasses == "integer"] <- "numeric"
    
    potential_factors <- which(
      attributes$columnClasses %in% "character")  # Identify factors
    
    for (j in 1:length(potential_factors)){
      if (length(unique(df_table[ ,potential_factors[j]])) <
          length(df_table[ ,potential_factors[j]])*.1){
        attributes$columnClasses[potential_factors[j]] <- "factor"
      }
    }
    
    # Set definitions (attributeDefinition)
    
    df_attributes <- xlsx::read.xlsx2(
      paste(
        path,
        "/",
        substr(fname_table_attributes,
               1,
               nchar(fname_table_attributes) - 5),
        "_draft.xlsx",
        sep = ""),
      sheetIndex = 1,
      colClasses = c(rep("character",4)))
    
    colnames(df_attributes) <- c("columnName",
                                 "description",
                                 "unitOrCodeExplanationOrDateFormat",
                                 "emptyValueCode")
    
    attributes$attributeDefinition <- trimws(
      df_attributes$description[
        match(trimws(attributes$attributeName),
              trimws(df_attributes$columnName))])
    
    use_I <- is.na(match(trimws(attributes$attributeName),
                         trimws(df_attributes$columnName))) # Tag fields where attribute names don't match between the data table and user supplied template
    
    attributes$attributeDefinition[use_I] <-
      "!!! Non-matching attribute names !!!"
    
    # Set definition (definition).
    # For nominal variables the attributeDefinition must be placed in definition.
    
    attributes$definition[attributes$columnClasses == "factor"] <-
      attributes$attributeDefinition[attributes$columnClasses == "factor"]
    
    # Set units
    
    attributes$unit <- trimws(df_attributes$unitOrCodeExplanationOrDateFormat[
      match(attributes$attributeName, df_attributes$columnName)])
    
    attributes$unit[(attributes$numberType == "real") &
                      (attributes$columnClasses == "factor")] <- "number"
    
    xlsx::write.xlsx(attributes,
                     paste(path,
                           "/",
                           fname_table_attributes,
                           sep = ""),
                     col.names = T,
                     row.names = F,
                     showNA = F)
    
    # Prompt the user to manually edit the attributes file and custom unit files.
    
    standardUnits <- get_unitList()
    View(standardUnits$units)
    
    if (os == "mac"){
      system(paste("open",
                   paste(path,
                         "/",
                         data_file_base,
                         "_attributes.xlsx",
                         sep = "")))
      
      system(paste("open ",
                   path,
                   "/",
                   data_file_base,
                   "_custom_units.xlsx",
                   sep = ""))
      
    } else if (os == "win"){
      
      shell.exec(paste(path,
                       "/",
                       data_file_base,
                       "_attributes.xlsx",
                       sep = ""))
      
      shell.exec(paste(path,
                       "/",
                       data_file_base,
                       "_custom_units.xlsx", sep = ""))
      
    }
    
    readline(
      prompt = "Press <enter> once attributes file and any custom units files have been edited, saved, and closed.")
    

  }

}

