#set path to files
setwd("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/WI data/FCPC Lake Data (Finished)/DataImport_WI_FCPC_CHEM")
setwd("C:/Users/Sam/Dropbox/CSI-LIMNO_DATA/DATA-lake/WI data/FCPC Lake Data (Finished)/DataImport_WI_FCPC_CHEM")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/WI data/FCPC Lake Data (Finished)/DataImport_WI_FCPC_CHEM/DataImport_WI_FCPC_CHEM.RData")

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
#data collected by Forest County Potawatomi Community Water Resources Program
#wq monitoring program
#no flags, censor observations less than the detection limit
#see data import log for info as to how the source data file was compiled & for details about other import decisions made during this import effort
###########################################################################################################################################################################################
################################### DOC (mg/L)  #############################################################################################################################
data=fcpc_chem_final
names(data)#look at column names
unique(data$lakename)#note that those lake names with "deep" are hypo samples
#check for null values
length(data$DOC..mg.L.[which(is.na(data$DOC..mg.L.)==TRUE)])
length(data$DOC..mg.L.[which(data$DOC..mg.L.=="")])
513-24#489 obs remain after filterin gnull
data=data[which(is.na(data$DOC..mg.L.)==FALSE),]
#check other column values
unique(data$Sample.Depth..ft.)#these are sample depths for the hypo samples, all epi samples are 1 foot


#done filtering

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID=as.character(data.Export$LakeID)
data.Export$LakeID[which(data$lakename=="BUG LAKE")]="574100"
data.Export$LakeID[which(data$lakename=="BUG LAKE DEEP")]="574100"
data.Export$LakeID[which(data$lakename=="CLOUD LAKE")]="499700"
data.Export$LakeID[which(data$lakename=="CLOUD LAKE DEEP")]="499700"
data.Export$LakeID[which(data$lakename=="DEVILS LAKE")]="396700"
data.Export$LakeID[which(data$lakename=="DEVILS LAKE DEEP")]="396700"
data.Export$LakeID[which(data$lakename=="KING LAKE")]="501700"
data.Export$LakeID[which(data$lakename=="KING LAKE DEEP")]="501700"
unique(data.Export$LakeID)#only four=good
#now export text lake name
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName[which(data$lakename=="BUG LAKE")]="BUG LAKE"
data.Export$LakeName[which(data$lakename=="BUG LAKE DEEP")]="BUG LAKE"
data.Export$LakeName[which(data$lakename=="CLOUD LAKE")]="CLOUD LAKE"
data.Export$LakeName[which(data$lakename=="CLOUD LAKE DEEP")]="CLOUD LAKE"
data.Export$LakeName[which(data$lakename=="DEVILS LAKE")]="DEVILS LAKE"
data.Export$LakeName[which(data$lakename=="DEVILS LAKE DEEP")]="DEVILS LAKE"
data.Export$LakeName[which(data$lakename=="KING LAKE")]="KING LAKE"
data.Export$LakeName[which(data$lakename=="KING LAKE DEEP")]="KING LAKE"
unique(data.Export$LakeName)#only 4=good
#continue exporting
data.Export$SourceVariableName = "DOC (mg/L)"
data.Export$SourceVariableDescription = "Dissolved organic carbon"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA 
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 6
data.Export$LagosVariableName="Carbon, dissolved organic"
names(data)
data$DOC..mg.L.=as.numeric(data$DOC..mg.L.)
names(data)
data.Export$Value = data[,11] #export observations already in preferred units
data.Export$DetectionLimit= 0.54 #per meta
length(data.Export$Value[which(data.Export$Value<data.Export$DetectionLimit)])
#don't have to censor any all obs greater than detection limit
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$Date#date already in correct format
data.Export$Units="mg/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadatA
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(data$lakename=="BUG LAKE")]="EPI"
data.Export$SamplePosition[which(data$lakename=="CLOUD LAKE")]="EPI"
data.Export$SamplePosition[which(data$lakename=="DEVILS LAKE")]="EPI"
data.Export$SamplePosition[which(data$lakename=="KING LAKE")]="EPI"
data.Export$SamplePosition[which(data$lakename=="BUG LAKE DEEP")]="HYPO"
data.Export$SamplePosition[which(data$lakename=="CLOUD LAKE DEEP")]="HYPO"
data.Export$SamplePosition[which(data$lakename=="DEVILS LAKE DEEP")]="HYPO"
data.Export$SamplePosition[which(data$lakename=="KING LAKE DEEP")]="HYPO"
unique(data.Export$SamplePosition)#only two=good
#assign sampledepth 
data.Export$SampleDepth=(data$Sample.Depth..ft.)*.3048 #export sample depths for hypo observations, convert to meters
data.Export$SampleDepth[which(data.Export$SamplePosition=="EPI")]= .3048 #meta states epi samples collected 1 ft. below surface, convert to meters
unique(data.Export$SampleDepth)
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])
#32 OBS are NA for sample depth (hypo observations)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY" #metadata specifies that the deep hole was sampled
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) #check to make sure CORRECT NUMBER populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "EPA_9060AM" #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
doc.Final = data.Export
rm(data.Export)
rm(data)

