#set path to files
setwd("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MI data/DEQ-historical data (finished)/DataImport_MI_DEQ_HIST_LWQS")
setwd("C:/Users/Sam/Dropbox/CSI-LIMNO_DATA/DATA-lake/MI data/DEQ-historical data (finished)/DataImport_MI_DEQ_HIST_LWQS")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MI data/DEQ-historical data (finished)/DataImport_MI_DEQ_HIST_LWQS/DataImport_MI_DEQ_HIST_LWQS.RData")


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
#these data were collected by the former michigan dept of environmental quality, a historical lake monitoring dataset
#all samples are grab except chlorophyll a and secchi, a kemmerer was used
#sample depth is specified except for chla which is epi
#basin type is primary unless 2+ similar basins then see import log
#dl's are specified in emi's meta
#lake id's are storet lake id's.
###########################################################################################################################################################################################
###################################   CARBON, TOTAL ORGANIC (MG/L AS C)   #############################################################################################################################
data=mi_deq_hist_lwqs
names(data)#looking at column names
#pull out columns of interest
data=data[,c(1:2,4:8,10:12)]
names(data)
#filter out toc observations
unique(data$Parameter_Long_Name) #look at different parameters
length(data$Parameter_Long_Name[which(data$Parameter_Long_Name=="CARBON, TOTAL ORGANIC (MG/L AS C)")]) #check to see how may obs. remain after filtering
data=data[which(data$Parameter_Long_Name=="CARBON, TOTAL ORGANIC (MG/L AS C)"),]
unique(data$Parameter_Long_Name) #check to make sure all others filtered out
unique(data$Result.Value)#look for observations that are problematic-text etc..
length(data$Result.Value[which(data$Result.Value=="")])#check for blank cells = none
length(data$Result.Value[which(is.na(data$Result.Value)==TRUE)])#none are NA
#look at other columns to understand data
unique(data$Remark.Code)#no unique remark codes here
unique(data$Remark_Description) #no unique remark description
unique(data$Composite.Method.Code)# B is the unique value here
length(data$Composite.Method.Code[which(data$Composite.Method.Code=="B")])# all obs are flagged as B
unique(data$Composite_Method_Description)
#check for missing sample depth since sample position is specified, depth required
unique(data$Sample.Depth)
length(data$Sample.Depth[which(is.na(data$Sample.Depth)==TRUE)])#one observation is missing saple depth, filter out
data=data[which(is.na(data$Sample.Depth)==FALSE),]
#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$Primary.Station.ID
data.Export$LakeName = data$lake_name_text
data.Export$SourceVariableName = "CARBON, TOTAL ORGANIC (MG/L AS C)"
data.Export$SourceVariableDescription = "total organic carbon"
#populate SourceFlags
unique(data$Remark.Code)
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags= NA #no remark codes
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 7
data.Export$LagosVariableName="Carbon, total organic"
names(data)
data.Export$Value = data[,4] #export toc values already in preff. units of mg/L
data.Export$CensorCode = "NC" #no info on CensorCode
data.Export$Date = data$Start.Date #date already in correct format
data.Export$Units="mg/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="SPECIFIED"#per metadata
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")])
#assign sampledepth 
unique(data$Sample.Depth)#look at depths
length(data$Sample.Depth) #219 observations
length(data$Sample.Depth[which(is.na(data$Sample.Depth)==TRUE)])#O ARE NA
data.Export$SampleDepth=data$Sample.Depth
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])#check to make sure none are NA
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
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments= NA 
toc.Final = data.Export
rm(data.Export)
rm(data)

###################################  CHLOROPHYLL A UG/L FLUOROMETRIC CORRECTED    #############################################################################################################################
data=mi_deq_hist_lwqs
names(data)#looking at column names
#pull out columns of interest
data=data[,c(1:2,4:8,10:12)]
names(data)
#filter out chla observations
unique(data$Parameter_Long_Name) #look at different parameters
length(data$Parameter_Long_Name[which(data$Parameter_Long_Name=="CHLOROPHYLL A UG/L FLUOROMETRIC CORRECTED")]) #check to see how may obs. remain after filtering
data=data[which(data$Parameter_Long_Name=="CHLOROPHYLL A UG/L FLUOROMETRIC CORRECTED"),]
unique(data$Parameter_Long_Name) #check to make sure all others filtered out
unique(data$Result.Value)#look for observations that are problematic-text etc..
length(data$Result.Value[which(data$Result.Value=="")])#check for blank cells = none
length(data$Result.Value[which(is.na(data$Result.Value)==TRUE)])#none are NA
#look at other columns to understand data
unique(data$Remark.Code)#four unique remark codes specified in log
#note that values that are "K" or "T" should be assigned a CensorCode of "LT"
unique(data$Remark_Description) #specified in meta and log
unique(data$Composite.Method.Code)# C,B,G are unique here. 
length(data$Composite.Method.Code[which(data$Composite.Method.Code=="C")])
length(data$Composite.Method.Code[which(data$Composite.Method.Code=="G")])
length(data$Composite.Method.Code[which(data$Composite.Method.Code=="B")])
unique(data$Composite_Method_Description) #still assign all chla observations a sampletype of "integrated" as the metadata specifies this is how the sample was collected
#check for missing sample depth since sample position is specified, depth required
unique(data$Sample.Depth)
length(data$Sample.Depth[which(is.na(data$Sample.Depth)==TRUE)])#8 observations are missing sample depths, filter out
#don't need to filter out the missing depth observations because sample position is specified for all
#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$Primary.Station.ID
data.Export$LakeName = data$lake_name_text
data.Export$SourceVariableName = "CHLOROPHYLL A UG/L FLUOROMETRIC CORRECTED"
data.Export$SourceVariableDescription = "chlorophyll a"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
unique(data$Remark.Code) #4 unique flags specified in import log
length(data$Remark.Code[which(data$Remark.Code!="")])#46 should be exported
data.Export$SourceFlags=data$Remark.Code
data.Export$SourceFlags[which(data$Remark.Code=="")]=NA #set null values to NA 
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA
1657+46#adds to total
#continue populating other lagos variables
data.Export$LagosVariableID = 9
data.Export$LagosVariableName="Chlorophyll a"
names(data)
data.Export$Value = data[,4] #export chla values already in preff. units of ug/l
#assign censor code
data.Export$CensorCode=as.character(data.Export$CensorCode)
length(data$Remark.Code[which(data$Remark.Code=="K")])
length(data$Remark.Code[which(data$Remark.Code=="T")])
#33 obs. should be "LT"
data.Export$CensorCode[which(data$Remark.Code=="K")]="LT"
data.Export$CensorCode[which(data$Remark.Code=="T")]="LT"
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure correct number
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]="NC"
unique(data.Export$CensorCode)
#continue populating others
data.Export$Date = data$Start.Date #date already in correct format
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
unique(data$Sample.Depth)#look at depths
length(data$Sample.Depth) #219 observations
length(data$Sample.Depth[which(is.na(data$Sample.Depth)==TRUE)])#8 ARE NA, but doesn't matter because sample position is specified
data.Export$SampleDepth=data$Sample.Depth
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY" #metadata specifies that the deep hole was sampled
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) #check to make sure CORRECT NUMBER populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "SM_P210001WF" #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="extracted using acetone"
data.Export$DetectionLimit= 0.2 #not specified in meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data.Export$SourceFlags=="K")]="K=Off-scale low. Actual value not known- but known to be less than value shown."
data.Export$Comments[which(data.Export$SourceFlags=="J")]="J=Estimated.  Value shown is not a result of analytical measurement."
data.Export$Comments[which(data.Export$SourceFlags=="A")]="A=Value reported is the mean of two or more determinations."
data.Export$Comments[which(data.Export$SourceFlags=="T")]="T=Value reported is less than the criteria of detection."
unique(data.Export$Comments)
chla.Final = data.Export
rm(data.Export)
rm(data)


