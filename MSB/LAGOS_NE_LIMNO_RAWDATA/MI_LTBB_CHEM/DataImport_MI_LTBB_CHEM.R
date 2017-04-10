#set path to files
setwd("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MI data/LTBB tribe data (finished)/DataImport_MI_LTBB_CHEM")
setwd("C:/Users/Sam/Dropbox/CSI-LIMNO_DATA/DATA-lake/MI data/LTBB tribe data (finished)/DataImport_MI_LTBB_CHEM")
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
#wq monitoring data collected by the little traverse bay bands of odawa indians
#all samples grab, and sample position is specified
#no data flags or censor code
#10 lakes sampled (ongoing), basin type not known
###########################################################################################################################################################################################
################################### Chlorophyll a #############################################################################################################################
data=mi_ltbb_chem
names(data)
unique(data$Chlorophyll.a) #check for problematic values
#check for null values
length(data$Chlorophyll.a[which(is.na(data$Chlorophyll.a)==TRUE)])
length(data$Chlorophyll.a[which(data$Chlorophyll.a=="")])
1964-1484 #480 remain after filtering out null
data=data[which(is.na(data$Chlorophyll.a)==FALSE),]
#check for null sample depths, required! sample position=specified
unique(data$Dep100)
length(data$Dep100[which(is.na(data$Dep100)==TRUE)])
length(data$Dep100[which(data$Dep100=="")])
#filter out 1 w/o depth
data=data[which(is.na(data$Dep100)==FALSE),]

#proceed to populating LAGOS template

#done filtering

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$Station.ID
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$Lake..Name
data.Export$SourceVariableName = "Chlorophyll a"
data.Export$SourceVariableDescription = "Chlorophyll a"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no flags w/ these data
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 9
data.Export$LagosVariableName="Chlorophyll a"
names(data)
data.Export$Value = data$Chlorophyll.a #export observations already in prefferred units
unique(data.Export$Value)
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$Date#date already in correct format
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
data.Export$SampleDepth= data$Dep100
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "SM_10200H" #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
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

################################### Total Nitrogen    #############################################################################################################################
data=mi_ltbb_chem
names(data)
unique(data$Total.Nitrogen) #check for problematic values
#check for null values
length(data$Total.Nitrogen[which(is.na(data$Total.Nitrogen)==TRUE)])
length(data$Total.Nitrogen[which(data$Total.Nitrogen=="")])
1964-780 #1184 remain after filtering out null
data=data[which(is.na(data$Total.Nitrogen)==FALSE),]
#check for null sample depths, required! sample position=specified
unique(data$Dep100)
length(data$Dep100[which(is.na(data$Dep100)==TRUE)])
length(data$Dep100[which(data$Dep100=="")])
#filter out 3 observations w/o depth
data=data[which(is.na(data$Dep100)==FALSE),]

#proceed to populating LAGOS template

#done filtering

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$Station.ID
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$Lake..Name
data.Export$SourceVariableName = "Total Nitrogen"
data.Export$SourceVariableDescription = "Total nitrogen"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no flags w/ these data
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 21
data.Export$LagosVariableName="Nitrogen, total"
names(data)
data.Export$Value = data$Total.Nitrogen*1000 #export observations already in prefferred units
unique(data.Export$Value)
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$Date#date already in correct format
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
data.Export$SampleDepth= data$Dep100
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "SM_4500NorgB" #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
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

################################### Total phosphorus    #############################################################################################################################
data=mi_ltbb_chem
names(data)
unique(data$Total.Phosphorus) #check for problematic values
#check for null values
length(data$Total.Phosphorus[which(is.na(data$Total.Phosphorus)==TRUE)])
length(data$Total.Phosphorus[which(data$Total.Phosphorus=="")])
1964-798 #1166 remain after filtering out null
data=data[which(is.na(data$Total.Phosphorus)==FALSE),]
#check for null sample depths, required! sample position=specified
unique(data$Dep100)
length(data$Dep100[which(is.na(data$Dep100)==TRUE)])
length(data$Dep100[which(data$Dep100=="")])
#filter out 3 observations w/o depth
data=data[which(is.na(data$Dep100)==FALSE),]
#proceed to populating LAGOS template

#done filtering

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$Station.ID
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$Lake..Name
data.Export$SourceVariableName = "Total Phosphorus"
data.Export$SourceVariableDescription = "Total phosphorus"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no flags w/ these data
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 27
data.Export$LagosVariableName="Phosphorus, total"
names(data)
data.Export$Value = data$Total.Phosphorus #export observations and convert to preff units
unique(data.Export$Value)
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$Date#date already in correct format
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
data.Export$SampleDepth= data$Dep100
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "SM_4500P" #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="Method 4500-P"
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


###Final.Export##########
Final.Export=rbind(chla.Final,tn.Final,tp.Final)

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
2824+0#adds up to total
##write table
Final.Export1=data1
typeof(Final.Export1$Value)
length(Final.Export1$Value[which(Final.Export1$Value<0)])
nosamplepos=Final.Export1[which(is.na(Final.Export1$SampleDepth)==TRUE & Final.Export1$SamplePosition=="UNKNOWN"),]
write.table(Final.Export1,file="DataImport_MI_LTBB_CHEM.csv",row.names=FALSE,sep=",")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MI data/LTBB tribe data (finished)/DataImport_MI_LTBB_CHEM/DataImport_MI_LTBB_CHEM.RData")
