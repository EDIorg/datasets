
# Set parameters for data tables ----------------------------------------------

# Data table names

table_names <- trimws(c("LAGOSNE_buffer100m_105.csv",
                        "LAGOSNE_buffer100m_lulc105.csv",
                        "LAGOSNE_buffer500m_105.csv",
                        "LAGOSNE_buffer500m_conn105.csv",
                        "LAGOSNE_buffer500m_lulc105.csv",
                        "LAGOSNE_county_105.csv",
                        "LAGOSNE_county_chag105.csv",
                        "LAGOSNE_county_conn105.csv",
                        "LAGOSNE_county_lulc105.csv",
                        "LAGOSNE_edu_105.csv",
                        "LAGOSNE_edu_chag105.csv",
                        "LAGOSNE_edu_conn105.csv",
                        "LAGOSNE_edu_lulc105.csv",
                        "LAGOSNE_hu4_105.csv",
                        "LAGOSNE_hu4_chag105.csv",
                        "LAGOSNE_hu4_conn105.csv",
                        "LAGOSNE_hu4_lulc105.csv",
                        "LAGOSNE_hu8_105.csv",
                        "LAGOSNE_hu8_chag105.csv",
                        "LAGOSNE_hu8_conn105.csv",
                        "LAGOSNE_hu8_lulc105.csv",
                        "LAGOSNE_hu12_105.csv",
                        "LAGOSNE_hu12_chag105.csv",
                        "LAGOSNE_hu12_conn105.csv",
                        "LAGOSNE_hu12_lulc105.csv",
                        "LAGOSNE_iws_105.csv",
                        "LAGOSNE_iws_conn105.csv",
                        "LAGOSNE_iws_lulc105.csv",
                        "LAGOSNE_lakesgeo105.csv",
                        "LAGOSNE_state_105.csv",
                        "LAGOSNE_state_chag105.csv",
                        "LAGOSNE_state_conn105.csv",
                        "LAGOSNE_state_lulc105.csv"))

# Data table descriptions (order must follow the above listing of tables).

data_table_descriptions <-trimws(c("100 m buffer area",
                                   "100 m land use/cover",
                                   "500 m buffer area",
                                   "500 m connectivity",
                                   "500 m land use/cover",
                                   "County information",
                                   "County scale measures of climate, hydrology, atmospheric deposition, and geology",
                                   "County scale measures of connectivity",
                                   "County scale measures of land use/cover",
                                   "Ecological drainage unit information",
                                   "Ecological drainage unit scale measures of climate, hydrology, atmospheric deposition, and geology",
                                   "Ecological drainage unit scale measures of connectivity",
                                   "Ecological drainage unit scale measures of land use/cover",
                                   "HU4 information",
                                   "HU4 scale measures of climate, hydrology, atmospheric deposition, and geology",
                                   "HU4 scale measures of connectivity",
                                   "HU4 scale measures of land use/cover",
                                   "HU8 information",
                                   "HU8 scale measures of climate, hydrology, atmospheric deposition, and geology",
                                   "HU8 scale measures of connectivity",
                                   "HU8 scale measures of land use/cover",
                                   "HU12 information",
                                   "HU12 scale measures of climate, hydrology, atmospheric deposition, and geology",
                                   "HU12 scale measures of connectivity",
                                   "HU12 scale measures of land use/cover",
                                   "IWS information",
                                   "IWS scale measures of connectivity",
                                   "IWD scale measures of land use/cover",
                                   "Lake geographic information",
                                   "State information",
                                   "State scale measures of climate, hydrology, atmospheric deposition, and geology",
                                   "State scale measures of connectivity",
                                   "State scale measures of land use/cover"))

# New attribute names?
# If yes then entries must must follow the listed order of table_names.
# If no, then leave the list empty.

new_attribute_names <- list(trimws(c()),
                           trimws(c()))

# URLs of data tables (order must follow the above listing of tables)