###################################   COLOR (PLATINUM-COBALT UNITS)  #############################################################################################################################
data=mi_deq_hist_lwqs
names(data)#looking at column names
#pull out columns of interest
data=data[,c(1:2,4:8,10:12)]
names(data)
#filter out color obs
unique(data$Parameter_Long_Name) #look at different parameters
length(data$Parameter_Long_Name[which(data$Parameter_Long_Name=="COLOR (PLATINUM-COBALT UNITS)")]) #check to see how may obs. remain after filtering
data=data[which(data$Parameter_Long_Name=="COLOR (PLATINUM-COBALT UNITS)"),]
unique(data$Parameter_Long_Name) #check to make sure all others filtered out
unique(data$Result.Value)#look for observations that are problematic-text etc..
length(data$Result.Value[which(data$Result.Value=="")])#check for blank cells = none
length(data$Result.Value[which(is.na(data$Result.Value)==TRUE)])#none are NA
#look at other columns to understand data
unique(data$Remark.Code)#K only unique remark doe
unique(data$Remark_Description) #don't worry about this, specified in import log
unique(data$Composite.Method.Code)# B is the unique value here
length(data$Composite.Method.Code[which(data$Composite.Method.Code=="B")])
unique(data$Composite_Method_Description) #don't worry about these
#check for missing sample depth since sample position is specified, depth required
unique(data$Sample.Depth)
length(data$Sample.Depth[which(is.na(data$Sample.Depth)==TRUE)])#one observation is missing saple depth, filter out
#1 obs is null for depth
#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$Primary.Station.ID
data.Export$LakeName = data$lake_name_text
data.Export$SourceVariableName = "COLOR (PLATINUM-COBALT UNITS)"
data.Export$SourceVariableDescription = "true color"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
unique(data$Remark.Code)
length(data$Remark.Code[which(data$Remark.Code=="K")]) #55 flags
data.Export$SourceFlags=data$Remark.Code
data.Export$SourceFlags[which(data$Remark.Code=="")]=NA
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA
2111+55 #adds to total
#continue populating other lagos variables
data.Export$LagosVariableID = 12
data.Export$LagosVariableName="Color, true"
names(data)
data.Export$Value = data[,4] #export color obs. already in preff units of PCU
#populate CensorCode
data.Export$CensorCode=as.character(data.Export$CensorCode)
length(data$Remark.Code[which(data$Remark.Code=="K")]) #55 should be "LT"
data.Export$CensorCode[which(data$Remark.Code=="K")]="LT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]="NC"
unique(data.Export$CensorCode)
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure correct number
#continue
data.Export$Date = data$Start.Date #date already in correct format
data.Export$Units="PCU"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(is.na(data$Sample.Depth)==TRUE)]="UNKNOWN"
data.Export$SamplePosition[which(is.na(data$Sample.Depth)==FALSE)]="SPECIFIED"
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")])
unique(data.Export$SamplePosition)
#assign sampledepth 
unique(data$Sample.Depth)#look at depths
length(data$Sample.Depth) #NO OF observations
length(data$Sample.Depth[which(is.na(data$Sample.Depth)==TRUE)])#1 ARE NA
data.Export$SampleDepth=data$Sample.Depth
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY" #metadata specifies that the deep hole was sampled
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) #check to make sure CORRECT NUMBER populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName="SM_P310001WI"
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= 3 #per meta
data.Export$Comments=as.character(data.Export$Comments)
unique(data.Export$SourceFlags)#define these in the comments field
data.Export$Comments[which(data.Export$SourceFlags=="K")]="K=Off-scale low. Actual value not known- but known to be less than value shown."
data.Export$Comments[which(data.Export$SourceFlags=="J")]="J=Estimated.  Value shown is not a result of analytical measurement."
data.Export$Comments[which(data.Export$SourceFlags=="A")]="A=Value reported is the mean of two or more determinations."
data.Export$Comments[which(data.Export$SourceFlags=="T")]="T=Value reported is less than the criteria of detection."
unique(data.Export$Comments)
color.Final = data.Export
rm(data.Export)
rm(data)


