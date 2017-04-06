#set path to files
setwd("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/ME data/Acadia (Finished)/DataImport_ME_ANP_post_2006")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/ME data/Acadia (Finished)/DataImport_ME_ANP_post_2006/DataImport_ME_ANP_post_2006.RData")


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

#################################### General Notes ########################################################################################################################################
#similar to ME DEP
#see data import log for details on variables
###########################################################################################################################################################################################
################################### DOC_mg/L #############################################################################################################################
data= Acadia.post2006.Chem
names(data) #just looking at column names
length(data$DOC_mgL[which(is.na(data$DOC_mgL)==TRUE)]) #142 values are null for DOC, remove
length(data$DOC_mgL[which(data$DOC_mgL=="NULL")]) #none are "NULL"
unique(data$DOC_mgL) #checking to make sure there aren't other values that may represent null
210-142 #should be left with 68 after filtering
data=data[which(is.na(data$DOC_mgL)==FALSE),]
data = data[,c(1:2,6:10,21,42)] #filtering out columns of interest
#no other filtering that needs to be done
#proceed to populating LAGOS template

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$MIDAS #set to MIDAS the unique lake id scheme in Maine
data.Export$LakeName = data$Lake.name
data.Export$SourceVariableName = "DOC_mg/L"
data.Export$SourceVariableDescription = "Dissolved organic carbon"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #none for DOC
#continue populating other lagos variables
data.Export$LagosVariableID = 6
data.Export$LagosVariableName="Carbon, dissolved organic"
names(data)
data.Export$Value = data[,8] #export doc values, no conversion necessary
data.Export$CensorCode = NA #no infor on CensorCode
data.Export$Date = data$Date #date already in correct format
data.Export$Units="mg/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
unique(data$Type.of.sample) #G=grab, C= integrated epi
unique(data$Sample.type) #only epilimnion
length(data$Sample.type[which(data$Sample.type=="Epilimnion")])#all 68 specified as epi
length(data$Type.of.sample[which(data$Type.of.sample=="G")]) #68 grab
length(data$Type.of.sample[which(data$Type.of.sample=="C")]) #0 integrated
68+0 #adds up to total
data.Export$SampleType[which(data$Type.of.sample=="G")]= "GRAB"
data.Export$SampleType[which(data$Type.of.sample=="C")]= "INTEGRATED"
#check to make sure adds up to total
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")])
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
length(data$Sample.depth_m[which(is.na(data$Sample.depth_m)==TRUE)]) #all sample depths filled = good
data.Export$SamplePosition[which(data$Sample.type=="Epilimnion")]="EPI"
data.Export$SamplePosition[which(is.na(data$Sample.type)==TRUE)]="SPECIFIED"
#check to make sure adds up to total
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")])
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
#assign sampledepth 
length(data$Sample.depth_m[which(is.na(data$Sample.depth_m)==FALSE)]) #check for missing depth values=none
data.Export$SampleDepth= data$Sample.depth_m
unique(data$Sample.depth_m)
#continue populating other lagos fields
unique(data$Sample.location) #if 1 set BasinType to PRIMARY if 2 set BasinType to UNKNOWN
data.Export$BasinType=as.character(data.Export$BasinType)
data$Sample.location=as.character(data$Sample.location)
data.Export$BasinType[which(data$Sample.location=="1")]="PRIMARY"
data.Export$BasinType[which(data$Sample.location=="2")]="UNKNOWN"
#check to make sure adds to total
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")])
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")])
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable to doc
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #no info in metadata
unique(data$SiteObservations) #don't export these comments
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments= NA 
doc.Final = data.Export
rm(data.Export)
rm(data)
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/ME data/Acadia (Finished)/DataImport_ME_ANP_post_2006/DataImport_ME_ANP_post_2006.RData")

