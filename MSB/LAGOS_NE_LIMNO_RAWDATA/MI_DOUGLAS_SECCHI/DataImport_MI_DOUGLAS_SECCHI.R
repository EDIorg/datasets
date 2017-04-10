#set path to files
setwd("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MI data/Douglas_Lake_MI-(finished)/DataImport_MI_DOUGLAS_SECCHI")
setwd("C:/Users/Sam/Dropbox/CSI-LIMNO_DATA/DATA-lake/MI data/Douglas_Lake_MI-(finished)/DataImport_MI_DOUGLAS_SECCHI")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MI data/Douglas_Lake_MI-(finished)/DataImport_MI_DOUGLAS_SECCHI/DataImport_MI_DOUGLAS_SECCHI.RData")

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

##################################### GENERAL NOTES ########################################################################################################
#citizen monitoring secchi observations for a single lake in michigan
#data organized by different sup programs
###################################  Secchi (m) #############################################################################################################################
data=mi_douglas_secchi
names(data)#look at column names
head(data)#look at a sample of the data
#check for null values
length(data$Secchi..m.[which(is.na(data$Secchi..m.)==TRUE)])
length(data$Secchi..m.[which(data$Secchi..m.=="")])
#no null values to filter out
length(data$Secchi..ft.[which(data$Secchi..ft.!="")])
#do not import these secchi observations (see import log)
data$Secchi..m.#check data for porblematic values
#data looks OK

#done filtering

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = NA #none specified in source data
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = "DOUGLAS LAKE"
data.Export$SourceVariableName = "Secchi (m)"
data.Export$SourceVariableDescription = "Secchi depth"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA 
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 30
data.Export$LagosVariableName="Secchi"
names(data)
data.Export$Value = data[,2] #export secchi values already in preff. units of m
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
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
data.Export$SampleDepth=NA #NOT APPLICABLE TO SECCHI
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN" #BASIN INFO not specified in meta
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")]) #check to make sure CORRECT NUMBER populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = "SECCHI_AVG_DOWN_UP"
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #not relevant
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #not relevant
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA 
unique(data$Source.)
data.Export$Subprogram=as.character(data.Export$Subprogram)
data.Export$Date=as.character(data.Export$Date)
data.Export$Subprogram[which(data.Export$Date<"1975-12-31")]="Rann project"
data.Export$Subprogram[which(data.Export$Date<="1971-12-31")]=NA
data.Export$Subprogram[which(data.Export$Date>"1986-12-31")]="Tip of the Mitt"
unique(data.Export$Subprogram)
secchi.Final = data.Export
rm(data.Export)
rm(data)

###################################### final export ########################################################################################
Final.Export = rbind(secchi.Final)
###############################
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
0+405#adds up to total
##write table
Final.Export1=data1
typeof(Final.Export1$Value)
length(Final.Export1$Value[which(Final.Export1$Value<0)])
nosamplepos=Final.Export1[which(is.na(Final.Export1$SampleDepth)==TRUE & Final.Export1$SamplePosition=="UNKNOWN"),]
write.table(Final.Export1,file="DataImport_MI_DOUGLAS_SECCHI.csv",row.names=FALSE,sep=",")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MI data/Douglas_Lake_MI-(finished)/DataImport_MI_DOUGLAS_SECCHI/DataImport_MI_DOUGLAS_SECCHI.RData")