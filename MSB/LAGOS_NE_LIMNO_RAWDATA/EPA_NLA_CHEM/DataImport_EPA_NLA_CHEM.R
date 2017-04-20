#set path to files
setwd("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/EPA national surveys/IN-LAKE DATA/DataImport_EPA_NLA_CHEM")
setwd("C:/Users/Sam/Dropbox/CSI-LIMNO_DATA/DATA-lake/EPA national surveys/IN-LAKE DATA/DataImport_EPA_NLA_CHEM")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/EPA national surveys/IN-LAKE DATA/DataImport_EPA_NLA_CHEM/DataImport_EPA_NLA_CHEM.RData")


LAGOS_Template = data.frame(LakeID=character(0),
                            LakeName=character(0),
                            SourceVariableName=character(0),
                            SourceVariableDescription=character(0),
                            SourceFlags=character(0),
                            LagosVariableID=integer(0),
                            LagosVariableName=character(0),
                            Value=numeric(0),
                            Units=character(0),
                            CensorCode=character(0),
                            DetectionLimit=numeric(0),
                            Date=character(0),
                            LabMethodName=character(0),
                            LabMethodInfo=character(0),
                            SampleType=character(0),
                            SamplePosition=character(0),
                            SampleDepth=numeric(0),
                            MethodInfo=character(0),
                            BasinType=character(0),
                            Subprogram=character(0),
                            Comments=character(0),
                            Dup=numeric(0))

#################################### General Notes ########################################################################################################################################
#large scale lake survey by the epa during the 2007 sampling season
#nla=national lake assessment, a water quality monitoring effort
#this data set is a mess: water chem sampes are integrated and should be taken between 0 and 2m
#if the euphotic zone <2m then the integrated depth is specified
#each variable has another flag column attached to it. see meta for flag meanings and record in import log
#a variable may also have an "altert" attached to it
#be cautious in filtering the data
###########################################################################################################################################################################################
################################### DOC #############################################################################################################################
data=EPA_NLA_CHEM
names(data) #looking at column names
#fiter out columns of interest
data=data[,c(1,6:8,14:16,30:32)]
names(data) #looking at column names
unique(data$DOC)#looking for problematic special characters
#checking for null values
length(data$DOC[which(data$DOC=="")])
length(data$DOC[which(data$DOC==".")])
length(data$DOC[which(is.na(data$DOC)==TRUE)])
#no null values
unique(data$SAMPLE_CATEGORY)
length(data$SAMPLE_CATEGORY[which(data$SAMPLE_CATEGORY=="D")])
1326-74 #remove those 74 obs that are duplicates, 1252 should remain
data=data[which(data$SAMPLE_CATEGORY!="D"),]
#check to make sure all obs have a lakeid
unique(data$SITE_ID)#all have a site id, multiple missing value identifiers tested
length(data$SITE_ID[which(data$SITE_ID=="")])
#check to make sure all have a date attached
unique(data$DATE_COL)#all have a date attached, multiple missing value identifiers tested
length(data$DATE_COL[which(data$DATE_COL==".")])
#look at sample depths
unique(data$SAMPLE_DEPTH) #there are NA values deal with later
length(data$SAMPLE_DEPTH[which(is.na(data$SAMPLE_DEPTH)==TRUE)])
#10 OBS MISSING DATA ON SAMPLE DEPTH
#look at flag information
unique(data$DOC_FLAG) #no flags here
unique(data$DOC_RL_ALERT) #no observations below reporting limit
length(data$DOC_RL_ALERT[which(data$DOC_RL_ALERT=="N")]) #1252 adds to total

#done filtering

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$SITE_ID
data.Export$LakeName = NA #textual lake name not specified in source data
data.Export$SourceVariableName = "DOC"
data.Export$SourceVariableDescription = "Dissolved organic carbon"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags= NA #no source flags associated with DOC
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 6
data.Export$LagosVariableName="Carbon, dissolved organic"
names(data)
data.Export$Value = data[,8] #export doc values already in preff. units of mg/L
data.Export$CensorCode = "NC" #no info on CensorCode
data.Export$Date = data$DATE_COL #date already in correct format
data.Export$Units="mg/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"#per metadata
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
#assign sampledepth 
unique(data$SAMPLE_DEPTH)#looking at depths to see if there are any problematic values
length(data$SAMPLE_DEPTH[which(is.na(data$SAMPLE_DEPTH)==TRUE)]) #depths missing for 10 observations=okay because sample position specified
data.Export$SampleDepth=data$SAMPLE_DEPTH
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)]) #check to make sure proper number are NA
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==FALSE)])
1242+10#adds to total
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
unique(data.Export$SampleDepth) #none are >50 so all obs are "PRIMARY" except if depth is NA
data.Export$BasinType[which(is.na(data$SAMPLE_DEPTH)==FALSE)]="PRIMARY"
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) #check to make sure CORRECT NUMBER populated
data.Export$BasinType[which(is.na(data$SAMPLE_DEPTH)==TRUE)]="UNKNOWN"
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")])
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= .20 #per meta data
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments= NA
doc.Final = data.Export
rm(data.Export)
rm(data)