################################### ChlA_ug/L  #############################################################################################################################
data= Acadia.post2006.Chem
names(data) #just looking at column names
length(data$ChlA_ug.L[which(is.na(data$ChlA_ug.L)==TRUE)]) #85 values are null, remove
length(data$ChlA_ug.L[which(data$ChlA_ug.L=="NULL")]) #none are "NULL"
unique(data$ChlA_ug.L) #checking to make sure there aren't other values that may represent null
210-85 #should be left with 125 after filtering
data=data[which(is.na(data$ChlA_ug.L)==FALSE),]
data = data[,c(1:2,6:10,19:20,42)] #filtering out columns of interest
unique(data$ChlA_Flag) #no values actually specified for flag
#no other filtering that needs to be done
#proceed to populating LAGOS template

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$MIDAS #set to MIDAS the unique lake id scheme in Maine
data.Export$LakeName = data$Lake.name
data.Export$SourceVariableName = "ChlA_ug/L"
data.Export$SourceVariableDescription = "Chlorophyll a"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #none for chla
#continue populating other lagos variables
data.Export$LagosVariableID = 9
data.Export$LagosVariableName="Chlorophyll a"
names(data)
data.Export$Value = data[,8] #export chla values, no conversion necessary
data.Export$CensorCode = NA #no infor on CensorCode
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
unique(data$Type.of.sample) #G=grab, C= integrated epi
unique(data$Sample.type) #only epilimnion
length(data$Sample.type[which(data$Sample.type=="Epilimnion")])#all 125 specified as epi
length(data$Type.of.sample[which(data$Type.of.sample=="G")]) #12 grab
length(data$Type.of.sample[which(data$Type.of.sample=="C")]) #113 integrated
12+113 #adds up to total
data.Export$SampleType[which(data$Type.of.sample=="G")]= "GRAB"
data.Export$SampleType[which(data$Type.of.sample=="C")]= "INTEGRATED"
#check to make sure adds up to total
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")])
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
length(data$Sample.depth_m[which(is.na(data$Sample.depth_m)==TRUE)]) #all sample depths filled = good
data.Export$SamplePosition[which(data$Sample.type=="Epilimnion")]="EPI"
data.Export$SamplePosition[which(is.na(data$Sample.type)==TRUE)]="SPECIFIED"
#check to make sure adds up to total
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")])
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
#assign sampledepth 
length(data$Sample.depth_m[which(is.na(data$Sample.depth_m)==FALSE)]) #check for missing depth values=none
data.Export$SampleDepth= data$Sample.depth_m
unique(data$Sample.depth_m)
#continue populating other lagos fields
unique(data$Sample.location) #if 1 set BasinType to PRIMARY if 2 set BasinType to UNKNOWN
data.Export$BasinType=as.character(data.Export$BasinType)
data$Sample.location=as.character(data$Sample.location)
data.Export$BasinType[which(data$Sample.location=="1")]="PRIMARY"
data.Export$BasinType[which(data$Sample.location=="2")]="UNKNOWN"
data.Export$BasinType[which(is.na(data$Sample.location)==TRUE)]="UNKNOWN"
#check to make sure adds to total
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")])
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")])
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable to chla
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= 1 #determined from MRL in flag column, even though no obs had this flag
unique(data$SiteObservations) #don't export these comments
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments= NA 
chla.Final = data.Export
rm(data.Export)
rm(data)
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/ME data/Acadia (Finished)/DataImport_ME_ANP_post_2006/DataImport_ME_ANP_post_2006.RData")

################################### ApparentColor_PCU  #############################################################################################################################
data= Acadia.post2006.Chem
names(data) #just looking at column names
length(data$ApparentColor_PCU[which(is.na(data$ApparentColor_PCU)==TRUE)]) #78 values are null, remove
length(data$ApparentColor_PCU[which(data$ApparentColor_PCU=="NULL")]) #none are "NULL"
unique(data$ApparentColor_PCU) #checking to make sure there aren't other values that may represent null
210-78 #should be left with 132 after filtering
data=data[which(is.na(data$ApparentColor_PCU)==FALSE),]
data = data[,c(1:2,6:10,23:24,42)] #filtering out columns of interest
unique(data$Color_Flag) #no values actually specified for flag
#no other filtering that needs to be done
#proceed to populating LAGOS template

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$MIDAS #set to MIDAS the unique lake id scheme in Maine
data.Export$LakeName = data$Lake.name
data.Export$SourceVariableName = "ApparentColor_PCU"
data.Export$SourceVariableDescription = "Apparent color"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #none for acolor
#continue populating other lagos variables
data.Export$LagosVariableID = 11
data.Export$LagosVariableName="Color, apparent"
names(data)
data.Export$Value = data[,8] #export acolor values, no conversion necessary
data.Export$CensorCode = NA #no infor on CensorCode
data.Export$Date = data$Date #date already in correct format
data.Export$Units="PCU"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
unique(data$Type.of.sample) #G=grab, C= integrated epi
unique(data$Sample.type) #only epilimnion
length(data$Sample.type[which(data$Sample.type=="Epilimnion")])#all 132 specified as epi
length(data$Type.of.sample[which(data$Type.of.sample=="G")]) #13 grab
length(data$Type.of.sample[which(data$Type.of.sample=="C")]) #119 integrated
13+119 #adds up to total
data.Export$SampleType[which(data$Type.of.sample=="G")]= "GRAB"
data.Export$SampleType[which(data$Type.of.sample=="C")]= "INTEGRATED"
#check to make sure adds up to total
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")])
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
length(data$Sample.depth_m[which(is.na(data$Sample.depth_m)==TRUE)]) #all sample depths filled = good
data.Export$SamplePosition[which(data$Sample.type=="Epilimnion")]="EPI"
data.Export$SamplePosition[which(is.na(data$Sample.type)==TRUE)]="SPECIFIED"
#check to make sure adds up to total
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")])
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
#assign sampledepth 
length(data$Sample.depth_m[which(is.na(data$Sample.depth_m)==FALSE)]) #check for missing depth values=none
data.Export$SampleDepth= data$Sample.depth_m
unique(data$Sample.depth_m)
#continue populating other lagos fields
unique(data$Sample.location) #if 1 set BasinType to PRIMARY if 2 set BasinType to UNKNOWN
data.Export$BasinType=as.character(data.Export$BasinType)
data$Sample.location=as.character(data$Sample.location)
data.Export$BasinType[which(data$Sample.location=="1")]="PRIMARY"
data.Export$BasinType[which(data$Sample.location=="2")]="UNKNOWN"
data.Export$BasinType[which(is.na(data$Sample.location)==TRUE)]="UNKNOWN"
#check to make sure adds to total
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")])
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")])
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #no info in metadata
unique(data$SiteObservations) #don't export these comments
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments= NA 
acolor.Final = data.Export
rm(data.Export)
rm(data)
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/ME data/Acadia (Finished)/DataImport_ME_ANP_post_2006/DataImport_ME_ANP_post_2006.RData")

