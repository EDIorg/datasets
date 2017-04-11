#path to files
setwd("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MN data/USGS_SHAEP_longterm/DataImport_MN_SHINGOBEE_SECCHI")


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
#data collected under usgs shaep program
#only secchi disk observations, at least one per month 
###########################################################################################################################################################################################
###################################   Secchi depth (m)        #############################################################################################################################
data=shingobee_secchi
#look at secchi obs. for problematic values
unique(data$Secchi.depth..m.)
#filter out null values
length(data$Secchi.depth..m.[which(is.na(data$Secchi.depth..m.)==TRUE)])
length(data$Secchi.depth..m.[which(data$Secchi.depth..m.=="")])
322-4#318 obs remain after filtering out those 4 null obs.
data=data[which(is.na(data$Secchi.depth..m.)==FALSE),]

#done filtering 

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = 29004300 #this is the MN DOWID, the unique lake id assinged by the dnr
data.Export$LakeName = "SHINGOBEE"
data.Export$SourceVariableName = "Secchi depth (m)"
data.Export$SourceVariableDescription = "Secchi disk depth"
data.Export$SourceFlags = NA #set source flags, none associated with this data set
data.Export$LagosVariableID = 30
data.Export$LagosVariableName="Secchi"
data.Export$Value = data$Secchi.depth..m. #export secchi values, already in preferred units of m
unique(data.Export$Value)#look at exported values
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode="NC" 
unique(data.Export$CensorCode)
data.Export$Date = data$Date #date already in correct format
data.Export$Units="m"
#populate sampletype and sample position
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED"
#populate SamplePosition
data.Export$SamplePosition="SPECIFIED"
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth=NA
#continue populating other lagos fields
data.Export$BasinType="UNKNOWN" #not specified in data
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable to SECCHI
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA 
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #per metadata
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
data.Export$Subprogram= "USGS SHAEP" 
Secchi.Final = data.Export
rm(data)
rm(data.Export)
Final.Export =Secchi.Final

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
0+318#adds up to total
##write table
Final.Export1=data1
typeof(Final.Export1$Value)
length(Final.Export1$Value[which(Final.Export1$Value<0)])
nosamplepos=Final.Export1[which(is.na(Final.Export1$SampleDepth)==TRUE & Final.Export1$SamplePosition=="UNKNOWN"),]
write.table(Final.Export1,file="DataImport_MN_SHINGOBEE_SECCHI.csv",row.names=FALSE,sep=",")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MN data/USGS_SHAEP_longterm/DataImport_MN_SHINGOBEE_SECCHI/DataImport_MN_SHINGOBEE_SECCHI.RData")
