#set path to files
setwd("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/WI data/L_Position (Finished)/DataImport_WI_L_POSITION_CHEM")


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
#samples are "grab" except for secchi
#sample position is either epi or hypo (specified for secchi)
#no source flags or cenosred observations
###########################################################################################################################################################################################
###################################  doc   #############################################################################################################################
data=l_position_chem
head(data)#snapshot of schema
names(data)#column names
#pull out columns of interest
data=data[,c(1:4,6,26,27)]
names(data)
#filter out null obs
unique(data$doc)#look at values, check for problems
length(data$doc[which(is.na(data$doc)==TRUE)])
length(data$doc[which(data$doc=="")])
295-229#66 obs remain after filtering out null
data=data[which(is.na(data$doc)==FALSE),]
#check for replicates
unique(data$rep)
length(data$rep[which(data$rep=="2")])#check number of replicates
data=data[which(data$rep=="1"),]#filter out replicates
#check other variables
unique(data$depth)#only depths of 1 and 0, only one sample position= "epi"
unique(data$wbic)
length(data$wbic[which(is.na(data$wbic)==TRUE)])#FILTER THESE OUT
data=data[which(is.na(data$wbic)==FALSE),]
unique(data$project)


#done filtering
#proceed to populating LAGOS template


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$wbic
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$lake
data.Export$SourceVariableName = "doc"
data.Export$SourceVariableDescription = "Dissolved organic C"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 6
data.Export$LagosVariableName="Carbon, dissolved organic"
data.Export$Value=data$doc
unique(data.Export$Value)
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$sampledate#date already in correct format
data.Export$Units="mg/L"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="SPECIFIED"
unique(data.Export$SamplePosition)
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all GRAB

#assign sampledepth 
data.Export$SampleDepth=data$depth
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
data.Export$LabMethodInfo="DOC - determined by heated persulfate digestion. See NT LTER website - http://lter.limnology.wisc.edu/research/protocols"
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
doc.Final = data.Export
rm(data)
rm(data.Export)

###################################  toc   #############################################################################################################################
data=l_position_chem
head(data)#snapshot of schema
names(data)#column names
#pull out columns of interest
data=data[,c(1:4,8,26,27)]
names(data)
#filter out null obs
unique(data$toc)#look at values, check for problems
length(data$toc[which(is.na(data$toc)==TRUE)])
length(data$toc[which(data$toc=="")])
295-232#63 obs remain after filtering out null
data=data[which(is.na(data$toc)==FALSE),]
#check for replicates
unique(data$rep)
length(data$rep[which(data$rep=="2")])#check number of replicates
data=data[which(data$rep=="1"),]#filter out replicates
#check other variables
unique(data$depth)#only depths of 1 and 0, only one sample position= "epi"
unique(data$wbic)
length(data$wbic[which(is.na(data$wbic)==TRUE)])#FILTER THESE OUT
data=data[which(is.na(data$wbic)==FALSE),]
unique(data$project)


#done filtering
#proceed to populating LAGOS template


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$wbic
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$lake
data.Export$SourceVariableName = "toc"
data.Export$SourceVariableDescription = "Total organic carbon"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 7
data.Export$LagosVariableName="Carbon, total organic"
data.Export$Value=data$toc
unique(data.Export$Value)
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$sampledate#date already in correct format
data.Export$Units="mg/L"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="SPECIFIED"
unique(data.Export$SamplePosition)
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all GRAB

#assign sampledepth 
data.Export$SampleDepth=data$depth
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
data.Export$LabMethodInfo="TOC - determined by heated persulfate digestion. See NT LTER website - http://lter.limnology.wisc.edu/research/protocols"
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
toc.Final = data.Export
rm(data)
rm(data.Export)