###################################   NITRITE PLUS NITRATE, TOTAL 1 DET. (MG/L AS N)  #############################################################################################################################
data=mi_deq_hist_lwqs
names(data)#looking at column names
#pull out columns of interest
data=data[,c(1:2,4:8,10:12)]
names(data)
#filter out color obs
unique(data$Parameter_Long_Name) #look at different parameters
length(data$Parameter_Long_Name[which(data$Parameter_Long_Name=="NITRITE PLUS NITRATE, TOTAL 1 DET. (MG/L AS N)")]) #check to see how may obs. remain after filtering
data=data[which(data$Parameter_Long_Name=="NITRITE PLUS NITRATE, TOTAL 1 DET. (MG/L AS N)"),]
unique(data$Parameter_Long_Name) #check to make sure all others filtered out
unique(data$Result.Value)#look for observations that are problematic-text etc..
length(data$Result.Value[which(data$Result.Value=="")])#check for blank cells = none
length(data$Result.Value[which(is.na(data$Result.Value)==TRUE)])#none are NA
#look at other columns to understand data
unique(data$Remark.Code)#four unique remark codes= data flags specified in import log
#those observations with remark codes that are k, t, w are assigned a censor code of "LT"
unique(data$Remark_Description) #don't worry about this, specified in import log
unique(data$Composite.Method.Code)# B is the unique value here
length(data$Composite.Method.Code[which(data$Composite.Method.Code=="B")])
unique(data$Composite_Method_Description) #don't worry about these
#check for missing sample depth since sample position is specified, depth required
unique(data$Sample.Depth)
length(data$Sample.Depth[which(is.na(data$Sample.Depth)==TRUE)])#6 observations are missing saple depth
#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$Primary.Station.ID
data.Export$LakeName = data$lake_name_text
data.Export$SourceVariableName = "NITRITE PLUS NITRATE, TOTAL 1 DET. (MG/L AS N)"
data.Export$SourceVariableDescription = "nitrite and nitrate"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
unique(data$Remark.Code)
length(data$Remark.Code[which(data$Remark.Code!="")])#1323 source flags
data.Export$SourceFlags=data$Remark.Code
data.Export$SourceFlags[which(data$Remark.Code=="")]=NA
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA
1323+3858 #adds to total
#continue populating other lagos variables
data.Export$LagosVariableID = 18
data.Export$LagosVariableName="Nitrogen, nitrite (NO2) + nitrate (NO3)"
names(data)
data.Export$Value = (data[,4])*1000 #export nitrate obs * 1000 to go from mg/l to ug/
unique(data.Export$Value)
#populate CensorCode
data.Export$CensorCode=as.character(data.Export$CensorCode)
length(data$Remark.Code[which(data$Remark.Code=="K")]) #327 flags
length(data$Remark.Code[which(data$Remark.Code=="T")]) #800 flags
length(data$Remark.Code[which(data$Remark.Code=="W")]) #186 flags
327+800+186#1313 should have a censor code of "LT"
data.Export$CensorCode[which(data$Remark.Code=="K")]="LT"
data.Export$CensorCode[which(data$Remark.Code=="T")]="LT"
data.Export$CensorCode[which(data$Remark.Code=="W")]="LT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]="NC"
unique(data.Export$CensorCode)
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])
#contiue
data.Export$Date = data$Start.Date #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(is.na(data$Sample.Depth)==TRUE)]="UNKNOWN"
data.Export$SamplePosition[which(is.na(data$Sample.Depth)==FALSE)]="SPECIFIED"
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")])
unique(data.Export$SamplePosition)
#assign sampledepth 
unique(data$Sample.Depth)#look at depths
length(data$Sample.Depth) #NO OF observations
length(data$Sample.Depth[which(is.na(data$Sample.Depth)==TRUE)])#6 ARE NA
data.Export$SampleDepth=data$Sample.Depth
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY" #metadata specifies that the deep hole was sampled
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) #check to make sure CORRECT NUMBER populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName="EPA_E400000WF"
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= (0.0059)*1000 #per meta data * 1000 (convert mg/l to ug/l)
data.Export$Comments=as.character(data.Export$Comments)
unique(data.Export$SourceFlags)#define these in the comments field
data.Export$Comments[which(data.Export$SourceFlags=="K")]="K=Off-scale low. Actual value not known- but known to be less than value shown."
data.Export$Comments[which(data.Export$SourceFlags=="J")]="J=Estimated.  Value shown is not a result of analytical measurement."
data.Export$Comments[which(data.Export$SourceFlags=="A")]="A=Value reported is the mean of two or more determinations."
data.Export$Comments[which(data.Export$SourceFlags=="T")]="T=Value reported is less than the criteria of detection."
data.Export$Comments[which(data.Export$SourceFlags=="W")]="W=Value observed is less than the lowest value reportable under remark 'T'"
unique(data.Export$Comments)
no3no2.Final = data.Export
rm(data.Export)
rm(data)

