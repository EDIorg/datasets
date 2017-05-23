#set path to files
setwd("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MA data/MassDEPData(FINISHED)/DataImport_MA_DEP")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MA data/MassDEPData(FINISHED)/DataImport_MA_DEP/DataImport_MA_DEP.RData")

dataset.variables = data.frame(row=seq(from=1, to=71,by=1),vaiable=names(raw.data))
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
                            Comments=character(0))

###############################     Secchi      ##################################
data = raw.data[,c(2,21,5:8,12,35,4,11,36,24,70)]
data = data[which(data$qctypename!="Duplicate"),]
data = data[which(is.na(data[,3])==FALSE),]
####Begin Populating Lagos Template
data.Export = LAGOS_Template
data.Export[1:nrow(data),]=NA
names(data)

data.Export$LakeID = data[,1]
data.Export$LakeName=data[,2]
data.Export$SourceVariableName = "Secchi"
data.Export$SourceVariableDescription = "Secchi depth w/ or w/o view scope"
data.Export$SourceFlags = data[,4]
# data.Export = data.Export[which(data.Export$SourceFlags!="e"),]
# data.Export$SourceFlags = NA
data.Export$LagosVariableID=30
data.Export$LagosVariableName="Secchi"
data.Export$Value = data[,3]

which.bott = which(data$secbot=="Yes" | data$secbot==">")
data.Export$CensorCode = as.character(data.Export$CensorCode)
data.Export$CensorCode[which.bott] = "GT"
data.Export$CensorCode[is.na(data.Export$CensorCode)] = "NC"

dates = strptime(x=data$date,format="%m/%d/%y")
data.Export$Date = dates

data.Export$Units="m"
data.Export$SampleType="INTEGRATED"
data.Export$SampleDepth=NA
data.Export$SamplePosition="SPECIFIED"
data.Export$BasinType="UNKNOWN"
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo[which(data$secview=="Yes")] = "SECCHI_VIEW"
data.Export$MethodInfo[which(data$secview=="**")] = "SECCHI_VIEW_UNKNOWN"
data.Export$Comments = paste(data[,10],data[,11],sep="; ")
data.Export$Subprogram=data$projname
data.Export = data.Export[which(data.Export$SourceFlags!="e"),]
data.Export$SourceFlags = NA

Secchi.Final = data.Export
rm(dates)
rm(which.bott)
rm(data)
rm(data.Export)

###############################     tp      ##################################
data = raw.data[,c(2,21,57:58,12,31:35,4,11,36,24,70)]
data = data[which(data$qctypename!="Duplicate"),]
data = data[which(is.na(data[,3])==FALSE),]
####Begin Populating Lagos Template
data.Export = LAGOS_Template
data.Export[1:nrow(data),]=NA


data.Export$LakeID = data[,1]
data.Export$LakeName=data[,2]
data.Export$SourceVariableName = "tp"
data.Export$SourceVariableDescription = "Total phosphorus"
data.Export$SourceFlags = data[,4]
data.Export$LagosVariableID=27
data.Export$LagosVariableName="Phosphorus, total"
data.Export$Value = data[,3]

data.Export$CensorCode = as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data.Export$Value<0)] = "LT "
data.Export$DetectionLimit[which(data.Export$Value<0)] = abs(data.Export$Value[which(data.Export$Value<0)])
data.Export$Value[which(data.Export$Value<0)] = abs(data.Export$Value[which(data.Export$Value<0)])
data.Export$CensorCode[is.na(data.Export$CensorCode)] = "NC"

data.Export$Units="ug/L"
data.Export$Value = data.Export$Value*1000
data.Export$DetectionLimit = data.Export$DetectionLimit*1000

dates = strptime(x=data$date,format="%m/%d/%y")
data.Export$Date = dates

data$sdepth1[which(data$sdepth1==(-8))]=NA
data.Export$SamplePosition = as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(data$sampleposition=="epi")] = "EPI"
data.Export$SamplePosition[which(data$sampleposition=="hypo")] = "HYPO"
data.Export$SampleDepth = data$sdepth1
data.Export$SamplePosition[which(is.na(data.Export$SamplePosition)==TRUE & is.na(data.Export$SampleDepth)==FALSE)] = "SPECIFIED"
data.Export$SamplePosition[which(is.na(data.Export$SamplePosition)==TRUE)] = "UNKNOWN"