################################### TrueColor_PCU  #############################################################################################################################
data= Acadia.post2006.Chem
names(data) #just looking at column names
length(data$TrueColor_PCU[which(is.na(data$TrueColor_PCU)==TRUE)]) #142 values are null, remove
length(data$TrueColor_PCU[which(data$TrueColor_PCU=="NULL")]) #none are "NULL"
unique(data$TrueColor_PCU) #checking to make sure there aren't other values that may represent null
210-142 #should be left with 68 after filtering
data=data[which(is.na(data$TrueColor_PCU)==FALSE),]
data = data[,c(1:2,6:10,22,24,42)] #filtering out columns of interest
unique(data$Color_Flag) #no values actually specified for flag
#no other filtering that needs to be done
#proceed to populating LAGOS template

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$MIDAS #set to MIDAS the unique lake id scheme in Maine
data.Export$LakeName = data$Lake.name
data.Export$SourceVariableName = "TrueColor_PCU"
data.Export$SourceVariableDescription = "True color"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #none for tcolor
#continue populating other lagos variables
data.Export$LagosVariableID = 12
data.Export$LagosVariableName="Color, true"
names(data)
data.Export$Value = data[,8] #export tcolor values, no conversion necessary
data.Export$CensorCode = NA #no infor on CensorCode
data.Export$Date = data$Date #date already in correct format
data.Export$Units="PCU"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
unique(data$Type.of.sample) #G=grab, C= integrated epi
unique(data$Sample.type) #only epilimnion
length(data$Sample.type[which(data$Sample.type=="Epilimnion")])#all 68 specified as epi
length(data$Type.of.sample[which(data$Type.of.sample=="G")]) #68 grab
length(data$Type.of.sample[which(data$Type.of.sample=="C")]) #0 integrated
68+0 #adds up to total
data.Export$SampleType[which(data$Type.of.sample=="G")]= "GRAB"
data.Export$SampleType[which(data$Type.of.sample=="C")]= "INTEGRATED"
#check to make sure adds up to total
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")])
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
length(data$Sample.depth_m[which(is.na(data$Sample.depth_m)==TRUE)]) #all sample depths filled = good
data.Export$SamplePosition[which(data$Sample.type=="Epilimnion")]="EPI"
data.Export$SamplePosition[which(is.na(data$Sample.type)==TRUE)]="SPECIFIED"
#check to make sure adds up to total
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")])
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
#assign sampledepth 
length(data$Sample.depth_m[which(is.na(data$Sample.depth_m)==FALSE)]) #check for missing depth values=none
data.Export$SampleDepth= data$Sample.depth_m
unique(data$Sample.depth_m)
#continue populating other lagos fields
unique(data$Sample.location) #if 1 set BasinType to PRIMARY if 2 set BasinType to UNKNOWN
data.Export$BasinType=as.character(data.Export$BasinType)
data$Sample.location=as.character(data$Sample.location)
data.Export$BasinType[which(data$Sample.location=="1")]="PRIMARY"
data.Export$BasinType[which(data$Sample.location=="2")]="UNKNOWN"
data.Export$BasinType[which(is.na(data$Sample.location)==TRUE)]="UNKNOWN"
#check to make sure adds to total
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")])
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")])
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #no info in metadata
unique(data$SiteObservations) #don't export these comments
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments= "True (filtered) color (Platinum cobalt units)"
tcolor.Final = data.Export
rm(data.Export)
rm(data)
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/ME data/Acadia (Finished)/DataImport_ME_ANP_post_2006/DataImport_ME_ANP_post_2006.RData")