################################### CC a (ug/L) #############################################################################################################################
data=fcpc_chem_final
names(data)#look at column names
unique(data$lakename)#note that those lake names with "deep" are hypo samples
#check for null values
length(data$CC.a..ug.L.[which(is.na(data$CC.a..ug.L.)==TRUE)])
length(data$CC.a..ug.L.[which(data$CC.a..ug.L.=="")])
unique(data$CC.a..ug.L.)#looking for problematic observations-characters etc.
513-1#512 obs remain after filterin gnull
data=data[which(is.na(data$CC.a..ug.L.)==FALSE),]
#check other column values
unique(data$Sample.Depth..ft.)#these are sample depths for the hypo samples, all epi samples are 1 foot 

#done filtering

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID=as.character(data.Export$LakeID)
data.Export$LakeID[which(data$lakename=="BUG LAKE")]="574100"
data.Export$LakeID[which(data$lakename=="BUG LAKE DEEP")]="574100"
data.Export$LakeID[which(data$lakename=="CLOUD LAKE")]="499700"
data.Export$LakeID[which(data$lakename=="CLOUD LAKE DEEP")]="499700"
data.Export$LakeID[which(data$lakename=="DEVILS LAKE")]="396700"
data.Export$LakeID[which(data$lakename=="DEVILS LAKE DEEP")]="396700"
data.Export$LakeID[which(data$lakename=="KING LAKE")]="501700"
data.Export$LakeID[which(data$lakename=="KING LAKE DEEP")]="501700"
unique(data.Export$LakeID)#only four=good
#now export text lake name
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName[which(data$lakename=="BUG LAKE")]="BUG LAKE"
data.Export$LakeName[which(data$lakename=="BUG LAKE DEEP")]="BUG LAKE"
data.Export$LakeName[which(data$lakename=="CLOUD LAKE")]="CLOUD LAKE"
data.Export$LakeName[which(data$lakename=="CLOUD LAKE DEEP")]="CLOUD LAKE"
data.Export$LakeName[which(data$lakename=="DEVILS LAKE")]="DEVILS LAKE"
data.Export$LakeName[which(data$lakename=="DEVILS LAKE DEEP")]="DEVILS LAKE"
data.Export$LakeName[which(data$lakename=="KING LAKE")]="KING LAKE"
data.Export$LakeName[which(data$lakename=="KING LAKE DEEP")]="KING LAKE"
unique(data.Export$LakeName)#only 4=good
#continue exporting
data.Export$SourceVariableName = "CC a (ug/L)"
data.Export$SourceVariableDescription = "Corrected chlorophyll a (ug/L)"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA 
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 9
data.Export$LagosVariableName="Chlorophyll a"
names(data)
data.Export$Value = data[,6] #export observations already in preferred units
data.Export$DetectionLimit= 0.10 #per meta
length(data.Export$Value[which(data.Export$Value<=data.Export$DetectionLimit)])
unique(data.Export$Value)#looking at values
#censor observation that is less than the detection limit
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data.Export$Value<=data.Export$DetectionLimit)]="LT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]="NC" #SET remaining obs. to not censored "NC"
unique(data.Export$CensorCode)
#continue exporting
data.Export$Date = data$Date#date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadatA
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(data$lakename=="BUG LAKE")]="EPI"
data.Export$SamplePosition[which(data$lakename=="CLOUD LAKE")]="EPI"
data.Export$SamplePosition[which(data$lakename=="DEVILS LAKE")]="EPI"
data.Export$SamplePosition[which(data$lakename=="KING LAKE")]="EPI"
data.Export$SamplePosition[which(data$lakename=="BUG LAKE DEEP")]="HYPO"
data.Export$SamplePosition[which(data$lakename=="CLOUD LAKE DEEP")]="HYPO"
data.Export$SamplePosition[which(data$lakename=="DEVILS LAKE DEEP")]="HYPO"
data.Export$SamplePosition[which(data$lakename=="KING LAKE DEEP")]="HYPO"
unique(data.Export$SamplePosition)#only two=good
#assign sampledepth 
data.Export$SampleDepth=(data$Sample.Depth..ft.)*.3048 #export sample depths for hypo observations, convert to meters
data.Export$SampleDepth[which(data.Export$SamplePosition=="EPI")]= .3048 #meta states epi samples collected 1 ft. below surface, convert to meters
unique(data.Export$SampleDepth)
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])
#32 OBS are NA for sample depth (hypo observations)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY" #metadata specifies that the deep hole was sampled
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) #check to make sure CORRECT NUMBER populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "APHA_10200H" #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
chla.Final = data.Export
rm(data.Export)
rm(data)

