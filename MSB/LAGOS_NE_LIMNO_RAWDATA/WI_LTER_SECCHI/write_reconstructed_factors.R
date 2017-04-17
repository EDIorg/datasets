#' Write data table factors
#'
#' @description  A function for writting data table factors from reconstructed attributes
#'
#' @usage write_factors(path, table.name)
#'
#' @param path Path to the directory containing the .xml file.
#' @param table.name Name of data table that attributes file has been written for.
#'
#' @return A .xlsx file in the specified working directory containing an approximated set
#' of factors based on the user supplied attributes.xlsx. The user is prompted to refine
#' this table.
#'


write_reconstructed_factors <- function(path, table.name) {
  
  # Issue warning
  
  answer <- readline(
    "Are you sure you want to build new factors? This will overwrite your previous work! (y or n):  ")
  
  if (answer == "y"){
    
    # Parameterize function
    
    library("EML")
    library("xlsx")
    library("rmarkdown")
    
    # Get system information
    
    sysinfo <- Sys.info()["sysname"]
    if (sysinfo == "Darwin"){
      os <- "mac"
    } else {
      os <- "win"
    }
    
    # Identify the attribute files
    
    attribute_file <- paste(substr(table.name, start = 1, stop = (nchar(table.name) - 4)),
                            "_attributes.xlsx",
                            sep = "")
    
    if (length(attribute_file) == 0){
      print("No attribute files found ... run write_attributes() to create them.")
    }
    
    # Set file names
    
    fname_table_factor <- paste(
      substr(table.name, 1, nchar(table.name) - 4),
      "_factors.xlsx",
      sep = "")
    
    fname_table_attributes <- c()
    for (i in 1:length(table.name)){
      fname_table_attributes[i] <- paste(
        substr(table.name, 1, nchar(table.name) - 4),
        "_attributes.xlsx",
        sep = ""
      )
    }
    
    # Loop through data tables ------------------------------------------------
      
    if (!is.na(match(
      paste(substr(attribute_file, 1, nchar(attribute_file) - 16),
            ".csv",
            sep = ""),
      table.name)) == T){
      
      
      print(paste("Now working on ... ",
                  attribute_file, sep = ""))
      
      # Read attributes file
      
      attributes <- read.xlsx2(
        paste(
          path,
          "/",
          attribute_file,
          sep = ""),
        sheetIndex = 1,
        colClasses = c(rep("character",7),
                       rep("numeric",2),
                       rep("character",2)))
      
      for (j in 1:dim(attributes)[2]){
        if (class(attributes[ ,j]) == "factor"){
          attributes[ ,j] <- as.character(attributes[ ,j])
        }
      }
      
      # Build factor table
      
      factors_I <- which(attributes$columnClasses %in% "factor")
      
      df_table <- read.csv(
        paste(
          path,
          "/",
          substr(attribute_file, 1, nchar(attribute_file) - 16),
          ".csv",
          sep = ""),
        header=TRUE,
        sep=",",
        quote="\"",
        as.is=TRUE)
      
      # If there are no factors then skip to the next file
      
      if (length(factors_I) > 0){
        
        rows <- 0
        for (j in 1:length(factors_I)){
          factor_names <- unique(
            eval(
              parse(
                text = paste(
                  "df_table",
                  "$",
                  attributes$attributeName[factors_I[j]],
                  sep = ""))))
          
          rows <- length(factor_names) + rows
          
        }
        
        factors <- data.frame(attributeName = character(rows),
                              code = character(rows),
                              definition = character(rows),
                              stringsAsFactors = F)
        
        row <- 1
        for (j in 1:length(factors_I)){
          
          factor_names <- unique(
            eval(
              parse(
                text = paste(
                  "df_table",
                  "$",
                  attributes$attributeName[factors_I[j]],
                  sep = ""))))
          
          factors$attributeName[row:(length(factor_names)+row-1)] <-
            attributes$attributeName[factors_I[j]]
          
          factors$code[row:(length(factor_names)+row-1)] <- factor_names
          
          row <- row + length(factor_names)
          
        }
        
        # Write factor table
        
        write.xlsx(factors,
                   paste(path,
                         "/",
                         substr(attribute_file, 1, nchar(attribute_file) - 16),
                         "_factors.xlsx",
                         sep = ""),
                   col.names = T,
                   row.names = F,
                   showNA = F)
        
        # Prompt the user to manually edit the factors file and custom unit files.
        
        standardUnits <- get_unitList()
        View(standardUnits$units)
        
        if (os == "mac"){
          
          system(paste("open",
                       paste(
                         path,
                         "/",
                         fname_table_factor,
                         sep = "")))
          
          system(paste("open ",
                       path,
                       "/",
                       substr(template, 1, nchar(template) - 14),
                       "_custom_units.csv", sep = ""))
          
        } else if (os == "win"){
          
          shell.exec(paste(path,"/",
                           substr(attribute_file,
                                  1,
                                  nchar(attribute_file) - 16),
                           "_factors.xlsx",
                           sep = ""))
          
          shell.exec(paste(path,"/",
                           substr(template,
                                  1,
                                  nchar(template) - 14),
                           "_custom_units.xlsx", sep = ""))
          
        }
        
        readline(
          prompt = "Press <enter> once factors file and any custom units files have been edited, saved, and closed."
        )
      }
      
    }
    
  }
  
}

