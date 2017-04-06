#path to files
setwd("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/ME data/Acadia (Finished)/DataImport_ME_ANP_pre_2006")
setwd("C:/Users/Sam/Dropbox/CSI-LIMNO_DATA/DATA-lake/ME data/Acadia (Finished)/DataImport_ME_ANP_pre_2006")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/ME data/Acadia (Finished)/DataImport_ME_ANP_pre_2006/DataImport_ME_ANP_pre_2006.RData")


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
#similar to ME DEP
#see data import log for details on variables
###########################################################################################################################################################################################
################################### DOC_mg/L #############################################################################################################################
data= Acadia.pre2006.Chem
names(data) #just looking at column names
length(data$DOC_mg.L[which(is.na(data$DOC_mg.L)==TRUE)]) #210 values are null for DOC, remove
length(data$DOC_mg.L[which(data$DOC_mg.L=="NULL")]) #none are "NULL"
unique(data$DOC_mg.L) #checking to make sure there aren't other values that may represent null
368-210 #should be left with 158 after filtering
data=data[which(is.na(data$DOC_mg.L)==FALSE),]
data = data[,c(1:2,6:9,14,35)] #filtering out columns of interest
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
data.Export$SourceFlags=NA #no info on source flags
#continue populating other lagos variables
data.Export$LagosVariableID = 6
data.Export$LagosVariableName="Carbon, dissolved organic"
data.Export$Value = data[,7] #export doc values, no conversion necessary
data.Export$CensorCode = NA #no infor on CensorCode
data.Export$Date = data$Date #date already in correct format
data.Export$Units="mg/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
unique(data$Type.of.sample) #G=grab, C= integrated epi
length(data$Type.of.sample[which(data$Type.of.sample=="G")]) #77 grab
length(data$Type.of.sample[which(data$Type.of.sample=="C")]) #81 integrated
77+81 #adds up to total
data.Export$SampleType[which(data$Type.of.sample=="G")]= "GRAB"
data.Export$SampleType[which(data$Type.of.sample=="C")]= "INTEGRATED"
#check to make sure adds up to total
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")])
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
length(data$Sample.depth_m[which(is.na(data$Sample.depth_m)==TRUE)]) #all sample depths filled = good
data.Export$SamplePosition[which(data.Export$SampleType=="GRAB")]= "SPECIFIED"
data.Export$SamplePosition[which(data.Export$SampleType=="INTEGRATED")]= "EPI"
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
unique(data$COMMENTS) #don't export these comments, related to analytical procedure not field notes
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments= NA 
doc.Final = data.Export
rm(data.Export)
rm(data)


################################### ChlA_ug/L  #############################################################################################################################
data= Acadia.pre2006.Chem
names(data) #just looking at column names
length(data$ChlA_ug.L[which(is.na(data$ChlA_ug.L)==TRUE)]) #220 values are null, remove
length(data$ChlA_ug.L[which(data$ChlA_ug.L=="NULL")]) #none are "NULL"
unique(data$ChlA_ug.L) #checking to make sure there aren't other values that may represent null
368-220 #should be left with 148 after filtering
data=data[which(is.na(data$ChlA_ug.L)==FALSE),]
data = data[,c(1:2,6:9,13,35)] #filtering out columns of interest
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
data.Export$SourceFlags=NA #no info on source flags
#continue populating other lagos variables
data.Export$LagosVariableID = 9
data.Export$LagosVariableName="Chlorophyll a"
data.Export$Value = data[,7] #export chla values,already in preff. ug/L
data.Export$CensorCode = NA #no infor on CensorCode
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
unique(data$Type.of.sample) #G=grab, C= integrated epi
length(data$Type.of.sample[which(data$Type.of.sample=="G")]) #28 grab
length(data$Type.of.sample[which(data$Type.of.sample=="C")]) #120 integrated
28+120 #adds up to total
data.Export$SampleType[which(data$Type.of.sample=="G")]= "GRAB"
data.Export$SampleType[which(data$Type.of.sample=="C")]= "INTEGRATED"
#check to make sure adds up to total
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")])
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
length(data$Sample.depth_m[which(is.na(data$Sample.depth_m)==TRUE)]) #all sample depths filled = good
data.Export$SamplePosition[which(data.Export$SampleType=="GRAB")]= "SPECIFIED"
data.Export$SamplePosition[which(data.Export$SampleType=="INTEGRATED")]= "EPI"
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
unique(data$COMMENTS) #don't export these comments, related to analytical procedure not field notes
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments= NA 
chla.Final = data.Export
rm(data.Export)
rm(data)