################################### TOC #############################################################################################################################
data=EPA_NLA_CHEM
names(data) #looking at column names
#fiter out columns of interest
data=data[,c(1,6:8,14:16,27:29,109:110)]
names(data) #looking at column names
unique(data$TOC)#looking for problematic special characters
#checking for null values
length(data$TOC[which(data$TOC=="")])
length(data$TOC[which(data$TOC==".")])
length(data$TOC[which(is.na(data$TOC)==TRUE)])
#no null values
unique(data$SAMPLE_CATEGORY)
length(data$SAMPLE_CATEGORY[which(data$SAMPLE_CATEGORY=="D")])
1326-74 #remove those 74 obs that are duplicates, 1252 should remain
data=data[which(data$SAMPLE_CATEGORY!="D"),]
#check to make sure all obs have a lakeid
unique(data$SITE_ID)#all have a site id, multiple missing value identifiers tested
length(data$SITE_ID[which(data$SITE_ID==".")])
#check to make sure all have a date attached
unique(data$DATE_COL)#all have a date attached, multiple missing value identifiers tested
length(data$DATE_COL[which(data$DATE_COL==".")])
#look at sample depths
unique(data$SAMPLE_DEPTH) #there are NA values deal with later
#look at flag information
unique(data$TOC_FLAG) #no flags here
unique(data$TOC_RL_ALERT) #no observations below reporting limit
length(data$TOC_RL_ALERT[which(data$TOC_RL_ALERT=="N")]) #1252 adds to total

#done filtering

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$SITE_ID
data.Export$LakeName = NA #textual lake name not specified in source data
data.Export$SourceVariableName = "TOC"
data.Export$SourceVariableDescription = "Total organic carbon"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags= NA #no source flags associated with TOC
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 7
data.Export$LagosVariableName="Carbon, total organic"
names(data)
data.Export$Value = data[,8] #export toc values already in preff. units of mg/L
data.Export$CensorCode = "NC" #no info on CensorCode
data.Export$Date = data$DATE_COL #date already in correct format
data.Export$Units="mg/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"#per metadata
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
#assign sampledepth 
unique(data$SAMPLE_DEPTH)#looking at depths to see if there are any problematic values
length(data$SAMPLE_DEPTH[which(is.na(data$SAMPLE_DEPTH)==TRUE)]) #depths missing for 10 observations=okay because sample position specified
data.Export$SampleDepth=data$SAMPLE_DEPTH
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)]) #check to make sure proper number are NA
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==FALSE)])
1242+10#adds to total
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
unique(data.Export$SampleDepth) #none are >50 so all obs are "PRIMARY" except if depth is NA
data.Export$BasinType[which(is.na(data$SAMPLE_DEPTH)==FALSE)]="PRIMARY"
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) #check to make sure CORRECT NUMBER populated
data.Export$BasinType[which(is.na(data$SAMPLE_DEPTH)==TRUE)]="UNKNOWN"
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")])
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= .20 #per meta data
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments= NA
toc.Final = data.Export
rm(data.Export)
rm(data)


################################### CHLA #############################################################################################################################
data=EPA_NLA_CHEM
names(data) #looking at column names
#fiter out columns of interest
data=data[,c(1,6:8,14:16,112:123)]
names(data) #looking at column names
unique(data$CHLA)#looking for problematic special characters
#checking for null values
length(data$CHLA[which(data$CHLA=="")])
length(data$CHLA[which(data$CHLA==".")])
length(data$CHLA[which(is.na(data$CHLA)==TRUE)]) #5 values are NA
data=data[which(is.na(data$CHLA)==FALSE),]
1326-5 #1321 should remain
#no null values
unique(data$SAMPLE_CATEGORY)
length(data$SAMPLE_CATEGORY[which(data$SAMPLE_CATEGORY=="D")])
1321-74 #remove those 74 obs that are duplicates, 1247 should remain
data=data[which(data$SAMPLE_CATEGORY!="D"),]
#check to make sure all obs have a lakeid
unique(data$SITE_ID)#all have a site id, multiple missing value identifiers tested
length(data$SITE_ID[which(data$SITE_ID==".")])
#check to make sure all have a date attached
unique(data$DATECHLA)#all have a date attached, multiple missing value identifiers tested
length(data$DATECHLA[which(data$DATECHLA=="")])
#look at sample depths
unique(data$SAMPLE_DEPTH) #there are NA values deal with later
#look at flag information
unique(data$CHLA_RL_ALERT) #flags which are "Y" should have a Censor Code of "LT"
length(data$CHLA_RL_ALERT[which(data$CHLA_RL_ALERT=="Y")]) #only one obs below reporting limit
unique(data$FLAG_FLD_CHLA) #8 unique flags for field observations
length(data$FLAG_FLD_CHLA[which(data$FLAG_FLD_CHLA=="K")]) #these are obs. that could not be determined
1247-7 #should be left with 1240
data=data[which(data$FLAG_FLD_CHLA!="K"),] #filter out "K" observations
unique(data$FLAG_LAB_CHLA) #one unique flag for lab analysis
unique(data$CHLA_HT_ALERT) #if yes then there is a holding time alert
length(data$CHLA_HT_ALERT[which(data$CHLA_HT_ALERT=="Y")]) #183 have holding time alerts