data.Export$SampleType = as.character(data.Export$SampleType)
data.Export$SampleType[which(data$smptypname=="Van Dorn Bottle")] = "GRAB"
data.Export$SampleType[which(data$smptypname=="Manual Grab")] = "GRAB"
data.Export$SampleType[which(data$smptypname=="Grab")] = "GRAB"
data.Export$SampleType[which(is.na(data.Export$SampleType)==TRUE)] = "UNKNOWN"

data.Export$BasinType = "UNKNOWN"

data.Export$SourceFlags[which(data.Export$SourceFlags=="")] = NA

TP.Final$Subprogram=data$projname
data.Export$Comments = paste(data[,12],data[,13],sep="; ")

TP.Final = data.Export
rm(dates)
rm(data)
rm(data.Export)

###############################     Chla      ##################################
data = raw.data[,c(2,21,47:48,12,31:35,4,11,36,24,70)]
data = data[which(data$qctypename!="Duplicate"),]
data = data[which(is.na(data[,3])==FALSE),]
####Begin Populating Lagos Template
data.Export = LAGOS_Template
data.Export[1:nrow(data),]=NA

names(data)
data.Export$LakeID = data[,1]
data.Export$LakeName=data[,2]
data.Export$SourceVariableName = "chla"
data.Export$SourceVariableDescription = "Chlorophyll a"
data.Export$SourceFlags = data[,4]
data.Export$LagosVariableID=9
data.Export$LagosVariableName="Chlorophyll a"
data.Export$Value = data[,3]

data.Export$CensorCode = as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data.Export$Value<0)] = "LT "
data.Export$DetectionLimit[which(data.Export$Value<0)] = abs(data.Export$Value[which(data.Export$Value<0)])
data.Export$Value[which(data.Export$Value<0)] = abs(data.Export$Value[which(data.Export$Value<0)])
data.Export$CensorCode[is.na(data.Export$CensorCode)] = "NC"

data.Export$Units="ug/L"

data.Export$SourceFlags[which(data.Export$SourceFlags=="")] = NA

dates = strptime(x=data$date,format="%m/%d/%y")
data.Export$Date = dates

data$sdepth1[which(data$sdepth1==(-8))]=NA
data$sdepth1[which(data$sdepth1==(-9))]=0

data$sdepth2[which(data$sdepth2==(-8))]=NA

data.Export$SampleType = as.character(data.Export$SampleType)
data.Export$SampleType[grep("integrate",data$smptypname,ignore.case=TRUE)]="INTEGRATED"
data.Export$SampleType[grep("grab",data$smptypname,ignore.case=TRUE)]="GRAB"
data.Export$SampleType[is.na(data.Export$SampleType)] = "UNKNOWN"

data.Export$SampleDepth[which(data.Export$SampleType=="INTEGRATED")] = data$sdepth2[which(data.Export$SampleType=="INTEGRATED")]
data.Export$SampleDepth[which(data.Export$SampleType=="GRAB")] = data$sdepth1[which(data.Export$SampleType=="GRAB")]

data.Export$SampleType[50] = "INTEGRATED"
data.Export$SampleDepth[50] = 6

data.Export$SamplePosition = as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(data$sampleposition=="epi")] = "EPI"
data.Export$SamplePosition[which(data$sampleposition=="hypo")] = "HYPO"
data.Export$SamplePosition[which(is.na(data.Export$SamplePosition)==TRUE & is.na(data.Export$SampleDepth)==FALSE)] = "SPECIFIED"
data.Export$SamplePosition[which(is.na(data.Export$SamplePosition)==TRUE)] = "UNKNOWN"

data.Export$BasinType = "UNKNOWN"
data.Export$Subprogram=data$projname
data.Export$Comments = paste(data[,12],data[,13],sep="; ")

Chl.Final = data.Export
rm(dates)
rm(data)
rm(data.Export)

###############################     AppCol      ##################################
data = raw.data[,c(2,21,63:64,12,31:35,4,11,36,24,70)]
data = data[which(data$qctypename!="Duplicate"),]
data = data[which(is.na(data[,3])==FALSE),]
####Begin Populating Lagos Template
data.Export = LAGOS_Template
data.Export[1:nrow(data),]=NA