################################### ApparentColor_PCU #############################################################################################################################
data= Acadia.pre2006.Chem
names(data) #just looking at column names
length(data$ApparentColor_PCU[which(is.na(data$ApparentColor_PCU)==TRUE)]) #312 values are null, remove
length(data$ApparentColor_PCU[which(data$ApparentColor_PCU=="NULL")]) #none are "NULL"
unique(data$ApparentColor_PCU) #checking to make sure there aren't other values that may represent null
368-312 #should be left with 56 after filtering
data=data[which(is.na(data$ApparentColor_PCU)==FALSE),]
data = data[,c(1:2,6:9,16,35)] #filtering out columns of interest
#no other filtering that needs to be done
#proceed to populating LAGOS template

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$MIDAS #set to MIDAS the unique lake id scheme in Maine
data.Export$LakeName = data$Lake.name
data.Export$SourceVariableName ="ApparentColor_PCU"
data.Export$SourceVariableDescription = "Apparent color"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no info on source flags
#continue populating other lagos variables
data.Export$LagosVariableID = 11
data.Export$LagosVariableName="Color, apparent"
data.Export$Value = data[,7] #export a color values,already in preff. units
data.Export$CensorCode = NA #no infor on CensorCode
data.Export$Date = data$Date #date already in correct format
data.Export$Units="PCU"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
unique(data$Type.of.sample) #G=grab, C= integrated epi
length(data$Type.of.sample[which(data$Type.of.sample=="G")]) #22 grab
length(data$Type.of.sample[which(data$Type.of.sample=="C")]) #34 integrated
22+34 #adds up to total
data.Export$SampleType[which(data$Type.of.sample=="G")]= "GRAB"
data.Export$SampleType[which(data$Type.of.sample=="C")]= "INTEGRATED"
#check to make sure adds up to total
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")])
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
length(data$Sample.depth_m[which(is.na(data$Sample.depth_m)==TRUE)]) #all sample depths filled = good
data.Export$SamplePosition[which(data.Export$SampleType=="GRAB")]= "SPECIFIED"
data.Export$SamplePosition[which(data.Export$SampleType=="INTEGRATED")]= "EPI"
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
data.Export$MethodInfo = NA #not applicable to acolor
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #no info in metadata
unique(data$COMMENTS) #don't export these comments, related to analytical procedure not field notes
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments= NA 
acolor.Final = data.Export
rm(data.Export)
rm(data)


################################### TrueColor_PCU #############################################################################################################################
data= Acadia.pre2006.Chem
names(data) #just looking at column names
length(data$TrueColor_PCU[which(is.na(data$TrueColor_PCU)==TRUE)]) #197 values are null, remove
length(data$TrueColor_PCU[which(data$TrueColor_PCU=="NULL")]) #none are "NULL"
unique(data$TrueColor_PCU) #checking to make sure there aren't other values that may represent null
368-197 #should be left with 171 after filtering
data=data[which(is.na(data$TrueColor_PCU)==FALSE),]
data = data[,c(1:2,6:9,15,35)] #filtering out columns of interest
#no other filtering that needs to be done
#proceed to populating LAGOS template

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$MIDAS #set to MIDAS the unique lake id scheme in Maine
data.Export$LakeName = data$Lake.name
data.Export$SourceVariableName ="TrueColor_PCU"
data.Export$SourceVariableDescription = "True color"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no info on source flags
#continue populating other lagos variables
data.Export$LagosVariableID = 12
data.Export$LagosVariableName="Color, true"
data.Export$Value = data[,7] #export t color values,already in preff. units
data.Export$CensorCode = NA #no infor on CensorCode
data.Export$Date = data$Date #date already in correct format
data.Export$Units="PCU"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
unique(data$Type.of.sample) #G=grab, C= integrated epi
length(data$Type.of.sample[which(data$Type.of.sample=="G")]) #79 grab
length(data$Type.of.sample[which(data$Type.of.sample=="C")]) #92 integrated
79+92 #adds up to total
data.Export$SampleType[which(data$Type.of.sample=="G")]= "GRAB"
data.Export$SampleType[which(data$Type.of.sample=="C")]= "INTEGRATED"
#check to make sure adds up to total
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")])
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
length(data$Sample.depth_m[which(is.na(data$Sample.depth_m)==TRUE)]) #all sample depths filled = good
data.Export$SamplePosition[which(data.Export$SampleType=="GRAB")]= "SPECIFIED"
data.Export$SamplePosition[which(data.Export$SampleType=="INTEGRATED")]= "EPI"
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
data.Export$MethodInfo = NA #not applicable to tcolor
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #no info in metadata
unique(data$COMMENTS) #don't export these comments, related to analytical procedure not field notes
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments= NA 
tcolor.Final = data.Export
rm(data.Export)
rm(data)


