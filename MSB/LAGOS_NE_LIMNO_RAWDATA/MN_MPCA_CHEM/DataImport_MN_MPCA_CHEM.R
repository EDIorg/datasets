#path to files
setwd("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MN data/MPCA_chemistry/DataImport_MPCA_chemistry")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MN data/MPCA_chemistry/DataImport_MPCA_chemistry/DataImport_MN_MPCA_chemistry.RData")

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
#data from minnesota pollution control agency, a lake monitoring program
#missing values= blank cells
#SampleType may be either integrated or grab --> Integrated if Sample_Upper_Depth and Sample_Lower_Depth BOTH poupulated
#Otherwise it is Grab and the depth is specified in Upper_Depth. 
#CensorCode specified in the variable "GTLT"
#Sample_Fraction_Type lists whether a variable is dissolved or particulate, separate processing for the "particulate" and "dissolved form" will occur for some variables as they have unique lagos id's
#note that the data file "MPCA_SAMPLE_TYPE_definitions.xlsx" in my R workspace lists the different
#SAMPLE_TYPE values
#don't have to worry about dealing with replicates
###########################################################################################################################################################################################
################################### Organic carbon (dissolved)#############################################################################################################################
data=MPCA_CHEM
head(data) #looking at data
names(data)#column names
#filter out data not interested in
data$PARAMETER=as.character(data$PARAMETER)
unique(data$PARAMETER) #look for name of variable interested in
data = data[which(data$PARAMETER =="Organic carbon"),] #filter out all other variables
unique(data$SAMPLE_FRACTION_TYPE)
data = data[which(data$SAMPLE_FRACTION_TYPE=="Dissolved"),] #we're only interested in dissolved oc here
unique(data$SAMPLE_FRACTION_TYPE)#check to make sure only dissolved
unique(data$RESULT)
data$RESULT[which(data$RESULT=="")]=NA #missing values indicated by blank cell, set to NA
length(data$RESULT[which(is.na(data$RESULT)==TRUE)]) #check for NA values
length(data$RESULT[which(data$RESULT=="")])
data = data[which(is.na(data$RESULT)==FALSE),] #remove NA values (none here)
unique(data$PARAMETER)#check to make sure not other parameters mixed in
unique(data$RESULT_UNIT) #check to make sure only one unique unit
unique(data$STATISTIC_TYPE) #look at what's unique here, filter out, null
#can filter out values related to the analytical procedure 
data = data[,c(1:2,4:6,9:10,12:13)]
head(data)
unique(data$GTLT) #no unique GTLT so there will be no CensorCode here
unique(data$COMMENT) #no unique comments that specify i.e. a data flag

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$LOCATION_ID
data.Export$LakeName = NA #lake name (text) not specified in the data
data.Export$SourceVariableName = "Organic carbon"
data.Export$SourceVariableDescription = "Dissolved organic carbon"
data.Export$SourceFlags = NA #set source flags, none associated with this data set
data.Export$LagosVariableID = 6
data.Export$LagosVariableName="Carbon, dissolved organic"
data.Export$Value = data[,7] #export doc values,no unit conversions required, already in pref. units
data.Export$CensorCode = "NC" #no unique GTLT specifications, which would determine CensorCode
data.Export$Date = data$SAMPLE_DATE #date already in correct format
data.Export$Units="mg/L"
#prepare to populate sampletype and sample position
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data$SAMPLE_UPPER_DEPTH[which(data$SAMPLE_UPPER_DEPTH=="")]=NA 
data$SAMPLE_LOWER_DEPTH[which(data$SAMPLE_LOWER_DEPTH=="")]=NA 
#check for integrated samples, note that the result is the same even if you take a subset of SAMPLE_LOWER_DEPTH
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)])
#check for grab samples
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)])
# 117 integrated, 909 grab
#check for obs which are null for both depth observations
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==TRUE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]) #check for samples which do not have either depth field specified
#no obs null for both depth obs
#populate SampleType
data.Export$SampleType[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]= "INTEGRATED"
data.Export$SampleType[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]= "GRAB"
unique(data.Export$SampleType)
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure proper number exported
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure proper number exported
#populate SamplePosition
data.Export$SamplePosition="SPECIFIED"
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]=data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]
data.Export$SampleDepth[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]=data$SAMPLE_LOWER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType="UNKNOWN" #not specified in data
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable to DOC
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "LEG_P00681"
data.Export$DetectionLimit= NA #per metadata
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data.Export$SampleType=="GRAB")]="Sample collected with a Kemmerer"
length(data.Export$Comments[which(data.Export$Comments=="Sample collected with a Kemmerer")]) #check to make sure proper number of comments
data.Export$Subprogram= NA #not specified
DOC.Final = data.Export
rm(data)
rm(data.Export)
################################### Organic carbon (total)#############################################################################################################################
data=MPCA_CHEM
head(data) #looking at data
names(data)#column names
#filter out data not interested in
data$PARAMETER=as.character(data$PARAMETER)
unique(data$PARAMETER) #look for name of variable interested in
data = data[which(data$PARAMETER =="Organic carbon"),] #filter out all other variables
unique(data$SAMPLE_FRACTION_TYPE)
data = data[which(data$SAMPLE_FRACTION_TYPE=="Total"),] #we're only interested in dissolved oc here
unique(data$SAMPLE_FRACTION_TYPE)#check to make sure only dissolved
data$RESULT[which(data$RESULT=="")]=NA #missing values indicated by blank cell, set to NA
length(data$RESULT[which(is.na(data$RESULT)==TRUE)]) #check for NA values
data = data[which(is.na(data$RESULT)==FALSE),] #remove NA values (none here)
unique(data$PARAMETER)#check to make sure not other parameters mixed in
unique(data$RESULT_UNIT) #check to make sure only one unique unit
unique(data$STATISTIC_TYPE) #look at what's unique here, filter out, null
#can filter out values related to the analytical procedure 
data = data[,c(1:2,4:6,9:10,12:13)]
head(data)
unique(data$GTLT) #no unique GTLT so there will be no CensorCode here
unique(data$COMMENT) #no unique comments that specify i.e. a data flag

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$LOCATION_ID
data.Export$LakeName = NA #lake name (text) not specified in the data
data.Export$SourceVariableName = "Organic carbon"
data.Export$SourceVariableDescription = "Total organic carbon"
data.Export$SourceFlags = NA #set source flags, none associated with this data set
data.Export$LagosVariableID = 7
data.Export$LagosVariableName="Carbon, total organic"
data.Export$Value = data[,7] #export toc values,no unit conversions required, already in pref. units
data.Export$CensorCode = "NC" #no unique GTLT specifications, which would determine CensorCode
data.Export$Date = data$SAMPLE_DATE #date already in correct format
data.Export$Units="mg/L"
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data$SAMPLE_UPPER_DEPTH[which(data$SAMPLE_UPPER_DEPTH=="")]=NA 
data$SAMPLE_LOWER_DEPTH[which(data$SAMPLE_LOWER_DEPTH=="")]=NA 
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)])#check for integrated samples
#18 INTEGRATED SAMPLES
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)])#check for grab samples
#218 GRAB SAMPLES
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==TRUE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]) #check for samples which do not have either depth field specified
#0 observations have to be removed because they are null for both SampleDepth and SamplePosition
#specify sample type
data.Export$SampleType[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]= "INTEGRATED"
data.Export$SampleType[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]= "GRAB"
unique(data.Export$SampleType) #check to make sure proper info exported
#specify sample position
data.Export$SamplePosition="SPECIFIED"
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]=data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]
data.Export$SampleDepth[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]=data$SAMPLE_LOWER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType="UNKNOWN" #not specified in data
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable to toc
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "LEG_P00680"
data.Export$DetectionLimit= NA #per metadata
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data.Export$SampleType=="GRAB")]="Sample collected with a Kemmerer"
length(data.Export$Comments[which(data.Export$Comments=="Sample collected with a Kemmerer")]) #check to make sure proper number of comments
data.Export$Subprogram= NA #not specified
TOC.Final = data.Export
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MN data/MPCA_chemistry/DataImport_MPCA_chemistry/DataImport_MN_MPCA_chemistry.RData")
rm(data)
rm(data.Export)
################################### Chlorophyll a, corrected for pheaophytin#############################################################################################################################
#be sure to specify different analytical method types
data=MPCA_CHEM
head(data) #looking at data
names(data)#column names
#filter out data not interested in
data$PARAMETER=as.character(data$PARAMETER)
unique(data$PARAMETER) #look for name of variable interested in
data = data[which(data$PARAMETER =="Chlorophyll a, corrected for pheophytin"),] #filter out all other variables
unique(data$SAMPLE_FRACTION_TYPE)
data = data[which(data$SAMPLE_FRACTION_TYPE=="Non-filter"),] #shouldn't change anything
unique(data$SAMPLE_FRACTION_TYPE)#check to make sure only dissolved
data$RESULT[which(data$RESULT=="")]=NA #missing values indicated by blank cell, set to NA
length(data$RESULT[which(is.na(data$RESULT)==TRUE)]) #check for NA values
data = data[which(is.na(data$RESULT)==FALSE),] #remove NA values, 4 here
unique(data$PARAMETER)#check to make sure not other parameters mixed in
unique(data$RESULT_UNIT) #check to make sure only one unique unit
unique(data$STATISTIC_TYPE) #look at what's unique here, nothing specified
unique(data$TEST_METHOD_ID) #three unique analytical methods used, one not specified in emi's metadta
data = data[,c(1:2,4:6,9:10,12:13,15)]#filter out columns of interest
head(data)
unique(data$GTLT) # "<" only GTLT value = CensorCode "LT"
unique(data$COMMENT) #don't export these comments, they don't relate to the sampling event
###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$LOCATION_ID
data.Export$LakeName = NA #lake name (text) not specified in the data
data.Export$SourceVariableName = "Chlorophyll a, corrected for pheaophytin"
data.Export$SourceVariableDescription = "Chlorophyll a corrected for phaeophytin"
data.Export$SourceFlags = NA #set source flags, none associated with this data set
data.Export$LagosVariableID = 9
data.Export$LagosVariableName="Chlorophyll a"
data.Export$Value = data[,7] #export chla values,no unit conversions required, already in pref. units
#populate CensorCode
unique(data$GTLT)
length(data$GTLT[which(data$GTLT=="< ")])
data.Export$CensorCode=as.character(data.Export$CensorCode)
#245 observations are "<"= "LT"
data.Export$CensorCode[which(data$GTLT=="< " )]= "LT"
data.Export$CensorCode[which(data$GTLT=="")]="NC" 
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")]) #check to make sure proper number exported
length(data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]) #check to make sure prope NA assigned
#continue populating lagos
data.Export$Date = data$SAMPLE_DATE #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype and sample position
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data$SAMPLE_UPPER_DEPTH[which(data$SAMPLE_UPPER_DEPTH=="")]=NA 
data$SAMPLE_LOWER_DEPTH[which(data$SAMPLE_LOWER_DEPTH=="")]=NA 
#check for integrated samples
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)])
#check for grab samples
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)])
# 3265 integrated, 9953 grab
#check for obs which are null for both depth observations
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==TRUE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]) #check for samples which do not have either depth field specified
#no obs null for both depth obs
#populate SampleType
data.Export$SampleType[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]= "INTEGRATED"
data.Export$SampleType[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]= "GRAB"
unique(data.Export$SampleType)
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure proper number exported
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure proper number exported
#populate SamplePosition
data.Export$SamplePosition = "SPECIFIED"
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]=data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]
data.Export$SampleDepth[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]=data$SAMPLE_LOWER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType="UNKNOWN" #not specified in data
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable to chla
#populate LabMethodName
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data$TEST_METHOD_ID=as.character(data$TEST_METHOD_ID)
unique(data$TEST_METHOD_ID)
data.Export$LabMethodName[which(data$TEST_METHOD_ID=="LEG_P32211")]= "LEG_P32211"
data.Export$LabMethodName[which(data$TEST_METHOD_ID=="LEG_P32209")]= "LEG_P32209"
data.Export$LabMethodName[which(data$TEST_METHOD_ID=="LEG_UNKNOWN")]= "UNKNOWN"
unique(data.Export$LabMethodName) #check to make sure correct values
#there are different detection limits specified  for LEG_P32211 (only), but there are multiple
#detection limits for LEG_P32211, and they can't be attached to a specific observation
#thus set DetectionLimit to NA for all 
data.Export$DetectionLimit= NA 
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data.Export$SampleType=="GRAB")]="Sample collected with a Kemmerer"
length(data.Export$Comments[which(data.Export$Comments=="Sample collected with a Kemmerer")]) #check to make sure proper number of comments
data.Export$Subprogram= NA #not specified
CHLA.Final = data.Export
rm(data)
rm(data.Export)
################################### Apparent Color  #############################################################################################################################
data=MPCA_CHEM
head(data) #looking at data
names(data)#column names
#filter out data not interested in
data$PARAMETER=as.character(data$PARAMETER)
unique(data$PARAMETER) #look for name of variable interested in
data = data[which(data$PARAMETER =="Apparent color"),] #filter out all other variables
unique(data$SAMPLE_FRACTION_TYPE)
data = data[which(data$SAMPLE_FRACTION_TYPE=="Dissolved"),] #shouldn't change anything
unique(data$SAMPLE_FRACTION_TYPE)#check to make sure only dissolved
data$RESULT[which(data$RESULT=="")]=NA #missing values indicated by blank cell, set to NA
length(data$RESULT[which(is.na(data$RESULT)==TRUE)]) #check for NA values, 53 here
data = data[which(is.na(data$RESULT)==FALSE),] #remove NA values, 4 here
unique(data$PARAMETER)#check to make sure not other parameters mixed in
unique(data$RESULT_UNIT) #check to make sure only one unique unit
unique(data$STATISTIC_TYPE) #look at what's unique here, nothing specified
unique(data$TEST_METHOD_ID) #three unique analytical methods used, one not specified in emi's metadta
data = data[,c(1:2,4:6,9:10,12:13)]#filter out columns of interest
head(data)
unique(data$GTLT) # "<" only GTLT value = CensorCode "LT"
unique(data$COMMENT) #don't export these comments, they don't relate to the sampling event
###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$LOCATION_ID
data.Export$LakeName = NA #lake name (text) not specified in the data
data.Export$SourceVariableName = "Apparent Color"
data.Export$SourceVariableDescription = "Apparent color"
data.Export$SourceFlags = NA #set source flags, none associated with this data set
data.Export$LagosVariableID = 11
data.Export$LagosVariableName="Color, apparent"
data.Export$Value = data[,7] #export apparent color values,no unit conversions required, already in pref. units
#populate CensorCode
unique(data$GTLT)
length(data$GTLT[which(data$GTLT=="< ")]) #check for how many
data.Export$CensorCode=as.character(data.Export$CensorCode)
#252 observations are "<"= "LT"
data.Export$CensorCode[which(data$GTLT=="< " )]= "LT"
data.Export$CensorCode[which(data$GTLT=="")]="NC"
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")]) #check to make sure proper number exported
length(data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]) #check to make sure prope NA assigned
#continue populating lagos
data.Export$Date = data$SAMPLE_DATE #date already in correct format
data.Export$Units="PCU"
#prepare to populate sampletype and sample position
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data$SAMPLE_UPPER_DEPTH[which(data$SAMPLE_UPPER_DEPTH=="")]=NA 
data$SAMPLE_LOWER_DEPTH[which(data$SAMPLE_LOWER_DEPTH=="")]=NA 
#check for integrated samples
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)])
#check for grab samples
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)])
# 1698 integrated, 7705 grab
#check for obs which are null for both depth observations
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==TRUE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]) #check for samples which do not have either depth field specified
#no obs null for both depth obs
#populate SampleType
data.Export$SampleType[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]= "INTEGRATED"
data.Export$SampleType[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]= "GRAB"
unique(data.Export$SampleType)
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure proper number exported
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure proper number exported
#populate SamplePosition
data.Export$SamplePosition = "SPECIFIED"
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]=data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]
data.Export$SampleDepth[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]=data$SAMPLE_LOWER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType="UNKNOWN" #not specified in data
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable to apparent color
#populate LabMethodName
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "LEG_P00080"
#multiple detection limits for this anlaytical method, can't attach a specific
#detection limit to a given observation
#set all to NA
unique(data.Export$LabMethodName) #check to make sure correct values
data.Export$DetectionLimit= NA 
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data.Export$SampleType=="GRAB")]="Sample collected with a Kemmerer"
length(data.Export$Comments[which(data.Export$Comments=="Sample collected with a Kemmerer")]) #check to make sure proper number of comments
data.Export$Subprogram= NA #not specified
ACOLOR.Final = data.Export
rm(data)
rm(data.Export)
################################### True Color  #############################################################################################################################
data=MPCA_CHEM
head(data) #looking at data
names(data)#column names
#filter out data not interested in
data$PARAMETER=as.character(data$PARAMETER)
unique(data$PARAMETER) #look for name of variable interested in
data = data[which(data$PARAMETER =="True color"),] #filter out all other variables
#only 12 obs. of "True color"
unique(data$SAMPLE_FRACTION_TYPE)
data = data[which(data$SAMPLE_FRACTION_TYPE=="Dissolved"),] #shouldn't change anything
unique(data$SAMPLE_FRACTION_TYPE)#check to make sure only dissolved
data$RESULT[which(data$RESULT=="")]=NA #missing values indicated by blank cell, set to NA
length(data$RESULT[which(is.na(data$RESULT)==TRUE)]) #check for NA values, none here
data = data[which(is.na(data$RESULT)==FALSE),] #remove NA values, 4 here
unique(data$PARAMETER)#check to make sure not other parameters mixed in
unique(data$RESULT_UNIT) #check to make sure only one unique unit
unique(data$STATISTIC_TYPE) #look at what's unique here, nothing specified
unique(data$TEST_METHOD_ID) #three unique analytical methods used, one not specified in emi's metadta
#LEG_UNKNOWN  is the only TEST_METHOD_ID type. 
data = data[,c(1:2,4:6,9:10,12:13)]#filter out columns of interest
head(data)
unique(data$GTLT) #none, all CensorCode=NA
unique(data$COMMENT) #don't export these comments, they don't relate to the sampling event
#no comments in this case anyhow
###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$LOCATION_ID
data.Export$LakeName = NA #lake name (text) not specified in the data
data.Export$SourceVariableName = "True Color"
data.Export$SourceVariableDescription = "True color dissolved"
data.Export$SourceFlags = NA #set source flags, none associated with this data set
data.Export$LagosVariableID = 12
data.Export$LagosVariableName="Color, true"
data.Export$Value = data[,7] #export apparent color values,no unit conversions required, already in pref. units
#populate CensorCode
unique(data$GTLT) #no unique
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode= "NC"