################################### Nitrogen, Ammonia as N (mg/L) #############################################################################################################################
data=fcpc_chem_final
names(data)#look at column names
unique(data$lakename)#note that those lake names with "deep" are hypo samples
#check for null values
length(data$Nitrogen..Ammonia.as.N..mg.L.[which(is.na(data$Nitrogen..Ammonia.as.N..mg.L.)==TRUE)])
length(data$Nitrogen..Ammonia.as.N..mg.L.[which(data$Nitrogen..Ammonia.as.N..mg.L.=="")])
unique(data$Nitrogen..Ammonia.as.N..mg.L.)#looking for problematic observations-characters etc.
513-18#495 obs remain after filterin gnull
data=data[which(is.na(data$Nitrogen..Ammonia.as.N..mg.L.)==FALSE),]
#check other column values
unique(data$Sample.Depth..ft.)#these are sample depths for the hypo samples, all epi samples are 1 foot 

#done filtering

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID=as.character(data.Export$LakeID)
data.Export$LakeID[which(data$lakename=="BUG LAKE")]="574100"
data.Export$LakeID[which(data$lakename=="BUG LAKE DEEP")]="574100"
data.Export$LakeID[which(data$lakename=="CLOUD LAKE")]="499700"
data.Export$LakeID[which(data$lakename=="CLOUD LAKE DEEP")]="499700"
data.Export$LakeID[which(data$lakename=="DEVILS LAKE")]="396700"
data.Export$LakeID[which(data$lakename=="DEVILS LAKE DEEP")]="396700"
data.Export$LakeID[which(data$lakename=="KING LAKE")]="501700"
data.Export$LakeID[which(data$lakename=="KING LAKE DEEP")]="501700"
unique(data.Export$LakeID)#only four=good
#now export text lake name
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName[which(data$lakename=="BUG LAKE")]="BUG LAKE"
data.Export$LakeName[which(data$lakename=="BUG LAKE DEEP")]="BUG LAKE"
data.Export$LakeName[which(data$lakename=="CLOUD LAKE")]="CLOUD LAKE"
data.Export$LakeName[which(data$lakename=="CLOUD LAKE DEEP")]="CLOUD LAKE"
data.Export$LakeName[which(data$lakename=="DEVILS LAKE")]="DEVILS LAKE"
data.Export$LakeName[which(data$lakename=="DEVILS LAKE DEEP")]="DEVILS LAKE"
data.Export$LakeName[which(data$lakename=="KING LAKE")]="KING LAKE"
data.Export$LakeName[which(data$lakename=="KING LAKE DEEP")]="KING LAKE"
unique(data.Export$LakeName)#only 4=good
#continue exporting
data.Export$SourceVariableName = "Nitrogen, Ammonia as N (mg/L)"
data.Export$SourceVariableDescription = "Ammonia NH3"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA 
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 19
data.Export$LagosVariableName="Nitrogen, NH4"
names(data)
data.Export$Value = data[,9]*1000 #export observations and convert to preferred units
data.Export$DetectionLimit= 25 #per meta
length(data.Export$Value[which(data.Export$Value<=data.Export$DetectionLimit)])
#135 obs less than or equal to detection limit
unique(data.Export$Value)#looking at values
#censor observations that is less than or equal to the detection limit
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data.Export$Value<=data.Export$DetectionLimit)]="LT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]="NC" #SET remaining obs. to not censored "NC"
unique(data.Export$CensorCode)
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure proper number
#continue exporting
data.Export$Date = data$Date#date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadatA
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(data$lakename=="BUG LAKE")]="EPI"
data.Export$SamplePosition[which(data$lakename=="CLOUD LAKE")]="EPI"
data.Export$SamplePosition[which(data$lakename=="DEVILS LAKE")]="EPI"
data.Export$SamplePosition[which(data$lakename=="KING LAKE")]="EPI"
data.Export$SamplePosition[which(data$lakename=="BUG LAKE DEEP")]="HYPO"
data.Export$SamplePosition[which(data$lakename=="CLOUD LAKE DEEP")]="HYPO"
data.Export$SamplePosition[which(data$lakename=="DEVILS LAKE DEEP")]="HYPO"
data.Export$SamplePosition[which(data$lakename=="KING LAKE DEEP")]="HYPO"
unique(data.Export$SamplePosition)#only two=good
#assign sampledepth 
data.Export$SampleDepth=(data$Sample.Depth..ft.)*.3048 #export sample depths for hypo observations, convert to meters
data.Export$SampleDepth[which(data.Export$SamplePosition=="EPI")]= .3048 #meta states epi samples collected 1 ft. below surface, convert to meters
unique(data.Export$SampleDepth)
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])
#32 OBS are NA for sample depth (hypo observations)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY" #metadata specifies that the deep hole was sampled
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) #check to make sure CORRECT NUMBER populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "EPA_350.1" #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
nh4.Final = data.Export
rm(data.Export)
rm(data)

