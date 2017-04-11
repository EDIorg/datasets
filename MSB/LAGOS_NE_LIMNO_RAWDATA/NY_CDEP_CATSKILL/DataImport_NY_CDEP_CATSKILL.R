#set path to files
setwd("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/NY data/Catskills_Reservoirs/DataImport_NY_CDEP_CATSKILL")
setwd("C:/Users/Sam/Dropbox/CSI-LIMNO_DATA/DATA-lake/NY data/Catskills_Reservoirs/DataImport_NY_CDEP_CATSKILL")

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
#DATA for 5 reservoirs in NY that = a water supply to the city
#different stations sampled at different depths and dates
#reservoirs sampled biweekly during open water season (maybe not at every station or the same depth)
#sample type if is unknown, sample position is grab
#multiple analytical methods used through time, assign lab method info based on the lab method info relevant to that date
###########################################################################################################################################################################################
################################### COLOR    #############################################################################################################################
data=catskill_reservoirs
head(data)#snapshot of the data
names(data)#look at column names
#pull out columns of interest
data=data[,c(1:6,19,7,25:28)]
names(data)
#check for null values
unique(data$COLOR..Apparent..units.)#looking for problematic values, note that there are negative values
length(data$COLOR..Apparent..units.[which(is.na(data$COLOR..Apparent..units.)==TRUE)])
length(data$COLOR..Apparent..units.[which(data$COLOR..Apparent..units.=="")])
28601-6649# 21952 should remain after filtering out the null values
data=data[which(is.na(data$COLOR..Apparent..units.)==FALSE),]
#look at other variables-unique, etc..
#check for NA sample depths, if NA filter out because info on SamplePosition is not sufficient
length(data$ZSP...Sample.Depth..m..[which(is.na(data$ZSP...Sample.Depth..m..)==TRUE)])#2 obs NA
length(data$ZSP...Sample.Depth..m..[which(data$ZSP...Sample.Depth..m..=="")])
#continue looking at data
unique(data$RESERVOIR.CODE)#LakeID
unique(data$STATION.)
#done filtering
#proceed to populating LAGOS template
###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$lagos_LakeID
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$reservoirname
data.Export$SourceVariableName = "COLOR- Apparent (units)"
data.Export$SourceVariableDescription = "Apparent color"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no flags w/ these data
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 11
data.Export$LagosVariableName="Color, apparent"
names(data)
data.Export$Value = data$COLOR..Apparent..units. #export observations already in prefferred units
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$DATE #date already in correct format
data.Export$Units="PCU"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType=data$sample_type
unique(data.Export$SampleType)
#check to make sure adds up to total
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #GOOD
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
#assign sampledepth 
data.Export$SampleDepth=data$sample_depth_final
unique(data.Export$SampleDepth)
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(is.na(data.Export$SampleDepth)==TRUE)]="UNKNOWN"#per metadata
data.Export$SamplePosition[which(is.na(data.Export$SampleDepth)==FALSE)]="SPECIFIED"
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")])#check to make sure correct number
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="UNKNOWN")])#check to make sure correct number
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
#assign primary to stations that represent the deep spot, the rest of the stations are not primary
unique(data$basin_type)
data.Export$BasinType[which(data$basin_type=="PRIMARY")]="PRIMARY" 
data.Export$BasinType[which(data$basin_type=="NOT_PRIMARY")]="NOT_PRIMARY" 
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) 
length(data.Export$BasinType[which(data.Export$BasinType=="NOT_PRIMARY")]) 
15416+6536#adds up to total
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "MULTIPLE" #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data$DATE=as.character(data$DATE)
data.Export$LabMethodInfo[which(data$DATE<="2003-12-31")]="From 1984-2003 SM16/17; 204A"
data.Export$LabMethodInfo[which(data$DATE>"2003-12-13")]="From 2004-2011 SM18; 2120B"
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #not specified in meta
data.Export$Comments=as.character(data.Export$Comments)
length(data.Export$Value[which(data.Export$Value==-1)])
#1006 observations were to turbid for analysis, note this in the comments field
data.Export$Comments[which(data.Export$Value==-1)]="Values of -1 indicate a sample that was too turbid for color determination"
unique(data.Export$Comments)
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
color.Final = data.Export
rm(data)
rm(data.Export)

