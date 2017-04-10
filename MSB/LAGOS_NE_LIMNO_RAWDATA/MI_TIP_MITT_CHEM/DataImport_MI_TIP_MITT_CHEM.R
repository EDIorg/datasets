#set path to files
setwd("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MI data/Tip of the Mitt(finished)/DataImport_MI_TIP_MITT_CHEM")
setwd("C:/Users/Sam/Dropbox/CSI-LIMNO_DATA/DATA-lake/MI data/Tip of the Mitt(finished)/DataImport_MI_TIP_MITT_CHEM")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MI data/Tip of the Mitt(finished)/DataImport_MI_TIP_MITT_CHEM/DataImport_MI_TIPP_MITT_CHEM.RData")

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
#missing values specified by blank cells.
#sample type is "grab" except for secchi
#sample position is specified by the "sample type" column in the source data
#detection limits and lab method names not always specified
###########################################################################################################################################################################################
################################### 'Chl a (ug/l)  #############################################################################################################################
data=mi_tipp_mitt_chem
head(data)#look at data
unique(data$Sample.Type)
unique(data$Sample.Depth..meters.)
length(data$Sample.Depth..meters.[which(is.na(data$Sample.Depth..meters.)==TRUE)])
#check for null values
length(data$Chl.a..ug.l.[which(data$Chl.a..ug.l.=="")])
length(data$Chl.a..ug.l.[which(is.na(data$Chl.a..ug.l.)==TRUE)])
#only one chla obs that is not null
data=data[which(is.na(data$Chl.a..ug.l.)==FALSE),]

#done filtering

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$WaterBody
#LakeID not identified yet
data.Export$LakeName = data$WaterBody
data.Export$SourceVariableName = "'Chl a (ug/l)"
data.Export$SourceVariableDescription = "Chlorophyll a"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags associated with these data
#continue populating other lagos variables
data.Export$LagosVariableID = 9
data.Export$LagosVariableName="Chlorophyll a"
names(data)
unique(data$Chl.a..ug.l.)
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode="NC"
names(data)
data$Result.Value=as.character(data$Chl.a..ug.l.)
names(data)
data.Export$Value = data[,17] #export obs already in preffered units
data.Export$Value=as.numeric(data.Export$Value)
unique(data.Export$Value)
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType= "GRAB"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
unique(data$Sample.Type)
data.Export$SamplePosition="SPECIFIED"
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth=data$Sample.Depth..meters.
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"

#continue with other lagos variables
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not specified
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #not specified in meta
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #per metadata
data.Export$Comments=as.character(data.Export$Comments)
a="Sample was collected from the"
data.Export$Comments=paste(a,data$Sample.Type)
unique(data.Export$Comments)
data.Export$Subprogram=NA
chla.Final = data.Export
rm(data)
rm(data.Export)

###################################'Ammonia nitrogen (ug/l)  #############################################################################################################################
data=mi_tipp_mitt_chem
head(data)#look at data
names(data)#look at column names
unique(data$Sample.Type)# set all sample position to NA
temp.df=data[which(data$Sample.Type=="12.13"),] # this must be a typo over write
data$Sample.Type[which(data$Sample.Type==12.13)]=NA
length(data$Sample.Type[which(is.na(data$Sample.Type)==TRUE)])
#check for null values
length(data$Ammonia.nitrogen..ug.l.[which(data$Ammonia.nitrogen..ug.l.=="")])
length(data$Ammonia.nitrogen..ug.l.[which(is.na(data$Ammonia.nitrogen..ug.l.)==TRUE)])
893-830#only 63 obs remain after filtering out null
data=data[which(is.na(data$Ammonia.nitrogen..ug.l.)==FALSE),]

#done filtering

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$WaterBody
#LakeID not identified yet
data.Export$LakeName = data$WaterBody
data.Export$SourceVariableName = "'Ammonia nitrogen (ug/l)"
data.Export$SourceVariableDescription = "Ammonia, nitrogen NH3"
#populate SourceFlags
unique(data$Notes)
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags associated with these data
#continue populating other lagos variables
data.Export$LagosVariableID = 19
data.Export$LagosVariableName="Nitrogen, NH4 "
names(data)
unique(data$Ammonia.nitrogen..ug.l.)
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode="NC"
names(data)
data$Result.Value=as.character(data$Ammonia.nitrogen..ug.l.)
names(data)
data.Export$Value = data[,15] #export obs already in preffered units
data.Export$Value=as.numeric(data.Export$Value)
unique(data.Export$Value)
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType= "GRAB"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)#set bottom=hypo
unique(data$Sample.Type)
data.Export$SamplePosition="SPECIFIED"
#check to make sure correct number of each
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")])
#assign sampledepth 
data.Export$SampleDepth=data$Sample.Depth..meters.
unique(data.Export$SampleDepth)
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])
length(data.Export$SampleDepth[which(data.Export$SampleDepth=="")])
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"

