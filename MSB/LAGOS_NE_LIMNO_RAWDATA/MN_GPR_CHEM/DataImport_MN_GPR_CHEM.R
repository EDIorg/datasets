#set path to files
setwd("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MN data/Grand Portage Tribe data/DataImport_MN_GPR_CHEM")
setwd("C:/Users/Sam/Dropbox/CSI-LIMNO_DATA/DATA-lake/MN data/Grand Portage Tribe data/DataImport_MN_GPR_CHEM")

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
# data collected by the grand portage tribe of MN for WQ monitoring
# blank cells indicated by NA or blank
# all sample type = integrated; all sample position for chem samples="epi"

###########################################################################################################################################################################################
################################### DOC_mgL  #############################################################################################################################
data=mn_Rgpr_chem
names(data)#look at column names
#check for null values
length(data$DOC_mgL[which(is.na(data$DOC_mgL)==TRUE)])
length(data$DOC_mgL[which(data$DOC_mgL=="")])
590-268 #322 should remain after filtering out null observations
data=data[which(data$DOC_mgL!=""),]
unique(data$DOC_mgL)#looking at data to check for problematic observations-characters etc..
#data looks OK
unique(data$Site)#filter out observations under duplicate
length(data$Site[which(data$Site=="Duplicate")])
data=data[which(data$Site!="Duplicate"),]
unique(data$formmated_date)#use this as the sample date

#done filtering

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$Site.ID
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$Site
data.Export$SourceVariableName = "DOC_mgL"
data.Export$SourceVariableDescription = "Dissolved organic carbon"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA 
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 6
data.Export$LagosVariableName="Carbon, dissolved organic"
names(data)
data$DOC_mgL=as.numeric(data$DOC_mgL)
names(data)
data.Export$Value = data[,11] #export Doc values already in preff. units of mg/L
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$formmated_date #date already in correct format
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
unique(data$Site)
data.Export$SampleDepth[which(data$Site=="Taylor Lake")]=2
data.Export$SampleDepth[which(data$Site=="Trout Lake")]=2
unique(data.Export$SampleDepth)
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
data.Export$DetectionLimit= NA #not specified in meta
#comments
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(is.na(data.Export$SampleDepth)==TRUE)]="sample collected over entire depth of the lake"
unique(data.Export$Comments)
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
doc.Final = data.Export
rm(data.Export)
rm(data)

################################### Chla_ugL  #############################################################################################################################
data=mn_gpr_chem
names(data)#look at column names
#check for null values
length(data$Chla_ugL[which(is.na(data$Chla_ugL)==TRUE)])
length(data$Chla_ugL[which(data$Chla_ugL=="")])
590-4 #586 should remain after filtering out null observations
data=data[which(is.na(data$Chla_ugL)==FALSE),]
unique(data$Chla_ugL)#looking at data to check for problematic observations-characters etc..
#data looks OK
unique(data$Site)#filter out observations under duplicate
length(data$Site[which(data$Site=="Duplicate")])
data=data[which(data$Site!="Duplicate"),]

#done filtering

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$Site.ID
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$Site
data.Export$SourceVariableName = "Chla_ugL"
data.Export$SourceVariableDescription = "Chlorophyll a"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA 
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 9
data.Export$LagosVariableName="Chlorophyll a"
names(data)
data$Chla_ugL=as.numeric(data$Chla_ugL)
names(data)
data.Export$Value = data[,5] #export obs already in lagos preferred units
data.Export$Date = data$formmated_date #date already in correct format
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
unique(data$Site)
data.Export$SampleDepth[which(data$Site=="Taylor Lake")]=2
data.Export$SampleDepth[which(data$Site=="Trout Lake")]=2
unique(data.Export$SampleDepth)
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
data.Export$DetectionLimit= 1.0 #per meta
length(data.Export$Value[which(data.Export$Value<=data.Export$DetectionLimit)])
print(data.Export$Value[which(data.Export$Value<=data.Export$DetectionLimit)])
#assign obs. less than or equal to detection limit a censor code of "LT"
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data.Export$Value<=data.Export$DetectionLimit)]="LT"
#set the rest of the obs as not censore
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]="NC"
unique(data.Export$CensorCode)
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure correct number LT
#comments
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(is.na(data.Export$SampleDepth)==TRUE)]="sample collected over entire depth of the lake"
unique(data.Export$Comments)
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
chla.Final = data.Export
rm(data.Export)
rm(data)

################################### Color_PCCU #############################################################################################################################
data=mn_gpr_chem
names(data)#look at column names
#check for null values
length(data$Color_PCCU[which(is.na(data$Color_PCCU)==TRUE)])
length(data$Color_PCCU[which(data$Color_PCCU=="")])
590-583 #7 should remain after filtering out null observations
data=data[which(is.na(data$Color_PCCU)==FALSE),]
unique(data$Color_PCCU)#looking at data to check for problematic observations-characters etc..
#data looks OK
unique(data$Site)#filter out observations under duplicate
length(data$Site[which(data$Site=="Duplicate")])
data=data[which(data$Site!="Duplicate"),]

