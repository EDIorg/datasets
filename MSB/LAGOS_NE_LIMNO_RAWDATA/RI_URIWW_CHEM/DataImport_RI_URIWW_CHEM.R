#set working directory
setwd("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/RI data/DataImport_RI_URIWW_CHEM")

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
#CITIZEN monitoring data from lakes in RI, salt or tidally influenced ponds excluded
#only a single site on each lake
#sample depth= NA
#sample position= EPI, depths typically from 0.1-1.0 meters but highly erratic
#see import log for others
###############################################################################################################################################
################################### Chl a #############################################################################################################################
data=ri_uriww_chem
names(data)
unique(data$WB.Code)#lake id
unique(data$Site)#lake name
unique(data$Chl.a) #look for problematic observations and null values
length(data$Chl.a[which(data$Chl.a=="")])
length(data$Chl.a[which(is.na(data$Chl.a)==TRUE)])
#filter out na observations
24263-10369#number remaining after filtering out null
data=data[which(is.na(data$Chl.a)==FALSE),]

#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID=data$WB.Code
unique(data.Export$LakeID)
length(data.Export$LakeID[which(data.Export$LakeID=="")])
#export lake name
data.Export$LakeName = data$Site
#continue with other variables
data.Export$SourceVariableName = "Chl a"
data.Export$SourceVariableDescription = "Chlorophyll a"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags= NA 
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 9
data.Export$LagosVariableName="Chlorophyll a"
#export values
typeof(data$Chl.a)
data.Export$Value = data$Chl.a
unique(data.Export$Value)
#continue exporting
data.Export$CensorCode = "NC" #no info on CensorCode
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
#SAMPLE position
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth=NA
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])#check to make sure all NA
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY"
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) #check to make sure CORRECT NUMBER populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "SM_10200H" #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= 1.0 #specified in meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
unique(data.Export$Comments)
chla.Final = data.Export
rm(data.Export)
rm(data)

################################### NH4  #############################################################################################################################
data=ri_uriww_chem
names(data)
unique(data$WB.Code)#lake id
unique(data$Site)#lake name
unique(data$NH4) #look for problematic observations and null values
length(data$NH4[which(data$NH4=="")])
length(data$NH4[which(is.na(data$NH4)==TRUE)])
length(data$NH4[which(data$NH4=="nd")])
#filter out null and "nd" observations
24263-(22516+30)#number remaining after filtering out null
data=data[which(data$NH4!="nd"),]
data=data[which(data$NH4!=""),]
#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID=data$WB.Code
unique(data.Export$LakeID)
length(data.Export$LakeID[which(data.Export$LakeID=="")])
#export lake name
data.Export$LakeName = data$Site
#continue with other variables
data.Export$SourceVariableName = "NH4"
data.Export$SourceVariableDescription = "NH4 filtered (0.4 µ)"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags= NA 
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 19
data.Export$LagosVariableName="Nitrogen, NH4"
#export values-convert from integer to numeric
typeof(data$NH4)
unique(data$NH4)
data$NH4=as.character(data$NH4)
data.Export$Value=as.character(data.Export$Value)
data.Export$Value = data$NH4
unique(data.Export$Value)
data.Export$Value=as.numeric(data.Export$Value)
#continue exporting
data.Export$CensorCode = "NC" #no info on CensorCode
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
#SAMPLE position
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth=NA
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])#check to make sure all NA
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY"
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) #check to make sure CORRECT NUMBER populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "SM_4500NH4G" #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= 3.0 #specified in meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
unique(data.Export$Comments)
nh4.Final = data.Export
rm(data.Export)
rm(data)

###################################  NO3 #############################################################################################################################
data=ri_uriww_chem
names(data)
unique(data$WB.Code)#lake id
unique(data$Site)#lake name
unique(data$NO3) #look for problematic observations and null values
length(data$NO3[which(data$NO3=="")])
length(data$NO3[which(is.na(data$NO3)==TRUE)])
length(data$NO3[which(data$NO3=="nd")])
#filter out null and "nd" observations
24263-(20878+1018)#number remaining after filtering out null
data=data[which(data$NO3!=""),]
data=data[which(data$NO3!="nd"),]
#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID=data$WB.Code
unique(data.Export$LakeID)
length(data.Export$LakeID[which(data.Export$LakeID=="")])
#export lake name
data.Export$LakeName = data$Site
#continue with other variables
data.Export$SourceVariableName = "NO3"
data.Export$SourceVariableDescription = "NO3"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags= NA 
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 18
data.Export$LagosVariableName="Nitrogen, nitrite (NO2) + nitrate (NO3)"
#export values-convert from integer to numeric
typeof(data$NO3)
unique(data$NO3)
data$NO3=as.character(data$NO3)
data.Export$Value=as.character(data.Export$Value)
data.Export$Value = data$NO3
unique(data.Export$Value)
data.Export$Value=as.numeric(data.Export$Value)
#continue exporting
data.Export$CensorCode = "NC" #no info on CensorCode
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
#SAMPLE position
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth=NA
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])#check to make sure all NA
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY"
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) #check to make sure CORRECT NUMBER populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "SM_4500NO3F" #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= 2.3 #specified in meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
unique(data.Export$Comments)
no3.Final = data.Export
rm(data.Export)
rm(data)

