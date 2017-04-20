#set path to files
setwd("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MA data/MWSA- Reservoirs (Finished)/Wachusetts/DataImport_MA_WACHUSETT_CHEM")



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
#data collected on 3 different stations on the Wachusett Reservoir in MA.
#sample position is attached to lake id, must parse it out
#sample depth is NA for all obs.
#units are included in the data table.
#sample type is grab for all observations
###############################################################################################################################################
###################################   AMMONIA   #############################################################################################################################
data=wachusett_chem
names(data)
unique(data$LOCATION_ID)#parse out sample position and assign lake id as this variable with out the "epilimnion, metalimnion,hypolimnion"
unique(data$COMPONENT)
length(data$COMPONENT[which(data$COMPONENT=="AMMONIA")]) #495 AMMONIA OBS
data=data[which(data$COMPONENT=="AMMONIA"),]
unique(data$RESULT)
#check for null
length(data$RESULT[which(is.na(data$RESULT)==TRUE)])
length(data$RESULT[which(data$RESULT=="")])
#continue looking at data
unique(data$DATE_COLLECTED)
unique(data$UNIT)#only one unit is good but not lagos prefferred, convert
#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
unique(data$LOCATION_ID)
data.Export$LakeID=as.character(data.Export$LakeID)
data$LOCATION_ID=as.character(data$LOCATION_ID)
data.Export$LakeID[which(data$LOCATION_ID=="Basin North epilimnion")]="Basin North"
data.Export$LakeID[which(data$LOCATION_ID=="Basin South epilimnion")]="Basin South"
data.Export$LakeID[which(data$LOCATION_ID=="Thomas Basin epilimnion")]="Thomas Basin"
data.Export$LakeID[which(data$LOCATION_ID=="Basin North metalimnion")]="Basin North"
data.Export$LakeID[which(data$LOCATION_ID=="Basin North hypolimnion")]="Basin North"
data.Export$LakeID[which(data$LOCATION_ID=="Basin South hypolimnion")]="Basin South"
data.Export$LakeID[which(data$LOCATION_ID=="Thomas Basin hypolimnion")]="Thomas Basin"
data.Export$LakeID[which(data$LOCATION_ID=="Thomas Basin metalimnion")]="Thomas Basin"
unique(data.Export$LakeID)
length(data.Export$LakeID[which(data.Export$LakeID=="")])
#export lake name
data.Export$LakeName = "WACHUSETT RESERVOIR"
data.Export$SourceVariableName = "AMMONIA"
data.Export$SourceVariableDescription = "Ammonia (NH3)"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags= NA #no remark codes
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 19
data.Export$LagosVariableName="Nitrogen, NH4"
#export values
typeof(data$RESULT)
data.Export$Value = data$RESULT*1000 #export values and convert from mg/l to ug/l
unique(data.Export$Value)
data.Export$CensorCode = "NC" #no info on CensorCode
data.Export$Date = data$DATE_COLLECTED #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
#assign sample position by parsing location id
unique(data$LOCATION_ID)
data$LOCATION_ID=as.character(data$LOCATION_ID) 
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[(grep("epilimnion",data$LOCATION_ID,ignore.case=TRUE))]="EPI"
data.Export$SamplePosition[(grep("metalimnion",data$LOCATION_ID,ignore.case=TRUE))]="META"
data.Export$SamplePosition[(grep("hypolimnion",data$LOCATION_ID,ignore.case=TRUE))]="HYPO"
unique(data.Export$SamplePosition)
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="META")])
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="HYPO")])
#CHECK to see if adds to total
192+113+190

#assign sampledepth 
data.Export$SampleDepth=NA
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])#check to make sure all NA
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")]) #check to make sure CORRECT NUMBER populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #not specified in meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments= NA 
nh4.Final = data.Export
rm(data.Export)
rm(data)

