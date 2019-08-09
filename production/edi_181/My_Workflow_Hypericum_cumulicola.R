# This file is for you to script out your operations on the assembly line 
# thus making it easier to reproduce your work and trouble shoot any issues
# that may arise.

#running EMLassemblyline
#install.packages("devtools")
library(devtools)
#install_github("EDIorg/EMLassemblyline")
library(EMLassemblyline)

import_templates(path="C:\\Users\\Colin\\Documents\\EDI\\data_sets\\Hypericum_cumulicola",
                 license = "CCBY",
                 data.files = "Hypericum_cumulicola")

# View the standard unit dictionary (use values as they appear in the 'ID' column)
view_unit_dictionary()

define_catvars("C:\\Users\\Colin\\Documents\\EDI\\data_sets\\Hypericum_cumulicola")

make_eml(path = "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\Hypericum_cumulicola",
         dataset.title = "Demographic measures of Hypericum cumulicola (Hypericaceae) in 20 populations in Florida Rosemary Scrub patches with different time-since-fire, at Archbold Biological Station, Highlands County, Florida from 1994-2015",
         data.files = "Hypericum_cumulicola",
         data.files.description = "Demography of Hypericum_cumulicola",
         temporal.coverage = c("1994-07-01", "2015-08-30 "),
         geographic.description = "Highlands counties, Florida, USA",
         geographic.coordinates = c("27.12", "-81.34", "27.21", "-81.37"),
         maintenance.description = "completed", 
         user.id = "csmith",
         package.id = "edi.181.1")
