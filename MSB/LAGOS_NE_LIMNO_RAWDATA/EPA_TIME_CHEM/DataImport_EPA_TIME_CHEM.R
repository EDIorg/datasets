#path to files
setwd("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/Northeast TIME RLTM/TIME Data (Finished)/DataImport_EPA_TIME_CHEM")
setwd("C:/Users/Sam/Dropbox/CSI-LIMNO_DATA/DATA-lake/Northeast TIME RLTM/TIME Data (Finished)/DataImport_EPA_TIME_CHEM")

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
#data are a collection of many different epa programs ---primarily time and rltm, but also alps/helm (maine only)
#sample type= grab for all obs except secchi. sampleposition= either epi or hypo, it is specified in a source data variable
#no source flags or censor code
#basin type= unknown
###########################################################################################################################################################################################
################################### DOC   #############################################################################################################################
data=time_nutrients
names(data)#look at column names
#pull out columns of interest
data=data[,c(1,4:7,13:14,19,40:42)]
names(data)
#check how many obs are null for sample position info
unique(data$SAMSTRAT)
length(data$SAMSTRAT[which(is.na(data$SAMSTRAT)==TRUE)])
length(data$SAMSTRAT[which(data$SAMSTRAT=="")])#none null= really good!
#look at values for problems and check/filter out nulls
unique(data$DOC)
length(data$DOC[which(is.na(data$DOC)==TRUE)])
length(data$DOC[which(data$DOC=="")])
3512-203#3309 remain after filtering null
data=data[which(is.na(data$DOC)==FALSE),]

#done filtering

#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID =data$lagos_lakeid
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$lagos_lakename
length(data.Export$LakeName[which(data.Export$LakeName=="")])#301 observations are missing
data.Export$SourceVariableName = "DOC"
data.Export$SourceVariableDescription = "Dissolved organic C"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID =6
data.Export$LagosVariableName="Carbon, dissolved organic"
data.Export$Value=data$DOC #export values, already in preferred units
unique(data.Export$Value)#look at exported values
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode="NC" #no censored obs.
unique(data.Export$CensorCode)
#continue exporting other info
data.Export$Date = data$formatted_date #date already in correct format
data.Export$Units="mg/L"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
unique(data.Export$SamplePosition)
data.Export$SamplePosition[which(data$SAMSTRAT=="EPI")]="EPI"
data.Export$SamplePosition[which(data$SAMSTRAT=="HYP")]="HYPO"
unique(data.Export$SamplePosition)
#assign sampledepth 
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])#3082 obs are .50 meters
3309-3082#227
data.Export$SampleDepth[which(data.Export$SamplePosition=="EPI")]=0.50
unique(data.Export$SampleDepth)
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])#check to make sure correct number
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB"
unique(data.Export$SampleType)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="Infrared carbon analyzer, persulfate oxidation"
unique(data.Export$LabMethodInfo)#look at unique exported values
data.Export$DetectionLimit= 0.10 #per meta
#export subprograms using the "Affiliation1" program
data.Export$Subprogram=data$Affiliation1
unique(data.Export$Subprogram)
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data.Export$SamplePosition=="HYPO")]="Exact sample depth is unknown, but the sample was collected at the midpoint between the thermocline and the bottom of the lake"
unique(data.Export$Comments)
length(data.Export$Comments[which(data.Export$Comments=="Exact sample depth is unknown, but the sample was collected at the midpoint between the thermocline and the bottom of the lake")])#check to make sure correct number
doc.Final = data.Export
rm(data)
rm(data.Export)

###################################   CHLA    #############################################################################################################################
data=time_nutrients
names(data)#look at column names
#pull out columns of interest
data=data[,c(1,4:7,13:14,38,40:42)]
names(data)
#check how many obs are null for sample position info
unique(data$SAMSTRAT)
length(data$SAMSTRAT[which(is.na(data$SAMSTRAT)==TRUE)])
length(data$SAMSTRAT[which(data$SAMSTRAT=="")])#none null= really good!
#look at values for problems and check/filter out nulls
unique(data$CHLA)
length(data$CHLA[which(is.na(data$CHLA)==TRUE)])
length(data$CHLA[which(data$CHLA=="")])
3512-3380#132 remain after filtering null
data=data[which(is.na(data$CHLA)==FALSE),]

#done filtering