################################### NH3_mg/L  #############################################################################################################################
data= Acadia.post2006.Chem
names(data) #just looking at column names
length(data$NH3_mg.L[which(is.na(data$NH3_mg.L)==TRUE)]) #188 values are null, remove
length(data$NH3_mg.L[which(data$NH3_mg.L=="NULL")]) #none are "NULL"
unique(data$NH3_mg.L) #checking to make sure there aren't other values that may represent null
210-188 #should be left with 22 after filtering
data=data[which(is.na(data$NH3_mg.L)==FALSE),]
data = data[,c(1:2,6:10,37:38,42)] #filtering out columns of interest
unique(data$NH3_Flag) #two unique flags here, each specify a diff. detection limit (MRL)
#no other filtering that needs to be done
#proceed to populating LAGOS template

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$MIDAS #set to MIDAS the unique lake id scheme in Maine
data.Export$LakeName = data$Lake.name
data.Export$SourceVariableName = "NH3_mg/L"
data.Export$SourceVariableDescription = "Free ammonia (NH3)"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=data$NH3_Flag
unique(data$NH3_Flag)
#continue populating other lagos variables
data.Export$LagosVariableID = 19
data.Export$LagosVariableName="Nitrogen, NH4 "
names(data)
data.Export$Value = data[,8]*1000 #export nh3 obs and *1000 to go from mg/L to pref. ug/L
#populate CensorCode based on flags
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$NH3_Flag=="E, <MRL 0.01")]="LT"
data.Export$CensorCode[which(data$NH3_Flag=="E, <MRL 0.02")]="LT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]=NA 
unique(data.Export$CensorCode)
#check to make sure all CensorCode populated
length(data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)])
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])
#continue with others
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
unique(data$Type.of.sample) #G=grab, C= integrated epi
unique(data$Sample.type) #only epilimnion
length(data$Sample.type[which(data$Sample.type=="Epilimnion")])#all 22 specified as epi
length(data$Type.of.sample[which(data$Type.of.sample=="G")]) #4 grab
length(data$Type.of.sample[which(data$Type.of.sample=="C")]) #18 integrated
18+4 #adds up to total
data.Export$SampleType[which(data$Type.of.sample=="G")]= "GRAB"
data.Export$SampleType[which(data$Type.of.sample=="C")]= "INTEGRATED"
#check to make sure adds up to total
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")])
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
length(data$Sample.depth_m[which(is.na(data$Sample.depth_m)==TRUE)]) #all sample depths filled = good
data.Export$SamplePosition[which(data$Sample.type=="Epilimnion")]="EPI"
data.Export$SamplePosition[which(is.na(data$Sample.type)==TRUE)]="SPECIFIED"
#check to make sure adds up to total
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")])
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
#assign sampledepth 
length(data$Sample.depth_m[which(is.na(data$Sample.depth_m)==FALSE)]) #check for missing depth values=none
data.Export$SampleDepth= data$Sample.depth_m
unique(data$Sample.depth_m)
#continue populating other lagos fields
unique(data$Sample.location) #if 1 set BasinType to PRIMARY if 2 set BasinType to UNKNOWN
data.Export$BasinType=as.character(data.Export$BasinType)
data$Sample.location=as.character(data$Sample.location)
data.Export$BasinType[which(data$Sample.location=="1")]="PRIMARY"
data.Export$BasinType[which(data$Sample.location=="2")]="UNKNOWN"
data.Export$BasinType[which(is.na(data$Sample.location)==TRUE)]="UNKNOWN"
#check to make sure adds to total
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")])
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")])
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
#specify detection limit
data.Export$DetectionLimit[which(data$NH3_Flag=="E, <MRL 0.01")]= (0.01*1000)
data.Export$DetectionLimit[which(data$NH3_Flag=="E, <MRL 0.02")]= (0.02*1000)  
data.Export$DetectionLimit[which(is.na(data.Export$DetectionLimit)==TRUE)]=.01*1000  #picked 0.01 as the detection limit for all other obs. w/o data flag
unique(data.Export$DetectionLimit)
#continue
unique(data$SiteObservations) #don't export these comments
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data$NH3_Flag=="E, <MRL 0.01")]= "ESTIMATED"
data.Export$Comments[which(data$NH3_Flag=="E, <MRL 0.02")]= "ESTIMATED"
unique(data.Export$Comments)  
nh3.Final = data.Export
rm(data.Export)
rm(data)
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/ME data/Acadia (Finished)/DataImport_ME_ANP_post_2006/DataImport_ME_ANP_post_2006.RData")

################################### NH4_mg/L  #############################################################################################################################
data= Acadia.post2006.Chem
names(data) #just looking at column names
length(data$NH4_mg.L[which(is.na(data$NH4_mg.L)==TRUE)]) #206 values are null, remove
length(data$NH4_mg.L[which(data$NH4_mg.L=="NULL")]) #none are "NULL"
unique(data$NH4_mg.L) #checking to make sure there aren't other values that may represent null
210-206 #should be left with 4 after filtering
data=data[which(is.na(data$NH4_mg.L)==FALSE),]
data = data[,c(1:2,6:10,39:40,42)] #filtering out columns of interest
unique(data$NH4_Flag) #one unique flag,specifies CensorCode
#no other filtering that needs to be done
#proceed to populating LAGOS template

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$MIDAS #set to MIDAS the unique lake id scheme in Maine
data.Export$LakeName = data$Lake.name
data.Export$SourceVariableName = "Nitrogen, NH4"
data.Export$SourceVariableDescription = "Ammonium (NH4)"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=data$NH4_Flag
unique(data$NH4_Flag)
#continue populating other lagos variables
data.Export$LagosVariableID = 19
data.Export$LagosVariableName="Nitrogen, NH4"
names(data)
data.Export$Value = data[,8]*1000 #export nh4 obs *1000 to go from mg/L to pref. ug/L
#populate CensorCode based on flags
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$NH4_Flag=="<MRL 0.1")]="LT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]=NA 
unique(data.Export$CensorCode)
#check to make sure all CensorCode populated
length(data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)])
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])
#continue with others
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
unique(data$Type.of.sample) #G=grab, C= integrated epi
unique(data$Sample.type) #only epilimnion
length(data$Sample.type[which(data$Sample.type=="Epilimnion")])#all 4 specified as epi
length(data$Type.of.sample[which(data$Type.of.sample=="G")]) #4 grab
length(data$Type.of.sample[which(data$Type.of.sample=="C")]) #0 integrated
0+4 #adds up to total
data.Export$SampleType[which(data$Type.of.sample=="G")]= "GRAB"
data.Export$SampleType[which(data$Type.of.sample=="C")]= "INTEGRATED"
#check to make sure adds up to total
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")])
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
length(data$Sample.depth_m[which(is.na(data$Sample.depth_m)==TRUE)]) #all sample depths filled = good
data.Export$SamplePosition[which(data$Sample.type=="Epilimnion")]="EPI"
data.Export$SamplePosition[which(is.na(data$Sample.type)==TRUE)]="SPECIFIED"
#check to make sure adds up to total
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")])
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
#assign sampledepth 
length(data$Sample.depth_m[which(is.na(data$Sample.depth_m)==FALSE)]) #check for missing depth values=none
data.Export$SampleDepth= data$Sample.depth_m
unique(data$Sample.depth_m)
#continue populating other lagos fields
unique(data$Sample.location) #if 1 set BasinType to PRIMARY if 2 set BasinType to UNKNOWN
data.Export$BasinType=as.character(data.Export$BasinType)
data$Sample.location=as.character(data$Sample.location)
data.Export$BasinType[which(data$Sample.location=="1")]="PRIMARY"
data.Export$BasinType[which(data$Sample.location=="2")]="UNKNOWN"
data.Export$BasinType[which(is.na(data$Sample.location)==TRUE)]="UNKNOWN"
#check to make sure adds to total
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")])
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")])
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
#populate detection limit
data.Export$DetectionLimit= (0.1*1000) 
unique(data.Export$DetectionLimit)
#continue
unique(data$SiteObservations) #don't export these comments
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data$NH4_Flag=="<MRL 0.1")]= "ESTIMATED"
unique(data.Export$Comments)
nh4.Final = data.Export
rm(data.Export)
rm(data)
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/ME data/Acadia (Finished)/DataImport_ME_ANP_post_2006/DataImport_ME_ANP_post_2006.RData")

