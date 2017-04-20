#set path to files
setwd("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MI data/Platte Lake (finished)/DataImport_MI_TMDL_PLATTE_CHEM")
setwd("C:/Users/Sam/Dropbox/CSI-LIMNO_DATA/DATA-lake/MI data/Platte Lake (finished)/DataImport_MI_TMDL_PLATTE_CHEM")


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
#data from big and little platte lake in michigan, wq monitoring-tmdl compliance
#most samples grab, except for chl-a= integrated (big platte lake only)
#check for missing values-not specified source data
#some depths reported as a range, set to bottom depth (integrated)
#filter out obs with "DNU" = "TRUE"
###########################################################################################################################################################################################
################################### Chl site one #############################################################################################################################
data=platte_lake_data
head(data) #looking at snapshot of data
unique(data$PDesc)#looking at unique parameters, pull out observations of interest
#pull out observations of interest
length(data$PDesc[which(data$PDesc=="Chl")])#1784 observations should remain
data=data[which(data$PDesc=="Chl"),]
#check for null observations
unique(data$Measure)#looking for problematic values
length(data$Measure[which(is.na(data$Measure)==TRUE)])
length(data$Measure[which(data$Measure=="")])
#no null values
#check for do not use observations and filter out
unique(data$DNU)
length(data$DNU[which(data$DNU=="TRUE")])
1784-568 #1216 OBSERVATIONS will remain after filtering out the do not use
568/1784
data=data[which(data$DNU!="TRUE"),]
unique(data$SiteID)
length(data$SiteID[which(data$SiteID=="1")])
#pull out obs with site Id of 1
data=data[which(data$SiteID=="1"),]
#filter out replicate observations
library(data.table)
data1=data.table(data,key=c('SampDate','DepthM'))
unique(data1)
data1=data1[unique(data1[,key(data1),with=FALSE]),mult='first']
1216-489#there were 727 replicate observations that had to be discarded
#look at other unique values in data
unique(data$DepthM)#only four unique sample depths
unique(data$MAbbr) #some samples composite others grab
unique(data$Measure)
rm(data)
#done filtering
#proceed to populating LAGOS template
###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data1),]=NA
data.Export$LakeID = data1$SiteID
data.Export$LakeName = data1$SiteName
data.Export$SourceVariableName = "Chl"
data.Export$SourceVariableDescription = "Chlorophyll a corrected for phaeophytin"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no info on source flags
#continue populating other lagos variables
data.Export$LagosVariableID = 9
data.Export$LagosVariableName="Chlorophyll a"
names(data1)
data.Export$Value = data1$Measure #export observations, already in preferred units
data.Export$CensorCode = NA #no info on censor code
data.Export$Date = data1$SampDate #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
unique(data1$MAbbr) #composite and grab
length(data1$MAbbr[which(data1$MAbbr=="Grab")]) #2 grab
length(data1$MAbbr[which(data1$MAbbr=="Composite")])#422 are composite
data.Export$SampleType[which(data1$MAbbr=="Grab")]="GRAB"
data.Export$SampleType[which(data1$MAbbr=="Composite")]="INTEGRATED"
#check to make sure correct number of each assigned
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")])
422+2#adds to toal
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition= "SPECIFIED"#per metadata
#assign sampledepth 
unique(data1$DepthM)
length(data1$DepthM[which(data1$DepthM=="")]) #check for missing depth values
data.Export$SampleDepth= data1$DepthM
#continue populating other lagos fields
data.Export$BasinType="UNKNOWN"
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable 
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "SM_10200H2"
data.Export$DetectionLimit= NA #per metadata
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments= NA 
data.Export$Subprogram=NA
chla.Final = data.Export
rm(data1)
rm(data.Export)