###################################   NITRATE   #############################################################################################################################
data=wachusett_chem
names(data)
unique(data$LOCATION_ID)#parse out sample position and assign lake id as this variable with out the "epilimnion, metalimnion,hypolimnion"
unique(data$COMPONENT)
length(data$COMPONENT[which(data$COMPONENT=="NITRATE")]) #480 AMMONIA OBS
data=data[which(data$COMPONENT=="NITRATE"),]
unique(data$RESULT)
#check for null
length(data$RESULT[which(is.na(data$RESULT)==TRUE)])
length(data$RESULT[which(data$RESULT=="")])
#continue looking at data
unique(data$DATE_COLLECTED)
unique(data$UNIT)#only one unit is good but not lagos prefferred, convert
#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
unique(data$LOCATION_ID)
data.Export$LakeID=as.character(data.Export$LakeID)
data$LOCATION_ID=as.character(data$LOCATION_ID)
data.Export$LakeID[which(data$LOCATION_ID=="Basin North epilimnion")]="Basin North"
data.Export$LakeID[which(data$LOCATION_ID=="Basin South epilimnion")]="Basin South"
data.Export$LakeID[which(data$LOCATION_ID=="Thomas Basin epilimnion")]="Thomas Basin"
data.Export$LakeID[which(data$LOCATION_ID=="Basin North metalimnion")]="Basin North"
data.Export$LakeID[which(data$LOCATION_ID=="Basin North hypolimnion")]="Basin North"
data.Export$LakeID[which(data$LOCATION_ID=="Basin South hypolimnion")]="Basin South"
data.Export$LakeID[which(data$LOCATION_ID=="Thomas Basin hypolimnion")]="Thomas Basin"
data.Export$LakeID[which(data$LOCATION_ID=="Thomas Basin metalimnion")]="Thomas Basin"
unique(data.Export$LakeID)
length(data.Export$LakeID[which(data.Export$LakeID=="")])
#export lake name
data.Export$LakeName = "WACHUSETT RESERVOIR"
data.Export$SourceVariableName = "NITRATE"
data.Export$SourceVariableDescription = "Nitrate"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags= NA #no remark codes
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 18
data.Export$LagosVariableName="Nitrogen, nitrite (NO2) + nitrate (NO3)"
#export values
typeof(data$RESULT)
data.Export$Value = data$RESULT*1000 #export values and convert from mg/l to ug/l
unique(data.Export$Value)
data.Export$CensorCode = "NC" #no info on CensorCode
data.Export$Date = data$DATE_COLLECTED #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
#assign sample position by parsing location id
unique(data$LOCATION_ID)
data$LOCATION_ID=as.character(data$LOCATION_ID) 
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[(grep("epilimnion",data$LOCATION_ID,ignore.case=TRUE))]="EPI"
data.Export$SamplePosition[(grep("metalimnion",data$LOCATION_ID,ignore.case=TRUE))]="META"
data.Export$SamplePosition[(grep("hypolimnion",data$LOCATION_ID,ignore.case=TRUE))]="HYPO"
unique(data.Export$SamplePosition)
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="META")])
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="HYPO")])
#CHECK to see if adds to total
186+110+184

#assign sampledepth 
data.Export$SampleDepth=NA
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])#check to make sure all NA
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")]) #check to make sure CORRECT NUMBER populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "EPA_353.2" 
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #not specified in meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments= NA 
no3.Final = data.Export
rm(data.Export)
rm(data)