#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID =data$lagos_lakeid
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$lagos_lakename
length(data.Export$LakeName[which(data.Export$LakeName=="")])#4 observations are missing
data.Export$SourceVariableName = "CHLA"
data.Export$SourceVariableDescription = "Chlorophyll a"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID =9
data.Export$LagosVariableName="Chlorophyll a"
data.Export$Value=data$CHLA #export values, already in preferred units
unique(data.Export$Value)#look at exported values
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode="NC" #no censored obs.
unique(data.Export$CensorCode)
#continue exporting other info
data.Export$Date = data$formatted_date #date already in correct format
data.Export$Units="ug/L"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
unique(data.Export$SamplePosition)
data.Export$SamplePosition[which(data$SAMSTRAT=="EPI")]="EPI"
data.Export$SamplePosition[which(data$SAMSTRAT=="HYP")]="HYPO"
unique(data.Export$SamplePosition)
#assign sampledepth 
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])#128 obs are .50 meters
132-128#4
data.Export$SampleDepth[which(data.Export$SamplePosition=="EPI")]=0.50
unique(data.Export$SampleDepth)
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])#check to make sure correct number
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB"
unique(data.Export$SampleType)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
unique(data.Export$LabMethodInfo)#look at unique exported values
data.Export$DetectionLimit= NA #per meta
#export subprograms using the "Affiliation1" program
data.Export$Subprogram=data$Affiliation1
unique(data.Export$Subprogram)
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data.Export$SamplePosition=="HYPO")]="Exact sample depth is unknown, but the sample was collected at the midpoint between the thermocline and the bottom of the lake"
unique(data.Export$Comments)
length(data.Export$Comments[which(data.Export$Comments=="Exact sample depth is unknown, but the sample was collected at the midpoint between the thermocline and the bottom of the lake")])#check to make sure correct number
chla.Final = data.Export
rm(data)
rm(data.Export)

###################################   COLOR_A   #############################################################################################################################
data=time_nutrients
names(data)#look at column names
#pull out columns of interest
data=data[,c(1,4:7,13:14,22,40:42)]
names(data)
#check how many obs are null for sample position info
unique(data$SAMSTRAT)
length(data$SAMSTRAT[which(is.na(data$SAMSTRAT)==TRUE)])
length(data$SAMSTRAT[which(data$SAMSTRAT=="")])#none null= really good!
#look at values for problems and check/filter out nulls
unique(data$COLOR_A)
length(data$COLOR_A[which(is.na(data$COLOR_A)==TRUE)])
length(data$COLOR_A[which(data$COLOR_A=="")])
3512-2506#1006 remain after filtering null
data=data[which(is.na(data$COLOR_A)==FALSE),]

#done filtering

#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID =data$lagos_lakeid
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$lagos_lakename
length(data.Export$LakeName[which(data.Export$LakeName=="")])#38 observations are missing
data.Export$SourceVariableName = "COLOR_A"
data.Export$SourceVariableDescription = "Apparent color"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID =11
data.Export$LagosVariableName="Color, apparent"
data.Export$Value=data$COLOR_A #export values, already in preferred units
unique(data.Export$Value)#look at exported values
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode="NC" #no censored obs.
unique(data.Export$CensorCode)
#continue exporting other info
data.Export$Date = data$formatted_date #date already in correct format
data.Export$Units="PCU"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
unique(data.Export$SamplePosition)
data.Export$SamplePosition[which(data$SAMSTRAT=="EPI")]="EPI"
data.Export$SamplePosition[which(data$SAMSTRAT=="HYP")]="HYPO"
unique(data.Export$SamplePosition)
#assign sampledepth 
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])#986 obs are .50 meters
1006-986#20
data.Export$SampleDepth[which(data.Export$SamplePosition=="EPI")]=0.50
unique(data.Export$SampleDepth)
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])#check to make sure correct number
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB"
unique(data.Export$SampleType)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="475.5 Spectrophotometer"
unique(data.Export$LabMethodInfo)#look at unique exported values
data.Export$DetectionLimit= NA #per meta
#export subprograms using the "Affiliation1" program
data.Export$Subprogram=data$Affiliation1
unique(data.Export$Subprogram)
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data.Export$SamplePosition=="HYPO")]="Exact sample depth is unknown, but the sample was collected at the midpoint between the thermocline and the bottom of the lake"
unique(data.Export$Comments)
length(data.Export$Comments[which(data.Export$Comments=="Exact sample depth is unknown, but the sample was collected at the midpoint between the thermocline and the bottom of the lake")])#check to make sure correct number
colora.Final = data.Export
rm(data)
rm(data.Export)