################################### Chl site 8 #############################################################################################################################
data=platte_lake_data
head(data) #looking at snapshot of data
unique(data$PDesc)#looking at unique parameters, pull out observations of interest
#pull out observations of interest
length(data$PDesc[which(data$PDesc=="Chl")])#1784 observations should remain
data=data[which(data$PDesc=="Chl"),]
#check for null observations
unique(data$Measure)#looking for problematic values
length(data$Measure[which(is.na(data$Measure)==TRUE)])
length(data$Measure[which(data$Measure=="")])
#no null values
#check for do not use observations and filter out
unique(data$DNU)
length(data$DNU[which(data$DNU=="TRUE")])
1784-568 #1216 OBSERVATIONS will remain after filtering out the do not use
568/1784
data=data[which(data$DNU!="TRUE"),]
unique(data$SiteID)
length(data$SiteID[which(data$SiteID=="8")])
#pull out obs with site Id of 8
data=data[which(data$SiteID=="8"),]
#filter out replicate observations
library(data.table)
data1=data.table(data,key=c('SampDate','DepthM'))
unique(data1)
data1=data1[unique(data1[,key(data1),with=FALSE]),mult='first']
#look at other unique values in data
unique(data$DepthM)#only four unique sample depths
unique(data$MAbbr) #some samples composite others grab
unique(data$Measure)
rm(data)
#done filtering
#proceed to populating LAGOS template
###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data1),]=NA
data.Export$LakeID = data1$SiteID
data.Export$LakeName = data1$SiteName
data.Export$SourceVariableName = "Chl"
data.Export$SourceVariableDescription = "Chlorophyll a corrected for phaeophytin"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no info on source flags
#continue populating other lagos variables
data.Export$LagosVariableID = 9
data.Export$LagosVariableName="Chlorophyll a"
names(data1)
data.Export$Value = data1$Measure #export observations, already in preferred units
data.Export$CensorCode = NA #no info on censor code
data.Export$Date = data1$SampDate #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
unique(data1$MAbbr) #composite and grab
length(data1$MAbbr[which(data1$MAbbr=="Grab")]) #65 grab
length(data1$MAbbr[which(data1$MAbbr=="Composite")])#0 are composite
data.Export$SampleType[which(data1$MAbbr=="Grab")]="GRAB"
data.Export$SampleType[which(data1$MAbbr=="Composite")]="INTEGRATED"
#check to make sure correct number of each assigned
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")])
65+0#adds to toal
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition= "SPECIFIED"#per metadata
#assign sampledepth 
unique(data1$DepthM)
length(data1$DepthM[which(data1$DepthM=="")]) #check for missing depth values
data.Export$SampleDepth= data1$DepthM
#continue populating other lagos fields
data.Export$BasinType="UNKNOWN"
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable 
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "SM_10200H2"
data.Export$DetectionLimit= NA #per metadata
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments= NA 
data.Export$Subprogram=NA
chla1.Final = data.Export
rm(data1)
rm(data.Export)

################################### NOx  #############################################################################################################################
data=platte_lake_data
head(data) #looking at snapshot of data
unique(data$PDesc)#looking at unique parameters, pull out observations of interest
#pull out observations of interest
length(data$PDesc[which(data$PDesc=="NOx")])#195 observations should remain
data=data[which(data$PDesc=="NOx"),]
#check for null observations
unique(data$Measure)#looking for problematic values
length(data$Measure[which(is.na(data$Measure)==TRUE)])
length(data$Measure[which(data$Measure=="")])
#no null values
#check for do not use observations and filter out
unique(data$DNU)
length(data$DNU[which(data$DNU=="TRUE")])
195-3 #192 OBSERVATIONS will remain after filtering out the do not use
data=data[which(data$DNU!="TRUE"),]
unique(data$SiteID)
length(data$SiteID[which(data$SiteID=="8")])
#pull out obs with site Id of 8
data=data[which(data$SiteID=="8"),]

#filter out replicate observations
library(data.table)
data1=data.table(data,key=c('SampDate','DepthM'))
unique(data1)
data1=data1[unique(data1[,key(data1),with=FALSE]),mult='first']
192-64#there were 128 replicate observations that had to be discarded
data=data1
rm(data1)
#look at other unique values of data
unique(data$DepthM)#only three unique sample depths
unique(data$MAbbr) #only grab samples
unique(data$Measure)