################################### NITROGEN, KJELDAHL, TOTAL, (MG/L AS N)  #############################################################################################################################
data=mi_deq_hist_lwqs
names(data)#looking at column names4
#pull out columns of interest
data=data[,c(1:2,4:8,10:12)]
names(data)
#filter out color obs
unique(data$Parameter_Long_Name) #look at different parameters
length(data$Parameter_Long_Name[which(data$Parameter_Long_Name=="NITROGEN, KJELDAHL, TOTAL, (MG/L AS N)")]) #check to see how may obs. remain after filtering
data=data[which(data$Parameter_Long_Name=="NITROGEN, KJELDAHL, TOTAL, (MG/L AS N)"),]
unique(data$Parameter_Long_Name) #check to make sure all others filtered out
unique(data$Result.Value)#look for observations that are problematic-text etc..
length(data$Result.Value[which(data$Result.Value=="")])#check for blank cells = none
length(data$Result.Value[which(is.na(data$Result.Value)==TRUE)])#none are NA
#look at other columns to understand data
unique(data$Remark.Code)#two unique remark codes
#those observations with remark code "t" are assigned a censor code of "LT"
unique(data$Remark_Description) #don't worry about this, specified in import log
unique(data$Composite.Method.Code)# B is the unique value here
length(data$Composite.Method.Code[which(data$Composite.Method.Code=="B")])
unique(data$Composite_Method_Description) #don't worry about these
#check for missing sample depth since sample position is specified, depth required
unique(data$Sample.Depth)
length(data$Sample.Depth[which(is.na(data$Sample.Depth)==TRUE)])#0 observations are missing saple depth, filter out

#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$Primary.Station.ID
data.Export$LakeName = data$lake_name_text
data.Export$SourceVariableName = "NITROGEN, KJELDAHL, TOTAL, (MG/L AS N)"
data.Export$SourceVariableDescription = "total Kjeldahl nitrogen"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
unique(data$Remark.Code)
length(data$Remark.Code[which(data$Remark.Code!="")])# 98 source flags
data.Export$SourceFlags=data$Remark.Code
data.Export$SourceFlags[which(data$Remark.Code=="")]=NA
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA
3804+98 #adds to total
#continue populating other lagos variables
data.Export$LagosVariableID = 16
data.Export$LagosVariableName="Nitrogen, total Kjeldahl"
names(data)
data.Export$Value = (data[,4])*1000 #export tkn obs * 1000 to go from mg/l to ug/
#populate CensorCode
data.Export$CensorCode=as.character(data.Export$CensorCode)
length(data$Remark.Code[which(data$Remark.Code=="T")]) #3 flags
#3 should have a censor code of "LT"
data.Export$CensorCode[which(data$Remark.Code=="T")]="LT"
length(data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)])
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]="NC"
unique(data.Export$CensorCode)
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])
#continue
data.Export$Date = data$Start.Date #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="SPECIFIED"#per metadata
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")])
#assign sampledepth 
unique(data$Sample.Depth)#look at depths
length(data$Sample.Depth) #NO OF observations
length(data$Sample.Depth[which(is.na(data$Sample.Depth)==TRUE)])#O ARE NA
data.Export$SampleDepth=data$Sample.Depth
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY" #metadata specifies that the deep hole was sampled
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) #check to make sure CORRECT NUMBER populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName="EPA_E450001WF"
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="Colorimetric, block digestor, automated salicylate"
data.Export$DetectionLimit= (0.064)*1000 #per meta data * 1000 (convert mg/l to ug/l)
data.Export$Comments=as.character(data.Export$Comments)
unique(data.Export$SourceFlags)#define these in the comments field
data.Export$Comments[which(data.Export$SourceFlags=="K")]="K=Off-scale low. Actual value not known- but known to be less than value shown."
data.Export$Comments[which(data.Export$SourceFlags=="J")]="J=Estimated.  Value shown is not a result of analytical measurement."
data.Export$Comments[which(data.Export$SourceFlags=="A")]="A=Value reported is the mean of two or more determinations."
data.Export$Comments[which(data.Export$SourceFlags=="T")]="T=Value reported is less than the criteria of detection."
data.Export$Comments[which(data.Export$SourceFlags=="Q")]="Q=Sample held beyond normal holding time."
unique(data.Export$Comments)
tkn.Final = data.Export
rm(data.Export)
rm(data)


