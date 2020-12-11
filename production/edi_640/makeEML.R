# This script executes an EMLassemblyline workflow.

library(EMLassemblyline)
library(dplyr)
library(tidyr)
library(stringr)


file_path <- "."

file_names <- c('FIeld_emergence.csv',
                'Field_survival.csv')

table_names <- c('Field emergence',
                 'Field survival')


dataset_title <- 'Native seedlings recorded on field plots with and without invasive buffel grass during the monsoon season of 2013 near Tucson, Arizona, USA'

file_descriptions <- c('Field emergence',
                       'Field survival')


quote_character <- rep("\"",2)

temp_cov <- c('2013-07-01', '2013-09-01')

maint_desc <- "completed"

user_id <- "EDI"
user_domain = 'EDI'

package_id <- "edi.640.1"

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
  other.entity = c('Field_emergence_r.R',
                   'Field_survival_r.R'),
  other.entity.name = c('Field emergence R script',
                        'Field survival R script'),
  other.entity.description = c('A script to test how perennial emergence changed as a function of plot type and site using a generalized linear mixed model (GLMM), including a random intercept for spatial block (each block consisting of one of each type of plot, all within a few meters of one another), with a log link function and a zero-inflated negative binomial error structure . To determine the importance of plot type overall, the script uses an analysis of deviance between models with and without plot type. To compare the effect of plot type on emergence, the script uses linear contrasts from the model that included plot type',
                               'A script to test whether the weekly survival rate of native seedlings varied with plot type (buffel grass, removal, or uninvaded) using a Cox proportional hazard mixed-effects model, including plot type, site, and week of germination as fixed effect, and spatial block as a random effect'),
  user.id = user_id,
  user.domain = user_domain,
  package.id = package_id
)