#done filtering
#proceed to populating LAGOS template
###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$SiteID
data.Export$LakeName = data$SiteName
data.Export$SourceVariableName = "NOx"
data.Export$SourceVariableDescription = "Nitrite + nitrate"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no info on source flags
#continue populating other lagos variables
data.Export$LagosVariableID = 18
data.Export$LagosVariableName="Nitrogen, nitrite (NO2) + nitrate (NO3)"
names(data)
data.Export$Value = data$Measure #export observations, already in preferred units
data.Export$CensorCode = NA #no info on censor code
data.Export$Date = data$SampDate #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
unique(data$MAbbr) #composite and grab
length(data$MAbbr[which(data$MAbbr=="Grab")]) #64 grab
length(data$MAbbr[which(data$MAbbr=="Composite")])#0 are composite
data.Export$SampleType[which(data$MAbbr=="Grab")]="GRAB"
data.Export$SampleType[which(data$MAbbr=="Composite")]="INTEGRATED"
#check to make sure correct number of each assigned
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")])
64+0#adds to toal
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition= "SPECIFIED"#per metadata
#assign sampledepth 
unique(data$DepthM)#all surface samples
length(data$DepthM[which(data$DepthM=="")]) #check for missing depth values
data.Export$SampleDepth= data$DepthM
#continue populating other lagos fields
data.Export$BasinType="UNKNOWN"
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable 
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="SM-4500-NO3-F"
data.Export$DetectionLimit= 1 #per metadata
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments= NA 
data.Export$Subprogram=NA
nox.Final = data.Export
rm(data)
rm(data.Export)

################################### TP- station 1  #############################################################################################################################
data=platte_lake_data
head(data) #looking at snapshot of data
unique(data$PDesc)#looking at unique parameters, pull out observations of interest
#pull out observations of interest
length(data$PDesc[which(data$PDesc=="TP")])#12193 observations should remain
data=data[which(data$PDesc=="TP"),]
#check for null observations
unique(data$Measure)#looking for problematic values
length(data$Measure[which(is.na(data$Measure)==TRUE)])
length(data$Measure[which(data$Measure=="")])
#no null values
#check for do not use observations and filter out
unique(data$DNU)
length(data$DNU[which(data$DNU=="TRUE")])
12193-303 #11890 OBSERVATIONS will remain after filtering out the do not use
data=data[which(data$DNU!="TRUE"),]

unique(data$SiteID)
length(data$SiteID[which(data$SiteID=="1")])
#pull out obs with site Id of 1
data=data[which(data$SiteID=="1"),]

#check for and eliminate replicates by determining which sample dates are duplicate (while the depth is also duplicate)
#filter out replicate observations
library(data.table)
data1=data.table(data,key=c('SampDate','DepthM'))
unique(data1)
data1=data1[unique(data1[,key(data1),with=FALSE]),mult='first']
data=data1
rm(data1)


#look at other unique values of data
unique(data$DepthM)#only three unique sample depths
unique(data$MAbbr) #only grab samples
unique(data$Measure)

#done filtering
#proceed to populating LAGOS template
###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$SiteID
data.Export$LakeName = data$SiteName
data.Export$SourceVariableName = "TP"
data.Export$SourceVariableDescription = "Total phosphorus"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no info on source flags
#continue populating other lagos variables
data.Export$LagosVariableID = 27
data.Export$LagosVariableName="Phosphorus, total"
names(data)
data.Export$Value = data$Measure #export observations, already in preferred units
data.Export$CensorCode = NA #no info on censor code
data.Export$Date = data$SampDate #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
unique(data$MAbbr) #composite and grab
length(data$MAbbr[which(data$MAbbr=="Grab")]) #3938 grab
length(data$MAbbr[which(data$MAbbr=="Composite")])#0 are composite
data.Export$SampleType[which(data$MAbbr=="Grab")]="GRAB"
data.Export$SampleType[which(data$MAbbr=="Composite")]="INTEGRATED"
#check to make sure correct number of each assigned
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")])
3938+0#adds to toal
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition= "SPECIFIED"#per metadata
#assign sampledepth 
unique(data$DepthM)#look at unique depths
length(data$DepthM[which(data$DepthM=="")]) #check for missing depth values
data.Export$SampleDepth= data$DepthM
#continue populating other lagos fields
data.Export$BasinType="UNKNOWN"
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable 
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "SM_4500PE"
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #per metadata
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments= NA 
data.Export$Subprogram=NA
tp.Final = data.Export
rm(data)
rm(data.Export)