#done filtering

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$SITE_ID
data.Export$LakeName = NA #textual lake name not specified in source data
data.Export$SourceVariableName = "CHLA"
data.Export$SourceVariableDescription = "Chlorophyll a"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags[which(data$FLAG_FLD_CHLA=="U")]= "U"
data.Export$SourceFlags[which(data$FLAG_FLD_CHLA=="IM")]= "IM"
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==FALSE)])
unique(data.Export$SourceFlags)
#continue populating other lagos variables
data.Export$LagosVariableID = 9
data.Export$LagosVariableName="Chlorophyll a"
names(data)
data.Export$Value = data[,11] #export CHLA OBS. already in preff units of ug/l
#assign censor code
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$CHLA_RL_ALERT=="Y")]="LT"
unique(data.Export$CensorCode)
#continue with other fields
data.Export$Date = data$DATECHLA #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"#per metadata
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
#assign sampledepth 
unique(data$SAMPLE_DEPTH)#looking at depths to see if there are any problematic values
length(data$SAMPLE_DEPTH[which(is.na(data$SAMPLE_DEPTH)==TRUE)]) #depths missing for 4 observations=okay because sample position specified
data.Export$SampleDepth=data$SAMPLE_DEPTH
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)]) #check to make sure proper number are NA
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==FALSE)])
1236+4#adds to total
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
unique(data.Export$SampleDepth) #none are >50 so all obs are "PRIMARY" except if depth is NA
data.Export$BasinType[which(is.na(data$SAMPLE_DEPTH)==FALSE)]="PRIMARY"
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) #check to make sure CORRECT NUMBER populated
data.Export$BasinType[which(is.na(data$SAMPLE_DEPTH)==TRUE)]="UNKNOWN"
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")])
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= 3 #per meta data
data.Export$Comments=as.character(data.Export$Comments)
length(data$CHLA_HT_ALERT[which(data$CHLA_HT_ALERT=="Y")]) #183 will have the comment below
data.Export$Comments[which(data$CHLA_HT_ALERT=="Y")]= "Holding time for this water sample was >28 days"
length(data$CHLA[which(data$FLAG_FLD_CHLA=="IM" & data$CHLA_HT_ALERT=="Y")])
length(data$CHLA[which(data$FLAG_FLD_CHLA=="U" & data$CHLA_HT_ALERT=="Y")])
data.Export$Comments[which(data.Export$SourceFlags=="U")]="U=nonstandard measurement"
data.Export$Comments[which(data.Export$SourceFlags=="IM")]="IM= missing sample volumes on the field form"
chla.Final = data.Export
rm(data.Export)
rm(data)


################################### COLOR #############################################################################################################################
data=EPA_NLA_CHEM
names(data) #looking at column names
#fiter out columns of interest
data=data[,c(1,6:8,14:16,75:77,109:111)]
names(data) #looking at column names
unique(data$COLOR)#looking for problematic special characters
#checking for null values
length(data$COLOR[which(data$COLOR=="")])
length(data$COLOR[which(data$COLOR==".")])
length(data$COLOR[which(is.na(data$COLOR)==TRUE)])
#no null values
unique(data$SAMPLE_CATEGORY)
length(data$SAMPLE_CATEGORY[which(data$SAMPLE_CATEGORY=="D")])
1326-74 #remove those 74 obs that are duplicates, 1252 should remain
data=data[which(data$SAMPLE_CATEGORY!="D"),]
#check to make sure all obs have a lakeid
unique(data$SITE_ID)#all have a site id, multiple missing value identifiers tested
length(data$SITE_ID[which(data$SITE_ID=="")])
#check to make sure all have a date attached
unique(data$DATE_COL)#all have a date attached, multiple missing value identifiers tested
length(data$DATE_COL[which(data$DATE_COL==".")])
#look at sample depths
unique(data$SAMPLE_DEPTH) #there are NA values deal with later
#look at flag information
unique(data$COLOR_FLAG) #only one unique flag
length(data$COLOR_FLAG[which(data$COLOR_FLAG=="<RL (5)")]) #246 are less than the reporting limit
unique(data$COLOR_RL_ALERT) #no observations below reporting limit
length(data$COLOR_RL_ALERT[which(data$COLOR_RL_ALERT=="Y")]) #however, only 146 are specified as being less than the reporting limit
#use COLOR_FLAG to assign a censor code of "LT" where "<RL(5) is specified

#done filtering

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$SITE_ID
data.Export$LakeName = NA #textual lake name not specified in source data
data.Export$SourceVariableName = "COLOR"
data.Export$SourceVariableDescription = "True color"
#populate SourceFlags
unique(data$COLOR_FLAG)#looking at unique flag
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=data$COLOR_FLAG
length(data.Export$SourceFlags[which(data.Export$SourceFlags=="")])
data.Export$SourceFlags[which(data.Export$SourceFlags=="")]=NA
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA
unique(data.Export$SourceFlags)
#continue populating other lagos variables
data.Export$LagosVariableID = 12
data.Export$LagosVariableName="Color, true"
names(data)
data.Export$Value = data[,8] #export color values already in preff. units of PCU
#assign censor code
data.Export$CensorCode=as.character(data.Export$CensorCode)
length(data.Export$Value[which(data.Export$Value<=5)]) #see how many are "LT"
data.Export$CensorCode[which(data.Export$Value<=5)]="LT"
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure correct number
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]="NC"
#continue with others
data.Export$Date = data$DATE_COL #date already in correct format
data.Export$Units="PCU"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"#per metadata
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
#assign sampledepth 
unique(data$SAMPLE_DEPTH)#looking at depths to see if there are any problematic values
length(data$SAMPLE_DEPTH[which(is.na(data$SAMPLE_DEPTH)==TRUE)]) #depths missing for 10 observations=okay because sample position specified
data.Export$SampleDepth=data$SAMPLE_DEPTH
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)]) #check to make sure proper number are NA
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==FALSE)])
1242+10#adds to total
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
unique(data.Export$SampleDepth) #none are >50 so all obs are "PRIMARY" except if depth is NA
data.Export$BasinType[which(is.na(data$SAMPLE_DEPTH)==FALSE)]="PRIMARY"
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) #check to make sure CORRECT NUMBER populated
data.Export$BasinType[which(is.na(data$SAMPLE_DEPTH)==TRUE)]="UNKNOWN"
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")])
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= 5#per meta data
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data$COLOR_RL_ALERT=="Y")]="observation below reporting limit of 5 PCU"
unique(data.Export$Comments)
color.Final = data.Export
rm(data.Export)
rm(data)