################################### NITROGEN, AMMONIA, TOTAL (MG/L AS N)   #############################################################################################################################
data=mi_deq_hist_lwqs
names(data)#looking at column names
#pull out columns of interest
data=data[,c(1:2,4:8,10:12)]
names(data)
#filter out color obs
unique(data$Parameter_Long_Name) #look at different parameters
length(data$Parameter_Long_Name[which(data$Parameter_Long_Name=="NITROGEN, AMMONIA, TOTAL (MG/L AS N)")]) #check to see how may obs. remain after filtering
data=data[which(data$Parameter_Long_Name=="NITROGEN, AMMONIA, TOTAL (MG/L AS N)"),]
unique(data$Parameter_Long_Name) #check to make sure all others filtered out
unique(data$Result.Value)#look for observations that are problematic-text etc..
length(data$Result.Value[which(data$Result.Value=="")])#check for blank cells = none
length(data$Result.Value[which(is.na(data$Result.Value)==TRUE)])#none are NA
#look at other columns to understand data
unique(data$Remark.Code)#four unique remark codes= data flags specified in import log
#those observations with remark codes that are k, t, w are assigned a censor code of "LT"
unique(data$Remark_Description) #don't worry about this, specified in import log
unique(data$Composite.Method.Code)# B is the unique value here
length(data$Composite.Method.Code[which(data$Composite.Method.Code=="B")])
unique(data$Composite_Method_Description) #don't worry about these
#check for missing sample depth since sample position is specified, depth required
unique(data$Sample.Depth)
length(data$Sample.Depth[which(is.na(data$Sample.Depth)==TRUE)])#7 observations are missing sample depth
#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$Primary.Station.ID
data.Export$LakeName = data$lake_name_text
data.Export$SourceVariableName = "NITROGEN, AMMONIA, TOTAL (MG/L AS N)"
data.Export$SourceVariableDescription = "ammonia (NH3)"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
unique(data$Remark.Code)
length(data$Remark.Code[which(data$Remark.Code!="")])#749 source flags
data.Export$SourceFlags=data$Remark.Code
data.Export$SourceFlags[which(data$Remark.Code=="")]=NA
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA
4514+749 #adds to total
#continue populating other lagos variables
data.Export$LagosVariableID = 19
data.Export$LagosVariableName="Nitrogen, NH4"
names(data)
data.Export$Value = (data[,4])*1000 #export ammonium obs * 1000 to go from mg/l to ug/
#populate CensorCode
data.Export$CensorCode=as.character(data.Export$CensorCode)
length(data$Remark.Code[which(data$Remark.Code=="K")]) #88 flags
length(data$Remark.Code[which(data$Remark.Code=="T")]) #623 flags
length(data$Remark.Code[which(data$Remark.Code=="W")]) #32 flags
88+623+32 # 743 should have a censor code of "LT"
data.Export$CensorCode[which(data$Remark.Code=="K")]="LT"
data.Export$CensorCode[which(data$Remark.Code=="T")]="LT"
data.Export$CensorCode[which(data$Remark.Code=="W")]="LT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]="NC"
unique(data.Export$CensorCode)
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])
#continue
data.Export$Date = data$Start.Date #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(is.na(data$Sample.Depth)==TRUE)]="UNKNOWN"
data.Export$SamplePosition[which(is.na(data$Sample.Depth)==FALSE)]="SPECIFIED"
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")])
unique(data.Export$SamplePosition)
#assign sampledepth 
unique(data$Sample.Depth)#look at depths
length(data$Sample.Depth) #NO OF observations
length(data$Sample.Depth[which(is.na(data$Sample.Depth)==TRUE)])#7 ARE NA
data.Export$SampleDepth=data$Sample.Depth
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY" #metadata specifies that the deep hole was sampled
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) #check to make sure CORRECT NUMBER populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName="EPA_E430000WF"
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="Colorimetric, automated Phenolate"
data.Export$DetectionLimit= (0.0071)*1000 #per meta data * 1000 (convert mg/l to ug/l)
data.Export$Comments=as.character(data.Export$Comments)
unique(data.Export$SourceFlags)#define these in the comments field
data.Export$Comments[which(data.Export$SourceFlags=="K")]="K=Off-scale low. Actual value not known- but known to be less than value shown."
data.Export$Comments[which(data.Export$SourceFlags=="J")]="J=Estimated.  Value shown is not a result of analytical measurement."
data.Export$Comments[which(data.Export$SourceFlags=="A")]="A=Value reported is the mean of two or more determinations."
data.Export$Comments[which(data.Export$SourceFlags=="T")]="T=Value reported is less than the criteria of detection."
data.Export$Comments[which(data.Export$SourceFlags=="W")]="W=Value observed is less than the lowest value reportable under remark 'T'"
unique(data.Export$Comments)
nh4.Final = data.Export
rm(data.Export)
rm(data)

################################### NITROGEN, ORGANIC, TOTAL (MG/L AS N)  #############################################################################################################################
data=mi_deq_hist_lwqs
names(data)#looking at column names
#pull out columns of interest
data=data[,c(1:2,4:8,10:12)]
names(data)
#filter out color obs
unique(data$Parameter_Long_Name) #look at different parameters
length(data$Parameter_Long_Name[which(data$Parameter_Long_Name=="NITROGEN, ORGANIC, TOTAL (MG/L AS N)")]) #check to see how may obs. remain after filtering
data=data[which(data$Parameter_Long_Name=="NITROGEN, ORGANIC, TOTAL (MG/L AS N)"),]
unique(data$Parameter_Long_Name) #check to make sure all others filtered out
unique(data$Result.Value)#look for observations that are problematic-text etc..
length(data$Result.Value[which(data$Result.Value=="")])#check for blank cells = none
length(data$Result.Value[which(is.na(data$Result.Value)==TRUE)])#none are NA
#look at other columns to understand data
unique(data$Remark.Code)#two unique remark codes: c and k
#those observations with remark code "k" are assigned a censor code of "LT"
unique(data$Remark_Description) #don't worry about this, specified in import log
unique(data$Composite.Method.Code)# B is the unique value here
length(data$Composite.Method.Code[which(data$Composite.Method.Code=="B")])
unique(data$Composite_Method_Description) #don't worry about these
#check for missing sample depth since sample position is specified, depth required
unique(data$Sample.Depth)
length(data$Sample.Depth[which(is.na(data$Sample.Depth)==TRUE)])#6 observations are missing saple depth
#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$Primary.Station.ID
data.Export$LakeName = data$lake_name_text
data.Export$SourceVariableName = "NITROGEN, ORGANIC, TOTAL (MG/L AS N)"
data.Export$SourceVariableDescription = "Total organic nitrogen"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
unique(data$Remark.Code)
length(data$Remark.Code[which(data$Remark.Code=="C")])
length(data$Remark.Code[which(data$Remark.Code!="")])#2899 source flags
#note that 2895 of these are "C" which means calculated
data.Export$SourceFlags=data$Remark.Code
data.Export$SourceFlags[which(data$Remark.Code=="")]=NA
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA
2899+888 #adds to total
#continue populating other lagos variables
data.Export$LagosVariableID = 20
data.Export$LagosVariableName="Nitrogen, total organic"
names(data)
data.Export$Value = (data[,4])*1000 #export toc obs * 1000 to go from mg/l to ug/
#populate CensorCode
data.Export$CensorCode=as.character(data.Export$CensorCode)
length(data$Remark.Code[which(data$Remark.Code=="K")]) #4 flags
#4 should have a censor code of "LT"
data.Export$CensorCode[which(data$Remark.Code=="K")]="LT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]="NC"
unique(data.Export$CensorCode)
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure correct number
#continue
data.Export$Date = data$Start.Date #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(is.na(data$Sample.Depth)==TRUE)]="UNKNOWN"
data.Export$SamplePosition[which(is.na(data$Sample.Depth)==FALSE)]="SPECIFIED"
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")])
unique(data.Export$SamplePosition)
#assign sampledepth 
unique(data$Sample.Depth)#look at depths
length(data$Sample.Depth) #NO OF observations
length(data$Sample.Depth[which(is.na(data$Sample.Depth)==TRUE)])#6 ARE NA
data.Export$SampleDepth=data$Sample.Depth
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY" #metadata specifies that the deep hole was sampled
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) #check to make sure CORRECT NUMBER populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName=NA
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA
data.Export$Comments=as.character(data.Export$Comments)
unique(data.Export$SourceFlags)#define these in the comments field
data.Export$Comments[which(data.Export$SourceFlags=="K")]="K=Off-scale low. Actual value not known- but known to be less than value shown."
data.Export$Comments[which(data.Export$SourceFlags=="C")]="C=Calculated.Value stored was not measured directly- but was calculated from other data available"
data.Export$Comments[which(data.Export$SourceFlags=="J")]="J=Estimated.  Value shown is not a result of analytical measurement."
data.Export$Comments[which(data.Export$SourceFlags=="A")]="A=Value reported is the mean of two or more determinations."
data.Export$Comments[which(data.Export$SourceFlags=="T")]="T=Value reported is less than the criteria of detection."
unique(data.Export$Comments)
ton.Final = data.Export
rm(data.Export)
rm(data)