###################################    COLOR_T     #############################################################################################################################
data=time_nutrients
names(data)#look at column names
#pull out columns of interest
data=data[,c(1,4:7,13:14,21,40:42)]
names(data)
#check how many obs are null for sample position info
unique(data$SAMSTRAT)
length(data$SAMSTRAT[which(is.na(data$SAMSTRAT)==TRUE)])
length(data$SAMSTRAT[which(data$SAMSTRAT=="")])#none null= really good!
#look at values for problems and check/filter out nulls
unique(data$COLOR_T)
length(data$COLOR_T[which(is.na(data$COLOR_T)==TRUE)])
length(data$COLOR_T[which(data$COLOR_T=="")])
3512-960#2552 obs remain after filtering null
data=data[which(is.na(data$COLOR_T)==FALSE),]

#done filtering

#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID =data$lagos_lakeid
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$lagos_lakename
length(data.Export$LakeName[which(data.Export$LakeName=="")])#290 observations are missing
data.Export$SourceVariableName = "COLOR_T"
data.Export$SourceVariableDescription = "True color"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID =12
data.Export$LagosVariableName="Color, true"
data.Export$Value=data$COLOR_T#export values, already in preferred units
unique(data.Export$Value)#look at exported values
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode="NC" #no censored obs.
unique(data.Export$CensorCode)
#continue exporting other info
data.Export$Date = data$formatted_date #date already in correct format
data.Export$Units="PCU"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
unique(data.Export$SamplePosition)
data.Export$SamplePosition[which(data$SAMSTRAT=="EPI")]="EPI"
data.Export$SamplePosition[which(data$SAMSTRAT=="HYP")]="HYPO"
unique(data.Export$SamplePosition)
#assign sampledepth 
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])#2328 obs are .50 meters
2552-2328#224 are hypo NA for depth
data.Export$SampleDepth[which(data.Export$SamplePosition=="EPI")]=0.50
unique(data.Export$SampleDepth)
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])#check to make sure correct number
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB"
unique(data.Export$SampleType)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="475.5 Spectrophotometer"
unique(data.Export$LabMethodInfo)#look at unique exported values
data.Export$DetectionLimit= NA #per meta
#export subprograms using the "Affiliation1" program
data.Export$Subprogram=data$Affiliation1
unique(data.Export$Subprogram)
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data.Export$SamplePosition=="HYPO")]="Exact sample depth is unknown, but the sample was collected at the midpoint between the thermocline and the bottom of the lake"
unique(data.Export$Comments)
length(data.Export$Comments[which(data.Export$Comments=="Exact sample depth is unknown, but the sample was collected at the midpoint between the thermocline and the bottom of the lake")])#check to make sure correct number
colort.Final = data.Export
rm(data)
rm(data.Export)

###################################   NH4    #############################################################################################################################
data=time_nutrients
names(data)#look at column names
#pull out columns of interest
data=data[,c(1,4:7,13:14,34,40:42)]
names(data)
#check how many obs are null for sample position info
unique(data$SAMSTRAT)
length(data$SAMSTRAT[which(is.na(data$SAMSTRAT)==TRUE)])
length(data$SAMSTRAT[which(data$SAMSTRAT=="")])#none null= really good!
#look at values for problems and check/filter out nulls
unique(data$NH4)
length(data$NH4[which(is.na(data$NH4)==TRUE)])
length(data$NH4[which(data$NH4=="")])
3512-1549#1963 obs remain after filtering null
data=data[which(is.na(data$NH4)==FALSE),]

#done filtering