################################### TP- station 8  #############################################################################################################################
data=platte_lake_data
head(data) #looking at snapshot of data
unique(data$PDesc)#looking at unique parameters, pull out observations of interest
#pull out observations of interest
length(data$PDesc[which(data$PDesc=="TP")])#12193 observations should remain
data=data[which(data$PDesc=="TP"),]
#check for null observations
unique(data$Measure)#looking for problematic values
length(data$Measure[which(is.na(data$Measure)==TRUE)])
length(data$Measure[which(data$Measure=="")])
#no null values
#check for do not use observations and filter out
unique(data$DNU)
length(data$DNU[which(data$DNU=="TRUE")])
12193-303 #11890 OBSERVATIONS will remain after filtering out the do not use
data=data[which(data$DNU!="TRUE"),]

unique(data$SiteID)
length(data$SiteID[which(data$SiteID=="8")])
#pull out obs with site Id of 8
data=data[which(data$SiteID=="8"),]

#check for and eliminate replicates by determining which sample dates are duplicate (while the depth is also duplicate)
#filter out replicate observations
library(data.table)
data1=data.table(data,key=c('SampDate','DepthM'))
unique(data1)
data1=data1[unique(data1[,key(data1),with=FALSE]),mult='first']
data=data1
rm(data1)


#look at other unique values of data
unique(data$DepthM)#only three unique sample depths
unique(data$MAbbr) #only grab samples
unique(data$Measure)

#done filtering
#proceed to populating LAGOS template
###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$SiteID
data.Export$LakeName = data$SiteName
data.Export$SourceVariableName = "TP"
data.Export$SourceVariableDescription = "Total phosphorus"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no info on source flags
#continue populating other lagos variables
data.Export$LagosVariableID = 27
data.Export$LagosVariableName="Phosphorus, total"
names(data)
data.Export$Value = data$Measure #export observations, already in preferred units
data.Export$CensorCode = NA #no info on censor code
data.Export$Date = data$SampDate #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
unique(data$MAbbr) #composite and grab
length(data$MAbbr[which(data$MAbbr=="Grab")]) #76 grab
length(data$MAbbr[which(data$MAbbr=="Composite")])#0 are composite
data.Export$SampleType[which(data$MAbbr=="Grab")]="GRAB"
data.Export$SampleType[which(data$MAbbr=="Composite")]="INTEGRATED"
#check to make sure correct number of each assigned
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")])
76+0#adds to toal
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition= "SPECIFIED"#per metadata
#assign sampledepth 
unique(data$DepthM)#look at unique depths
length(data$DepthM[which(data$DepthM=="")]) #check for missing depth values
data.Export$SampleDepth= data$DepthM
#continue populating other lagos fields
data.Export$BasinType="UNKNOWN"
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable 
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "SM_4500PE"
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #per metadata
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments= NA 
data.Export$Subprogram=NA
tp1.Final = data.Export
rm(data)
rm(data.Export)

################################### TDP-site 1  #############################################################################################################################
data=platte_lake_data
head(data) #looking at snapshot of data
unique(data$PDesc)#looking at unique parameters, pull out observations of interest
#pull out observations of interest
length(data$PDesc[which(data$PDesc=="TDP")])#213 observations should remain
data=data[which(data$PDesc=="TDP"),]
#check for null observations
unique(data$Measure)#looking for problematic values
length(data$Measure[which(is.na(data$Measure)==TRUE)])
length(data$Measure[which(data$Measure=="")])
#no null values
#check for do not use observations and filter out
unique(data$DNU)
length(data$DNU[which(data$DNU=="TRUE")])
213-6 #207 OBSERVATIONS will remain after filtering out the do not use
data=data[which(data$DNU!="TRUE"),]
unique(data$SiteID)
length(data$SiteID[which(data$SiteID=="1")])
#pull out obs with site Id of 1
data=data[which(data$SiteID=="1"),]

