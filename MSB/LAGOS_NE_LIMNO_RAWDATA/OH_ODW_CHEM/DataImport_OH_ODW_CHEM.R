#set wd
setwd("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/OH Data/DataImport_OH_ODW_CHEM")

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
#data collected by the oh dnr from 153 reservoirs during 2006-2007.
#samples collected from epi at specified depth if no depth then collected at 2 meters
#column specifying whether sample collected at inflow, middle, or outflow of reservoir--> populate in comments field
#no source flags or censor code info.
###############################################################################################################################################
###################################  Chla(ug/L)    #############################################################################################################################
data=oh_odw_chem
names(data)
#check for null values and filter them out
length(data$Chla.ug.L.[which(is.na(data$Chla.ug.L.)==TRUE)])
length(data$Chla.ug.L.[which(data$Chla.ug.L.=="")])
#filter out nulls
486-15#number remaining
data=data[which(is.na(data$Chla.ug.L.)==FALSE),]
length(data$Location[which(is.na(data$Location)==TRUE)])
length(data$Location[which(data$Location=="")])
#no missing lake ids=good
unique(data$SampSite)#populate comments field using info in this field.

#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID=data$Location
unique(data.Export$LakeID)
length(data.Export$LakeID[which(data.Export$LakeID=="")])
#export lake name
data.Export$LakeName = data$lake_name
#continue with other variables
data.Export$SourceVariableName = "Chla(ug/L)"
data.Export$SourceVariableDescription = "Chlorophyll a"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags= NA 
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 9
data.Export$LagosVariableName="Chlorophyll a"
#export values
typeof(data$Chla.ug.L.)
data.Export$Value = data$Chla.ug.L.
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
length(data$Integrated_Depth.m.[which(is.na(data$Integrated_Depth.m.)==TRUE)])
#there are 10 obs null for depth
length(data$Integrated_Depth.m.[which(data$Integrated_Depth.m.=="")])
data.Export$SampleDepth=data$Integrated_Depth.m.
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])#check to see if correct number of NA values
unique(data.Export$SampleDepth)
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
data.Export$LabMethodInfo="Water samples were filtered through Pall A/E glad fiber filters (1,0 um pore size) and frozen for lab analysis. Followed analyitical procedures outlined in Knoll et al. 2003.  determined fluorometrically after extraction with acetone without grinding; 'Chl was extracted from the filters in the dark at 4o C using acetone and measured on a Turner model TD-700 fluorometer"
data.Export$DetectionLimit= NA #not specified
data.Export$Comments=as.character(data.Export$Comments)
unique(data$SampSite)
data.Export$Comments[which(data$SampSite=="OUTFL")]= "Sample collected at the outflow of the reservoir"
data.Export$Comments[which(data$SampSite=="INFLO")]= "Sample collected at the inflow of the reservoir"
unique(data.Export$Comments)
chla.Final = data.Export
rm(data.Export)
rm(data)

###################################   TN(ug/L)   #############################################################################################################################
data=oh_odw_chem
names(data)
#check for null values and filter them out
length(data$TN.ug.L.[which(is.na(data$TN.ug.L.)==TRUE)])
length(data$TN.ug.L.[which(data$TN.ug.L.=="")])
#filter out nulls
486-16#number remaining
data=data[which(is.na(data$TN.ug.L.)==FALSE),]
length(data$Location[which(is.na(data$Location)==TRUE)])
length(data$Location[which(data$Location=="")])
#no missing lake ids=good
unique(data$SampSite)#populate comments field using info in this field.

#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID=data$Location
unique(data.Export$LakeID)
length(data.Export$LakeID[which(data.Export$LakeID=="")])
#export lake name
data.Export$LakeName = data$lake_name
#continue with other variables
data.Export$SourceVariableName = "TN(ug/L)"
data.Export$SourceVariableDescription = "Total nitrogen"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags= NA 
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 21
data.Export$LagosVariableName="Nitrogen, total"
#export values
typeof(data$TN.ug.L.)
data.Export$Value = data$TN.ug.L.
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
length(data$Integrated_Depth.m.[which(is.na(data$Integrated_Depth.m.)==TRUE)])
#there are 11 obs null for depth
length(data$Integrated_Depth.m.[which(data$Integrated_Depth.m.=="")])
data.Export$SampleDepth=data$Integrated_Depth.m.
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])#check to see if correct number of NA values
unique(data.Export$SampleDepth)
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
data.Export$LabMethodInfo="Water samples were acidfied and stored at 4 degC. Followed analyitical procedures outlined in Knoll et al. 2003. samples digested with persulfate; 'TN was converted to dissolved nitrogen via low-N potassium persulfate digestion, acidified, and analyzed using second-derivative spectroscopy on a Perkin Elmer Lambda 35 UV/VIS spectrophotometer (Crumpton et al. 1992)"
data.Export$DetectionLimit= NA #not specified
data.Export$Comments=as.character(data.Export$Comments)
unique(data$SampSite)
data.Export$Comments[which(data$SampSite=="OUTFL")]= "Sample collected at the outflow of the reservoir"
data.Export$Comments[which(data$SampSite=="INFLO")]= "Sample collected at the inflow of the reservoir"
unique(data.Export$Comments)
tn.Final = data.Export
rm(data.Export)
rm(data)

