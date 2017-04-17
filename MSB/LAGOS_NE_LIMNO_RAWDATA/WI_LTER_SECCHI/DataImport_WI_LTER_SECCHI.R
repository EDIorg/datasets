#set path to files
setwd("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/WI data/LTER (finished)/DataImport_WI_LTER_SECCHI")

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
                            Comments=character(0))


################################## WI_LTER_SECCHI #####################################################################################################
#lter secchi data
#with a view scope or without
#########################################################################################################################################################
###############################   secnview      ##############################################################################################################
data=secchi
names(data) #look at column names
data = data[,c(1,4:7)] #pull out columns of interest
head(data)#looking at data
unique(data$secnview)#looking for problematic observations
length(data$secnview[which(is.na(data$secnview)==TRUE)])
1846/6326#30% observations need to be removed because they are NA
#filter out 1846 NA observations
6326-1846#4480 should remain after filtering
data=data[which(is.na(data$secnview)==FALSE),]
#no other filtering

#### Begin Populating Lagos Template ###
data.Export = LAGOS_Template #creates LAGOS export template
data.Export[1:nrow(data),]=NA #specifies how to fill template
data$lakeid = as.character(data$lakeid) #need to work on getting the full lake name from lakeid in the dataset
unique(data$lakeid) #reveals number of lakes == 11 NTL-LTER study lakes
#now convert to full lakename and export to LAGOS 
data.Export$LakeName=as.character(data.Export$LakeName) #convert to character so it can be manipulated
data.Export$LakeName[which(data$lakeid=="ME")]="LAKE MENDOTA"
data.Export$LakeName[which(data$lakeid=="MO")]="LAKE MONONA"
data.Export$LakeName[which(data$lakeid=="FI")]="FISH LAKE"
data.Export$LakeName[which(data$lakeid=="WI")]="LAKE WINGRA"
data.Export$LakeName[which(data$lakeid=="TR")]="TROUT LAKE"
data.Export$LakeName[which(data$lakeid=="TB")]="TROUT BOG"
data.Export$LakeName[which(data$lakeid=="AL")]="ALLEQUASH LAKE"
data.Export$LakeName[which(data$lakeid=="SP")]="SPARKLING LAKE"
data.Export$LakeName[which(data$lakeid=="BM")]="BIG MUSKELLUNGE LAKE"
data.Export$LakeName[which(data$lakeid=="CB")]="CRYSTAL BOG"
data.Export$LakeName[which(data$lakeid=="CR")]="CRYSTAL LAKE"
#now populate LAGOS LakeID--use WDNR (Wisconsin DNR) WBIC (WBIC=waterbody identification code) for LakeID
data.Export$LakeID=as.character(data.Export$LakeID)
data.Export$LakeID[which(data$lakeid=="ME")]="805400"
data.Export$LakeID[which(data$lakeid=="MO")]="804600"
data.Export$LakeID[which(data$lakeid=="FI")]="985100"
data.Export$LakeID[which(data$lakeid=="WI")]="805000"
data.Export$LakeID[which(data$lakeid=="TR")]="2331600" #note that it is the south basin of trout
data.Export$LakeID[which(data$lakeid=="TB")]="2014700"
data.Export$LakeID[which(data$lakeid=="SP")]="1881900"
data.Export$LakeID[which(data$lakeid=="BM")]="1835300"
data.Export$LakeID[which(data$lakeid=="AL")]="2332400" ##note that it is the north basin of allequash
data.Export$LakeID[which(data$lakeid=="CB")]="2017500"
data.Export$LakeID[which(data$lakeid=="CR")]="1842400"
#fill in source variable name according to major.nutrients
data.Export$SourceVariableName = "secnview"
data.Export$SourceVariableDescription = "Secchi depth without viewer" #be sure to check metadata table to make sure it matches
##need to populate data flags and make a note in the processing log
head(data)
data.Export$SourceFlags = data[,5] #export observations that were "ice" to source flags (if ice 1 is specified)
unique(data.Export$SourceFlags)
data.Export$LagosVariableID= 30 
data.Export$LagosVariableName="Secchi"
names(data)
data.Export$Value = data[,4] #export secchi no viewer obs, already in preff. units of meters
data.Export$DetectionLimit = NA
##censor code populating- determine if detection limit (dl exists) then determine if observation is greater than (GL) or less than (LT) the detection limit. Assign "NC" if there is no censor code
data.Export$CensorCode = as.character(data.Export$CensorCode)
data.Export$CensorCode= "NC"
data.Export$Units="m" #preferred units per metadata table
data.Export$Date = data$sampledate #export sample date, already in correct format
data.Export$SamplePosition = as.character(data.Export$SamplePosition) #convert sample position to character, so it can be manipulated
data.Export$SamplePosition= "SPECIFIED" #secchi
data.Export$SampleDepth = NA #because secchi
unique(data.Export$SampleDepth)
data.Export$SampleType = as.character(data.Export$SampleType)
data.Export$SampleType= "INTEGRATED" #SECCHI
data.Export$BasinType = as.character(data.Export$BasinType)
data.Export$BasinType= "PRIMARY"
data.Export$MethodInfo=as.character(data.Export$MethodInfo)
data.Export$MethodInfo=NA
data.Export$LabMethodName=as.character(data.Export$LabMethodName)
data.Export$LabMethodName=NA 
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="See NT LTER website - http://lter.limnology.wisc.edu/research/protocols"
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data$ice=="1")]="secchi disk observation made while the lake was ice-covered"
unique(data.Export$Comments)
secchi.Final = data.Export
rm(data)
rm(data.Export)