################################### NH4_mg/L  #############################################################################################################################
data= Acadia.pre2006.Chem
names(data) #just looking at column names
length(data$NH4_mg.L[which(is.na(data$NH4_mg.L)==TRUE)]) #314 values are null, remove
length(data$NH4_mg.L[which(data$NH4_mg.L=="NULL")]) #none are "NULL"
unique(data$NH4_mg.L) #checking to make sure there aren't other values that may represent null
368-314 #should be left with 54 after filtering
data=data[which(is.na(data$NH4_mg.L)==FALSE),]
data = data[,c(1:2,6:9,28,35)] #filtering out columns of interest
#no other filtering that needs to be done
#proceed to populating LAGOS template

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$MIDAS #set to MIDAS the unique lake id scheme in Maine
data.Export$LakeName = data$Lake.name
data.Export$SourceVariableName ="NH4_mg/L"
data.Export$SourceVariableDescription = "Ammonium (NH4)"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no info on source flags
#continue populating other lagos variables
data.Export$LagosVariableID = 19
data.Export$LagosVariableName="Nitrogen, NH4"
names(data)
data.Export$Value = data[,7]*1000 #export nh4 values and *1000 to go from mg/L to pref. units of ug/L
data.Export$CensorCode = NA #no infor on CensorCode
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
unique(data$Type.of.sample) #G=grab, C= integrated epi
length(data$Type.of.sample[which(data$Type.of.sample=="G")]) #54 grab
length(data$Type.of.sample[which(data$Type.of.sample=="C")]) #0 integrated
54+0 #adds up to total
data.Export$SampleType[which(data$Type.of.sample=="G")]= "GRAB"
data.Export$SampleType[which(data$Type.of.sample=="C")]= "INTEGRATED"
#check to make sure adds up to total
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")])
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
length(data$Sample.depth_m[which(is.na(data$Sample.depth_m)==TRUE)]) #all sample depths filled = good
data.Export$SamplePosition[which(data.Export$SampleType=="GRAB")]= "SPECIFIED"
data.Export$SamplePosition[which(data.Export$SampleType=="INTEGRATED")]= "EPI"
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
data.Export$MethodInfo = NA #not applicable 
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #no info in metadata
unique(data$COMMENTS) #don't export these comments, related to analytical procedure not field notes
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments= NA 
nh4.Final = data.Export
rm(data.Export)
rm(data)