#continue populating lagos
data.Export$Date = data$SAMPLE_DATE #date already in correct format
data.Export$Units="PCU"
#prepare to populate sampletype and sample position
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data$SAMPLE_UPPER_DEPTH[which(data$SAMPLE_UPPER_DEPTH=="")]=NA 
data$SAMPLE_LOWER_DEPTH[which(data$SAMPLE_LOWER_DEPTH=="")]=NA 
#check for integrated samples
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)])
#check for grab samples
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)])
# 5 integrated, 7 grab
#check for obs which are null for both depth observations
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==TRUE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]) #check for samples which do not have either depth field specified
#no obs null for both depth obs
#populate SampleType
data.Export$SampleType[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]= "INTEGRATED"
data.Export$SampleType[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]= "GRAB"
unique(data.Export$SampleType)
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure proper number exported
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure proper number exported
#populate SamplePosition
data.Export$SamplePosition="EPI"
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]=data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]
data.Export$SampleDepth[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]=data$SAMPLE_LOWER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])
unique(data.Export$SampleDepth)

#continue populating other lagos fields
data.Export$BasinType="UNKNOWN" #not specified in data
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = "Unknown procedure" 
#populate LabMethodName
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #LEG_UNKNOWN = procedure unknown
unique(data.Export$LabMethodName) #check to make sure correct values
data.Export$DetectionLimit= NA 
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data.Export$SampleType=="GRAB")]="Sample collected with a Kemmerer"
length(data.Export$Comments[which(data.Export$Comments=="Sample collected with a Kemmerer")]) #check to make sure proper number of comments
data.Export$Subprogram= NA #not specified
TCOLOR.Final = data.Export
rm(data)
rm(data.Export)

################################### Kjeldahl nitrogen #############################################################################################################################
data=MPCA_CHEM
head(data) #looking at data
names(data)#column names
#filter out data not interested in
data$PARAMETER=as.character(data$PARAMETER)
unique(data$PARAMETER) #look for name of variable interested in
data = data[which(data$PARAMETER =="Kjeldahl nitrogen"),] #filter out all other variables
unique(data$SAMPLE_FRACTION_TYPE)
data = data[which(data$SAMPLE_FRACTION_TYPE=="Dissolved"),] #interested in the Dissolved KN (DKN) which has a seaprate lagos id than total KN (TKN)
#wow, only one observation of dkn
unique(data$SAMPLE_FRACTION_TYPE)#check to make sure only dissolved
data$RESULT[which(data$RESULT=="")]=NA #missing values indicated by blank cell, set to NA
length(data$RESULT[which(is.na(data$RESULT)==TRUE)]) #check for NA values
data = data[which(is.na(data$RESULT)==FALSE),] #remove NA values, 0 here
unique(data$PARAMETER)#check to make sure not other parameters mixed in
unique(data$RESULT_UNIT) #check to make sure only one unique unit
unique(data$STATISTIC_TYPE) #look at what's unique here, nothing specified
unique(data$TEST_METHOD_ID) #three unique analytical methods used, one not specified in emi's metadta
data = data[,c(1:2,4:6,9:10,12:13,15)]#filter out columns of interest
head(data)
unique(data$GTLT) # "<" only GTLT value = CensorCode "LT"
unique(data$COMMENT) #don't export these comments, they don't relate to the sampling event
###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$LOCATION_ID
data.Export$LakeName = NA #lake name (text) not specified in the data
data.Export$SourceVariableName = "Kjeldahl nitrogen"
data.Export$SourceVariableDescription = "Dissolved kjeldahl nitrogen"
data.Export$SourceFlags = NA #set source flags, none associated with this data set
data.Export$LagosVariableID = 15
data.Export$LagosVariableName="Nitrogen, dissolved Kjeldahl"
names(data)
data.Export$Value=as.character(data.Export$Value)
data$RESULT=as.character(data$RESULT)
data.Export$Value = data[,7] #export dkn obs and multiply by 1000 to go from mg/l to the preferred units of ug/
data.Export$Value=as.numeric(data.Export$Value)
data.Export$Value=(data.Export$Value)*1000
data.Export$Value=as.character(data.Export$Value)
#populate CensorCode
unique(data$GTLT) #none unique
data.Export$CensorCode="NC"