#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID =data$lagos_lakeid
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$lagos_lakename
length(data.Export$LakeName[which(data.Export$LakeName=="")])#163 observations are missing
data.Export$SourceVariableName = "NH4"
data.Export$SourceVariableDescription = "Ammonium (NH4)"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID =19
data.Export$LagosVariableName="Nitrogen, NH4"
data.Export$Value=((data$NH4/55.44)*1000)#export values and convert to preferred units
unique(data.Export$Value)#look at exported values
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode="NC" #no censored obs.
unique(data.Export$CensorCode)
#continue exporting other info
data.Export$Date = data$formatted_date #date already in correct format
data.Export$Units="ug/L"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
unique(data.Export$SamplePosition)
data.Export$SamplePosition[which(data$SAMSTRAT=="EPI")]="EPI"
data.Export$SamplePosition[which(data$SAMSTRAT=="HYP")]="HYPO"
unique(data.Export$SamplePosition)
#assign sampledepth 
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])#2328 obs are .50 meters
1963-1851#112 are hypo NA for depth
data.Export$SampleDepth[which(data.Export$SamplePosition=="EPI")]=0.50
unique(data.Export$SampleDepth)
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])#check to make sure correct number
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB"
unique(data.Export$SampleType)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="Autoanalyzer before and during 2003; Ion chromatography from 2004 and after"
unique(data.Export$LabMethodInfo)#look at unique exported values
data.Export$DetectionLimit= (2.7/55.44)*1000 #per meta
unique(data.Export$DetectionLimit)
#export subprograms using the "Affiliation1" program
data.Export$Subprogram=data$Affiliation1
unique(data.Export$Subprogram)
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data.Export$SamplePosition=="HYPO")]="Exact sample depth is unknown, but the sample was collected at the midpoint between the thermocline and the bottom of the lake"
unique(data.Export$Comments)
length(data.Export$Comments[which(data.Export$Comments=="Exact sample depth is unknown, but the sample was collected at the midpoint between the thermocline and the bottom of the lake")])#check to make sure correct number
nh4.Final = data.Export
rm(data)
rm(data.Export)

###################################  NO3    #############################################################################################################################
data=time_nutrients
names(data)#look at column names
#pull out columns of interest
data=data[,c(1,4:7,13:14,28,40:42)]
names(data)
#check how many obs are null for sample position info
unique(data$SAMSTRAT)
length(data$SAMSTRAT[which(is.na(data$SAMSTRAT)==TRUE)])
length(data$SAMSTRAT[which(data$SAMSTRAT=="")])#none null= really good!
#look at values for problems and check/filter out nulls
unique(data$NO3)
length(data$NO3[which(is.na(data$NO3)==TRUE)])
length(data$NO3[which(data$NO3=="")])
3512-22#3490 obs remain after filtering null
data=data[which(is.na(data$NO3)==FALSE),]

#done filtering

#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID =data$lagos_lakeid
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$lagos_lakename
length(data.Export$LakeName[which(data.Export$LakeName=="")])#363 observations are missing
data.Export$SourceVariableName = "NO3"
data.Export$SourceVariableDescription = "Nitrate (NO3)"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID =18
data.Export$LagosVariableName="Nitrogen, nitrite (NO2) + nitrate (NO3)"
data.Export$Value=((data$NO3/16.13)*1000)#export values and convert to preferred units
unique(data.Export$Value)#look at exported values
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode="NC" #no censored obs.
unique(data.Export$CensorCode)
#continue exporting other info
data.Export$Date = data$formatted_date #date already in correct format
data.Export$Units="ug/L"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
unique(data.Export$SamplePosition)
data.Export$SamplePosition[which(data$SAMSTRAT=="EPI")]="EPI"
data.Export$SamplePosition[which(data$SAMSTRAT=="HYP")]="HYPO"
unique(data.Export$SamplePosition)
#assign sampledepth 
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])#2328 obs are .50 meters
3490-3203#287 are hypo NA for depth
data.Export$SampleDepth[which(data.Export$SamplePosition=="EPI")]=0.50
unique(data.Export$SampleDepth)
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])#check to make sure correct number
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB"
unique(data.Export$SampleType)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="Ion chromotography"
unique(data.Export$LabMethodInfo)#look at unique exported values
data.Export$DetectionLimit= (0.10/16.13)*1000 #per meta
unique(data.Export$DetectionLimit)
#export subprograms using the "Affiliation1" program
data.Export$Subprogram=data$Affiliation1
unique(data.Export$Subprogram)
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data.Export$SamplePosition=="HYPO")]="Exact sample depth is unknown, but the sample was collected at the midpoint between the thermocline and the bottom of the lake"
unique(data.Export$Comments)
length(data.Export$Comments[which(data.Export$Comments=="Exact sample depth is unknown, but the sample was collected at the midpoint between the thermocline and the bottom of the lake")])#check to make sure correct number
no3.Final = data.Export
rm(data)
rm(data.Export)