################################### Nitrate and Nitrite (mg/L)  #############################################################################################################################
data=fcpc_chem_final
names(data)#look at column names
unique(data$lakename)#note that those lake names with "deep" are hypo samples
#check for null values
length(data$Nitrate.and.Nitrite..mg.L.[which(is.na(data$Nitrate.and.Nitrite..mg.L.)==TRUE)])
length(data$Nitrate.and.Nitrite..mg.L.[which(data$Nitrate.and.Nitrite..mg.L.=="")])
unique(data$Nitrate.and.Nitrite..mg.L.)#looking for problematic observations-characters etc.
513-18#495 obs remain after filterin gnull
data=data[which(is.na(data$Nitrate.and.Nitrite..mg.L.)==FALSE),]
#check other column values
unique(data$Sample.Depth..ft.)#these are sample depths for the hypo samples, all epi samples are 1 foot 

#done filtering

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID=as.character(data.Export$LakeID)
data.Export$LakeID[which(data$lakename=="BUG LAKE")]="574100"
data.Export$LakeID[which(data$lakename=="BUG LAKE DEEP")]="574100"
data.Export$LakeID[which(data$lakename=="CLOUD LAKE")]="499700"
data.Export$LakeID[which(data$lakename=="CLOUD LAKE DEEP")]="499700"
data.Export$LakeID[which(data$lakename=="DEVILS LAKE")]="396700"
data.Export$LakeID[which(data$lakename=="DEVILS LAKE DEEP")]="396700"
data.Export$LakeID[which(data$lakename=="KING LAKE")]="501700"
data.Export$LakeID[which(data$lakename=="KING LAKE DEEP")]="501700"
unique(data.Export$LakeID)#only four=good
#now export text lake name
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName[which(data$lakename=="BUG LAKE")]="BUG LAKE"
data.Export$LakeName[which(data$lakename=="BUG LAKE DEEP")]="BUG LAKE"
data.Export$LakeName[which(data$lakename=="CLOUD LAKE")]="CLOUD LAKE"
data.Export$LakeName[which(data$lakename=="CLOUD LAKE DEEP")]="CLOUD LAKE"
data.Export$LakeName[which(data$lakename=="DEVILS LAKE")]="DEVILS LAKE"
data.Export$LakeName[which(data$lakename=="DEVILS LAKE DEEP")]="DEVILS LAKE"
data.Export$LakeName[which(data$lakename=="KING LAKE")]="KING LAKE"
data.Export$LakeName[which(data$lakename=="KING LAKE DEEP")]="KING LAKE"
unique(data.Export$LakeName)#only 4=good
#continue exporting
data.Export$SourceVariableName = "Nitrate and Nitrite (mg/L)"
data.Export$SourceVariableDescription = "Nitrate and Nitrite"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA 
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 18
data.Export$LagosVariableName="Nitrogen, nitrite (NO2) + nitrate (NO3)"
names(data)
data.Export$Value = data[,8]*1000 #export observations and convert to preferred units
data.Export$DetectionLimit= 25 #per meta
length(data.Export$Value[which(data.Export$Value<=data.Export$DetectionLimit)])
#294 obs less than or equal to detection limit
unique(data.Export$Value)#looking at values
#censor observations that is less than or equal to the detection limit
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data.Export$Value<=data.Export$DetectionLimit)]="LT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]="NC" #SET remaining obs. to not censored "NC"
unique(data.Export$CensorCode)
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure proper number
#continue exporting
data.Export$Date = data$Date#date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadatA
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(data$lakename=="BUG LAKE")]="EPI"
data.Export$SamplePosition[which(data$lakename=="CLOUD LAKE")]="EPI"
data.Export$SamplePosition[which(data$lakename=="DEVILS LAKE")]="EPI"
data.Export$SamplePosition[which(data$lakename=="KING LAKE")]="EPI"
data.Export$SamplePosition[which(data$lakename=="BUG LAKE DEEP")]="HYPO"
data.Export$SamplePosition[which(data$lakename=="CLOUD LAKE DEEP")]="HYPO"
data.Export$SamplePosition[which(data$lakename=="DEVILS LAKE DEEP")]="HYPO"
data.Export$SamplePosition[which(data$lakename=="KING LAKE DEEP")]="HYPO"
unique(data.Export$SamplePosition)#only two=good
#assign sampledepth 
data.Export$SampleDepth=(data$Sample.Depth..ft.)*.3048 #export sample depths for hypo observations, convert to meters
data.Export$SampleDepth[which(data.Export$SamplePosition=="EPI")]= .3048 #meta states epi samples collected 1 ft. below surface, convert to meters
unique(data.Export$SampleDepth)
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])
#32 OBS are NA for sample depth (hypo observations)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY" #metadata specifies that the deep hole was sampled
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) #check to make sure CORRECT NUMBER populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "EPA_353.2" #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
no3no2.Final = data.Export
rm(data.Export)
rm(data)

