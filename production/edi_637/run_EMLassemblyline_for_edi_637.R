# This script executes an EMLassemblyline workflow.

# Initialize workspace --------------------------------------------------------

library(EMLassemblyline)

# Define paths for your metadata templates, data, and EML

path_templates <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_637\\metadata_templates"
path_data <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_637\\data_objects"
path_eml <- "C:\\Users\\Colin\\Documents\\EDI\\data_sets\\edi_637\\eml"

# Create metadata templates ---------------------------------------------------

# Create core templates (required for all data packages)

EMLassemblyline::template_core_metadata(
  path = path_templates,
  license = "CCBY",
  file.type = ".docx")

# Create table attributes template (required when data tables are present)

EMLassemblyline::template_table_attributes(
  path = path_templates,
  data.path = path_data,
  data.table = c("Agkistrodon_contortrix.csv",
                 "Carphophis_vermis.csv",
                 "Coluber_constrictor.csv",
                 "Crotalus_horridus.csv",
                 "Lampropeltis_calligaster.csv",
                 "Lampropeltis_holbrooki.csv",
                 "Lampropeltis_triangulum.csv",
                 "Nerodia_sipedon.csv",
                 "Pantherophis_emoryi.csv",
                 "Pantherophis_obsoletus.csv",
                 "Pituophis_catenifer.csv",
                 "Storeria_dekayi.csv",
                 "Thamnophis_sirtalis.csv",
                 "Virginia_valeriae.csv"))

# Create categorical variables template (required when attributes templates
# contains variables with a "categorical" class)

EMLassemblyline::template_categorical_variables(
  path = path_templates, 
  data.path = path_data)

# Create taxonomic coverage template (Not-required. Use this to report 
# taxonomic entities in the metadata)

library(taxonomyCleanr)

r <- resolve_sci_taxa(
  x = c("Coluber constrictor", "Lampropeltis calligaster", 
        "Lampropeltis triangulum", "Lampropeltis holbrooki", 
        "Pantherophis emoryi", "Pantherophis obsoletus", 
        "Pituophis catenifer", "Agkistrodon contortrix", 
        "Crotalus horridus", "Carphophis vermis", "Nerodia sipedon", 
        "Storeria dekayi", "Thamnophis sirtalis", "Virginia valeriae"),
  data.sources = 3)

make_taxonomicCoverage(
  taxa.clean = r$taxa_clean,
  rank = r$rank, 
  authority = r$authority, 
  authority.id = r$authority_id, 
  path = path_templates)

# Make EML from metadata templates --------------------------------------------

# Once all your metadata templates are complete call this function to create 
# the EML.