################################### TP (ug/l)  #############################################################################################################################
data=catskill_reservoirs
head(data)#snapshot of the data
names(data)#look at column names
#pull out columns of interest
data=data[,c(1:6,19,9,25:28)]
names(data)
#check for null values
unique(data$TP..ug.l.)#looking for problematic values, note that there are negative values
length(data$TP..ug.l.[which(is.na(data$TP..ug.l.)==TRUE)])
length(data$TP..ug.l.[which(data$TP..ug.l.=="")])
28601-8779# 19822 should remain after filtering out the null values
data=data[which(is.na(data$TP..ug.l.)==FALSE),]
#look at other variables-unique, etc..
#check for NA sample depths, if NA filter out because info on SamplePosition is not sufficient
length(data$ZSP...Sample.Depth..m..[which(is.na(data$ZSP...Sample.Depth..m..)==TRUE)])#1 obs NA
length(data$ZSP...Sample.Depth..m..[which(data$ZSP...Sample.Depth..m..=="")])
#continue looking at data
unique(data$RESERVOIR.CODE)#LakeID
unique(data$STATION.)
#done filtering
#proceed to populating LAGOS template
###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$lagos_LakeID
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$reservoirname
data.Export$SourceVariableName = "TP (ug/l)"
data.Export$SourceVariableDescription = "Total phosphorus"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no flags w/ these data
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 27
data.Export$LagosVariableName="Phosphorus, total"
names(data)
data.Export$Value = data$TP..ug.l. #export observations already in prefferred units
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$DATE #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType=data$sample_type
unique(data.Export$SampleType)
#check to make sure adds up to total
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #GOOD
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
#assign sampledepth 
data.Export$SampleDepth=data$sample_depth_final
unique(data.Export$SampleDepth)
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(is.na(data.Export$SampleDepth)==TRUE)]="UNKNOWN"#per metadata
data.Export$SamplePosition[which(is.na(data.Export$SampleDepth)==FALSE)]="SPECIFIED"
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")])#check to make sure correct number
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="UNKNOWN")])#check to make sure correct number
data.Export$BasinType=as.character(data.Export$BasinType)
#assign primary to stations that represent the deep spot, the rest of the stations are not primary
unique(data$basin_type)
data.Export$BasinType[which(data$basin_type=="PRIMARY")]="PRIMARY" 
data.Export$BasinType[which(data$basin_type=="NOT_PRIMARY")]="NOT_PRIMARY" 
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) 
length(data.Export$BasinType[which(data.Export$BasinType=="NOT_PRIMARY")]) 
5742+14080#adds up to total
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "MULTIPLE" #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data$DATE=as.character(data$DATE)
data.Export$LabMethodInfo[which(data$DATE<="1988-12-31")]="SM16 (1987-1988)"
data.Export$LabMethodInfo[which(data$DATE> "1988-12-31")]="Persulfate digestion/ascorbic acid method, Valderrama 1980 (1990-1999)"
data.Export$LabMethodInfo[which(data$DATE> "1999-12-31")]="SM18 (2000-2006)"
data.Export$LabMethodInfo[which(data$DATE> "2006-12-31")]="EPA 365.1 (2007-2011)"
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #not specified in meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
tp.Final = data.Export
rm(data)
rm(data.Export)

