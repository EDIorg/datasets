# Load EMLassemblyline
library(EMLassemblyline)
library(data.table)
library(rgdal)

parent_dir = '/Users/csmith/Documents/EDI/datasets/Archive'

# Import templates for an example dataset licensed under CC0, with 2 tables located in at "path"
import_templates(path = parent_dir,
                 license = "CCBY",
                 data.files = c("Dune_Plant_Survey_2012_Delta_Elev_2012_2014.csv",
                                "Dune_Plant_Survey_2014_Delta_Elev_2012_2014.csv",
                                'Foredune_Morphology_2012.csv',
                                'Foredune_Morphology_2014.csv'))


#### prep bounding_boxes.txt ####
dat = read.csv(file.path(parent_dir,'Dune_Plant_Survey_2012_Delta_Elev_2012_2014.csv'))
head(dat)
dat = dat[!is.na(dat$UTMx),]
coordinates(dat) <- ~UTMx+UTMy #similar to SpatialPoints
proj4string(dat) <- CRS('+proj=utm +zone=10 +ellps=GRS80 +units=m +no_defs') #assign projection and coordinate reference system

longlats <- spTransform(dat, CRS('+proj=longlat')) #transform


names(longlats)
df = data.frame(transect = longlats@data[,'Transect_Name'], lon = longlats@coords[,1], lat = longlats@coords[,2])
l = list()
for (ii in unique(df$transect)) {
  sub = subset(df, subset=transect==ii)
  l[[ii]] = c(geographicDescription = ii, 
              westBoundingCoordinate = min(sub$lon),	
              eastBoundingCoordinate = max(sub$lon),
              northBoundingCoordinate	= max(sub$lat),
              southBoundingCoordinate = min(sub$lat))
}
bounding_box_dat = do.call('rbind', l)
write.table(bounding_box_dat, file.path(parent_dir, 'bounding_boxes.txt'), sep = '\t', quote=F, row.names = F)


#### prep personnel.txt ####
pers = read.table(file.path(parent_dir, 'personnel.txt'), header=T)
pers
pers[1,] = c('Reuben','G','Biel','Department of Integrative Biology, Oregon State University', 'reuben.biel@gmail.com', '0000-0001-7489-7808', 'creator', '', '', '')
pers[2,] = c('Reuben','G','Biel','Department of Integrative Biology, Oregon State University', 'reuben.biel@gmail.com', '0000-0001-7489-7808', 'PI', '', 'US EPA', 'F13B20274')
pers[3,] = c('Reuben','G','Biel','Department of Integrative Biology, Oregon State University', 'reuben.biel@gmail.com', '0000-0001-7489-7808', 'contact', '', '', '')
pers[4,] = c('Sally','D','Hacker','Department of Integrative Biology, Oregon State University', 'hackers@science.oregonstate.edu', '0000-0002-5036-9629', 'PI', '', 'US EPA', 'R833836')
pers[5,] = c('Sally','D','Hacker','Department of Integrative Biology, Oregon State University', 'hackers@science.oregonstate.edu', '0000-0002-5036-9629', 'PI', '', 'US NOAA', 'NA15OAR4310243')
pers[6,] = c('Sally','D','Hacker','Department of Integrative Biology, Oregon State University', 'hackers@science.oregonstate.edu', '0000-0002-5036-9629', 'creator', '', '', '')
pers[7,] = c('Peter','','Ruggiero','College of Earth, Ocean, and Atmospheric Sciences, Oregon State University', 'pruggier@coas.oregonstate.edu', '0000-0001-7425-9953', 'PI', '', 'US EPA', 'R833836')
pers[8,] = c('Peter','','Ruggiero','College of Earth, Ocean, and Atmospheric Sciences, Oregon State University', 'pruggier@coas.oregonstate.edu', '0000-0001-7425-9953', 'PI', '', 'US NOAA', 'NA15OAR4310243')
pers[9,] = c('Lindsay','','Carroll','Department of Integrative Biology, Oregon State University', '', '', 'creator', '', '', '')
pers
write.table(pers, file.path(parent_dir, 'personnel.txt'), sep = '\t', quote=F, row.names = F)


#### prep keywords.txt ####
kw = read.table(file.path(parent_dir, 'keywords.txt'), header=T)
kw
kw[1,] = c('Ammophila arenaria','')
kw[2,] = c('Ammophila breviligulata','')
kw[3,] = c('beachgrass','')
kw[4,] = c('sand dune','')
kw[5,] = c('ecomorphodynamics','')
kw[6,] = c('ecogeomorphology','')
kw[7,] = c('ecosystem engineer','')
kw[8,] = c('coastal','')
kw[9,] = c('beach','')
kw[10,] = c('Ammophila arenaria','')
kw[11,] = c('dunes', 'https://vocab.lternet.edu/vocab/vocab/index.php')
kw[12,] = c('geomorphology', 'https://vocab.lternet.edu/vocab/vocab/index.php')
kw[13,] = c('sand', 'https://vocab.lternet.edu/vocab/vocab/index.php')
kw[14,] = c('plant ecology', 'https://vocab.lternet.edu/vocab/vocab/index.php')
kw[15,] = c('global positioning systems', 'https://vocab.lternet.edu/vocab/vocab/index.php')
kw[16,] = c('spatial methods', 'https://vocab.lternet.edu/vocab/vocab/index.php')
kw[17,] = c('transects', 'https://vocab.lternet.edu/vocab/vocab/index.php')
kw[18,] = c('topography', 'https://vocab.lternet.edu/vocab/vocab/index.php')
kw[19,] = c('accretion', 'https://vocab.lternet.edu/vocab/vocab/index.php')
kw[20,] = c('invasive species', 'https://vocab.lternet.edu/vocab/vocab/index.php')
kw