#check for and eliminate replicates by determining which sample dates are duplicate (while the depth is also duplicate)
#filter out replicate observations
library(data.table)
data1=data.table(data,key=c('SampDate','DepthM'))
unique(data1)
data1=data1[unique(data1[,key(data1),with=FALSE]),mult='first']
data=data1
rm(data1)


#look at other unique values of data
unique(data$DepthM)#only two unique sample depths
unique(data$MAbbr) #only grab samples
unique(data$Measure)

#done filtering
#proceed to populating LAGOS template
###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$SiteID
data.Export$LakeName = data$SiteName
data.Export$SourceVariableName = "TDP"
data.Export$SourceVariableDescription = "Total dissolved phosphorus"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no info on source flags
#continue populating other lagos variables
data.Export$LagosVariableID = 28
data.Export$LagosVariableName="Phosphorus, total dissolved"
names(data)
data.Export$Value = data$Measure #export observations, already in preferred units
data.Export$CensorCode = NA #no info on censor code
data.Export$Date = data$SampDate #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
unique(data$MAbbr) #composite and grab
length(data$MAbbr[which(data$MAbbr=="Grab")]) #1 grab
length(data$MAbbr[which(data$MAbbr=="Composite")])#0 are composite
data.Export$SampleType[which(data$MAbbr=="Grab")]="GRAB"
data.Export$SampleType[which(data$MAbbr=="Composite")]="INTEGRATED"
#check to make sure correct number of each assigned
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")])
1+0#adds to toal
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition= "SPECIFIED"#per metadata
#assign sampledepth 
unique(data$DepthM)#look at unique depths
length(data$DepthM[which(data$DepthM=="")]) #check for missing depth values
data.Export$SampleDepth= data$DepthM
#continue populating other lagos fields
data.Export$BasinType="UNKNOWN"
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable 
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "SM_4500PE"
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #per metadata
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments= NA 
data.Export$Subprogram=NA
tdp.Final = data.Export
rm(data)
rm(data.Export)

################################### TDP-site 8  #############################################################################################################################
data=platte_lake_data
head(data) #looking at snapshot of data
unique(data$PDesc)#looking at unique parameters, pull out observations of interest
#pull out observations of interest
length(data$PDesc[which(data$PDesc=="TDP")])#213 observations should remain
data=data[which(data$PDesc=="TDP"),]
#check for null observations
unique(data$Measure)#looking for problematic values
length(data$Measure[which(is.na(data$Measure)==TRUE)])
length(data$Measure[which(data$Measure=="")])
#no null values
#check for do not use observations and filter out
unique(data$DNU)
length(data$DNU[which(data$DNU=="TRUE")])
213-6 #207 OBSERVATIONS will remain after filtering out the do not use
data=data[which(data$DNU!="TRUE"),]
unique(data$SiteID)
length(data$SiteID[which(data$SiteID=="8")])
#pull out obs with site Id of 8
data=data[which(data$SiteID=="8"),]

#check for and eliminate replicates by determining which sample dates are duplicate (while the depth is also duplicate)
#filter out replicate observations
library(data.table)
data1=data.table(data,key=c('SampDate','DepthM'))
unique(data1)
data1=data1[unique(data1[,key(data1),with=FALSE]),mult='first']
data=data1
rm(data1)


#look at other unique values of data
unique(data$DepthM)#only two unique sample depths
unique(data$MAbbr) #only grab samples
unique(data$Measure)