################################### color253    #############################################################################################################################
data=l_position_chem
head(data)#snapshot of schema
names(data)#column names
#pull out columns of interest
data=data[,c(1:4,13,26,27)]
names(data)
#filter out null obs
unique(data$color253)#look at values, check for problems
length(data$color253[which(is.na(data$color253)==TRUE)])
length(data$color253[which(data$color253=="")])
295-242#53 obs remain after filtering out null
data=data[which(is.na(data$color253)==FALSE),]
#check for replicates
unique(data$rep)
length(data$rep[which(data$rep=="2")])#check number of replicates
data=data[which(data$rep=="1"),]#filter out replicates, no reps here doesn't make a difference
#check other variables
unique(data$depth)#only depths of 1 and 0, only one sample position= "epi"
length(data$depth[which(is.na(data$depth)==TRUE)])# one obs null, discard
data=data[which(is.na(data$depth)==FALSE),]
unique(data$wbic)
length(data$wbic[which(is.na(data$wbic)==TRUE)])#FILTER THESE OUT
data=data[which(is.na(data$wbic)==FALSE),]
unique(data$project)


#done filtering
#proceed to populating LAGOS template


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$wbic
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$lake
data.Export$SourceVariableName = "color253"
data.Export$SourceVariableDescription = "Color aborbance at 253 nm"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 12
data.Export$LagosVariableName="Color, true"
g_253=(2.303*data$color253)/(.10)
for_exp=-0.0169*(440-253)
g_440= g_253*exp(for_exp)
color_440=(18.216*g_440)-.209
data.Export$Value=color_440
unique(data.Export$Value)
data.Export$Value=round(data.Export$Value,digits=4)
unique(data.Export$Value)
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$sampledate#date already in correct format
data.Export$Units="PCU"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="SPECIFIED"
unique(data.Export$SamplePosition)
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all GRAB

#assign sampledepth 
data.Export$SampleDepth=data$depth
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
data.Export$LabMethodInfo="See NT LTER website - http://lter.limnology.wisc.edu/research/protocols "
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
color1.Final = data.Export
rm(data)
rm(data.Export)
rm(g_253)
rm(g_440)
rm(color_440)
rm(for_exp)

################################### color280   #############################################################################################################################
data=l_position_chem
head(data)#snapshot of schema
names(data)#column names
#pull out columns of interest
data=data[,c(1:4,12,26,27)]
names(data)
#filter out null obs
unique(data$color280)#look at values, check for problems
length(data$color280[which(is.na(data$color280)==TRUE)])
length(data$color280[which(data$color280=="")])
295-242#53 obs remain after filtering out null
data=data[which(is.na(data$color280)==FALSE),]
#check for replicates
unique(data$rep)
length(data$rep[which(data$rep=="2")])#check number of replicates
data=data[which(data$rep=="1"),]#filter out replicates, no reps here doesn't make a difference
#check other variables
unique(data$depth)#only depths of 1 and 0, only one sample position= "epi"
length(data$depth[which(is.na(data$depth)==TRUE)])# one obs null, discard
data=data[which(is.na(data$depth)==FALSE),]
unique(data$wbic)
length(data$wbic[which(is.na(data$wbic)==TRUE)])#FILTER THESE OUT
data=data[which(is.na(data$wbic)==FALSE),]
unique(data$project)


#done filtering
#proceed to populating LAGOS template


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$wbic
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$lake
data.Export$SourceVariableName = "color280"
data.Export$SourceVariableDescription = "Color absorbance at 280nm"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 12
data.Export$LagosVariableName="Color, true"
g_280=(2.303*data$color280)/(.10)
for_exp=-0.0169*(440-280)
g_440= g_280*exp(for_exp)
color_440=(18.216*g_440)-.209
data.Export$Value=color_440
unique(data.Export$Value)
data.Export$Value=round(data.Export$Value,digits=4)
unique(data.Export$Value)
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$sampledate#date already in correct format
data.Export$Units="PCU"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="SPECIFIED"
unique(data.Export$SamplePosition)
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all GRAB

#assign sampledepth 
data.Export$SampleDepth=data$depth
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
data.Export$LabMethodInfo="See NT LTER website - http://lter.limnology.wisc.edu/research/protocols "
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
color2.Final = data.Export
rm(data)
rm(data.Export)
rm(g_280)
rm(g_440)
rm(color_440)
rm(for_exp)

