#set path to files
setwd("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/WI data/Webster 2000 Survey/DataImport_WI_LKLS")


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
#dnr project = wisconsin lake landscape survey (LKLS)
#samples collected from the epi (except secchi)
#sample type = integrated
#basintype= unknown
###########################################################################################################################################################################################
################################### TKN    #############################################################################################################################
data=wi_lkls
names(data)#look at column names
#pull out columns of interest
data=data[,c(1:3,6:7,30:31,41)]
names(data)
#check for null observations
unique(data$TKN)#look at values for problems
length(data$TKN[which(is.na(data$TKN)==TRUE)])
length(data$TKN[which(data$TKN=="")])
#no null observations
#check for null sample depth
unique(data$IntSam_depth)
length(data$IntSam_depth[which(data$IntSam_depth=="")])
#no null depths
#look at data flags
unique(data$TKN_tag)#two unique flags to export to source flags and specify in comments
#check for null wbic= LakeId
unique(data$WBIC)
length(data$WBIC[which(data$WBIC=="")])
#no null wbics
#done filtering
#proceed to populating LAGOS template


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$WBIC
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$Lakename
data.Export$SourceVariableName = "TKN"
data.Export$SourceVariableDescription = "total Kjeldahl nitrogen"
#populate SourceFlags
unique(data$TKN_tag)#look at data flags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=data$TKN_tag
unique(data.Export$SourceFlags)
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#number of no flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==FALSE)])#number of flags
length(data.Export$SourceFlags[which(data.Export$SourceFlags=="1")])#set these as NA, see import log
data.Export$SourceFlags[which(data.Export$SourceFlags=="1")]=NA
unique(data.Export$SourceFlags)


#continue populating other lagos variables
data.Export$LagosVariableID = 16
data.Export$LagosVariableName="Nitrogen, total Kjeldahl"
data.Export$Value=data$TKN
unique(data.Export$Value)
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$Date_sampled#date already in correct format
data.Export$Units="ug/L"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"
unique(data.Export$SamplePosition)
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure all INTEGRATED

#assign sampledepth 
data.Export$SampleDepth=data$IntSam_depth
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType[which(data$Sitedep_m==data$Zmax_m)]="PRIMARY"
data.Export$BasinType[which(is.na(data.Export$BasinType)==TRUE)]="UNKNOWN"
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "EPA_351.2" #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo= NA #per metadata
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #per meta
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data.Export$SourceFlags=="3")]="3=value is greater than the limit of detection  but less than the limit of quantification"
unique(data.Export$Comments)
tkn.Final = data.Export
rm(data)
rm(data.Export)

################################### NO3+NO2   #############################################################################################################################
data=wi_lkls
names(data)#look at column names
#pull out columns of interest
data=data[,c(1:3,8:9,30:31,41)]
names(data)
#check for null observations
unique(data$NO3.NO2)#look at values for problems
length(data$NO3.NO2[which(is.na(data$NO3.NO2)==TRUE)])
length(data$NO3.NO2[which(data$NO3.NO2=="")])
#no null observations
#check for null sample depth
unique(data$IntSam_depth)
length(data$IntSam_depth[which(data$IntSam_depth=="")])
#no null depths
#look at data flags
unique(data$NO3_tag)#two unique flags to export to source flags and specify in comments
#check for null wbic= LakeId
unique(data$WBIC)
length(data$WBIC[which(data$WBIC=="")])
#no null wbics
#done filtering
#proceed to populating LAGOS template


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$WBIC
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$Lakename
data.Export$SourceVariableName = "NO3+NO2"
data.Export$SourceVariableDescription = "Nitrate + Nitrite Nitrogen"
#populate SourceFlags
unique(data$NO3_tag)#look at data flags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=data$NO3_tag
unique(data.Export$SourceFlags)
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#number of no flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==FALSE)])#number of flags
#adds up to total
unique(data.Export$SourceFlags)

#continue populating other lagos variables
data.Export$LagosVariableID = 18
data.Export$LagosVariableName="Nitrogen, nitrite (NO2) + nitrate (NO3)"
data.Export$Value=data$NO3.NO2
unique(data.Export$Value)
length(data.Export$SourceFlags[which(data.Export$SourceFlags=="2")])#censor these as LT
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data.Export$SourceFlags=="2")] = "LT"
unique(data.Export$CensorCode)
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]="NC"
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure correct number
unique(data.Export$CensorCode)
data.Export$Date = data$Date_sampled#date already in correct format
data.Export$Units="ug/L"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"
unique(data.Export$SamplePosition)
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure all INTEGRATED

