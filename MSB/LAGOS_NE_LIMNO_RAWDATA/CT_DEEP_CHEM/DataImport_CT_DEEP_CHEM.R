#set path to files
setwd("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/CT data/CT_ENH/CT_Chemistry_finished/DataImport_CT_DEEP_CHEM")
setwd("C:/Users/Sam/Dropbox/CSI-LIMNO_DATA/DATA-lake/CT data/CT_ENH/CT_Chemistry_finished/DataImport_CT_DEEP_CHEM")

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
#these data are the compilation of numerous surveys conducted by the CT DEEP, Bureau of Water Protection and Land Reuse
#sample type is "grab" for all obs and variables (except secchi) and sample position is specified for all obs and variables
#detection limits not specified, multiple lab methods used to measure chem variables, assigned by date to which they apply!!
###########################################################################################################################################################################################
################################### Organic Carbon, Dissolved #############################################################################################################################
data=ct_deep_chem
unique(data$ChemParameter)#look at parameters
#pull out parameter of interest
length(data$ChemParameter[which(data$ChemParameter=="Organic Carbon, Dissolved")]) #check no. of observations
data=data[which(data$ChemParameter=="Organic Carbon, Dissolved"),]
unique(data$media)#all water no filtering to do
unique(data$donotuse)#all false, no filtering to do
unique(data$value)#look at data for problematic values
#check for null observations
length(data$value[which(data$value=="")])
length(data$value[which(is.na(data$value)==TRUE)])
#no null values
#check for null sample depths (must have depth!)
length(data$depth.of.sample.meters.[which(data$depth.of.sample.meters.=="")])
length(data$depth.of.sample.meters.[which(is.na(data$depth.of.sample.meters.)==TRUE)])
#no null sample depths
#check units
unique(data$mdl)
length(data$mdl[which(is.na(data$mdl)==TRUE)])
unique(data$unit)#note that different units are used
temp.df=data[which(is.na(data$mdl)==FALSE & (is.na(data$unit)==FALSE)),]
unique(data$primary.type)#specifies the waterbody type, export to comments. concatenate "Waterbody designated as a" + "data$primary.type"+ "in the source data"
unique(data$method)#specifies chemical method used
#check to see if obs. are flagged as less than detection limit
unique(data$lessthan)#none flagged