#continue populating lagos
data.Export$Date = data$SAMPLE_DATE #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype and sample position
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data$SAMPLE_UPPER_DEPTH[which(data$SAMPLE_UPPER_DEPTH=="")]=NA 
data$SAMPLE_LOWER_DEPTH[which(data$SAMPLE_LOWER_DEPTH=="")]=NA 
#check for integrated samples
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)])
#check for grab samples
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)])
# the single observaiton is integrated
#check for obs which are null for both depth observations
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==TRUE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]) #check for samples which do not have either depth field specified
#no obs null for both depth obs
#populate SampleType
data.Export$SampleType[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]= "INTEGRATED"
data.Export$SampleType[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]= "GRAB"
unique(data.Export$SampleType)
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure proper number exported
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure proper number exported
#populate SamplePosition
data.Export$SamplePosition = "SPECIFIED"
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth[which(data.Export$SampleType=="GRAB")]=data$SAMPLE_UPPER_DEPTH
data.Export$SampleDepth[which(data.Export$SampleType=="INTEGRATED")]=data$SAMPLE_LOWER_DEPTH
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])
data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)]=data$SAMPLE_UPPER_DEPTH
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType="UNKNOWN" #not specified in data
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable to DKN
#populate LabMethodName
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data$TEST_METHOD_ID=as.character(data$TEST_METHOD_ID)
unique(data$TEST_METHOD_ID)
data.Export$LabMethodName[which(data$TEST_METHOD_ID=="LEG_P00623")]= "LEG_P00623"
unique(data.Export$LabMethodName) #check to make sure correct values
data.Export$DetectionLimit= NA #no dl specified
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data.Export$SampleType=="GRAB")]="Sample collected with a Kemmerer"
length(data.Export$Comments[which(data.Export$Comments=="Sample collected with a Kemmerer")]) #check to make sure proper number of comments
data.Export$Subprogram= NA #not specified
DKN.Final = data.Export
rm(data)
rm(data.Export)

################################### Nitrate as N -Dissolved  #############################################################################################################################
#be sure to specify different analytical method types
data=MPCA_CHEM
head(data) #looking at data
names(data)#column names
#filter out data not interested in
data$PARAMETER=as.character(data$PARAMETER)
unique(data$PARAMETER) #look for name of variable interested in
data = data[which(data$PARAMETER =="Nitrate as N"),] #filter out all other variables
unique(data$SAMPLE_FRACTION_TYPE)
data = data[which(data$SAMPLE_FRACTION_TYPE=="Dissolved"),] #shouldn't change anything
unique(data$SAMPLE_FRACTION_TYPE)#check to make sure only dissolved
data$RESULT[which(data$RESULT=="")]=NA #missing values indicated by blank cell, set to NA
length(data$RESULT[which(is.na(data$RESULT)==TRUE)]) #check for NA values
data = data[which(is.na(data$RESULT)==FALSE),] #remove NA values, none here, makes no difference
unique(data$PARAMETER)#check to make sure not other parameters mixed in
unique(data$RESULT_UNIT) #check to make sure only one unique unit
unique(data$STATISTIC_TYPE) #look at what's unique here, nothing specified
unique(data$TEST_METHOD_ID) #only one unique analytical method
data = data[,c(1:2,4:6,9:10,12:13,15)]#filter out columns of interest
head(data)
unique(data$GTLT) # "<" only GTLT value = CensorCode "LT"
unique(data$COMMENT) #don't export these comments, they don't relate to the sampling event
#no comments here anyway
###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$LOCATION_ID
data.Export$LakeName = NA #lake name (text) not specified in the data
data.Export$SourceVariableName = "Nitrate as N"
data.Export$SourceVariableDescription = "Dissolved nitrate"
data.Export$SourceFlags = NA #set source flags, none associated with this data set
data.Export$LagosVariableID = 18
data.Export$LagosVariableName="Nitrogen, nitrite (NO2) + nitrate (NO3)"
names(data)
data.Export$Value=as.character(data.Export$Value)
data$RESULT=as.character(data$RESULT)
data.Export$Value = data[,7] #export n03 obs and multiply by 1000 to go from mg/l to the preferred units of ug/
data.Export$Value=as.numeric(data.Export$Value)
data.Export$Value=(data.Export$Value)*1000
data.Export$Value=as.character(data.Export$Value)
#populate CensorCode
unique(data$GTLT)
length(data$GTLT[which(data$GTLT=="< ")])
data.Export$CensorCode=as.character(data.Export$CensorCode)
#237 observations are "<"= "LT"
data.Export$CensorCode[which(data$GTLT=="< " )]= "LT"
data.Export$CensorCode[which(data$GTLT=="")]="NC"
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])
length(data.Export$CensorCode[which(data.Export$CensorCode=="NC")])
#check to make sure proper number exported
length(data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]) #check to make sure prope NA assigned
#continue populating lagos
data.Export$Date = data$SAMPLE_DATE #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype and sample position
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data$SAMPLE_UPPER_DEPTH[which(data$SAMPLE_UPPER_DEPTH=="")]=NA 
data$SAMPLE_LOWER_DEPTH[which(data$SAMPLE_LOWER_DEPTH=="")]=NA 
#check for integrated samples
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)])
#check for grab samples
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)])
# all observations are grab samples
#check for obs which are null for both depth observations
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==TRUE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]) #check for samples which do not have either depth field specified
#no obs null for both depth obs
#populate SampleType
data.Export$SampleType[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]= "INTEGRATED"
data.Export$SampleType[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]= "GRAB"
unique(data.Export$SampleType)
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure proper number exported
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure proper number exported
#populate SamplePosition
data.Export$SamplePosition = "SPECIFIED"
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth[which(data.Export$SampleType=="GRAB")]=data$SAMPLE_UPPER_DEPTH
data.Export$SampleDepth[which(data.Export$SampleType=="INTEGRATED")]=data$SAMPLE_LOWER_DEPTH
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])
data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)]=data$SAMPLE_UPPER_DEPTH
unique(data.Export$SampleDepth)

#continue populating other lagos fields
data.Export$BasinType="UNKNOWN" #not specified in data
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable to no3
#populate LabMethodName
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data$TEST_METHOD_ID=as.character(data$TEST_METHOD_ID)
unique(data$TEST_METHOD_ID)
data.Export$LabMethodName="LEG_P00618"
unique(data.Export$LabMethodName) #check to make sure correct values, this is the only analytical method
data.Export$DetectionLimit= NA #no info on dl
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data.Export$SampleType=="GRAB")]="Sample collected with a Kemmerer"
length(data.Export$Comments[which(data.Export$Comments=="Sample collected with a Kemmerer")]) #check to make sure proper number of comments
data.Export$Subprogram= NA #not specified
DNO3.Final = data.Export
rm(data)
rm(data.Export)

################################### Ammonia-nitrogen as N- dissolved#############################################################################################################################
#be sure to specify different analytical method types
data=MPCA_CHEM
head(data) #looking at data
names(data)#column names
#filter out data not interested in
data$PARAMETER=as.character(data$PARAMETER)
unique(data$PARAMETER) #look for name of variable interested in
data = data[which(data$PARAMETER =="Ammonia-nitrogen as N"),] #filter out all other variables
unique(data$SAMPLE_FRACTION_TYPE)
data = data[which(data$SAMPLE_FRACTION_TYPE=="Dissolved"),] #shouldn't change anything
unique(data$SAMPLE_FRACTION_TYPE)#check to make sure only dissolved
data$RESULT[which(data$RESULT=="")]=NA #missing values indicated by blank cell, set to NA
length(data$RESULT[which(is.na(data$RESULT)==TRUE)]) #check for NA values
data = data[which(is.na(data$RESULT)==FALSE),] #remove NA values, none here, makes no difference
unique(data$PARAMETER)#check to make sure not other parameters mixed in
unique(data$RESULT_UNIT) #check to make sure only one unique unit
unique(data$STATISTIC_TYPE) #look at what's unique here, nothing specified
unique(data$TEST_METHOD_ID) #only one unique analytical method
data = data[,c(1:2,4:6,9:10,12:13,15)]#filter out columns of interest
head(data)
unique(data$GTLT) # "<" only GTLT value = CensorCode "LT"
unique(data$COMMENT) #don't export these comments, they don't relate to the sampling event
#no comments here anyway
###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$LOCATION_ID
data.Export$LakeName = NA #lake name (text) not specified in the data
data.Export$SourceVariableName = "Ammonia-nitrogen as N"
data.Export$SourceVariableDescription = "Dissolved free ammonia as N"
data.Export$SourceFlags = NA #set source flags, none associated with this data set
data.Export$LagosVariableID = 19
data.Export$LagosVariableName="Nitrogen, NH4"
names(data)
data.Export$Value=as.character(data.Export$Value)
data$RESULT=as.character(data$RESULT)
data.Export$Value = data[,7] #export nh4 obs and multiply by 1000 to go from mg/l to the preferred units of ug/
data.Export$Value=as.numeric(data.Export$Value)
data.Export$Value=(data.Export$Value)*1000
data.Export$Value=as.character(data.Export$Value)
#populate CensorCode
unique(data$GTLT)
length(data$GTLT[which(data$GTLT=="< ")])
data.Export$CensorCode=as.character(data.Export$CensorCode)
#183 observations are "<"= "LT"
data.Export$CensorCode[which(data$GTLT=="< " )]= "LT"
data.Export$CensorCode[which(data$GTLT=="")]="NC" 
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")]) #check to make sure proper number exported
length(data.Export$CensorCode[which(data.Export$CensorCode=="NC")])
length(data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]) #check to make sure prope NA assigned
#continue populating lagos
data.Export$Date = data$SAMPLE_DATE #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype and sample position
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data$SAMPLE_UPPER_DEPTH[which(data$SAMPLE_UPPER_DEPTH=="")]=NA 
data$SAMPLE_LOWER_DEPTH[which(data$SAMPLE_LOWER_DEPTH=="")]=NA 
#check for integrated samples
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)])
#check for grab samples
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)])
# 21 integrated 788 grab
#check for obs which are null for both depth observations
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==TRUE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]) #check for samples which do not have either depth field specified
#no obs null for both depth obs
#populate SampleType
data.Export$SampleType[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]= "INTEGRATED"
data.Export$SampleType[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]= "GRAB"
unique(data.Export$SampleType)
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure proper number exported
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure proper number exported
#populate SamplePosition
data.Export$SamplePosition = "SPECIFIED"
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]=data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]
data.Export$SampleDepth[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]=data$SAMPLE_LOWER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])
unique(data.Export$SampleDepth)

#continue populating other lagos fields
data.Export$BasinType="UNKNOWN" #not specified in data
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo="DISSOLVED"
#populate LabMethodName
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data$TEST_METHOD_ID=as.character(data$TEST_METHOD_ID)
unique(data$TEST_METHOD_ID)
data.Export$LabMethodName="LEG_P00608"
unique(data.Export$LabMethodName) #check to make sure correct values, this is the only analytical method
data.Export$DetectionLimit= NA #no info on dl
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data.Export$SampleType=="GRAB")]="Sample collected with a Kemmerer"
length(data.Export$Comments[which(data.Export$Comments=="Sample collected with a Kemmerer")]) #check to make sure proper number of comments
data.Export$Subprogram= NA #not specified
DNH4.Final = data.Export
rm(data)
rm(data.Export)