#assign sampledepth 
data.Export$SampleDepth=data$IntSam_depth
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType[which(data$Sitedep_m==data$Zmax_m)]="PRIMARY"
data.Export$BasinType[which(is.na(data.Export$BasinType)==TRUE)]="UNKNOWN"
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "LACHAT_10.107.04.1.J" #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo= NA #per metadata
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #per meta
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
unique(data.Export$SourceFlags)
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data.Export$SourceFlags=="3")]="3=value is greater than the limit of detection  but less than the limit of quantification"
data.Export$Comments[which(data.Export$SourceFlags=="2")]="2=value is less than the limit of detection"
unique(data.Export$Comments)
no3no2.Final = data.Export
rm(data)
rm(data.Export)


################################### Color_true   #############################################################################################################################
data=wi_lkls
names(data)#look at column names
#pull out columns of interest
data=data[,c(1:3,10:11,30:31,41)]
names(data)
#check for null observations
unique(data$Color_true)#look at values for problems
length(data$Color_true[which(is.na(data$Color_true)==TRUE)])
length(data$Color_true[which(data$Color_true=="")])
#no null observations
#check for null sample depth
unique(data$IntSam_depth)
length(data$IntSam_depth[which(data$IntSam_depth=="")])
#no null depths
#look at data flags
unique(data$Col_tag)#two unique flags to export to source flags and specify in comments
#check for null wbic= LakeId
unique(data$WBIC)
length(data$WBIC[which(data$WBIC=="")])
#no null wbics
#done filtering
#proceed to populating LAGOS template


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$WBIC
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$Lakename
data.Export$SourceVariableName = "Color_true"
data.Export$SourceVariableDescription = "True color"
#populate SourceFlags
unique(data$Col_tag)#look at data flags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=data$Col_tag
unique(data.Export$SourceFlags)
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#number of no flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==FALSE)])#number of flags
#adds up to total
unique(data.Export$SourceFlags)

#continue populating other lagos variables
data.Export$LagosVariableID = 12
data.Export$LagosVariableName="Color, true"
data.Export$Value=data$Color_true
unique(data.Export$Value)
length(data.Export$SourceFlags[which(data.Export$SourceFlags=="4")])#censor these as LT
length(data.Export$SourceFlags[which(data.Export$SourceFlags=="5")]) #censor these as GT
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data.Export$SourceFlags=="4")] = "LT"
data.Export$CensorCode[which(data.Export$SourceFlags=="5")] = "GT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]="NC"
unique(data.Export$CensorCode)
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure correct number
length(data.Export$CensorCode[which(data.Export$CensorCode=="GT")])
data.Export$Date = data$Date_sampled#date already in correct format
data.Export$Units="PCU"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"
unique(data.Export$SamplePosition)
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure all INTEGRATED

#assign sampledepth 
data.Export$SampleDepth=data$IntSam_depth
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType[which(data$Sitedep_m==data$Zmax_m)]="PRIMARY"
data.Export$BasinType[which(is.na(data.Export$BasinType)==TRUE)]="UNKNOWN"
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "SM_2120B" #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo= NA #per metadata
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #per meta
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
unique(data.Export$SourceFlags)
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data.Export$SourceFlags=="3")]="3=value is greater than the limit of detection  but less than the limit of quantification"
data.Export$Comments[which(data.Export$SourceFlags=="2")]="2=value is less than the limit of detection"
data.Export$Comments[which(data.Export$SourceFlags=="4")]="4=value is less than the lower bound"
data.Export$Comments[which(data.Export$SourceFlags=="5")]="5=value is greater than the upper bound for color = 140 PCU"
unique(data.Export$Comments)
color.Final = data.Export
rm(data)
rm(data.Export)

