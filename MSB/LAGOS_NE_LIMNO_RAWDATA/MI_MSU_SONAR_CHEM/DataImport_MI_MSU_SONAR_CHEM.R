#path to files
setwd("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MI data/Sonar lakes (finished)/DataImport_MI_MSU_SONAR_CHEM")

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
#data from a study looking at the effects of herbicide on macrophytes 
#1998-2000, sample type= integrated, sample pos= epi, basin type=primary
###########################################################################################################################################################################################
################################### CHLA_UG   #############################################################################################################################
data=msu_sonar_chem
names(data)
#check for null values
unique(data$CHLA_UG)#check values for problems
length(data$CHLA_UG[which(is.na(data$CHLA_UG)==TRUE)])
length(data$CHLA_UG[which(data$CHLA_UG=="")])
#no null values
#check for null depths
unique(data$Epi_Depth)
length(data$Epi_Depth[which(data$Epi_Depth=="")])
#no null depths
#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = NA
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$Lake
data.Export$SourceVariableName = "CHLA_UG"
data.Export$SourceVariableDescription = "Chlorophyll a corrected for phaeophytin"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID =9
data.Export$LagosVariableName="Chlorophyll a"
data.Export$Value=data$CHLA_UG #export values, already in preferred units
unique(data.Export$Value)#look at exported values
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode="NC" #no censored obs.
unique(data.Export$CensorCode)
#continue exporting other info
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth=data$Epi_Depth 
unique(data.Export$SampleDepth)
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED"
unique(data.Export$SampleType)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY"
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #per meta
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
unique(data.Export$Comments)
chla.Final = data.Export
rm(data)
rm(data.Export)

################################### TN_ugL  #############################################################################################################################
data=msu_sonar_chem
names(data)
#check for null values
unique(data$TN_ugL)#check values for problems
length(data$TN_ugL[which(is.na(data$TN_ugL)==TRUE)])
length(data$TN_ugL[which(data$TN_ugL=="")])
79-6#number remaining after filtering out null
data=data[which(is.na(data$TN_ugL)==FALSE),]

#check for null depths
unique(data$Epi_Depth)
length(data$Epi_Depth[which(data$Epi_Depth=="")])
#no null depths
#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = NA
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$Lake
data.Export$SourceVariableName = "TN_ugL"
data.Export$SourceVariableDescription = "Total nitrogen"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID =21
data.Export$LagosVariableName="Nitrogen, total"
data.Export$Value=data$TN_ugL #export values, already in preferred units
unique(data.Export$Value)#look at exported values
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode="NC" #no censored obs.
unique(data.Export$CensorCode)
#continue exporting other info
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth=data$Epi_Depth 
unique(data.Export$SampleDepth)
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED"
unique(data.Export$SampleType)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY"
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #per meta
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
unique(data.Export$Comments)
tn.Final = data.Export
rm(data)
rm(data.Export)

################################### TP_ugL  #############################################################################################################################
data=msu_sonar_chem
names(data)
#check for null values
unique(data$TP_ugL)#check values for problems
length(data$TP_ugL[which(is.na(data$TP_ugL)==TRUE)])
length(data$TP_ugL[which(data$TP_ugL=="")])
79-6#number remaining after filtering out null
data=data[which(is.na(data$TP_ugL)==FALSE),]

#check for null depths
unique(data$Epi_Depth)
length(data$Epi_Depth[which(data$Epi_Depth=="")])
#no null depths
#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = NA
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$Lake
data.Export$SourceVariableName = "TP_ugL"
data.Export$SourceVariableDescription = "Total phosphorus"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID =27
data.Export$LagosVariableName="Phosphorus, total"
data.Export$Value=data$TP_ugL #export values, already in preferred units
unique(data.Export$Value)#look at exported values
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode="NC" #no censored obs.
unique(data.Export$CensorCode)
#continue exporting other info
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth=data$Epi_Depth 
unique(data.Export$SampleDepth)
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED"
unique(data.Export$SampleType)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY"
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #per meta
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
unique(data.Export$Comments)
tp.Final = data.Export
rm(data)
rm(data.Export)

################################### SECCHI_m  #############################################################################################################################
data=msu_sonar_chem
names(data)
#check for null values
unique(data$SECCHI_m)#check values for problems
length(data$SECCHI_m[which(is.na(data$SECCHI_m)==TRUE)])
length(data$SECCHI_m[which(data$SECCHI_m=="")])
79-3#number remaining after filtering out null
data=data[which(is.na(data$SECCHI_m)==FALSE),]

#no null depths
#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = NA
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$Lake
data.Export$SourceVariableName = "SECCHI_m"
data.Export$SourceVariableDescription = "Secchi disk depth"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID =30
data.Export$LagosVariableName="Secchi"
data.Export$Value=data$SECCHI_m #export values, already in preferred units
unique(data.Export$Value)#look at exported values
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode="NC" #no censored obs.
unique(data.Export$CensorCode)
#continue exporting other info
data.Export$Date = data$Date #date already in correct format
data.Export$Units="m"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="SPECIFIED"
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth=NA
unique(data.Export$SampleDepth)
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED"
unique(data.Export$SampleType)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY"
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #per meta
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
unique(data.Export$Comments)
secchi.Final = data.Export
rm(data)
rm(data.Export)


###################################### final export ########################################################################################
Final.Export = rbind(chla.Final,secchi.Final,tn.Final,tp.Final)
##########################################################################################################
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
1+300#adds up to total
##write table
Final.Export1=data1
typeof(Final.Export1$Value)
length(Final.Export1$Value[which(Final.Export1$Value<0)])
nosamplepos=Final.Export1[which(is.na(Final.Export1$SampleDepth)==TRUE & Final.Export1$SamplePosition=="UNKNOWN"),]
write.table(Final.Export1,file="DataImport_MI_MSU_SONAR_CHEM.csv",row.names=FALSE,sep=",")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MI data/Sonar lakes (finished)/DataImport_MI_MSU_SONAR_CHEM/DataImport_MI_MSU_SONAR_CHEM.RData")