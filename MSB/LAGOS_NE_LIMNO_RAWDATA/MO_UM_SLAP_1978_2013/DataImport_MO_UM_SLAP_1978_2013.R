#set wd
setwd("C:/Users/Sam/Dropbox/CSI-LIMNO_DATA/DATA-lake/MO data/DataImport_MO_UM_SLAP_1978_2013")

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
#missouri reservoirs
###############################################################################################################################################
#read in source dataframe
mo_slap <- read.csv("C:/Users/Sam/Dropbox/CSI-LIMNO_DATA/DATA-lake/MO data/NEW_data_SLAP/MO Statewide 1978-2013-EDITED.csv", stringsAsFactors=FALSE)


###################################  SECCHI..m.  #############################################################################################################################
data <- mo_slap
colnames(data)

#remove nulls
data <- data[which(is.na(data$SECCHI..m.)==FALSE),]
unique(data$SECCHI..m.)

#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA

#assign lake name and id
data.Export$LakeID=data$MU.
unique(data.Export$LakeID)
length(data.Export$LakeID[which(data.Export$LakeID=="")])
data.Export$LakeName = data$Lake.Name
unique(data.Export$LakeName)
length(data.Export$LakeName[which(data.Export$LakeName=="")])

#continue with other variables
data.Export$SourceVariableName = "SECCHI (m)"
data.Export$SourceVariableDescription = "Secchi Depth"

#populate SourceFlags
data.Export$SourceFlags <- as.character(data.Export$SourceFlags)
data.Export$SourceFlags <-  NA 


#continue populating other lagos variables
data.Export$LagosVariableID = 30
data.Export$LagosVariableName="Secchi"

#export censor code
data.Export$CensorCode <- as.character(data.Export$CensorCode)
data.Export$CensorCode <- 'NC'

#export values
data.Export$Value <- data$SECCHI..m. 
unique(data.Export$Value)

#continue exporting
data.Export$Date <- paste(data$MONTH,data$DAY,data$YEAR,sep='/')
data.Export$Units="m"

#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType<- "INTEGRATED" #per metadata

#assign sampledepth 
data.Export$SampleDepth <- NA

#SAMPLE position
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition <- 'SPECIFIED'

#continue populating other lagos fields
data.Export$BasinType <-as.character(data.Export$BasinType)
data.Export$BasinType <- "UNKNOWN"

#continue with other fields
data.Export$MethodInfo <- as.character(data.Export$MethodInfo)
data.Export$MethodInfo <- NA #not applicable

data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName <- NA

data.Export$LabMethodInfo<-as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo <- NA

data.Export$DetectionLimit <- NA 

data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments <- paste('max depth is',as.character(data$Dam.Ht..m.),sep=' ')

secchi.Final = data.Export
rm(data.Export)
rm(data)

######
################################### Total Nitrogen (mg/L)   #############################################################################################################################
data <- mo_slap
colnames(data)

#remove nulls
data <- data[which(is.na(data$Total.Nitrogen..mg.L.)==FALSE),]
unique(data$Total.Nitrogen..mg.L.)

#no other filtering to be done

###start populating the lagos template
data.Export<- LAGOS_Template
data.Export[1:nrow(data),]<-NA

#assign lake name and id
data.Export$LakeID=data$MU.
unique(data.Export$LakeID)
length(data.Export$LakeID[which(data.Export$LakeID=="")])
data.Export$LakeName = data$Lake.Name
unique(data.Export$LakeName)
length(data.Export$LakeName[which(data.Export$LakeName=="")])

#continue with other variables
data.Export$SourceVariableName = "Total Nitrogen (mg/L)"
data.Export$SourceVariableDescription = "Total Nitrogen"

#populate SourceFlags
data.Export$SourceFlags <- as.character(data.Export$SourceFlags)
data.Export$SourceFlags <-  NA 


#continue populating other lagos variables
data.Export$LagosVariableID = 21
data.Export$LagosVariableName="Nitrogen, total"

#export censor code
data.Export$CensorCode <- as.character(data.Export$CensorCode)
data.Export$CensorCode <- 'NC'

#export values
data.Export$Value <- (data$Total.Nitrogen..mg.L.)*1000
unique(data.Export$Value)

#continue exporting
data.Export$Date <- paste(data$MONTH,data$DAY,data$YEAR,sep='/')
data.Export$Units="ug/L"

#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType<- "GRAB" #per metadata

#assign sampledepth 
data.Export$SampleDepth <- NA

#SAMPLE position
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition <- 'EPI'

#continue populating other lagos fields
data.Export$BasinType <-as.character(data.Export$BasinType)
data.Export$BasinType <- "UNKNOWN"

#continue with other fields
data.Export$MethodInfo <- as.character(data.Export$MethodInfo)
data.Export$MethodInfo <- NA #not applicable

data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName <- NA

data.Export$LabMethodInfo<-as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo <- 'Crumpton et al.'

data.Export$DetectionLimit <- 2

data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments <- paste('max depth is',as.character(data$Dam.Ht..m.),sep=' ')

tn.Final <- data.Export

##########
################################### Total Phosphorus (ug/L)   #############################################################################################################################
data <- mo_slap
colnames(data)