#done filtering

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$Site.ID
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$Site
data.Export$SourceVariableName = "Color_PCCU"
data.Export$SourceVariableDescription = "True color"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA 
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 12
data.Export$LagosVariableName="Color, true"
names(data)
data$Color_PCCU=as.numeric(data$Color_PCCU)
names(data)
data.Export$Value = data[,12] #export obs already in lagos preferred units
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$formmated_date #date already in correct format
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
unique(data$Site)
data.Export$SampleDepth[which(data$Site=="Taylor Lake")]=2
data.Export$SampleDepth[which(data$Site=="Trout Lake")]=2
unique(data.Export$SampleDepth)

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
data.Export$DetectionLimit= NA #per meta
#comments
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(is.na(data.Export$SampleDepth)==TRUE)]="sample collected over entire depth of the lake"
unique(data.Export$Comments)
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
tcolor.Final = data.Export
rm(data.Export)
rm(data)

################################### N_rate_rite #############################################################################################################################
data=mn_gpr_chem
names(data)#look at column names
#check for null values
length(data$N_rate_rite[which(is.na(data$N_rate_rite)==TRUE)])
length(data$N_rate_rite[which(data$N_rate_rite=="")])
590-169 #421 should remain after filtering out null observations
data=data[which(is.na(data$N_rate_rite)==FALSE),]
unique(data$N_rate_rite)#looking at data to check for problematic observations-characters etc..
#data looks OK
unique(data$Site)#filter out observations under duplicate
length(data$Site[which(data$Site=="Duplicate")])
data=data[which(data$Site!="Duplicate"),]

#done filtering

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$Site.ID
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$Site
data.Export$SourceVariableName = "N_rate_rite"
data.Export$SourceVariableDescription = "Nitrite + nitrate"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA 
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 18
data.Export$LagosVariableName="Nitrogen, nitrite (NO2) + nitrate (NO3)"
names(data)
data$N_rate_rite=as.numeric(data$N_rate_rite)
names(data)
data.Export$Value = data[,7]*1000 #export obs, and convert into lagos preferred units
unique(data.Export$Value)
data.Export$Date = data$formmated_date #date already in correct format
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
unique(data$Site)
data.Export$SampleDepth[which(data$Site=="Taylor Lake")]=2
data.Export$SampleDepth[which(data$Site=="Trout Lake")]=2
unique(data.Export$SampleDepth)

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
data.Export$DetectionLimit= 100 #per meta
length(data.Export$Value[which(data.Export$Value<=data.Export$DetectionLimit)])
print(data.Export$Value[which(data.Export$Value<=data.Export$DetectionLimit)])
#assign obs. less than or equal to detection limit a censor code of "LT"
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data.Export$Value<=data.Export$DetectionLimit)]="LT"
#set the rest of the obs as not censore
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]="NC"
unique(data.Export$CensorCode)
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure correct number LT

#comments
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(is.na(data.Export$SampleDepth)==TRUE)]="sample collected over entire depth of the lake"
unique(data.Export$Comments)
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
no3no2.Final = data.Export
rm(data.Export)
rm(data)

################################### TN_mgL   #############################################################################################################################
data=mn_gpr_chem
names(data)#look at column names
#check for null values
length(data$TN_mgL[which(is.na(data$TN_mgL)==TRUE)])
length(data$TN_mgL[which(data$TN_mgL=="")])
590-4 #586 should remain after filtering out null observations
data=data[which(is.na(data$TN_mgL)==FALSE),]
unique(data$TN_mgL)#looking at data to check for problematic observations-characters etc..
#data looks OK
unique(data$Site)#filter out observations under duplicate
length(data$Site[which(data$Site=="Duplicate")])
data=data[which(data$Site!="Duplicate"),]

#done filtering

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$Site.ID
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$Site
data.Export$SourceVariableName = "TN_mgL"
data.Export$SourceVariableDescription = "Total nitrogen"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA 
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 21
data.Export$LagosVariableName="Nitrogen, total"
names(data)
data$TN_mgL=as.numeric(data$TN_mgL)
names(data)
data.Export$Value = data[,8]*1000 #export obs already and convert to lagos preferred units
unique(data.Export$Value)
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$formmated_date #date already in correct format
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
unique(data$Site)
data.Export$SampleDepth[which(data$Site=="Taylor Lake")]=2
data.Export$SampleDepth[which(data$Site=="Trout Lake")]=2
unique(data.Export$SampleDepth)
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
data.Export$DetectionLimit= NA #per meta
#comments
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(is.na(data.Export$SampleDepth)==TRUE)]="sample collected over entire depth of the lake"
unique(data.Export$Comments)
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
tn.Final = data.Export
rm(data.Export)
rm(data)