#continue with other lagos variables
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not specified
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #not specified in meta
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #per metadata
data.Export$Comments=as.character(data.Export$Comments)
a="Sample was collected from the"
data.Export$Comments=paste(a,data$Sample.Type)
unique(data.Export$Comments)
data.Export$Subprogram=NA
nh4.Final = data.Export
rm(data)
rm(data.Export)

################################### 'Nitrate-Nitrogen (ug/l)    #############################################################################################################################
data=mi_tipp_mitt_chem
head(data)#look at data
names(data)#look at column names
unique(data$Sample.Type)#Set all sample position to specified
temp.df=data[which(data$Sample.Type=="12.13"),] # this must be a typo over write
data$Sample.Type[which(data$Sample.Type==12.13)]=NA
length(data$Sample.Type[which(is.na(data$Sample.Type)==TRUE)])
length(data$Sample.Depth..meters.[which(is.na(data$Sample.Depth..meters.)==TRUE)])
length(data$Sample.Depth..meters.[which(data$Sample.Depth..meters.=="")])
data=data[which(is.na(data$Sample.Depth..meters.)==FALSE),]#remove one obs null for sample depth
#check for null values
length(data$Nitrate.Nitrogen..ug.l.[which(data$Nitrate.Nitrogen..ug.l.=="")])
length(data$Nitrate.Nitrogen..ug.l.[which(is.na(data$Nitrate.Nitrogen..ug.l.)==TRUE)])
892-108#784 obs remain after filtering out null
data=data[which(data$Nitrate.Nitrogen..ug.l.!=""),]

#done filtering

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$WaterBody
#LakeID not identified yet
data.Export$LakeName = data$WaterBody
data.Export$SourceVariableName = "'Nitrate-Nitrogen (ug/l)"
data.Export$SourceVariableDescription = "Nitrate (NO3)"
#populate SourceFlags
unique(data$Notes)
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags associated with these data
#continue populating other lagos variables
data.Export$LagosVariableID = 18
data.Export$LagosVariableName="Nitrogen, nitrite (NO2) + nitrate (NO3)"
names(data)
unique(data$Nitrate.Nitrogen..ug.l.)#looking for problematic characters etc..
length(data$Nitrate.Nitrogen..ug.l.[which(data$Nitrate.Nitrogen..ug.l.=="<1")])#censor these as "LT"
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$Nitrate.Nitrogen..ug.l.=="<1")]="LT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]="NC"#set the remainder to not censored
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure correct number LT
unique(data.Export$CensorCode)
#overwrite special characters
data$Nitrate.Nitrogen..ug.l.[which(data$Nitrate.Nitrogen..ug.l.=="<1")]=1.0
unique(data$Nitrate.Nitrogen..ug.l.)
names(data)
data.Export$Value = data[,10] #export obs already in preffered units
unique(data.Export$Value)
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType= "GRAB"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)#set bottom=hypo
unique(data$Sample.Type)
data.Export$SamplePosition="SPECIFIED"
#check to make sure correct number of each
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")])
#assign sampledepth 
data.Export$SampleDepth=data$Sample.Depth..meters.
unique(data.Export$SampleDepth)
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])
length(data.Export$SampleDepth[which(data.Export$SampleDepth=="")])

#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"
#continue with other lagos variables
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not specified
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #not specified in meta
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="Auto Analyzer Application Bran+Luebbe Method No. G-172-96 Rev 9"
data.Export$DetectionLimit= 0.5 #per metadata
data.Export$Comments=as.character(data.Export$Comments)
a="Sample was collected from the"
data.Export$Comments=paste(a,data$Sample.Type)
unique(data.Export$Comments)
data.Export$Comments[which(data.Export$Comments=="Sample was collected from the NA")]=NA #overwrite this comment
unique(data.Export$Comments)
data.Export$Subprogram=NA
no3.Final = data.Export
rm(data)
rm(data.Export)