data.Export$LakeID = data[,1]
data.Export$LakeName=data[,2]
data.Export$SourceVariableName = "appcolor"
data.Export$SourceVariableDescription = "Apparent color"
data.Export$SourceFlags = data[,4]
data.Export$LagosVariableID = 11
data.Export$LagosVariableName="Color, apparent"
data.Export$Value = data[,3]

data.Export$CensorCode = as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data.Export$Value<0)] = "LT "
data.Export$DetectionLimit[which(data.Export$Value<0)] = abs(data.Export$Value[which(data.Export$Value<0)])
data.Export$Value[which(data.Export$Value<0)] = abs(data.Export$Value[which(data.Export$Value<0)])
data.Export$CensorCode[is.na(data.Export$CensorCode)] = "NC"

data.Export$DetectionLimit[is.na(data.Export$DetectionLimit)] = 15

data.Export$Units="PCU"

data.Export$SourceFlags[which(data.Export$SourceFlags=="")] = NA

dates = strptime(x=data$date,format="%m/%d/%y")
data.Export$Date = dates

data$sdepth1[which(data$sdepth1==(-8))]=NA
data$sdepth1[which(data$sdepth1==(-9))]=0

# data$sdepth2[which(data$sdepth2==(-8))]=NA

data.Export$SampleType = as.character(data.Export$SampleType)
data.Export$SampleType[grep("grab",data$smptypname,ignore.case=TRUE)]="GRAB"
data.Export$SampleType[grep("van",data$smptypname,ignore.case=TRUE)]="GRAB"
data.Export$SampleType[is.na(data.Export$SampleType)] = "UNKNOWN"

data.Export$SampleDepth = data$sdepth1

data.Export$SamplePosition = as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(data$sampleposition=="epi")] = "EPI"
data.Export$SamplePosition[which(data$sampleposition=="hypo")] = "HYPO"

data.Export$SamplePosition[which(is.na(data.Export$SamplePosition)==TRUE & is.na(data.Export$SampleDepth)==FALSE)] = "SPECIFIED"
data.Export$SamplePosition[which(is.na(data.Export$SamplePosition)==TRUE)] = "UNKNOWN"

data.Export$BasinType = "UNKNOWN"
data.Export$Subprogram=data$projname
data.Export$Comments = paste(data[,12],data[,13],sep="; ")

AppColor.Final = data.Export
rm(dates)
rm(data)
rm(data.Export)



###############################     nh3      ##################################
data = raw.data[,c(2,21,49:50,12,31:35,4,11,36,24,70)]
data = data[which(data$qctypename!="Duplicate"),]
data = data[which(is.na(data[,3])==FALSE),]
####Begin Populating Lagos Template
data.Export = LAGOS_Template
data.Export[1:nrow(data),]=NA


data.Export$LakeID = data[,1]
data.Export$LakeName=data[,2]
data.Export$SourceVariableName = "nh3n"
data.Export$SourceVariableDescription = "ammonia"
data.Export$SourceFlags = data[,4]
data.Export$LagosVariableID = 19
data.Export$LagosVariableName="Nitrogen, NH4"
data.Export$Value = data[,3]

data.Export$CensorCode = as.character(data.Export$CensorCode)
data.Export$Value[which(data.Export$Value<0)]
data.Export$CensorCode[which(data.Export$Value<0)] = "LT "
data.Export$DetectionLimit[which(data.Export$Value<0)] = abs(data.Export$Value[which(data.Export$Value<0)])
data.Export$Value[which(data.Export$Value<0)] = abs(data.Export$Value[which(data.Export$Value<0)])
data.Export$CensorCode[is.na(data.Export$CensorCode)] = "NC"

data.Export$DetectionLimit[is.na(data.Export$DetectionLimit)] = 0.02

data.Export$Units="ug/L"
data.Export[c(8,11)] = data.Export[,c(8,11)]*1000

data.Export$SourceFlags[which(data.Export$SourceFlags=="")] = NA

dates = strptime(x=data$date,format="%m/%d/%y")
data.Export$Date = dates

data$sdepth1[which(data$sdepth1==(-8))]=NA
data$sdepth1[which(data$sdepth1==(-9))]=0