#proceed to populating LAGOS template


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$basinid
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$StreamName.FacilityName
data.Export$SourceVariableName = "Organic Carbon, Dissolved"
data.Export$SourceVariableDescription = "Dissolved organic carbon"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no flags w/ these data
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 6
data.Export$LagosVariableName="Carbon, dissolved organic"
names(data)
data.Export$Value=data$value
unique(data.Export$Value)
unique(data$lessthan)#check to see if obs. is less than dl, if it is "TRUE" then censor as "LT", set all others to not censored "NT"
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$tripdate#date already in correct format
data.Export$Units="mg/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="SPECIFIED"#per metadata
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")])
#assign sampledepth 
data.Export$SampleDepth= data$depth.of.sample.meters.
unique(data.Export$SampleDepth)
length(data.Export$SampleDepth[which(data.Export$SampleDepth=="")])
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType[grep("deepest",data$proximity,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deep",data$proximity,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deepest",data$landmark.facility.name,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deep",data$landmark.facility.name,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[which(is.na(data.Export$BasinType)==TRUE)]="UNKNOWN" #set remaining obs to unknown
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="Oxidation"
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= data$mdl
unique(data.Export$DetectionLimit)
data.Export$Comments=as.character(data.Export$Comments)
unique(data$primary.type)
a="Source data specifies that this waterbody is a"
data.Export$Comments=paste(a,data$primary.type)
unique(data.Export$Comments)
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
doc.Final = data.Export
rm(data)
rm(data.Export)
rm(a)
rm(temp.df)

################################### Organic Carbon, Total #############################################################################################################################
data=ct_deep_chem
unique(data$ChemParameter)#look at parameters
#pull out parameter of interest
length(data$ChemParameter[which(data$ChemParameter=="Organic Carbon, Total")]) #check no. of observations
data=data[which(data$ChemParameter=="Organic Carbon, Total"),]
unique(data$media)#filter out sediment
length(data$media[which(data$media=="Sediment")])
79-20#59 will remain after filtering 
data=data[which(data$media!="Sediment"),]
#proceed with other filtering
unique(data$donotuse)#all false, no filtering to do
unique(data$value)#look at data for problematic values
#check for null observations
length(data$value[which(data$value=="")])
length(data$value[which(is.na(data$value)==TRUE)])
#no null values
#check for null sample depths (must have depth!)
length(data$depth.of.sample.meters.[which(data$depth.of.sample.meters.=="")])
length(data$depth.of.sample.meters.[which(is.na(data$depth.of.sample.meters.)==TRUE)])
#no null sample depths
#look at info on minimum detection limit
unique(data$mdl)
length(data$mdl[which(is.na(data$mdl)==TRUE)])
unique(data$unit)#note that different units are used
temp.df=data[which(is.na(data$mdl)==FALSE & (is.na(data$unit)==FALSE)),]
unique(temp.df$unit)
#check units
unique(data$unit)#note that these units describe the detection limit
length(data$unit[which(data$unit=="ppb")])#17 specified as "ppb"
temp.df2=data[which(data$unit=="ppb"),]
unique(temp.df2$value)# these appear to be units of ppm
#continue filtering
unique(data$primary.type)#specifies the waterbody type, export to comments. concatenate "Waterbody designated as a" + "data$primary.type"+ "in the source data"
unique(data$method)#specifies chemical method used
#check to see if obs. are flagged as less than detection limit
unique(data$lessthan)#none flagged
length(data$lessthan[which(data$lessthan=="TRUE")])#one observation should be censored as "LT"

#proceed to populating LAGOS template


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$basinid
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$StreamName.FacilityName
data.Export$SourceVariableName = "Organic Carbon, Total"
data.Export$SourceVariableDescription = "Total organic carbon"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no flags w/ these data
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 7
data.Export$LagosVariableName="Carbon, total organic"
names(data)
unique(data$unit)
data.Export$Value=data$value
unique(data.Export$Value)
unique(data$lessthan)#check to see if obs. is less than dl, if it is "TRUE" then censor as "LT", set all others to not censored "NT"
length(data$lessthan[which(data$lessthan=="TRUE")])#set as "LT"
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$lessthan=="TRUE")]="LT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)] = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$tripdate#date already in correct format
data.Export$Units="mg/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="SPECIFIED"#per metadata
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")])
#assign sampledepth 
data.Export$SampleDepth= data$depth.of.sample.meters.
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
unique(data$proximity)
unique(data$landmark.facility.name)
data.Export$BasinType[grep("deepest",data$proximity,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deep",data$proximity,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deepest",data$landmark.facility.name,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deep",data$landmark.facility.name,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[which(is.na(data.Export$BasinType)==TRUE)]="UNKNOWN" #set remaining obs to unknown
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "EPA_415.1" #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= data$mdl
unique(data.Export$DetectionLimit)
data.Export$Comments=as.character(data.Export$Comments)
unique(data$primary.type)
a="Source data specifies that this waterbody is a"
data.Export$Comments=paste(a,data$primary.type)
unique(data.Export$Comments)
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
toc.Final = data.Export
rm(data)
rm(data.Export)
rm(a)
rm(temp.df)
rm(temp.df2)

###################################  Chlorophyll a plankton    #############################################################################################################################
data=ct_deep_chem
unique(data$ChemParameter)#look at parameters
#pull out parameter of interest
length(data$ChemParameter[which(data$ChemParameter=="Chlorophyll-a Plankton")]) #check no. of observations
data=data[which(data$ChemParameter=="Chlorophyll-a Plankton"),]
unique(data$media)#do not filter any of these out
#proceed with other filtering
unique(data$donotuse)#all false, no filtering to do
unique(data$value)#look at data for problematic values
#check for null observations
length(data$value[which(data$value=="")])
length(data$value[which(is.na(data$value)==TRUE)])
#no null values
#check for null sample depths (must have depth!)
length(data$depth.of.sample.meters.[which(data$depth.of.sample.meters.=="")])
length(data$depth.of.sample.meters.[which(is.na(data$depth.of.sample.meters.)==TRUE)])
#27 values have no info on sample depth= NA and sample position= unknown
#check units
unique(data$unit)#note that these units describe the detection limit, units all the same here = good
#continue filtering
unique(data$primary.type)#specifies the waterbody type, export to comments. concatenate "Waterbody designated as a" + "data$primary.type"+ "in the source data"
unique(data$method)#specifies chemical method used
#check to see if obs. are flagged as less than detection limit
unique(data$lessthan)#none flagged

#look at info on minimum detection limit
unique(data$mdl)
length(data$mdl[which(is.na(data$mdl)==TRUE)])
unique(data$unit)#note that different units are used
temp.df=data[which(is.na(data$mdl)==FALSE & (is.na(data$unit)==FALSE)),]
unique(temp.df$unit)#check to make sure dl units match parameter units


#proceed to populating LAGOS template


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$basinid
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$StreamName.FacilityName
data.Export$SourceVariableName = "Chlorophyll-a Plankton"
data.Export$SourceVariableDescription = "Chlorophyll a plankton"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no flags w/ these data
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 9
data.Export$LagosVariableName="Chlorophyll a"
names(data)
unique(data$unit)
data.Export$Value=data$value
unique(data.Export$Value)
#populate censor code
unique(data$lessthan)#check to see if obs. is less than dl, if it is "TRUE" then censor as "LT", set all others to not censored "NT"
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$lessthan=="TRUE")]="LT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)] = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$tripdate#date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(is.na(data$depth.of.sample.meters.)==FALSE)]="SPECIFIED"
data.Export$SamplePosition[which(is.na(data$depth.of.sample.meters.)==TRUE)]="UNKNOWN"
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="UNKNOWN")])
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth= data$depth.of.sample.meters.
unique(data.Export$SampleDepth)
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
unique(data$proximity)
unique(data$landmark.facility.name)
data.Export$BasinType[grep("deepest",data$proximity,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deep",data$proximity,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deepest",data$landmark.facility.name,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deep",data$landmark.facility.name,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("greatest",data$landmark.facility.name,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[which(is.na(data.Export$BasinType)==TRUE)]="UNKNOWN" #set remaining obs to unknown
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
unique(data$method)
data.Export$LabMethodName[which(data$method=="AERP 12")]= "AERP_12"
data.Export$LabMethodName[which(data$method=="EPA 300.2")]= "EPA_300.2"
data.Export$LabMethodName[which(data$method=="Fluorescence")]= "MULTIPLE"
data.Export$LabMethodName[which(data$method=="")]= "MULTIPLE"
data.Export$LabMethodName[which(data$method=="EPA 445.0")]= "EPA_445.0"
data.Export$LabMethodName[which(data$method=="445")]= "EPA_445.0"
unique(data.Export$LabMethodName)
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo[which(data.Export$LabMethodName=="MULTIPLE")]="One of multiple fluorecence lab methods: EPA 300.2, EPA 445.0, AERP 12 used"
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= data$mdl
unique(data.Export$DetectionLimit)
data.Export$Comments=as.character(data.Export$Comments)
unique(data$primary.type)
a="Source data specifies that this waterbody is a"
data.Export$Comments=paste(a,data$primary.type)
unique(data.Export$Comments)
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
chla.Final = data.Export
rm(data)
rm(data.Export)
rm(a)
rm(temp.df)

###################################  Ammonia Nitrogen    #############################################################################################################################
data=ct_deep_chem
unique(data$ChemParameter)#look at parameters
#pull out parameter of interest
length(data$ChemParameter[which(data$ChemParameter=="Ammonia Nitrogen")]) #check no. of observations
data=data[which(data$ChemParameter=="Ammonia Nitrogen"),]
unique(data$media)#nothing to filter out
#proceed with other filtering
unique(data$donotuse)#filter out those that are "TRUE"
length(data$donotuse[which(data$donotuse=="TRUE")])#7 obs should be filtered out
data=data[which(data$donotuse!="TRUE"),]
#continue filterin
unique(data$value)#look at data for problematic values
#check for null observations
length(data$value[which(data$value=="")])
length(data$value[which(is.na(data$value)==TRUE)])
#no null values
#check for null sample depths (must have depth!)
unique(data$depth.of.sample.meters.)
length(data$depth.of.sample.meters.[which(data$depth.of.sample.meters.=="")])
length(data$depth.of.sample.meters.[which(is.na(data$depth.of.sample.meters.)==TRUE)])
#79 obs. will have a sample depth of NA and position of unknown
#check units
unique(data$unit)#all the same units= good!! mg/L
#continue filtering
unique(data$primary.type)#specifies the waterbody type, export to comments. concatenate "Waterbody designated as a" + "data$primary.type"+ "in the source data"
unique(data$method)#specifies chemical method used
#check to see if obs. are flagged as less than detection limit
unique(data$lessthan)#none flagged
length(data$lessthan[which(data$lessthan=="TRUE")])#151 observations should be censored as "LT"
#look at info on minimum detection limit
unique(data$mdl)
length(data$mdl[which(is.na(data$mdl)==TRUE)])
unique(data$unit)#note that different units are used
temp.df=data[which(is.na(data$mdl)==FALSE & (is.na(data$unit)==FALSE)),]
unique(temp.df$unit)#check to make sure dl units match parameter units


#proceed to populating LAGOS template


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$basinid
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$StreamName.FacilityName
data.Export$SourceVariableName = "Ammonia Nitrogen"
data.Export$SourceVariableDescription = "Ammonia (NH3)"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no flags w/ these data
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 19
data.Export$LagosVariableName="Nitrogen, NH4"
names(data)
unique(data$unit)
data.Export$Value=data$value*1000 #export obs. and convert to preff units
unique(data.Export$Value)
unique(data$lessthan)#check to see if obs. is less than dl, if it is "TRUE" then censor as "LT", set all others to not censored "NT"
length(data$lessthan[which(data$lessthan=="TRUE")])#set as "LT"
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$lessthan=="TRUE")]="LT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)] = "NC" #none censored
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure proper number "LT"
unique(data.Export$CensorCode)
data.Export$Date = data$tripdate#date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(is.na(data$depth.of.sample.meters.)==FALSE)]="SPECIFIED"
data.Export$SamplePosition[which(is.na(data$depth.of.sample.meters.)==TRUE)]="UNKNOWN"
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="UNKNOWN")])
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth= data$depth.of.sample.meters.
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
unique(data$proximity)
unique(data$landmark.facility.name)
data.Export$BasinType[grep("deepest",data$proximity,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deep",data$proximity,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deepest",data$landmark.facility.name,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deep",data$landmark.facility.name,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[which(is.na(data.Export$BasinType)==TRUE)]="UNKNOWN" #set remaining obs to unknown
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
unique(data$method)
data.Export$LabMethodName[which(data$method=="EPA 350.1")]="EPA_350.1"
data.Export$LabMethodName[which(data$method=="epa 350.1")]="EPA_350.1"
data.Export$LabMethodName[which(data$method=="EPA 353.2")]="EPA_353.2"
data.Export$LabMethodName[which(data$method=="")]="MULTIPLE"
unique(data.Export$LabMethodName)
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo[which(data.Export$LabMethodName=="MULTIPLE")]="EPA 350.1, EPA 353.2"
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= data$mdl
unique(data.Export$DetectionLimit)
data.Export$Comments=as.character(data.Export$Comments)
unique(data$primary.type)
a="Source data specifies that this waterbody is a"
data.Export$Comments=paste(a,data$primary.type)
unique(data.Export$Comments)
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
nh4.Final = data.Export
rm(data)
rm(data.Export)
rm(a)
rm(temp.df)

###################################  Nitrate as Nitrogen   #############################################################################################################################
data=ct_deep_chem
unique(data$ChemParameter)#look at parameters
#pull out parameter of interest
length(data$ChemParameter[which(data$ChemParameter=="Nitrate as Nitrogen")]) #check no. of observations
data=data[which(data$ChemParameter=="Nitrate as Nitrogen"),]
unique(data$media)#nothing to filter out
#proceed with other filtering
unique(data$donotuse)#filter out those that are "TRUE", none to filter here
#continue filterin
unique(data$value)#look at data for problematic values
#check for null observations
length(data$value[which(data$value=="")])
length(data$value[which(is.na(data$value)==TRUE)])
#no null values
#check for null sample depths (must have depth!)
unique(data$depth.of.sample.meters.)
length(data$depth.of.sample.meters.[which(data$depth.of.sample.meters.=="")])
length(data$depth.of.sample.meters.[which(is.na(data$depth.of.sample.meters.)==TRUE)])
#80 obs will have  a sample depth of NA and position of unknown
#check units
unique(data$unit)#note that these units describe the detection limit
length(data$unit[which(data$unit=="ppb")])#17 specified as "ppb"
temp.df2=data[which(data$unit=="ppb"),]
unique(temp.df2$value)#2 of these could have units of ppb, and the others ppm it would appear
temp.df2$value
#continue filtering
unique(data$primary.type)#specifies the waterbody type, export to comments. concatenate "Waterbody designated as a" + "data$primary.type"+ "in the source data"
unique(data$method)#specifies chemical method used
#check to see if obs. are flagged as less than detection limit
unique(data$lessthan)#none flagged
length(data$lessthan[which(data$lessthan=="TRUE")])#396 observations should be censored as "LT"

#look at info on minimum detection limit
unique(data$mdl)
length(data$mdl[which(is.na(data$mdl)==TRUE)])
unique(data$unit)#note that different units are used
temp.df=data[which(is.na(data$mdl)==FALSE & (is.na(data$unit)==FALSE)),]
unique(temp.df$unit)#check to make sure dl units match parameter units
#convert those detection limits with units of "ppm" to ug/L the preferred units for this variable
data$mdl[which(data$unit=="ppm")]= data$mdl[which(data$unit=="ppm")]*1000
data$mdl[which(data$unit=="PPM")]= data$mdl[which(data$unit=="PPM")]*1000
unique(data$mdl)

#proceed to populating LAGOS template


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$basinid
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$StreamName.FacilityName
data.Export$SourceVariableName = "Nitrate as Nitrogen"
data.Export$SourceVariableDescription = "Nitrogen, nitrate"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no flags w/ these data
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 18
data.Export$LagosVariableName="Nitrogen, nitrite (NO2) + nitrate (NO3)"
names(data)
unique(data$unit)
length(data$unit[which(data$unit=="ppb")])#don't convert these
data.Export$Value[which(data$unit=="ppb")]=data$value[which(data$unit=="ppb")]
data.Export$Value[which(data$unit!="ppb")]=data$value[which(data$unit!="ppb")]*1000#convert the rest to ug/L
unique(data.Export$Value)
unique(data$lessthan)#check to see if obs. is less than dl, if it is "TRUE" then censor as "LT", set all others to not censored "NT"
length(data$lessthan[which(data$lessthan=="TRUE")])#set as "LT"
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$lessthan=="TRUE")]="LT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)] = "NC" #none censored
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure proper number "LT"
unique(data.Export$CensorCode)
data.Export$Date = data$tripdate#date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(is.na(data$depth.of.sample.meters.)==FALSE)]="SPECIFIED"
data.Export$SamplePosition[which(is.na(data$depth.of.sample.meters.)==TRUE)]="UNKNOWN"
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="UNKNOWN")])
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth= data$depth.of.sample.meters.
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
unique(data$proximity)
unique(data$landmark.facility.name)
data.Export$BasinType[grep("deepest",data$proximity,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deep",data$proximity,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deepest",data$landmark.facility.name,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deep",data$landmark.facility.name,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[which(is.na(data.Export$BasinType)==TRUE)]="UNKNOWN" #set remaining obs to unknown
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
unique(data$method)
data.Export$LabMethodName="EPA_353.2"
unique(data.Export$LabMethodName)
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit=data$mdl
unique(data.Export$DetectionLimit)
data.Export$Comments=as.character(data.Export$Comments)
unique(data$primary.type)
a="Source data specifies that this waterbody is a"
data.Export$Comments=paste(a,data$primary.type)
unique(data.Export$Comments)
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
no3.Final = data.Export
rm(data)
rm(data.Export)
rm(a)
rm(temp.df)
rm(temp.df2)


################################### Ammonia-NH3    #############################################################################################################################
data=ct_deep_chem
unique(data$ChemParameter)#look at parameters
#pull out parameter of interest
length(data$ChemParameter[which(data$ChemParameter=="Ammonia-NH3")]) #check no. of observations
data=data[which(data$ChemParameter=="Ammonia-NH3"),]
unique(data$media)#nothing to filter out
#proceed with other filtering
unique(data$donotuse)#filter out those that are "TRUE"
#continue filtering
unique(data$value)#look at data for problematic values
#check for null observations
length(data$value[which(data$value=="")])
length(data$value[which(is.na(data$value)==TRUE)])
#no null values
#check for null sample depths (must have depth!)
unique(data$depth.of.sample.meters.)
length(data$depth.of.sample.meters.[which(data$depth.of.sample.meters.=="")])
#no null depths
#check units
unique(data$unit)#all the same units=good
#continue filtering
unique(data$primary.type)#specifies the waterbody type, export to comments. concatenate "Waterbody designated as a" + "data$primary.type"+ "in the source data"
unique(data$method)#specifies chemical method used
#check to see if obs. are flagged as less than detection limit
unique(data$lessthan)#none flagged
#look at info on minimum detection limit
unique(data$mdl)
length(data$mdl[which(is.na(data$mdl)==TRUE)])
unique(data$unit)#note that different units are used
temp.df=data[which(is.na(data$mdl)==FALSE & (is.na(data$unit)==FALSE)),]
unique(temp.df$unit)#check to make sure dl units match parameter units
data$mdl[which(data$unit=="ppm")]= data$mdl[which(data$unit=="ppm")]*1000
unique(data$mdl)

#proceed to populating LAGOS template


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$basinid
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$StreamName.FacilityName
data.Export$SourceVariableName = "Ammonia-NH3"
data.Export$SourceVariableDescription = "Ammonia (NH3)"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no flags w/ these data
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 19
data.Export$LagosVariableName="Nitrogen, NH4"
names(data)
data.Export$Value=data$value*1000 #export obs. and convert to preff units
unique(data.Export$Value)
unique(data$lessthan)#check to see if obs. is less than dl, if it is "TRUE" then censor as "LT", set all others to not censored "NT"
length(data$lessthan[which(data$lessthan=="TRUE")])#set as "LT"
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$lessthan=="TRUE")]="LT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)] = "NC" #none censored
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure proper number "LT"
unique(data.Export$CensorCode)
data.Export$Date = data$tripdate#date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(is.na(data$depth.of.sample.meters.)==FALSE)]="SPECIFIED"
data.Export$SamplePosition[which(is.na(data$depth.of.sample.meters.)==TRUE)]="UNKNOWN"
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="UNKNOWN")])
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth= data$depth.of.sample.meters.
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
unique(data$proximity)
unique(data$landmark.facility.name)
data.Export$BasinType[grep("deepest",data$proximity,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deep",data$proximity,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deepest",data$landmark.facility.name,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deep",data$landmark.facility.name,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[which(is.na(data.Export$BasinType)==TRUE)]="UNKNOWN" #set remaining obs to unknown
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
unique(data$method)
data.Export$LabMethodName="EPA_350.1"
unique(data.Export$LabMethodName)
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= data$mdl
unique(data.Export$DetectionLimit)
data.Export$Comments=as.character(data.Export$Comments)
unique(data$primary.type)
a="Source data specifies that this waterbody is a"
data.Export$Comments=paste(a,data$primary.type)
unique(data.Export$Comments)
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
nh41.Final = data.Export
rm(data)
rm(data.Export)
rm(a)
rm(temp.df)

################################### Nitrite as Nitrogen    #############################################################################################################################
data=ct_deep_chem
unique(data$ChemParameter)#look at parameters
#pull out parameter of interest
length(data$ChemParameter[which(data$ChemParameter=="Nitrite as Nitrogen")]) #check no. of observations
data=data[which(data$ChemParameter=="Nitrite as Nitrogen"),]
unique(data$media)#nothing to filter out
#proceed with other filtering
unique(data$donotuse)#filter out those that are "TRUE", none to filter here
#continue filterin
unique(data$value)#look at data for problematic values
#check for null observations
length(data$value[which(data$value=="")])
length(data$value[which(is.na(data$value)==TRUE)])
#no null values
#check for null sample depths (must have depth!)
unique(data$depth.of.sample.meters.)
length(data$depth.of.sample.meters.[which(data$depth.of.sample.meters.=="")])
length(data$depth.of.sample.meters.[which(is.na(data$depth.of.sample.meters.)==TRUE)])
#79 obs. will be NA for depth and unknown for position
#check units
unique(data$unit)#units all the same= good!!
#continue filtering
unique(data$primary.type)#specifies the waterbody type, export to comments. concatenate "Waterbody designated as a" + "data$primary.type"+ "in the source data"
unique(data$method)#specifies chemical method used
#check to see if obs. are flagged as less than detection limit
unique(data$lessthan)#none flagged
length(data$lessthan[which(data$lessthan=="TRUE")])#782 observations should be censored as "LT"

#look at info on minimum detection limit
unique(data$mdl)
length(data$mdl[which(is.na(data$mdl)==TRUE)])
unique(data$unit)#note that different units are used
temp.df=data[which(is.na(data$mdl)==FALSE & (is.na(data$unit)==FALSE)),]
unique(temp.df$unit)#check to make sure dl units match parameter units
data$mdl[which(data$unit=="PPM")]= data$mdl[which(data$unit=="PPM")]*1000
data$mdl[which(data$unit=="ppm")]= data$mdl[which(data$unit=="ppm")]*1000
data$mdl[which(data$unit=="mg/L")]= data$mdl[which(data$unit=="mg/L")]*1000
unique(data$mdl)


#proceed to populating LAGOS template


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$basinid
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$StreamName.FacilityName
data.Export$SourceVariableName = "Nitrite as Nitrogen"
data.Export$SourceVariableDescription = "Nitrogen, nitrite"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no flags w/ these data
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 17
data.Export$LagosVariableName="Nitrogen, nitrite (NO2)"
names(data)
unique(data$unit)
data.Export$Value=data$value*1000
unique(data.Export$Value)
unique(data$lessthan)#check to see if obs. is less than dl, if it is "TRUE" then censor as "LT", set all others to not censored "NT"
length(data$lessthan[which(data$lessthan=="TRUE")])#set as "LT"
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$lessthan=="TRUE")]="LT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)] = "NC" #none censored
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure proper number "LT"
unique(data.Export$CensorCode)
data.Export$Date = data$tripdate#date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(is.na(data$depth.of.sample.meters.)==FALSE)]="SPECIFIED"
data.Export$SamplePosition[which(is.na(data$depth.of.sample.meters.)==TRUE)]="UNKNOWN"
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="UNKNOWN")])
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth= data$depth.of.sample.meters.
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
unique(data$proximity)
unique(data$landmark.facility.name)
data.Export$BasinType[grep("deepest",data$proximity,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deep",data$proximity,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deepest",data$landmark.facility.name,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deep",data$landmark.facility.name,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[which(is.na(data.Export$BasinType)==TRUE)]="UNKNOWN" #set remaining obs to unknown
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
unique(data$method)
data.Export$LabMethodName="EPA_353.2"
unique(data.Export$LabMethodName)
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= data$mdl
unique(data.Export$DetectionLimit)
data.Export$Comments=as.character(data.Export$Comments)
unique(data$primary.type)
a="Source data specifies that this waterbody is a"
data.Export$Comments=paste(a,data$primary.type)
unique(data.Export$Comments)
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
no2.Final = data.Export
rm(data)
rm(data.Export)
rm(a)
rm(temp.df)

###################################  Nitrogen, Total  #############################################################################################################################
data=ct_deep_chem
unique(data$ChemParameter)#look at parameters
#pull out parameter of interest
length(data$ChemParameter[which(data$ChemParameter=="Nitrogen, Total")]) #check no. of observations
data=data[which(data$ChemParameter=="Nitrogen, Total"),]
unique(data$media)#nothing to filter out
#proceed with other filtering
unique(data$donotuse)#filter out those that are "TRUE", none to filter here
#continue filterin
unique(data$value)#look at data for problematic values
#check for null observations
length(data$value[which(data$value=="")])
length(data$value[which(is.na(data$value)==TRUE)])
#no null values
#check for null sample depths (must have depth!)
unique(data$depth.of.sample.meters.)
length(data$depth.of.sample.meters.[which(data$depth.of.sample.meters.=="")])
length(data$depth.of.sample.meters.[which(is.na(data$depth.of.sample.meters.)==TRUE)])
#one obs. will be NA for depth and unknown for sample position
#check units
unique(data$unit)#different units, don't convert those that are "ppb" to ug/L (already ug/L)
length(data$unit[which(data$unit=="ppb")])#17 specified as "ppb"
temp.df2=data[which(data$unit=="ppb"),]
unique(temp.df2$value)# these appear to be units of ppb (no issue here)
rm(temp.df2)

#continue filtering
unique(data$primary.type)#specifies the waterbody type, export to comments. concatenate "Waterbody designated as a" + "data$primary.type"+ "in the source data"
unique(data$method)#specifies chemical method used
#check to see if obs. are flagged as less than detection limit
unique(data$lessthan)#none flagged
length(data$lessthan[which(data$lessthan=="TRUE")])#2 observations should be censored as "LT"

#look at info on minimum detection limit
unique(data$mdl)
length(data$mdl[which(is.na(data$mdl)==TRUE)])
unique(data$unit)#note that different units are used
temp.df=data[which(is.na(data$mdl)==FALSE & (is.na(data$unit)==FALSE)),]
unique(temp.df$unit)#check to make sure dl units match parameter units= they do.
data$mdl[which(data$unit=="ppm")]= data$mdl[which(data$unit=="ppm")]*1000
data$mdl[which(data$unit=="PPM")]= data$mdl[which(data$unit=="PPM")]*1000
data$mdl[which(data$unit=="mg/L")]= data$mdl[which(data$unit=="mg/L")]*1000
unique(data$mdl)



#proceed to populating LAGOS template


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$basinid
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$StreamName.FacilityName
data.Export$SourceVariableName = "Nitrogen, Total"
data.Export$SourceVariableDescription = "Total nitrogen"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no flags w/ these data
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 21
data.Export$LagosVariableName="Nitrogen, total"
names(data)
unique(data$unit)
print(data[which(data$unit=="ppb"),])
length(data$unit[which(data$unit=="ppb")])#don't convert these
data.Export$Value[which(data$unit=="ppb")]=data$value[which(data$unit=="ppb")]
data.Export$Value[which(data$unit=="PPM")]=data$value[which(data$unit=="PPM")]*1000
data.Export$Value[which(data$unit=="ppm")]=data$value[which(data$unit=="ppm")]*1000
data.Export$Value[which(data$unit=="mg/L")]=data$value[which(data$unit=="mg/L")]*1000

unique(data.Export$Value)
unique(data$lessthan)#check to see if obs. is less than dl, if it is "TRUE" then censor as "LT", set all others to not censored "NT"
length(data$lessthan[which(data$lessthan=="TRUE")])#set as "LT"
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$lessthan=="TRUE")]="LT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)] = "NC" #none censored
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure proper number "LT"
unique(data.Export$CensorCode)
data.Export$Date = data$tripdate#date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(is.na(data$depth.of.sample.meters.)==FALSE)]="SPECIFIED"
data.Export$SamplePosition[which(is.na(data$depth.of.sample.meters.)==TRUE)]="UNKNOWN"
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="UNKNOWN")])
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth= data$depth.of.sample.meters.
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
unique(data$proximity)
unique(data$landmark.facility.name)
data.Export$BasinType[grep("deepest",data$proximity,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deep",data$proximity,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deepest",data$landmark.facility.name,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deep",data$landmark.facility.name,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[which(is.na(data.Export$BasinType)==TRUE)]="UNKNOWN" #set remaining obs to unknown
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
unique(data$method)
data.Export$LabMethodName="EPA_353.2"
unique(data.Export$LabMethodName)
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="multiple variations of EPA_353.2 used throughout time"
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= data$mdl
unique(data.Export$DetectionLimit)
data.Export$Comments=as.character(data.Export$Comments)
unique(data$primary.type)
a="Source data specifies that this waterbody is a"
data.Export$Comments=paste(a,data$primary.type)
unique(data.Export$Comments)
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
tn.Final = data.Export
rm(data)
rm(data.Export)
rm(a)
rm(temp.df)


###################################  Nitrogen, Total Dissolved  #############################################################################################################################
data=ct_deep_chem
unique(data$ChemParameter)#look at parameters
#pull out parameter of interest
length(data$ChemParameter[which(data$ChemParameter=="Nitrogen, Total Dissolved")]) #check no. of observations
data=data[which(data$ChemParameter=="Nitrogen, Total Dissolved"),]
unique(data$media)#nothing to filter out
#proceed with other filtering
unique(data$donotuse)#filter out those that are "TRUE", none to filter here
#continue filterin
unique(data$value)#look at data for problematic values
#check for null observations
length(data$value[which(data$value=="")])
length(data$value[which(is.na(data$value)==TRUE)])
#no null values
#check for null sample depths (must have depth!)
unique(data$depth.of.sample.meters.)
length(data$depth.of.sample.meters.[which(data$depth.of.sample.meters.=="")])
length(data$depth.of.sample.meters.[which(is.na(data$depth.of.sample.meters.)==TRUE)])
#none to filter out
#check units
unique(data$unit)#different units, don't convert those that are "ppb" to ug/L (already ug/L)
length(data$unit[which(data$unit=="ppb")])
temp.df2=data[which(data$unit=="ppb"),]
unique(temp.df2$value)# these appear to be units of ppm, even though they are supposidly 

#continue filtering
unique(data$primary.type)#specifies the waterbody type, export to comments. concatenate "Waterbody designated as a" + "data$primary.type"+ "in the source data"
unique(data$method)#specifies chemical method used
#check to see if obs. are flagged as less than detection limit
unique(data$lessthan)#none flagged
length(data$lessthan[which(data$lessthan=="TRUE")])#no observations are flagged

#look at info on minimum detection limit
unique(data$mdl)
length(data$mdl[which(is.na(data$mdl)==TRUE)])
unique(data$unit)#note that different units are used
temp.df=data[which(is.na(data$mdl)==FALSE & (is.na(data$unit)==FALSE)),]
unique(temp.df$unit)#check to make sure dl units match parameter units
data$mdl[which(data$unit=="ppm")]= data$mdl[which(data$unit=="ppm")]*1000
data$mdl[which(data$unit=="ppb")]= data$mdl[which(data$unit=="ppb")]
unique(data$mdl)


#proceed to populating LAGOS template


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$basinid
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$StreamName.FacilityName
data.Export$SourceVariableName = "Nitrogen, Total Dissolved"
data.Export$SourceVariableDescription = "Total dissolved nitrogen"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no flags w/ these data
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 22
data.Export$LagosVariableName="Nitrogen, total dissolved"
names(data)
unique(data$unit)
print(data[which(data$unit=="ppb"),])
length(data$unit[which(data$unit=="ppb")])#don't convert these
unique(temp.df2$value)
data.Export$Value=as.character(data.Export$Value)
data$value=as.character(data$value)
data.Export$Value[which(data$unit=="ppb")]=data$value[which(data$unit=="ppb")]
data$value=as.numeric(data$value)
data.Export$Value[which(data$unit=="ppm")]=data$value[which(data$unit=="ppm")]*1000
unique(data.Export$Value)
unique(data$lessthan)#check to see if obs. is less than dl, if it is "TRUE" then censor as "LT", set all others to not censored "NT"
length(data$lessthan[which(data$lessthan=="TRUE")])#set as "LT"
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$lessthan=="TRUE")]="LT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)] = "NC" #none censored
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure proper number "LT"
unique(data.Export$CensorCode)
data.Export$Date = data$tripdate#date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(is.na(data$depth.of.sample.meters.)==FALSE)]="SPECIFIED"
data.Export$SamplePosition[which(is.na(data$depth.of.sample.meters.)==TRUE)]="UNKNOWN"
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="UNKNOWN")])
unique(data.Export$SamplePosition)

