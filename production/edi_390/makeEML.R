#update EMLassemblyline
remotes::install_github("EDIorg/EMLassemblyline")

# Load EMLassemblyline
library(EMLassemblyline)
library(tidyr)
library(dplyr)

# Make the wide table long

df_diversity <- read.csv('msb-diversity-tdbu-4sites-output-for-paper.csv', header = T, as.is = T)
df_location <- select(df_diversity, c(1:15))
write.csv(df_location, file = 'msb-diversity-samples.csv', row.names = F)
df_counts <- select(df_diversity, c(1, 16:2784))
df_long <- gather(df_counts, "OTU", "number", 2:2770)
#don't take 0 values out, as it would get rid of some parameters
write.csv(df_long, file = 'msb-diversity-OTU-counts.csv', row.names = F)
# Import templates
template_core_metadata(path = ".",
                       license = "CCBY")

template_table_attributes(path = '.',
                          data.table = c('Fungal_spdata_taxa_assignment.csv', 'msb-diversity-samples.csv', 'msb-diversity-OTU-counts.csv'))

template_categorical_variables(
  path = '.',
  data.path = '.',
  write.file = T
)

template_geographic_coverage(
  path = '.',
  data.path = '.',
  data.table = 'sitesgeography.csv',
  site.col = 'site_name',
  lat.col = 'site_lat',
  lon.col = 'site_lon'
)

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
         dataset.title = "Effects of Nutrient Supply, Herbivory, and Host Community on Fungal Endophyte Diversity, Kentucky, Iowa, Kansas, Minnesota, USA, 2014",
         temporal.coverage = c('2014-08-01', '2014-08-31'),
         maintenance.description = 'completed',
         data.table = c('Fungal_spdata_taxa_assignment.csv', 'msb-diversity-samples.csv', 'msb-diversity-OTU-counts.csv'),
         data.table.description = c('OTU taxonomy assignment', 'Sample parameters', 'OTU count values for each sample'),
         data.table.quote.character = c("\"", "\"", "\""),
         user.id = 'edi',
         user.domain = 'EDI',
         package.id = 'edi.390.1')