################################### DOC (mg/l)  #############################################################################################################################
data=catskill_reservoirs
head(data)#snapshot of the data
names(data)#look at column names
#pull out columns of interest
data=data[,c(1:6,19,10,25:28)]
names(data)
#check for null values
unique(data$DOC..mg.l.)#looking for problematic values, note that there are negative values
length(data$DOC..mg.l.[which(is.na(data$DOC..mg.l.)==TRUE)])
length(data$DOC..mg.l.[which(data$DOC..mg.l.=="")])
28601-20308# 8293 should remain after filtering out the null values
data=data[which(is.na(data$DOC..mg.l.)==FALSE),]
#look at other variables-unique, etc..
#check for NA sample depths, if NA filter out because info on SamplePosition is not sufficient
length(data$ZSP...Sample.Depth..m..[which(is.na(data$ZSP...Sample.Depth..m..)==TRUE)])#2 obs NA
length(data$ZSP...Sample.Depth..m..[which(data$ZSP...Sample.Depth..m..=="")])
#continue looking at data
unique(data$RESERVOIR.CODE)#LakeID
unique(data$STATION.)
#done filtering
#proceed to populating LAGOS template
###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$lagos_LakeID
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$reservoirname
data.Export$SourceVariableName = "DOC (mg/l)"
data.Export$SourceVariableDescription = "Dissolved organic carbon"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no flags w/ these data
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 6
data.Export$LagosVariableName="Carbon, dissolved organic"
names(data)
data.Export$Value = data$DOC..mg.l. #export observations already in prefferred units
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$DATE #date already in correct format
data.Export$Units="mg/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType=data$sample_type
unique(data.Export$SampleType)
#check to make sure adds up to total
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #GOOD
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
#assign sampledepth 
data.Export$SampleDepth=data$sample_depth_final
unique(data.Export$SampleDepth)
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(is.na(data.Export$SampleDepth)==TRUE)]="UNKNOWN"#per metadata
data.Export$SamplePosition[which(is.na(data.Export$SampleDepth)==FALSE)]="SPECIFIED"
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")])#check to make sure correct number
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="UNKNOWN")])#check to make sure correct number
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
#assign primary to stations that represent the deep spot, the rest of the stations are not primary
unique(data$basin_type)
data.Export$BasinType[which(data$basin_type=="PRIMARY")]="PRIMARY" 
data.Export$BasinType[which(data$basin_type=="NOT_PRIMARY")]="NOT_PRIMARY" 
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) 
length(data.Export$BasinType[which(data.Export$BasinType=="NOT_PRIMARY")]) 
2515+5778#adds up to total
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "MULTIPLE" #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data$DATE=as.character(data$DATE)
data.Export$LabMethodInfo[which(data$DATE<="2001-12-31")]="SM18 (1987-2001)"
data.Export$LabMethodInfo[which(data$DATE> "2001-12-31")]="SM19 (2002-2011)"
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #not specified in meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
doc.Final = data.Export
rm(data)
rm(data.Export)

################################### TN (mg/l)  #############################################################################################################################
data=catskill_reservoirs
head(data)#snapshot of the data
names(data)#look at column names
#pull out columns of interest
data=data[,c(1:6,19,11,25:28)]
names(data)
#check for null values
unique(data$TN..mg.l.)#looking for problematic values, note that there are negative values
length(data$TN..mg.l.[which(is.na(data$TN..mg.l.)==TRUE)])
length(data$TN..mg.l.[which(data$TN..mg.l.=="")])
28601-14506# 14095 should remain after filtering out the null values
data=data[which(is.na(data$TN..mg.l.)==FALSE),]
#look at other variables-unique, etc..
#check for NA sample depths, if NA filter out because info on SamplePosition is not sufficient
length(data$ZSP...Sample.Depth..m..[which(is.na(data$ZSP...Sample.Depth..m..)==TRUE)])#2 obs NA
length(data$ZSP...Sample.Depth..m..[which(data$ZSP...Sample.Depth..m..=="")])
#continue looking at data
unique(data$lagos_LakeID)#LakeID
unique(data$STATION.)
#done filtering
#proceed to populating LAGOS template
###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$lagos_LakeID
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$reservoirname
data.Export$SourceVariableName = "TN (mg/l)"
data.Export$SourceVariableDescription = "Total nitrogen"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no flags w/ these data
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 21
data.Export$LagosVariableName="Nitrogen, total"
names(data)
data.Export$Value = data$TN..mg.l.*1000 #export observations and convert to prefferred units
unique(data.Export$Value)
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$DATE #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType=data$sample_type
unique(data.Export$SampleType)
#check to make sure adds up to total
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #GOOD
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
#assign sampledepth 
data.Export$SampleDepth=data$sample_depth_final
unique(data.Export$SampleDepth)
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(is.na(data.Export$SampleDepth)==TRUE)]="UNKNOWN"#per metadata
data.Export$SamplePosition[which(is.na(data.Export$SampleDepth)==FALSE)]="SPECIFIED"
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")])#check to make sure correct number
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="UNKNOWN")])#check to make sure correct number
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
#assign primary to stations that represent the deep spot, the rest of the stations are not primary
unique(data$basin_type)
data.Export$BasinType[which(data$basin_type=="PRIMARY")]="PRIMARY" 
data.Export$BasinType[which(data$basin_type=="NOT_PRIMARY")]="NOT_PRIMARY" 
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) 
length(data.Export$BasinType[which(data.Export$BasinType=="NOT_PRIMARY")]) 
4164+9931#adds up to total
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "MULTIPLE" #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data$DATE=as.character(data$DATE)
data.Export$LabMethodInfo[which(data$DATE<="2001-12-31")]="Persulfate digestion simultaneous with TP/Cd reduction Valderrama 1980 (1990-2001)"
data.Export$LabMethodInfo[which(data$DATE> "2001-12-31")]="Furnace combustion/chemoluminescence detection, Shimadzu TOC-VCSH, TOC User Manaul 2001 (2002-2011)"
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #not specified in meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
tn.Final = data.Export
rm(data)
rm(data.Export)