################################### color440   #############################################################################################################################
data=l_position_chem
head(data)#snapshot of schema
names(data)#column names
#pull out columns of interest
data=data[,c(1:4,11,26,27)]
names(data)
#filter out null obs
unique(data$color440)#look at values, check for problems
length(data$color440[which(is.na(data$color440)==TRUE)])
length(data$color440[which(data$color440=="")])
295-236#59 obs remain after filtering out null
data=data[which(is.na(data$color440)==FALSE),]
#check for replicates
unique(data$rep)
length(data$rep[which(data$rep=="2")])#check number of replicates
data=data[which(data$rep=="1"),]#filter out replicates, no reps here doesn't make a difference
#check other variables
unique(data$depth)#only depths of 1 and 0, only one sample position= "epi"
length(data$depth[which(is.na(data$depth)==TRUE)])# no obs null
data=data[which(is.na(data$depth)==FALSE),]
unique(data$wbic)
length(data$wbic[which(is.na(data$wbic)==TRUE)])#FILTER THESE OUT
data=data[which(is.na(data$wbic)==FALSE),]
unique(data$project)


#done filtering
#proceed to populating LAGOS template


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$wbic
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$lake
data.Export$SourceVariableName = "color440"
data.Export$SourceVariableDescription = "Color absorbance at 440 nm"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 12
data.Export$LagosVariableName="Color, true"
absorbance=data$color440
g_440=2.303*(absorbance/.10)
color_440= (18.216*g_440) - 0.209
data.Export$Value=color_440
unique(data.Export$Value)
data.Export$Value=round(data.Export$Value,digits=4)
unique(data.Export$Value)
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$sampledate#date already in correct format
data.Export$Units="PCU"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="SPECIFIED"
unique(data.Export$SamplePosition)
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all GRAB

#assign sampledepth 
data.Export$SampleDepth=data$depth
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
color3.Final = data.Export
rm(data)
rm(data.Export)
rm(absorbance)
rm(color_440)
rm(g_440)

################################### totnuf   #############################################################################################################################
data=l_position_chem
head(data)#snapshot of schema
names(data)#column names
#pull out columns of interest
data=data[,c(1:4,17,26,27)]
names(data)
#filter out null obs
unique(data$totnuf)#look at values, check for problems
length(data$totnuf[which(is.na(data$totnuf)==TRUE)])
length(data$totnuf[which(data$totnuf=="")])
295-37#258 obs remain after filtering out null
data=data[which(is.na(data$totnuf)==FALSE),]
#check for replicates
unique(data$rep)#no replicates here the below commands won't do anything
length(data$rep[which(data$rep=="2")])#check number of replicates
data=data[which(data$rep=="1"),]#filter out replicates, no reps here doesn't make a difference
#check other variables
unique(data$depth)#only depths of 1 and 0, only one sample position= "epi"
length(data$depth[which(is.na(data$depth)==TRUE)])# no obs null
data=data[which(is.na(data$depth)==FALSE),]
unique(data$wbic)
length(data$wbic[which(is.na(data$wbic)==TRUE)])#FILTER THESE OUT
data=data[which(is.na(data$wbic)==FALSE),]
unique(data$project)


#done filtering
#proceed to populating LAGOS template


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$wbic
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$lake
data.Export$SourceVariableName = "totnuf"
data.Export$SourceVariableDescription = "Total nitrogen"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 21
data.Export$LagosVariableName="Nitrogen, total"
data.Export$Value=data$totnuf
unique(data.Export$Value)
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$sampledate#date already in correct format
data.Export$Units="ug/L"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="SPECIFIED"
unique(data.Export$SamplePosition)
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all GRAB

#assign sampledepth 
data.Export$SampleDepth=data$depth
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
tn.Final = data.Export
rm(data)
rm(data.Export)