################################### PHOSPHORUS, TOTAL (MG/L AS P)   #############################################################################################################################
data=mi_deq_hist_lwqs
names(data)#looking at column names
#pull out columns of interest
data=data[,c(1:2,4:8,10:12)]
names(data)
#filter out obs of interest
unique(data$Parameter_Long_Name) #look at different parameters
length(data$Parameter_Long_Name[which(data$Parameter_Long_Name=="PHOSPHORUS, TOTAL (MG/L AS P)")]) #check to see how may obs. remain after filtering
data=data[which(data$Parameter_Long_Name=="PHOSPHORUS, TOTAL (MG/L AS P)"),]
unique(data$Parameter_Long_Name) #check to make sure all others filtered out
unique(data$Result.Value)#look for observations that are problematic-text etc..
length(data$Result.Value[which(data$Result.Value=="")])#check for blank cells = none
length(data$Result.Value[which(is.na(data$Result.Value)==TRUE)])#none are NA
#look at other columns to understand data
unique(data$Remark.Code)#four unique remark codes= data flags specified in import log
#those observations with remark codes that are k, t, w are assigned a censor code of "LT"
unique(data$Remark_Description) #don't worry about this, specified in import log
unique(data$Composite.Method.Code)# B is the unique value here
length(data$Composite.Method.Code[which(data$Composite.Method.Code=="B")])
unique(data$Composite_Method_Description) #don't worry about these
#check for missing sample depth since sample position is specified, depth required
unique(data$Sample.Depth)
length(data$Sample.Depth[which(is.na(data$Sample.Depth)==TRUE)])#6 observations are missing saple depth
#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$Primary.Station.ID
data.Export$LakeName = data$lake_name_text
data.Export$SourceVariableName = "PHOSPHORUS, TOTAL (MG/L AS P)"
data.Export$SourceVariableDescription = "Total phospohrus"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
unique(data$Remark.Code)
length(data$Remark.Code[which(data$Remark.Code!="")])#257 source flags
data.Export$SourceFlags=data$Remark.Code
data.Export$SourceFlags[which(data$Remark.Code=="")]=NA
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA
5147+257 #adds to total
#continue populating other lagos variables
data.Export$LagosVariableID = 27
data.Export$LagosVariableName="Phosphorus, total"
names(data)
data.Export$Value = (data[,4])*1000 #export tp obs * 1000 to go from mg/l to ug/
#populate CensorCode
data.Export$CensorCode=as.character(data.Export$CensorCode)
length(data$Remark.Code[which(data$Remark.Code=="K")]) #32 flags
length(data$Remark.Code[which(data$Remark.Code=="T")]) #99 flags
length(data$Remark.Code[which(data$Remark.Code=="W")]) #16 flags
32+99+16 # 147 should have a censor code of "LT"
data.Export$CensorCode[which(data$Remark.Code=="K")]="LT"
data.Export$CensorCode[which(data$Remark.Code=="T")]="LT"
data.Export$CensorCode[which(data$Remark.Code=="W")]="LT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]="NC"
unique(data.Export$CensorCode)
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure correct number
#continue
data.Export$Date = data$Start.Date #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(is.na(data$Sample.Depth)==TRUE)]="UNKNOWN"
data.Export$SamplePosition[which(is.na(data$Sample.Depth)==FALSE)]="SPECIFIED"
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")])
unique(data.Export$SamplePosition)
#assign sampledepth 
unique(data$Sample.Depth)#look at depths
length(data$Sample.Depth) #NO OF observations
length(data$Sample.Depth[which(is.na(data$Sample.Depth)==TRUE)])#6 ARE NA
data.Export$SampleDepth=data$Sample.Depth
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY" #metadata specifies that the deep hole was sampled
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) #check to make sure CORRECT NUMBER populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName="EPA_E550001WF"
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="Colorimetric, Block Digestor, Mercury, Automated Ascorbic Acid Reduction"
#assign detection limits based on the date range specified in emi's metadata
data$Start.Date=as.character(data$Start.Date)
length(data$Start.Date[which(data$Start.Date<"1982-12-31")]) #these have a dl of 5.2 per meta
length(data$Start.Date[which(data$Start.Date>"1982-12-31")]) #these have a dl of 1.9 per meta
2720+2684#adds up to total
data.Export$DetectionLimit[which(data$Start.Date<"1982-12-31")]=5.2
data.Export$DetectionLimit[which(data$Start.Date>"1982-12-31")]=1.9
unique(data.Export$DetectionLimit)
data.Export$Comments=as.character(data.Export$Comments)
unique(data.Export$SourceFlags)#define these in the comments field
data.Export$Comments[which(data.Export$SourceFlags=="K")]="K=Off-scale low. Actual value not known- but known to be less than value shown."
data.Export$Comments[which(data.Export$SourceFlags=="J")]="J=Estimated.  Value shown is not a result of analytical measurement."
data.Export$Comments[which(data.Export$SourceFlags=="A")]="A=Value reported is the mean of two or more determinations."
data.Export$Comments[which(data.Export$SourceFlags=="T")]="T=Value reported is less than the criteria of detection."
data.Export$Comments[which(data.Export$SourceFlags=="Q")]="Q=Sample held beyond normal holding time."
data.Export$Comments[which(data.Export$SourceFlags=="W")]="W=Value observed is less than the lowest value reportable under remark 'T'."
unique(data.Export$Comments)
tp.Final = data.Export
rm(data.Export)
rm(data)