################################### Ammonia-nitrogen as N- total#############################################################################################################################
#be sure to specify different analytical method types
data=MPCA_CHEM
head(data) #looking at data
names(data)#column names
#filter out data not interested in
data$PARAMETER=as.character(data$PARAMETER)
unique(data$PARAMETER) #look for name of variable interested in
data = data[which(data$PARAMETER =="Ammonia-nitrogen as N"),] #filter out all other variables
unique(data$SAMPLE_FRACTION_TYPE)
data = data[which(data$SAMPLE_FRACTION_TYPE=="Total"),] #shouldn't change anything
unique(data$SAMPLE_FRACTION_TYPE)#check to make sure only dissolved
data$RESULT[which(data$RESULT=="")]=NA #missing values indicated by blank cell, set to NA
length(data$RESULT[which(is.na(data$RESULT)==TRUE)]) #check for NA values
data = data[which(is.na(data$RESULT)==FALSE),] #remove NA values, none here, makes no difference
unique(data$PARAMETER)#check to make sure not other parameters mixed in
unique(data$RESULT_UNIT) #check to make sure only one unique unit
unique(data$STATISTIC_TYPE) #look at what's unique here, "Minimum" specified these obs are a censor code of "GT"
#don't worry about statistic type, those that are "minimum" correspond with observations that are ">"
unique(data$TEST_METHOD_ID) #only one unique analytical method
data = data[,c(1:2,4:6,9:10,12:13,15)]#filter out columns of interest
head(data)
unique(data$GTLT) # "<" and ">" only GTLT values = CensorCode "LT" and "GT"
unique(data$COMMENT) #don't export these comments, they don't relate to the sampling event
#no comments here anyway
###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$LOCATION_ID
data.Export$LakeName = NA #lake name (text) not specified in the data
data.Export$SourceVariableName = "Ammonia-nitrogen as N"
data.Export$SourceVariableDescription = "Total ammonia"
data.Export$SourceFlags = NA #set source flags, none associated with this data set
data.Export$LagosVariableID = 19
data.Export$LagosVariableName="Nitrogen, NH4"
names(data)
data.Export$Value=as.character(data.Export$Value)
data$RESULT=as.character(data$RESULT)
data.Export$Value = data[,7] #export nh4 obs and multiply by 1000 to go from mg/l to the preferred units of ug/
data.Export$Value=as.numeric(data.Export$Value)
data.Export$Value=(data.Export$Value)*1000
data.Export$Value=as.character(data.Export$Value)
#populate CensorCode
unique(data$GTLT)
length(data$GTLT[which(data$GTLT=="< ")])#840
length(data$GTLT[which(data$GTLT=="> ")])#12
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$GTLT=="< " )]= "LT"
data.Export$CensorCode[which(data$GTLT=="> " )]= "GT"
data.Export$CensorCode[which(data$GTLT=="")]="NC"
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")]) #check to make sure proper number exported
length(data.Export$CensorCode[which(data.Export$CensorCode=="GT")])
length(data.Export$CensorCode[which(data.Export$CensorCode=="NC")])
length(data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]) #check to make sure prope NA assigned
#continue populating lagos
data.Export$Date = data$SAMPLE_DATE #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype and sample position
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data$SAMPLE_UPPER_DEPTH[which(data$SAMPLE_UPPER_DEPTH=="")]=NA 
data$SAMPLE_LOWER_DEPTH[which(data$SAMPLE_LOWER_DEPTH=="")]=NA 
#check for integrated samples
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)])
#check for grab samples
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)])
# 423 are integrated, 9896 are grab
#check for obs which are null for both depth observations
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==TRUE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]) #check for samples which do not have either depth field specified
#no obs null for both depth obs
#populate SampleType
data.Export$SampleType[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]= "INTEGRATED"
data.Export$SampleType[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]= "GRAB"
unique(data.Export$SampleType)
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure proper number exported
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure proper number exported
#populate SamplePosition
data.Export$SamplePosition = "SPECIFIED"
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]=data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]
data.Export$SampleDepth[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]=data$SAMPLE_LOWER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])
unique(data.Export$SampleDepth)

#ignore warning message
#continue populating other lagos fields
data.Export$BasinType="UNKNOWN" #not specified in data
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo=NA
#populate LabMethodName
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data$TEST_METHOD_ID=as.character(data$TEST_METHOD_ID)
unique(data$TEST_METHOD_ID)
data.Export$LabMethodName="LEG_P00610"
unique(data.Export$LabMethodName) #check to make sure correct values, this is the only analytical method
data.Export$DetectionLimit= NA #no info on dl
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data.Export$SampleType=="GRAB")]="Sample collected with a Kemmerer"
length(data.Export$Comments[which(data.Export$Comments=="Sample collected with a Kemmerer")]) #check to make sure proper number of comments
data.Export$Subprogram= NA #not specified
TNH4.Final = data.Export
rm(data)
rm(data.Export)


###################################  Nitrate as N- Total  #############################################################################################################################
#be sure to specify different analytical method types
data=MPCA_CHEM
head(data) #looking at data
names(data)#column names
#filter out data not interested in
data$PARAMETER=as.character(data$PARAMETER)
unique(data$PARAMETER) #look for name of variable interested in
data = data[which(data$PARAMETER =="Nitrate as N"),] #filter out all other variables
unique(data$SAMPLE_FRACTION_TYPE)
data = data[which(data$SAMPLE_FRACTION_TYPE=="Total"),] #only interest in observations that measure total nitrate
unique(data$SAMPLE_FRACTION_TYPE)#check to make sure only total
data$RESULT[which(data$RESULT=="")]=NA #missing values indicated by blank cell, set to NA
length(data$RESULT[which(is.na(data$RESULT)==TRUE)]) #check for NA values
data = data[which(is.na(data$RESULT)==FALSE),] #remove NA values, 17 here
unique(data$PARAMETER)#check to make sure not other parameters mixed in
unique(data$RESULT_UNIT) #check to make sure only one unique unit
unique(data$STATISTIC_TYPE) #look at what's unique here, nothing specified
# "minimum" is specified as a unique "STATISTIC_TYPE," where "minimum" is attached to an observation export "LT" to CensorCode.
unique(data$TEST_METHOD_ID) #one unique analytical method used
data = data[,c(1:2,4:6,9:10,12:15),]#filter out columns of interest
head(data)
unique(data$GTLT) # "<" and ">" GTLT value = CensorCode "LT" "GT"; respectively
unique(data$COMMENT) #don't export these comments, they don't relate to the sampling event
###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$LOCATION_ID
data.Export$LakeName = NA #lake name (text) not specified in the data
data.Export$SourceVariableName = "Nitrate as N"
data.Export$SourceVariableDescription = "Total nitrate"
data.Export$SourceFlags = NA #set source flags, none associated with this data set
data.Export$LagosVariableID = 18
data.Export$LagosVariableName="Nitrogen, nitrite (NO2) + nitrate (NO3)"
names(data)
data.Export$Value=as.character(data.Export$Value)
data$RESULT=as.character(data$RESULT)
data.Export$Value = data[,7] #export tno3 obs and multiply by 1000 to go from mg/l to the preferred units of ug/
data.Export$Value=as.numeric(data.Export$Value)
data.Export$Value=(data.Export$Value)*1000
data.Export$Value=as.character(data.Export$Value)
#populate CensorCode
unique(data$GTLT)
data$GTLT=as.character(data$GTLT)
length(data$GTLT[which(data$GTLT=="< ")])
length(data$GTLT[which(data$GTLT=="> ")])
data.Export$CensorCode=as.character(data.Export$CensorCode)
#1782 observations are "<"= "LT," and 8 observations are ">"= "GT"
data.Export$CensorCode[which(data$GTLT=="< " )]= "LT"
data$STATISTIC_TYPE=as.character(data$STATISTIC_TYPE)
length(data$STATISTIC_TYPE[which(data$STATISTIC_TYPE=="Minimum")]) #8 are "minimum
data.Export$CensorCode[which(data$STATISTIC_TYPE=="Minimum")]="GT"
data.Export$CensorCode[which(data$GTLT=="> ")]= "GT" 
data.Export$CensorCode[which(data$GTLT=="")]="NC"
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")]) #check to make sure proper number exported
length(data.Export$CensorCode[which(data.Export$CensorCode=="GT")])
length(data.Export$CensorCode[which(data.Export$CensorCode=="NC")])
length(data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]) #check to make sure prope NA assigned
unique(data.Export$CensorCode)
#continue populating lagos
data.Export$Date = data$SAMPLE_DATE #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype and sample position
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data$SAMPLE_UPPER_DEPTH[which(data$SAMPLE_UPPER_DEPTH=="")]=NA 
data$SAMPLE_LOWER_DEPTH[which(data$SAMPLE_LOWER_DEPTH=="")]=NA 
#check for integrated samples
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)])
#check for grab samples
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)])
# 50 integrated, 6600 grab
#check for obs which are null for both depth observations
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==TRUE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]) #check for samples which do not have either depth field specified
#no obs null for both depth obs
#populate SampleType
data.Export$SampleType[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]= "INTEGRATED"
data.Export$SampleType[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]= "GRAB"
unique(data.Export$SampleType)
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure proper number exported
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure proper number exported
#populate SamplePosition
data.Export$SamplePosition = "SPECIFIED"
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]=data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]
data.Export$SampleDepth[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]=data$SAMPLE_LOWER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType="UNKNOWN" #not specified in data
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable to tno3
#populate LabMethodName
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data$TEST_METHOD_ID=as.character(data$TEST_METHOD_ID)
unique(data$TEST_METHOD_ID) #only one unique analytical method
data.Export$LabMethodName= "LEG_P00620"
#more than one detection limit in metadata, no way to associate a given dl with a given observation
#set DetectionLimit to NA
data.Export$DetectionLimit= NA 
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data.Export$SampleType=="GRAB")]="Sample collected with a Kemmerer"
length(data.Export$Comments[which(data.Export$Comments=="Sample collected with a Kemmerer")]) #check to make sure proper number of comments
data.Export$Subprogram= NA #not specified
TNO3.Final = data.Export
rm(data)
rm(data.Export)

################################### Nitrite as N    #############################################################################################################################
#be sure to specify different analytical method types
data=MPCA_CHEM
head(data) #looking at data
names(data)#column names
#filter out data not interested in
data$PARAMETER=as.character(data$PARAMETER)
unique(data$PARAMETER) #look for name of variable interested in
data = data[which(data$PARAMETER =="Nitrite as N"),] #filter out all other variables
unique(data$SAMPLE_FRACTION_TYPE)
data = data[which(data$SAMPLE_FRACTION_TYPE=="Total"),] #shouldn't change anything
unique(data$SAMPLE_FRACTION_TYPE)#check to make sure only dissolved
data$RESULT[which(data$RESULT=="")]=NA #missing values indicated by blank cell, set to NA
length(data$RESULT[which(is.na(data$RESULT)==TRUE)]) #check for NA values
data = data[which(is.na(data$RESULT)==FALSE),] #remove NA values, 13 here
unique(data$PARAMETER)#check to make sure not other parameters mixed in
unique(data$RESULT_UNIT) #check to make sure only one unique unit
unique(data$STATISTIC_TYPE) #look at what's unique here, nothing specified
unique(data$TEST_METHOD_ID) #one unique analytical method
data = data[,c(1:2,4:6,9:10,12:15)]#filter out columns of interest
head(data)
unique(data$GTLT) # "<" only GTLT value = CensorCode "LT"
unique(data$COMMENT) #don't export these comments, they don't relate to the sampling event
###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$LOCATION_ID
data.Export$LakeName = NA #lake name (text) not specified in the data
data.Export$SourceVariableName = "Nitrite as N"
data.Export$SourceVariableDescription = "Total nitrite"
data.Export$SourceFlags = NA #set source flags, none associated with this data set
data.Export$LagosVariableID = 17
data.Export$LagosVariableName="Nitrogen, nitrite (NO2)"
names(data)
data.Export$Value=as.character(data.Export$Value)
data$RESULT=as.character(data$RESULT)
data.Export$Value = data[,7] #export no2 obs and multiply by 1000 to go from mg/l to the preferred units of ug/
data.Export$Value=as.numeric(data.Export$Value)
data.Export$Value=(data.Export$Value)*1000
data.Export$Value=as.character(data.Export$Value)
#populate CensorCode
unique(data$GTLT)
length(data$GTLT[which(data$GTLT=="< ")])
data.Export$CensorCode=as.character(data.Export$CensorCode)
#2064 observations are "<"= "LT"
data.Export$CensorCode[which(data$GTLT=="< " )]= "LT"
data.Export$CensorCode[which(data$GTLT=="")]="NC"
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")]) #check to make sure proper number exported
length(data.Export$CensorCode[which(data.Export$CensorCode=="NC")])
length(data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]) #check to make sure prope NA assigned
3229+3714
#continue populating lagos
data.Export$Date = data$SAMPLE_DATE #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype and sample position
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data$SAMPLE_UPPER_DEPTH[which(data$SAMPLE_UPPER_DEPTH=="")]=NA 
data$SAMPLE_LOWER_DEPTH[which(data$SAMPLE_LOWER_DEPTH=="")]=NA 
#check for integrated samples
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)])
#check for grab samples
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)])
# no integrated, all grab samples
#check for obs which are null for both depth observations
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==TRUE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]) #check for samples which do not have either depth field specified
#no obs null for both depth obs
#populate SampleType
data.Export$SampleType[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]= "INTEGRATED"
data.Export$SampleType[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]= "GRAB"
unique(data.Export$SampleType)
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure proper number exported
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure proper number exported
#populate SamplePosition
data.Export$SamplePosition = "SPECIFIED"
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth[which(data.Export$SampleType=="GRAB")]=data$SAMPLE_UPPER_DEPTH
data.Export$SampleDepth[which(data.Export$SampleType=="INTEGRATED")]=data$SAMPLE_LOWER_DEPTH
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])
data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)]=data$SAMPLE_UPPER_DEPTH
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType="UNKNOWN" #not specified in data
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable to no2
#populate LabMethodName
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data$TEST_METHOD_ID=as.character(data$TEST_METHOD_ID)
unique(data$TEST_METHOD_ID)
data.Export$LabMethodName="LEG_P00615"
unique(data.Export$LabMethodName) #check to make sure correct values
# there are multiple detection limits for LEG_P00615, and they can't be attached to a specific observation
#thus set DetectionLimit to NA for all 
data.Export$DetectionLimit= NA 
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data.Export$SampleType=="GRAB")]="Sample collected with a Kemmerer"
length(data.Export$Comments[which(data.Export$Comments=="Sample collected with a Kemmerer")]) #check to make sure proper number of comments
data.Export$Subprogram= NA #not specified
NO2.Final = data.Export
rm(data)
rm(data.Export)