################################### NH4N_PPM #############################################################################################################################
data=EPA_NLA_CHEM
names(data) #looking at column names
#fiter out columns of interest
data=data[,c(1,6:8,14:16,33:36,109:111)]
names(data) #looking at column names
unique(data$NH4N_PPM)#looking for problematic special characters
#checking for null values
length(data$NH4N_PPM[which(data$NH4N_PPM=="")])
length(data$NH4N_PPM[which(data$NH4N_PPM==".")])
length(data$NH4N_PPM[which(is.na(data$NH4N_PPM)==TRUE)])
#no null values
unique(data$SAMPLE_CATEGORY)
length(data$SAMPLE_CATEGORY[which(data$SAMPLE_CATEGORY=="D")])
1326-74 #remove those 74 obs that are duplicates, 1252 should remain
data=data[which(data$SAMPLE_CATEGORY!="D"),]
#check to make sure all obs have a lakeid
unique(data$SITE_ID)#all have a site id, multiple missing value identifiers tested
length(data$SITE_ID[which(data$SITE_ID=="")])
#check to make sure all have a date attached
unique(data$DATE_COL)#all have a date attached, multiple missing value identifiers tested
length(data$DATE_COL[which(data$DATE_COL==".")])
#look at sample depths
unique(data$SAMPLE_DEPTH) #there are NA values deal with later
#look at flag information
unique(data$NH4_FLAG) #only one unique flag
length(data$NH4_FLAG[which(data$NH4_FLAG=="<RL (0.02)")]) #710 are less than the reporting limit
unique(data$NH4_RL_ALERT) #no observations below reporting limit
length(data$NH4_RL_ALERT[which(data$NH4_RL_ALERT=="Y")]) #710
#note that the no. of obs. below detection is not the same as those below the reporting limit!!! RL does not equal detection limit!!

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$SITE_ID
data.Export$LakeName = NA #textual lake name not specified in source data
data.Export$SourceVariableName = "NH4N_PPM"
data.Export$SourceVariableDescription = "Ammonium nitrogen"
#populate SourceFlags
unique(data$NH4_FLAG)#looking at unique flag
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=data$NH4_FLAG
length(data.Export$SourceFlags[which(data.Export$SourceFlags=="")])
data.Export$SourceFlags[which(data.Export$SourceFlags=="")]=NA
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA
unique(data.Export$SourceFlags)
#continue populating other lagos variables
data.Export$LagosVariableID = 19
data.Export$LagosVariableName="Nitrogen, NH4"
names(data)
data.Export$Value = (data[,8]*1000) #export nh4 and multiply by 1000 to go from mg/L to preff. ug/L
#assign censor code
data.Export$CensorCode=as.character(data.Export$CensorCode)
length(data.Export$Value[which(data.Export$Value<=25.8)]) #see how many are "LT"
data.Export$CensorCode[which(data.Export$Value<=25.8)]="LT"
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure correct number
data.Export$CensorCode[which(is.na(data.Export$CensorCode==TRUE))]="NC"
#continue with others
data.Export$Date = data$DATE_COL #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"#per metadata
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
#assign sampledepth 
unique(data$SAMPLE_DEPTH)#looking at depths to see if there are any problematic values
length(data$SAMPLE_DEPTH[which(is.na(data$SAMPLE_DEPTH)==TRUE)]) #depths missing for 10 observations=okay because sample position specified
data.Export$SampleDepth=data$SAMPLE_DEPTH
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)]) #check to make sure proper number are NA
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==FALSE)])
1242+10#adds to total
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
unique(data.Export$SampleDepth) #none are >50 so all obs are "PRIMARY" except if depth is NA
data.Export$BasinType[which(is.na(data$SAMPLE_DEPTH)==FALSE)]="PRIMARY"
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) #check to make sure CORRECT NUMBER populated
data.Export$BasinType[which(is.na(data$SAMPLE_DEPTH)==TRUE)]="UNKNOWN"
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")])
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= 25.8 #per source data reporting limit, had to convert from ueq/L to ug/L
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data$NH4_RL_ALERT=="Y")]="observation below reporting limit of 20 ug/L"
length(data.Export$Comments[which(data.Export$Comments=="observation below reporting limit of 20 ug/L")])
nh4.Final = data.Export
rm(data.Export)
rm(data)
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/EPA national surveys/IN-LAKE DATA/DataImport_EPA_NLA_CHEM/DataImport_EPA_NLA_CHEM.RData")