###################################   CHLA (ug/l)   #############################################################################################################################
data=catskill_reservoirs
head(data)#snapshot of the data
names(data)#look at column names
#pull out columns of interest
data=data[,c(1:6,19,14,25:28)]
names(data)
#check for null values
unique(data$CHLA..ug.l.)#looking for problematic values, note that there are negative values
length(data$CHLA..ug.l.[which(is.na(data$CHLA..ug.l.)==TRUE)])
length(data$CHLA..ug.l.[which(data$CHLA..ug.l.=="")])
28601-17973# 10628 should remain after filtering out the null values
data=data[which(is.na(data$CHLA..ug.l.)==FALSE),]
#look at other variables-unique, etc..
#check for NA sample depths, if NA filter out because info on SamplePosition is not sufficient
length(data$ZSP...Sample.Depth..m..[which(is.na(data$ZSP...Sample.Depth..m..)==TRUE)])#2 obs NA
length(data$ZSP...Sample.Depth..m..[which(data$ZSP...Sample.Depth..m..=="")])
#continue looking at data
unique(data$lagos_LakeID)#LakeID
unique(data$STATION.)
#done filtering
#proceed to populating LAGOS template
###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$lagos_LakeID
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$reservoirname
data.Export$SourceVariableName = "CHLA (ug/l)"
data.Export$SourceVariableDescription = "Chlorophyll a"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no flags w/ these data
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 9
data.Export$LagosVariableName="Chlorophyll a"
names(data)
data.Export$Value = data$CHLA..ug.l. #export observations already in preff units
unique(data.Export$Value)
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$DATE #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType=data$sample_type
unique(data.Export$SampleType)
#check to make sure adds up to total
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #GOOD
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
#assign sampledepth 
data.Export$SampleDepth=data$sample_depth_final
unique(data.Export$SampleDepth)
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(is.na(data.Export$SampleDepth)==TRUE)]="UNKNOWN"#per metadata
data.Export$SamplePosition[which(is.na(data.Export$SampleDepth)==FALSE)]="SPECIFIED"
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")])#check to make sure correct number
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="UNKNOWN")])#check to make sure correct number
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
#assign primary to stations that represent the deep spot, the rest of the stations are not primary
unique(data$basin_type)
data.Export$BasinType[which(data$basin_type=="PRIMARY")]="PRIMARY" 
data.Export$BasinType[which(data$basin_type=="NOT_PRIMARY")]="NOT_PRIMARY" 
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) 
length(data.Export$BasinType[which(data.Export$BasinType=="NOT_PRIMARY")]) 
3740+6887#adds up to total
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "MULTIPLE" #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data$DATE=as.character(data$DATE)
data.Export$LabMethodInfo[which(data$DATE<="1998-12-31")]="SM 17/18: 10200, H3 (1984-1998)"
data.Export$LabMethodInfo[which(data$DATE> "1998-12-31")]="SM19: 10200, H5"
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #not specified in meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
chla.Final = data.Export
rm(data)
rm(data.Export)