################################### NO3_ueq/L #############################################################################################################################
data= Acadia.post2006.Chem
names(data) #just looking at column names
length(data$NO3_ueq.L[which(is.na(data$NO3_ueq.L)==TRUE)]) #194 values are null, remove
length(data$NO3_ueq.L[which(data$NO3_ueq.L=="NULL")]) #none are "NULL"
unique(data$NO3_ueq.L) #checking to make sure there aren't other values that may represent null
210-194 #should be left with 16 after filtering
data=data[which(is.na(data$NO3_ueq.L)==FALSE),]
data = data[,c(1:2,6:10,17:18,42)] #filtering out columns of interest
unique(data$NO3_Flag) #one unique flag with MRL
#no other filtering that needs to be done
#proceed to populating LAGOS template

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$MIDAS #set to MIDAS the unique lake id scheme in Maine
data.Export$LakeName = data$Lake.name
data.Export$SourceVariableName = "NO3_ueq/L"
data.Export$SourceVariableDescription = "Nitrate (NO3)"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=data$NO3_Flag
unique(data$NO3_Flag)
#continue populating other lagos variables
data.Export$LagosVariableID = 18
data.Export$LagosVariableName="Nitrogen, nitrite (NO2) + nitrate (NO3)"
names(data)
data.Export$Value = (data[,8]/16.13)*1000 #export no3 obs divide by 16.13 and * 1000 to go from ueq/L to pref. ug/L
#populate CensorCode based on flags
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$NO3_Flag=="E, <MRL 1")]="LT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]=NA 
unique(data.Export$CensorCode)
#check to make sure all CensorCode populated
length(data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)])
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])
#continue with others
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
unique(data$Type.of.sample) #G=grab, C= integrated epi
unique(data$Sample.type) #only epilimnion
length(data$Sample.type[which(data$Sample.type=="Epilimnion")])#all 16 specified as epi
length(data$Type.of.sample[which(data$Type.of.sample=="G")]) #16 grab
length(data$Type.of.sample[which(data$Type.of.sample=="C")]) #0 integrated
16+0 #adds up to total
data.Export$SampleType[which(data$Type.of.sample=="G")]= "GRAB"
data.Export$SampleType[which(data$Type.of.sample=="C")]= "INTEGRATED"
#check to make sure adds up to total
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")])
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
length(data$Sample.depth_m[which(is.na(data$Sample.depth_m)==TRUE)]) #all sample depths filled = good
data.Export$SamplePosition[which(data$Sample.type=="Epilimnion")]="EPI"
data.Export$SamplePosition[which(is.na(data$Sample.type)==TRUE)]="SPECIFIED"
#check to make sure adds up to total
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")])
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
#assign sampledepth 
length(data$Sample.depth_m[which(is.na(data$Sample.depth_m)==FALSE)]) #check for missing depth values=none
data.Export$SampleDepth= data$Sample.depth_m
unique(data$Sample.depth_m)
#continue populating other lagos fields
unique(data$Sample.location) #if 1 set BasinType to PRIMARY if 2 set BasinType to UNKNOWN
data.Export$BasinType=as.character(data.Export$BasinType)
data$Sample.location=as.character(data$Sample.location)
data.Export$BasinType[which(data$Sample.location=="1")]="PRIMARY"
data.Export$BasinType[which(data$Sample.location=="2")]="UNKNOWN"
data.Export$BasinType[which(is.na(data$Sample.location)==TRUE)]="UNKNOWN"
#check to make sure adds to total
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")])
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")])
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
#populate detection limit
data.Export$DetectionLimit= (1/16.13) * 1000
unique(data.Export$DetectionLimit)
unique(data$SiteObservations) #don't export these comments
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data$NO3_Flag=="E, <MRL 1")]= "ESTIMATED"
unique(data.Export$Comments)
no3.Final = data.Export
rm(data.Export)
rm(data)
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/ME data/Acadia (Finished)/DataImport_ME_ANP_post_2006/DataImport_ME_ANP_post_2006.RData")

