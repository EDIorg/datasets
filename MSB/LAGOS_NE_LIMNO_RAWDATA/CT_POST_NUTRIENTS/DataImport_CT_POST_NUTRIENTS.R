#SET WD
setwd("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/CT data/CT_POST_CHEM/DataImport_CT_POST_NUTRIENTS")

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
#data belongs to david post at yale, mostly for the 6 long term study lakes
#only 6 unique lakes sampled for nutrients
#see import log for other info
###############################################################################################################################################
################################### TP (ug/L)  #############################################################################################################################
data=ct_post_nutrients
names(data)
unique(data$TP..ug.L.)#looking for NA values or problematic values
length(data$TP..ug.L.[which(data$TP..ug.L.=="")])
length(data$TP..ug.L.[which(is.na(data$TP..ug.L.)==TRUE)])
#no null values or problematic observations
unique(data$Lake)
unique(data$Date)

#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID=data$Lake
unique(data.Export$LakeID)
length(data.Export$LakeID[which(data.Export$LakeID=="")])
#export lake name
data.Export$LakeName = data$Lake
#continue with other variables
data.Export$SourceVariableName = "TP (ug/L)"
data.Export$SourceVariableDescription = "Total phosphorus"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags= NA #no remark codes
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 27
data.Export$LagosVariableName="Phosphorus, total"
#export values
typeof(data$TP..ug.L.)
data.Export$Value = data$TP..ug.L.
unique(data.Export$Value)
#continue exporting
data.Export$CensorCode = "NC" #no info on CensorCode
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")])
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
data.Export$Comments=NA
unique(data.Export$Comments)
tp.Final = data.Export
rm(data.Export)
rm(data)

################################### TN (mg/L)  #############################################################################################################################
data=ct_post_nutrients
names(data)
unique(data$TN..mg.L.)#looking for NA values or problematic values
length(data$TN..mg.L.[which(data$TN..mg.L.=="")])
length(data$TN..mg.L.[which(is.na(data$TN..mg.L.)==TRUE)])
length(data$TN..mg.L.[which(data$TN..mg.L.=="na")])
436-12# number remaining after filtering
data=data[which(data$TN..mg.L.!="na"),]
#no null values or problematic observations
unique(data$Lake)
unique(data$Date)

#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID=data$Lake
unique(data.Export$LakeID)
length(data.Export$LakeID[which(data.Export$LakeID=="")])
#export lake name
data.Export$LakeName = data$Lake
#continue with other variables
data.Export$SourceVariableName = "TN (mg/L)"
data.Export$SourceVariableDescription = "Total nitrogen"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags= NA #no remark codes
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 21
data.Export$LagosVariableName="Nitrogen, total"
#export values
typeof(data$TN..mg.L.)
unique(data$TN..mg.L.)
data$TN..mg.L.=as.character(data$TN..mg.L.)
unique(data$TN..mg.L.)
data.Export$Value=as.character(data.Export$Value)
data.Export$Value = data$TN..mg.L.
unique(data.Export$Value)
data.Export$Value=as.numeric(data.Export$Value)
data.Export$Value=data.Export$Value*1000 #convert from mg to ug/L
unique(data.Export$Value)
#continue exporting
data.Export$CensorCode = "NC" #no info on CensorCode
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")])
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
data.Export$Comments=NA
unique(data.Export$Comments)
tn.Final = data.Export
rm(data.Export)
rm(data)

###################################### final export ########################################################################################
Final.Export = rbind(tp.Final,tn.Final)
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
0+860#adds up to total
##write table
Final.Export1=data1
typeof(Final.Export1$Value)
length(Final.Export1$Value[which(Final.Export1$Value<0)])
write.table(Final.Export1,file="DataImport_CT_POST_NUTRIENTS.csv",row.names=FALSE,sep=",")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/CT data/CT_POST_CHEM/DataImport_CT_POST_NUTRIENTS/DataImport_CT_POST_NUTRIENTS.RData")