###################################  N_TD    #############################################################################################################################
data=time_nutrients
names(data)#look at column names
#pull out columns of interest
data=data[,c(1,4:7,13:14,31,40:42)]
names(data)
#check how many obs are null for sample position info
unique(data$SAMSTRAT)
length(data$SAMSTRAT[which(is.na(data$SAMSTRAT)==TRUE)])
length(data$SAMSTRAT[which(data$SAMSTRAT=="")])#none null= really good!
#look at values for problems and check/filter out nulls
unique(data$N_TD)
length(data$N_TD[which(is.na(data$N_TD)==TRUE)])
length(data$N_TD[which(data$N_TD=="")])
3512-1359#2153 obs remain after filtering null
data=data[which(is.na(data$N_TD)==FALSE),]

#done filtering

#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID =data$lagos_lakeid
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$lagos_lakename
length(data.Export$LakeName[which(data.Export$LakeName=="")])#148 observations are missing
data.Export$SourceVariableName = "N_TD"
data.Export$SourceVariableDescription = "Total dissolved nitrogen"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID =22
data.Export$LagosVariableName="Nitrogen, total dissolved"
data.Export$Value=(data$N_TD)#export values w/o conversion
unique(data.Export$Value)#look at exported values
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode="NC" #no censored obs.
unique(data.Export$CensorCode)
#continue exporting other info
data.Export$Date = data$formatted_date #date already in correct format
data.Export$Units="ug/L"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
unique(data.Export$SamplePosition)
data.Export$SamplePosition[which(data$SAMSTRAT=="EPI")]="EPI"
data.Export$SamplePosition[which(data$SAMSTRAT=="HYP")]="HYPO"
unique(data.Export$SamplePosition)
#assign sampledepth 
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])#2328 obs are .50 meters
2153-2058#95 are hypo NA for depth
data.Export$SampleDepth[which(data.Export$SamplePosition=="EPI")]=0.50
unique(data.Export$SampleDepth)
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])#check to make sure correct number
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB"
unique(data.Export$SampleType)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="Automated colorimetry"
unique(data.Export$LabMethodInfo)#look at unique exported values
data.Export$DetectionLimit= 25 #per meta
unique(data.Export$DetectionLimit)
#export subprograms using the "Affiliation1" program
data.Export$Subprogram=data$Affiliation1
unique(data.Export$Subprogram)
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data.Export$SamplePosition=="HYPO")]="Exact sample depth is unknown, but the sample was collected at the midpoint between the thermocline and the bottom of the lake"
unique(data.Export$Comments)
length(data.Export$Comments[which(data.Export$Comments=="Exact sample depth is unknown, but the sample was collected at the midpoint between the thermocline and the bottom of the lake")])#check to make sure correct number
tn.Final = data.Export
rm(data)
rm(data.Export)

################################### P_TD   #############################################################################################################################
data=time_nutrients
names(data)#look at column names
#pull out columns of interest
data=data[,c(1,4:7,13:14,30,40:42)]
names(data)
#check how many obs are null for sample position info
unique(data$SAMSTRAT)
length(data$SAMSTRAT[which(is.na(data$SAMSTRAT)==TRUE)])
length(data$SAMSTRAT[which(data$SAMSTRAT=="")])#none null= really good!
#look at values for problems and check/filter out nulls
unique(data$P_TD)
length(data$P_TD[which(is.na(data$P_TD)==TRUE)])
length(data$P_TD[which(data$P_TD=="")])
3512-1707#1805 obs remain after filtering null
data=data[which(is.na(data$P_TD)==FALSE),]

#done filtering