###################################   TP   #############################################################################################################################
data=wi_lkls
names(data)#look at column names
#pull out columns of interest
data=data[,c(1:3,14:15,30:31,41)]
names(data)
#check for null observations
unique(data$TP)#look at values for problems
length(data$TP[which(is.na(data$TP)==TRUE)])
length(data$TP[which(data$TP=="")])
#no null observations
#check for null sample depth
unique(data$IntSam_depth)
length(data$IntSam_depth[which(data$IntSam_depth=="")])
#no null depths
#look at data flags
unique(data$TP_tag)#export to source flags and define in comments
#check for null wbic= LakeId
unique(data$WBIC)
length(data$WBIC[which(data$WBIC=="")])
#no null wbics
#done filtering
#proceed to populating LAGOS template


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$WBIC
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$Lakename
data.Export$SourceVariableName = "TP"
data.Export$SourceVariableDescription = "total phosphorus"
#populate SourceFlags
unique(data$TP_tag)#look at data flags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=data$TP_tag
unique(data.Export$SourceFlags)
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#number of no flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==FALSE)])#number of flags
#adds up to total
unique(data.Export$SourceFlags)

#continue populating other lagos variables
data.Export$LagosVariableID = 27
data.Export$LagosVariableName="Phosphorus, total"
data.Export$Value=data$TP*1000
unique(data.Export$Value)
#note that the censor code commands will not have an effect unless the flag is as specified
length(data.Export$SourceFlags[which(data.Export$SourceFlags=="4")])#censor these as LT
length(data.Export$SourceFlags[which(data.Export$SourceFlags=="5")]) #censor these as GT
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data.Export$SourceFlags=="4")] = "LT"
data.Export$CensorCode[which(data.Export$SourceFlags=="5")] = "GT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]="NC"
unique(data.Export$CensorCode)
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure correct number
length(data.Export$CensorCode[which(data.Export$CensorCode=="GT")])
data.Export$Date = data$Date_sampled#date already in correct format
data.Export$Units="ug/L"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"
unique(data.Export$SamplePosition)
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure all INTEGRATED

#assign sampledepth 
data.Export$SampleDepth=data$IntSam_depth
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType[which(data$Sitedep_m==data$Zmax_m)]="PRIMARY"
data.Export$BasinType[which(is.na(data.Export$BasinType)==TRUE)]="UNKNOWN"
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "EPA_365.1" #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo= NA #per metadata
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #per meta
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
unique(data.Export$SourceFlags)
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data.Export$SourceFlags=="3")]="3=value is greater than the limit of detection  but less than the limit of quantification"
data.Export$Comments[which(data.Export$SourceFlags=="2")]="2=value is less than the limit of detection"
data.Export$Comments[which(data.Export$SourceFlags=="4")]="4=value is less than the lower bound"
data.Export$Comments[which(data.Export$SourceFlags=="5")]="5=value is greater than the upper bound for color = 140 PCU"
unique(data.Export$Comments)
tp.Final = data.Export
rm(data)
rm(data.Export)

################################### DOC   #############################################################################################################################
data=wi_lkls
names(data)#look at column names
#pull out columns of interest
data=data[,c(1:3,36,37,30:31,41)]
names(data)
#check for null observations
unique(data$DOC)#look at values for problems
length(data$DOC[which(is.na(data$DOC)==TRUE)])
length(data$DOC[which(data$DOC=="")])
#filter out one null obs.
data=data[which(is.na(data$DOC)==FALSE),]
#check for null sample depth
unique(data$IntSam_depth)
length(data$IntSam_depth[which(data$IntSam_depth=="")])
#no null depths
#look at data flags
unique(data$DOC_lab)#export to source flags and define in comments
#check for null wbic= LakeId
unique(data$WBIC)
length(data$WBIC[which(data$WBIC=="")])
#no null wbics
#done filtering
#proceed to populating LAGOS template


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$WBIC
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$Lakename
data.Export$SourceVariableName = "DOC"
data.Export$SourceVariableDescription = "dissolved organic carbon"
#populate SourceFlags
unique(data$DOC_lab)#look at data flags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=data$DOC_lab
unique(data.Export$SourceFlags)
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#number of no flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==FALSE)])#number of flags
#adds up to total
unique(data.Export$SourceFlags)

#continue populating other lagos variables
data.Export$LagosVariableID = 6
data.Export$LagosVariableName="Carbon, dissolved organic"
data.Export$Value=data$DOC
unique(data.Export$Value)
#note that the censor code commands will not have an effect unless the flag is as specified
length(data.Export$SourceFlags[which(data.Export$SourceFlags=="4")])#censor these as LT
length(data.Export$SourceFlags[which(data.Export$SourceFlags=="5")]) #censor these as GT
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data.Export$SourceFlags=="4")] = "LT"
data.Export$CensorCode[which(data.Export$SourceFlags=="5")] = "GT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]="NC"
unique(data.Export$CensorCode)
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure correct number
length(data.Export$CensorCode[which(data.Export$CensorCode=="GT")])
data.Export$Date = data$Date_sampled#date already in correct format
data.Export$Units="mg/L"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"
unique(data.Export$SamplePosition)
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure all INTEGRATED