################################### TKN (mg/L)  #############################################################################################################################
data=fcpc_chem_final
names(data)#look at column names
unique(data$lakename)#note that those lake names with "deep" are hypo samples
#check for null values
length(data$TKN..mg.L.[which(is.na(data$TKN..mg.L.)==TRUE)])
length(data$TKN..mg.L.[which(data$TKN..mg.L.=="")])
unique(data$TKN..mg.L.)#looking for problematic observations-characters etc.
513-18#495 obs remain after filterin gnull
data=data[which(is.na(data$TKN..mg.L.)==FALSE),]
#check other column values
unique(data$Sample.Depth..ft.)#these are sample depths for the hypo samples, all epi samples are 1 foot 

#done filtering

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID=as.character(data.Export$LakeID)
data.Export$LakeID[which(data$lakename=="BUG LAKE")]="574100"
data.Export$LakeID[which(data$lakename=="BUG LAKE DEEP")]="574100"
data.Export$LakeID[which(data$lakename=="CLOUD LAKE")]="499700"
data.Export$LakeID[which(data$lakename=="CLOUD LAKE DEEP")]="499700"
data.Export$LakeID[which(data$lakename=="DEVILS LAKE")]="396700"
data.Export$LakeID[which(data$lakename=="DEVILS LAKE DEEP")]="396700"
data.Export$LakeID[which(data$lakename=="KING LAKE")]="501700"
data.Export$LakeID[which(data$lakename=="KING LAKE DEEP")]="501700"
unique(data.Export$LakeID)#only four=good
#now export text lake name
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName[which(data$lakename=="BUG LAKE")]="BUG LAKE"
data.Export$LakeName[which(data$lakename=="BUG LAKE DEEP")]="BUG LAKE"
data.Export$LakeName[which(data$lakename=="CLOUD LAKE")]="CLOUD LAKE"
data.Export$LakeName[which(data$lakename=="CLOUD LAKE DEEP")]="CLOUD LAKE"
data.Export$LakeName[which(data$lakename=="DEVILS LAKE")]="DEVILS LAKE"
data.Export$LakeName[which(data$lakename=="DEVILS LAKE DEEP")]="DEVILS LAKE"
data.Export$LakeName[which(data$lakename=="KING LAKE")]="KING LAKE"
data.Export$LakeName[which(data$lakename=="KING LAKE DEEP")]="KING LAKE"
unique(data.Export$LakeName)#only 4=good
#continue exporting
data.Export$SourceVariableName = "TKN (mg/L)"
data.Export$SourceVariableDescription = "Total kjeldahl"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA 
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 16
data.Export$LagosVariableName="Nitrogen, total Kjeldahl"
names(data)
data.Export$Value = data[,10]*1000 #export observations and convert to preferred units
data.Export$DetectionLimit= 89 #per meta
length(data.Export$Value[which(data.Export$Value<=data.Export$DetectionLimit)])
#4 obs less than or equal to detection limit
unique(data.Export$Value)#looking at values
#censor observations that is less than or equal to the detection limit
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data.Export$Value<=data.Export$DetectionLimit)]="LT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]="NC" #SET remaining obs. to not censored "NC"
unique(data.Export$CensorCode)
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure proper number
#continue exporting
data.Export$Date = data$Date#date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadatA
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(data$lakename=="BUG LAKE")]="EPI"
data.Export$SamplePosition[which(data$lakename=="CLOUD LAKE")]="EPI"
data.Export$SamplePosition[which(data$lakename=="DEVILS LAKE")]="EPI"
data.Export$SamplePosition[which(data$lakename=="KING LAKE")]="EPI"
data.Export$SamplePosition[which(data$lakename=="BUG LAKE DEEP")]="HYPO"
data.Export$SamplePosition[which(data$lakename=="CLOUD LAKE DEEP")]="HYPO"
data.Export$SamplePosition[which(data$lakename=="DEVILS LAKE DEEP")]="HYPO"
data.Export$SamplePosition[which(data$lakename=="KING LAKE DEEP")]="HYPO"
unique(data.Export$SamplePosition)#only two=good
#assign sampledepth 
data.Export$SampleDepth=(data$Sample.Depth..ft.)*.3048 #export sample depths for hypo observations, convert to meters
data.Export$SampleDepth[which(data.Export$SamplePosition=="EPI")]= .3048 #meta states epi samples collected 1 ft. below surface, convert to meters
unique(data.Export$SampleDepth)
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])
#32 OBS are NA for sample depth (hypo observations)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY" #metadata specifies that the deep hole was sampled
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) #check to make sure CORRECT NUMBER populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "EPA_351.2" #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
tkn.Final = data.Export
rm(data.Export)
rm(data)

