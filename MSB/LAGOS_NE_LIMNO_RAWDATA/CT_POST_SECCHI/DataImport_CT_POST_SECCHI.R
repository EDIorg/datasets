#set wd
setwd("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/CT data/CT_POST_CHEM/DataImport_CT_POST_SECCHI")



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
#13 lakes in total, extra lakes sampled in 2005,2006
#see import log for other info
###############################################################################################################################################
################################### Secchi..m.     #############################################################################################################################
data=ct_post_secchi
names(data)
unique(data$Lake)
unique(data$Secchi..m.)
length(data$Secchi..m.[which(data$Secchi..m.=="na")])#filter these out= null
length(data$Secchi..m.[which(data$Secchi..m.=="")])
472-5 # 467 should remain
data=data[which(data$Secchi..m.!="na"),]
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
data.Export$SourceVariableName = "Secchi (m)"
data.Export$SourceVariableDescription = "Secchi"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags= NA #no remark codes
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 30
data.Export$LagosVariableName="Secchi"
#export values
typeof(data$Secchi..m.)
unique(data$Secchi..m.)
data$Secchi..m.=as.character(data$Secchi..m.)
unique(data$Secchi..m.)
data.Export$Value=as.character(data.Export$Value)
data.Export$Value = data$Secchi..m.
unique(data.Export$Value)
data.Export$Value=as.numeric(data.Export$Value)
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
data.Export$Comments= NA 
secchi.Final = data.Export
rm(data.Export)
rm(data)

###################################### final export ########################################################################################
Final.Export = secchi.Final
#######################################################################################################################
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
0+467#adds up to total
##write table
Final.Export1=data1
typeof(Final.Export1$Value)
length(Final.Export1$Value[which(Final.Export1$Value<0)])
unique(Final.Export1$Value)
write.table(Final.Export1,file="DataImport_CT_POST_SECCHI.csv",row.names=FALSE,sep=",")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/CT data/CT_POST_CHEM/DataImport_CT_POST_SECCHI/CT_POST_SECCHI.RData")