EMLassemblyline::make_eml(
  path = path_templates,
  data.path = path_data,
  eml.path = path_eml, 
  dataset.title = "University of Kansas Field Station: Cumulative field records of snake species collected by Dr. Henry S. Fitch 1948 - 2003, with a few additional records collected 2004 - 2016. Records contain capture locations, measurements, notes on reproduction, recapture, and growth data. This data package contains individual files for 14 species.", 
  temporal.coverage = c("1948-01-01", "2016-01-01"), 
  geographic.description = "The University of Kansas Field Station is located in eastern Kansas just north of Lawrence, Kansas, in the prairie-forest ecotone region of the central USA.", 
  geographic.coordinates = c("39.085468", "-95.134409", "38.995391", "-95.249891"), 
  maintenance.description = "Data collection is complete. No updates are expected.", 
  data.table = c("Agkistrodon_contortrix.csv",
                 "Carphophis_vermis.csv",
                 "Coluber_constrictor.csv",
                 "Crotalus_horridus.csv",
                 "Lampropeltis_calligaster.csv",
                 "Lampropeltis_holbrooki.csv",
                 "Lampropeltis_triangulum.csv",
                 "Nerodia_sipedon.csv",
                 "Pantherophis_emoryi.csv",
                 "Pantherophis_obsoletus.csv",
                 "Pituophis_catenifer.csv",
                 "Storeria_dekayi.csv",
                 "Thamnophis_sirtalis.csv",
                 "Virginia_valeriae.csv"), 
  data.table.name = c("Fitch snake data - Agkistrodon contortrix (Copperhead)",
                      "Fitch snake data - Carphophis vermis (Western Worm Snake)",
                      "Fitch snake data - Coluber constrictor (North American Racer)",
                      "Fitch snake data - Crotalus horridus (Timber Rattlesnake)",
                      "Fitch snake data - Lampropeltis calligaster (Yellow-bellied Kingsnake)",
                      "Fitch snake data - Lampropeltis holbrooki (Speckled Kingsnake)",
                      "Fitch snake data - Lampropeltis triangulum (Milksnake)",
                      "Fitch snake data - Nerodia sipedon (Northern Watersnake)",
                      "Fitch snake data - Pantherophis emoryi (Great Plains Ratsnake)",
                      "Fitch snake data - Pantherophis obsoletus (Western Ratsnake)",
                      "Fitch snake data - Pituophis catenifer (Gophersnake)",
                      "Fitch snake data - Storeria dekayi (Dekay's Brownsnake)",
                      "Fitch snake data - Thamnophis sirtalis (Common Gartersnake)",
                      "Fitch snake data - Virginia valeriae (Smooth Earthsnake)"),
  data.table.description = c("University of Kansas Field Station: Capture locations and measurements of snakes collected by Henry S. Fitch, 1949 - 2003: Agkistrodon contortrix (Copperhead)",
                             "University of Kansas Field Station: Capture locations and measurements of snakes collected by Henry S. Fitch, 1949 - 1997: Carphophis vermis (Western Worm Snake)",
                             "University of Kansas Field Station: Capture locations and measurements of snakes collected by Henry S. Fitch, 1948 - 2003: Coluber constrictor (North American Racer)",
                             "University of Kansas Field Station: Capture locations and measurements of snakes collected by Henry S. Fitch, 1948 - 2016: Crotalus horridus (Timber Rattlesnake)",
                             "University of Kansas Field Station: Capture locations and measurements of snakes collected by Henry S. Fitch, 1949 - 2004: Lampropeltis calligaster (Yellow-bellied Kingsnake)",
                             "University of Kansas Field Station: Capture locations and measurements of snakes collected by Henry S. Fitch, 1949 - 1974: Lampropeltis holbrooki (Speckled Kingsnake)",
                             "University of Kansas Field Station: Capture locations and measurements of snakes collected by Henry S. Fitch, 1950 - 2003: Lampropeltis triangulum (Milksnake)",
                             "University of Kansas Field Station: Capture locations and measurements of snakes collected by Henry S. Fitch, 1949 - 2003: Nerodia sipedon (Northern Watersnake)",
                             "University of Kansas Field Station: Capture locations and measurements of snakes collected by Henry S. Fitch, 1959 - 2002: Pantherophis emoryi (Great Plains Ratsnake)",
                             "University of Kansas Field Station: Capture locations and measurements of snakes collected by Henry S. Fitch, 1948 - 2003: Pantherophis obsoletus (Western Ratsnake)",
                             "University of Kansas Field Station: Capture locations and measurements of snakes collected by Henry S. Fitch, 1949 - 1995: Pituophis catenifer (Gophersnake)",
                             "University of Kansas Field Station: Capture locations and measurements of snakes collected by Henry S. Fitch, 1950 - 2001: Storeria dekayi (Dekay's Brownsnake)",
                             "University of Kansas Field Station: Capture locations and measurements of snakes collected by Henry S. Fitch, 1949 - 2006: Thamnophis sirtalis (Common Gartersnake)",
                             "University of Kansas Field Station: Capture locations and measurements of snakes collected by Henry S. Fitch and others, 1964 - 2010: Virginia valeriae (Smooth Earthsnake)"),
  data.table.quote.character = c('"','"','"','"','"','"','"','"','"','"','"','"','"','"'),
  user.id = "csmith",
  user.domain = "LTER", 
  package.id = "edi.637.1")