write.table(kw, file.path(parent_dir, 'keywords.txt'), sep = '\t', quote=F, row.names = F)



#### ABSTRACT #####
fileConn<-file(file.path(parent_dir,"abstract.txt"))

writeLines(
'These datasets documents our measurements of dune plant species abundance and topography from paired vegetation and topographic cross-shore foredune surveys in the United States Pacific Northwest (Oregon and southern Washington coastlines) in Summer 2012 and Summer 2014. In 2012, we conducted cross-shore paired topographic and vegetation surveys at 126 transect locations, and performed three replicate cross-shore transects per location (for a total of 378 transects). Of these surveys, 58 transect locations were positioned within Habitat Restoration Areas (as described in Biel et al. 2017). In 2014, we repeated these topographic and vegetation surveys at 83 of the 2012 transect locations (performing a single transect survey per location).,
,
Within each transect, we measure elevation (using RTK GPS) and plant species abundance (using 0.25 m^2 quadrats) at 5 m intervals between the vegetation line and the foredune heel. Within each quadrat, we measure the percent cover of all plant species present, and the tiller abundance of the three dune building grasses, Ammophila arenaria (invasive), Ammophila breviligulata (invasive), and Elymus mollis (native). Together, these datasets encompass measurements of elevation and plant abundance from 7953 quadrats in 2012, and 1616 quadrats in 2014.'
, fileConn)
close(fileConn)


#### METHODS #####
fileConn<-file(file.path(parent_dir,"methods.txt"))
writeLines(
'Detailed methods are described in Biel et al. 2017, Biel et al. 2019, and closely follow methods described by Zarnetske et al. 2012 and Seabloom et al. 1988.'
, fileConn)
close(fileConn)

#### Additional Info ####
fileConn<-file(file.path(parent_dir,"additional_info.txt"))
writeLines(c("Articles derived from this dataset:",
             " Biel, R. G., Hacker, S. D., Ruggiero, P., Cohn, N., and Seabloom, E. W.. 2017. Coastal protection and conservation on sandy beaches and dunes: context-dependent tradeoffs in ecosystem service supply. Ecosphere 8( 4):e01791. 10.1002/ecs2.1791 "), fileConn)
close(fileConn)

##### attributes
# attribute file templates
atts1 = fread(file.path(parent_dir, 'attributes_Dune_Plant_Survey_2012_Delta_Elev_2012_2014.txt'), header=T)
atts2 = fread(file.path(parent_dir, 'attributes_Dune_Plant_Survey_2014_Delta_Elev_2012_2014.txt'), header=T)

# attributes from accdb
att = fread('C:/Users/rgbiel/Desktop/test_doc_rptObjects3.txt', header=T)
unique(att$Property)
unique(att[,c('Name', 'Type')]) # fields

att_desc=att[Property=='Description:',]
att[Property=='RowSource:',]
att[Property=='ValidationRule:',]
unique(att$Property)

#### 2012 dataset attributes ####
tmp = merge(atts1, att_desc, by.x = 'attributeName', by.y = 'Name', all.x=T)
tmp$attributeDefinition = tmp$Value
tmp$Value <- c()
tmp$Property <- c()
tmp$Size <- c()
tmp$Type <- c()
tmp[,`missingValueCode`:= as.character(`missingValueCode`)]
tmp[,`missingValueCodeExplanation`:= as.character(`missingValueCodeExplanation`)]
tmp[,`dateTimeFormatString`:= as.character(`dateTimeFormatString`)]
tmp$missingValueCode = 'NaN'
tmp$missingValueCodeExplanation = 'Missing or unreadable observation'
tmp$dateTimeFormatString = ''

head(tmp)