################################### Phosphorus, Ortho (mg/L)  #############################################################################################################################
data=fcpc_chem_final
names(data)#look at column names
unique(data$lakename)#note that those lake names with "deep" are hypo samples
#check for null values
length(data$Phosphorus..Ortho..mg.L.[which(is.na(data$Phosphorus..Ortho..mg.L.)==TRUE)])
length(data$Phosphorus..Ortho..mg.L.[which(data$Phosphorus..Ortho..mg.L.=="")])
unique(data$Phosphorus..Ortho..mg.L.)#looking for problematic observations-characters etc.
513-17#496 obs remain after filterin gnull
data=data[which(is.na(data$Phosphorus..Ortho..mg.L.)==FALSE),]
#check other column values
unique(data$Sample.Depth..ft.)#these are sample depths for the hypo samples, all epi samples are 1 foot 

#done filtering

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID=as.character(data.Export$LakeID)
data.Export$LakeID[which(data$lakename=="BUG LAKE")]="574100"
data.Export$LakeID[which(data$lakename=="BUG LAKE DEEP")]="574100"
data.Export$LakeID[which(data$lakename=="CLOUD LAKE")]="499700"
data.Export$LakeID[which(data$lakename=="CLOUD LAKE DEEP")]="499700"
data.Export$LakeID[which(data$lakename=="DEVILS LAKE")]="396700"
data.Export$LakeID[which(data$lakename=="DEVILS LAKE DEEP")]="396700"
data.Export$LakeID[which(data$lakename=="KING LAKE")]="501700"
data.Export$LakeID[which(data$lakename=="KING LAKE DEEP")]="501700"
unique(data.Export$LakeID)#only four=good
#now export text lake name
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName[which(data$lakename=="BUG LAKE")]="BUG LAKE"
data.Export$LakeName[which(data$lakename=="BUG LAKE DEEP")]="BUG LAKE"
data.Export$LakeName[which(data$lakename=="CLOUD LAKE")]="CLOUD LAKE"
data.Export$LakeName[which(data$lakename=="CLOUD LAKE DEEP")]="CLOUD LAKE"
data.Export$LakeName[which(data$lakename=="DEVILS LAKE")]="DEVILS LAKE"
data.Export$LakeName[which(data$lakename=="DEVILS LAKE DEEP")]="DEVILS LAKE"
data.Export$LakeName[which(data$lakename=="KING LAKE")]="KING LAKE"
data.Export$LakeName[which(data$lakename=="KING LAKE DEEP")]="KING LAKE"
unique(data.Export$LakeName)#only 4=good
#continue exporting
data.Export$SourceVariableName = "Phosphorus, Ortho (mg/L)"
data.Export$SourceVariableDescription = "Ortho phosphorus"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA 
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 26
data.Export$LagosVariableName="Phosphorus, soluable reactive orthophosphate"
names(data)
data.Export$Value = data[,12]*1000 #export observations and convert to preferred units
data.Export$DetectionLimit= 7 #per meta
length(data.Export$Value[which(data.Export$Value<=data.Export$DetectionLimit)])
#372 obs less than or equal to detection limit
unique(data.Export$Value)#looking at values
#censor observations that is less than or equal to the detection limit
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data.Export$Value<=data.Export$DetectionLimit)]="LT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]="NC" #SET remaining obs. to not censored "NC"
unique(data.Export$CensorCode)
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure proper number
#continue exporting
data.Export$Date = data$Date#date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadatA
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(data$lakename=="BUG LAKE")]="EPI"
data.Export$SamplePosition[which(data$lakename=="CLOUD LAKE")]="EPI"
data.Export$SamplePosition[which(data$lakename=="DEVILS LAKE")]="EPI"
data.Export$SamplePosition[which(data$lakename=="KING LAKE")]="EPI"
data.Export$SamplePosition[which(data$lakename=="BUG LAKE DEEP")]="HYPO"
data.Export$SamplePosition[which(data$lakename=="CLOUD LAKE DEEP")]="HYPO"
data.Export$SamplePosition[which(data$lakename=="DEVILS LAKE DEEP")]="HYPO"
data.Export$SamplePosition[which(data$lakename=="KING LAKE DEEP")]="HYPO"
unique(data.Export$SamplePosition)#only two=good
#assign sampledepth 
data.Export$SampleDepth=(data$Sample.Depth..ft.)*.3048 #export sample depths for hypo observations, convert to meters
data.Export$SampleDepth[which(data.Export$SamplePosition=="EPI")]= .3048 #meta states epi samples collected 1 ft. below surface, convert to meters
unique(data.Export$SampleDepth)
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])
#32 OBS are NA for sample depth (hypo observations)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY" #metadata specifies that the deep hole was sampled
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) #check to make sure CORRECT NUMBER populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "EPA_365.2" #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
drp.Final = data.Export
rm(data.Export)
rm(data)