################################### NO3N_PPM  #############################################################################################################################
data=EPA_NLA_CHEM
names(data) #looking at column names
#fiter out columns of interest
data=data[,c(1,6:8,14:16,51:54,109:111)]
names(data) #looking at column names
unique(data$NO3N_PPM)#looking for problematic special characters
#checking for null values
length(data$NO3N_PPM[which(data$NO3N_PPM=="")])
length(data$NO3N_PPM[which(data$NO3N_PPM==".")])
length(data$NO3N_PPM[which(is.na(data$NO3N_PPM)==TRUE)])
#no null values
unique(data$SAMPLE_CATEGORY)
length(data$SAMPLE_CATEGORY[which(data$SAMPLE_CATEGORY=="D")])
1326-74 #remove those 74 obs that are duplicates, 1252 should remain
data=data[which(data$SAMPLE_CATEGORY!="D"),]
#check to make sure all obs have a lakeid
unique(data$SITE_ID)#all have a site id, multiple missing value identifiers tested
length(data$SITE_ID[which(data$SITE_ID=="")])
#check to make sure all have a date attached
unique(data$DATE_COL)#all have a date attached, multiple missing value identifiers tested
length(data$DATE_COL[which(data$DATE_COL==".")])
#look at sample depths
unique(data$SAMPLE_DEPTH) #there are NA values deal with later
#look at flag information
unique(data$NO3_FLAG) #only one unique flag
length(data$NO3_FLAG[which(data$NO3_FLAG=="<RL (0.02)")]) #966 are less than the reporting limit
unique(data$NO3_RL_ALERT) #no observations below reporting limit
length(data$NO3_RL_ALERT[which(data$NO3_RL_ALERT=="Y")]) #982

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$SITE_ID
data.Export$LakeName = NA #textual lake name not specified in source data
data.Export$SourceVariableName = "NO3N_PPM"
data.Export$SourceVariableDescription = "nitrate nitrogen"
#populate SourceFlags
unique(data$NO3_FLAG)#looking at unique flag
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=data$NO3_FLAG
length(data.Export$SourceFlags[which(data.Export$SourceFlags=="")])
data.Export$SourceFlags[which(data.Export$SourceFlags=="")]=NA
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA
unique(data.Export$SourceFlags)
#continue populating other lagos variables
data.Export$LagosVariableID = 18
data.Export$LagosVariableName="Nitrogen, nitrite (NO2) + nitrate (NO3)"
names(data)
data.Export$Value = (data[,8]*1000) #export n03 values and multiply by 1000 to go from mg/L to preff. ug/L
#assign censor code
data.Export$CensorCode=as.character(data.Export$CensorCode)
length(data.Export$Value[which(data.Export$Value<=25.8)]) #see how many are "LT"
data.Export$CensorCode[which(data.Export$Value<=25.8)]="LT"
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure correct number
data.Export$CensorCode[which(is.na(data.Export$CensorCode==TRUE))]="NC"
#continue with others
data.Export$Date = data$DATE_COL #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"#per metadata
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
#assign sampledepth 
unique(data$SAMPLE_DEPTH)#looking at depths to see if there are any problematic values
length(data$SAMPLE_DEPTH[which(is.na(data$SAMPLE_DEPTH)==TRUE)]) #depths missing for 10 observations=okay because sample position specified
data.Export$SampleDepth=data$SAMPLE_DEPTH
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)]) #check to make sure proper number are NA
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==FALSE)])
1242+10#adds to total
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
unique(data.Export$SampleDepth) #none are >50 so all obs are "PRIMARY" except if depth is NA
data.Export$BasinType[which(is.na(data$SAMPLE_DEPTH)==FALSE)]="PRIMARY"
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) #check to make sure CORRECT NUMBER populated
data.Export$BasinType[which(is.na(data$SAMPLE_DEPTH)==TRUE)]="UNKNOWN"
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")])
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= 25.8 #per source data reporting limit, had to convert from ueq/L to ug/L
length(data$NO3_RL_ALERT[which(data$NO3_RL_ALERT=="Y")])
length(data$NO3_FLAG[which(data$NO3_FLAG=="<RL (0.02)")])
#they don't match use the RL alert to populate comments
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data$NO3_RL_ALERT=="Y")]="observation below reporting limit of 20 ug/L"
length(data.Export$Comments[which(data.Export$Comments=="observation below reporting limit of 20 ug/L")])
no3.Final = data.Export
rm(data.Export)
rm(data)

