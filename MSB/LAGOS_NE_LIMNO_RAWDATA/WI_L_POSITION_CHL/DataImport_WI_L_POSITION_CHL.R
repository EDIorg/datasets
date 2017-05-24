setwd("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/WI data/L_Position (Finished)/DataImport_WI_L_POSITION_CHL")


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
#these data are from the landscape pos. project at NTL from 1998-2000
#lake id = "wbic"
#samples are integrated
#epi, meta, or hypo
#no source flags or cenosred observations
###########################################################################################################################################################################################
###################################  chl   #############################################################################################################################
data=l_position_chlor
head(data)#snapshopt of data
names(data)#looking at column names
#check for replicates and filter out
unique(data$rep)
length(data$rep[which(data$rep=="2")])
length(data$rep[which(data$rep=="3")])
23+2#25 obs. will be filtered out
275-25#250 remain
data=data[which(data$rep==1),]
#check for nulls and filter out
length(data$chl[which(is.na(data$chl)==TRUE)])
length(data$chl[which(data$chl=="")])
#no nulls to filter out
#check for missing sample depths and discard because positin cannot be determined or specified
unique(data$bottom)
length(data$bottom[which(is.na(data$bottom)==TRUE)])

#CHECK for missing wbic codes= required and filter out null
unique(data$wbic)
length(data$wbic[which(is.na(data$wbic)==TRUE)])
data=data[which(is.na(data$wbic)==FALSE),]
#done filtering
#proceed to populating LAGOS template


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$wbic
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$lake
data.Export$SourceVariableName = "chl"
data.Export$SourceVariableDescription = "Total chlorophyll"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 9
data.Export$LagosVariableName="Chlorophyll a"
data.Export$Value=data$chl
unique(data.Export$Value)
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$sampledate#date already in correct format
data.Export$Units="ug/L"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition=data$sample_position
unique(data.Export$SamplePosition)
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="")])
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(data.Export$SamplePosition=="")]="UNKNOWN"
unique(data.Export$SamplePosition)
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure all integrated

#assign sampledepth 
data.Export$SampleDepth=data$bottom
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY"
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="See NT LTER website - http://lter.limnology.wisc.edu/research/protocols"
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #per meta
data.Export$Subprogram=data$project
unique(data.Export$Subprogram)
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data.Export$Subprogram=="LPP")]="LPP= A core landscape position project lake"
data.Export$Comments[which(data.Export$Subprogram=="Ben")]="Ben= One of the lakes sampled as part of Ben Greenfield MS thesis (2000)"
data.Export$Comments[which(data.Export$Subprogram=="LTER")]="LTER= A core LTER lake sampled for biology as part of the landscape positon project"
data.Export$Comments[which(data.Export$Subprogram=="Fish")]="Fish= A landscape position project lake sampled only for fish"
unique(data.Export$Comments)
chl.Final = data.Export
rm(data)
rm(data.Export)

###################################### final export ########################################################################################
Final.Export = chl.Final
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
0+246#adds up to total
##write table
Final.Export1=data1
typeof(Final.Export1$Value)
length(Final.Export1$Value[which(Final.Export1$Value<0)])
negative.df=Final.Export1[which(Final.Export1$Value<0)]
unique(negative.df$SourceVariableName)
unique(negative.df$Value)
246-3#number remaining after filtering out negatives
Final.Export1=Final.Export1[which(Final.Export1$Value>=0),]
length(Final.Export1$Dup[which(Final.Export1$Dup==1)])
nosamplepos=Final.Export1[which(is.na(Final.Export1$SampleDepth)==TRUE & Final.Export1$SamplePosition=="UNKNOWN"),]
write.table(Final.Export1,file="DataImport_WI_L_POSITION_CHL.csv",row.names=FALSE,sep=",")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/WI data/L_Position (Finished)/DataImport_WI_L_POSITION_CHL/DataImport_WI_L_POSITION_CHL.RData")