# set descriptions
tmp[which(tmp$attributeName=='AMAR_STEM_L'),'attributeDefinition'] = 'AMMOPHILA ARENARIA LIVE STEM COUNT'
tmp[which(tmp$attributeName=='AMCH'),'attributeDefinition'] = 'AMBROSIA CHAMISSONIS - SILVER BEACHWEED'
tmp[which(tmp$attributeName=='ANOD'),'attributeDefinition'] = 'ANTHOXANTHUM ODORATUM'
tmp[which(tmp$attributeName=='ARPY'),'attributeDefinition'] = 'ARTEMISIA PYCNOCEPHALA - BEACH SAGEWORT'
tmp[which(tmp$attributeName=='CASO'),'attributeDefinition'] = 'CALYSTEGIA SOLDANELLA - BEACH MORNING GLORY'
tmp[which(tmp$attributeName=='CEAR'),'attributeDefinition'] = 'CERASTIUM ARVENSE - FIELD CHICKWEED'
tmp[which(tmp$attributeName=='CYSC'),'attributeDefinition'] = 'CYTISUS SCOPARIUS - SCOTCH BROOM'
tmp[which(tmp$attributeName=='ELMO_STEM_D'),'attributeDefinition'] = 'ELMYUS MOLLIS DEAD STEM COUNT'
tmp[which(tmp$attributeName=='FEAR'),'attributeDefinition'] = 'FESTUCA ARUNDINACEA - TALL FESCUE'
tmp[which(tmp$attributeName=='GASH'),'attributeDefinition'] = 'GAULTHERIA SHALLON - SALAL'
tmp[which(tmp$attributeName=='HIAL'),'attributeDefinition'] = 'HIERACIUM ALBIFLORUM - WHITE HAWKWEED'
tmp[which(tmp$attributeName=='HYBR_D'),'attributeDefinition'] = 'HYBRID AMMOPHILA PERCENT DEAD COVER'
tmp[which(tmp$attributeName=='ID'),'attributeDefinition'] = 'Unique ID'
tmp[which(tmp$attributeName=='LAJA'),'attributeDefinition'] = 'LATHYRUS JAPONICUS - BEACH PEA'
tmp[which(tmp$attributeName=='LEVU'),'attributeDefinition'] = 'LEUCANTHEMUM VULGARE - OX-EYED DAISY'
tmp[which(tmp$attributeName=='MEAR'),'attributeDefinition'] = 'MENTHA ARVENSIS - WILD MINT, FIELD MINT'
tmp[which(tmp$attributeName=='PLMA'),'attributeDefinition'] = 'PLANTAGO MARITIMA - GOOSE TONGUE, PACIFIC SEASIDE PLANTAIN'
tmp[which(tmp$attributeName=='POGL'),'attributeDefinition'] = 'POLYPODIUM GLYCYRRHIZA - LICORICE FERN'
tmp[which(tmp$attributeName=='RUAC'),'attributeDefinition'] = 'RUMEX ACETOSELLA - COMMON SHEEP SORREL'
tmp[which(tmp$attributeName=='SALIX_SPP'),'attributeDefinition'] = 'SALIX SPP - WILLOW SPECIES'
tmp[which(tmp$attributeName=='SHELL'),'attributeDefinition'] = 'SHELL HASH COVER'
tmp[which(tmp$attributeName=='STATION'),'attributeDefinition'] = 'Number of quadrats along transect from seaward-most quadrat'
tmp[which(tmp$attributeName=='STATION_METER'),'attributeDefinition'] = 'Surface distance along transect from seaward-most quadrat'
tmp[which(tmp$attributeName=='TABI'),'attributeDefinition'] = 'SHELL HASH COVER'
tmp[which(tmp$attributeName=='Transect_ID'),'attributeDefinition'] = 'unique ID value, ordered North to South'
tmp[which(tmp$attributeName=='Transect_Name'),'attributeDefinition'] = 'Name of the cross-shore transect'
tmp[which(tmp$attributeName=='UTMx'),'attributeDefinition'] = 'NAD83 (NA 2011) UTM 10N Easting'
tmp[which(tmp$attributeName=='UTMy'),'attributeDefinition'] = 'NAD83 (NA 2011) UTM 10N Northing'
tmp[which(tmp$attributeName=='zLMSL_2012'),'attributeDefinition'] = 'Elevation above local mean sea level in 2012'
tmp[which(tmp$attributeName=='zLMSL_2014'),'attributeDefinition'] = 'Elevation above local mean sea level in 2014'

tmp[which(tmp$attributeName=='LocBeach'),'attributeDefinition'] = 'Quadrat located on the backbeach (seaward of the dune toe)'
tmp[which(tmp$attributeName=='LocFace'),'attributeDefinition'] = 'Quadrat located on the seaward foredune face (between the dune toe and dune crest)'
tmp[which(tmp$attributeName=='LocCrest'),'attributeDefinition'] = 'Quadrat located within 10 meters of the foredune crest'
tmp[which(tmp$attributeName=='LocBack'),'attributeDefinition'] = 'Quadrat located on landward side of the foredune (between the crest and the heel)'
tmp[which(tmp$attributeName=='LocBeach'),'class'] = 'categorical'
tmp[which(tmp$attributeName=='LocFace'),'class'] = 'categorical'
tmp[which(tmp$attributeName=='LocCrest'),'class'] = 'categorical'
tmp[which(tmp$attributeName=='LocBack'),'class'] = 'categorical'
tmp[which(tmp$attributeName=='LocBeach'),'unit'] = ''
tmp[which(tmp$attributeName=='LocFace'),'unit'] = ''
tmp[which(tmp$attributeName=='LocCrest'),'unit'] = ''
tmp[which(tmp$attributeName=='LocBack'),'unit'] = ''