#assign sampledepth 
data.Export$SampleDepth=data$IntSam_depth
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType[which(data$Sitedep_m==data$Zmax_m)]="PRIMARY"
data.Export$BasinType[which(is.na(data.Export$BasinType)==TRUE)]="UNKNOWN"
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo= NA #per metadata
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #per meta
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
unique(data.Export$SourceFlags)
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data.Export$SourceFlags=="S")]="S=sample analyzed by Wisconsin State Laboratory of Hygiene"
data.Export$Comments[which(data.Export$SourceFlags=="P")]="P= sample analyzed by Institute for Ecosystem Studies"
unique(data.Export$Comments)
doc.Final = data.Export
rm(data)
rm(data.Export)

################################### 'Secchi_m   #############################################################################################################################
data=wi_lkls
names(data)#look at column names
#pull out columns of interest
data=data[,c(1:3,28:29,30:31,41)]
names(data)
#check for null observations
unique(data$Secchi_m)#look at values for problems
length(data$Secchi_m[which(is.na(data$Secchi_m)==TRUE)])
length(data$Secchi_m[which(data$Secchi_m=="")])
#filter out two null obs.
data=data[which(is.na(data$Secchi_m)==FALSE),]
#check for null sample depth
unique(data$IntSam_depth)
length(data$IntSam_depth[which(data$IntSam_depth=="")])
#no null depths
#look at data flags
unique(data$Secchi_tag)#export to source flags and define in comments
#check for null wbic= LakeId
unique(data$WBIC)
length(data$WBIC[which(data$WBIC=="")])
#no null wbics
#done filtering
#proceed to populating LAGOS template


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$WBIC
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$Lakename
data.Export$SourceVariableName = "Secchi_m"
data.Export$SourceVariableDescription = "Secchi transparency depth"
#populate SourceFlags
unique(data$Secchi_tag)#look at data flags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=data$Secchi_tag
data.Export$SourceFlags[which(data.Export$SourceFlags=="")]=NA
unique(data.Export$SourceFlags)

#continue populating other lagos variables
data.Export$LagosVariableID = 30
data.Export$LagosVariableName="Secchi"
data.Export$Value=data$Secchi_m
unique(data.Export$Value)
#note that the censor code commands will not have an effect unless the flag is as specified
length(data.Export$SourceFlags[which(data.Export$SourceFlags=="VAB")])#censor these as GT
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data.Export$SourceFlags=="VAB")] = "GT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]="NC"
unique(data.Export$CensorCode)
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure correct number
length(data.Export$CensorCode[which(data.Export$CensorCode=="GT")])
data.Export$Date = data$Date_sampled#date already in correct format
data.Export$Units="m"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="SPECIFIED"
unique(data.Export$SamplePosition)
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure all INTEGRATED

#assign sampledepth 
data.Export$SampleDepth=NA
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType[which(data$Sitedep_m==data$Zmax_m)]="PRIMARY"
data.Export$BasinType[which(is.na(data.Export$BasinType)==TRUE)]="UNKNOWN"
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = "SECCHI_VIEW_UNKNOWN" #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo= NA #per metadata
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #per meta
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
unique(data.Export$SourceFlags)
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data.Export$SourceFlags=="VAB")]="VAB= Visible at bottom"
unique(data.Export$Comments)
secchi.Final = data.Export
rm(data)
rm(data.Export)

###################################### final export ########################################################################################
Final.Export = rbind(color.Final,doc.Final,no3no2.Final,secchi.Final,tkn.Final,tp.Final)
#################################################################################################################
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
0+723#adds up to total
##write table
Final.Export1=data1
typeof(Final.Export1$Value)
length(Final.Export1$Value[which(Final.Export1$Value<0)])
nosamplepos=Final.Export1[which(is.na(Final.Export1$SampleDepth)==TRUE & Final.Export1$SamplePosition=="UNKNOWN"),]
write.table(Final.Export1,file="DataImport_WI_LKLS.csv",row.names=FALSE,sep=",")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/WI data/Webster 2000 Survey/DataImport_WI_LKLS/DataImport_WI_LKLS.RData")