#assign sampledepth 
data.Export$SampleDepth= data$depth.of.sample.meters.
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
unique(data$proximity)
unique(data$landmark.facility.name)
data.Export$BasinType[grep("deepest",data$proximity,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deep",data$proximity,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deepest",data$landmark.facility.name,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deep",data$landmark.facility.name,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[which(is.na(data.Export$BasinType)==TRUE)]="UNKNOWN" #set remaining obs to unknown
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
unique(data$method)
data.Export$LabMethodName="EPA_353.2"
unique(data.Export$LabMethodName)
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= data$mdl
unique(data.Export$DetectionLimit)
data.Export$Comments=as.character(data.Export$Comments)
unique(data$primary.type)
a="Source data specifies that this waterbody is a"
data.Export$Comments=paste(a,data$primary.type)
unique(data.Export$Comments)
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
tdn.Final = data.Export
rm(data)
rm(data.Export)
rm(a)
rm(temp.df)
rm(temp.df2)

################################### Organic Nitrogen  #############################################################################################################################
data=ct_deep_chem
unique(data$ChemParameter)#look at parameters
#pull out parameter of interest
length(data$ChemParameter[which(data$ChemParameter=="Organic Nitrogen")]) #check no. of observations
data=data[which(data$ChemParameter=="Organic Nitrogen"),]
unique(data$media)#nothing to filter out
#proceed with other filtering
unique(data$donotuse)#filter out those that are "TRUE", none to filter here
#continue filterin
unique(data$value)#look at data for problematic values
#check for null observations
length(data$value[which(data$value=="")])
length(data$value[which(is.na(data$value)==TRUE)])
#no null values
#check for null sample depths (must have depth!)
unique(data$depth.of.sample.meters.)
length(data$depth.of.sample.meters.[which(data$depth.of.sample.meters.=="")])
length(data$depth.of.sample.meters.[which(is.na(data$depth.of.sample.meters.)==TRUE)])
#78 observations are NA for depth and unknown for position
#check units
unique(data$unit)#all the same units=good!!
#continue filtering
unique(data$primary.type)#specifies the waterbody type, export to comments. concatenate "Waterbody designated as a" + "data$primary.type"+ "in the source data"
unique(data$method)#specifies chemical method used
length(data$method[which(data$method=="Calculation")])#do not assign a lab method name for these obs, see import log
#check to see if obs. are flagged as less than detection limit
unique(data$lessthan)#none flagged
length(data$lessthan[which(data$lessthan=="TRUE")])#6  obs to be flagged as "LT"

#look at info on minimum detection limit
unique(data$mdl)
length(data$mdl[which(is.na(data$mdl)==TRUE)])
unique(data$unit)#note that different units are used
temp.df=data[which(is.na(data$mdl)==FALSE & (is.na(data$unit)==FALSE)),]
unique(temp.df$unit)#check to make sure dl units match parameter units
data$mdl[which(data$unit=="ppm")]= data$mdl[which(data$unit=="ppm")]*1000
unique(data$mdl)

#proceed to populating LAGOS template



###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$basinid
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$StreamName.FacilityName
data.Export$SourceVariableName = "Organic Nitrogen"
data.Export$SourceVariableDescription = "organic nitrogen"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no flags w/ these data
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 16
data.Export$LagosVariableName="Nitrogen, total Kjeldahl"
names(data)
unique(data$unit)#different units, but equivalent,convert to ug/L
unique(data$value)
data.Export$Value=data$value*1000
unique(data.Export$Value)
#populate censorcode
unique(data$lessthan)#check to see if obs. is less than dl, if it is "TRUE" then censor as "LT", set all others to not censored "NT"
length(data$lessthan[which(data$lessthan=="TRUE")])#set as "LT"
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$lessthan=="TRUE")]="LT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)] = "NC" #none censored
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure proper number "LT"
unique(data.Export$CensorCode)
data.Export$Date = data$tripdate#date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(is.na(data$depth.of.sample.meters.)==FALSE)]="SPECIFIED"
data.Export$SamplePosition[which(is.na(data$depth.of.sample.meters.)==TRUE)]="UNKNOWN"
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="UNKNOWN")])
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth= data$depth.of.sample.meters.
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
unique(data$proximity)
unique(data$landmark.facility.name)
data.Export$BasinType[grep("deepest",data$proximity,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deep",data$proximity,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deepest",data$landmark.facility.name,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deep",data$landmark.facility.name,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[which(is.na(data.Export$BasinType)==TRUE)]="UNKNOWN" #set remaining obs to unknown
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
unique(data$method)
data.Export$LabMethodName[which(data$method=="EPA 351.1")]="EPA_351.1"
data.Export$LabMethodName[which(data$method=="EPA 353.2")]="EPA_353.2"
data.Export$LabMethodName[which(data$method=="Calculation")]= NA
unique(data.Export$LabMethodName)
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo[which(is.na(data.Export$LabMethodName)==TRUE)]="Observation calculated using unknown algorithm"
data.Export$LabMethodInfo[which(is.na(data.Export$LabMethodName)==FALSE)]=NA
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= data$mdl
unique(data.Export$DetectionLimit)
data.Export$Comments=as.character(data.Export$Comments)
unique(data$primary.type)
a="Source data specifies that this waterbody is a"
data.Export$Comments=paste(a,data$primary.type)
unique(data.Export$Comments)
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
tkn.Final = data.Export
rm(data)
rm(data.Export)
rm(a)
rm(temp.df)

###################################  TKN #############################################################################################################################
data=ct_deep_chem
unique(data$ChemParameter)#look at parameters
#pull out parameter of interest
length(data$ChemParameter[which(data$ChemParameter=="TKN")]) #check no. of observations
data=data[which(data$ChemParameter=="TKN"),]
unique(data$media)#nothing to filter out
#proceed with other filtering
unique(data$donotuse)#filter out those that are "TRUE", none to filter here
#continue filterin
unique(data$value)#look at data for problematic values
#check for null observations
length(data$value[which(data$value=="")])
length(data$value[which(is.na(data$value)==TRUE)])
#no null values
#check for null sample depths (must have depth!)
unique(data$depth.of.sample.meters.)
length(data$depth.of.sample.meters.[which(data$depth.of.sample.meters.=="")])
length(data$depth.of.sample.meters.[which(is.na(data$depth.of.sample.meters.)==TRUE)])
#78 obs will be null for sample depth and unknown for position
#check units
unique(data$unit)#all the same unit==good!!
#continue filtering
unique(data$primary.type)#specifies the waterbody type, export to comments. concatenate "Waterbody designated as a" + "data$primary.type"+ "in the source data"
unique(data$method)#specifies chemical method used
length(data$method[which(data$method=="Calculation")])# do not assign a lab method name for these obs, see import log
#check to see if obs. are flagged as less than detection limit
unique(data$lessthan)#none flagged
length(data$lessthan[which(data$lessthan=="TRUE")])#4  obs to be flagged as "LT"
#proceed to populating LAGOS template

#look at info on minimum detection limit
unique(data$mdl)
length(data$mdl[which(is.na(data$mdl)==TRUE)])
unique(data$unit)#note that different units are used
temp.df=data[which(is.na(data$mdl)==FALSE & (is.na(data$unit)==FALSE)),]
unique(temp.df$unit)#check to make sure dl units match parameter units
#convert those detection limits with units of "ppm" to ug/L the preferred units for this variable
data$mdl[which(data$unit=="ppm")]= data$mdl[which(data$unit=="ppm")]*1000
unique(data$mdl)

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$basinid
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$StreamName.FacilityName
data.Export$SourceVariableName = "TKN"
data.Export$SourceVariableDescription = "Total kjeldahl"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no flags w/ these data
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 16
data.Export$LagosVariableName="Nitrogen, total Kjeldahl"
names(data)
unique(data$unit)#different units, but equivalent,convert to ug/L
unique(data$value)
data.Export$Value=data$value*1000
unique(data.Export$Value)
#populate censorcode
unique(data$lessthan)#check to see if obs. is less than dl, if it is "TRUE" then censor as "LT", set all others to not censored "NT"
length(data$lessthan[which(data$lessthan=="TRUE")])#set as "LT"
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$lessthan=="TRUE")]="LT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)] = "NC" #none censored
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure proper number "LT"
unique(data.Export$CensorCode)
data.Export$Date = data$tripdate#date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(is.na(data$depth.of.sample.meters.)==FALSE)]="SPECIFIED"
data.Export$SamplePosition[which(is.na(data$depth.of.sample.meters.)==TRUE)]="UNKNOWN"
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="UNKNOWN")])
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth= data$depth.of.sample.meters.
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
unique(data$proximity)
unique(data$landmark.facility.name)
data.Export$BasinType[grep("deepest",data$proximity,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deep",data$proximity,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deepest",data$landmark.facility.name,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deep",data$landmark.facility.name,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[which(is.na(data.Export$BasinType)==TRUE)]="UNKNOWN" #set remaining obs to unknown
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
unique(data$method)
data.Export$LabMethodName[which(data$method=="EPA 351.2")]="EPA_351.2"
data.Export$LabMethodName[which(data$method=="Calculation")]= NA
unique(data.Export$LabMethodName)
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo[which(is.na(data.Export$LabMethodName)==TRUE)]="Observation calculated using unknown algorithm"
data.Export$LabMethodInfo[which(is.na(data.Export$LabMethodName)==FALSE)]=NA
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= data$mdl
unique(data.Export$DetectionLimit)
data.Export$Comments=as.character(data.Export$Comments)
unique(data$primary.type)
a="Source data specifies that this waterbody is a"
data.Export$Comments=paste(a,data$primary.type)
unique(data.Export$Comments)
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
tkn1.Final = data.Export
rm(data)
rm(data.Export)
rm(a)
rm(temp.df)

################################### Orthophosphate  #############################################################################################################################
data=ct_deep_chem
unique(data$ChemParameter)#look at parameters
#pull out parameter of interest
length(data$ChemParameter[which(data$ChemParameter=="Orthophosphate")]) #check no. of observations
data=data[which(data$ChemParameter=="Orthophosphate"),]
unique(data$media)#nothing to filter out
#proceed with other filtering
unique(data$donotuse)#filter out those that are "TRUE"
length(data$donotuse[which(data$donotuse=="TRUE")])
778-20#758 after filtering out those flagged as TRUE for donotuse
data=data[which(data$donotuse!="TRUE"),]
#continue filterin
unique(data$value)#look at data for problematic values
#check for null observations
length(data$value[which(data$value=="")])
length(data$value[which(is.na(data$value)==TRUE)])
#no null values
#check for null sample depths (must have depth!)
unique(data$depth.of.sample.meters.)
length(data$depth.of.sample.meters.[which(data$depth.of.sample.meters.=="")])
length(data$depth.of.sample.meters.[which(is.na(data$depth.of.sample.meters.)==TRUE)])
#one obs will be NA for depth and unknown for position
#check units
unique(data$unit)#all the same units==good!
#continue filtering
unique(data$primary.type)#specifies the waterbody type, export to comments. concatenate "Waterbody designated as a" + "data$primary.type"+ "in the source data"
unique(data$method)#specifies chemical method used
#check to see if obs. are flagged as less than detection limit
unique(data$lessthan)#none flagged
length(data$lessthan[which(data$lessthan=="TRUE")])#170  obs to be flagged as "LT"

#look at info on minimum detection limit
unique(data$mdl)
length(data$mdl[which(is.na(data$mdl)==TRUE)])
unique(data$unit)#note that different units are used
temp.df=data[which(is.na(data$mdl)==FALSE & (is.na(data$unit)==FALSE)),]
unique(temp.df$unit)#check to make sure dl units match parameter units
data$mdl[which(data$unit=="ppm")]= data$mdl[which(data$unit=="ppm")]*1000
data$mdl[which(data$unit=="PPM")]= data$mdl[which(data$unit=="PPM")]*1000
data$mdl[which(data$unit=="mg/L")]= data$mdl[which(data$unit=="mg/L")]*1000
unique(data$mdl)

#proceed to populating LAGOS template


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$basinid
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$StreamName.FacilityName
data.Export$SourceVariableName = "Orthophosphate"
data.Export$SourceVariableDescription = "orthophosphate"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no flags w/ these data
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 26
data.Export$LagosVariableName="Phosphorus, soluable reactive orthophosphate"
names(data)
unique(data$unit)#different units, but equivalent,convert to ug/L
unique(data$value)
data.Export$Value=data$value*1000
unique(data.Export$Value)
#populate censorcode
unique(data$lessthan)#check to see if obs. is less than dl, if it is "TRUE" then censor as "LT", set all others to not censored "NT"
length(data$lessthan[which(data$lessthan=="TRUE")])#set as "LT"
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$lessthan=="TRUE")]="LT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)] = "NC" #none censored
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure proper number "LT"
unique(data.Export$CensorCode)
data.Export$Date = data$tripdate#date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(is.na(data$depth.of.sample.meters.)==FALSE)]="SPECIFIED"
data.Export$SamplePosition[which(is.na(data$depth.of.sample.meters.)==TRUE)]="UNKNOWN"
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="UNKNOWN")])
unique(data.Export$SamplePosition)

