# This script executes an EMLassemblyline workflow.

library(EMLassemblyline)
library(dplyr)
library(tidyr)
library(stringr)


file_path <- "."

file_names <- c('chlorophylla.csv',
                'distance_weighted_population_metrics.csv',
                'fatty_acid.csv',
                'invertebrates.csv',
                'metadata.csv',
                'microplastics.csv',
                'nutrients.csv',
                'periphyton.csv',
                'ppcp.csv',
                'stable_isotopes.csv',
                'total_lipid.csv')

table_names <- c('Chlorophyll data',
                'Inverse-distance-weighted population',
                'Fatty Acid profiles',
                'Macroinvertebrate species counts',
                'site-associated metadata',
                'Microplastics',
                'Nutrient data',
                'Periphyton abundance data',
                'Pharmaceutical and Personal Care Product (PPCP) data',
                'Stable Isotopes data',
                'Total Lipid data')


dataset_title <- 'A unified dataset of co-located sewage pollution, periphyton, and benthic macroinvertebrate community and food web structure from Lake Baikal (Siberia)'

file_descriptions <- c('Chlorophyll a data for each littoral and pelagic sampling locations along Lake Baikal’s southwestern shoreline.',
                       'Population data for each of the sampled locations. Although the majority of sites do not contain adjacent developments, we calculated inverse-distance-weighted population for each location based on neighboring settlements.',
                       'Fatty acid concentrations for various benthic macroinvertebrate genera, periphyton, and endemic Draparnaldia spp. benthic algae collected from the 14 littoral sampling locations.',
                       'Benthic macroinvertebrate abundance data.',
                       'Metadata for each of the sampled locations.',
                       'Microplastics counts for each of the pelagic and littoral sampling locations.',
                       'Nutrient data for each of the associated sampling locations.',
                       'Periphyton abundance data for each of the sampled littoral sites.',
                       'PPCP concentrations for each of the associated sampling locations.',
                       'Carbon and nitrogen stable isotope data within periphyton and macroinvertebrate tissue for each of the associated sampling locations.',
                       'Lipid gravimetry data for periphyton and benthic macroinvertebrate tissue for each of the associated sampling locations.')


quote_character <- rep("\"",11)

temp_cov <- c('2015-08-19', '2015-08-23')

maint_desc <- "completed"

user_id <- "EDI"
user_domain = 'EDI'

package_id <- "edi.677.1"

#geographic information
#use either this description or a .txt file generated below
#make sure these two paramters are then taken out of make_eml

geog_descr <- "Southwestern shore of Lake Baikal between the town of Listvyanka and the village of Bolshoe Goloustnoe"

coord_south <- 51.85530
coord_east <- 105.4724
coord_north <- 52.02693
coord_west <- 104.8148

geog_coord <- c(coord_north, coord_east, coord_south, coord_west)

#Template geographic coverage
# template_geographic_coverage(
#   path = file_path,
#   data.path = file_path,
#   data.table = 'sites.csv',
#   site.col = 'site',
#   lat.col = 'latitude',
#   lon.col = 'longitude'
# )

template_core_metadata(
  path = file_path,
  license = 'CCBY'
)


template_table_attributes(
  path = file_path,
  data.path = file_path,
  data.table = file_names
)

template_categorical_variables(
  path = file_path,
  data.path = file_path
)

df_taxa <- read.csv('taxa.csv', header = T, as.is = T)
df_taxa <- distinct(df_taxa)
write.csv(df_taxa, file = 'taxa.csv', row.names = F)

template_taxonomic_coverage(
  path = file_path,
  data.path = file_path,
  taxa.table = 'taxa.csv',
  taxa.col = 'taxon',
  taxa.authority = c(3,11),
  taxa.name.type = 'scientific'
)

make_eml(
  path = file_path,
  data.path = file_path,
  eml.path = file_path,
  dataset.title = dataset_title,
  temporal.coverage = temp_cov,
  geographic.description = geog_descr,
  geographic.coordinates = geog_coord,
  maintenance.description = maint_desc,
  data.table = file_names,
  data.table.name = table_names,
  data.table.description = file_descriptions,
  data.table.quote.character = quote_character,
  other.entity = c('Baikal_shapefile.kml',
                   'scripts.zip',
                   'protocol.pdf'),
  other.entity.name = c('Locations of Lakeside Development',
                        'R scripts',
                        'Methods'),
  other.entity.description = c('Polygons of each lakeside development’s perimeter and line geometries of each development’s shorelines from satellite imagery for each developed site in Google Earth',
                               'All R scripts used in analysis',
                               'Methods used in this study'),
  user.id = user_id,
  user.domain = user_domain,
  package.id = package_id
)