#remove nulls
data <- data[which(is.na(data$Total.Phosphorus..ug.L.)==FALSE),]
unique(data$Total.Phosphorus..ug.L.)

#no other filtering to be done

###start populating the lagos template
data.Export<- LAGOS_Template
data.Export[1:nrow(data),]<-NA

#assign lake name and id
data.Export$LakeID=data$MU.
unique(data.Export$LakeID)
length(data.Export$LakeID[which(data.Export$LakeID=="")])
data.Export$LakeName = data$Lake.Name
unique(data.Export$LakeName)
length(data.Export$LakeName[which(data.Export$LakeName=="")])

#continue with other variables
data.Export$SourceVariableName = "Total Phosphorus (ug/L)"
data.Export$SourceVariableDescription = "Total Phosphorus"

#populate SourceFlags
data.Export$SourceFlags <- as.character(data.Export$SourceFlags)
data.Export$SourceFlags <-  NA 


#continue populating other lagos variables
data.Export$LagosVariableID = 27
data.Export$LagosVariableName="Phosphorus, total"

#export censor code
data.Export$CensorCode <- as.character(data.Export$CensorCode)
data.Export$CensorCode <- 'NC'

#export values
data.Export$Value <- data$Total.Phosphorus..ug.L.
unique(data.Export$Value)

#continue exporting
data.Export$Date <- paste(data$MONTH,data$DAY,data$YEAR,sep='/')
data.Export$Units="ug/L"

#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType<- "GRAB" #per metadata

#assign sampledepth 
data.Export$SampleDepth <- NA

#SAMPLE position
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition <- 'EPI'

#continue populating other lagos fields
data.Export$BasinType <-as.character(data.Export$BasinType)
data.Export$BasinType <- "UNKNOWN"

#continue with other fields
data.Export$MethodInfo <- as.character(data.Export$MethodInfo)
data.Export$MethodInfo <- NA #not applicable

data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName <- "APHA_4500-PE"

data.Export$LabMethodInfo<-as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo <- NA

data.Export$DetectionLimit <- .02*1000

data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments <- paste('max depth is',as.character(data$Dam.Ht..m.),sep=' ')

tp.Final <- data.Export

##########
################################### Total Chlorophyll (ug/L)   #############################################################################################################################
data <- mo_slap
colnames(data)

#remove nulls
data <- data[which(is.na(data$Total.Chlorophyll..ug.L.)==FALSE),]
unique(data$Total.Chlorophyll..ug.L.)

#no other filtering to be done

###start populating the lagos template
data.Export<- LAGOS_Template
data.Export[1:nrow(data),]<-NA

#assign lake name and id
data.Export$LakeID=data$MU.
unique(data.Export$LakeID)
length(data.Export$LakeID[which(data.Export$LakeID=="")])
data.Export$LakeName = data$Lake.Name
unique(data.Export$LakeName)
length(data.Export$LakeName[which(data.Export$LakeName=="")])

#continue with other variables
data.Export$SourceVariableName = "Total Chlorophyll (ug/L)"
data.Export$SourceVariableDescription = "Total Chlorophyll"

#populate SourceFlags
data.Export$SourceFlags <- as.character(data.Export$SourceFlags)
data.Export$SourceFlags <-  NA 


#continue populating other lagos variables
data.Export$LagosVariableID <- 9
data.Export$LagosVariableName <- "Chlorophyll a"

#export censor code
data.Export$CensorCode <- as.character(data.Export$CensorCode)
data.Export$CensorCode <- 'NC'

#export values
data.Export$Value <- data$Total.Chlorophyll..ug.L.
unique(data.Export$Value)

#continue exporting
data.Export$Date <- paste(data$MONTH,data$DAY,data$YEAR,sep='/')
data.Export$Units="ug/L"

#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType<- "GRAB" #per metadata

#assign sampledepth 
data.Export$SampleDepth <- NA

#SAMPLE position
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition <- 'EPI'

#continue populating other lagos fields
data.Export$BasinType <-as.character(data.Export$BasinType)
data.Export$BasinType <- "UNKNOWN"

#continue with other fields
data.Export$MethodInfo <- as.character(data.Export$MethodInfo)
data.Export$MethodInfo <- NA #not applicable

data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName <- NA

data.Export$LabMethodInfo<-as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo <- "Sartory and Grobbelar, and Knowlton"

data.Export$DetectionLimit <- 1

data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments <- paste('max depth is',as.character(data$Dam.Ht..m.),sep=' ')

chla.Final <- data.Export

###################################### final export ########################################################################################
Final.Export = rbind(secchi.Final,tn.Final,tp.Final,chla.Final)
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
0+32175#adds up to total
##write table
Final.Export1 <- data1
typeof(Final.Export1$Value)
length(Final.Export1$Value[which(Final.Export1$Value<0)])
write.table(Final.Export1,file="DataImport_MO_UM_SLAP_1978_2013.csv",row.names=FALSE,sep=",")

save.image("C:/Users/Sam/Dropbox/CSI-LIMNO_DATA/DATA-lake/MO data/DataImport_MO_UM_SLAP_1978_2013/DataImport_MO_UM_SLAP_1978_2013.RData")