###################################  NO2+NO3_mg/L  #############################################################################################################################
data= Acadia.post2006.Chem
names(data) #just looking at column names
length(data$NO2.NO3_mg.L[which(is.na(data$NO2.NO3_mg.L)==TRUE)]) #199 values are null, remove
length(data$NO2.NO3_mg.L[which(data$NO2.NO3_mg.L=="NULL")]) #none are "NULL"
unique(data$NO2.NO3_mg.L) #checking to make sure there aren't other values that may represent null
210-199 #should be left with 11 after filtering
data=data[which(is.na(data$NO2.NO3_mg.L)==FALSE),]
data = data[,c(1:2,6:10,15:16,42)] #filtering out columns of interest
unique(data$NO2.NO3_Flag) #one unique flag with MRL
#no other filtering that needs to be done
#proceed to populating LAGOS template

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$MIDAS #set to MIDAS the unique lake id scheme in Maine
data.Export$LakeName = data$Lake.name
data.Export$SourceVariableName = "NO2+NO3_mg/L"
data.Export$SourceVariableDescription = "Nitrite (NO2) + Nitrate (NO3)"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=data$NO2.NO3_Flag
unique(data$NO2.NO3_Flag)
#continue populating other lagos variables
data.Export$LagosVariableID = 18
data.Export$LagosVariableName="Nitrogen, nitrite (NO2) + nitrate (NO3)"
names(data)
data.Export$Value = (data[,8])*1000 #export no3no2 and * 1000 to go from mg/L to pref. ug/L
#populate CensorCode based on flags
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$NO2.NO3_Flag=="E, <MRL 0.016")]="LT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]=NA 
unique(data.Export$CensorCode)
#check to make sure all CensorCode populated
length(data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)])
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])
#continue with others
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
unique(data$Type.of.sample) #G=grab, C= integrated epi
unique(data$Sample.type) #only epilimnion
length(data$Sample.type[which(data$Sample.type=="Epilimnion")])#all 11 specified as epi
length(data$Type.of.sample[which(data$Type.of.sample=="G")]) #1 grab
length(data$Type.of.sample[which(data$Type.of.sample=="C")]) #10 integrated
10+1 #adds up to total
data.Export$SampleType[which(data$Type.of.sample=="G")]= "GRAB"
data.Export$SampleType[which(data$Type.of.sample=="C")]= "INTEGRATED"
#check to make sure adds up to total
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")])
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
length(data$Sample.depth_m[which(is.na(data$Sample.depth_m)==TRUE)]) #all sample depths filled = good
data.Export$SamplePosition[which(data$Sample.type=="Epilimnion")]="EPI"
data.Export$SamplePosition[which(is.na(data$Sample.type)==TRUE)]="SPECIFIED"
#check to make sure adds up to total
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")])
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
#assign sampledepth 
length(data$Sample.depth_m[which(is.na(data$Sample.depth_m)==FALSE)]) #check for missing depth values=none
data.Export$SampleDepth= data$Sample.depth_m
unique(data$Sample.depth_m)
#continue populating other lagos fields
unique(data$Sample.location) #if 1 set BasinType to PRIMARY if 2 set BasinType to UNKNOWN
data.Export$BasinType=as.character(data.Export$BasinType)
data$Sample.location=as.character(data$Sample.location)
data.Export$BasinType[which(data$Sample.location=="1")]="PRIMARY"
data.Export$BasinType[which(data$Sample.location=="2")]="UNKNOWN"
data.Export$BasinType[which(is.na(data$Sample.location)==TRUE)]="UNKNOWN"
#check to make sure adds to total
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")])
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")])
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= (.016*1000)
unique(data.Export$DetectionLimit)
unique(data$SiteObservations) #don't export these comments
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data$NO2.NO3_Flag=="E, <MRL 0.016")]="ESTIMATED"
unique(data.Export$Comments)
no3no2.Final = data.Export
rm(data.Export)
rm(data)
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/ME data/Acadia (Finished)/DataImport_ME_ANP_post_2006/DataImport_ME_ANP_post_2006.RData")