tmp[which(tmp$attributeName=='ROAD'), 'attributeDefinition'] = 'Quadrat located on road or path'
tmp[which(tmp$attributeName=='ROAD'), 'class'] = 'categorical'

tmp[which(tmp$attributeName=='Replicate_Name'),'attributeDefinition'] = 'Replicate cross-shore transect. 10N = 10m north of the center transect. 10S = 10m south of the center transect.'
tmp[which(tmp$attributeName=='Replicate'),'attributeDefinition'] = 'Replicate Transect ID: 1=10N replicate, 2 = center replicate, 3=10S replicate'
tmp[which(tmp$attributeName=='Replicate'),'unit'] = 'dimensionless'
tmp[which(tmp$attributeName=='REGION'),'attributeDefinition'] = 'Name of the region encompassing multiple transects'

# set units
tmp[which(nchar(tmp$attributeName)==4),'unit'] = 'pct areal cover'
tmp[which(tmp$attributeName=='ROAD'), 'unit'] = ''
tmp[grep('_L', tmp$attributeName), 'unit'] = 'pct areal cover'
tmp[grep('_D', tmp$attributeName), 'unit'] = 'pct areal cover'
tmp[grep('STEM', tmp$attributeName), 'unit'] = 'tillers per 0.25 m^2'
tmp[grep('zLMSL', tmp$attributeName), 'unit'] = 'meters'
tmp[grep('UTM', tmp$attributeName), 'unit'] = 'meters'
tmp[which(tmp$attributeName=='Transect_ID'), 'unit'] = 'dimensionless'
tmp[which(tmp$attributeName=='UNK_COUNT'), 'unit'] = 'number of unique, unidentified species'
tmp[which(tmp$attributeName=='STATION'), 'unit'] = 'dimensionless'
tmp[which(tmp$attributeName=='STATION_METER'), 'unit'] = 'meters'
tmp[which(tmp$attributeName=='SHELL'),'unit'] = 'pct areal cover'
tmp[which(tmp$attributeName=='LITTER'),'unit'] = 'pct areal cover'
tmp[which(tmp$attributeName=='SALIX_SPP'),'unit'] = 'pct areal cover'
tmp[grep('Loc', tmp$attributeName), 'class'] = 'categorical'
tmp[which(tmp$attributeName=='ID'),'unit'] = 'dimensionless'
tmp[which(tmp$attributeName=='END_METER'),'unit'] = 'meters'
tmp[which(tmp$attributeName=='UNKs'),'class'] = 'categorical'
tmp[which(tmp$attributeName=='UNKs'),'unit'] = ''


tmp[grep('Replicate',tmp$attributeName),'missingValueCodeExplanation'] = 'Transect-wide species richness survey'


# WRITE ATTS1 TABLE
write.table(as.data.frame(tmp), file.path(parent_dir, 'attributes_Dune_Plant_Survey_2012_Delta_Elev_2012_2014.txt'), sep = '\t', quote=F, row.names = F)

#### 2014 dataset attributes ####
tmp = merge(atts2, att_desc, by.x = 'attributeName', by.y = 'Name', all.x=T)
tmp$attributeDefinition = tmp$Value
tmp$Value <- c()
tmp$Property <- c()
tmp$Size <- c()
tmp$Type <- c()
tmp[,`missingValueCode`:= as.character(`missingValueCode`)]
tmp[,`missingValueCodeExplanation`:= as.character(`missingValueCodeExplanation`)]
tmp[,`dateTimeFormatString`:= as.character(`dateTimeFormatString`)]
tmp$missingValueCode = 'NaN'
tmp$missingValueCodeExplanation = 'Missing or unreadable observation'
tmp$dateTimeFormatString = ''

head(tmp)