################################### Total Phosphorus (mg/L)  #############################################################################################################################
data=fcpc_chem_final
names(data)#look at column names
unique(data$lakename)#note that those lake names with "deep" are hypo samples
#check for null values
length(data$Total.Phosphorus..mg.L.[which(is.na(data$Total.Phosphorus..mg.L.)==TRUE)])
length(data$Total.Phosphorus..mg.L.[which(data$Total.Phosphorus..mg.L.=="")])
unique(data$Total.Phosphorus..mg.L.)#looking for problematic observations-characters etc.
513-2#511 obs remain after filterin gnull
data=data[which(is.na(data$Total.Phosphorus..mg.L.)==FALSE),]
#check other column values
unique(data$Sample.Depth..ft.)#these are sample depths for the hypo samples, all epi samples are 1 foot 

#done filtering

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID=as.character(data.Export$LakeID)
data.Export$LakeID[which(data$lakename=="BUG LAKE")]="574100"
data.Export$LakeID[which(data$lakename=="BUG LAKE DEEP")]="574100"
data.Export$LakeID[which(data$lakename=="CLOUD LAKE")]="499700"
data.Export$LakeID[which(data$lakename=="CLOUD LAKE DEEP")]="499700"
data.Export$LakeID[which(data$lakename=="DEVILS LAKE")]="396700"
data.Export$LakeID[which(data$lakename=="DEVILS LAKE DEEP")]="396700"
data.Export$LakeID[which(data$lakename=="KING LAKE")]="501700"
data.Export$LakeID[which(data$lakename=="KING LAKE DEEP")]="501700"
unique(data.Export$LakeID)#only four=good
#now export text lake name
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName[which(data$lakename=="BUG LAKE")]="BUG LAKE"
data.Export$LakeName[which(data$lakename=="BUG LAKE DEEP")]="BUG LAKE"
data.Export$LakeName[which(data$lakename=="CLOUD LAKE")]="CLOUD LAKE"
data.Export$LakeName[which(data$lakename=="CLOUD LAKE DEEP")]="CLOUD LAKE"
data.Export$LakeName[which(data$lakename=="DEVILS LAKE")]="DEVILS LAKE"
data.Export$LakeName[which(data$lakename=="DEVILS LAKE DEEP")]="DEVILS LAKE"
data.Export$LakeName[which(data$lakename=="KING LAKE")]="KING LAKE"
data.Export$LakeName[which(data$lakename=="KING LAKE DEEP")]="KING LAKE"
unique(data.Export$LakeName)#only 4=good
#continue exporting
data.Export$SourceVariableName = "Total Phosphorus (mg/L)"
data.Export$SourceVariableDescription = "Total phosphorus"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA 
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 27
data.Export$LagosVariableName="Phosphorus, total"
names(data)
data.Export$Value = data[,13]*1000 #export observations and convert to preferred units
data.Export$DetectionLimit= 7 #per meta
length(data.Export$Value[which(data.Export$Value<=data.Export$DetectionLimit)])
#81 obs less than or equal to detection limit
unique(data.Export$Value)#looking at values
#censor observations that is less than or equal to the detection limit
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data.Export$Value<=data.Export$DetectionLimit)]="LT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]="NC" #SET remaining obs. to not censored "NC"
unique(data.Export$CensorCode)
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure proper number
#continue exporting
data.Export$Date = data$Date#date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadatA
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(data$lakename=="BUG LAKE")]="EPI"
data.Export$SamplePosition[which(data$lakename=="CLOUD LAKE")]="EPI"
data.Export$SamplePosition[which(data$lakename=="DEVILS LAKE")]="EPI"
data.Export$SamplePosition[which(data$lakename=="KING LAKE")]="EPI"
data.Export$SamplePosition[which(data$lakename=="BUG LAKE DEEP")]="HYPO"
data.Export$SamplePosition[which(data$lakename=="CLOUD LAKE DEEP")]="HYPO"
data.Export$SamplePosition[which(data$lakename=="DEVILS LAKE DEEP")]="HYPO"
data.Export$SamplePosition[which(data$lakename=="KING LAKE DEEP")]="HYPO"
unique(data.Export$SamplePosition)#only two=good
#assign sampledepth 
data.Export$SampleDepth=(data$Sample.Depth..ft.)*.3048 #export sample depths for hypo observations, convert to meters
data.Export$SampleDepth[which(data.Export$SamplePosition=="EPI")]= .3048 #meta states epi samples collected 1 ft. below surface, convert to meters
unique(data.Export$SampleDepth)
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])
#32 OBS are NA for sample depth (hypo observations)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY" #metadata specifies that the deep hole was sampled
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) #check to make sure CORRECT NUMBER populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "EPA_365.2" #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
tp.Final = data.Export
rm(data.Export)
rm(data)

