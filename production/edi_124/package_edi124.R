# Create ecocomDP data package
#
# This script converts knb-lter-cdr.386.x to the ecocomDP, validates the 
# resultant tables, and creates the associated EML record.

path <- 'C:\\Users\\Colin\\Downloads\\edi_124'
parent_pkg_id <- 'knb-lter-cdr.386.8'
child_pkg_id <- 'edi.124.4'

package_edi275 <- function(path, parent_pkg_id, child_pkg_id){
  
  message(paste0('Converting ', parent_pkg_id, ' to ecocomDP (', child_pkg_id, ')' ))
  
  # Load libraries
  
  library(ecocomDP)
  
  # Create ecocomDP tables from parent data package
  
  convert_cdr386_to_ecocomDP(path, parent_pkg_id, child_pkg_id)
  
  # Validate ecocomDP tables
  
  message('Validating ecocomDP tables')
  
  ecocomDP::validate_ecocomDP(
    data.path = path
  )
  
  # Define variables found in the ecocomDP tables
  
  message('Defining ecocomDP variables')
  
  catvars <- ecocomDP::define_variables(
    data.path = path,
    parent.pkg.id = parent_pkg_id
  )
  
  use_i <- catvars$code == 'Mass..g.m2.'
  catvars$definition[use_i] <- 'Mass (g/m2)'
  catvars$unit[use_i] <- 'gramsPerSquareMeter'
  
  use_i <- catvars$code == 'treatment'
  catvars$definition[use_i] <- 'Heat treatment. Can be one of 3 values: "Control" = Metal shade above plot to simulate shading effects of lamps, "Low" = 600 W lamp, "High" = 1200 W lamp.'
  catvars$unit[use_i] <- 'NA'
  
  # Add contact information for the creator of this script
  
  additional_contact <- data.frame(
    givenName = 'Colin',
    surName = 'Smith',
    organizationName = 'Environmental Data Initiative',
    electronicMailAddress = 'colin.smith@wisc.edu',
    stringsAsFactors = FALSE
  )
  
  # Make EML
  
  message('Creating EML')
  
  ecocomDP::make_eml(
    data.path = path,
    code.path = path,
    code.files = 'convert_cdr386_to_ecocomDP.R',
    parent.package.id = parent_pkg_id,
    child.package.id = child_pkg_id,
    sep = '\t',
    cat.vars = catvars,
    user.id = 'csmith',
    affiliation = 'LTER',
    additional.contact = additional_contact
  )
  
}