################################### totpuf   #############################################################################################################################
data=l_position_chem
head(data)#snapshot of schema
names(data)#column names
#pull out columns of interest
data=data[,c(1:4,16,26,27)]
names(data)
#filter out null obs
unique(data$totpuf)#look at values, check for problems
length(data$totpuf[which(is.na(data$totpuf)==TRUE)])
length(data$totpuf[which(data$totpuf=="")])
295-36#259 obs remain after filtering out null
data=data[which(is.na(data$totpuf)==FALSE),]
#check for replicates
unique(data$rep)#no replicates here the below commands won't do anything
length(data$rep[which(data$rep=="2")])#check number of replicates
data=data[which(data$rep=="1"),]#filter out replicates, no reps here doesn't make a difference
#check other variables
unique(data$depth)#only depths of 1 and 0, only one sample position= "epi"
length(data$depth[which(is.na(data$depth)==TRUE)])# no obs null
data=data[which(is.na(data$depth)==FALSE),]
unique(data$wbic)
length(data$wbic[which(is.na(data$wbic)==TRUE)])#FILTER THESE OUT
data=data[which(is.na(data$wbic)==FALSE),]
unique(data$project)


#done filtering
#proceed to populating LAGOS template


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$wbic
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$lake
data.Export$SourceVariableName = "totpuf"
data.Export$SourceVariableDescription = "Total phospohrus"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 27
data.Export$LagosVariableName="Phosphorus, total"
data.Export$Value=data$totpuf
unique(data.Export$Value)
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$sampledate#date already in correct format
data.Export$Units="ug/L"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="SPECIFIED"
unique(data.Export$SamplePosition)
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all GRAB

#assign sampledepth 
data.Export$SampleDepth=data$depth
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
tp.Final = data.Export
rm(data)
rm(data.Export)

################################### secchi   #############################################################################################################################
data=l_position_chem
head(data)#snapshot of schema
names(data)#column names
#pull out columns of interest
data=data[,c(1:4,15,26,27)]
names(data)
#filter out null obs
unique(data$secchi)#look at values, check for problems
length(data$secchi[which(is.na(data$secchi)==TRUE)])
length(data$secchi[which(data$secchi=="")])
295-182#113 obs remain after filtering out null
data=data[which(is.na(data$secchi)==FALSE),]
#check for replicates
unique(data$rep)#no replicates here the below commands won't do anything
length(data$rep[which(data$rep=="2")])#check number of replicates
data=data[which(data$rep=="1"),]#filter out replicates, no reps here doesn't make a difference
#check other variables
unique(data$wbic)
length(data$wbic[which(is.na(data$wbic)==TRUE)])#FILTER THESE OUT
data=data[which(is.na(data$wbic)==FALSE),]
unique(data$project)


#done filtering
#proceed to populating LAGOS template


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$wbic
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$lake
data.Export$SourceVariableName = "secchi"
data.Export$SourceVariableDescription = "Secchi depth"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 30
data.Export$LagosVariableName="Secchi"
data.Export$Value=data$secchi
unique(data.Export$Value)
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$sampledate#date already in correct format
data.Export$Units="m"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="SPECIFIED"
unique(data.Export$SamplePosition)
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED" #because secchi disk
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure all GRAB

#assign sampledepth 
data.Export$SampleDepth=NA#not applicable to secchi
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY"
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = "SECCHI_VIEW_UNKNOWN" #not applicable
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
secchi.Final = data.Export
rm(data)
rm(data.Export)

###################################### final export ########################################################################################
Final.Export = rbind(doc.Final,toc.Final,color1.Final,color2.Final,color3.Final,tn.Final,tp.Final,secchi.Final)
#########################################################################################################
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
2+883#adds up to total
##write table
Final.Export1=data1
typeof(Final.Export1$Value)
length(Final.Export1$Value[which(Final.Export1$Value<0)])
negative.df=Final.Export1[which(Final.Export1$Value<0),]
Final.Export1=Final.Export1[which(Final.Export1$Value>=0),]
nosamplepos=Final.Export1[which(is.na(Final.Export1$SampleDepth)==TRUE & Final.Export1$SamplePosition=="UNKNOWN"),]
write.table(Final.Export1,file="DataImport_WI_L_POSITION_CHEM.csv",row.names=FALSE,sep=",")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/WI data/L_Position (Finished)/DataImport_WI_L_POSITION_CHEM/WI_L_POSITION_CHEM.RData")