# data$sdepth2[which(data$sdepth2==(-8))]=NA

data.Export$SampleType = as.character(data.Export$SampleType)
data.Export$SampleType[grep("grab",data$smptypname,ignore.case=TRUE)]="GRAB"
data.Export$SampleType[grep("van",data$smptypname,ignore.case=TRUE)]="GRAB"
data.Export$SampleType[is.na(data.Export$SampleType)] = "UNKNOWN"

data.Export$SampleDepth = data$sdepth1

data.Export$SamplePosition = as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(data$sampleposition=="epi")] = "EPI"
data.Export$SamplePosition[which(data$sampleposition=="hypo")] = "HYPO"
data.Export$SamplePosition[which(is.na(data.Export$SamplePosition)==TRUE & is.na(data.Export$SampleDepth)==FALSE)] = "SPECIFIED"
data.Export$SamplePosition[which(is.na(data.Export$SamplePosition)==TRUE)] = "UNKNOWN"

data.Export$BasinType = "UNKNOWN"
data.Export$Subprogram=data$projname
data.Export$Comments = paste(data[,12],data[,13],sep="; ")

NH4.Final = data.Export
rm(dates)
rm(data)
rm(data.Export)


###############################     DIN     ##################################
data = raw.data[,c(2,21,51:52,12,31:35,4,11,36,24,70)]
data = data[which(data$qctypename!="Duplicate"),]
data = data[which(is.na(data[,3])==FALSE),]
####Begin Populating Lagos Template
data.Export = LAGOS_Template
data.Export[1:nrow(data),]=NA


data.Export$LakeID = data[,1]
data.Export$LakeName=data[,2]
data.Export$SourceVariableName = "no3no2n"
data.Export$SourceVariableDescription = "Nitrate/nitrite nitrogen (mg/L)"
data.Export$SourceFlags = data[,4]
data.Export$LagosVariableID = 18
data.Export$LagosVariableName="Nitrogen, nitrite (NO2) + nitrate (NO3)"
data.Export$Value = data[,3]

data.Export$CensorCode = as.character(data.Export$CensorCode)
data.Export$Value[which(data.Export$Value<0)]
data.Export$CensorCode[which(data.Export$Value<0)] = "LT "
data.Export$DetectionLimit[which(data.Export$Value<0)] = abs(data.Export$Value[which(data.Export$Value<0)])
data.Export$Value[which(data.Export$Value<0)] = abs(data.Export$Value[which(data.Export$Value<0)])
data.Export$CensorCode[is.na(data.Export$CensorCode)] = "NC"

data.Export$DetectionLimit[is.na(data.Export$DetectionLimit)] = 0.02

data.Export$Units="ug/L"
data.Export[c(8,11)] = data.Export[,c(8,11)]*1000

data.Export$SourceFlags[which(data.Export$SourceFlags=="")] = NA

dates = strptime(x=data$date,format="%m/%d/%y")
data.Export$Date = dates

data$sdepth1[which(data$sdepth1==(-8))]=NA
data$sdepth1[which(data$sdepth1==(-9))]=0

# data$sdepth2[which(data$sdepth2==(-8))]=NA

unique(data$smptypname)
data.Export$SampleType = as.character(data.Export$SampleType)
data.Export$SampleType[grep("grab",data$smptypname,ignore.case=TRUE)]="GRAB"
data.Export$SampleType[grep("van",data$smptypname,ignore.case=TRUE)]="GRAB"
data.Export$SampleType[is.na(data.Export$SampleType)] = "UNKNOWN"

data.Export$SampleDepth = data$sdepth1

data.Export$SamplePosition = as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(data$sampleposition=="epi")] = "EPI"
data.Export$SamplePosition[which(data$sampleposition=="hypo")] = "HYPO"
data.Export$SamplePosition[which(is.na(data.Export$SamplePosition)==TRUE & is.na(data.Export$SampleDepth)==FALSE)] = "SPECIFIED"
data.Export$SamplePosition[which(is.na(data.Export$SamplePosition)==TRUE)] = "UNKNOWN"

data.Export$BasinType = "UNKNOWN"
data.Export$Subprogram=data$projname
data.Export$Comments = paste(data[,12],data[,13],sep="; ")