#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID =data$lagos_lakeid
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$lagos_lakename
length(data.Export$LakeName[which(data.Export$LakeName=="")])#140 observations are missing
data.Export$SourceVariableName = "P_TD"
data.Export$SourceVariableDescription = "Total dissolved phosphorus"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID =28
data.Export$LagosVariableName="Phosphorus, total dissolved"
data.Export$Value=(data$P_TD)#export values 
unique(data.Export$Value)#look at exported values
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode="NC" #no censored obs.
unique(data.Export$CensorCode)
#continue exporting other info
data.Export$Date = data$formatted_date #date already in correct format
data.Export$Units="ug/L"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
unique(data.Export$SamplePosition)
data.Export$SamplePosition[which(data$SAMSTRAT=="EPI")]="EPI"
data.Export$SamplePosition[which(data$SAMSTRAT=="HYP")]="HYPO"
unique(data.Export$SamplePosition)
#assign sampledepth 
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])#2328 obs are .50 meters
1805-1714#91 are hypo NA for depth
data.Export$SampleDepth[which(data.Export$SamplePosition=="EPI")]=0.50
unique(data.Export$SampleDepth)
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])#check to make sure correct number
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB"
unique(data.Export$SampleType)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="Automated colorimetry"
unique(data.Export$LabMethodInfo)#look at unique exported values
data.Export$DetectionLimit= 0.50 #per meta
unique(data.Export$DetectionLimit)
#export subprograms using the "Affiliation1" program
data.Export$Subprogram=data$Affiliation1
unique(data.Export$Subprogram)
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data.Export$SamplePosition=="HYPO")]="Exact sample depth is unknown, but the sample was collected at the midpoint between the thermocline and the bottom of the lake"
unique(data.Export$Comments)
length(data.Export$Comments[which(data.Export$Comments=="Exact sample depth is unknown, but the sample was collected at the midpoint between the thermocline and the bottom of the lake")])#check to make sure correct number
tp.Final = data.Export
rm(data)
rm(data.Export)

################################### SECCHI   #############################################################################################################################
data=time_nutrients
names(data)#look at column names
#pull out columns of interest
data=data[,c(1,4:7,13:14,37,40:42)]
names(data)
#check how many obs are null for sample position info
unique(data$SAMSTRAT)
length(data$SAMSTRAT[which(is.na(data$SAMSTRAT)==TRUE)])
length(data$SAMSTRAT[which(data$SAMSTRAT=="")])#none null= really good!
#look at values for problems and check/filter out nulls
unique(data$SECCHI)
length(data$SECCHI[which(data$SECCHI==".")])#filter these out
data=data[which(data$SECCHI!="."),]
length(data$SECCHI[which(is.na(data$SECCHI)==TRUE)])
length(data$SECCHI[which(data$SECCHI=="")])
3510-3179#331 obs remain after filtering null
data=data[which(data$SECCHI!=""),]

#done filtering

#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID =data$lagos_lakeid
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$lagos_lakename
length(data.Export$LakeName[which(data.Export$LakeName=="")])#40 observations are missing
data.Export$SourceVariableName = "SECCHI"
data.Export$SourceVariableDescription = "Secchi depth"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID =30
data.Export$LagosVariableName="Secchi"
data.Export$Value=(data$SECCHI)#export values 
unique(data.Export$Value)#look at exported values

data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode="NC" #no censored obs.
unique(data.Export$CensorCode)
#continue exporting other info
data.Export$Date = data$formatted_date #date already in correct format
data.Export$Units="m"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="SPECIFIED"
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth=NA
unique(data.Export$SampleDepth)
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])#check to make sure correct number
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED"
unique(data.Export$SampleType)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = "SECCHI_VIEW_UNKNOWN"
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
unique(data.Export$LabMethodInfo)#look at unique exported values
data.Export$DetectionLimit= NA #per meta
unique(data.Export$DetectionLimit)
#export subprograms using the "Affiliation1" program
data.Export$Subprogram=data$Affiliation1
unique(data.Export$Subprogram)
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
unique(data.Export$Comments)
secchi.Final = data.Export
rm(data)
rm(data.Export)


###################################### final export ########################################################################################
Final.Export = rbind(chla.Final,colora.Final,doc.Final,colort.Final,nh4.Final,no3.Final,tn.Final,tp.Final,secchi.Final)
#########################################################################################
##Duplicates check #an observation is defined as duplicate if it is NOT unique for programid, lagoslakeid, date, sampledepth, sampleposition, lagosvariableid, datavalue
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
42+16699#adds up to total
##write table
Final.Export1=data1
typeof(Final.Export1$Value)
unique(Final.Export1$Value)
Final.Export1$Value=as.numeric(Final.Export1$Value)
length(Final.Export1$Value[which(Final.Export1$Value<0)])
nosamplepos=Final.Export1[which(is.na(Final.Export1$SampleDepth)==TRUE & Final.Export1$SamplePosition=="UNKNOWN"),]
write.table(Final.Export1,file="DataImport_EPA_TIME_CHEM.csv",row.names=FALSE,sep=",")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/Northeast TIME RLTM/TIME Data (Finished)/DataImport_EPA_TIME_CHEM/DataImport_EPA_TIME_CHEM.RData")