################################### PHOSPHORUS,IN TOTAL ORTHOPHOSPHATE (MG/L AS P)   #############################################################################################################################
data=mi_deq_hist_lwqs
names(data)#looking at column names
#pull out columns of interest
data=data[,c(1:2,4:8,10:12)]
names(data)
#filter out obs of interest
unique(data$Parameter_Long_Name) #look at different parameters
length(data$Parameter_Long_Name[which(data$Parameter_Long_Name=="PHOSPHORUS,IN TOTAL ORTHOPHOSPHATE (MG/L AS P)")]) #check to see how may obs. remain after filtering
data=data[which(data$Parameter_Long_Name=="PHOSPHORUS,IN TOTAL ORTHOPHOSPHATE (MG/L AS P)"),]
unique(data$Parameter_Long_Name) #check to make sure all others filtered out
unique(data$Result.Value)#look for observations that are problematic-text etc..
length(data$Result.Value[which(data$Result.Value=="")])#check for blank cells = none
length(data$Result.Value[which(is.na(data$Result.Value)==TRUE)])#none are NA
#look at other columns to understand data
unique(data$Remark.Code)#four unique remark codes= data flags specified in import log
#those observations with remark codes that are k, t, w are assigned a censor code of "LT"
unique(data$Remark_Description) #don't worry about this, specified in import log
unique(data$Composite.Method.Code)# B is the unique value here
length(data$Composite.Method.Code[which(data$Composite.Method.Code=="B")])
unique(data$Composite_Method_Description) #don't worry about these
#check for missing sample depth since sample position is specified, depth required
unique(data$Sample.Depth)
length(data$Sample.Depth[which(is.na(data$Sample.Depth)==TRUE)])#6 observations are missing saple depth
#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$Primary.Station.ID
data.Export$LakeName = data$lake_name_text
data.Export$SourceVariableName = "PHOSPHORUS,IN TOTAL ORTHOPHOSPHATE (MG/L AS P)"
data.Export$SourceVariableDescription = "Ortho phosphorus"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
unique(data$Remark.Code)
length(data$Remark.Code[which(data$Remark.Code!="")])#1203 source flags
data.Export$SourceFlags=data$Remark.Code
data.Export$SourceFlags[which(data$Remark.Code=="")]=NA
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA
1851+1203 #adds to total
#continue populating other lagos variables
data.Export$LagosVariableID = 26
data.Export$LagosVariableName="Phosphorus, soluable reactive orthophosphate"
names(data)
data.Export$Value = (data[,4])*1000 #export drp obs * 1000 to go from mg/l to ug/
#populate CensorCode
data.Export$CensorCode=as.character(data.Export$CensorCode)
length(data$Remark.Code[which(data$Remark.Code=="K")]) #832 flags
length(data$Remark.Code[which(data$Remark.Code=="T")]) #198 flags
length(data$Remark.Code[which(data$Remark.Code=="W")]) #172 flags
172+198+832 # 1202 should have a censor code of "LT"
data.Export$CensorCode[which(data$Remark.Code=="K")]="LT"
data.Export$CensorCode[which(data$Remark.Code=="T")]="LT"
data.Export$CensorCode[which(data$Remark.Code=="W")]="LT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]="NC"
unique(data.Export$CensorCode)
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure correct number
data.Export$Date = data$Start.Date #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(is.na(data$Sample.Depth)==TRUE)]="UNKNOWN"
data.Export$SamplePosition[which(is.na(data$Sample.Depth)==FALSE)]="SPECIFIED"
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")])
unique(data.Export$SamplePosition)
#assign sampledepth 
unique(data$Sample.Depth)#look at depths
length(data$Sample.Depth) #NO OF observations
length(data$Sample.Depth[which(is.na(data$Sample.Depth)==TRUE)])#6 ARE NA
data.Export$SampleDepth=data$Sample.Depth
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY" #metadata specifies that the deep hole was sampled
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) #check to make sure CORRECT NUMBER populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName="EPA_E550001WF"
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="Colorimetric, Block Digestor, Mercury, Automated Ascorbic Acid Reduction"
data.Export$DetectionLimit=3
data.Export$Comments=as.character(data.Export$Comments)
unique(data.Export$SourceFlags)#define these in the comments field
data.Export$Comments[which(data.Export$SourceFlags=="K")]="K=Off-scale low. Actual value not known- but known to be less than value shown."
data.Export$Comments[which(data.Export$SourceFlags=="J")]="J=Estimated.  Value shown is not a result of analytical measurement."
data.Export$Comments[which(data.Export$SourceFlags=="A")]="A=Value reported is the mean of two or more determinations."
data.Export$Comments[which(data.Export$SourceFlags=="T")]="T=Value reported is less than the criteria of detection."
data.Export$Comments[which(data.Export$SourceFlags=="W")]="W=Value observed is less than the lowest value reportable under remark 'T'."
unique(data.Export$Comments)
drp.Final = data.Export
rm(data.Export)
rm(data)


