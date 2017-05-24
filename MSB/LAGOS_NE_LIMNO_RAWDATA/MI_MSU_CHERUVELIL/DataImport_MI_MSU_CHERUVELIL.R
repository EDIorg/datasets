#set path to files
setwd("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MI data/Cheruvelil PhD lakes(finished)/DataImport_MI_MSU_CHERUVELIL")
setwd("C:/Users/Sam/Dropbox/CSI-LIMNO_DATA/DATA-lake/MI data/Cheruvelil PhD lakes(finished)/DataImport_MI_MSU_CHERUVELIL")

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
#data collected from a suite of 54 lakes in s. michigan for dr. cheruvelil's phd project
#sampletype="integrated", sampleposition="epi"
#no unit conversions required, no LabMethodName
###########################################################################################################################################################################################
###################################  WatColAPHA    #############################################################################################################################
data=mi_msu_cheruvelil
head(data)#look at sample of data
names(data)#column names
#pull out columns of interest
data=data[,c(1:2,8,10,12)]
names(data)
#look at values and check for null values
unique(data$WatColAPHA)
length(data$WatColAPHA[which(is.na(data$WatColAPHA)==TRUE)])
length(data$WatColAPHA[which(data$WatColAPHA=="")])
54-36#filter out null, 18 remain
data=data[which(is.na(data$WatColAPHA)==FALSE),]

#proceed to populating LAGOS template

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$NEW_KEY.
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$Lake.
data.Export$SourceVariableName = "WatColAPHA"
data.Export$SourceVariableDescription = "Apparent Color"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no flags w/ these data
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 11
data.Export$LagosVariableName="Color, apparent"
names(data)
data.Export$Value=data$WatColAPHA #export observations already in preferred units
unique(data.Export$Value)
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$Limno_date.#date already in correct format
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
data.Export$SampleDepth= data$EpiDepth_m
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY"
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="water color (APHA) determined with color wheel"
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #per meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
unique(data.Export$Comments)
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
color.Final = data.Export
rm(data)
rm(data.Export)

###################################    TP_ug_L    #############################################################################################################################
data=mi_msu_cheruvelil
head(data)#look at sample of data
names(data)#column names
#pull out columns of interest
data=data[,c(1:2,8,10,14)]
names(data)
#look at values and check for null values
unique(data$TP_ug_L)
length(data$TP_ug_L[which(is.na(data$TP_ug_L)==TRUE)])
length(data$TP_ug_L[which(data$TP_ug_L=="")])
54-1#filter out null, 53 remain
data=data[which(is.na(data$TP_ug_L)==FALSE),]
unique(data$EpiDepth_m)#look at sample depths
#proceed to populating LAGOS template

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$NEW_KEY.
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$Lake.
data.Export$SourceVariableName = "TP_ug_L"
data.Export$SourceVariableDescription = "Total phosphorus"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no flags w/ these data
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 27
data.Export$LagosVariableName="Phosphorus, total"
names(data)
data.Export$Value=data$TP_ug_L #export observations already in preferred units
unique(data.Export$Value)
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$Limno_date.#date already in correct format
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
data.Export$SampleDepth= data$EpiDepth_m
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY"
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="total phosphorus (ug/L) determined by spec"
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #per meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
unique(data.Export$Comments)
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
tp.Final = data.Export
rm(data)
rm(data.Export)

