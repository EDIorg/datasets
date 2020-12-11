# This script executes an EMLassemblyline workflow.

library(EMLassemblyline)
library(dplyr)
library(tidyr)
library(stringr)


file_path <- "."

file_names <- c('First_pot_experiment_mass.csv',
                'First_pot_experiment_survival.csv',
                'Second_pot_experiment.csv',
                'Stable_isotopes.csv')

table_names <- str_replace_all(file_names, '\\.csv', '')
table_names <- str_replace_all(table_names, '_', ' ' )


dataset_title <- 'Invasive buffel grass (Cenchrus ciliaris) increases water stress and reduces growth of native foothills palo verde (Parkinsonia microphylla) seedlings in pot experiments'

file_descriptions <- table_names


quote_character <- rep("\"",4)

temp_cov <- c('2013-08-01', '2015-07-31')

maint_desc <- "completed"

user_id <- "EDI"
user_domain = 'EDI'

package_id <- "edi.642.2"

#geographic information
#use either this description or a .txt file generated below
#make sure these two paramters are then taken out of make_eml

#geog_descr <- "Field sites were located at the University of Arizona Desert Laboratory at Tumamoc Hill, and at Saguaro National Park Tucson Mountain District and Rincon Mountain District. Sites were all located on rocky slopes that had been invaded by buffel grass for at least a decade without experiencing fire or other major disturbance (Bowers et al. 2006; Abella et al. 2012). The buffel grass patches in the Tucson Mountains and Rincon Mountains had been there for 15-20 years (Abella et al. 2012), and the patch at the Tumamoc Hill study site was approximately 30 years old (Bowers et al. 2006). No livestock have grazed on Tumamoc Hill since 1907, or in Saguaro National park since 1976."

#coord_south <- 35.033131
#coord_east <- -83.162898
#coord_north <- 35.211960
#coord_west <- -83.362044

#geog_coord <- c(coord_north, coord_east, coord_south, coord_west)

#Template geographic coverage
template_geographic_coverage(
  path = file_path,
  data.path = file_path,
  data.table = 'sites.csv',
  site.col = 'site',
  lat.col = 'latitude',
  lon.col = 'longitude'
)

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
  #geographic.description = geog_descr,
  #geographic.coordinates = geog_coord,
  maintenance.description = maint_desc,
  data.table = file_names,
  data.table.name = table_names,
  data.table.description = file_descriptions,
  data.table.quote.character = quote_character,
  other.entity = c('First_pot_experiment_r.R',
                   'Second_pot_experiment_r.R',
                   'Stable_isotopes_r.R'),
  other.entity.name = c('First pot experiment R script',
                        'Second pot experiment R script',
                        'Stable isotopes R script'),
  other.entity.description = c('A script to analyze the seedling emergence, survival, and biomass attained in the first pot experiment',
                               'A script to analyze the seedling emergence, survival, and biomass attained in the second pot experiment',
                               'A script to compare delta_C_13 values between palo verde seedlings grown with and without mature and seedling buffel grass'),
  user.id = user_id,
  user.domain = user_domain,
  package.id = package_id
)