################################### TN_mg/L     #############################################################################################################################
data= Acadia.pre2006.Chem
names(data) #just looking at column names
length(data$TN_mg.L[which(is.na(data$TN_mg.L)==TRUE)]) #314 values are null, remove
length(data$TN_mg.L[which(data$TN_mg.L=="NULL")]) #none are "NULL"
unique(data$TN_mg.L) #checking to make sure there aren't other values that may represent null
368-183 #should be left with 185 after filtering
data=data[which(is.na(data$TN_mg.L)==FALSE),]
data = data[,c(1:2,6:9,11,35)] #filtering out columns of interest
#no other filtering that needs to be done
#proceed to populating LAGOS template

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$MIDAS #set to MIDAS the unique lake id scheme in Maine
data.Export$LakeName = data$Lake.name
data.Export$SourceVariableName ="TN_mg/L"
data.Export$SourceVariableDescription = "Total nitrogen"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no info on source flags
#continue populating other lagos variables
data.Export$LagosVariableID = 21
data.Export$LagosVariableName="Nitrogen, total"
names(data)
data.Export$Value = data[,7]*1000 #export tn values and *1000 to go from mg/L to pref. units of ug/L
data.Export$CensorCode = NA #no infor on CensorCode
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
unique(data$Type.of.sample) #G=grab, C= integrated epi
length(data$Type.of.sample[which(data$Type.of.sample=="G")]) #81 grab
length(data$Type.of.sample[which(data$Type.of.sample=="C")]) #104 integrated
81+104 #adds up to total
data.Export$SampleType[which(data$Type.of.sample=="G")]= "GRAB"
data.Export$SampleType[which(data$Type.of.sample=="C")]= "INTEGRATED"
#check to make sure adds up to total
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")])
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
length(data$Sample.depth_m[which(is.na(data$Sample.depth_m)==TRUE)]) #all sample depths filled = good
data.Export$SamplePosition[which(data.Export$SampleType=="GRAB")]= "SPECIFIED"
data.Export$SamplePosition[which(data.Export$SampleType=="INTEGRATED")]= "EPI"
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
data.Export$MethodInfo = NA #not applicable 
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #no info in metadata
unique(data$COMMENTS) #don't export these comments, related to analytical procedure not field notes
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments= NA 
tn.Final = data.Export
rm(data.Export)
rm(data)


################################### TP_ug/L   #############################################################################################################################
data= Acadia.pre2006.Chem
names(data) #just looking at column names
length(data$TP_ug.L[which(is.na(data$TP_ug.L)==TRUE)]) #104 values are null, remove
length(data$TP_ug.L[which(data$TP_ug.L=="NULL")]) #none are "NULL"
unique(data$TP_ug.L) #checking to make sure there aren't other values that may represent null
368-104 #should be left with 264 after filtering
data=data[which(is.na(data$TP_ug.L)==FALSE),]
data = data[,c(1:2,6:9,10,35)] #filtering out columns of interest
#no other filtering that needs to be done
#proceed to populating LAGOS template

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$MIDAS #set to MIDAS the unique lake id scheme in Maine
data.Export$LakeName = data$Lake.name
data.Export$SourceVariableName ="TP_ug/L"
data.Export$SourceVariableDescription = "Total phosphorus"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no info on source flags
#continue populating other lagos variables
data.Export$LagosVariableID = 27
data.Export$LagosVariableName="Phosphorus, total"
names(data)
data.Export$Value = data[,7] #export tp values already in preff. units of ug/l
data.Export$CensorCode = NA #no infor on CensorCode
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
unique(data$Type.of.sample) #G=grab, C= integrated epi
length(data$Type.of.sample[which(data$Type.of.sample=="G")]) #58 grab
length(data$Type.of.sample[which(data$Type.of.sample=="C")]) #206 integrated
58+206 #adds up to total
data.Export$SampleType[which(data$Type.of.sample=="G")]= "GRAB"
data.Export$SampleType[which(data$Type.of.sample=="C")]= "INTEGRATED"
#check to make sure adds up to total
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")])
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
length(data$Sample.depth_m[which(is.na(data$Sample.depth_m)==TRUE)]) #all sample depths filled = good
data.Export$SamplePosition[which(data.Export$SampleType=="GRAB")]= "SPECIFIED"
data.Export$SamplePosition[which(data.Export$SampleType=="INTEGRATED")]= "EPI"
#check to make sure adds up to total
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")])
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
#assign sampledepth 
length(data$Sample.depth_m[which(is.na(data$Sample.depth_m)==FALSE)]) #check for missing depth values=none
data.Export$SampleDepth= data$Sample.depth_m
unique(data$Sample.depth_m)
#continue populating other lagos fields
unique(data$Sample.location) #if 1 set BasinType to PRIMARY if 2 or other numbers set BasinType to UNKNOWN
data.Export$BasinType=as.character(data.Export$BasinType)
data$Sample.location=as.character(data$Sample.location)
data.Export$BasinType[which(data$Sample.location=="1")]="PRIMARY"
data.Export$BasinType[which(data$Sample.location=="2")]="UNKNOWN"
data.Export$BasinType[which(data$Sample.location=="3")]="UNKNOWN"
data.Export$BasinType[which(data$Sample.location=="4")]="UNKNOWN"
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
unique(data$COMMENTS) #don't export these comments, related to analytical procedure not field notes
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments= NA 
tp.Final = data.Export
rm(data.Export)
rm(data)