################################### Inorganic nitrogen (nitrate and nitrite) as N#############################################################################################################################
data=MPCA_CHEM
head(data) #looking at data
names(data)#column names
#filter out data not interested in
data$PARAMETER=as.character(data$PARAMETER)
unique(data$PARAMETER) #look for name of variable interested in
data = data[which(data$PARAMETER =="Inorganic nitrogen (nitrate and nitrite) as N"),] #filter out all other variables
unique(data$SAMPLE_FRACTION_TYPE)
data = data[which(data$SAMPLE_FRACTION_TYPE=="Total"),] #shouldn't change anything
unique(data$SAMPLE_FRACTION_TYPE)#check to make sure only dissolved
data$RESULT[which(data$RESULT=="")]=NA #missing values indicated by blank cell, set to NA
length(data$RESULT[which(is.na(data$RESULT)==TRUE)]) #check for NA values
data = data[which(is.na(data$RESULT)==FALSE),] #remove NA values, 486 here
unique(data$PARAMETER)#check to make sure not other parameters mixed in
unique(data$RESULT_UNIT) #check to make sure only one unique unit
unique(data$STATISTIC_TYPE) #look at what's unique here, nothing specified
#The unique data$STATISTIC_TYPE is "Minimum" which corresponds to a CensorCode of "GT" since a minimum value is reported
unique(data$TEST_METHOD_ID) #two unique analytical methods used
data = data[,c(1:2,4:6,9:10,12:15)]#filter out columns of interest
head(data)
unique(data$GTLT) # "<" ">" GTLT values = CensorCode "LT" and "GT"; respectively
unique(data$COMMENT) #don't export these comments, they don't relate to the sampling event
###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$LOCATION_ID
data.Export$LakeName = NA #lake name (text) not specified in the data
data.Export$SourceVariableName = "Inorganic nitrogen (nitrate and nitrite) as N"
data.Export$SourceVariableDescription = "Inorganic nitrogen nitrate and nitrite"
data.Export$SourceFlags = NA #set source flags, none associated with this data set
data.Export$LagosVariableID = 18
data.Export$LagosVariableName="Nitrogen, nitrite (NO2) + nitrate (NO3)"
names(data)
data.Export$Value=as.character(data.Export$Value)
data$RESULT=as.character(data$RESULT)
data.Export$Value = data[,7] #export dkn obs and multiply by 1000 to go from mg/l to the preferred units of ug/
data.Export$Value=as.numeric(data.Export$Value)
data.Export$Value=(data.Export$Value)*1000
data.Export$Value=as.character(data.Export$Value)
#populate CensorCode
unique(data$GTLT)
data$STATISTIC_TYPE=as.character(data$STATISTIC_TYPE)
length(data$STATISTIC_TYPE[which(data$STATISTIC_TYPE=="Minimum")]) #only one obs. "Minimum"
length(data$GTLT[which(data$GTLT=="< ")])
length(data$GTLT[which(data$GTLT=="> ")])
data.Export$CensorCode=as.character(data.Export$CensorCode)
#3778 observations are "<"= "LT"
data.Export$CensorCode[which(data$GTLT=="< " )]= "LT"
data.Export$CensorCode[which(data$STATISTIC_TYPE=="Minimum" )]= "GT"
data.Export$CensorCode[which(data$GTLT=="> " )]= "GT"
data.Export$CensorCode[which(data$GTLT=="")]="NC"
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")]) #check to make sure proper number exported
length(data.Export$CensorCode[which(data.Export$CensorCode=="GT")])
length(data.Export$CensorCode[which(data.Export$CensorCode=="NC")])
length(data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]) #check to make sure prope NA assigned
unique(data.Export$CensorCode)
#continue populating lagos
data.Export$Date = data$SAMPLE_DATE #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype and sample position
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data$SAMPLE_UPPER_DEPTH[which(data$SAMPLE_UPPER_DEPTH=="")]=NA 
data$SAMPLE_LOWER_DEPTH[which(data$SAMPLE_LOWER_DEPTH=="")]=NA 
#check for integrated samples
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)])
#check for grab samples
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)])
# 1424 integrated, 9463 grab
#check for obs which are null for both depth observations
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==TRUE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]) #check for samples which do not have either depth field specified
#no obs null for both depth obs
#populate SampleType
data.Export$SampleType[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]= "INTEGRATED"
data.Export$SampleType[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]= "GRAB"
unique(data.Export$SampleType)
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure proper number exported
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure proper number exported
#populate SamplePosition
data.Export$SamplePosition="SPECIFIED"
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]=data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]
data.Export$SampleDepth[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]=data$SAMPLE_LOWER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])
unique(data.Export$SampleDepth)

#ignore warning message
#continue populating other lagos fields
data.Export$BasinType="UNKNOWN" #not specified in data
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable to chla
#populate LabMethodName
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data$TEST_METHOD_ID=as.character(data$TEST_METHOD_ID)
unique(data$TEST_METHOD_ID)
data.Export$LabMethodName[which(data$TEST_METHOD_ID=="LEG_P00630")]= "LEG_P00630"
data.Export$LabMethodName[which(data$TEST_METHOD_ID=="LEG_UNKNOWN")]= "UNKNOWN"
unique(data.Export$LabMethodName) #check to make sure correct values
#there are different detection limits specified  for LEG_P00630 , but there are multiple
#detection limits ALSO specified, and they can't be attached to a specific observation
#thus set DetectionLimit to NA for all 
data.Export$DetectionLimit= NA 
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data.Export$SampleType=="GRAB")]="Sample collected with a Kemmerer"
length(data.Export$Comments[which(data.Export$Comments=="Sample collected with a Kemmerer")]) #check to make sure proper number of comments
data.Export$Subprogram= NA #not specified
INORGN.Final = data.Export
rm(data)
rm(data.Export)

################################### Nutrient-nitrogen as N  #############################################################################################################################
data=MPCA_CHEM
head(data) #looking at data
names(data)#column names
#filter out data not interested in
data$PARAMETER=as.character(data$PARAMETER)
unique(data$PARAMETER) #look for name of variable interested in
data = data[which(data$PARAMETER =="Nutrient-nitrogen as N"),] #filter out all other variables
unique(data$SAMPLE_FRACTION_TYPE)
data = data[which(data$SAMPLE_FRACTION_TYPE=="Total"),] #shouldn't change anything
unique(data$SAMPLE_FRACTION_TYPE)#check to make sure only dissolved
data$RESULT[which(data$RESULT=="")]=NA #missing values indicated by blank cell, set to NA
length(data$RESULT[which(is.na(data$RESULT)==TRUE)]) #check for NA values
data = data[which(is.na(data$RESULT)==FALSE),] #remove NA values, 1 here
unique(data$PARAMETER)#check to make sure not other parameters mixed in
unique(data$RESULT_UNIT) #check to make sure only one unique unit
unique(data$STATISTIC_TYPE) #look at what's unique here, nothing specified
unique(data$TEST_METHOD_ID) #two unique analytical methods used
data = data[,c(1:2,4:6,9:10,12:15)]#filter out columns of interest
head(data)
unique(data$GTLT) # no GTLT identifiers here
unique(data$COMMENT) #don't export these comments, they don't relate to the sampling event
###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$LOCATION_ID
data.Export$LakeName = NA #lake name (text) not specified in the data
data.Export$SourceVariableName = "Nutrient-nitrogen as N"
data.Export$SourceVariableDescription = "Total Nitrogen"
data.Export$SourceFlags = NA #set source flags, none associated with this data set
data.Export$LagosVariableID = 21
data.Export$LagosVariableName="Nitrogen, total"
names(data)
data.Export$Value=as.character(data.Export$Value)
data$RESULT=as.character(data$RESULT)
data.Export$Value = data[,7] #export nitrogen obs and multiply by 1000 to go from mg/l to the preferred units of ug/
data.Export$Value=as.numeric(data.Export$Value)
data.Export$Value=(data.Export$Value)*1000
data.Export$Value=as.character(data.Export$Value)
#populate CensorCode
unique(data$GTLT) #no unique set all CensorCode to NA
data.Export$CensorCode="NC" 
unique(data.Export$CensorCode)
#continue populating lagos
data.Export$Date = data$SAMPLE_DATE #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype and sample position
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data$SAMPLE_UPPER_DEPTH[which(data$SAMPLE_UPPER_DEPTH=="")]=NA 
data$SAMPLE_LOWER_DEPTH[which(data$SAMPLE_LOWER_DEPTH=="")]=NA 
#check for integrated samples
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)])
#check for grab samples
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)])
# 21 integrated, 1146 grab
#check for obs which are null for both depth observations
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==TRUE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]) #check for samples which do not have either depth field specified
#no obs null for both depth obs
#populate SampleType
data.Export$SampleType[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]= "INTEGRATED"
data.Export$SampleType[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]= "GRAB"
unique(data.Export$SampleType)
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure proper number exported
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure proper number exported
#populate SamplePosition
data.Export$SamplePosition = "SPECIFIED"
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]=data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]
data.Export$SampleDepth[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]=data$SAMPLE_LOWER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType="UNKNOWN" #not specified in data
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable to TN
#populate LabMethodName
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data$TEST_METHOD_ID=as.character(data$TEST_METHOD_ID)
unique(data$TEST_METHOD_ID)
data.Export$LabMethodName[which(data$TEST_METHOD_ID=="APHA 4500-NORGD")]= "APHA 4500-NORGD"
data.Export$LabMethodName[which(data$TEST_METHOD_ID=="LEG_P00600")]= "LEG_P00600"
unique(data.Export$LabMethodName) #check to make sure correct values
data.Export$DetectionLimit= NA #NO INFO ON detection limits
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data.Export$SampleType=="GRAB")]="Sample collected with a Kemmerer"
length(data.Export$Comments[which(data.Export$Comments=="Sample collected with a Kemmerer")]) #check to make sure proper number of comments
data.Export$Subprogram= NA #not specified
TN.Final = data.Export
rm(data)
rm(data.Export)