###################################   TRANSPARENCY, SECCHI DISC (INCHES)  #############################################################################################################################
data=mi_deq_hist_lwqs
names(data)#looking at column names
#pull out columns of interest
data=data[,c(1:2,4:8,10:12)]
names(data)
#filter out  observations
unique(data$Parameter_Long_Name) #look at different parameters
length(data$Parameter_Long_Name[which(data$Parameter_Long_Name=="TRANSPARENCY, SECCHI DISC (INCHES)")]) #check to see how may obs. remain after filtering
data=data[which(data$Parameter_Long_Name=="TRANSPARENCY, SECCHI DISC (INCHES)"),]
unique(data$Parameter_Long_Name) #check to make sure all others filtered out
unique(data$Result.Value)#look for observations that are problematic-text etc..
length(data$Result.Value[which(data$Result.Value=="")])#check for blank cells = none
length(data$Result.Value[which(is.na(data$Result.Value)==TRUE)])#none are NA
#look at other columns to understand data
unique(data$Remark.Code)#two unique remark codes. L=censor code of "GT", K=censor code of "LT"
unique(data$Remark_Description) #no unique remark description
unique(data$Composite.Method.Code)# B is the unique value here
length(data$Composite.Method.Code[which(data$Composite.Method.Code=="B")])
unique(data$Composite_Method_Description)
#check for missing sample depth since sample position is specified, depth required
#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$Primary.Station.ID
data.Export$LakeName = data$lake_name_text
data.Export$SourceVariableName = "TRANSPARENCY, SECCHI DISC (INCHES)"
data.Export$SourceVariableDescription = "secchi"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
unique(data$Remark.Code)
length(data$Remark.Code[which(data$Remark.Code!="")])#32 flags
data.Export$SourceFlags=data$Remark.Code
data.Export$SourceFlags[which(data$Remark.Code=="")]=NA
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA
1758+32#adds up to total
#continue populating other lagos variables
data.Export$LagosVariableID = 30
data.Export$LagosVariableName="Secchi"
names(data)
data.Export$Value = data[,4]*0.0254 #export secchi and convert from inches to meters.
#assign censor code
data.Export$CensorCode=as.character(data.Export$CensorCode)
unique(data$Remark.Code)
length(data$Remark.Code[which(data$Remark.Code=="L")])# 31 censor code of "GT"
length(data$Remark.Code[which(data$Remark.Code=="K")])#1 censor code of "LT"
data.Export$CensorCode[which(data$Remark.Code=="L")]="GT"
data.Export$CensorCode[which(data$Remark.Code=="K")]="LT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]="NC"
unique(data.Export$CensorCode)
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure correct number
length(data.Export$CensorCode[which(data.Export$CensorCode=="GT")])#check to make sure correct number
data.Export$Date = data$Start.Date #date already in correct format
data.Export$Units="m"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED" #because secchi
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="SPECIFIED"#per metadata
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")])
#assign sampledepth 
data.Export$SampleDepth=NA #because secchi
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY" #metadata specifies that the deep hole was sampled
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) #check to make sure CORRECT NUMBER populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = "SECCHI_VIEW_UNKNOWN"
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #not specified in meta
data.Export$Comments=as.character(data.Export$Comments)
unique(data.Export$SourceFlags)#define these in the comments field
data.Export$Comments[which(data.Export$SourceFlags=="K")]="K=Off-scale low. Actual value not known- but known to be less than value shown."
data.Export$Comments[which(data.Export$SourceFlags=="L")]="L=Off-scale high.  Actual value not known- but known to be greater than value shown."
data.Export$Comments[which(data.Export$SourceFlags=="J")]="J=Estimated.  Value shown is not a result of analytical measurement."
data.Export$Comments[which(data.Export$SourceFlags=="A")]="A=Value reported is the mean of two or more determinations."
data.Export$Comments[which(data.Export$SourceFlags=="T")]="T=Value reported is less than the criteria of detection."
unique(data.Export$Comments)
secchi.Final = data.Export
rm(data.Export)
rm(data)


###################################### final export ########################################################################################
Final.Export = rbind(chla.Final,color.Final,drp.Final,nh4.Final,no3no2.Final,secchi.Final,tkn.Final,ton.Final,tp.Final)
###################################################################
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
77+32173#adds up to total
##write table
Final.Export1=data1
typeof(Final.Export1$Value)
length(Final.Export1$Value[which(Final.Export1$Value<0)])
negative.df=Final.Export1[which(Final.Export1$Value<0),]
unique(negative.df$SourceVariableName)
32250-43#no. remaining after filtering out negatives
Final.Export1=Final.Export1[which(Final.Export1$Value>=0),]
nosamplepos=Final.Export1[which(is.na(Final.Export1$SampleDepth)==TRUE & Final.Export1$SamplePosition=="UNKNOWN"),]
write.table(Final.Export1,file="DataImport_MI_DEQ_HIST_LWQS.csv",row.names=FALSE,sep=",")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MI data/DEQ-historical data (finished)/DataImport_MI_DEQ_HIST_LWQS/DataImport_MI_DEQ_HIST_LWQS.RData")
save.image("C:/Users/Sam/Dropbox/CSI-LIMNO_DATA/DATA-lake/MI data/DEQ-historical data (finished)/DataImport_MI_DEQ_HIST_LWQS/DataImport_MI_DEQ_HIST_LWQS.RData"