# set descriptions
tmp[which(tmp$attributeName=='AMAR_STEM_L'),'attributeDefinition'] = 'AMMOPHILA ARENARIA LIVE STEM COUNT'
tmp[which(tmp$attributeName=='AMCH'),'attributeDefinition'] = 'AMBROSIA CHAMISSONIS - SILVER BEACHWEED'
tmp[which(tmp$attributeName=='ANOD'),'attributeDefinition'] = 'ANTHOXANTHUM ODORATUM'
tmp[which(tmp$attributeName=='ARPY'),'attributeDefinition'] = 'ARTEMISIA PYCNOCEPHALA - BEACH SAGEWORT'
tmp[which(tmp$attributeName=='CASO'),'attributeDefinition'] = 'CALYSTEGIA SOLDANELLA - BEACH MORNING GLORY'
tmp[which(tmp$attributeName=='CEAR'),'attributeDefinition'] = 'CERASTIUM ARVENSE - FIELD CHICKWEED'
tmp[which(tmp$attributeName=='CYSC'),'attributeDefinition'] = 'CYTISUS SCOPARIUS - SCOTCH BROOM'
tmp[which(tmp$attributeName=='ELMO_STEM_D'),'attributeDefinition'] = 'ELMYUS MOLLIS DEAD STEM COUNT'
tmp[which(tmp$attributeName=='FEAR'),'attributeDefinition'] = 'FESTUCA ARUNDINACEA - TALL FESCUE'
tmp[which(tmp$attributeName=='GASH'),'attributeDefinition'] = 'GAULTHERIA SHALLON - SALAL'
tmp[which(tmp$attributeName=='HIAL'),'attributeDefinition'] = 'HIERACIUM ALBIFLORUM - WHITE HAWKWEED'
tmp[which(tmp$attributeName=='HYBR_D'),'attributeDefinition'] = 'HYBRID AMMOPHILA PERCENT DEAD COVER'
tmp[which(tmp$attributeName=='ID'),'attributeDefinition'] = 'Unique ID'
tmp[which(tmp$attributeName=='LAJA'),'attributeDefinition'] = 'LATHYRUS JAPONICUS - BEACH PEA'
tmp[which(tmp$attributeName=='LEVU'),'attributeDefinition'] = 'LEUCANTHEMUM VULGARE - OX-EYED DAISY'
tmp[which(tmp$attributeName=='MEAR'),'attributeDefinition'] = 'MENTHA ARVENSIS - WILD MINT, FIELD MINT'
tmp[which(tmp$attributeName=='PLMA'),'attributeDefinition'] = 'PLANTAGO MARITIMA - GOOSE TONGUE, PACIFIC SEASIDE PLANTAIN'
tmp[which(tmp$attributeName=='POGL'),'attributeDefinition'] = 'POLYPODIUM GLYCYRRHIZA - LICORICE FERN'
tmp[which(tmp$attributeName=='RUAC'),'attributeDefinition'] = 'RUMEX ACETOSELLA - COMMON SHEEP SORREL'
tmp[which(tmp$attributeName=='SALIX_SPP'),'attributeDefinition'] = 'SALIX SPP - WILLOW SPECIES'
tmp[which(tmp$attributeName=='SHELL'),'attributeDefinition'] = 'SHELL HASH COVER'
tmp[which(tmp$attributeName=='STATION'),'attributeDefinition'] = 'Number of quadrats along transect from seaward-most quadrat'
tmp[which(tmp$attributeName=='STATION_METER'),'attributeDefinition'] = 'Surface distance along transect from seaward-most quadrat'
tmp[which(tmp$attributeName=='TABI'),'attributeDefinition'] = 'SHELL HASH COVER'
tmp[which(tmp$attributeName=='Transect_ID'),'attributeDefinition'] = 'unique ID value, ordered North to South'
tmp[which(tmp$attributeName=='Transect_Name'),'attributeDefinition'] = 'Name of the cross-shore transect'
tmp[which(tmp$attributeName=='UTMx'),'attributeDefinition'] = 'NAD83 (NA 2011) UTM 10N Easting'
tmp[which(tmp$attributeName=='UTMy'),'attributeDefinition'] = 'NAD83 (NA 2011) UTM 10N Northing'
tmp[which(tmp$attributeName=='zLMSL_2012'),'attributeDefinition'] = 'Elevation above local mean sea level in 2012'
tmp[which(tmp$attributeName=='zLMSL_2014'),'attributeDefinition'] = 'Elevation above local mean sea level in 2014'

tmp[which(tmp$attributeName=='LocBeach'),'attributeDefinition'] = 'Quadrat located on the backbeach (seaward of the dune toe)'
tmp[which(tmp$attributeName=='LocFace'),'attributeDefinition'] = 'Quadrat located on the seaward foredune face (between the dune toe and dune crest)'
tmp[which(tmp$attributeName=='LocCrest'),'attributeDefinition'] = 'Quadrat located within 10 meters of the foredune crest'
tmp[which(tmp$attributeName=='LocBack'),'attributeDefinition'] = 'Quadrat located on landward side of the foredune (between the crest and the heel)'
tmp[which(tmp$attributeName=='LocBeach'),'class'] = 'categorical'
tmp[which(tmp$attributeName=='LocFace'),'class'] = 'categorical'
tmp[which(tmp$attributeName=='LocCrest'),'class'] = 'categorical'
tmp[which(tmp$attributeName=='LocBack'),'class'] = 'categorical'
tmp[which(tmp$attributeName=='LocBeach'),'unit'] = ''
tmp[which(tmp$attributeName=='LocFace'),'unit'] = ''
tmp[which(tmp$attributeName=='LocCrest'),'unit'] = ''
tmp[which(tmp$attributeName=='LocBack'),'unit'] = ''

tmp[which(tmp$attributeName=='ROAD'), 'attributeDefinition'] = 'Quadrat located on road or path'
tmp[which(tmp$attributeName=='ROAD'), 'class'] = 'categorical'
tmp[which(tmp$attributeName=='GRAVEL'), 'attributeDefinition'] = 'Quadrat located on road or path'
tmp[which(tmp$attributeName=='GRAVEL'), 'class'] = 'categorical'
tmp[which(tmp$attributeName=='GRAVEL'),'unit'] = ''