###################################   NITRATE/NITRITE   #############################################################################################################################
data=wachusett_chem
names(data)
unique(data$LOCATION_ID)#parse out sample position and assign lake id as this variable with out the "epilimnion, metalimnion,hypolimnion"
unique(data$COMPONENT)
length(data$COMPONENT[which(data$COMPONENT=="NITRATE/NITRITE")]) #41 OBS
data=data[which(data$COMPONENT=="NITRATE/NITRITE"),]
unique(data$RESULT)
#check for null
length(data$RESULT[which(is.na(data$RESULT)==TRUE)])
length(data$RESULT[which(data$RESULT=="")])
#continue looking at data
unique(data$DATE_COLLECTED)
unique(data$UNIT)#only one unit is good but not lagos prefferred, convert
#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
unique(data$LOCATION_ID)
data.Export$LakeID=as.character(data.Export$LakeID)
data$LOCATION_ID=as.character(data$LOCATION_ID)
data.Export$LakeID[which(data$LOCATION_ID=="Basin North epilimnion")]="Basin North"
data.Export$LakeID[which(data$LOCATION_ID=="Basin South epilimnion")]="Basin South"
data.Export$LakeID[which(data$LOCATION_ID=="Thomas Basin epilimnion")]="Thomas Basin"
data.Export$LakeID[which(data$LOCATION_ID=="Basin North metalimnion")]="Basin North"
data.Export$LakeID[which(data$LOCATION_ID=="Basin North hypolimnion")]="Basin North"
data.Export$LakeID[which(data$LOCATION_ID=="Basin South hypolimnion")]="Basin South"
data.Export$LakeID[which(data$LOCATION_ID=="Thomas Basin hypolimnion")]="Thomas Basin"
data.Export$LakeID[which(data$LOCATION_ID=="Thomas Basin metalimnion")]="Thomas Basin"
unique(data.Export$LakeID)
length(data.Export$LakeID[which(data.Export$LakeID=="")])
#export lake name
data.Export$LakeName = "WACHUSETT RESERVOIR"
data.Export$SourceVariableName = "NITRATE/NITRITE"
data.Export$SourceVariableDescription = "Nitrite/nitrate"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags= NA #no remark codes
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 18
data.Export$LagosVariableName="Nitrogen, nitrite (NO2) + nitrate (NO3)"
#export values
typeof(data$RESULT)
data.Export$Value = data$RESULT*1000 #export values and convert from mg/l to ug/l
unique(data.Export$Value)
data.Export$CensorCode = "NC" #no info on CensorCode
data.Export$Date = data$DATE_COLLECTED #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
#assign sample position by parsing location id
unique(data$LOCATION_ID)
data$LOCATION_ID=as.character(data$LOCATION_ID) 
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[(grep("epilimnion",data$LOCATION_ID,ignore.case=TRUE))]="EPI"
data.Export$SamplePosition[(grep("metalimnion",data$LOCATION_ID,ignore.case=TRUE))]="META"
data.Export$SamplePosition[(grep("hypolimnion",data$LOCATION_ID,ignore.case=TRUE))]="HYPO"
unique(data.Export$SamplePosition)
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="META")])
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="HYPO")])
#CHECK to see if adds to total
18+9+14

#assign sampledepth 
data.Export$SampleDepth=NA
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])#check to make sure all NA
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")]) #check to make sure CORRECT NUMBER populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #not specified in meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments= NA 
no3no2.Final = data.Export
rm(data.Export)
rm(data)

###################################   NITRITE   #############################################################################################################################
data=wachusett_chem
names(data)
unique(data$LOCATION_ID)#parse out sample position and assign lake id as this variable with out the "epilimnion, metalimnion,hypolimnion"
unique(data$COMPONENT)
length(data$COMPONENT[which(data$COMPONENT=="NITRITE")]) # number of OBS
data=data[which(data$COMPONENT=="NITRITE"),]
unique(data$RESULT)
#check for null
length(data$RESULT[which(is.na(data$RESULT)==TRUE)])
length(data$RESULT[which(data$RESULT=="")])
#continue looking at data
unique(data$DATE_COLLECTED)
unique(data$UNIT)#only one unit is good but not lagos prefferred, convert
#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
unique(data$LOCATION_ID)
data.Export$LakeID=as.character(data.Export$LakeID)
data$LOCATION_ID=as.character(data$LOCATION_ID)
data.Export$LakeID[which(data$LOCATION_ID=="Basin North epilimnion")]="Basin North"
data.Export$LakeID[which(data$LOCATION_ID=="Basin South epilimnion")]="Basin South"
data.Export$LakeID[which(data$LOCATION_ID=="Thomas Basin epilimnion")]="Thomas Basin"
data.Export$LakeID[which(data$LOCATION_ID=="Basin North metalimnion")]="Basin North"
data.Export$LakeID[which(data$LOCATION_ID=="Basin North hypolimnion")]="Basin North"
data.Export$LakeID[which(data$LOCATION_ID=="Basin South hypolimnion")]="Basin South"
data.Export$LakeID[which(data$LOCATION_ID=="Thomas Basin hypolimnion")]="Thomas Basin"
data.Export$LakeID[which(data$LOCATION_ID=="Thomas Basin metalimnion")]="Thomas Basin"
unique(data.Export$LakeID)
length(data.Export$LakeID[which(data.Export$LakeID=="")])
#export lake name
data.Export$LakeName = "WACHUSETT RESERVOIR"
data.Export$SourceVariableName = "NITRITE"
data.Export$SourceVariableDescription = "Nitrite"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags= NA #no remark codes
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 17
data.Export$LagosVariableName="Nitrogen, nitrite (NO2)"
#export values
typeof(data$RESULT)
data.Export$Value = data$RESULT*1000 #export values and convert from mg/l to ug/l
unique(data.Export$Value)
data.Export$CensorCode = "NC" #no info on CensorCode
data.Export$Date = data$DATE_COLLECTED #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
#assign sample position by parsing location id
unique(data$LOCATION_ID)
data$LOCATION_ID=as.character(data$LOCATION_ID) 
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[(grep("epilimnion",data$LOCATION_ID,ignore.case=TRUE))]="EPI"
data.Export$SamplePosition[(grep("metalimnion",data$LOCATION_ID,ignore.case=TRUE))]="META"
data.Export$SamplePosition[(grep("hypolimnion",data$LOCATION_ID,ignore.case=TRUE))]="HYPO"
unique(data.Export$SamplePosition)
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="META")])
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="HYPO")])
#CHECK to see if adds to total
13+7+11