################################### NO3_NO2  #############################################################################################################################
data=EPA_NLA_CHEM
names(data) #looking at column names
#fiter out columns of interest
data=data[,c(1,6:8,14:16,37:39,109:111)]
names(data) #looking at column names
unique(data$NO3_NO2)#looking for problematic special characters
#checking for null values
length(data$NO3_NO2[which(data$NO3_NO2=="")])
length(data$NO3_NO2[which(data$NO3_NO2==".")])
length(data$NO3_NO2[which(is.na(data$NO3_NO2)==TRUE)])
#no null values
unique(data$SAMPLE_CATEGORY)
length(data$SAMPLE_CATEGORY[which(data$SAMPLE_CATEGORY=="D")])
1326-74 #remove those 74 obs that are duplicates, 1252 should remain
data=data[which(data$SAMPLE_CATEGORY!="D"),]
#check to make sure all obs have a lakeid
unique(data$SITE_ID)#all have a site id, multiple missing value identifiers tested
length(data$SITE_ID[which(data$SITE_ID=="")])
#check to make sure all have a date attached
unique(data$DATE_COL)#all have a date attached, multiple missing value identifiers tested
length(data$DATE_COL[which(data$DATE_COL==".")])
#look at sample depths
unique(data$SAMPLE_DEPTH) #there are NA values deal with later
#look at flag information
unique(data$NO3NO2_FLAG) #only one unique flag
length(data$NO3NO2_FLAG[which(data$NO3NO2_FLAG=="<RL (0.02)")]) #1024 are less than the reporting limit
unique(data$NO3NO2_RL_ALERT) #no observations below reporting limit
length(data$NO3NO2_RL_ALERT[which(data$NO3NO2_RL_ALERT=="Y")]) #1021

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$SITE_ID
data.Export$LakeName = NA #textual lake name not specified in source data
data.Export$SourceVariableName = "NO3_NO2"
data.Export$SourceVariableDescription = "nitrate + nitrite, nitrogen"
#populate SourceFlags
unique(data$NO3NO2_FLAG)#looking at unique flag
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=data$NO3NO2_FLAG
length(data.Export$SourceFlags[which(data.Export$SourceFlags=="")])
data.Export$SourceFlags[which(data.Export$SourceFlags=="")]=NA
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA
unique(data.Export$SourceFlags)
#continue populating other lagos variables
data.Export$LagosVariableID = 18
data.Export$LagosVariableName="Nitrogen, nitrite (NO2) + nitrate (NO3)"
names(data)
data.Export$Value = (data[,8]*1000) #export no3no2 values and multiply by 1000 to go from mg/L to preff. ug/L
#assign censor code
data.Export$CensorCode=as.character(data.Export$CensorCode)
length(data.Export$Value[which(data.Export$Value<=20)]) #see how many are "LT"
data.Export$CensorCode[which(data.Export$Value<=20)]="LT"
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure correct number
data.Export$CensorCode[which(is.na(data.Export$CensorCode==TRUE))]="NC"
#continue with others
data.Export$Date = data$DATE_COL #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"#per metadata
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
#assign sampledepth 
unique(data$SAMPLE_DEPTH)#looking at depths to see if there are any problematic values
length(data$SAMPLE_DEPTH[which(is.na(data$SAMPLE_DEPTH)==TRUE)]) #depths missing for 10 observations=okay because sample position specified
data.Export$SampleDepth=data$SAMPLE_DEPTH
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)]) #check to make sure proper number are NA
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==FALSE)])
1242+10#adds to total
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
unique(data.Export$SampleDepth) #none are >50 so all obs are "PRIMARY" except if depth is NA
data.Export$BasinType[which(is.na(data$SAMPLE_DEPTH)==FALSE)]="PRIMARY"
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) #check to make sure CORRECT NUMBER populated
data.Export$BasinType[which(is.na(data$SAMPLE_DEPTH)==TRUE)]="UNKNOWN"
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")])
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= 20 #per source data reporting limit, had to convert from ueq/L to ug/L
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data$NO3NO2_RL_ALERT=="Y")]="observation below reporting limit of 20 ug/L"
length(data.Export$Comments[which(data.Export$Comments=="observation below reporting limit of 20 ug/L")])
no3no2.Final = data.Export
rm(data.Export)
rm(data)