###################################  TN_ug_L     #############################################################################################################################
data=mi_msu_cheruvelil
head(data)#look at sample of data
names(data)#column names
#pull out columns of interest
data=data[,c(1:2,8,10,15)]
names(data)
#look at values and check for null values
unique(data$TN_ug_L)
length(data$TN_ug_L[which(is.na(data$TN_ug_L)==TRUE)])
length(data$TN_ug_L[which(data$TN_ug_L=="")])
54-19#filter out null, 35 remain
data=data[which(is.na(data$TN_ug_L)==FALSE),]
unique(data$EpiDepth_m)#look at sample depths
#proceed to populating LAGOS template

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$NEW_KEY.
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$Lake.
data.Export$SourceVariableName = "TN_ug_L"
data.Export$SourceVariableDescription = "Total nitrogen"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no flags w/ these data
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 21
data.Export$LagosVariableName="Nitrogen, total"
names(data)
data.Export$Value=data$TN_ug_L#export observations already in preferred units
unique(data.Export$Value)
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$Limno_date.#date already in correct format
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
data.Export$SampleDepth= data$EpiDepth_m
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY"
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="total nitrogen (ug/L) determined by spec"
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #per meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
unique(data.Export$Comments)
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
tn.Final = data.Export
rm(data)
rm(data.Export)

###################################  chl_ug_L    #############################################################################################################################
data=mi_msu_cheruvelil
head(data)#look at sample of data
names(data)#column names
#pull out columns of interest
data=data[,c(1:2,8,10,16)]
names(data)
#look at values and check for null values
unique(data$chl_ug_L)
length(data$chl_ug_L[which(is.na(data$chl_ug_L)==TRUE)])
length(data$chl_ug_L[which(data$chl_ug_L=="")])
#no null values
data=data[which(is.na(data$chl_ug_L)==FALSE),] #doesn't change anything
unique(data$EpiDepth_m)#look at sample depths
#proceed to populating LAGOS template

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$NEW_KEY.
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$Lake.
data.Export$SourceVariableName = "chl_ug_L"
data.Export$SourceVariableDescription = "Chlorophyll-a"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no flags w/ these data
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 9
data.Export$LagosVariableName="Chlorophyll a"
names(data)
data.Export$Value=data$chl_ug_L#export observations already in preferred units
unique(data.Export$Value)
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$Limno_date.#date already in correct format
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
data.Export$SampleDepth= data$EpiDepth_m
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY"
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="chlorophyl a (ug/L) determined by flourometer"
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #per meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
unique(data.Export$Comments)
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
chla.Final = data.Export
rm(data)
rm(data.Export)

###################################  Secchi_m  #############################################################################################################################
data=mi_msu_cheruvelil
head(data)#look at sample of data
names(data)#column names
#pull out columns of interest
data=data[,c(1:2,8,10,13)]
names(data)
#look at values and check for null values
unique(data$Secchi_m)
length(data$Secchi_m[which(is.na(data$Secchi_m)==TRUE)])
length(data$Secchi_m[which(data$Secchi_m=="")])
#no null values
data=data[which(is.na(data$Secchi_m)==FALSE),] #doesn't change anything

#proceed to populating LAGOS template

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$NEW_KEY.
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$Lake.
data.Export$SourceVariableName = "Secchi_m"
data.Export$SourceVariableDescription = "Secchi disk depth"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no flags w/ these data
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 30
data.Export$LagosVariableName="Secchi"
names(data)
data.Export$Value=data$Secchi_m#export observations already in preferred units
unique(data.Export$Value)
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$Limno_date.#date already in correct format
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
data.Export$SampleDepth= NA
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY"
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="secchi depth (m) determined over shady side of boat - average of 2 depths"
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #per meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
unique(data.Export$Comments)
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
secchi.Final = data.Export
rm(data)
rm(data.Export)

###################################### final export ########################################################################################
Final.Export = rbind(color.Final,tp.Final,tn.Final,secchi.Final,chla.Final)

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
0+214#adds up to total
##write table
Final.Export1=data1
typeof(Final.Export1$Value)
length(Final.Export1$Value[which(Final.Export1$Value<0)])
write.table(Final.Export1,file="DataImport_MI_MSU_CHERUVELIL.csv",row.names=FALSE,sep=",")
nosamplepos=Final.Export1[which(is.na(Final.Export1$SampleDepth)==TRUE & Final.Export1$SamplePosition=="UNKNOWN"),]
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MI data/Cheruvelil PhD lakes(finished)/DataImport_MI_MSU_CHERUVELIL/DataImport_MI_MSU_CHERUVELIL.RData")