# This script executes an EMLassemblyline workflow.

library(EMLassemblyline)
library(dplyr)
library(tidyr)
library(stringr)

file_path <- "."

file_names <- c('above_veg.csv',
                'below_veg.csv',
                'herb_veg___litter_quant.csv',
                'leaf_c_n.csv',
                'N_mineralization.csv',
                'sites.csv',
                'soil.csv')

dataset_title <- 'Forest Invasibility in Communities in Southeastern New York'

file_descriptions <- c('Data on woody vegetation cover above the 1 m height transect line',
                       'Data on woody vegetation cover below the 1 m height transect line',
                       'Data on abundance of herbaceous vegetation (and seedlings of woody species), sampled using 1m x 1m plots, and on litter quantity',
                       'Data on carbon and nitrogen content of angiosperm leaves',
                       'Data on nitrogen mineralization rates',
                       'List of study sites with GPS coordinates',
                       'Data on soil mineral components')
                       

quote_character <- rep("\"",7)

temp_cov <- c('1998-07-24', '1998-09-21')

maint_desc <- "completed"

user_id <- "EDI"

package_id <- "edi.538.1"

#geographic information
#use either this description or a .txt file generated below
#make sure these two paramters are then taken out of make_eml

geog_descr <- 'Suffolk county and Westchester county, southeastern New York state, USA'

coord_south <- 40.85437
coord_east <- -72.28023
coord_north <- 41.18667
coord_west <- -73.67050

geog_coord <- c(coord_north, coord_east, coord_south, coord_west)

#fix the sampling date

df_sites <- read.csv('sites.csv', header = T, as.is = T)
df_sites$Date_Surveyed <- paste(df_sites$Date_Surveyed, '1998', sep = '-')
df_sites$Date_Surveyed <- as.Date(df_sites$Date_Surveyed, format = "%d-%b-%Y")
write.csv(df_sites, file = 'sites1.csv', row.names = F)

template_core_metadata(
  path = file_path,
  license = 'CCBY'
)


template_table_attributes(
  path = file_path,
  data.path = file_path,
  data.table = file_names
)

#generate the attribute description from taxon name table
df_above <- read.table('attributes_above_veg.txt', header = T, as.is = T, sep = '\t')
df_taxon <- read.csv('taxon.csv', header = T, as.is = T)
df_both <- left_join(df_above, df_taxon, by = c('attributeName'='abbreviation'))
df_both$attributeDefinition <- paste('Abundance of ', df_both$taxon, ', ', df_both$Common_name, sep = '' )
df_both$unit <- 'dimensionless'
df_save <- select(df_both, -taxon, -Common_name)
write.table(df_save, file = 'attributes_above_veg1.txt', sep = '\t', row.names = F)


df_below <- read.table('attributes_below_veg.txt', header = T, as.is = T, sep = '\t')
df_taxon <- read.csv('taxon.csv', header = T, as.is = T)
df_both <- left_join(df_below, df_taxon, by = c('attributeName'='abbreviation'))
df_both$attributeDefinition <- paste('Abundance of ', df_both$taxon, ', ', df_both$Common_name, sep = '' )
df_both$unit <- 'dimensionless'
df_save <- select(df_both, -taxon, -Common_name)
write.table(df_save, file = 'attributes_below_veg1.txt', sep = '\t', row.names = F)


df_herb <- read.table('attributes_herb_veg___litter_quant.txt', header = T, as.is = T, sep = '\t')
df_taxon <- read.csv('taxon.csv', header = T, as.is = T)
df_both <- left_join(df_herb, df_taxon, by = c('attributeName'='abbreviation'))
df_both$attributeDefinition <- paste('Abundance of ', df_both$taxon, ', ', df_both$Common_name, sep = '' )
df_both$unit <- 'dimensionless'
df_save <- select(df_both, -taxon, -Common_name)
write.table(df_save, file = 'attributes_herb_veg___litter_quant1.txt', sep = '\t', row.names = F)

template_categorical_variables(
  path = file_path,
  data.path = file_path
)


template_taxonomic_coverage(
  path = file_path,
  data.path = file_path,
  taxa.table = 'taxon.csv',
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
  data.table.description = file_descriptions,
  data.table.quote.character = quote_character,
  other.entity = 'protocol.pdf',
  other.entity.description = 'methods used for this study',
  user.id = 'edi',
  user.domain = 'EDI',
  package.id = package_id
)
