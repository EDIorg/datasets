#set path to files
setwd("C:/Users/Sam/Dropbox/CSI-LIMNO_DATA/DATA-lake/MI data/MI-DEQ-Color data(finished)/DataImport_MI_DEQ_COLOR")

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
#doc and tp data set collected by the michigan deq during 2006
###########################################################################################################################################################################################
################################### Color #############################################################################################################################
data=mi_deq_color
names(data)
unique(data$WBID)
length(data$WBID[which(data$WBID=="")])
length(data$COLOR[which(data$COLOR=="")])
length(data$COLOR[which(is.na(data$COLOR)==TRUE)])
#FILTER out these 7 observations null for color
data=data[which(is.na(data$COLOR)==FALSE),]
121-7#CORRECT number removed
unique(data$COLOR)#check for strange values
typeof(data$COLOR)
data$COLOR=as.character(data$COLOR)
unique(data$COLOR)
data$COLOR=as.numeric(data$COLOR)
#ready for data import



#proceed to populating LAGOS template

#done filtering

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$WBID
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$WBNAME
data.Export$SourceVariableName = "COLOR"
data.Export$SourceVariableDescription = "True color in platinum cobalt units"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no flags w/ these data
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 12
data.Export$LagosVariableName="Color, true"
names(data)
data.Export$Value = data$COLOR #export observations already in prefferred units
unique(data.Export$Value)
data.Export$CensorCode=as.character(data.Export$CensorCode)
data$qualifier.color=as.character(data$qualifier.color)
data.Export$CensorCode = data$qualifier.color #none censored
unique(data.Export$CensorCode)
data.Export$CensorCode[which(data.Export$CensorCode=="")]="NC"
unique(data.Export$CensorCode)
data.Export$Date = data$DATE#date already in correct format
data.Export$Units="PCU"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"#per metadata
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
#assign sampledepth 
data.Export$SampleDepth= NA
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "SM_3500FeD" #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= 7 #per meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=paste("sample collected by the ",data$agency,sep="")
unique(data.Export$Comments)
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
color.Final = data.Export
rm(data)
rm(data.Export)

################################### TP #############################################################################################################################
data=mi_deq_color
names(data)
unique(data$WBID)
length(data$WBID[which(data$WBID=="")])
length(data$TP[which(data$TP=="")])
length(data$TP[which(is.na(data$TP)==TRUE)])
unique(data$TP)#check for strange values
typeof(data$TP)

#ready for data import



#proceed to populating LAGOS template

#done filtering

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$WBID
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$WBNAME
data.Export$SourceVariableName = "TP"
data.Export$SourceVariableDescription = "total phosphorus in ug/L"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no flags w/ these data
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 27
data.Export$LagosVariableName="Phosphorus, total"
names(data)
data.Export$Value = data$TP #export observations already in prefferred units
unique(data.Export$Value)
data.Export$CensorCode=as.character(data.Export$CensorCode)
data$qualifier.color=as.character(data$qualifier.color)
data.Export$CensorCode="NC"
unique(data.Export$CensorCode)
data.Export$Date = data$DATE#date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"#per metadata
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
#assign sampledepth 
data.Export$SampleDepth= NA
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "SM_4500PE" #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #per meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=paste("sample collected by the ",data$agency,sep="")
unique(data.Export$Comments)
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
TP.Final = data.Export
rm(data)
rm(data.Export)


###Final.Export##########
Final.Export=rbind(TP.Final,color.Final)

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
234+1#adds up to total
##write table
Final.Export1=data1
typeof(Final.Export1$Value)
length(Final.Export1$Value[which(Final.Export1$Value<0)])
nosamplepos=Final.Export1[which(is.na(Final.Export1$SampleDepth)==TRUE & Final.Export1$SamplePosition=="UNKNOWN"),]
write.table(Final.Export1,file="DataImport_MI_DEQ_COLOR.csv",row.names=FALSE,sep=",")
save.image("C:/Users/Sam/Dropbox/CSI-LIMNO_DATA/DATA-lake/MI data/MI-DEQ-Color data(finished)/DataImport_MI_DEQ_COLOR/DataImport_MI_DEQ_COLOR.RData")