################################### Secchi disc (ft)   #############################################################################################################################
data=fcpc_chem_final
names(data)#look at column names
unique(data$lakename)#note that those lake names with "deep" are hypo samples
#check for null values
length(data$Secchi.disc..ft.[which(is.na(data$Secchi.disc..ft.)==TRUE)])
length(data$Secchi.disc..ft.[which(data$Secchi.disc..ft.=="")])
unique(data$Secchi.disc..ft.)#looking for problematic observations-characters etc.
513-(312+7)#194 obs remain after filterin gnull
data=data[which(is.na(data$Secchi.disc..ft.)==FALSE),]
data=data[which(data$Secchi.disc..ft.!=""),]
unique(data$Secchi.disc..ft.)#remove N/A observations
data=data[which(data$Secchi.disc..ft.!="N/A"),]
#that only removed one observation
unique(data$Secchi.disc..ft.)
#done filtering

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID=as.character(data.Export$LakeID)
data.Export$LakeID[which(data$lakename=="BUG LAKE")]="574100"
data.Export$LakeID[which(data$lakename=="BUG LAKE DEEP")]="574100"
data.Export$LakeID[which(data$lakename=="CLOUD LAKE")]="499700"
data.Export$LakeID[which(data$lakename=="CLOUD LAKE DEEP")]="499700"
data.Export$LakeID[which(data$lakename=="DEVILS LAKE")]="396700"
data.Export$LakeID[which(data$lakename=="DEVILS LAKE DEEP")]="396700"
data.Export$LakeID[which(data$lakename=="KING LAKE")]="501700"
data.Export$LakeID[which(data$lakename=="KING LAKE DEEP")]="501700"
unique(data.Export$LakeID)#only four=good
#now export text lake name
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName[which(data$lakename=="BUG LAKE")]="BUG LAKE"
data.Export$LakeName[which(data$lakename=="BUG LAKE DEEP")]="BUG LAKE"
data.Export$LakeName[which(data$lakename=="CLOUD LAKE")]="CLOUD LAKE"
data.Export$LakeName[which(data$lakename=="CLOUD LAKE DEEP")]="CLOUD LAKE"
data.Export$LakeName[which(data$lakename=="DEVILS LAKE")]="DEVILS LAKE"
data.Export$LakeName[which(data$lakename=="DEVILS LAKE DEEP")]="DEVILS LAKE"
data.Export$LakeName[which(data$lakename=="KING LAKE")]="KING LAKE"
data.Export$LakeName[which(data$lakename=="KING LAKE DEEP")]="KING LAKE"
unique(data.Export$LakeName)#only 4=good
#continue exporting
data.Export$SourceVariableName = "Secchi disc (ft)"
data.Export$SourceVariableDescription = "Secchi depth"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA 
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 30
data.Export$LagosVariableName="Secchi"
names(data)
data$Secchi.disc..ft.=as.numeric(data$Secchi.disc..ft.)
data.Export$Value = data[,16]*0.3048 #export observations and convert to preferred units
data.Export$DetectionLimit= NA #not applicable to secchi
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode="NC" 
unique(data.Export$CensorCode)
data.Export$Date = data$Date#date already in correct format
data.Export$Units="m"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED" #per metadatA
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition= "SPECIFIED"
unique(data.Export$SamplePosition)#only specified=good
#assign sampledepth 
data.Export$SampleDepth=NA #not applicable to secchi
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY" #metadata specifies that the deep hole was sampled
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) #check to make sure CORRECT NUMBER populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
secchi.Final = data.Export
rm(data.Export)
rm(data)


###################################### final export ########################################################################################
Final.Export = rbind(doc.Final,chla.Final,drp.Final,nh4.Final,no3no2.Final,tkn.Final,tp.Final,secchi.Final)
###############################################################
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
0+3686#adds up to total
##write table
Final.Export1=data1
typeof(Final.Export1$Value)
length(Final.Export1$Value[which(Final.Export1$Value<0)])
nosamplepos=Final.Export1[which(is.na(Final.Export1$SampleDepth)==TRUE & Final.Export1$SamplePosition=="UNKNOWN"),]
write.table(Final.Export1,file="DataImport_WI_FCPC_CHEM.csv",row.names=FALSE,sep=",")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/WI data/FCPC Lake Data (Finished)/DataImport_WI_FCPC_CHEM/DataImport_WI_FCPC_CHEM.RData")