################################### NTL_PPM  #############################################################################################################################
data=EPA_NLA_CHEM
names(data) #looking at column names
#fiter out columns of interest
data=data[,c(1,6:8,14:16,40:43,109:111)]
names(data) #looking at column names
unique(data$NTL_PPM)#looking for problematic special characters
#checking for null values
length(data$NTL_PPM[which(data$NTL_PPM=="")])
length(data$NTL_PPM[which(data$NTL_PPM==".")])
length(data$NTL_PPM[which(is.na(data$NTL_PPM)==TRUE)])
#no null values
unique(data$SAMPLE_CATEGORY)
length(data$SAMPLE_CATEGORY[which(data$SAMPLE_CATEGORY=="D")])
1326-74 #remove those 74 obs that are duplicates, 1252 should remain
data=data[which(data$SAMPLE_CATEGORY!="D"),]
#check to make sure all obs have a lakeid
unique(data$SITE_ID)#all have a site id, multiple missing value identifiers tested
length(data$SITE_ID[which(data$SITE_ID=="")])
#check to make sure all have a date attached
unique(data$DATE_COL)#all have a date attached, multiple missing value identifiers tested
length(data$DATE_COL[which(data$DATE_COL==".")])
#look at sample depths
unique(data$SAMPLE_DEPTH) #there are NA values deal with later
#look at flag information
unique(data$NTL_FLAG) #only one unique flag <RL (20)
length(data$NTL_FLAG[which(data$NTL_FLAG=="<RL (20)")]) #no are less than the reporting limit
unique(data$NTL_RL_ALERT) #no observations below reporting limit

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$SITE_ID
data.Export$LakeName = NA #textual lake name not specified in source data
data.Export$SourceVariableName = "NTL_PPM"
data.Export$SourceVariableDescription = "Total nitrogen"
#populate SourceFlags
unique(data$NTL_FLAG)#looking at unique flag
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=data$NTL_FLAG
length(data.Export$SourceFlags[which(data.Export$SourceFlags=="")])
data.Export$SourceFlags[which(data.Export$SourceFlags=="")]=NA
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA
unique(data.Export$SourceFlags)
#continue populating other lagos variables
data.Export$LagosVariableID = 21
data.Export$LagosVariableName="Nitrogen, total"
names(data)
data.Export$Value = (data[,8]*1000) #export tn values and multiply by 1000 to go from mg/L to preff. ug/L
#assign censor code
data.Export$CensorCode=as.character(data.Export$CensorCode)
length(data.Export$Value[which(data.Export$Value<=20)]) #see how many are "LT"
data.Export$CensorCode[which(data.Export$Value<=20)]="LT"
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure correct number
data.Export$CensorCode[which(is.na(data.Export$CensorCode==TRUE))]="NC"
#continue with others
data.Export$Date = data$DATE_COL #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"#per metadata
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
#assign sampledepth 
unique(data$SAMPLE_DEPTH)#looking at depths to see if there are any problematic values
length(data$SAMPLE_DEPTH[which(is.na(data$SAMPLE_DEPTH)==TRUE)]) #depths missing for 10 observations=okay because sample position specified
data.Export$SampleDepth=data$SAMPLE_DEPTH
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)]) #check to make sure proper number are NA
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==FALSE)])
1242+10#adds to total
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
unique(data.Export$SampleDepth) #none are >50 so all obs are "PRIMARY" except if depth is NA
data.Export$BasinType[which(is.na(data$SAMPLE_DEPTH)==FALSE)]="PRIMARY"
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) #check to make sure CORRECT NUMBER populated
data.Export$BasinType[which(is.na(data$SAMPLE_DEPTH)==TRUE)]="UNKNOWN"
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")])
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= 20 #per source data reporting limit, had to convert from ueq/L to ug/L
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data$NTL_RL_ALERT=="Y")]="observation below reporting limit of 20 ug/L"
length(data.Export$Comments[which(data.Export$Comments=="observation below reporting limit of 20 ug/L")])
tn.Final = data.Export
rm(data.Export)
rm(data)


################################### PTL  #############################################################################################################################
data=EPA_NLA_CHEM
names(data) #looking at column names
#fiter out columns of interest
data=data[,c(1,6:8,14:16,44:46,109:111)]
names(data) #looking at column names
unique(data$PTL)#looking for problematic special characters
#checking for null values
length(data$PTL[which(data$PTL=="")])
length(data$PTL[which(data$PTL==".")])
length(data$PTL[which(is.na(data$PTL)==TRUE)])
#no null values
unique(data$SAMPLE_CATEGORY)
length(data$SAMPLE_CATEGORY[which(data$SAMPLE_CATEGORY=="D")])
1326-74 #remove those 74 obs that are duplicates, 1252 should remain
data=data[which(data$SAMPLE_CATEGORY!="D"),]
#check to make sure all obs have a lakeid
unique(data$SITE_ID)#all have a site id, multiple missing value identifiers tested
length(data$SITE_ID[which(data$SITE_ID=="")])
#check to make sure all have a date attached
unique(data$DATE_COL)#all have a date attached, multiple missing value identifiers tested
length(data$DATE_COL[which(data$DATE_COL==".")])
#look at sample depths
unique(data$SAMPLE_DEPTH) #there are NA values deal with later
#look at flag information
unique(data$PTL_FLAG) #only one unique flag <RL (4)
length(data$PTL_FLAG[which(data$PTL_FLAG=="<RL (4)")]) #131 are less than the reporting limit
unique(data$PTL_RL_ALERT) #no observations below reporting limit
length(data$PTL_RL_ALERT[which(data$PTL_RL_ALERT=="Y")]) #87
###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$SITE_ID
data.Export$LakeName = NA #textual lake name not specified in source data
data.Export$SourceVariableName = "PTL"
data.Export$SourceVariableDescription = "Total phosphorus"
#populate SourceFlags
unique(data$PTL_FLAG)#looking at unique flag
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=data$PTL_FLAG
length(data.Export$SourceFlags[which(data.Export$SourceFlags=="")])
data.Export$SourceFlags[which(data.Export$SourceFlags=="")]=NA
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA
unique(data.Export$SourceFlags)
#continue populating other lagos variables
data.Export$LagosVariableID = 27
data.Export$LagosVariableName="Phosphorus, total"
names(data)
data.Export$Value = data[,8] #export tp values already in preff units of ug/L
#assign censor code
data.Export$CensorCode=as.character(data.Export$CensorCode)
length(data.Export$Value[which(data.Export$Value<=4)]) #see how many are "LT"
data.Export$CensorCode[which(data.Export$Value<=4)]="LT"
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure correct number
data.Export$CensorCode[which(is.na(data.Export$CensorCode==TRUE))]="NC"
#continue with others
data.Export$Date = data$DATE_COL #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"#per metadata
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
#assign sampledepth 
unique(data$SAMPLE_DEPTH)#looking at depths to see if there are any problematic values
length(data$SAMPLE_DEPTH[which(is.na(data$SAMPLE_DEPTH)==TRUE)]) #depths missing for 10 observations=okay because sample position specified
data.Export$SampleDepth=data$SAMPLE_DEPTH
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)]) #check to make sure proper number are NA
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==FALSE)])
1242+10#adds to total
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
unique(data.Export$SampleDepth) #none are >50 so all obs are "PRIMARY" except if depth is NA
data.Export$BasinType[which(is.na(data$SAMPLE_DEPTH)==FALSE)]="PRIMARY"
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) #check to make sure CORRECT NUMBER populated
data.Export$BasinType[which(is.na(data$SAMPLE_DEPTH)==TRUE)]="UNKNOWN"
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")])
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= 4 #per source data reporting limit, units ug/L
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data$PTL_RL_ALERT=="Y")]="observation below reporting limit of 4 ug/L"
length(data.Export$Comments[which(data.Export$Comments=="observation below reporting limit of 4 ug/L")])
tp.Final = data.Export
rm(data.Export)
rm(data)


