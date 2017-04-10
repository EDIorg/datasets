#set path to files
setwd("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MI data/Tip of the Mitt(finished)/DataImport_MI_TIP_MITT_VOLUNTEER")
setwd("C:/Users/Sam/Dropbox/CSI-LIMNO_DATA/DATA-lake/MI data/Tip of the Mitt(finished)/DataImport_MI_TIP_MITT_VOLUNTEER")

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
#these data are from a citizen monitoring program, only secchi and chl-a
#chl-a samples collected w/ integrated sampler- representative of euphotic zone
#sampe type= integrated #sample position=specified #sample depth=NA for secchi & twice secchi disk depth for chla (definition euphotic zone)
#see import log for other comments
###########################################################################################################################################################################################
###################################  Chl-a   #############################################################################################################################
data=mitt_volunteer_all_lakes_data
head(data)#looking at snapshot of data
#set Name= lagos LakeName, set lakeid= lagos LakeID
#pull out columns with chl-a info
data=data[,c(1:2,5:6,8,9)]
unique(data$Comments)#primarily weather comments, exported to lagos comments field
#check for null chl-a obs
length(data$Chl.a[which(is.na(data$Chl.a)==TRUE)])
length(data$Chl.a[which(data$Chl.a=="")])
7459-4111#3348 chla obs. remain after filtering out null
data=data[which(data$Chl.a!=""),]
#check for null sample depths
length(data$chla_sampledepth_ft[which(data$chla_sampledepth_ft=="")])
length(data$chla_sampledepth_ft[which(is.na(data$chla_sampledepth_ft)==TRUE)])
#no null sample depths = good!
unique(data$Chl.a)#checking for problematic obs.
length(data$Chl.a[which(data$Chl.a=="ND **")])
length(data$Chl.a[which(data$Chl.a=="ND")])
#18 ND values should also be removed, 3330 values remain
data=data[which(data$Chl.a!="ND **"),]
data=data[which(data$Chl.a!="ND"),]
unique(data$Chl.a)
#done filtering

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$Name
data.Export$LakeName = data$Name
data.Export$SourceVariableName = "Chl-a"
data.Export$SourceVariableDescription = "Chlorophyll a from the photic zone defined as 2x Secchi depth"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags associated with these data
#continue populating other lagos variables
data.Export$LagosVariableID = 9
data.Export$LagosVariableName="Chlorophyll a"
names(data)
unique(data$Chl.a)
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode="NC"#data not censored
names(data)
typeof(data$Chl.a)
data$Chl.a=as.character(data$Chl.a)
data.Export$Value = data[,3] #export obs already in preferred units
unique(data.Export$Value)
data.Export$Value=as.numeric(data.Export$Value)
unique(data.Export$Value)
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType= "INTEGRATED"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"
unique(data.Export$SamplePosition)
#assign sampledepth AND convert from feet to meters
unique(data$chla_sampledepth_ft)
data.Export$SampleDepth=data$chla_sampledepth_ft*0.3048
data.Export$SampleDepth=round(data.Export$SampleDepth,digits=4)
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN" #meta doesn't specify this for chla

#continue with other lagos variables
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not specified
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #not specified in meta
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #per metadata
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments= data$Comments
data.Export$Subprogram=NA
chla.Final = data.Export
rm(data)
rm(data.Export)

###################################  Secchi (ft)  #############################################################################################################################
data=mitt_volunteer_all_lakes_data
head(data)#looking at snapshot of data
#set Name= lagos LakeName, set lakeid= lagos LakeID
#pull out columns with secchi info
names(data)
data=data[,c(1:4,8,9)]
unique(data$Comments)#primarily weather comments, exported to lagos comments field
#check for null obs
length(data$Secchi..ft.[which(is.na(data$Secchi..ft.)==TRUE)])
length(data$Secchi..ft.[which(data$Secchi..ft.=="")])
7459-140#7319 obs. remain after filtering out null
data=data[which(is.na(data$Secchi..ft.)==FALSE),]
unique(data$Secchi..ft.)#checking for problematic obs., none 

#done filtering

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$Name
data.Export$LakeName = data$Name
data.Export$SourceVariableName = "Secchi (ft)"
data.Export$SourceVariableDescription = "Secchi depth no view scope"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags associated with these data
#continue populating other lagos variables
data.Export$LagosVariableID = 30
data.Export$LagosVariableName="Secchi"
names(data)
unique(data$Secchi..ft.)
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode="NC"#data not censored
names(data)
typeof(data$Secchi..ft.)
data$Secchi..ft.=data$Secchi..ft.*0.3048 #convert to meters
unique(data$Secchi..ft.)
names(data)
data.Export$Value = data[,3] #export obs and convert from ft to meters
unique(data.Export$Value)
data.Export$Value=round(data.Export$Value,digits=4)
unique(data.Export$Value)
data.Export$Date = data$Date #date already in correct format
data.Export$Units="m"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType= "INTEGRATED"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="SPECIFIED"
unique(data.Export$SamplePosition)
#assign sampledepth AND convert from feet to meters
data.Export$SampleDepth=NA #not relevant to secchi
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY" #meta DATA specifies that deep hole is sampled

#continue with other lagos variables
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not specified
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #not specified in meta
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #per metadata
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments= data$Comments
data.Export$Subprogram=NA
secchi.Final = data.Export
rm(data)
rm(data.Export)



###################################### final export ########################################################################################
Final.Export = rbind(chla.Final,secchi.Final)
#########################################################
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
2+10647
#adds up to total
##write table
Final.Export1=data1
typeof(Final.Export1$Value)
length(Final.Export1$Value[which(Final.Export1$Value<0)])
nosamplepos=Final.Export1[which(is.na(Final.Export1$SampleDepth)==TRUE & Final.Export1$SamplePosition=="UNKNOWN"),]
write.table(Final.Export1,file="DataImport_MI_TIP_MITT_VOLUNTEER.csv",row.names=FALSE,sep=",")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MI data/Tip of the Mitt(finished)/DataImport_MI_TIP_MITT_VOLUNTEER/DataImport_MI_TIP_MITT_VOLUNTEER.RData")