tmp[which(tmp$attributeName=='Replicate_Name'),'attributeDefinition'] = 'Replicate cross-shore transect. 10N = 10m north of the center transect. 10S = 10m south of the center transect.'
tmp[which(tmp$attributeName=='Replicate'),'attributeDefinition'] = 'Replicate Transect ID: 1=10N replicate, 2 = center replicate, 3=10S replicate'
tmp[which(tmp$attributeName=='Replicate'),'unit'] = 'dimensionless'
tmp[which(tmp$attributeName=='REGION'),'attributeDefinition'] = 'Name of the region encompassing multiple transects'

# set units
tmp[which(nchar(tmp$attributeName)==4),'unit'] = 'pct areal cover'
tmp[which(tmp$attributeName=='ROAD'), 'unit'] = ''
tmp[grep('_L', tmp$attributeName), 'unit'] = 'pct areal cover'
tmp[grep('_D', tmp$attributeName), 'unit'] = 'pct areal cover'
tmp[grep('STEM', tmp$attributeName), 'unit'] = 'tillers per 0.25 m^2'
tmp[grep('zLMSL', tmp$attributeName), 'unit'] = 'meters'
tmp[grep('UTM', tmp$attributeName), 'unit'] = 'meters'
tmp[which(tmp$attributeName=='Transect_ID'), 'unit'] = 'dimensionless'
tmp[which(tmp$attributeName=='UNK_COUNT'), 'unit'] = 'number of unique, unidentified species'
tmp[which(tmp$attributeName=='STATION'), 'unit'] = 'dimensionless'
tmp[which(tmp$attributeName=='STATION_METER'), 'unit'] = 'meters'
tmp[which(tmp$attributeName=='SHELL'),'unit'] = 'pct areal cover'
tmp[which(tmp$attributeName=='LITTER'),'unit'] = 'pct areal cover'
tmp[which(tmp$attributeName=='SALIX_SPP'),'unit'] = 'pct areal cover'
tmp[grep('Loc', tmp$attributeName), 'class'] = 'categorical'
tmp[which(tmp$attributeName=='ID'),'unit'] = 'dimensionless'
tmp[which(tmp$attributeName=='END_METER'),'unit'] = 'meters'
tmp[which(tmp$attributeName=='UNKs'),'class'] = 'categorical'
tmp[which(tmp$attributeName=='UNKs'),'unit'] = ''


tmp[grep('Replicate',tmp$attributeName),'missingValueCodeExplanation'] = 'Transect-wide species richness survey'

# additions to 2012 dataset
tmp[which(tmp$attributeName=='FERU'),'attributeDefinition'] = 'FESTUCA RUBRA - RED FESCUE'
tmp[which(tmp$attributeName=='STLO'),'attributeDefinition'] = 'STELLARIA LONGIPES - LONGSTALK STARWORT'

# WRITE ATTS2 TABLE
write.table(as.data.frame(tmp), file.path(parent_dir, 'attributes_Dune_Plant_Survey_2014_Delta_Elev_2012_2014.txt'), sep = '\t', quote=F, row.names = F)


#### 
tmp = fread(file.path(parent_dir, 'attributes_Foredune_Morphology_2014.txt'))
tmp1 = fread(file.path(parent_dir, 'attributes_Dune_Plant_Survey_2014_Delta_Elev_2012_2014.txt'))

tmp[,`attributeDefinition`:= as.character(`attributeDefinition`)]
tmp[,`missingValueCode`:= as.integer(`missingValueCode`)]
tmp[,`missingValueCodeExplanation`:= as.character(`missingValueCodeExplanation`)]
tmp[,`dateTimeFormatString`:= as.character(`dateTimeFormatString`)]

tmp[which(tmp$attributeName=='Transect_Name')] = tmp1[which(tmp1$attributeName=='Transect_Name')]
tmp[which(tmp$attributeName=='Transect_ID')] = tmp1[which(tmp1$attributeName=='Transect_ID')]
tmp[which(tmp$attributeName=='Replicate')] = tmp1[which(tmp1$attributeName=='Replicate')]

tmp[,`missingValueCode`:= as.character(`missingValueCode`)]

tmp[,'missingValueCode'] = ''
tmp[,'dateTimeFormatString'] = ''
tmp[,'missingValueCodeExplanation'] = ''

tmp[which(tmp$attributeName=='Littoral_Cell'), 'attributeDefinition'] = 'Blocking factor for sites located in the same littoral or sublittoral cell'
tmp[which(tmp$attributeName=='Littoral_Cell'), 'unit'] = 'dimensionless'

tmp[which(tmp$attributeName=='HRABlock'), 'attributeDefinition'] = 'Blocking factor for sites located in the same habitat restoration area'
tmp[which(tmp$attributeName=='HRABlock'), 'unit'] = 'dimensionless'

tmp[which(tmp$attributeName=='HRA'), 'attributeDefinition'] = 'Indicator variable for sites that have undergone habitat restoration (beachgrass removal). 1 = removal occurred, 0 = No removal'
tmp[which(tmp$attributeName=='HRA'), 'unit'] = 'dimensionless'

