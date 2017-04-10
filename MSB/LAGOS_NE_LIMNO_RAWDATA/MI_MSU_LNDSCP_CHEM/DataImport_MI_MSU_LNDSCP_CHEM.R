#set path to files
setwd("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MI data/Martin_Soranno_2006 study (finished)/DataImport_MI_MSU_LNDSCP_CHEM")
setwd("C:/Users/Sam/Dropbox/CSI-LIMNO_DATA/DATA-lake/MI data/Martin_Soranno_2006 study (finished)/DataImport_MI_MSU_LNDSCP_CHEM")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MI data/Martin_Soranno_2006 study (finished)/DataImport_MI_MSU_LNDSCP_CHEM/DataImport_MI_MSU_LNDSCP_CHEM.RData")


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
#collected by master's student at msu
#71 lake survey during the summer of 2003 (mid-July to August)
#null values= empty cell
#other details specified in log
###########################################################################################################################################################################################
###################################   DOC   #############################################################################################################################
data=MI_MSU_LNDSCP_CHEM
names(data) #looking at column names
#pull out columns of interest
data=data[,c(2:4,21)]
head(data)#looking at data
unique(data$DOC)#checking for problematic values
length(data$DOC[which(is.na(data$DOC)==TRUE)]) #no na values
length(data$DOC[which(data$DOC=="")])#no empty values

#done filtering

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$New_key
data.Export$LakeName = data$Lake_Name
data.Export$SourceVariableName = "DOC"
data.Export$SourceVariableDescription = "Dissolved organic carbon"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags= NA #no source flags specified in data set
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 6
data.Export$LagosVariableName="Carbon, dissolved organic"
names(data)
data.Export$Value = data[,4] #export doc values already in preff. units of mg/L
data.Export$CensorCode = "NC" #no info on CensorCode
data.Export$Date = data$Date #date already in correct format
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
data.Export$SampleDepth=NA #integrated core of epi taken, not a discrete depth
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)]) #check to make sure proper number are NA
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
doc.Final = data.Export
rm(data.Export)
rm(data)


###################################  chla   #############################################################################################################################
data=MI_MSU_LNDSCP_CHEM
names(data) #looking at column names
#pull out columns of interest
data=data[,c(2:4,10)]
head(data)#looking at data
unique(data$chla)#checking for problematic values
length(data$chla[which(is.na(data$chla)==TRUE)]) #no na values
length(data$chla[which(data$chla=="")])#no empty values

#done filtering

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$New_key
data.Export$LakeName = data$Lake_Name
data.Export$SourceVariableName = "chla"
data.Export$SourceVariableDescription = "Average of the 2 Chlorophyll a samples, Chlorophyll a corrected for phaeophytin"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags= NA #no source flags specified in data set
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 9
data.Export$LagosVariableName="Chlorophyll a"
names(data)
data.Export$Value = data[,4] #export chla already in preff. units of ug/L
data.Export$CensorCode = "NC" #no info on CensorCode
data.Export$Date = data$Date #date already in correct format
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
data.Export$SampleDepth=NA #integrated core of epi taken, not a discrete depth
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)]) #check to make sure proper number are NA
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
chla.Final = data.Export
rm(data.Export)
rm(data)


###################################  COLOR  #############################################################################################################################
data=MI_MSU_LNDSCP_CHEM
names(data) #looking at column names
#pull out columns of interest
data=data[,c(2:4,8)]
head(data)#looking at data
unique(data$COLOR)#checking for problematic values
length(data$COLOR[which(is.na(data$COLOR)==TRUE)]) #1 NA value to filter out
length(data$COLOR[which(data$COLOR=="")])#no empty values
data=data[which(is.na(data$COLOR)==FALSE),]
#done filtering

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$New_key
data.Export$LakeName = data$Lake_Name
data.Export$SourceVariableName = "COLOR"
data.Export$SourceVariableDescription = "Apparent color"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags= NA #no source flags specified in data set
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 11
data.Export$LagosVariableName="Color, apparent"
names(data)
data.Export$Value = data[,4] #export COLOR obs. already in PCU the preff. units
data.Export$CensorCode ="NC" #no info on CensorCode
data.Export$Date = data$Date #date already in correct format
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
data.Export$SampleDepth=NA #integrated core of epi taken, not a discrete depth
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)]) #check to make sure proper number are NA
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
color.Final = data.Export
rm(data.Export)
rm(data)


################################### NO3-N (mg/L)  #############################################################################################################################
data=MI_MSU_LNDSCP_CHEM
names(data) #looking at column names
#pull out columns of interest
data=data[,c(2:4,19)]
head(data)#looking at data
unique(data$NO3.N..mg.L.)#checking for problematic values
length(data$NO3.N..mg.L.[which(is.na(data$NO3.N..mg.L.)==TRUE)]) #no na values
length(data$NO3.N..mg.L.[which(data$NO3.N..mg.L.=="")])#no empty values