#assign sampledepth 
data.Export$SampleDepth= data$depth.of.sample.meters.
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
unique(data$proximity)
unique(data$landmark.facility.name)
data.Export$BasinType[grep("deepest",data$proximity,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deep",data$proximity,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deepest",data$landmark.facility.name,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deep",data$landmark.facility.name,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[which(is.na(data.Export$BasinType)==TRUE)]="UNKNOWN" #set remaining obs to unknown
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
unique(data$method)
data.Export$LabMethodName[which(data$method=="EPA 365.1")]="EPA_365.1"
data.Export$LabMethodName[which(data$method=="epa 365.3")]="EPA_365.3"
data.Export$LabMethodName[which(data$method=="EPA 365.5")]="EPA_365.5"
unique(data.Export$LabMethodName)
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #per meta
data.Export$Comments=as.character(data.Export$Comments)
unique(data$primary.type)
a="Source data specifies that this waterbody is a"
data.Export$Comments=paste(a,data$primary.type)
unique(data.Export$Comments)
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
srp.Final = data.Export
rm(data)
rm(data.Export)
rm(a)
rm(temp.df)

################################### Phosphorous, Dissolved Total (TDP) #############################################################################################################################
data=ct_deep_chem
unique(data$ChemParameter)#look at parameters
#pull out parameter of interest
length(data$ChemParameter[which(data$ChemParameter=="Phosphorous, Dissolved Total (TDP)")]) #check no. of observations
data=data[which(data$ChemParameter=="Phosphorous, Dissolved Total (TDP)"),]
unique(data$media)#nothing to filter out
#proceed with other filtering
unique(data$donotuse)#filter out those that are "TRUE", none here
#continue filterin
unique(data$value)#look at data for problematic values
#check for null observations
length(data$value[which(data$value=="")])
length(data$value[which(is.na(data$value)==TRUE)])
#no null values
#check for null sample depths (must have depth!)
unique(data$depth.of.sample.meters.)
length(data$depth.of.sample.meters.[which(data$depth.of.sample.meters.=="")])
length(data$depth.of.sample.meters.[which(is.na(data$depth.of.sample.meters.)==TRUE)])
# no null depths
#check units
unique(data$unit)#all the same
#continue filtering
unique(data$primary.type)#specifies the waterbody type, export to comments. concatenate "Waterbody designated as a" + "data$primary.type"+ "in the source data"
unique(data$method)#specifies chemical method used
#check to see if obs. are flagged as less than detection limit
unique(data$lessthan)#none flagged
length(data$lessthan[which(data$lessthan=="TRUE")])#none flagged

unique(data$mdl)
data$mdl[which(data$unit=="ppm")]= data$mdl[which(data$unit=="ppm")]*1000

#proceed to populating LAGOS template


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$basinid
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$StreamName.FacilityName
data.Export$SourceVariableName = "Phosphorous, Dissolved Total (TDP)"
data.Export$SourceVariableDescription = "Total dissolved phosphorus"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no flags w/ these data
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 28
data.Export$LagosVariableName="Phosphorus, total dissolved"
names(data)
unique(data$unit)
unique(data$value)
data.Export$Value=data$value*1000
unique(data.Export$Value)
#populate censorcode
unique(data$lessthan)#check to see if obs. is less than dl, if it is "TRUE" then censor as "LT", set all others to not censored "NT"
length(data$lessthan[which(data$lessthan=="TRUE")])#set as "LT"
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$lessthan=="TRUE")]="LT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)] = "NC" #none censored
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure proper number "LT"
unique(data.Export$CensorCode)
data.Export$Date = data$tripdate#date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(is.na(data$depth.of.sample.meters.)==FALSE)]="SPECIFIED"
data.Export$SamplePosition[which(is.na(data$depth.of.sample.meters.)==TRUE)]="UNKNOWN"
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="UNKNOWN")])
unique(data.Export$SamplePosition)