tmp[which(tmp$attributeName=='start_UTMx'), 'attributeDefinition'] = 'NAD83 CORS96 easting coordinate marking the seaward-most point of assocated vegetation survey transects.'
tmp[which(tmp$attributeName=='start_UTMy'), 'attributeDefinition'] = 'NAD83 CORS96 northing coordinate marking the seaward-most point of assocated vegetation survey transects.'

tmp[which(tmp$attributeName=='end_UTMx'), 'attributeDefinition'] = 'NAD83 CORS96 easting coordinate marking the landward-most point of assocated vegetation survey transects.'
tmp[which(tmp$attributeName=='end_UTMy'), 'attributeDefinition'] = 'NAD83 CORS96 northing coordinate marking the landward-most point of assocated vegetation survey transects.'

tmp[which(tmp$attributeName=='shore_UTMx_data'), 'attributeDefinition'] = 'NAD83 CORS96 easting coordinate of the shoreline location (defined as MHW).'
tmp[which(tmp$attributeName=='shore_UTMy_data'), 'attributeDefinition'] = 'NAD83 CORS96 northing coordinate of the shoreline location (defined as MHW).'

tmp[which(tmp$attributeName=='backshore_beach_slope_data'), 'attributeDefinition'] = 'Slope between the shoreline and the foredune toe.'
tmp[which(tmp$attributeName=='backshore_beach_slope_4m_data'), 'attributeDefinition'] = 'Slope between the shoreline and the NAVD88 4m topographic contour of the foredune.'

tmp[which(tmp$attributeName=='backshore_width'), 'attributeDefinition'] = 'Horizontal distance between the shoreline and the foredune toe.'
tmp[which(tmp$attributeName=='backshore_width_4m'), 'attributeDefinition'] = 'Horizontal distance between the shoreline and the NAVD88 4m topographic contour of the foredune.'

tmp[which(tmp$attributeName=='dtoe_UTMx_data'), 'attributeDefinition'] = 'NAD83 CORS96 easting coordinate of the foredune toe (identified using the cubic approximation, described in Mull and Ruggiero 2014).'
tmp[which(tmp$attributeName=='dtoe_UTMy_data'), 'attributeDefinition'] = 'NAD83 CORS96 northing coordinate of the foredune toe location (identified using the cubic method, described in Mull and Ruggiero 2014).'
tmp[which(tmp$attributeName=='dtoe_elev_data'), 'attributeDefinition'] = 'Elevation of the foredune toe (m NAVD88).'

tmp[which(tmp$attributeName=='dtoe_4m_UTMx_data'), 'attributeDefinition'] = 'NAD83 CORS96 easting coordinate of the foredune toe (defined as an NAVD88 elevation of 4m - approx. 1.9m above local mean sea level).'
tmp[which(tmp$attributeName=='dtoe_4m_UTMy_data'), 'attributeDefinition'] = 'NAD83 CORS96 northing coordinate of the shoreline location (defined as an NAVD88 elevation of 4m - approx. 1.9m above local mean sea level).'

tmp[which(tmp$attributeName=='dcrest_UTMx_data'), 'attributeDefinition'] = 'NAD83 CORS96 easting coordinate of the foredune crest location.'
tmp[which(tmp$attributeName=='dcrest_UTMy_data'), 'attributeDefinition'] = 'NAD83 CORS96 northing coordinate of the foredune crest location.'
tmp[which(tmp$attributeName=='dcrest_elev_data'), 'attributeDefinition'] = 'Elevation of the foredune crest (m NAVD88).'


tmp[which(tmp$attributeName=='dheel_UTMx_data'), 'attributeDefinition'] = 'NAD83 CORS96 easting coordinate of the foredune crest location.'
tmp[which(tmp$attributeName=='dheel_UTMy_data'), 'attributeDefinition'] = 'NAD83 CORS96 northing coordinate of the foredune crest location.'
tmp[which(tmp$attributeName=='dheel_elev_data'), 'attributeDefinition'] = 'Elevation of the foredune crest (m NAVD88).'

tmp[which(tmp$attributeName=='foredune_width'), 'attributeDefinition'] = 'Horizontal distance between the foredune toe and the foredune heel.'

tmp[which(tmp$attributeName=='ST_SCR'), 'attributeDefinition'] = 'Short term rate of shoreline change. Derived from Ruggiero et al. 2013, UGSG OFR 2012-1007'
tmp[which(tmp$attributeName=='LT_SCR'), 'attributeDefinition'] = 'Long term rate of shoreline change. Derived from Ruggiero et al. 2013, UGSG OFR 2012-1007'

tmp[7:28,'unit'] = 'm'
tmp[29:30,'unit'] = 'm/yr'
tmp[grep('slope',tmp$attributeName),'unit'] = 'm/m'

tmp[,`missingValueCode`:= as.character(`missingValueCode`)]
tmp[,'missingValueCode'] = ''
tmp[,'dateTimeFormatString'] = ''
tmp[,'missingValueCodeExplanation'] = ''