###############################   secview     ##############################################################################################################
data=secchi
names(data) #look at column names
data = data[,c(1,4:7)] #pull out columns of interest
head(data)#looking at data
unique(data$secview)#looking for problematic observations
length(data$secview[which(is.na(data$secview)==TRUE)])
3236/6326#50% observations need to be removed because they are NA
#filter out 3236 NA observations
6326-3236#3090 should remain after filtering
data=data[which(is.na(data$secview)==FALSE),]
#no other filtering

#### Begin Populating Lagos Template ###
data.Export = LAGOS_Template #creates LAGOS export template
data.Export[1:nrow(data),]=NA #specifies how to fill template
data$lakeid = as.character(data$lakeid) #need to work on getting the full lake name from lakeid in the dataset
unique(data$lakeid) #reveals number of lakes == 11 NTL-LTER study lakes
#now convert to full lakename and export to LAGOS 
data.Export$LakeName=as.character(data.Export$LakeName) #convert to character so it can be manipulated
data.Export$LakeName[which(data$lakeid=="ME")]="LAKE MENDOTA"
data.Export$LakeName[which(data$lakeid=="MO")]="LAKE MONONA"
data.Export$LakeName[which(data$lakeid=="FI")]="FISH LAKE"
data.Export$LakeName[which(data$lakeid=="WI")]="LAKE WINGRA"
data.Export$LakeName[which(data$lakeid=="TR")]="TROUT LAKE"
data.Export$LakeName[which(data$lakeid=="TB")]="TROUT BOG"
data.Export$LakeName[which(data$lakeid=="AL")]="ALLEQUASH LAKE"
data.Export$LakeName[which(data$lakeid=="SP")]="SPARKLING LAKE"
data.Export$LakeName[which(data$lakeid=="BM")]="BIG MUSKELLUNGE LAKE"
data.Export$LakeName[which(data$lakeid=="CB")]="CRYSTAL BOG"
data.Export$LakeName[which(data$lakeid=="CR")]="CRYSTAL LAKE"
#now populate LAGOS LakeID--use WDNR (Wisconsin DNR) WBIC (WBIC=waterbody identification code) for LakeID
data.Export$LakeID=as.character(data.Export$LakeID)
data.Export$LakeID[which(data$lakeid=="ME")]="805400"
data.Export$LakeID[which(data$lakeid=="MO")]="804600"
data.Export$LakeID[which(data$lakeid=="FI")]="985100"
data.Export$LakeID[which(data$lakeid=="WI")]="805000"
data.Export$LakeID[which(data$lakeid=="TR")]="2331600" #note that it is the south basin of trout
data.Export$LakeID[which(data$lakeid=="TB")]="2014700"
data.Export$LakeID[which(data$lakeid=="SP")]="1881900"
data.Export$LakeID[which(data$lakeid=="BM")]="1835300"
data.Export$LakeID[which(data$lakeid=="AL")]="2332400" ##note that it is the north basin of allequash
data.Export$LakeID[which(data$lakeid=="CB")]="2017500"
data.Export$LakeID[which(data$lakeid=="CR")]="1842400"
#fill in source variable name according to major.nutrients
data.Export$SourceVariableName = "secview"
data.Export$SourceVariableDescription = "Secchi depth with viewer" #be sure to check metadata table to make sure it matches
##need to populate data flags and make a note in the processing log
head(data)
data.Export$SourceFlags = data[,5] #export observations that were "ice" to source flags (if ice 1 is specified)
unique(data.Export$SourceFlags)
data.Export$LagosVariableID= 30 
data.Export$LagosVariableName="Secchi"
names(data)
data.Export$Value = data[,3] #export secchi viewer obs, already in preff. units of meters
data.Export$DetectionLimit = NA
##censor code populating- determine if detection limit (dl exists) then determine if observation is greater than (GL) or less than (LT) the detection limit. Assign "NC" if there is no censor code
data.Export$CensorCode = as.character(data.Export$CensorCode)
data.Export$CensorCode= "NC"
data.Export$Units="m" #preferred units per metadata table
data.Export$Date = data$sampledate #export sample date, already in correct format
data.Export$SamplePosition = as.character(data.Export$SamplePosition) #convert sample position to character, so it can be manipulated
data.Export$SamplePosition= "SPECIFIED" #secchi
data.Export$SampleDepth = NA #because secchi
unique(data.Export$SampleDepth)
data.Export$SampleType = as.character(data.Export$SampleType)
data.Export$SampleType= "INTEGRATED" #SECCHI
data.Export$BasinType = as.character(data.Export$BasinType)
data.Export$BasinType= "PRIMARY"
data.Export$MethodInfo=as.character(data.Export$MethodInfo)
data.Export$MethodInfo="SECCHI_VIEW"
data.Export$LabMethodName=as.character(data.Export$LabMethodName)
data.Export$LabMethodName=NA 
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="See NT LTER website - http://lter.limnology.wisc.edu/research/protocols"
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data$ice=="1")]="secchi disk observation made while the lake was ice-covered"
unique(data.Export$Comments)
secchi1.Final = data.Export
rm(data)
rm(data.Export)


###################################### final export ########################################################################################
Final.Export = rbind(secchi.Final,secchi1.Final)
write.table(Final.Export,file="DataImport_WI_LTER_SECCHI.csv",row.names=FALSE,sep=",")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/WI data/LTER (finished)/DataImport_WI_LTER_SECCHI/DataImport_WI_LTER_SECCHI.RData")