###################################  NH3   #############################################################################################################################
data=catskill_reservoirs
head(data)#snapshot of the data
names(data)#look at column names
#pull out columns of interest
data=data[,c(1:6,19,15,25:28)]
names(data)
#check for null values
unique(data$NH3)#looking for problematic values, note that there are negative values
length(data$NH3[which(is.na(data$NH3)==TRUE)])
length(data$NH3[which(data$NH3=="")])
28601-13069# 15532 should remain after filtering out the null values
data=data[which(is.na(data$NH3)==FALSE),]
#look at other variables-unique, etc..
#check for NA sample depths, if NA filter out because info on SamplePosition is not sufficient
length(data$ZSP...Sample.Depth..m..[which(is.na(data$ZSP...Sample.Depth..m..)==TRUE)])#2 obs NA
length(data$ZSP...Sample.Depth..m..[which(data$ZSP...Sample.Depth..m..=="")])
#continue looking at data
unique(data$lagos_LakeID)#LakeID
unique(data$STATION.)
#done filtering
#proceed to populating LAGOS template
###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$lagos_LakeID
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$reservoirname
data.Export$SourceVariableName = "NH3"
data.Export$SourceVariableDescription = "Nitrogen NH3"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no flags w/ these data
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 19
data.Export$LagosVariableName="Nitrogen, NH4"
names(data)
data.Export$Value = data$NH3*1000 #export observations and convert to preff units
unique(data.Export$Value)
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$DATE #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType=data$sample_type
unique(data.Export$SampleType)
#check to make sure adds up to total
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #GOOD
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
#assign sampledepth 
data.Export$SampleDepth=data$sample_depth_final
unique(data.Export$SampleDepth)
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(is.na(data.Export$SampleDepth)==TRUE)]="UNKNOWN"#per metadata
data.Export$SamplePosition[which(is.na(data.Export$SampleDepth)==FALSE)]="SPECIFIED"
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")])#check to make sure correct number
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="UNKNOWN")])#check to make sure correct number
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
#assign primary to stations that represent the deep spot, the rest of the stations are not primary
unique(data$basin_type)
data.Export$BasinType[which(data$basin_type=="PRIMARY")]="PRIMARY" 
data.Export$BasinType[which(data$basin_type=="NOT_PRIMARY")]="NOT_PRIMARY" 
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) 
length(data.Export$BasinType[which(data.Export$BasinType=="NOT_PRIMARY")]) 
4543+10989#adds up to total
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "MULTIPLE" #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data$DATE=as.character(data$DATE)
data.Export$LabMethodInfo[which(data$DATE<="1989-12-31")]="SM16 (1988-1989)"
data.Export$LabMethodInfo[which(data$DATE> "1989-12-31")]="Automated phenate method (1990-1991)"
data.Export$LabMethodInfo[which(data$DATE> "1991-12-31")]="Automated salicylate method (SM 18; 4500-NH3, H; 1992-1994)"
data.Export$LabMethodInfo[which(data$DATE> "1994-12-31")]="Autmoated phenate method (SM18; 4500-NH3, H; 1995-1999)"
data.Export$LabMethodInfo[which(data$DATE> "1999-12-31")]="Flow Injection analysis- Lachat QucikChem 8500; Lachat 10-107-06-1-J"
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #not specified in meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
nh4.Final = data.Export
rm(data)
rm(data.Export)

