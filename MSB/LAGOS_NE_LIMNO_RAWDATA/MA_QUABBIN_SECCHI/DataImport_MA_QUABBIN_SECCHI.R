#path to files
setwd("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MA data/MWSA- Reservoirs (Finished)/Quabbin/DataImport_MA_QUABBIN_SECCHI")


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
#data collected from a single reservoir in MA--Quabbin Reservoir
#secchi observations only at a single site on the reservoir--Site 206
###########################################################################################################################################################################################
################################### NO3  #############################################################################################################################
data=quabbin_secchi
names(data)
#check for null and filter out nulls
unique(data$SECCHI.DEPTH)
length(data$SECCHI.DEPTH[which(is.na(data$SECCHI.DEPTH)==TRUE)])
length(data$SECCHI.DEPTH[which(data$SECCHI.DEPTH=="")])
#only 1 null obs. to filter out
data=data[which(is.na(data$SECCHI.DEPTH)==FALSE),]
#done filtering

#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID =206
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = "QUABBIN RESERVOIR"
data.Export$SourceVariableName = "SECCHI DEPTH"
data.Export$SourceVariableDescription = "Secchi"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID =30
data.Export$LagosVariableName="Secchi"
data.Export$Value=data$SECCHI.DEPTH  #export values and convert to preff. units
unique(data.Export$Value)#look at exported values
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode="NC" #no censored obs.
unique(data.Export$CensorCode)
#continue exporting other info
data.Export$Date = data$DATE #date already in correct format
data.Export$Units="m"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="SPECIFIED"
#assign sampledepth 
data.Export$SampleDepth=NA
unique(data.Export$SampleDepth)
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED"
unique(data.Export$SampleType)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="NOT_PRIMARY"
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
unique(data.Export$LabMethodInfo)#look at unique exported values
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
Final.Export=secchi.Final
####################################################################################################
##Duplicates check #an observation is defined as duplicate if it is NOT unique for programid, lagoslakeid, date, sampledepth, sampleposition, lagosvariableid, datavalue
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
0+30#adds up to total
##write table
Final.Export1=data1
typeof(Final.Export1$Value)
length(Final.Export1$Value[which(Final.Export1$Value<0)])
nosamplepos=Final.Export1[which(is.na(Final.Export1$SampleDepth)==TRUE & Final.Export1$SamplePosition=="UNKNOWN"),]
write.table(Final.Export1,file="DataImport_MA_QUABBIN_SECCHI.csv",row.names=FALSE,sep=",")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MA data/MWSA- Reservoirs (Finished)/Quabbin/DataImport_MA_QUABBIN_SECCHI/DataImport_MA_QUABBIN_SECCHI.RData")