DIN.Final = data.Export
rm(dates)
rm(data)
rm(data.Export)


###############################     TN     ##################################
data = raw.data[,c(2,21,55:56,12,31:35,4,11,36,24,70)]
data = data[which(data$qctypename!="Duplicate"),]
data = data[which(is.na(data[,3])==FALSE),]
####Begin Populating Lagos Template
data.Export = LAGOS_Template
data.Export[1:nrow(data),]=NA


data.Export$LakeID = data[,1]
data.Export$LakeName=data[,2]
data.Export$SourceVariableName = "tn"
data.Export$SourceVariableDescription = "Total nitrogen"
data.Export$SourceFlags = data[,4]
data.Export$LagosVariableID = 21
data.Export$LagosVariableName="Nitrogen, total"
data.Export$Value = data[,3]

data.Export$CensorCode = as.character(data.Export$CensorCode)
data.Export$Value[which(data.Export$Value<0)]
# data.Export$CensorCode[which(data.Export$Value<0)] = "LT "
# data.Export$DetectionLimit[which(data.Export$Value<0)] = abs(data.Export$Value[which(data.Export$Value<0)])
# data.Export$Value[which(data.Export$Value<0)] = abs(data.Export$Value[which(data.Export$Value<0)])
data.Export$CensorCode[is.na(data.Export$CensorCode)] = "NC"

# data.Export$DetectionLimit[is.na(data.Export$DetectionLimit)] = 0.02

data.Export$Units="ug/L"
data.Export[c(8,11)] = data.Export[,c(8,11)]*1000

data.Export$SourceFlags[which(data.Export$SourceFlags=="")] = NA

dates = strptime(x=data$date,format="%m/%d/%y")
data.Export$Date = dates

data$sdepth1[which(data$sdepth1==(-8))]=NA
data$sdepth1[which(data$sdepth1==(-9))]=0

# data$sdepth2[which(data$sdepth2==(-8))]=NA

unique(data$smptypname)
data.Export$SampleType = as.character(data.Export$SampleType)
data.Export$SampleType[grep("grab",data$smptypname,ignore.case=TRUE)]="GRAB"
data.Export$SampleType[grep("van",data$smptypname,ignore.case=TRUE)]="GRAB"
data.Export$SampleType[is.na(data.Export$SampleType)] = "UNKNOWN"

data.Export$SampleDepth = data$sdepth1

data.Export$SamplePosition = as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(data$sampleposition=="epi")] = "EPI"
data.Export$SamplePosition[which(data$sampleposition=="hypo")] = "HYPO"
data.Export$SamplePosition[which(is.na(data.Export$SamplePosition)==TRUE & is.na(data.Export$SampleDepth)==FALSE)] = "SPECIFIED"
data.Export$SamplePosition[which(is.na(data.Export$SamplePosition)==TRUE)] = "UNKNOWN"

data.Export$BasinType = "UNKNOWN"
data.Export$Subprogram=data$projname
data.Export$Comments = paste(data[,12],data[,13],sep="; ")

TN.Final = data.Export
rm(dates)
rm(data)
rm(data.Export)



###############################     TKN     ##################################
data = raw.data[,c(2,21,53:54,12,31:35,4,11,36,24,70)]
data = data[which(data$qctypename!="Duplicate"),]
data = data[which(is.na(data[,3])==FALSE),]
####Begin Populating Lagos Template
data.Export = LAGOS_Template
data.Export[1:nrow(data),]=NA


data.Export$LakeID = data[,1]
data.Export$LakeName=data[,2]
data.Export$SourceVariableName = "tkn"
data.Export$SourceVariableDescription = "Total Kjedhal nitrogen"
data.Export$SourceFlags = data[,4]
data.Export$LagosVariableID = 16
data.Export$LagosVariableName="Nitrogen, total Kjeldahl"
data.Export$Value = data[,3]

data.Export$CensorCode = as.character(data.Export$CensorCode)
data.Export$Value[which(data.Export$Value<0)]
# data.Export$CensorCode[which(data.Export$Value<0)] = "LT "
# data.Export$DetectionLimit[which(data.Export$Value<0)] = abs(data.Export$Value[which(data.Export$Value<0)])
# data.Export$Value[which(data.Export$Value<0)] = abs(data.Export$Value[which(data.Export$Value<0)])
data.Export$CensorCode[is.na(data.Export$CensorCode)] = "NC"