################################### TN  #############################################################################################################################
data=ri_uriww_chem
names(data)
unique(data$WB.Code)#lake id
unique(data$Site)#lake name
unique(data$TN) #look for problematic observations and null values
length(data$TN[which(data$TN=="")])
length(data$TN[which(is.na(data$TN)==TRUE)])
length(data$TN[which(data$TN=="nd")])
#filter out null and "nd" observations
24263-(21301)#number remaining after filtering out null
data=data[which(is.na(data$TN)==FALSE),]
#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID=data$WB.Code
unique(data.Export$LakeID)
length(data.Export$LakeID[which(data.Export$LakeID=="")])
#export lake name
data.Export$LakeName = data$Site
#continue with other variables
data.Export$SourceVariableName = "TN"
data.Export$SourceVariableDescription = "TN"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags= NA 
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 21
data.Export$LagosVariableName="Nitrogen, total "
#export values
typeof(data$TN)
data.Export$Value = data$TN
unique(data.Export$Value)
#continue exporting
data.Export$CensorCode = "NC" #no info on CensorCode
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
#SAMPLE position
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth=NA
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])#check to make sure all NA
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY"
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) #check to make sure CORRECT NUMBER populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "SM_4500NORGD" #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= 3.2 #specified in meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
unique(data.Export$Comments)
tn.Final = data.Export
rm(data.Export)
rm(data)

################################### TP  #############################################################################################################################
data=ri_uriww_chem
names(data)
unique(data$WB.Code)#lake id
unique(data$Site)#lake name
unique(data$TP) #look for problematic observations and null values
length(data$TP[which(data$TP=="")])
length(data$TP[which(is.na(data$TP)==TRUE)])
length(data$TP[which(data$TP=="nd")])
#filter out null and "nd" observations
24263-(20486+19)#number remaining after filtering out null
data=data[which(data$TP!=""),]
data=data[which(data$TP!="nd"),]
#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID=data$WB.Code
unique(data.Export$LakeID)
length(data.Export$LakeID[which(data.Export$LakeID=="")])
#export lake name
data.Export$LakeName = data$Site
#continue with other variables
data.Export$SourceVariableName = "TP"
data.Export$SourceVariableDescription = "TP"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags= NA 
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 27
data.Export$LagosVariableName="Phosphorus, total"
#export values and deal with integer data type
typeof(data$TP)
unique(data$TP)
data$TP=as.character(data$TP)
data.Export$Value=as.character(data.Export$Value)
data.Export$Value = data$TP
unique(data.Export$Value)
data.Export$Value=as.numeric(data.Export$Value)

#continue exporting
data.Export$CensorCode = "NC" #no info on CensorCode
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
#SAMPLE position
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth=NA
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])#check to make sure all NA
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY"
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) #check to make sure CORRECT NUMBER populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "SM_4500PF" #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= 0.3 #specified in meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
unique(data.Export$Comments)
tp.Final = data.Export
rm(data.Export)
rm(data)

################################### Secchi  #############################################################################################################################
data=ri_uriww_chem
names(data)
unique(data$WB.Code)#lake id
unique(data$Site)#lake name
unique(data$Secchi) #look for problematic observations and null values
length(data$Secchi[which(data$Secchi=="")])
length(data$Secchi[which(is.na(data$Secchi)==TRUE)])
length(data$Secchi[which(data$Secchi=="nd")])
#filter out null and "nd" observations
24263-(3548)#number remaining after filtering out null
data=data[which(is.na(data$Secchi)==FALSE),]
#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID=data$WB.Code
unique(data.Export$LakeID)
length(data.Export$LakeID[which(data.Export$LakeID=="")])
#export lake name
data.Export$LakeName = data$Site
#continue with other variables
data.Export$SourceVariableName = "Secchi"
data.Export$SourceVariableDescription = "Secchi, no view"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags= NA 
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 30
data.Export$LagosVariableName="Secchi"
#export values 
typeof(data$Secchi)
data.Export$Value = data$Secchi
unique(data.Export$Value)

#continue exporting
data.Export$CensorCode = "NC" #no info on CensorCode
data.Export$Date = data$Date #date already in correct format
data.Export$Units="m"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")])
#SAMPLE position
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="SPECIFIED"
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth=NA
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])#check to make sure all NA
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY"
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) #check to make sure CORRECT NUMBER populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #specified in meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
unique(data.Export$Comments)
secchi.Final = data.Export
rm(data.Export)
rm(data)

###################################### final export ########################################################################################
Final.Export = rbind(chla.Final,nh4.Final,no3.Final,tn.Final,tp.Final,secchi.Final)
#######################################################################################################################
nosamplepos=Final.Export[which(is.na(Final.Export$SampleDepth)==TRUE & Final.Export$SamplePosition=="UNKNOWN"),]
##Duplicates check ##############################################################################################
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
8+45405#adds up to total
##write table
Final.Export1=data1
typeof(Final.Export1$Value)
length(Final.Export1$Value[which(Final.Export1$Value<0)])
write.table(Final.Export1,file="DataImport_RI_URIWW_CHEM.csv",row.names=FALSE,sep=",")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/RI data/DataImport_RI_URIWW_CHEM/DataImport_RI_URIWW_CHEM.RData")