################################### Kjeldahl nitrogen- Total  #############################################################################################################################
data=MPCA_CHEM
head(data) #looking at data
names(data)#column names
#filter out data not interested in
data$PARAMETER=as.character(data$PARAMETER)
unique(data$PARAMETER) #look for name of variable interested in
data = data[which(data$PARAMETER =="Kjeldahl nitrogen"),] #filter out all other variables
unique(data$SAMPLE_FRACTION_TYPE)
data = data[which(data$SAMPLE_FRACTION_TYPE=="Total"),] #shouldn't change anything
unique(data$SAMPLE_FRACTION_TYPE)#check to make sure only dissolved
data$RESULT[which(data$RESULT=="")]=NA #missing values indicated by blank cell, set to NA
length(data$RESULT[which(is.na(data$RESULT)==TRUE)]) #check for NA values
data = data[which(is.na(data$RESULT)==FALSE),] #remove NA values, 2 here
unique(data$PARAMETER)#check to make sure not other parameters mixed in
unique(data$RESULT_UNIT) #check to make sure only one unique unit
unique(data$STATISTIC_TYPE) #look at what's unique here
#"Minimum" is the unique STATISTIC_TYPE and corresponds to a CensorCode of "GT"
unique(data$TEST_METHOD_ID) #two unique analytical methods used
data = data[,c(1:2,4:6,9:10,12:15)]#filter out columns of interest
head(data)
unique(data$GTLT) 
#GTLT specifies "<" and ">" which correspond to CensorCode "LT" and "GT"; respectively
unique(data$COMMENT) #don't export these comments, they don't relate to the sampling event
###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$LOCATION_ID
data.Export$LakeName = NA #lake name (text) not specified in the data
data.Export$SourceVariableName = "Kjeldahl nitrogen"
data.Export$SourceVariableDescription = "Total kjeldahl nitrogen"
data.Export$SourceFlags = NA #set source flags, none associated with this data set
data.Export$LagosVariableID = 16
data.Export$LagosVariableName="Nitrogen, total Kjeldahl"
names(data)
data.Export$Value=as.character(data.Export$Value)
data$RESULT=as.character(data$RESULT)
data.Export$Value = data[,7] #export tkn obs and multiply by 1000 to go from mg/l to the preferred units of ug/
data.Export$Value=as.numeric(data.Export$Value)
data.Export$Value=(data.Export$Value)*1000
data.Export$Value=as.character(data.Export$Value)
#populate CensorCode
unique(data$GTLT) #no unique set all CensorCode to NA
length(data$GTLT[which(data$GTLT=="> ")])
length(data$GTLT[which(data$GTLT=="< ")])
length(data$GTLT[which(data$STATISTIC_TYPE=="Minimum")])
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$GTLT=="< ")]= "LT"
data.Export$CensorCode[which(data$GTLT=="> ")]= "GT"
data.Export$CensorCode[which(data$STATISTIC_TYPE=="Minimum")]="GT"
data.Export$CensorCode[which(data$GTLT=="")]= "NC"
unique(data.Export$CensorCode)
#continue populating lagos
data.Export$Date = data$SAMPLE_DATE #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype and sample position
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data$SAMPLE_UPPER_DEPTH[which(data$SAMPLE_UPPER_DEPTH=="")]=NA 
data$SAMPLE_LOWER_DEPTH[which(data$SAMPLE_LOWER_DEPTH=="")]=NA 
#check for integrated samples
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)])
#check for grab samples
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)])
# 2035 integrated, 18720 grab
#check for obs which are null for both depth observations
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==TRUE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]) #check for samples which do not have either depth field specified
#no obs null for both depth obs
#populate SampleType
data.Export$SampleType[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]= "INTEGRATED"
data.Export$SampleType[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]= "GRAB"
unique(data.Export$SampleType)
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure proper number exported
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure proper number exported
#populate SamplePosition
data.Export$SamplePosition= "SPECIFIED"
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]=data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]
data.Export$SampleDepth[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]=data$SAMPLE_LOWER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])
unique(data.Export$SampleDepth)

#continue populating other lagos fields
data.Export$BasinType="UNKNOWN" #not specified in data
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable to TN
#populate LabMethodName
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data$TEST_METHOD_ID=as.character(data$TEST_METHOD_ID)
unique(data$TEST_METHOD_ID)
data.Export$LabMethodName[which(data$TEST_METHOD_ID=="LEG_P00625")]= "LEG_P00625"
data.Export$LabMethodName[which(data$TEST_METHOD_ID=="LEG_P00629")]= "LEG_P00629"
data.Export$LabMethodName[which(data$TEST_METHOD_ID=="LEG_UNKNOWN")]= "UNKNOWN"
unique(data.Export$LabMethodName) #check to make sure correct values
data.Export$DetectionLimit= NA #NO INFO ON detection limits
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data.Export$SampleType=="GRAB")]="Sample collected with a Kemmerer"
length(data.Export$Comments[which(data.Export$Comments=="Sample collected with a Kemmerer")]) #check to make sure proper number of comments
data.Export$Subprogram= NA #not specified
TKN.Final = data.Export
rm(data)
rm(data.Export)

################################### Organic Nitrogen as N #############################################################################################################################
data=MPCA_CHEM
head(data) #looking at data
names(data)#column names
#filter out data not interested in
data$PARAMETER=as.character(data$PARAMETER)
unique(data$PARAMETER) #look for name of variable interested in
data = data[which(data$PARAMETER =="Organic Nitrogen as N"),] #filter out all other variables
unique(data$SAMPLE_FRACTION_TYPE)
data = data[which(data$SAMPLE_FRACTION_TYPE=="Total"),] #shouldn't change anything
unique(data$SAMPLE_FRACTION_TYPE)#check to make sure only dissolved
data$RESULT[which(data$RESULT=="")]=NA #missing values indicated by blank cell, set to NA
length(data$RESULT[which(is.na(data$RESULT)==TRUE)]) #check for NA values
data = data[which(is.na(data$RESULT)==FALSE),] #remove NA values, none here
unique(data$PARAMETER)#check to make sure not other parameters mixed in
unique(data$RESULT_UNIT) #check to make sure only one unique unit
unique(data$STATISTIC_TYPE) #look at what's unique here- no STATISTIC_TYPE
unique(data$TEST_METHOD_ID) #one unique analyticall method
data = data[,c(1:2,4:6,9:10,12:15)]#filter out columns of interest
head(data)
unique(data$GTLT) 
#GTLT specifies "<"  which corresponds to CensorCode "LT"
unique(data$COMMENT) #don't export these comments, they don't relate to the sampling event
###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$LOCATION_ID
data.Export$LakeName = NA #lake name (text) not specified in the data
data.Export$SourceVariableName = "Organic Nitrogen as N"
data.Export$SourceVariableDescription = "Total organic nitrogen"
data.Export$SourceFlags = NA #set source flags, none associated with this data set
data.Export$LagosVariableID = 16
data.Export$LagosVariableName="Nitrogen, total Kjeldahl"
names(data)
data.Export$Value=as.character(data.Export$Value)
data$RESULT=as.character(data$RESULT)
data.Export$Value = data[,7] #export  obs and multiply by 1000 to go from mg/l to the preferred units of ug/
data.Export$Value=as.numeric(data.Export$Value)
data.Export$Value=(data.Export$Value)*1000
data.Export$Value=as.character(data.Export$Value)
#populate CensorCode
unique(data$GTLT) #no unique set all CensorCode to NA
length(data$GTLT[which(data$GTLT=="< ")])
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$GTLT=="< ")]= "LT"
data.Export$CensorCode[which(data$GTLT=="")]= "NC"
unique(data.Export$CensorCode)
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])
length(data.Export$CensorCode[which(data.Export$CensorCode=="NC")])
#continue populating lagos
data.Export$Date = data$SAMPLE_DATE #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype and sample position
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data$SAMPLE_UPPER_DEPTH[which(data$SAMPLE_UPPER_DEPTH=="")]=NA 
data$SAMPLE_LOWER_DEPTH[which(data$SAMPLE_LOWER_DEPTH=="")]=NA 
#check for integrated samples
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)])
#check for grab samples
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)])
# all grab samples here
#check for obs which are null for both depth observations
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==TRUE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]) #check for samples which do not have either depth field specified
#no obs null for both depth obs
#populate SampleType
data.Export$SampleType[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]= "INTEGRATED"
data.Export$SampleType[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]= "GRAB"
unique(data.Export$SampleType)
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure proper number exported
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure proper number exported
#populate SamplePosition
data.Export$SamplePosition= "SPECIFIED"
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth[which(data.Export$SampleType=="GRAB")]=data$SAMPLE_UPPER_DEPTH
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType="UNKNOWN" #not specified in data
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable to TN
#populate LabMethodName
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data$TEST_METHOD_ID=as.character(data$TEST_METHOD_ID)
unique(data$TEST_METHOD_ID)
data.Export$LabMethodName="LEG_P00605"
unique(data.Export$LabMethodName) #check to make sure correct values
data.Export$DetectionLimit= NA #NO INFO ON detection limits
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data.Export$SampleType=="GRAB")]="Sample collected with a Kemmerer"
length(data.Export$Comments[which(data.Export$Comments=="Sample collected with a Kemmerer")]) #check to make sure proper number of comments
data.Export$Subprogram= NA #not specified
TKN1.Final = data.Export
rm(data.Export)

################################### Orthophosphate as P - dissolved      #############################################################################################################################
data=MPCA_CHEM
head(data) #looking at data
names(data)#column names
#filter out data not interested in
data$PARAMETER=as.character(data$PARAMETER)
unique(data$PARAMETER) #look for name of variable interested in
data = data[which(data$PARAMETER =="Orthophosphate as P"),] #filter out all other variables
unique(data$SAMPLE_FRACTION_TYPE)
data = data[which(data$SAMPLE_FRACTION_TYPE=="Dissolved"),] # interested in drp
unique(data$SAMPLE_FRACTION_TYPE)#check to make sure only dissolved
data$RESULT[which(data$RESULT=="")]=NA #missing values indicated by blank cell, set to NA
length(data$RESULT[which(is.na(data$RESULT)==TRUE)]) #check for NA values
data = data[which(is.na(data$RESULT)==FALSE),] #remove NA values, 13 here
unique(data$PARAMETER)#check to make sure not other parameters mixed in
unique(data$RESULT_UNIT) #check to make sure only one unique unit
unique(data$STATISTIC_TYPE) #look at what's unique here, nothing specified
unique(data$TEST_METHOD_ID) #one unique analytical method used
data = data[,c(1:2,4:6,9:10,12:13,15)]#filter out columns of interest
head(data)
unique(data$GTLT) # "<" only GTLT value = CensorCode "LT"
unique(data$COMMENT) #don't export these comments, they don't relate to the sampling event
###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$LOCATION_ID
data.Export$LakeName = NA #lake name (text) not specified in the data
data.Export$SourceVariableName = "Orthophosphate as P"
data.Export$SourceVariableDescription = "Dissolved Orthophosphate"
data.Export$SourceFlags = NA #set source flags, none associated with this data set
data.Export$LagosVariableID = 26
data.Export$LagosVariableName="Phosphorus, soluable reactive orthophosphate"
names(data)
data.Export$Value=as.character(data.Export$Value)
data$RESULT=as.character(data$RESULT)
data.Export$Value = data[,7] #export p obs and multiply by 1000 to go from mg/l to the preferred units of ug/
data.Export$Value=as.numeric(data.Export$Value)
data.Export$Value=(data.Export$Value)*1000
data.Export$Value=as.character(data.Export$Value)
#populate CensorCode
unique(data$GTLT)
length(data$GTLT[which(data$GTLT=="< ")])
data.Export$CensorCode=as.character(data.Export$CensorCode)
#184 observations are "<"= "LT"
data.Export$CensorCode[which(data$GTLT=="< " )]= "LT"
data.Export$CensorCode[which(data$GTLT=="")]="NC"
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")]) #check to make sure proper number exported
length(data.Export$CensorCode[which(data.Export$CensorCode=="NC")])
length(data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]) #check to make sure prope NA assigned
#continue populating lagos
data.Export$Date = data$SAMPLE_DATE #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype and sample position
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data$SAMPLE_UPPER_DEPTH[which(data$SAMPLE_UPPER_DEPTH=="")]=NA 
data$SAMPLE_LOWER_DEPTH[which(data$SAMPLE_LOWER_DEPTH=="")]=NA 
#check for integrated samples
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)])
#check for grab samples
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)])
# 319 integrated, 1496 grab
#check for obs which are null for both depth observations
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==TRUE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]) #check for samples which do not have either depth field specified
#no obs null for both depth obs
#populate SampleType
data.Export$SampleType[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]= "INTEGRATED"
data.Export$SampleType[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]= "GRAB"
unique(data.Export$SampleType)
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure proper number exported
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure proper number exported
#populate SamplePosition
data.Export$SamplePosition = "SPECIFIED"
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]=data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]
data.Export$SampleDepth[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]=data$SAMPLE_LOWER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType="UNKNOWN" #not specified in data
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable to chla
#populate LabMethodName
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data$TEST_METHOD_ID=as.character(data$TEST_METHOD_ID)
unique(data$TEST_METHOD_ID)
data.Export$LabMethodName="LEG_P00671"
unique(data.Export$LabMethodName) #check to make sure correct values
data.Export$DetectionLimit= NA #no info on detection limit
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data.Export$SampleType=="GRAB")]="Sample collected with a Kemmerer"
length(data.Export$Comments[which(data.Export$Comments=="Sample collected with a Kemmerer")]) #check to make sure proper number of comments
data.Export$Subprogram= NA #not specified
DRP.Final = data.Export
rm(data)
rm(data.Export)