#assign sampledepth 
data.Export$SampleDepth=NA
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])#check to make sure all NA
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")]) #check to make sure CORRECT NUMBER populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #not specified in meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments= NA 
no2.Final = data.Export
rm(data.Export)
rm(data)

###################################   TOTAL KJELDAHL NITROGEN  #############################################################################################################################
data=wachusett_chem
names(data)
unique(data$LOCATION_ID)#parse out sample position and assign lake id as this variable with out the "epilimnion, metalimnion,hypolimnion"
unique(data$COMPONENT)
length(data$COMPONENT[which(data$COMPONENT=="TOTAL KJELDAHL NITROGEN")]) # number of OBS
data=data[which(data$COMPONENT=="TOTAL KJELDAHL NITROGEN"),]
unique(data$RESULT)
#check for null
length(data$RESULT[which(is.na(data$RESULT)==TRUE)])
length(data$RESULT[which(data$RESULT=="")])
#continue looking at data
unique(data$DATE_COLLECTED)
unique(data$UNIT)#only one unit is good but not lagos prefferred, convert
#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
unique(data$LOCATION_ID)
data.Export$LakeID=as.character(data.Export$LakeID)
data$LOCATION_ID=as.character(data$LOCATION_ID)
data.Export$LakeID[which(data$LOCATION_ID=="Basin North epilimnion")]="Basin North"
data.Export$LakeID[which(data$LOCATION_ID=="Basin South epilimnion")]="Basin South"
data.Export$LakeID[which(data$LOCATION_ID=="Thomas Basin epilimnion")]="Thomas Basin"
data.Export$LakeID[which(data$LOCATION_ID=="Basin North metalimnion")]="Basin North"
data.Export$LakeID[which(data$LOCATION_ID=="Basin North hypolimnion")]="Basin North"
data.Export$LakeID[which(data$LOCATION_ID=="Basin South hypolimnion")]="Basin South"
data.Export$LakeID[which(data$LOCATION_ID=="Thomas Basin hypolimnion")]="Thomas Basin"
data.Export$LakeID[which(data$LOCATION_ID=="Thomas Basin metalimnion")]="Thomas Basin"
unique(data.Export$LakeID)
length(data.Export$LakeID[which(data.Export$LakeID=="")])
#export lake name
data.Export$LakeName = "WACHUSETT RESERVOIR"
data.Export$SourceVariableName = "TOTAL KJELDAHL NITROGEN"
data.Export$SourceVariableDescription = "Total Kjeldahl"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags= NA #no remark codes
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 16
data.Export$LagosVariableName="Nitrogen, total Kjeldahl"
#export values
typeof(data$RESULT)
data.Export$Value = data$RESULT*1000 #export values and convert from mg/l to ug/l
unique(data.Export$Value)
data.Export$CensorCode = "NC" #no info on CensorCode
data.Export$Date = data$DATE_COLLECTED #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
#assign sample position by parsing location id
unique(data$LOCATION_ID)
data$LOCATION_ID=as.character(data$LOCATION_ID) 
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[(grep("epilimnion",data$LOCATION_ID,ignore.case=TRUE))]="EPI"
data.Export$SamplePosition[(grep("metalimnion",data$LOCATION_ID,ignore.case=TRUE))]="META"
data.Export$SamplePosition[(grep("hypolimnion",data$LOCATION_ID,ignore.case=TRUE))]="HYPO"
unique(data.Export$SamplePosition)
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="META")])
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="HYPO")])
#CHECK to see if adds to total
186+111+185