tmp[grep('dheel',tmp$attributeName),'missingValueCode'] = 'NaN'
tmp[grep('dheel',tmp$attributeName),'missingValueCodeExplanation'] = 'dheel not identifiable from cross-shore topographic profile'
tmp[which(tmp$attributeName=='foredune_width'), 'missingValueCode'] = 'NaN'
tmp[which(tmp$attributeName=='foredune_width'), 'missingValueCodeExplanation'] = 'dheel not identifiable from cross-shore topographic profile'

# WRITE ATTS TABLE
write.table(as.data.frame(tmp), file.path(parent_dir, 'attributes_Foredune_Morphology_2014.txt'), sep = '\t', quote=F, row.names = F)


#### 2012 foredune morphology ####
tmp1 = tmp
tmp = fread(file.path(parent_dir, 'attributes_Foredune_Morphology_2012.txt'))


tmp[,`attributeDefinition`:= as.character(`attributeDefinition`)]
tmp[,`missingValueCode`:= as.character(`missingValueCode`)]
tmp[,`missingValueCodeExplanation`:= as.character(`missingValueCodeExplanation`)]
tmp[,`dateTimeFormatString`:= as.character(`dateTimeFormatString`)]

tmp[,'missingValueCode'] = ''
tmp[,'dateTimeFormatString'] = ''
tmp[,'missingValueCodeExplanation'] = ''

for (ii in tmp1[['attributeName']]) {
  tmp[which(tmp$attributeName==ii)] = tmp1[which(tmp1$attributeName==ii)]
}

tmp[which(tmp$attributeName=='median_sed_diam'), 'attributeDefinition'] = 'median sand grain size diameter at STATION 0.'
tmp[which(tmp$attributeName=='median_sed_diam'), 'unit'] = 'phi'
tmp[which(tmp$attributeName=='median_sed_diam'), 'missingValueCode'] = 'NaN'
tmp[which(tmp$attributeName=='median_sed_diam'), 'missingValueCodeExplanation'] = 'No data available'

tmp[which(tmp$attributeName=='mean_sed_diam'), 'attributeDefinition'] = 'median sand grain size diameter at STATION 0.'
tmp[which(tmp$attributeName=='mean_sed_diam'), 'unit'] = 'phi'
tmp[which(tmp$attributeName=='mean_sed_diam'), 'missingValueCode'] = 'NaN'
tmp[which(tmp$attributeName=='mean_sed_diam'), 'missingValueCodeExplanation'] = 'No data available'

tmp[which(tmp$attributeName=='sed_sorting'), 'attributeDefinition'] = 'sorting of grain size distribution at STATION 0.'
tmp[which(tmp$attributeName=='sed_sorting'), 'unit'] = 'phi'
tmp[which(tmp$attributeName=='sed_sorting'), 'missingValueCode'] = 'NaN'
tmp[which(tmp$attributeName=='sed_sorting'), 'missingValueCodeExplanation'] = 'No data available'

tmp[which(tmp$attributeName=='sed_skewness'), 'attributeDefinition'] = 'skewness of sediment grain size distribution at STATION 0.'
tmp[which(tmp$attributeName=='sed_skewness'), 'unit'] = 'phi'
tmp[which(tmp$attributeName=='sed_skewness'), 'missingValueCode'] = 'NaN'
tmp[which(tmp$attributeName=='sed_skewness'), 'missingValueCodeExplanation'] = 'No data available'

tmp[which(tmp$attributeName=='sed_kurtosis'), 'attributeDefinition'] = 'kurtosis of sediment grain size distribution at STATION 0.'
tmp[which(tmp$attributeName=='sed_kurtosis'), 'unit'] = 'phi'
tmp[which(tmp$attributeName=='sed_kurtosis'), 'missingValueCode'] = 'NaN'
tmp[which(tmp$attributeName=='sed_kurtosis'), 'missingValueCodeExplanation'] = 'No data available'


write.table(as.data.frame(tmp), file.path(parent_dir, 'attributes_Foredune_Morphology_2012.txt'), sep = '\t', quote=F, row.names = F)



##### Make EML #####
# Make EML for data and metadata templates co-located at path
make_eml(path = parent_dir,
         dataset.title = "United States Pacific Northwest surveys of coastal foredune topography and vegetation abundance, 2012-2014",
         data.files = c("Dune_Plant_Survey_2012_Delta_Elev_2012_2014",
                                     "Dune_Plant_Survey_2014_Delta_Elev_2012_2014",
                                     'Foredune_Morphology_2012',
                                     'Foredune_Morphology_2014'),
         data.files.description = c("2012 dune plant survey data.", 
                                    "2014 dune plant survey data.",
                                    "2012 foredune morphology data.",
                                    "2014 foredune morphology data."),
         temporal.coverage = c("2012-06-01", "2014-10-01"),
         maintenance.description = "completed", 
         user.id = "csmith",
         affiliation = "LTER",
         package.id = "edi.276.4")