###################################  TN_mg/L  #############################################################################################################################
data= Acadia.post2006.Chem
names(data) #just looking at column names
length(data$TN_mg.L[which(is.na(data$TN_mg.L)==TRUE)]) #41 values are null, remove
length(data$TN_mg.L[which(data$TN_mg.L=="NULL")]) #none are "NULL"
unique(data$TN_mg.L) #checking to make sure there aren't other values that may represent null
210-41 #should be left with 169 after filtering
data=data[which(is.na(data$TN_mg.L)==FALSE),]
data = data[,c(1:2,6:10,13:14,42)] #filtering out columns of interest
unique(data$TN_Flag) #one unique flag with MRL
#no other filtering that needs to be done
#proceed to populating LAGOS template

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$MIDAS #set to MIDAS the unique lake id scheme in Maine
data.Export$LakeName = data$Lake.name
data.Export$SourceVariableName = "TN_mg/L"
data.Export$SourceVariableDescription = "Total nitrogen"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no flags attached to these obs anyhow
unique(data.Export$SourceFlags)
#continue populating other lagos variables
data.Export$LagosVariableID = 21
data.Export$LagosVariableName="Nitrogen, total"
names(data)
data.Export$Value = (data[,8])*1000 #export tn and * 1000 to go from mg/L to pref. ug/L
#populate CensorCode based on flags
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode=NA #no flags attached to these obs.
#check to make sure all CensorCode populated
length(data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)])
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])
#continue with others
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
unique(data$Type.of.sample) #G=grab, C= integrated epi
unique(data$Sample.type) #only epilimnion
length(data$Sample.type[which(data$Sample.type=="Epilimnion")])#all 169 specified as epi
length(data$Type.of.sample[which(data$Type.of.sample=="G")]) #68 grab
length(data$Type.of.sample[which(data$Type.of.sample=="C")]) #101 integrated
101+68 #adds up to total
data.Export$SampleType[which(data$Type.of.sample=="G")]= "GRAB"
data.Export$SampleType[which(data$Type.of.sample=="C")]= "INTEGRATED"
#check to make sure adds up to total
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")])
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
length(data$Sample.depth_m[which(is.na(data$Sample.depth_m)==TRUE)]) #all sample depths filled = good
data.Export$SamplePosition[which(data$Sample.type=="Epilimnion")]="EPI"
data.Export$SamplePosition[which(is.na(data$Sample.type)==TRUE)]="SPECIFIED"
#check to make sure adds up to total
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")])
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
#assign sampledepth 
length(data$Sample.depth_m[which(is.na(data$Sample.depth_m)==FALSE)]) #check for missing depth values=none
data.Export$SampleDepth= data$Sample.depth_m
unique(data$Sample.depth_m)
#continue populating other lagos fields
unique(data$Sample.location) #if 1 set BasinType to PRIMARY if 2 set BasinType to UNKNOWN
data.Export$BasinType=as.character(data.Export$BasinType)
data$Sample.location=as.character(data$Sample.location)
data.Export$BasinType[which(data$Sample.location=="1")]="PRIMARY"
data.Export$BasinType[which(data$Sample.location=="2")]="UNKNOWN"
data.Export$BasinType[which(is.na(data$Sample.location)==TRUE)]="UNKNOWN"
#check to make sure adds to total
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")])
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")])
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= (0.06*1000)
unique(data.Export$DetectionLimit)
unique(data$SiteObservations) #don't export these comments
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA 
unique(data.Export$Comments)
tn.Final = data.Export
rm(data.Export)
rm(data)
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/ME data/Acadia (Finished)/DataImport_ME_ANP_post_2006/DataImport_ME_ANP_post_2006.RData")

################################### TP_ug/L #############################################################################################################################
data= Acadia.post2006.Chem
names(data) #just looking at column names
length(data$TP_ug.L[which(is.na(data$TP_ug.L)==TRUE)]) #90 values are null, remove
length(data$TP_ug.L[which(data$TP_ug.L=="NULL")]) #none are "NULL"
unique(data$TP_ug.L) #checking to make sure there aren't other values that may represent null
210-90 #should be left with 120 after filtering
data=data[which(is.na(data$TP_ug.L)==FALSE),]
data = data[,c(1:2,6:10,11:12,42)] #filtering out columns of interest
unique(data$TP_Flag) #one unique flag with MRL
#no other filtering that needs to be done
#proceed to populating LAGOS template

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$MIDAS #set to MIDAS the unique lake id scheme in Maine
data.Export$LakeName = data$Lake.name
data.Export$SourceVariableName = "TP_ug/L"
data.Export$SourceVariableDescription = "Total phosphorus"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=data$TP_Flag
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags[which(data.Export$SourceFlags=="")]=NA
unique(data.Export$SourceFlags)
#continue populating other lagos variables
data.Export$LagosVariableID = 27
data.Export$LagosVariableName="Phosphorus, total"
names(data)
data.Export$Value = (data[,8]) #export tp obs. alreadyin pref. units of ug/
#populate CensorCode based on flags
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$TP_Flag=="E, <MRL 4")]="LT"
data.Export$CensorCode[which(data$TP_Flag=="E, <MRL 20")]="LT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]=NA 
unique(data.Export$CensorCode)
#check to make sure all CensorCode populated
length(data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)])
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])
#continue with others
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
unique(data$Type.of.sample) #G=grab, C= integrated epi
unique(data$Sample.type) #only epilimnion
length(data$Sample.type[which(data$Sample.type=="Epilimnion")])#all 120 specified as epi
length(data$Type.of.sample[which(data$Type.of.sample=="G")]) #11 grab
length(data$Type.of.sample[which(data$Type.of.sample=="C")]) #109 integrated
109+11 #adds up to total
data.Export$SampleType[which(data$Type.of.sample=="G")]= "GRAB"
data.Export$SampleType[which(data$Type.of.sample=="C")]= "INTEGRATED"
#check to make sure adds up to total
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")])
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
length(data$Sample.depth_m[which(is.na(data$Sample.depth_m)==TRUE)]) #all sample depths filled = good
data.Export$SamplePosition[which(data$Sample.type=="Epilimnion")]="EPI"
data.Export$SamplePosition[which(is.na(data$Sample.type)==TRUE)]="SPECIFIED"
#check to make sure adds up to total
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")])
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
#assign sampledepth 
length(data$Sample.depth_m[which(is.na(data$Sample.depth_m)==FALSE)]) #check for missing depth values=none
data.Export$SampleDepth= data$Sample.depth_m
unique(data$Sample.depth_m)
#continue populating other lagos fields
unique(data$Sample.location) #if 1 set BasinType to PRIMARY if 2 set BasinType to UNKNOWN
data.Export$BasinType=as.character(data.Export$BasinType)
data$Sample.location=as.character(data$Sample.location)
data.Export$BasinType[which(data$Sample.location=="1")]="PRIMARY"
data.Export$BasinType[which(data$Sample.location=="2")]="UNKNOWN"
data.Export$BasinType[which(is.na(data$Sample.location)==TRUE)]="UNKNOWN"
#check to make sure adds to total
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")])
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")])
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit[which(data$TP_Flag=="E, <MRL 4")]= 4
data.Export$DetectionLimit[which(data$TP_Flag=="E, <MRL 20")]= 20
data.Export$DetectionLimit[which(is.na(data.Export$DetectionLimit)==TRUE)]=4
unique(data.Export$DetectionLimit)
unique(data$SiteObservations) #don't export these comments
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data$TP_Flag=="E, <MRL 4")]="ESTIMATED"
data.Export$Comments[which(data$TP_Flag=="E, <MRL 20")]="ESTIMATED"
unique(data.Export$Comments)
tp.Final = data.Export
rm(data.Export)
rm(data)
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/ME data/Acadia (Finished)/DataImport_ME_ANP_post_2006/DataImport_ME_ANP_post_2006.RData")