################################### TP(ug/L)    #############################################################################################################################
data=oh_odw_chem
names(data)
#check for null values and filter them out
length(data$TP.ug.L.[which(is.na(data$TP.ug.L.)==TRUE)])
length(data$TP.ug.L.[which(data$TP.ug.L.=="")])
#filter out nulls
486-7#number remaining
data=data[which(is.na(data$TP.ug.L.)==FALSE),]
length(data$Location[which(is.na(data$Location)==TRUE)])
length(data$Location[which(data$Location=="")])
#no missing lake ids=good
unique(data$SampSite)#populate comments field using info in this field.

#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID=data$Location
unique(data.Export$LakeID)
length(data.Export$LakeID[which(data.Export$LakeID=="")])
#export lake name
data.Export$LakeName = data$lake_name
#continue with other variables
data.Export$SourceVariableName = "TP(ug/L)"
data.Export$SourceVariableDescription = "Total phosphorus"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags= NA 
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 27
data.Export$LagosVariableName="Phosphorus, total"
#export values
typeof(data$TP.ug.L.)
data.Export$Value = data$TP.ug.L.
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
length(data$Integrated_Depth.m.[which(is.na(data$Integrated_Depth.m.)==TRUE)])
#there are 14 obs null for depth
length(data$Integrated_Depth.m.[which(data$Integrated_Depth.m.=="")])
data.Export$SampleDepth=data$Integrated_Depth.m.
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])#check to see if correct number of NA values
unique(data.Export$SampleDepth)
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
data.Export$LabMethodInfo="Water samples were acidfied and stored at 4 degC. Followed analyitical procedures outlined in Knoll et al. 2003.  samples digested with persulfate; 'TP was converted to soluble reactive phosphorus via potassium persulfate digestion, acidified and analyzed using the molybdenum blue technique method on a Lachat FIA+ QuikChem 8000 series autoanalyzer"
data.Export$DetectionLimit= NA #not specified
data.Export$Comments=as.character(data.Export$Comments)
unique(data$SampSite)
data.Export$Comments[which(data$SampSite=="OUTFL")]= "Sample collected at the outflow of the reservoir"
data.Export$Comments[which(data$SampSite=="INFLO")]= "Sample collected at the inflow of the reservoir"
unique(data.Export$Comments)
tp.Final = data.Export
rm(data.Export)
rm(data)

################################### SD(cm)   #############################################################################################################################
data=oh_odw_chem
names(data)
#check for null values and filter them out
length(data$SD.cm.[which(is.na(data$SD.cm.)==TRUE)])
length(data$SD.cm.[which(data$SD.cm.=="")])
#filter out nulls
486-1#number remaining
data=data[which(is.na(data$SD.cm.)==FALSE),]
length(data$Location[which(is.na(data$Location)==TRUE)])
length(data$Location[which(data$Location=="")])
#no missing lake ids=good
unique(data$SampSite)#populate comments field using info in this field.

#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID=data$Location
unique(data.Export$LakeID)
length(data.Export$LakeID[which(data.Export$LakeID=="")])
#export lake name
data.Export$LakeName = data$lake_name
#continue with other variables
data.Export$SourceVariableName = "SD(cm)"
data.Export$SourceVariableDescription = "Secchi transparency"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags= NA 
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 30
data.Export$LagosVariableName="Secchi"
#export values
typeof(data$SD.cm.)
data.Export$Value = data$SD.cm./100 #export values but divide by 100 to convert from cm to m
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
data.Export$SampleDepth=NA #not applicable to secchi
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")]) #check to make sure CORRECT NUMBER populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = "SECCHI_VIEW_UNKNOWN"
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #not specified
data.Export$Comments=as.character(data.Export$Comments)
unique(data$SampSite)
data.Export$Comments[which(data$SampSite=="OUTFL")]= "Observation made at the outflow of the reservoir"
data.Export$Comments[which(data$SampSite=="INFLO")]= "Observation made at the inflow of the reservoir"
data.Export$Comments[which(data$SampSite=="MIDLK")]= "Observation made at the middle of the reservoir"
unique(data.Export$Comments)
secchi.Final = data.Export
rm(data.Export)
rm(data)

###################################### final export ########################################################################################
Final.Export = rbind(chla.Final,tn.Final,tp.Final,secchi.Final)
################################################################################################################################################
nosamplepos=Final.Export[which(is.na(Final.Export$SampleDepth)==TRUE & Final.Export$SamplePosition=="UNKNOWN"),]
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
0+1905#adds up to total
##write table
Final.Export1=data1
typeof(Final.Export1$Value)
length(Final.Export1$Value[which(Final.Export1$Value<0)])
write.table(Final.Export1,file="DataImport_OH_ODW_CHEM.csv",row.names=FALSE,sep=",")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/OH Data/DataImport_OH_ODW_CHEM/DataImport_OH_ODW_CHEM.RData")