################################### Total Nitrogen (ug/l)   #############################################################################################################################
data=mi_tipp_mitt_chem
head(data)#look at data
names(data)#look at column names
unique(data$Sample.Type)#Set all sample position to specified
temp.df=data[which(data$Sample.Type=="12.13"),] # this must be a typo over write
data$Sample.Type[which(data$Sample.Type==12.13)]=NA
length(data$Sample.Type[which(is.na(data$Sample.Type)==TRUE)])
length(data$Sample.Depth..meters.[which(is.na(data$Sample.Depth..meters.)==TRUE)])
length(data$Sample.Depth..meters.[which(data$Sample.Depth..meters.=="")])
data=data[which(is.na(data$Sample.Depth..meters.)==FALSE),]#remove one obs null for sample depth

#check for null values
length(data$Total.Nitrogen..ug.l.[which(data$Total.Nitrogen..ug.l.=="")])#filter out
length(data$Total.Nitrogen..ug.l.[which(is.na(data$Total.Nitrogen..ug.l.)==TRUE)])
length(data$Total.Nitrogen..ug.l.[which(data$Total.Nitrogen..ug.l.=="No data")])#filter out
892-174-1#717 obs remain after filtering out null
data=data[which(data$Total.Nitrogen..ug.l.!=""),]
data=data[which(data$Total.Nitrogen..ug.l.!="No data"),]
#done filtering

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID =data$WaterBody
#LakeID not identified yet
data.Export$LakeName = data$WaterBody
data.Export$SourceVariableName = "Total Nitrogen (ug/l)"
data.Export$SourceVariableDescription = "Total nitrogen"
#populate SourceFlags
unique(data$Notes)
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags associated with these data
#continue populating other lagos variables
data.Export$LagosVariableID = 21
data.Export$LagosVariableName="Nitrogen, total"
names(data)
unique(data$Total.Nitrogen..ug.l.)#looking for problematic characters etc..
data.Export$CensorCode="NC"#no obs are censored here
names(data)
data.Export$Value = data[,11] #export obs already in preffered units
unique(data.Export$Value)
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType= "GRAB"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)#set bottom=hypo
unique(data$Sample.Type)
data.Export$SamplePosition="SPECIFIED"
#check to make sure correct number of each
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")])
#assign sampledepth 
data.Export$SampleDepth=data$Sample.Depth..meters.
unique(data.Export$SampleDepth)

#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"
#continue with other lagos variables
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not specified
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #not specified in meta
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="APHA protocol"
data.Export$DetectionLimit= NA #per metadata
data.Export$Comments=as.character(data.Export$Comments)
a="Sample was collected from the"
data.Export$Comments=paste(a,data$Sample.Type)
unique(data.Export$Comments)
data.Export$Comments[which(data.Export$Comments=="Sample was collected from the NA")]=NA #overwrite this comment
unique(data.Export$Comments)
data.Export$Subprogram=NA
tn.Final = data.Export
rm(data)
rm(data.Export)


################################### Total Phosphorus (ug/l)   #############################################################################################################################
data=mi_tipp_mitt_chem
head(data)#look at data
names(data)#look at column names
unique(data$Sample.Type)#Set all sample position to specified
temp.df=data[which(data$Sample.Type=="12.13"),] # this must be a typo over write
data$Sample.Type[which(data$Sample.Type==12.13)]=NA
length(data$Sample.Type[which(is.na(data$Sample.Type)==TRUE)])
length(data$Sample.Depth..meters.[which(is.na(data$Sample.Depth..meters.)==TRUE)])
length(data$Sample.Depth..meters.[which(data$Sample.Depth..meters.=="")])
data=data[which(is.na(data$Sample.Depth..meters.)==FALSE),]#remove one obs null for sample depth

