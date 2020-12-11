# This script executes an EMLassemblyline workflow.

library(EMLassemblyline)
library(dplyr)
library(tidyr)
library(stringr)

file_path <- "."

file_names <- c('Controls_1997-2018_v17.csv',
                'NERACOOS_data.csv',
                'Salisbury_data.csv')

dataset_title <- 'Data and R scripts for analyses of declines in invertebrate species from the Gulf of Maine, USA, 1997 - 2018'

file_descriptions <- c('Recruitment data from control plot',
                       'Monthly average temperatures at 1 m depth',
                       'Yearly averages in pH and aragonite saturation ratio')

quote_character <- rep("\"",3)

temp_cov <- c("1997-01-01","2018-12-31")

maint_desc <- "completed"

user_id <- "EDI"

package_id <- "edi.507.1"

#geographic information
#use either this description or a .txt file generated below
#make sure these two paramters are then taken out of make_eml

geog_descr <- "Data were collected from 12 unmanipulated control plots on Swans Island, a small island (approx. 36 km2 in area) in the Gulf of Maine, USA. The 12 sites are spread over four different bays on Swans Island, which are Mackerel Cove, Seal Cove, Toothacker Cove, and Burnt Coat Harbor.  Most sites are more than 1 km apart; the two closest sites are slightly less than 1 km apart. All plots are in the mid intertidal zone."

coord_south <- 44.128690
coord_east <- -68.383570
coord_north <- 44.191442
coord_west <- -68.503708

geog_coord <- c(coord_north, coord_east, coord_south, coord_west)


template_core_metadata(
  path = file_path,
  license = 'CCBY'
)


# romove that stupid special characterat the beginning of the file

# df <- read.csv('VegCoverDataRMBL2014.csv')

# colnames(df)[colnames(df)=="ÃƒÂ¯..Gradient"] <- "Gradient"

# write.csv(df, file = 'VegCoverDataRMBL2014.csv', row.names = F)

template_table_attributes(
  path = file_path,
  data.path = file_path,
  data.table = file_names
)

template_categorical_variables(
  path = file_path,
  data.path = file_path
)

# template_geographic_coverage(
#   path = file_path,
#   data.path = file_path,
#   data.table = 'sites_lat_long.csv',
#   site.col = 'Site',
#   lat.col = 'Lat',
#   lon.col = 'Long'
# )
# 
# df <- read.csv('taxonInfo.csv', header = T, as.is = T)
# df <- distinct(df, taxon_name)
# write.csv(df, file = 'taxonInfo.csv', row.names = F)

template_taxonomic_coverage(
  path = file_path,
  data.path = file_path,
  taxa.table = 'taxonInfo.csv',
  taxa.col = 'taxon_name',
  taxa.authority = c(3,11),
  taxa.name.type = 'both'
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
  other.entity = c('AA_Poisson_regressions.R',
                   'BB_Clean_up_environmental_data.R',
                   'CC_Find_best_envir_model_for_recruits.R',
                   'DD_Find_best_envir_model_for counts.R'),
  other.entity.description = c('Script for Bayesian estimates from Poisson regressions for recruitment and abundance data versus year.  Year entered as a fixed effect; Sites entered as random effect. Uses data file Control_1997-2018_v17.csv. Run using MCMCglmm package, version 2.29.', 
                               'Cleans up environmental data and imputes missing values. Uses NERACOOS_data.csv and Salisbury_data.csv and produces two files, Env_data_for_recruits.csv and Env_data_for_counts.csv. Imputation done using Amelia, version 1.7.6.',
                               'R script has three steps: 1) finds the best model for predicting recruitment from environmental data using MuMIn package (version 1.43.15), 2) imputes missing values in best model using Amelia (version 1.7.6), and 3) obtains pooled estimates using Zelig (version 5.1.6.1).  Uses Controls_1997-2018.csv and Env_data_for_recruits.csv.',
                               'Does the same as CC_Find_best_envir_model_for_recruits.R but for abundance data.  Uses Controls_1997-2018.csv and Env_data_for_counts.csv.'),
  user.id = 'edi',
  user.domain = 'EDI',
  package.id = package_id
)