################################### SECMEAN   #############################################################################################################################
data=EPA_NLA_CHEM
names(data) #looking at column names
#fiter out columns of interest
data=data[,c(1,6:8,14:16,124:130)]
names(data) #looking at column names
unique(data$SECMEAN)#looking for problematic special characters
#do filtering 
#checking for null values
length(data$SECMEAN[which(data$SECMEAN=="")])
length(data$SECMEAN[which(data$SECMEAN==".")])
length(data$SECMEAN[which(is.na(data$SECMEAN)==TRUE)]) #143 need to be filtered out
1326-143 #should be left with 1183 after removing na obs.
data=data[which(is.na(data$SECMEAN)==FALSE),]
#other filtering
unique(data$SAMPLE_CATEGORY) #all primary don't have to filter
unique(data$CLEAR_TO_BOTTOM) #no values specified for this variable
unique(data$SAMPLED_SECCHI) #all values are YES so don't have to filter anything out
unique(data$COMMENT_SECCHI) #don't export columns
unique(data$FLAG_SECCHI)#two flags U=non standard measurment Fn=other comment
length(data$FLAG_SECCHI[which(data$FLAG_SECCHI=="U")])#only 3
#done filtering populate lagos

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$SITE_ID
data.Export$LakeName = NA #textual lake name not specified in source data
data.Export$SourceVariableName = "SECMEAN"
data.Export$SourceVariableDescription = "Average of disk disappearance and reappearance depths"
#populate SourceFlags
unique(data$FLAG_SECCHI)#looking at unique flag
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags[which(data$FLAG_SECCHI=="U")]="U"
data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)]=NA
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA
unique(data.Export$SourceFlags)
#continue populating other lagos variables
data.Export$LagosVariableID = 30
data.Export$LagosVariableName="Secchi"
names(data)
data.Export$Value = data[,10] #export secchi obs, already in preff units of "m"
#assign censor code
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode="NC"
#continue with others
data.Export$Date = data$DATESECCHI #date already in correct format
data.Export$Units="m"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="SPECIFIED"#because secchi
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")])
#assign sampledepth 
data.Export$SampleDepth=NA #because secchi
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
unique(data.Export$SampleDepth) #none are >50 so all obs are "PRIMARY" except if depth is NA
data.Export$BasinType[which(is.na(data$SAMPLE_DEPTH)==FALSE)]="PRIMARY"
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) #check to make sure CORRECT NUMBER populated
data.Export$BasinType[which(is.na(data$SAMPLE_DEPTH)==TRUE)]="UNKNOWN"
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")])
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #because secchi
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data.Export$SourceFlags=="U")]="U= non-standard measurement"
unique(data.Export$Comments)
secchi.Final = data.Export
rm(data.Export)
rm(data)

###################################### final export ########################################################################################
Final.Export = rbind(chla.Final, color.Final,doc.Final,nh4.Final,no3.Final,no3no2.Final,secchi.Final,tn.Final,toc.Final,tp.Final)
#############################################################################################

##Duplicates check #################################
#an observation is defined as duplicate if it is NOT unique for programid, lagoslakeid, date, sampledepth, sampleposition, lagosvariableid, datavalue
names(Final.Export)
library(data.table)
data1=data.table(Final.Export,key=c('LakeID','Value','Date','LagosVariableID','SampleDepth','SamplePosition'))
data1=data1[,Dup:=duplicated(.SD),.SDcols=c('LakeID','Value','Date', 'LagosVariableID', 'SampleDepth', 'SamplePosition')]
head(data1)#look at a snapshot of the data
data1$Dup[which(data1$Dup==FALSE)]=NA 
data1$Dup[which(data1$Dup==TRUE)]=1
unique(data1$Dup)
#check to see if they add up to the total
length(data1$Dup[which(data1$Dup=="1")])
length(data1$Dup[which(is.na(data1$Dup)==TRUE)])
2183+10256#adds up to total
##write table
Final.Export1=data1
typeof(Final.Export1$Value)
length(Final.Export1$Value[which(Final.Export1$Value<0)])
nosamplepos=Final.Export1[which(is.na(Final.Export1$SampleDepth)==TRUE & Final.Export1$SamplePosition=="UNKNOWN"),]
write.table(Final.Export1,file="DataImport_EPA_NLA_CHEM.csv",row.names=FALSE,sep=",")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/EPA national surveys/IN-LAKE DATA/DataImport_EPA_NLA_CHEM/DataImport_EPA_NLA_CHEM.RData")