################################### SecchiDepth_m #############################################################################################################################
data= Acadia.post2006.Chem
names(data) #just looking at column names
length(data$SecchiDepth_m[which(is.na(data$SecchiDepth_m)==TRUE)]) #3 values are null, remove
length(data$SecchiDepth_m[which(data$SecchiDepth_m=="NULL")]) #none are "NULL"
unique(data$SecchiDepth_m) #checking to make sure there aren't other values that may represent null
210-3 #should be left with 207 after filtering
data=data[which(is.na(data$SecchiDepth_m)==FALSE),]
data = data[,c(1:2,6:10,25:26,42)] #filtering out columns of interest
unique(data$Disk.hit.bottom.) #one unique flag which is "B" meaning disk hit bottom, where B assign CensorCode of "GT"
#no other filtering that needs to be done
#proceed to populating LAGOS template

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$MIDAS #set to MIDAS the unique lake id scheme in Maine
data.Export$LakeName = data$Lake.name
data.Export$SourceVariableName = "SecchiDepth_m"
data.Export$SourceVariableDescription = "Secchi depth w/view scope and viewing scope with a mask was used from 1996-2005"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=data$Disk.hit.bottom.
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags[which(data.Export$SourceFlags=="")]=NA
unique(data.Export$SourceFlags)
#continue populating other lagos variables
data.Export$LagosVariableID = 30
data.Export$LagosVariableName="Secchi"
names(data)
data.Export$Value = (data[,8]) #export secchi obs. alreadyin pref. units of m
#populate CensorCode based on flags
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$Disk.hit.bottom.=="B")]="GT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]=NA 
unique(data.Export$CensorCode)
#check to make sure all CensorCode populated
length(data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)])
length(data.Export$CensorCode[which(data.Export$CensorCode=="GT")])
#continue with others
data.Export$Date = data$Date #date already in correct format
data.Export$Units="m"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
unique(data$Type.of.sample) #G=grab, C= integrated epi
unique(data$Sample.type) #only epilimnion
length(data$Sample.type[which(data$Sample.type=="Epilimnion")])#all 207 specified as epi
length(data$Type.of.sample[which(data$Type.of.sample=="G")]) #88 grab
length(data$Type.of.sample[which(data$Type.of.sample=="C")]) #119 integrated
119+88 #adds up to total
data.Export$SampleType= "INTEGRATED"
#check to make sure adds up to total
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")])
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
length(data$Sample.depth_m[which(is.na(data$Sample.depth_m)==TRUE)]) #all sample depths filled = good
data.Export$SamplePosition= "SPECIFIED"
#check to make sure adds up to total
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")])
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
#assign sampledepth 
length(data$Sample.depth_m[which(is.na(data$Sample.depth_m)==FALSE)]) #check for missing depth values=none
data.Export$SampleDepth= NA
unique(data.Export$SampleDepth)
#continue populating other lagos fields
unique(data$Sample.location) #if 1 set BasinType to PRIMARY if 2 set BasinType to UNKNOWN
data.Export$BasinType=as.character(data.Export$BasinType)
data$Sample.location=as.character(data$Sample.location)
data.Export$BasinType[which(data$Sample.location=="1")]="PRIMARY"
data.Export$BasinType[which(data$Sample.location=="2")]="UNKNOWN"
data.Export$BasinType[which(is.na(data$Sample.location)==TRUE)]="UNKNOWN"
#check to make sure adds to total
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")])
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")])
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = "SECCHI_VIEW"
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit=NA
unique(data.Export$DetectionLimit)
unique(data$SiteObservations) #don't export these comments
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments= NA
unique(data.Export$Comments)
secchi.Final = data.Export
rm(data.Export)
rm(data)
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/ME data/Acadia (Finished)/DataImport_ME_ANP_post_2006/DataImport_ME_ANP_post_2006.RData")

###################################### final export ########################################################################################
Final.Export = rbind(acolor.Final,chla.Final,doc.Final,nh3.Final,nh4.Final,no3.Final,no3no2.Final,secchi.Final,tcolor.Final,tn.Final,tp.Final)
write.table(Final.Export,file="DataImport_ME_ANP_post_2006.csv",row.names=FALSE,sep=",")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/ME data/Acadia (Finished)/DataImport_ME_ANP_post_2006/DataImport_ME_ANP_post_2006.RData")