data_table_urls <- trimws(c("https://lter.limnology.wisc.edu/sites/default/files/data/LAGOS_NE_GEO_EXPORT/LAGOSNE_buffer100m_105.csv",
                            "https://lter.limnology.wisc.edu/sites/default/files/data/LAGOS_NE_GEO_EXPORT/LAGOSNE_buffer100m_lulc105.csv",
                            "https://lter.limnology.wisc.edu/sites/default/files/data/LAGOS_NE_GEO_EXPORT/LAGOSNE_buffer500m_105.csv",
                            "https://lter.limnology.wisc.edu/sites/default/files/data/LAGOS_NE_GEO_EXPORT/LAGOSNE_buffer500m_conn105.csv",
                            "https://lter.limnology.wisc.edu/sites/default/files/data/LAGOS_NE_GEO_EXPORT/LAGOSNE_buffer500m_lulc105.csv",
                            "https://lter.limnology.wisc.edu/sites/default/files/data/LAGOS_NE_GEO_EXPORT/LAGOSNE_county_105.csv",
                            "https://lter.limnology.wisc.edu/sites/default/files/data/LAGOS_NE_GEO_EXPORT/LAGOSNE_county_chag105.csv",
                            "https://lter.limnology.wisc.edu/sites/default/files/data/LAGOS_NE_GEO_EXPORT/LAGOSNE_county_conn105.csv",
                            "https://lter.limnology.wisc.edu/sites/default/files/data/LAGOS_NE_GEO_EXPORT/LAGOSNE_county_lulc105.csv",
                            "https://lter.limnology.wisc.edu/sites/default/files/data/LAGOS_NE_GEO_EXPORT/LAGOSNE_edu_105.csv",
                            "https://lter.limnology.wisc.edu/sites/default/files/data/LAGOS_NE_GEO_EXPORT/LAGOSNE_edu_chag105.csv",
                            "https://lter.limnology.wisc.edu/sites/default/files/data/LAGOS_NE_GEO_EXPORT/LAGOSNE_edu_conn105.csv",
                            "https://lter.limnology.wisc.edu/sites/default/files/data/LAGOS_NE_GEO_EXPORT/LAGOSNE_edu_lulc105.csv",
                            "https://lter.limnology.wisc.edu/sites/default/files/data/LAGOS_NE_GEO_EXPORT/LAGOSNE_hu4_105.csv",
                            "https://lter.limnology.wisc.edu/sites/default/files/data/LAGOS_NE_GEO_EXPORT/LAGOSNE_hu4_chag105.csv",
                            "https://lter.limnology.wisc.edu/sites/default/files/data/LAGOS_NE_GEO_EXPORT/LAGOSNE_hu4_conn105.csv",
                            "https://lter.limnology.wisc.edu/sites/default/files/data/LAGOS_NE_GEO_EXPORT/LAGOSNE_hu4_lulc105.csv",
                            "https://lter.limnology.wisc.edu/sites/default/files/data/LAGOS_NE_GEO_EXPORT/LAGOSNE_hu8_105.csv",
                            "https://lter.limnology.wisc.edu/sites/default/files/data/LAGOS_NE_GEO_EXPORT/LAGOSNE_hu8_chag105.csv",
                            "https://lter.limnology.wisc.edu/sites/default/files/data/LAGOS_NE_GEO_EXPORT/LAGOSNE_hu8_conn105.csv",
                            "https://lter.limnology.wisc.edu/sites/default/files/data/LAGOS_NE_GEO_EXPORT/LAGOSNE_hu8_lulc105.csv",
                            "https://lter.limnology.wisc.edu/sites/default/files/data/LAGOS_NE_GEO_EXPORT/LAGOSNE_hu12_105.csv",
                            "https://lter.limnology.wisc.edu/sites/default/files/data/LAGOS_NE_GEO_EXPORT/LAGOSNE_hu12_chag105.csv",
                            "https://lter.limnology.wisc.edu/sites/default/files/data/LAGOS_NE_GEO_EXPORT/LAGOSNE_hu12_conn105.csv",
                            "https://lter.limnology.wisc.edu/sites/default/files/data/LAGOS_NE_GEO_EXPORT/LAGOSNE_hu12_lulc105.csv",
                            "https://lter.limnology.wisc.edu/sites/default/files/data/LAGOS_NE_GEO_EXPORT/LAGOSNE_iws_105.csv",
                            "https://lter.limnology.wisc.edu/sites/default/files/data/LAGOS_NE_GEO_EXPORT/LAGOSNE_iws_conn105.csv",
                            "https://lter.limnology.wisc.edu/sites/default/files/data/LAGOS_NE_GEO_EXPORT/LAGOSNE_iws_lulc105.csv",
                            "https://lter.limnology.wisc.edu/sites/default/files/data/LAGOS_NE_GEO_EXPORT/LAGOSNE_lakesgeo105.csv",
                            "https://lter.limnology.wisc.edu/sites/default/files/data/LAGOS_NE_GEO_EXPORT/LAGOSNE_state_105.csv",
                            "https://lter.limnology.wisc.edu/sites/default/files/data/LAGOS_NE_GEO_EXPORT/LAGOSNE_state_chag105.csv",
                            "https://lter.limnology.wisc.edu/sites/default/files/data/LAGOS_NE_GEO_EXPORT/LAGOSNE_state_conn105.csv",
                            "https://lter.limnology.wisc.edu/sites/default/files/data/LAGOS_NE_GEO_EXPORT/LAGOSNE_state_lulc105.csv"))