################################### NO3NO2 (mg/l)   #############################################################################################################################
data=catskill_reservoirs
head(data)#snapshot of the data
names(data)#look at column names
#pull out columns of interest
data=data[,c(1:6,19,16,25:28)]
names(data)
#check for null values
unique(data$NO3NO2..mg.l.)#looking for problematic values, note that there are negative values
length(data$NO3NO2..mg.l.[which(is.na(data$NO3NO2..mg.l.)==TRUE)])
length(data$NO3NO2..mg.l.[which(data$NO3NO2..mg.l.=="")])
28601-15482# 13119 should remain after filtering out the null values
data=data[which(is.na(data$NO3NO2..mg.l.)==FALSE),]
#look at other variables-unique, etc..
#check for NA sample depths, if NA filter out because info on SamplePosition is not sufficient
length(data$ZSP...Sample.Depth..m..[which(is.na(data$ZSP...Sample.Depth..m..)==TRUE)])#1 obs NA
length(data$ZSP...Sample.Depth..m..[which(data$ZSP...Sample.Depth..m..=="")])
#continue looking at data
unique(data$lagos_LakeID)#LakeID
unique(data$STATION.)
#done filtering
#proceed to populating LAGOS template
###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$lagos_LakeID
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$reservoirname
data.Export$SourceVariableName = "NO3NO2 (mg/l)"
data.Export$SourceVariableDescription = "Nitrite + nitrate"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no flags w/ these data
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 18
data.Export$LagosVariableName="Nitrogen, nitrite (NO2) + nitrate (NO3)"
names(data)
data.Export$Value = data$NO3NO2..mg.l.*1000 #export observations and convert to preff units
unique(data.Export$Value)
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$DATE #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType=data$sample_type
unique(data.Export$SampleType)
#check to make sure adds up to total
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #GOOD
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
#assign sampledepth 
data.Export$SampleDepth=data$sample_depth_final
unique(data.Export$SampleDepth)
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(is.na(data.Export$SampleDepth)==TRUE)]="UNKNOWN"#per metadata
data.Export$SamplePosition[which(is.na(data.Export$SampleDepth)==FALSE)]="SPECIFIED"
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")])#check to make sure correct number
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="UNKNOWN")])#check to make sure correct number
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
#assign primary to stations that represent the deep spot, the rest of the stations are not primary
unique(data$basin_type)
data.Export$BasinType[which(data$basin_type=="PRIMARY")]="PRIMARY" 
data.Export$BasinType[which(data$basin_type=="NOT_PRIMARY")]="NOT_PRIMARY" 
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) 
length(data.Export$BasinType[which(data.Export$BasinType=="NOT_PRIMARY")]) 
3666+9453#adds up to total
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "MULTIPLE" #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data$DATE=as.character(data$DATE)
data.Export$LabMethodInfo[which(data$DATE<="1989-12-31")]="SM16: 418F (1988-1989)"
data.Export$LabMethodInfo[which(data$DATE> "1989-12-31")]="SM17; 4500NO3-F (1990-1997)"
data.Export$LabMethodInfo[which(data$DATE> "1997-12-31")]=" Flow Injection Analysis, Lachat QucikChem 8500; Lachat10-107-04-1C (1998 or 1999-2011)"
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #not specified in meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
no3no2.Final = data.Export
rm(data)
rm(data.Export)

################################### ZSD (m)  #############################################################################################################################
data=catskill_reservoirs
head(data)#snapshot of the data
names(data)#look at column names
#pull out columns of interest
data=data[,c(1:6,17,25,26)]
names(data)
#check for null values
unique(data$ZSD..m.)#looking for problematic values, note that there are negative values
length(data$ZSD..m.[which(is.na(data$ZSD..m.)==TRUE)])
length(data$ZSD..m.[which(data$ZSD..m.=="")])
length(data$ZSD..m.[which(data$ZSD..m.==-110.00)])
28601-13204-14# 15383 should remain after filtering out the null and -110 values
data=data[which(is.na(data$ZSD..m.)==FALSE),]
data=data[which(data$ZSD..m.!=-110.00),]