#assign sampledepth 
data.Export$SampleDepth=NA
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])#check to make sure all NA
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")]) #check to make sure CORRECT NUMBER populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "EPA_351.2"
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #not specified in meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments= NA 
tkn.Final = data.Export
rm(data.Export)
rm(data)

###################################   TOTAL PHOSPHORUS  #############################################################################################################################
data=wachusett_chem
names(data)
unique(data$LOCATION_ID)#parse out sample position and assign lake id as this variable with out the "epilimnion, metalimnion,hypolimnion"
unique(data$COMPONENT)
length(data$COMPONENT[which(data$COMPONENT=="TOTAL PHOSPHORUS")]) # number of OBS
data=data[which(data$COMPONENT=="TOTAL PHOSPHORUS"),]
unique(data$RESULT)
#check for null
length(data$RESULT[which(is.na(data$RESULT)==TRUE)])
length(data$RESULT[which(data$RESULT=="")])
#continue looking at data
unique(data$DATE_COLLECTED)
unique(data$UNIT)#only one unit is good but not lagos prefferred, convert
#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
unique(data$LOCATION_ID)
data.Export$LakeID=as.character(data.Export$LakeID)
data$LOCATION_ID=as.character(data$LOCATION_ID)
data.Export$LakeID[which(data$LOCATION_ID=="Basin North epilimnion")]="Basin North"
data.Export$LakeID[which(data$LOCATION_ID=="Basin South epilimnion")]="Basin South"
data.Export$LakeID[which(data$LOCATION_ID=="Thomas Basin epilimnion")]="Thomas Basin"
data.Export$LakeID[which(data$LOCATION_ID=="Basin North metalimnion")]="Basin North"
data.Export$LakeID[which(data$LOCATION_ID=="Basin North hypolimnion")]="Basin North"
data.Export$LakeID[which(data$LOCATION_ID=="Basin South hypolimnion")]="Basin South"
data.Export$LakeID[which(data$LOCATION_ID=="Thomas Basin hypolimnion")]="Thomas Basin"
data.Export$LakeID[which(data$LOCATION_ID=="Thomas Basin metalimnion")]="Thomas Basin"
unique(data.Export$LakeID)
length(data.Export$LakeID[which(data.Export$LakeID=="")])
#export lake name
data.Export$LakeName = "WACHUSETT RESERVOIR"
data.Export$SourceVariableName = "TOTAL PHOSPHORUS"
data.Export$SourceVariableDescription = "Total phosphorus"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags= NA #no remark codes
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 27
data.Export$LagosVariableName="Phosphorus, total"
#export values
typeof(data$RESULT)
data.Export$Value = data$RESULT*1000 #export values and convert from mg/l to ug/l
unique(data.Export$Value)
data.Export$CensorCode = "NC" #no info on CensorCode
data.Export$Date = data$DATE_COLLECTED #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
#assign sample position by parsing location id
unique(data$LOCATION_ID)
data$LOCATION_ID=as.character(data$LOCATION_ID) 
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[(grep("epilimnion",data$LOCATION_ID,ignore.case=TRUE))]="EPI"
data.Export$SamplePosition[(grep("metalimnion",data$LOCATION_ID,ignore.case=TRUE))]="META"
data.Export$SamplePosition[(grep("hypolimnion",data$LOCATION_ID,ignore.case=TRUE))]="HYPO"
unique(data.Export$SamplePosition)
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="META")])
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="HYPO")])
#CHECK to see if adds to total
189+112+187

#assign sampledepth 
data.Export$SampleDepth=NA
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])#check to make sure all NA
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")]) #check to make sure CORRECT NUMBER populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "EPA_365.4"
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #not specified in meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments= NA 
tp.Final = data.Export
rm(data.Export)
rm(data)