#done filtering

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$New_key
data.Export$LakeName = data$Lake_Name
data.Export$SourceVariableName = "NO3-N (mg/L)"
data.Export$SourceVariableDescription = "Nitrogen, nitrate"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags= NA #no source flags specified in data set
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 18
data.Export$LagosVariableName="Nitrogen, nitrite (NO2) + nitrate (NO3)"
names(data)
data.Export$Value = ((data[,4])*1000) #export nitrate and * 1000 to go from mg/L to preff ug/L
data.Export$CensorCode = "NC" #no info on CensorCode
data.Export$Date = data$Date #date already in correct format
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
data.Export$SampleDepth=NA #integrated core of epi taken, not a discrete depth
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)]) #check to make sure proper number are NA
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
no3.Final = data.Export
rm(data.Export)
rm(data)


################################### TN  #############################################################################################################################
data=MI_MSU_LNDSCP_CHEM
names(data) #looking at column names
#pull out columns of interest
data=data[,c(2:4,11)]
head(data)#looking at data
unique(data$TN)#checking for problematic values
length(data$TN[which(is.na(data$TN)==TRUE)]) #no na values
length(data$TN[which(data$TN=="")])#no empty values

#done filtering

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$New_key
data.Export$LakeName = data$Lake_Name
data.Export$SourceVariableName = "TN"
data.Export$SourceVariableDescription = "Total nitrogen"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags= NA #no source flags specified in data set
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 21
data.Export$LagosVariableName="Nitrogen, total"
names(data)
data.Export$Value = data[,4] #export tn values already in preff units of ug/L
data.Export$CensorCode = "NC" #no info on CensorCode
data.Export$Date = data$Date #date already in correct format
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
data.Export$SampleDepth=NA #integrated core of epi taken, not a discrete depth
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)]) #check to make sure proper number are NA
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
tn.Final = data.Export
rm(data.Export)
rm(data)

################################### TP #############################################################################################################################
data=MI_MSU_LNDSCP_CHEM
names(data) #looking at column names
#pull out columns of interest
data=data[,c(2:4,12)]
head(data)#looking at data
unique(data$TP)#checking for problematic values
length(data$TP[which(is.na(data$TP)==TRUE)]) #no na values
length(data$TP[which(data$TP=="")])#no empty values

#done filtering

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$New_key
data.Export$LakeName = data$Lake_Name
data.Export$SourceVariableName = "TP"
data.Export$SourceVariableDescription = "Total phosphorus"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags= NA #no source flags specified in data set
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 27
data.Export$LagosVariableName="Phosphorus, total"
names(data)
data.Export$Value = data[,4] #export tP values already in preff units of ug/L
data.Export$CensorCode = "NC" #no info on CensorCode
data.Export$Date = data$Date #date already in correct format
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
data.Export$SampleDepth=NA #integrated core of epi taken, not a discrete depth
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)]) #check to make sure proper number are NA
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
tp.Final = data.Export
rm(data.Export)
rm(data)


################################### SECCHI_m #############################################################################################################################
data=MI_MSU_LNDSCP_CHEM
names(data) #looking at column names
#pull out columns of interest
data=data[,c(2:4,7)]
head(data)#looking at data
unique(data$SECCHI_m)#checking for problematic values
length(data$SECCHI_m[which(is.na(data$SECCHI_m)==TRUE)]) #1 value is missing
length(data$SECCHI_m[which(data$SECCHI_m=="")])#no empty values
data=data[which(is.na(data$SECCHI_m)==FALSE),]
#done filtering

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$New_key
data.Export$LakeName = data$Lake_Name
data.Export$SourceVariableName = "SECCHI_m"
data.Export$SourceVariableDescription = "Secchi depth unknown if viewscope was used"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags= NA #no source flags specified in data set
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 30
data.Export$LagosVariableName="Secchi"
names(data)
data.Export$Value = data[,4] #export SECCHI ALREADY IN PREFF UNITS OF METERS
data.Export$CensorCode = "NC" #no info on CensorCode
data.Export$Date = data$Date #date already in correct format
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
data.Export$SampleDepth=NA #integrated core of epi taken, not a discrete depth
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)]) #check to make sure proper number are NA
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
data.Export$Comments= NA 
secchi.Final = data.Export
rm(data.Export)
rm(data)


###################################### final export ########################################################################################
Final.Export = rbind(chla.Final,color.Final,doc.Final,no3.Final,secchi.Final,tn.Final,tp.Final)
###########################################################

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
0+495#adds up to total
##write table
Final.Export1=data1
typeof(Final.Export1$Value)
length(Final.Export1$Value[which(Final.Export1$Value<0)])
nosamplepos=Final.Export1[which(is.na(Final.Export1$SampleDepth)==TRUE & Final.Export1$SamplePosition=="UNKNOWN"),]
write.table(Final.Export1,file="DataImport_MI_MSU_LNDSCP_CHEM.csv",row.names=FALSE,sep=",")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MI data/Martin_Soranno_2006 study (finished)/DataImport_MI_MSU_LNDSCP_CHEM/DataImport_MI_MSU_LNDSCP_CHEM.RData")