#check for null values
unique(data$Total.Phosphorus..ug.l.)#look for problematic observations
length(data$Total.Phosphorus..ug.l.[which(data$Total.Phosphorus..ug.l.=="")])#filter out
length(data$Total.Phosphorus..ug.l.[which(is.na(data$Total.Phosphorus..ug.l.)==TRUE)])
892-31#861 obs remain after filtering out null
data=data[which(is.na(data$Total.Phosphorus..ug.l.)==FALSE),]
#done filtering

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID =data$WaterBody
#LakeID not identified yet
data.Export$LakeName = data$WaterBody
data.Export$SourceVariableName = "Total Phosphorus (ug/l)"
data.Export$SourceVariableDescription = "Total phosphorus"
#populate SourceFlags
unique(data$Notes)
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags associated with these data
#continue populating other lagos variables
data.Export$LagosVariableID = 27
data.Export$LagosVariableName="Phosphorus, total"
names(data)
unique(data$Total.Phosphorus..ug.l.)#looking for problematic characters etc..
#censore observations less than the detection limit as "LT" since they must be estimated anyhow
data.Export$CensorCode=as.character(data.Export$CensorCode)
length(data$Total.Phosphorus..ug.l.[which(data$Total.Phosphorus..ug.l.<=2)])
data.Export$CensorCode[which(data$Total.Phosphorus..ug.l.<=2)]="LT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]="NC"#no obs are censored here
unique(data.Export$CensorCode)
names(data)
data.Export$Value = data[,12] #export obs already in preffered units
unique(data.Export$Value)
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType= "GRAB"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)#set bottom=hypo
unique(data$Sample.Type)
data.Export$SamplePosition="SPECIFIED"
#check to make sure correct number of each
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")])
#assign sampledepth 
data.Export$SampleDepth=data$Sample.Depth..meters.
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"
#continue with other lagos variables
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not specified
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #not specified in meta
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="Auto Analyzer Applications Bran+Luebbe Method NO. G-175-96 Rev 11"
data.Export$DetectionLimit= 2.0 #per metadata
data.Export$Comments=as.character(data.Export$Comments)
a="Sample was collected from the"
data.Export$Comments=paste(a,data$Sample.Type)
unique(data.Export$Comments)
data.Export$Comments[which(data.Export$Comments=="Sample was collected from the NA")]=NA #overwrite this comment
unique(data.Export$Comments)
data.Export$Subprogram=NA
tp.Final = data.Export
rm(data)
rm(data.Export)

################################### 'Secchi depth (feet)  #############################################################################################################################
data=mi_tipp_mitt_chem
head(data)#look at data
unique(data$Sample.Type)
names(data)#look at column names
#check for null values
length(data$Secchi.depth..feet.[which(data$Secchi.depth..feet.=="")])
length(data$Secchi.depth..feet.[which(is.na(data$Secchi.depth..feet.)==TRUE)])
893-746#147 secchi obs. remain after filtering out null
data=data[which(is.na(data$Secchi.depth..feet.)==FALSE),]
unique(data$Sample.Type)#actually ignore sample type since secchi obs. all are "specified"

#done filtering

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$WaterBody
#LakeID not identified yet
data.Export$LakeName = data$WaterBody
data.Export$SourceVariableName = "'Secchi depth (feet)"
data.Export$SourceVariableDescription = "Secchi depth"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags associated with these data
#continue populating other lagos variables
data.Export$LagosVariableID = 30
data.Export$LagosVariableName="Secchi"
names(data)
unique(data$Secchi.depth..feet.)#looking for problematic obs.
unique(data$Notes)
length(data$Notes[which(data$Notes=="Secchi depth = bottom")])#only one obs. censored as "GT"
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$Notes=="Secchi depth = bottom")]="GT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]="NC"
unique(data.Export$CensorCode)
names(data)
data.Export$Value = data[,14]*0.3048 #export obs and convert to preffered units
unique(data.Export$Value)
data.Export$Date = data$Date #date already in correct format
data.Export$Units="m"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType= "INTEGRATED"#because secchi disk observations
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="SPECIFIED"#because secchi disk
#assign sampledepth 
data.Export$SampleDepth=NA #because secchi
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"

#continue with other lagos variables
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not specified
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #not specified in meta
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #per metadata
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments= NA 
data.Export$Subprogram=NA
secchi.Final = data.Export
rm(data)
rm(data.Export)


###################################### final export ########################################################################################
Final.Export = rbind(chla.Final,nh4.Final,no3.Final,tn.Final,tp.Final,secchi.Final)
##################################################################
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
0+2573#adds up to total
##write table
Final.Export1=data1
typeof(Final.Export1$Value)
unique(Final.Export1$Value)
Final.Export1$Value=as.numeric(Final.Export1$Value)
length(Final.Export1$Value[which(Final.Export1$Value<0)])
nosamplepos=Final.Export1[which(is.na(Final.Export1$SampleDepth)==TRUE & Final.Export1$SamplePosition=="UNKNOWN"),]
write.table(Final.Export1,file="DataImport_MI_TIP_MITT_CHEM.csv",row.names=FALSE,sep=",")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MI data/Tip of the Mitt(finished)/DataImport_MI_TIP_MITT_CHEM/DataImport_MI_TIPP_MITT_CHEM.RData")