# Enter date range of dataset
#
# Format must be: "YYYY-MM-DD"

begin_date <- trimws("1925-07-24")

end_date <- trimws("2013-10-27")

# Define table formatting (order must follow the above listing of tables)

num_header_lines <- trimws(c(rep("1", 33)))

record_delimeter <- trimws(c(rep("\\r\\n", 33)))

attribute_orientation <- trimws(c(rep("column", 33)))

field_delimeter <- trimws(c(rep(",", 33)))


# Set parameters for spatial vectors ------------------------------------------

# Name of zipped vector folder(s) names

spatial_vector_names <- trimws(c())

# Description(s) of Zipped vector folder contents (order must follow the above listing of zipped vector folder(s) names).

spatial_vector_description <-trimws(c())

# URL(s) of Zipped vector folder(s) (order must follow the above listing of zipped vector folder(s)).

spatial_vector_urls <- trimws(c())

# Define spatial vector formatting (order must follow the above listing of zipped vector folder(s) names).

num_header_lines_sv <- trimws(c())

record_delimeter_sv <- trimws(c())

attribute_orientation_sv <- trimws(c())

field_delimeter_sv <- trimws(c())

# Enter size of .zip files IN BYTES (order must follow the above listing of zipped vector folder(s) names).

spatial_vector_sizes <- trimws(c())

# Geometry of spatial data (order must follow the above listing of zipped vector folder(s) names).

spatial_vector_geometry <- trimws(c())


# Set additional parameters -------------------------------------------------

# Dataset title

dataset_title <- trimws("LAGOS-NE-GEO v1.05: A module for LAGOS-NE, a multi-scaled geospatial and temporal database of lake ecological context and water quality for thousands of U.S. Lakes: 1925-2013")

# Dataset keywords

keywords <- trimws(c("Macrosystems Biology", "MSB",
                     "Cross-scale Interactions", "CSI",
                     "National Science Foundation", "NSF",
                     "lakes", "multi-scaled", "geospatial", "geography", "temporal", "database",
                     "LAGOS", "LAGOS-NE", "nutrients", "dissolved nutrients", "inorganic nutrients",
                     "water quality", "water properties", "water clarity",
                     "chlorophyll", "ecological context", "lake trophic state", "eutrophication"))

# Geographic information
#
# Enter these as decimal degrees.
#
# If more than one set of bounding coordinates exists, enter these into the
# spread sheet "datasetname_spatial_bounds.xlsx".
#
# If the there are many geographical points that describe sampling sites (e.g.
# many lakes spread over a continent) repeat the lattidudinal value in both
# the North and South fields, and likewise repeat the longitudinal value in
# both the East and West fields.

geographic_location <- "Northeastern and upper Midwestern U.S. states, including: Minnesota, Iowa, Wisconsin, Illinois, Indiana, Missouri, Michigan, Ohio, Pennsylvania, New York, Connecticut, Rhode Island, New Hampshire, Vermont, Maine, New Jersey, New York"

coordinate_north <- 49.3477 

coordinate_east <- -66.99892

coordinate_south <- 34.61761

coordinate_west <- -97.90363

# Funding information

funding_title = trimws(c("The effect of cross-scale interactions on freshwater ecosystem state across space and time."))

funding_grants = trimws("National Science Foundation EF-1065786, EF-1065818, EF-1065649")

# Set root level info

data_package_id <- trimws("edi.63.2")

root_system <- "https://pasta.lternet.edu"

schema_location <- "eml://ecoinformatics.org/eml-2.1.1  http://nis.lternet.edu/schemas/EML/eml-2.1.1/eml.xsd"

maintenance_description <- "complete"

# Set access

author_system <- "edi"

allow_principals <- trimws(c("uid=csmith,o=LTER,dc=ecoinformatics,dc=org",
                             "public"))

allow_permissions <- trimws(c("all",
                              "read")) # order follows allow_principals

access_order <- trimws("allowFirst")

access_scope <- trimws("document")