###################################  Mean U254   #############################################################################################################################
data=wachusett_chem
names(data)
unique(data$LOCATION_ID)#parse out sample position and assign lake id as this variable with out the "epilimnion, metalimnion,hypolimnion"
unique(data$COMPONENT)
length(data$COMPONENT[which(data$COMPONENT=="Mean U254")]) # number of OBS
data=data[which(data$COMPONENT=="Mean U254"),]
unique(data$RESULT)
#check for null
length(data$RESULT[which(is.na(data$RESULT)==TRUE)])
length(data$RESULT[which(data$RESULT=="")])
#continue looking at data
unique(data$DATE_COLLECTED)
unique(data$UNIT)#only one unit is good but not lagos prefferred, convert
#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
unique(data$LOCATION_ID)
data.Export$LakeID=as.character(data.Export$LakeID)
data$LOCATION_ID=as.character(data$LOCATION_ID)
data.Export$LakeID[which(data$LOCATION_ID=="Basin North epilimnion")]="Basin North"
data.Export$LakeID[which(data$LOCATION_ID=="Basin South epilimnion")]="Basin South"
data.Export$LakeID[which(data$LOCATION_ID=="Thomas Basin epilimnion")]="Thomas Basin"
data.Export$LakeID[which(data$LOCATION_ID=="Basin North metalimnion")]="Basin North"
data.Export$LakeID[which(data$LOCATION_ID=="Basin North hypolimnion")]="Basin North"
data.Export$LakeID[which(data$LOCATION_ID=="Basin South hypolimnion")]="Basin South"
data.Export$LakeID[which(data$LOCATION_ID=="Thomas Basin hypolimnion")]="Thomas Basin"
data.Export$LakeID[which(data$LOCATION_ID=="Thomas Basin metalimnion")]="Thomas Basin"
unique(data.Export$LakeID)
length(data.Export$LakeID[which(data.Export$LakeID=="")])
#export lake name
data.Export$LakeName = "WACHUSETT RESERVOIR"
data.Export$SourceVariableName = "Mean U254"
data.Export$SourceVariableDescription = "Color absorbance at 254 nm UV spectrum"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags= NA #no remark codes
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 12
data.Export$LagosVariableName="Color, true"
#export values
typeof(data$RESULT)
g_253=(2.303*data$RESULT)/(.01)
for_exp=-0.01688*(440-253)
g_440= g_253*exp(for_exp)
color_440=(18.216*g_440)-.209
data.Export$Value=color_440
unique(data.Export$Value)
data.Export$CensorCode = "NC" #no info on CensorCode
data.Export$Date = data$DATE_COLLECTED #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
#assign sample position by parsing location id
unique(data$LOCATION_ID)
data$LOCATION_ID=as.character(data$LOCATION_ID) 
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[(grep("epilimnion",data$LOCATION_ID,ignore.case=TRUE))]="EPI"
data.Export$SamplePosition[(grep("metalimnion",data$LOCATION_ID,ignore.case=TRUE))]="META"
data.Export$SamplePosition[(grep("hypolimnion",data$LOCATION_ID,ignore.case=TRUE))]="HYPO"
unique(data.Export$SamplePosition)
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="META")])
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="HYPO")])
#CHECK to see if adds to total
152+99+151

#assign sampledepth 
data.Export$SampleDepth=NA
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])#check to make sure all NA
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")]) #check to make sure CORRECT NUMBER populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #not specified in meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments= NA 
color.Final = data.Export
rm(data.Export)
rm(data)

###################################### final export ########################################################################################
Final.Export = rbind(nh4.Final,no3.Final,no3no2.Final,no2.Final,tkn.Final,tp.Final,color.Final)
#######################################################################################################################
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
30+2389#adds up to total
##write table
Final.Export1=data1
typeof(Final.Export1$Value)
length(Final.Export1$Value[which(Final.Export1$Value<0)])
nosamplepos=Final.Export1[which(is.na(Final.Export1$SampleDepth)==TRUE & Final.Export1$SamplePosition=="UNKNOWN"),]
write.table(Final.Export1,file="DataImport_MA_WACHUSETT_CHEM.csv",row.names=FALSE,sep=",")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MA data/MWSA- Reservoirs (Finished)/Wachusetts/DataImport_MA_WACHUSETT_CHEM/DataImport_MA_WACHUSETT_CHEM.RData"