# data.Export$DetectionLimit[is.na(data.Export$DetectionLimit)] = 0.02

data.Export$Units="ug/L"
data.Export[c(8,11)] = data.Export[,c(8,11)]*1000

data.Export$SourceFlags[which(data.Export$SourceFlags=="")] = NA

dates = strptime(x=data$date,format="%m/%d/%y")
data.Export$Date = dates

data$sdepth1[which(data$sdepth1==(-8))]=NA
data$sdepth1[which(data$sdepth1==(-9))]=0

# data$sdepth2[which(data$sdepth2==(-8))]=NA

unique(data$smptypname)
data.Export$SampleType = as.character(data.Export$SampleType)
data.Export$SampleType[grep("grab",data$smptypname,ignore.case=TRUE)]="GRAB"
data.Export$SampleType[grep("van",data$smptypname,ignore.case=TRUE)]="GRAB"
data.Export$SampleType[is.na(data.Export$SampleType)] = "UNKNOWN"

data.Export$SampleDepth = data$sdepth1

data.Export$SamplePosition = as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(data$sampleposition=="epi")] = "EPI"
data.Export$SamplePosition[which(data$sampleposition=="hypo")] = "HYPO"
data.Export$SamplePosition[which(is.na(data.Export$SamplePosition)==TRUE & is.na(data.Export$SampleDepth)==FALSE)] = "SPECIFIED"
data.Export$SamplePosition[which(is.na(data.Export$SamplePosition)==TRUE)] = "UNKNOWN"

data.Export$BasinType = "UNKNOWN"
data.Export$Subprogram=data$projname
data.Export$Comments = paste(data[,12],data[,13],sep="; ")

TKN.Final = data.Export
rm(dates)
rm(data)
rm(data.Export)

###############################     SRP     ##################################
data = raw.data[,c(2,21,61:62,12,31:35,4,11,36,24,70)]
data = data[which(data$qctypename!="Duplicate"),]
data = data[which(is.na(data[,3])==FALSE),]
####Begin Populating Lagos Template
data.Export = LAGOS_Template
data.Export[1:nrow(data),]=NA


data.Export$LakeID = data[,1]
data.Export$LakeName=data[,2]
data.Export$SourceVariableName = "drp"
data.Export$SourceVariableDescription = "Dissolved reactive phosphorus"
data.Export$SourceFlags = data[,4]
data.Export$LagosVariableID = 26
data.Export$LagosVariableName="Phosphorus, soluable reactive orthophosphate"
data.Export$Value = data[,3]

data.Export$CensorCode = as.character(data.Export$CensorCode)
data.Export$Value[which(data.Export$Value<0)]
# data.Export$CensorCode[which(data.Export$Value<0)] = "LT "
# data.Export$DetectionLimit[which(data.Export$Value<0)] = abs(data.Export$Value[which(data.Export$Value<0)])
# data.Export$Value[which(data.Export$Value<0)] = abs(data.Export$Value[which(data.Export$Value<0)])
data.Export$CensorCode[is.na(data.Export$CensorCode)] = "NC"

# data.Export$DetectionLimit[is.na(data.Export$DetectionLimit)] = 0.02

data.Export$Units="ug/L"
data.Export[c(8,11)] = data.Export[,c(8,11)]*1000

data.Export$SourceFlags[which(data.Export$SourceFlags=="")] = NA

dates = strptime(x=data$date,format="%m/%d/%y")
data.Export$Date = dates

data$sdepth1[which(data$sdepth1==(-8))]=NA
data$sdepth1[which(data$sdepth1==(-9))]=0

# data$sdepth2[which(data$sdepth2==(-8))]=NA

unique(data$smptypname)
data.Export$SampleType = as.character(data.Export$SampleType)
data.Export$SampleType[grep("grab",data$smptypname,ignore.case=TRUE)]="GRAB"
data.Export$SampleType[grep("van",data$smptypname,ignore.case=TRUE)]="GRAB"
data.Export$SampleType[is.na(data.Export$SampleType)] = "UNKNOWN"