################################### TKN_mgL   #############################################################################################################################
data=mn_gpr_chem
names(data)#look at column names
#check for null values
length(data$TKN_mgL[which(is.na(data$TKN_mgL)==TRUE)])
length(data$TKN_mgL[which(data$TKN_mgL=="")])
590-136 #454 should remain after filtering out null observations
data=data[which(is.na(data$TKN_mgL)==FALSE),]
unique(data$TKN_mgL)#looking at data to check for problematic observations-characters etc..
#data looks OK
unique(data$Site)#filter out observations under duplicate
length(data$Site[which(data$Site=="Duplicate")])
data=data[which(data$Site!="Duplicate"),]

#done filtering

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$Site.ID
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$Site
data.Export$SourceVariableName = "TKN_mgL"
data.Export$SourceVariableDescription = "Total kjeldahl nitrogen"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA 
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 16
data.Export$LagosVariableName="Nitrogen, total Kjeldahl"
names(data)
data$TKN_mgL=as.numeric(data$TKN_mgL)
names(data)
data.Export$Value = data[,6]*1000 #export obs already and convert to lagos preferred units
unique(data.Export$Value)
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$formmated_date #date already in correct format
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
#assign sampledepth 
unique(data$Site)
data.Export$SampleDepth[which(data$Site=="Taylor Lake")]=2
data.Export$SampleDepth[which(data$Site=="Trout Lake")]=2
unique(data.Export$SampleDepth)
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
data.Export$DetectionLimit= NA #per meta
#comments
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(is.na(data.Export$SampleDepth)==TRUE)]="sample collected over entire depth of the lake"
unique(data.Export$Comments)
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
tkn.Final = data.Export
rm(data.Export)
rm(data)

###################################  TP_MGL    #############################################################################################################################
data=mn_gpr_chem
names(data)#look at column names
#check for null values
length(data$TP_MGL[which(is.na(data$TP_MGL)==TRUE)])
length(data$TP_MGL[which(data$TP_MGL=="")])
590-3 #587 should remain after filtering out null observations
data=data[which(is.na(data$TP_MGL)==FALSE),]
unique(data$TP_MGL)#looking at data to check for problematic observations-characters etc..
#data looks OK
unique(data$Site)#filter out observations under duplicate
length(data$Site[which(data$Site=="Duplicate")])
data=data[which(data$Site!="Duplicate"),]

#done filtering

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$Site.ID
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$Site
data.Export$SourceVariableName = "TP_MGL"
data.Export$SourceVariableDescription = "Total phosphorus"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA 
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 27
data.Export$LagosVariableName="Phosphorus, total"
names(data)
data$TP_MGL=as.numeric(data$TP_MGL)
names(data)
data.Export$Value = data[,10]*1000 #export obs, and convert into lagos preferred units
unique(data.Export$Value)
data.Export$Date = data$formmated_date #date already in correct format
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
unique(data$Site)
data.Export$SampleDepth[which(data$Site=="Taylor Lake")]=2
data.Export$SampleDepth[which(data$Site=="Trout Lake")]=2
unique(data.Export$SampleDepth)
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
data.Export$DetectionLimit= 10 #per meta
length(data.Export$Value[which(data.Export$Value<=data.Export$DetectionLimit)])
print(data.Export$Value[which(data.Export$Value<=data.Export$DetectionLimit)])
#assign obs. less than or equal to detection limit a censor code of "LT"
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data.Export$Value<=data.Export$DetectionLimit)]="LT"
#set the rest of the obs as not censore
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]="NC"
unique(data.Export$CensorCode)
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure correct number LT
data.Export$Comments=as.character(data.Export$Comments)
#comments
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(is.na(data.Export$SampleDepth)==TRUE)]="sample collected over entire depth of the lake"
unique(data.Export$Comments)
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
tp.Final = data.Export
rm(data.Export)
rm(data)

###################################### final export ########################################################################################
Final.Export = rbind(doc.Final,chla.Final,tcolor.Final,no3no2.Final,tn.Final,tkn.Final,tp.Final)
######################################################################

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
39+2912#adds up to total
##write table
Final.Export1=data1
typeof(Final.Export1$Value)
length(Final.Export1$Value[which(Final.Export1$Value<0)])
nosamplepos=Final.Export1[which(is.na(Final.Export1$SampleDepth)==TRUE & Final.Export1$SamplePosition=="UNKNOWN"),]
write.table(Final.Export1,file="DataImport_MN_GPR_CHEM.csv",row.names=FALSE,sep=",")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MN data/Grand Portage Tribe data/DataImport_MN_GPR_CHEM/DataImport_MN_GPR_CHEM.RData")