#done filtering
#proceed to populating LAGOS template
###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$SiteID
data.Export$LakeName = data$SiteName
data.Export$SourceVariableName = "TDP"
data.Export$SourceVariableDescription = "Total dissolved phosphorus"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no info on source flags
#continue populating other lagos variables
data.Export$LagosVariableID = 28
data.Export$LagosVariableName="Phosphorus, total dissolved"
names(data)
data.Export$Value = data$Measure #export observations, already in preferred units
data.Export$CensorCode = NA #no info on censor code
data.Export$Date = data$SampDate #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
unique(data$MAbbr) #composite and grab
length(data$MAbbr[which(data$MAbbr=="Grab")]) #69 grab
length(data$MAbbr[which(data$MAbbr=="Composite")])#0 are composite
data.Export$SampleType[which(data$MAbbr=="Grab")]="GRAB"
data.Export$SampleType[which(data$MAbbr=="Composite")]="INTEGRATED"
#check to make sure correct number of each assigned
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")])
69+0#adds to toal
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition= "SPECIFIED"#per metadata
#assign sampledepth 
unique(data$DepthM)#look at unique depths
length(data$DepthM[which(data$DepthM=="")]) #check for missing depth values
data.Export$SampleDepth= data$DepthM
#continue populating other lagos fields
data.Export$BasinType="UNKNOWN"
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable 
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "SM_4500PE"
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #per metadata
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments= NA 
data.Export$Subprogram=NA
tdp1.Final = data.Export
rm(data)
rm(data.Export)



################################### SecchiM  #############################################################################################################################
data=platte_lake_secchi
head(data) #looking at snapshot of data
unique(data$SecchiM)#looking for problematic values
names(data)
unique(data$SiteID)#multiple sites
#check for null observations
length(data$SecchiM[which(is.na(data$SecchiM)==TRUE)])
length(data$SecchiM[which(data$SecchiM=="")])


#look at other unique values of data
unique(data$SiteID)#multiple sites sampled
unique(data$SiteName) #multiple site names specified depending on depth of basin


#done filtering
#proceed to populating LAGOS template
###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$SiteID
data.Export$LakeName = data$SiteName
data.Export$SourceVariableName = "SecchiM"
data.Export$SourceVariableDescription = "Secchi depth"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no info on source flags
#continue populating other lagos variables
data.Export$LagosVariableID = 30
data.Export$LagosVariableName="Secchi"
names(data)
data.Export$Value = data$SecchiM #export observations, already in preferred units
data.Export$CensorCode = NA #no info on censor code
data.Export$Date = data$SampDate #date already in correct format
data.Export$Units="m"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED"
#check to make sure correct number of each assigned
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")])
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition= "SPECIFIED"#per metadata
#assign sampledepth 
data.Export$SampleDepth= NA #because secchi
#continue populating other lagos fields
data.Export$BasinType="UNKNOWN"
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = "SECCHI_VIEW_UNKNOWN"
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA
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
Final.Export = rbind(chla.Final,chla1.Final,nox.Final,tp.Final,tp1.Final,tdp.Final,tdp1.Final,secchi.Final)
######################################################################
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
10+5914#adds up to total
##write table
Final.Export1=data1
typeof(Final.Export1$Value)
length(Final.Export1$Value[which(Final.Export1$Value<0)])
negative.df=Final.Export1[which(Final.Export1$Value<0),]
Final.Export1=Final.Export1[which(Final.Export1$Value>=0),]#filter out one neg. obs.
nosamplepos=Final.Export1[which(is.na(Final.Export1$SampleDepth)==TRUE & Final.Export1$SamplePosition=="UNKNOWN"),]
write.table(Final.Export1,file="DataImport_MI_TMDL_PLATTE_CHEM.csv",row.names=FALSE,sep=",")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MI data/Platte Lake (finished)/DataImport_MI_TMDL_PLATTE_CHEM/DataImport_MI_TMDL_PLATTE_CHEM.RData")
save.image("C:/Users/Sam/Dropbox/CSI-LIMNO_DATA/DATA-lake/MI data/Platte Lake (finished)/DataImport_MI_TMDL_PLATTE_CHEM/DataImport_MI_TMDL_PLATTE_CHEM.RData")