data.Export$SampleDepth = data$sdepth1

data.Export$SamplePosition = as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(data$sampleposition=="epi")] = "EPI"
data.Export$SamplePosition[which(data$sampleposition=="hypo")] = "HYPO"
data.Export$SamplePosition[which(is.na(data.Export$SamplePosition)==TRUE & is.na(data.Export$SampleDepth)==FALSE)] = "SPECIFIED"
data.Export$SamplePosition[which(is.na(data.Export$SamplePosition)==TRUE)] = "UNKNOWN"

data.Export$BasinType = "UNKNOWN"
data.Export$Subprogram=data$projname
data.Export$Comments = paste(data[,12],data[,13],sep="; ")

SRP.Final = data.Export
rm(dates)
rm(data)
rm(data.Export)


###############################     TDP     ##################################
data = raw.data[,c(2,21,59:60,12,31:35,4,11,36,24,70)]
data = data[which(data$qctypename!="Duplicate"),]
data = data[which(is.na(data[,3])==FALSE),]
####Begin Populating Lagos Template
data.Export = LAGOS_Template
data.Export[1:nrow(data),]=NA


data.Export$LakeID = data[,1]
data.Export$LakeName=data[,2]
data.Export$SourceVariableName = "tdphos"
data.Export$SourceVariableDescription = "Total dissolved phosphorus"
data.Export$SourceFlags = data[,4]
data.Export$LagosVariableID = 28
data.Export$LagosVariableName="Phosphorus, total dissolved"
data.Export$Value = data[,3]

data.Export$CensorCode = as.character(data.Export$CensorCode)
data.Export$Value[which(data.Export$Value<0)]
# data.Export$CensorCode[which(data.Export$Value<0)] = "LT "
# data.Export$DetectionLimit[which(data.Export$Value<0)] = abs(data.Export$Value[which(data.Export$Value<0)])
# data.Export$Value[which(data.Export$Value<0)] = abs(data.Export$Value[which(data.Export$Value<0)])
data.Export$CensorCode[is.na(data.Export$CensorCode)] = "NC"

# data.Export$DetectionLimit[is.na(data.Export$DetectionLimit)] = 0.02

data.Export$Units="ug/L"
data.Export[c(8,11)] = data.Export[,c(8,11)]*1000

data.Export$SourceFlags[which(data.Export$SourceFlags=="")] = NA

dates = strptime(x=data$date,format="%m/%d/%y")
data.Export$Date = dates

data$sdepth1[which(data$sdepth1==(-8))]=NA
data$sdepth1[which(data$sdepth1==(-9))]=0

# data$sdepth2[which(data$sdepth2==(-8))]=NA

unique(data$smptypname)
data.Export$SampleType = as.character(data.Export$SampleType)
data.Export$SampleType[grep("grab",data$smptypname,ignore.case=TRUE)]="GRAB"
data.Export$SampleType[grep("van",data$smptypname,ignore.case=TRUE)]="GRAB"
data.Export$SampleType[is.na(data.Export$SampleType)] = "UNKNOWN"

data.Export$SampleDepth = data$sdepth1

data.Export$SamplePosition = as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(data$sampleposition=="epi")] = "EPI"
data.Export$SamplePosition[which(data$sampleposition=="hypo")] = "HYPO"
data.Export$SamplePosition[which(is.na(data.Export$SamplePosition)==TRUE & is.na(data.Export$SampleDepth)==FALSE)] = "SPECIFIED"
data.Export$SamplePosition[which(is.na(data.Export$SamplePosition)==TRUE)] = "UNKNOWN"

data.Export$BasinType = "UNKNOWN"
data.Export$Subprogram=data$projname
data.Export$Comments = paste(data[,12],data[,13],sep="; ")

TDP.Final = data.Export
rm(dates)
rm(data)
rm(data.Export)

########final export #####################

Final.Export = rbind(AppColor.Final,Chl.Final,DIN.Final,NH4.Final,SRP.Final,Secchi.Final,TDP.Final,TKN.Final,TN.Final,TP.Final)
write.table(Final.Export,file="DataImport_MA_DEP.csv",row.names=FALSE,sep=",")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MA data/MassDEPData(FINISHED)/DataImport_MA_DEP/DataImport_MA_DEP.RData")