###################################  SecchiDepth_m  #############################################################################################################################
data= Acadia.pre2006.Chem
names(data) #just looking at column names
length(data$SecchiDepth_m[which(is.na(data$SecchiDepth_m)==TRUE)]) #2 values are null, remove
length(data$SecchiDepth_m[which(data$SecchiDepth_m=="NULL")]) #none are "NULL"
unique(data$SecchiDepth_m) #checking to make sure there aren't other values that may represent null
368-2 #should be left with 366 after filtering
data=data[which(is.na(data$SecchiDepth_m)==FALSE),]
data = data[,c(1:2,6:9,17,35)] #filtering out columns of interest
#no other filtering that needs to be done
#proceed to populating LAGOS template

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$MIDAS #set to MIDAS the unique lake id scheme in Maine
data.Export$LakeName = data$Lake.name
data.Export$SourceVariableName ="SecchiDepth_m"
data.Export$SourceVariableDescription = "Secchi depth w/view scope and viewing scope with a mask was used from 1996-2005"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no info on source flags
#continue populating other lagos variables
data.Export$LagosVariableID = 30
data.Export$LagosVariableName="Secchi"
names(data)
data.Export$Value = data[,7] #export secchi values, already in preff units of meters
data.Export$CensorCode = NA #no infor on CensorCode
data.Export$Date = data$Date #date already in correct format
data.Export$Units="m"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED"
#check to make sure adds up to total
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")])
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
length(data$Sample.depth_m[which(is.na(data$Sample.depth_m)==TRUE)]) #all sample depths filled = good
data.Export$SamplePosition="SPECIFIED"
#check to make sure adds up to total
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")])
#assign sampledepth 
length(data$Sample.depth_m[which(is.na(data$Sample.depth_m)==FALSE)]) #check for missing depth values=none
data.Export$SampleDepth= NA #because secchi
unique(data.Export$SampleDepth)
#continue populating other lagos fields
unique(data$Sample.location) #if 1 set BasinType to PRIMARY if 2 or other numbers set BasinType to UNKNOWN
data.Export$BasinType=as.character(data.Export$BasinType)
data$Sample.location=as.character(data$Sample.location)
data.Export$BasinType[which(data$Sample.location=="1")]="PRIMARY"
data.Export$BasinType[which(data$Sample.location=="2")]="UNKNOWN"
data.Export$BasinType[which(data$Sample.location=="3")]="UNKNOWN"
data.Export$BasinType[which(data$Sample.location=="4")]="UNKNOWN"
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
data.Export$DetectionLimit= NA #no info in metadata
unique(data$COMMENTS) #don't export these comments, related to analytical procedure not field notes
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments= NA 
secchi.Final = data.Export
rm(data.Export)
rm(data)



###################################### final export ########################################################################################
Final.Export = rbind(acolor.Final,chla.Final,doc.Final,nh4.Final,secchi.Final,tcolor.Final,tn.Final,tp.Final)
#############################################
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
128+1274#adds up to total
##write table
Final.Export1=data1
typeof(Final.Export1$Value)
length(Final.Export1$Value[which(Final.Export1$Value<0)])
nosamplepos=Final.Export1[which(is.na(Final.Export1$SampleDepth)==TRUE & Final.Export1$SamplePosition=="UNKNOWN"),]
write.table(Final.Export1,file="DataImport_ME_ANP_pre_2006.csv",row.names=FALSE,sep=",")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/ME data/Acadia (Finished)/DataImport_ME_ANP_pre_2006/DataImport_ME_ANP_pre_2006.RData")