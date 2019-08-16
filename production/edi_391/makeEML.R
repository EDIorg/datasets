# Load EMLassemblyline
library(EMLassemblyline)
library(dplyr)
library(tidyr)

# Import templates
template_core_metadata(path = ".",
                       license = "CCBY")

template_table_attributes(path = '.',
                          data.table = c('LynnETAL2019_Ecography_ContDep.csv'))

#this doesn't seem to work
template_categorical_variables(
  path = '.',
  data.path = '.'
)

#get geographic information out of datafile

df <- read.csv('LynnETAL2019_Ecography_ContDep.csv', header = T, as.is = T)
df <- select(df, peak, Latitude, Longitude)
east_df <- df %>% group_by(peak) %>% summarise(eastBoundingCoordinate = min(Longitude)) %>% as.data.frame()
west_df <- df %>% group_by(peak) %>% summarise(westBoundingCoordinate = max(Longitude)) %>% as.data.frame()
south_df <- df %>% group_by(peak) %>% summarise(southBoundingCoordinate = min(Latitude)) %>% as.data.frame()
north_df <- df %>% group_by(peak) %>% summarise(northBoundingCoordinate = max(Latitude)) %>% as.data.frame()

geog_df <- left_join(north_df,south_df, by = "peak")
geog_df <- left_join(geog_df, north_df, by = "peak")
geog_df <- left_join(geog_df, east_df, by = "peak")
geog_df <- left_join(geog_df, west_df, by = "peak")

write.csv(geog_df, file = 'geographic_coverage.txt', row.names = F)

#not needed now

#template_geographic_coverage(
#  path = '.',
#  data.path = '.',
#  data.table = 'sitesgeography.csv',
#  site.col = 'site_name',
#  lat.col = 'site_lat',
#  lon.col = 'site_lon'
#)

template_taxonomic_coverage(
  path = '.',
  data.path = '.',
  taxa.table = 'taxa.csv',
  taxa.col = 'taxa',
  taxa.authority = c(3,11),
  taxa.name.type = 'both'
)

make_eml(path = ".",
         data.path = ".",
         dataset.title = "Data for Context-dependent biotic interactions control plant abundance across altitudinal environmental gradients, 2014, 2016, Colorado, USA ",
         temporal.coverage = c('2014-06-01', '2016-07-31'),
         maintenance.description = 'completed',
         data.table = c('LynnETAL2019_Ecography_ContDep.csv'),
         data.table.description = c('Grass abundance was estimated along three parallel 20 m transects placed perpendicular to the mountain slope.'),
         data.table.quote.character = "\"",
         user.id = 'edi',
         user.domain = 'EDI',
         package.id = 'edi.391.1')