#continue looking at data
unique(data$lagos_LakeID)#LakeID
unique(data$STATION.)
#done filtering
#proceed to populating LAGOS template
###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$lagos_LakeID
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$reservoirname
data.Export$SourceVariableName = "ZSD (m)"
data.Export$SourceVariableDescription = "Secchi, unknown"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no flags w/ these data
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 30
data.Export$LagosVariableName="Secchi"
names(data)
data.Export$Value = data$ZSD..m. #export observations already in  preff units
unique(data.Export$Value)
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$DATE #date already in correct format
data.Export$Units="m"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="SPECIFIED"#per metadata
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")])
#assign sampledepth 
data.Export$SampleDepth=NA#because secchi
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
#assign primary to stations that represent the deep spot, the rest of the stations are not primary
unique(data$basin_type)
data.Export$BasinType[which(data$basin_type=="PRIMARY")]="PRIMARY" 
data.Export$BasinType[which(data$basin_type=="NOT_PRIMARY")]="NOT_PRIMARY" 
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) 
length(data.Export$BasinType[which(data.Export$BasinType=="NOT_PRIMARY")]) 
5089+10294#adds up to total
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA#per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="calculated as avg of 2 observations from shady side of boat, by 2 persons and within 19% of each other"
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #not specified in meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
secchi.Final = data.Export
rm(data)
rm(data.Export)

################################### ZVB- Viewer Scope (m)    #############################################################################################################################
data=catskill_reservoirs
head(data)#snapshot of the data
names(data)#look at column names
#pull out columns of interest
data=data[,c(1:6,18,25,26)]
names(data)
#check for null values
unique(data$ZVB..Viewer.Scope..m.)#looking for problematic values, note that there are negative values
length(data$ZVB..Viewer.Scope..m.[which(is.na(data$ZVB..Viewer.Scope..m.)==TRUE)])
length(data$ZVB..Viewer.Scope..m.[which(data$ZVB..Viewer.Scope..m.=="")])
length(data$ZVB..Viewer.Scope..m.[which(data$ZVB..Viewer.Scope..m.==-110.00)])
28601-15736-153# 12712 should remain after filtering out the null and -110 values
data=data[which(is.na(data$ZVB..Viewer.Scope..m.)==FALSE),]
data=data[which(data$ZVB..Viewer.Scope..m.!=-110.00),]

#continue looking at data
unique(data$lagos_LakeID)#LakeID
unique(data$STATION.)
#done filtering
#proceed to populating LAGOS template
###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$lagos_LakeID
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$reservoirname
data.Export$SourceVariableName = "ZVB- Viewer Scope (m)"
data.Export$SourceVariableDescription = "Secchi, view"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no flags w/ these data
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 30
data.Export$LagosVariableName="Secchi"
names(data)
data.Export$Value = data$ZVB..Viewer.Scope..m. #export observations already in  preff units
unique(data.Export$Value)
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$DATE #date already in correct format
data.Export$Units="m"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="SPECIFIED"#per metadata
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")])
#assign sampledepth 
data.Export$SampleDepth=NA#because secchi
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
#assign primary to stations that represent the deep spot, the rest of the stations are not primary
unique(data$basin_type)
data.Export$BasinType[which(data$basin_type=="PRIMARY")]="PRIMARY" 
data.Export$BasinType[which(data$basin_type=="NOT_PRIMARY")]="NOT_PRIMARY" 
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) 
length(data.Export$BasinType[which(data.Export$BasinType=="NOT_PRIMARY")]) 
3784+8928#adds up to total
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = "SECCHI_VIEW" #per  meta
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA#per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo= NA #per meta
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #not specified in meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
secchi1.Final = data.Export
rm(data)
rm(data.Export)

###################################### final export ########################################################################################
Final.Export = rbind(color.Final,tp.Final,doc.Final,tn.Final,chla.Final,no3no2.Final,nh4.Final,secchi.Final,secchi1.Final)
#########################################################################
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
18722+112814#adds up to total
##write table
Final.Export1=data1
typeof(Final.Export1$Value)
length(Final.Export1$Value[which(Final.Export1$Value<0)])
negative.df=Final.Export1[which(Final.Export1$Value<0),]
unique(negative.df$SourceVariableName)
131536-8244#no. remaining after filtering out negatives
Final.Export1=Final.Export1[which(Final.Export1$Value>=0),]
nosamplepos=Final.Export1[which(is.na(Final.Export1$SampleDepth)==TRUE & Final.Export1$SamplePosition=="UNKNOWN"),]
write.table(Final.Export1,file="DataImport_NY_CDEP_CATSKILL.csv",row.names=FALSE,sep=",")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/NY data/Catskills_Reservoirs/DataImport_NY_CDEP_CATSKILL/DataImport_NY_CDEP_CATSKILL.RData")