#assign sampledepth 
data.Export$SampleDepth= data$depth.of.sample.meters.
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
unique(data$proximity)
unique(data$landmark.facility.name)
data.Export$BasinType[grep("deepest",data$proximity,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deep",data$proximity,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deepest",data$landmark.facility.name,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deep",data$landmark.facility.name,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[which(is.na(data.Export$BasinType)==TRUE)]="UNKNOWN" #set remaining obs to unknown
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
unique(data$method)
data.Export$LabMethodName="EPA_365.1"
unique(data.Export$LabMethodName)
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= data$mdl
unique(data.Export$DetectionLimit)
data.Export$Comments=as.character(data.Export$Comments)
unique(data$primary.type)
a="Source data specifies that this waterbody is a"
data.Export$Comments=paste(a,data$primary.type)
unique(data.Export$Comments)
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
tdp.Final = data.Export
rm(data)
rm(data.Export)
rm(a)

###################################  Transparency (Water column) no tube    #############################################################################################################################
data=ct_deep_chem
unique(data$ChemParameter)#look at parameters
#pull out parameter of interest
length(data$ChemParameter[which(data$ChemParameter=="Transparency (Water column) no tube")]) #check no. of observations
data=data[which(data$ChemParameter=="Transparency (Water column) no tube"),]
unique(data$media)#nothing to filter out
#proceed with other filtering
unique(data$donotuse)#filter out those that are "TRUE", none here
#continue filtering
unique(data$value)#look at data for problematic values
#check for null observations
length(data$value[which(data$value=="")])
length(data$value[which(is.na(data$value)==TRUE)])
#1 null value, filter out
data=data[which(is.na(data$value)==FALSE),]
#check units
unique(data$unit)#all the same units
#continue filtering
unique(data$primary.type)#specifies the waterbody type, export to comments. concatenate "Waterbody designated as a" + "data$primary.type"+ "in the source data"
unique(data$method)#specifies SECCHI
#check to see if obs. are flagged as less than detection limit
unique(data$lessthan)#none flagged, because there is no detection limit for secchi disk
#proceed to populating LAGOS template


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$basinid
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$StreamName.FacilityName
data.Export$SourceVariableName = "Transparency (Water column) no tube"
data.Export$SourceVariableDescription = "Secchi depth with no view scope"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no flags w/ these data
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 30
data.Export$LagosVariableName="Secchi"
names(data)
unique(data$unit)#meters
unique(data$value)
data.Export$Value=data$value #export secchi obs, already in preff. units
unique(data.Export$Value)
#populate censorcode
unique(data$lessthan)#check to see if obs. is less than dl, if it is "TRUE" then censor as "LT", set all others to not censored "NT"
length(data$lessthan[which(data$lessthan=="TRUE")])#set as "LT"
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode="NC" #these secchi disk obs. are not censored
unique(data.Export$CensorCode)
data.Export$Date = data$tripdate#date already in correct format
data.Export$Units="m"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="SPECIFIED"#per metadata
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")])
#assign sampledepth 
data.Export$SampleDepth= NA #n/a to seechi
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
unique(data$proximity)
unique(data$landmark.facility.name)
data.Export$BasinType[grep("deepest",data$proximity,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deep",data$proximity,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deepest",data$landmark.facility.name,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deep",data$landmark.facility.name,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[which(is.na(data.Export$BasinType)==TRUE)]="UNKNOWN" #set remaining obs to unknown
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName=NA
unique(data.Export$LabMethodName)
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #per meta
data.Export$Comments=as.character(data.Export$Comments)
unique(data$primary.type)
a="Source data specifies that this waterbody is a"
data.Export$Comments=paste(a,data$primary.type)
unique(data.Export$Comments)
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
secchi.Final = data.Export
rm(data)
rm(data.Export)
rm(a)

###################################  Transparency (Water column) with tube   #############################################################################################################################
data=ct_deep_chem
unique(data$ChemParameter)#look at parameters
#pull out parameter of interest
length(data$ChemParameter[which(data$ChemParameter=="Transparency (Water column) with tube")]) #check no. of observations
data=data[which(data$ChemParameter=="Transparency (Water column) with tube"),]
unique(data$media)#nothing to filter out
#proceed with other filtering
unique(data$donotuse)#filter out those that are "TRUE", none here
#continue filtering
unique(data$value)#look at data for problematic values
#check for null observations
length(data$value[which(data$value=="")])
length(data$value[which(is.na(data$value)==TRUE)])
#no null values
#check units
unique(data$unit)#all the same units=good!
#continue filtering
unique(data$primary.type)#specifies the waterbody type, export to comments. concatenate "Waterbody designated as a" + "data$primary.type"+ "in the source data"
unique(data$method)#specifies SECCHI
#check to see if obs. are flagged as less than detection limit
unique(data$lessthan)#none flagged, because there is no detection limit for secchi disk
#proceed to populating LAGOS template


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$basinid
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$StreamName.FacilityName
data.Export$SourceVariableName = "Transparency (Water column) with tube"
data.Export$SourceVariableDescription = "Secchi depth with view scope"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no flags w/ these data
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 30
data.Export$LagosVariableName="Secchi"
names(data)
unique(data$unit)#meters
unique(data$value)
data.Export$Value=data$value #export secchi obs, already in preff. units
unique(data.Export$Value)
#populate censorcode
unique(data$lessthan)#check to see if obs. is less than dl, if it is "TRUE" then censor as "LT", set all others to not censored "NT"
length(data$lessthan[which(data$lessthan=="TRUE")])#set as "LT"
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode="NC" #these secchi disk obs. are not censored
unique(data.Export$CensorCode)
data.Export$Date = data$tripdate#date already in correct format
data.Export$Units="m"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="SPECIFIED"#per metadata
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")])
#assign sampledepth 
data.Export$SampleDepth= NA #n/a to secchi
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
unique(data$proximity)
unique(data$landmark.facility.name)
data.Export$BasinType[grep("deepest",data$proximity,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deep",data$proximity,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deepest",data$landmark.facility.name,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deep",data$landmark.facility.name,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[which(is.na(data.Export$BasinType)==TRUE)]="UNKNOWN" #set remaining obs to unknown
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = "SECCHI_VIEW" #per meta
data.Export$LabMethodName=NA
unique(data.Export$LabMethodName)
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #per meta
data.Export$Comments=as.character(data.Export$Comments)
unique(data$primary.type)
a="Source data specifies that this waterbody is a"
data.Export$Comments=paste(a,data$primary.type)
unique(data.Export$Comments)
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
secchi1.Final = data.Export
rm(data)
rm(data.Export)
rm(a)

################################### Transparency (Water column)  #############################################################################################################################
data=ct_deep_chem
unique(data$ChemParameter)#look at parameters
#pull out parameter of interest
length(data$ChemParameter[which(data$ChemParameter=="Transparency (Water column)")]) #check no. of observations
data=data[which(data$ChemParameter=="Transparency (Water column)"),]
unique(data$media)#nothing to filter out
#proceed with other filtering
unique(data$donotuse)#filter out those that are "TRUE", none here
#continue filtering
unique(data$value)#look at data for problematic values
#check for null observations
length(data$value[which(data$value=="")])
length(data$value[which(is.na(data$value)==TRUE)])
data=data[which(is.na(data$value)==FALSE),]#filter out 2 null obs
#check units
unique(data$unit)#different units, but equivalent, must convert to ug/l
#continue filtering
unique(data$primary.type)#specifies the waterbody type, export to comments. concatenate "Waterbody designated as a" + "data$primary.type"+ "in the source data"
unique(data$method)#specifies SECCHI
#check to see if obs. are flagged as less than detection limit
unique(data$lessthan)#none flagged, because there is no detection limit for secchi disk
#proceed to populating LAGOS template


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$basinid
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$StreamName.FacilityName
data.Export$SourceVariableName = "Transparency (Water column)"
data.Export$SourceVariableDescription = "Secchi depth (unknown if view scope was used)"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no flags w/ these data
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 30
data.Export$LagosVariableName="Secchi"
names(data)
unique(data$unit)#meters
unique(data$value)
data.Export$Value=data$value #export secchi obs, already in preff. units
unique(data.Export$Value)
#populate censorcode
unique(data$lessthan)#check to see if obs. is less than dl, if it is "TRUE" then censor as "LT", set all others to not censored "NT"
length(data$lessthan[which(data$lessthan=="TRUE")])#set as "LT"
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode="NC" #these secchi disk obs. are not censored
unique(data.Export$CensorCode)
data.Export$Date = data$tripdate#date already in correct format
data.Export$Units="m"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="SPECIFIED"#per metadata
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")])
#assign sampledepth 
data.Export$SampleDepth= NA #n/a to secchi
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
unique(data$proximity)
unique(data$landmark.facility.name)
data.Export$BasinType[grep("deepest",data$proximity,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deep",data$proximity,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deepest",data$landmark.facility.name,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("deep",data$landmark.facility.name,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[which(is.na(data.Export$BasinType)==TRUE)]="UNKNOWN" #set remaining obs to unknown
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = "SECCHI_VIEW_UNKNOWN" #per meta
data.Export$LabMethodName=NA
unique(data.Export$LabMethodName)
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #per meta
data.Export$Comments=as.character(data.Export$Comments)
unique(data$primary.type)
a="Source data specifies that this waterbody is a"
data.Export$Comments=paste(a,data$primary.type)
unique(data.Export$Comments)
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
secchi2.Final = data.Export
rm(data)
rm(data.Export)
rm(a)


###################################### final export ########################################################################################
Final.Export = rbind(chla.Final,doc.Final,nh4.Final,nh41.Final,no2.Final,no3.Final,tdn.Final,tn.Final,toc.Final,tkn.Final,tkn1.Final,srp.Final,tdp.Final,secchi.Final,secchi1.Final,secchi2.Final)

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
764+5581#adds up to total
##write table
Final.Export1=data1
typeof(Final.Export1$Value)
unique(Final.Export1$Value)
Final.Export1$Value=as.numeric(Final.Export1$Value)
length(Final.Export1$Value[which(Final.Export1$Value<0)])
nosamplepos=Final.Export1[which(is.na(Final.Export1$SampleDepth)==TRUE & Final.Export1$SamplePosition=="UNKNOWN"),]
write.table(Final.Export1,file="DataImport_CT_DEEP_CHEM.csv",row.names=FALSE,sep=",")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/CT data/CT_ENH/CT_Chemistry_finished/DataImport_CT_DEEP_CHEM/DataImport_CT_DEEP_CHEM.RData")