################################### Orthophosphate as P - total      #############################################################################################################################
data=MPCA_CHEM
head(data) #looking at data
names(data)#column names
#filter out data not interested in
data$PARAMETER=as.character(data$PARAMETER)
unique(data$PARAMETER) #look for name of variable interested in
data = data[which(data$PARAMETER =="Orthophosphate as P"),] #filter out all other variables
unique(data$SAMPLE_FRACTION_TYPE)
data = data[which(data$SAMPLE_FRACTION_TYPE=="Total"),] # interested in trp
unique(data$SAMPLE_FRACTION_TYPE)#check to make sure only total
data$RESULT[which(data$RESULT=="")]=NA #missing values indicated by blank cell, set to NA
length(data$RESULT[which(is.na(data$RESULT)==TRUE)]) #check for NA values
data = data[which(is.na(data$RESULT)==FALSE),] #remove NA values, 9 here
unique(data$PARAMETER)#check to make sure not other parameters mixed in
unique(data$RESULT_UNIT) #check to make sure only one unique unit
unique(data$STATISTIC_TYPE) #look at what's unique here
#unique STATISTIC_TYPE is "Minimum" which corresponds to a CensorCode of "GT" since a minimum value was reported (see metadata)
unique(data$TEST_METHOD_ID) #one unique analytical method used
data = data[,c(1:2,4:6,9:10,12:15)]#filter out columns of interest
head(data)
unique(data$GTLT) # "<" and ">" unique GTLT values = CensorCode "LT" and "GT" respectively
unique(data$COMMENT) #don't export these comments, they don't relate to the sampling event
###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$LOCATION_ID
data.Export$LakeName = NA #lake name (text) not specified in the data
data.Export$SourceVariableName = "Orthophosphate as P"
data.Export$SourceVariableDescription = "Total orthophosphate"
data.Export$SourceFlags = NA #set source flags, none associated with this data set
data.Export$LagosVariableID = 26
data.Export$LagosVariableName="Phosphorus, soluable reactive orthophosphate"
names(data)
data.Export$Value=as.character(data.Export$Value)
data$RESULT=as.character(data$RESULT)
data.Export$Value = data[,7] #export  obs and multiply by 1000 to go from mg/l to the preferred units of ug/
data.Export$Value=as.numeric(data.Export$Value)
data.Export$Value=(data.Export$Value)*1000
data.Export$Value=as.character(data.Export$Value)
#populate CensorCode
unique(data$GTLT) 
unique(data$STATISTIC_TYPE)
length(data$GTLT[which(data$GTLT=="< ")]) #next three lines checking the number of each qualifier that will become a CensorCode
length(data$GTLT[which(data$GTLT=="> ")])
length(data$STATISTIC_TYPE[which(data$STATISTIC_TYPE=="Minimum")])
# 847 "<", 2 ">", and 2 "Minimum"
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$GTLT=="< " )]= "LT"
data.Export$CensorCode[which(data$GTLT=="> " )]= "GT"
data.Export$CensorCode[which(data$STATISTIC_TYPE=="Minimum" )]= "GT"
data.Export$CensorCode[which(data$GTLT=="")]="NC"
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")]) #check to make sure proper number exported
length(data.Export$CensorCode[which(data.Export$CensorCode=="GT")])
length(data.Export$CensorCode[which(data.Export$CensorCode=="NC")])
length(data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]) #check to make sure prope NA assigned
#continue populating lagos
data.Export$Date = data$SAMPLE_DATE #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype and sample position
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data$SAMPLE_UPPER_DEPTH[which(data$SAMPLE_UPPER_DEPTH=="")]=NA 
data$SAMPLE_LOWER_DEPTH[which(data$SAMPLE_LOWER_DEPTH=="")]=NA 
#check for integrated samples
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)])
#check for grab samples
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)])
# 61 integrated, 11877 grab
#check for obs which are null for both depth observations
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==TRUE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]) #check for samples which do not have either depth field specified
#no obs null for both depth obs
#populate SampleType
data.Export$SampleType[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]= "INTEGRATED"
data.Export$SampleType[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]= "GRAB"
unique(data.Export$SampleType)
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure proper number exported
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure proper number exported
#populate SamplePosition
data.Export$SamplePosition = "SPECIFIED"
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]=data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]
data.Export$SampleDepth[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]=data$SAMPLE_LOWER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])
unique(data.Export$SampleDepth)

#continue populating other lagos fields
data.Export$BasinType="UNKNOWN" #not specified in data
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable to chla
#populate LabMethodName
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data$TEST_METHOD_ID=as.character(data$TEST_METHOD_ID)
unique(data$TEST_METHOD_ID)
data.Export$LabMethodName="LEG_P70507"
unique(data.Export$LabMethodName) #check to make sure correct values
data.Export$DetectionLimit= NA #no info on detection limit
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data.Export$SampleType=="GRAB")]="Sample collected with a Kemmerer"
length(data.Export$Comments[which(data.Export$Comments=="Sample collected with a Kemmerer")]) #check to make sure proper number of comments
data.Export$Subprogram= NA #not specified
TRP.Final = data.Export
rm(data)
rm(data.Export)

################################### Phosphorus as P- Dissolved    #############################################################################################################################
data=MPCA_CHEM
head(data) #looking at data
names(data)#column names
#filter out data not interested in
data$PARAMETER=as.character(data$PARAMETER)
unique(data$PARAMETER) #look for name of variable interested in
data = data[which(data$PARAMETER =="Phosphorus as P"),] #filter out all other variables
unique(data$SAMPLE_FRACTION_TYPE)
data = data[which(data$SAMPLE_FRACTION_TYPE=="Dissolved"),] #we are interested in the suspended and total fractions
unique(data$SAMPLE_FRACTION_TYPE)#check to make sure only total and suspended
data$RESULT[which(data$RESULT=="")]=NA #missing values indicated by blank cell, set to NA
length(data$RESULT[which(is.na(data$RESULT)==TRUE)]) #check for NA values
data = data[which(is.na(data$RESULT)==FALSE),] #remove NA values, 0 here
unique(data$PARAMETER)#check to make sure not other parameters mixed in
unique(data$RESULT_UNIT) #check to make sure only one unique unit
unique(data$STATISTIC_TYPE) #look at what's unique here, no STATISTIC_TYPE specified here
unique(data$TEST_METHOD_ID) #one unique analtyical method
data = data[,c(1:2,4:6,9:10,12:15)]#filter out columns of interest
head(data)
unique(data$GTLT) # "<" only unique GTLT which corresponds to CensorCode "LT"
unique(data$COMMENT) #don't export these comments, they don't relate to the sampling event
###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$LOCATION_ID
data.Export$LakeName = NA #lake name (text) not specified in the data
data.Export$SourceVariableName = "Phosphorus as P"
data.Export$SourceVariableDescription = "Total dissolved phosphorus"
data.Export$SourceFlags = NA #set source flags, none associated with this data set
data.Export$LagosVariableID = 28
data.Export$LagosVariableName="Phosphorus, total dissolved"
names(data)
data.Export$Value=as.character(data.Export$Value)
data$RESULT=as.character(data$RESULT)
data.Export$Value = data[,7] #export obs and multiply by 1000 to go from mg/l to the preferred units of ug/
data.Export$Value=as.numeric(data.Export$Value)
data.Export$Value=(data.Export$Value)*1000
data.Export$Value=as.character(data.Export$Value)
#populate CensorCode
unique(data$GTLT) 
unique(data$STATISTIC_TYPE)
length(data$GTLT[which(data$GTLT=="< ")]) #checking the # of "<"
# 64 "<"
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$GTLT=="< " )]= "LT"
data.Export$CensorCode[which(data$GTLT=="")]="NC"
length(data.Export$CensorCode[which(data.Export$CensorCode=="NC")])
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure proper number exported
length(data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]) #check to make sure prope NA assigned

#continue populating lagos
data.Export$Date = data$SAMPLE_DATE #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype and sample position
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data$SAMPLE_UPPER_DEPTH[which(data$SAMPLE_UPPER_DEPTH=="")]=NA 
data$SAMPLE_LOWER_DEPTH[which(data$SAMPLE_LOWER_DEPTH=="")]=NA 
#check for integrated samples
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)])
#check for grab samples
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)])
# 961 obs. are grab samples and 7 integrated
#check for obs which are null for both depth observations
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==TRUE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]) #check for samples which do not have either depth field specified
#no obs null for both depth obs
#populate SampleType
data.Export$SampleType[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]= "INTEGRATED"
data.Export$SampleType[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]= "GRAB"
unique(data.Export$SampleType)
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure proper number exported
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure proper number exported
#populate SamplePosition
data.Export$SamplePosition = "SPECIFIED"
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]=data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]
data.Export$SampleDepth[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]=data$SAMPLE_LOWER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])
unique(data.Export$SampleDepth)

#continue populating other lagos fields
data.Export$BasinType="UNKNOWN" #not specified in data
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable to tdp
#populate LabMethodName
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data$TEST_METHOD_ID=as.character(data$TEST_METHOD_ID)
unique(data$TEST_METHOD_ID) #only one unique analytical method
data.Export$LabMethodName[which(data$TEST_METHOD_ID=="LEG_P00666")]="LEG_P00666"
length(data$TEST_METHOD_ID[which(is.na(data$TEST_METHOD_ID)==FALSE)]) #just making sure there are no null values for analytical method
unique(data.Export$LabMethodName) #check to make sure correct values
#populate DetectionLimit
data.Export$DetectionLimit = NA #multiple detection limits attached to "LEG_P00666" cannot attach a specific dl to a specific obs.
#export NA for DetectionLimit (for now)
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data.Export$SampleType=="GRAB")]="Sample collected with a Kemmerer"
length(data.Export$Comments[which(data.Export$Comments=="Sample collected with a Kemmerer")]) #check to make sure proper number of comments
data.Export$Subprogram= NA #not specified
TDP.Final = data.Export
rm(data.Export)

################################### Phosphorus as P- Total   #############################################################################################################################
data=MPCA_CHEM
head(data) #looking at data
names(data)#column names
#filter out data not interested in
data$PARAMETER=as.character(data$PARAMETER)
unique(data$PARAMETER) #look for name of variable interested in
data = data[which(data$PARAMETER =="Phosphorus as P"),] #filter out all other variables
unique(data$SAMPLE_FRACTION_TYPE)
data = data[which(data$SAMPLE_FRACTION_TYPE!="Dissolved"),] #we are interested in the dissolved fraction
unique(data$SAMPLE_FRACTION_TYPE)#check to make sure only total and suspended
data$RESULT[which(data$RESULT=="")]=NA #missing values indicated by blank cell, set to NA
length(data$RESULT[which(is.na(data$RESULT)==TRUE)]) #check for NA values
data = data[which(is.na(data$RESULT)==FALSE),] #remove NA values, 28 values NA
unique(data$PARAMETER)#check to make sure not other parameters mixed in
unique(data$RESULT_UNIT) #check to make sure only one unique unit
unique(data$STATISTIC_TYPE) #look at what's unique here, unique statistic_type is "Minimum" which corresponds to a CensorCode of "GT"
unique(data$TEST_METHOD_ID) #for unique analytical methods
data = data[,c(1:2,4:6,9:10,12:15)]#filter out columns of interest
head(data)
unique(data$GTLT) # "<" and ">" which correspond to "LT" and "GT" Censorcodes, respectively
unique(data$COMMENT) #don't export these comments, they don't relate to the sampling event
###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$LOCATION_ID
data.Export$LakeName = NA #lake name (text) not specified in the data
data.Export$SourceVariableName = "Phosphorus as P"
data.Export$SourceVariableDescription = "Total phosphorus"
data.Export$SourceFlags = NA #set source flags, none associated with this data set
data.Export$LagosVariableID = 27
data.Export$LagosVariableName="Phosphorus, total"
names(data)
data.Export$Value=as.character(data.Export$Value)
data$RESULT=as.character(data$RESULT)
data.Export$Value = data[,7] #export obs and multiply by 1000 to go from mg/l to the preferred units of ug/
data.Export$Value=as.numeric(data.Export$Value)
data.Export$Value=(data.Export$Value)*1000
data.Export$Value=as.character(data.Export$Value)
#populate CensorCode
unique(data$GTLT) 
unique(data$STATISTIC_TYPE)
length(data$GTLT[which(data$GTLT=="< ")]) #checking the # of each CensorCode, based on data
length(data$GTLT[which(data$GTLT=="> ")])
length(data$STATISTIC_TYPE[which(data$STATISTIC_TYPE=="Minimum")])
# 469 "<", 2 ">", and 2 "Minimum
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$GTLT=="< " )]= "LT"
data.Export$CensorCode[which(data$GTLT=="> " )]= "GT"
data.Export$CensorCode[which(data$STATISTIC_TYPE=="Minimum" )]= "GT"
data.Export$CensorCode[which(data$GTLT=="")]="NC"
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")]) #check to make sure proper number exported
length(data.Export$CensorCode[which(data.Export$CensorCode=="NC")])
length(data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]) #check to make sure prope NA assigned
length(data.Export$CensorCode[which(data.Export$CensorCode=="GT")]) 

#continue populating lagos
data.Export$Date = data$SAMPLE_DATE #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype and sample position
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data$SAMPLE_UPPER_DEPTH[which(data$SAMPLE_UPPER_DEPTH=="")]=NA 
data$SAMPLE_LOWER_DEPTH[which(data$SAMPLE_LOWER_DEPTH=="")]=NA 
#check for integrated samples
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)])
#check for grab samples
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)])
# 3368 are integrated, and 24334 are grab samples
#check for obs which are null for both depth observations
length(data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==TRUE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]) #check for samples which do not have either depth field specified
#no obs null for both depth obs
#populate SampleType
data.Export$SampleType[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]= "INTEGRATED"
data.Export$SampleType[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]= "GRAB"
unique(data.Export$SampleType)
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure proper number exported
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure proper number exported
#populate SamplePosition
data.Export$SamplePosition = "SPECIFIED"
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]=data$SAMPLE_UPPER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==TRUE)]
data.Export$SampleDepth[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]=data$SAMPLE_LOWER_DEPTH[which(is.na(data$SAMPLE_UPPER_DEPTH)==FALSE & is.na(data$SAMPLE_LOWER_DEPTH)==FALSE)]
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])
unique(data.Export$SampleDepth)


#continue populating other lagos fields
data.Export$BasinType="UNKNOWN" #not specified in data
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable to tp
#populate LabMethodName
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data$TEST_METHOD_ID=as.character(data$TEST_METHOD_ID)
unique(data$TEST_METHOD_ID) #only one unique analytical method
data.Export$LabMethodName[which(data$TEST_METHOD_ID=="LEG_P00665")]="LEG_P00665"
data.Export$LabMethodName[which(data$TEST_METHOD_ID=="4500-P-E")]="4500-P-E"
data.Export$LabMethodName[which(data$TEST_METHOD_ID=="LEG_P00667")]="LEG_P00667"
data.Export$LabMethodName[which(data$TEST_METHOD_ID=="LEG_UNKNOWN")]="UNKNOWN"
length(data$TEST_METHOD_ID[which(is.na(data$TEST_METHOD_ID)==FALSE)]) #just making sure there are no null values for analytical method
unique(data.Export$LabMethodName) #check to make sure correct values
#populate DetectionLimit
data.Export$DetectionLimit[which(data$TEST_METHOD_ID=="LEG_UNKNOWN")] = 10 #multiply .01 *1000 to get into ug/l
data.Export$DetectionLimit[which(data.Export$DetectionLimit=="")]= NA 
#multiple detection limits attached to "LEG_P00665" AND "4500-P-E" cannot attach a specific dl to a specific obs.
#no info on dl for "LEG_P00667".  For unknown method dl is .01mg/l
length(data$TEST_METHOD_ID[which(data$TEST_METHOD_ID=="LEG_UNKNOWN")])#next to lines, test to make sure proper number of dl's exported
length(data.Export$DetectionLimit[which(data.Export$DetectionLimit==10)])
length(data.Export$DetectionLimit[which(is.na(data.Export$DetectionLimit)==TRUE)])
27670+32
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data.Export$SampleType=="GRAB")]="Sample collected with a Kemmerer"
length(data.Export$Comments[which(data.Export$Comments=="Sample collected with a Kemmerer")]) #check to make sure proper number of comments
data.Export$Subprogram= NA #not specified
TP.Final = data.Export
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MN data/MPCA_chemistry/DataImport_MPCA_chemistry/DataImport_MN_MPCA_chemistry.RData")
rm(data)
rm(data.Export)

################################### Depth, Secchi disk depth  #############################################################################################################################
data=MPCA_CHEM
head(data) #looking at data
names(data)#column names
#filter out data not interested in
data$PARAMETER=as.character(data$PARAMETER)
unique(data$PARAMETER) #look for name of variable interested in
data = data[which(data$PARAMETER =="Depth, Secchi disk depth"),] #filter out all other variables
data$RESULT[which(data$RESULT=="")]=NA #missing values indicated by blank cell, set to NA
length(data$RESULT[which(is.na(data$RESULT)==TRUE)]) #check for NA values
data = data[which(is.na(data$RESULT)==FALSE),] #remove NA values, none here
unique(data$PARAMETER)#check to make sure not other parameters mixed in
unique(data$RESULT_UNIT) #check to make sure only one unique unit
unique(data$STATISTIC_TYPE) #look at what's unique here
#the only unique data$STATISTIC_TYPE is "Minimum" which corresponds to a CensorCode of "GT" since a minimum observation was reported
#unique STATISTIC_TYPE is "Minimum" which corresponds to a CensorCode of "GT" since a minimum value was reported (see metadata)
unique(data$TEST_METHOD_ID) #analytical method not relevant to secchi, measured in field
data = data[,c(1:2,4:6,9:10,12:15)]#filter out columns of interest
head(data)
unique(data$GTLT) #  ">" unique GTLT value = Censor Code of "GT" 
###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$LOCATION_ID
data.Export$LakeName = NA #lake name (text) not specified in the data
data.Export$SourceVariableName = "Depth, Secchi disk depth"
data.Export$SourceVariableDescription = "Secchi disk depth"
data.Export$SourceFlags = NA #set source flags, none associated with this data set
data.Export$LagosVariableID = 30
data.Export$LagosVariableName="Secchi"
data.Export$Value = data[,7] #export secchi obs's already in meters, the preferred units
#populate CensorCode
unique(data$GTLT) 
unique(data$STATISTIC_TYPE)
length(data$GTLT[which(data$GTLT=="> ")]) #checking to see # that are "GT"
length(data$STATISTIC_TYPE[which(data$STATISTIC_TYPE=="Minimum")])
# 147 are "GT" or "> " 
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$GTLT=="> " )]= "GT"
data.Export$CensorCode[which(data$STATISTIC_TYPE=="Minimum" )]= "GT"
data.Export$CensorCode[which(data$GTLT=="")]="NC"
length(data.Export$CensorCode[which(data.Export$CensorCode=="GT")]) #check to makie sure proper number exported
length(data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]) #check to make sure prope NA assigned
length(data.Export$CensorCode[which(data.Export$CensorCode=="NC")])
15014+164 #check to make sure all observations have a CensorCode (even if NA)
#continue populating lagos
data.Export$Date = data$SAMPLE_DATE #date already in correct format
data.Export$Units="m"
#prepare to populate sampletype and sample position
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data$SAMPLE_UPPER_DEPTH[which(data$SAMPLE_UPPER_DEPTH=="")]=NA 
data$SAMPLE_LOWER_DEPTH[which(data$SAMPLE_LOWER_DEPTH=="")]=NA 

#populate SampleType
data.Export$SampleType= "INTEGRATED" #SECCHI DISK OBS. ARE INTEGRATED
#populate SamplePosition
data.Export$SamplePosition = "SPECIFIED"
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth= NA #not applicable to seechi obs
#continue populating other lagos fields
data.Export$BasinType="UNKNOWN" #not specified in data
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = "SECCHI_VIEW_UNKNOWN"
#populate LabMethodName
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data$TEST_METHOD_ID=as.character(data$TEST_METHOD_ID)
unique(data$TEST_METHOD_ID)
data.Export$LabMethodName=NA #observations made in field
unique(data.Export$LabMethodName) #check to make sure correct values
data.Export$DetectionLimit= NA #no info on detection limit
data.Export$Comments= NA #no comments
data.Export$Subprogram= NA #not specified
Secchi.Final = data.Export
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MN data/MPCA_chemistry/DataImport_MPCA_chemistry/DataImport_MN_MPCA_chemistry.RData")
rm(data)
rm(data.Export)

###################################### final export ########################################################################################
Final.Export = rbind(ACOLOR.Final,CHLA.Final,DKN.Final,DNO3.Final,DOC.Final,DRP.Final, INORGN.Final, NO2.Final,Secchi.Final,TCOLOR.Final,TDP.Final,TKN.Final,TKN1.Final,TN.Final,TNO3.Final,TOC.Final,TP.Final,TRP.Final,DNH4.Final,TNH4.Final)
######################################################################################
##Duplicates check #an observation is defined as duplicate if it is NOT unique for programid, lagoslakeid, date, sampledepth, sampleposition, lagosvariableid, datavalue
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
814+141679#adds up to total
##write table
Final.Export1=data1
typeof(Final.Export1$Value)
unique(Final.Export1$Value)
Final.Export1$Value=as.character(Final.Export1$Value)
Final.Export1$Value=as.numeric(Final.Export1$Value)
length(Final.Export1$Value[which(Final.Export1$Value<0)])
nosamplepos=Final.Export1[which(is.na(Final.Export1$SampleDepth)==TRUE & Final.Export1$SamplePosition=="UNKNOWN"),]
write.table(Final.Export1,file="DataImport_MN_MPCA_chemistry.csv",row.names=FALSE,sep=",")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MN data/MPCA_chemistry/DataImport_MPCA_chemistry/DataIport_MN_MPCA_chemistry.RData")