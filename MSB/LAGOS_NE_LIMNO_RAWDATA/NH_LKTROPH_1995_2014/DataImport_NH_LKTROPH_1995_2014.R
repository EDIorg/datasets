#processing of NH VLAP/Trophic survey data from 1995-present.
setwd("C:/Users/Sam/Dropbox/CSI-LIMNO_DATA/DATA-lake/NH data/NHDES_1995toPresent")
save.image("C:/Users/Sam/Dropbox/CSI-LIMNO_DATA/DATA-lake/NH data/NHDES_1995toPresent/DataImport_NHDES_1995toPresent/DataImport_NHDES_1995toPresent.RData")


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

lagosNames <-colnames(LAGOS_Template)

#read in data

Lakedata <- read.csv("C:/Users/Sam/Dropbox/CSI-LIMNO_DATA/DATA-lake/NH data/NHDES_1995toPresent/NH_Lake_Data.csv", stringsAsFactors=FALSE)

#see 'DataImport_notes.R' at Dropbox/CSI-LIMNO_DATA/DATA-lake/NH data/NHDES_1995toPresent for information
#about the final data file (the one used for import) called 'NH_Lake_Data.csv'

Vars <- unique(Lakedata$PARAMETER)

Vars[c(2,4,8)] ## note that THESE PARAMETERS WERE EXCLUDED FROM THIS ANALYSIS BECAUSE THEY ARE ALL NON DETECTS


###########################################################################################################################################################################################
###################################  Carbon, total organic #############################################################################################################################
data <- Lakedata
colnames(data)

#filter so only TOC remains
unique(data$PARAMETER)
data <- data[which(data$PARAMETER=="CARBON, ORGANIC"),]

# filter so only samps of "TOTAL" remain
unique(data$FRACTION_TYPE)
data <- data[which(data$FRACTION_TYPE=="TOTAL"),]

#check data status
unique(data$DATA_STATUS) #all final = good

#check depth,position, and lake name
length(data$DEPTH[which(is.na(data$DEPTH)==TRUE)]) #no NA for depth = good
length(data$DEPTH_ZONE[which(is.na(data$DEPTH_ZONE)==TRUE)]) #13 NA = OK because we have depth
length(data$WATERBODY_NAME[which(is.na(data$WATERBODY_NAME)==TRUE)]) #NO NA for lake name


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID <- data$WATERBODY_ID
data.Export$LakeName <- data$WATERBODY_NAME
data.Export$SourceVariableName <- "CARBON, ORGANIC"
data.Export$SourceVariableDescription <- "Total organic carbon"
#populate SourceFlags
unique(data$LAB_QUALIFIER)
data.Export$SourceFlags <- NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID <- 7
data.Export$LagosVariableName <- "Carbon, total organic"
data.Export$Value=as.numeric(data$RESULTS)
unique(data.Export$Value)

#no censored obs. set as NC
data.Export$CensorCode <- "NC" #none censored
unique(data.Export$CensorCode)
length(data.Export$CensorCode[which(data.Export$CensorCode=="NC")])#check to make sure correct number

#continue exporting other info
data.Export$Date <- as.Date(data$START_DATE, format='%m/%d/%y')  #convert date to correct format and populate
data.Export$Units <- "mg/L"

#populate sampelposition
unique(data$DEPTH_ZONE)
data.Export$SamplePosition <- data$DEPTH_ZONE
data.Export$SamplePosition[which(data.Export$SamplePosition=="EPILIMNION")] <- "EPI"
data.Export$SamplePosition[which(is.na(data.Export$SamplePosition)==TRUE)] <- "UNKNOWN"
unique(data.Export$SamplePosition)

# populate sampletype
data$SAMPLE_COLLECTION_METHOD
data.Export$SampleType <- "GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all integrated

#assign sampledepth 
data.Export$SampleDepth <- data$DEPTH
unique(data.Export$SampleDepth)
unique(data$DEPTH_UNITS) #check depth units--all meters= good
unique(data$DEPTH_MEAS_FROM)

#check to make sure it is not an integrated sample
data$UPPER_DEPTH
data$LOWER_DEPTH

#continue populating other lagos fields
data.Export$BasinType <- "UNKNOWN"
unique(data.Export$BasinType)

#continue with other fields
data.Export$MethodInfo <- NA 

data.Export$LabMethodName <- "EPA_415.3" #per emi's metadata

data.Export$LabMethodInfo <- NA
unique(data.Export$LabMethodInfo)#look at unique values exported

data.Export$DetectionLimit <- 0.50 #per meta

data$LKTROPH[which(is.na(data$LKTROPH)==TRUE)] <- "VLAP"
data.Export$Subprogram <- data$LKTROPH
unique(data.Export$Subprogram)

data.Export$Comments <- "Sample Collected with Kemmerer"

toc.Final <- data.Export
rm(data)
rm(data.Export)


###########################################################################################################################################################################################
###################################  NITROGEN, KJELDAHL #############################################################################################################################
colnames(data)
data <-Lakedata

#filter so only var of interest remains
unique(data$PARAMETER)
data <- data[which(data$PARAMETER=="NITROGEN, KJELDAHL"),]

# filter so only samps of "TOTAL" remain
unique(data$FRACTION_TYPE)
data <- data[which(data$FRACTION_TYPE=="TOTAL"),]

#check data status
unique(data$DATA_STATUS) #all final = good

#discard observations that are ND and Not Run
data <- data[which(data$RESULTS != "ND"),]
data <- data[which(data$RESULTS != "NOT RUN"),]

#check depth,position, and lake name
length(data$DEPTH[which(is.na(data$DEPTH)==TRUE)]) #no NA for depth = good
length(data$DEPTH_ZONE[which(is.na(data$DEPTH_ZONE)==TRUE)]) #13 NA = OK because we have depth
length(data$WATERBODY_NAME[which(is.na(data$WATERBODY_NAME)==TRUE)]) #NO NA for lake name

length(data$DEPTH[which(is.na(data$DEPTH) & is.na(data$DEPTH_ZONE))==TRUE]) 

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID <- data$WATERBODY_ID
data.Export$LakeName <- data$WATERBODY_NAME
data.Export$SourceVariableName <- "NITROGEN, KJELDAHL"
data.Export$SourceVariableDescription <- "Total Kjeldahl Nitrogen"

#populate SourceFlags
unique(data$LAB_QUALIFIER)
data.Export$SourceFlags <- NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID <- 15
data.Export$LagosVariableName <- "Nitrogen, total Kjeldahl"

#no censored obs. set as NC
data.Export$Value <- data$RESULTS
data.Export$CensorCode <- as.character(data.Export$CensorCode)
data.Export$CensorCode[grep("<",data.Export$Value)] <- "LT" 
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)] <- "NC"
unique(data.Export$CensorCode)

data.Export$Value <- gsub("<","",data.Export$Value) #remove the < from values
data.Export$Value <- as.numeric(data.Export$Value)
data.Export$Value <- data.Export$Value * 1000 #convert to ug/l

#continue exporting other info
data.Export$Date <- as.Date(data$START_DATE, format='%m/%d/%y')  #convert date to correct format and populate
data.Export$Units <- "ug/L"

#populate sampelposition
unique(data$DEPTH_ZONE)
data.Export$SamplePosition <- data$DEPTH_ZONE
data.Export$SamplePosition[which(data.Export$SamplePosition=="EPILIMNION")] <- "EPI"
data.Export$SamplePosition[which(data.Export$SamplePosition=="UPPER")] <- "EPI"
data.Export$SamplePosition[which(data.Export$SamplePosition=="LOWER")] <- "HYPO"
data.Export$SamplePosition[which(data.Export$SamplePosition=="METALIMNION")] <- "META"
data.Export$SamplePosition[which(data.Export$SamplePosition=="HYPOLIMNION")] <- "HYPO"
data.Export$SamplePosition[which(data.Export$SamplePosition=="COMPOSITE")] <- "SPECIFIED"
data.Export$SamplePosition[which(is.na(data.Export$SamplePosition)==TRUE)] <- "UNKNOWN"
unique(data.Export$SamplePosition)

# populate sampletype
data.Export$SampleType <- as.character(data.Export$SampleType)
data.Export$SampleType[which(data$DEPTH_ZONE=="COMPOSITE")] <- "INTEGRATED" 
data.Export$SampleType[which(is.na(data.Export$SampleType)==TRUE)] <- "GRAB"
unique(data.Export$SampleType)

#assign sampledepth 
data.Export$SampleDepth <- data$DEPTH
unique(data.Export$SampleDepth)
unique(data$DEPTH_UNITS) #check depth units--all meters= good
unique(data$DEPTH_MEAS_FROM)

#check integrated sample depths if provided
unique(data$UPPER_DEPTH)
unique(data$LOWER_DEPTH)

#continue populating other lagos fields
data.Export$BasinType <- "UNKNOWN"
unique(data.Export$BasinType)

#continue with other fields
data.Export$MethodInfo <- NA 

unique(data$ANALYTICAL_METHOD)
data.Export$LabMethodName <- as.character(data.Export$LabMethodName)
data.Export$LabMethodName[which(data$ANALYTICAL_METHOD=="10-107-06-2-E")] <- "LACHAT_10.107.06.2.E" #per emi's metadata
data.Export$LabMethodName[which(data$ANALYTICAL_METHOD=="351.2")] <- "EPA_351.2"
unique(data.Export$LabMethodName)

data.Export$LabMethodInfo <- NA
unique(data.Export$LabMethodInfo)#look at unique values exported

data.Export$DetectionLimit <- as.character(data.Export$DetectionLimit)
data.Export$DetectionLimit[which(data$ANALYTICAL_METHOD=="10-107-06-2-E")] <- "0.25" #per meta
data.Export$DetectionLimit[which(data$ANALYTICAL_METHOD=="351.2")] <- "0.25-0.30"

data$LKTROPH[which(is.na(data$LKTROPH)==TRUE)] <- "VLAP"
data.Export$Subprogram <- data$LKTROPH
unique(data.Export$Subprogram)

data.Export$Comments <- NA

tkn.Final <- data.Export
rm(data)
rm(data.Export)

###########################################################################################################################################################################################
###################################  NITROGEN, NITRITE (NO2) + NITRATE (NO3) AS N #############################################################################################################################
data <-Lakedata

#filter so only var of interest remains
unique(data$PARAMETER)
data <- data[which(data$PARAMETER=="NITROGEN, NITRITE (NO2) + NITRATE (NO3) AS N"),]

# filter so only samps of "TOTAL" remain
unique(data$FRACTION_TYPE)
data <- data[which(data$FRACTION_TYPE=="TOTAL"),]

#check data status
unique(data$DATA_STATUS) #all final = good

#remove those that are preliminary
data <- data[which(data$DATA_STATUS != "PRELIMINARY"),]

#discard observations that are ND and Not Run
data <- data[which(data$RESULTS != "ND"),]
data <- data[which(data$RESULTS != "NOT RUN"),]

#check depth,position, and lake name
length(data$DEPTH[which(is.na(data$DEPTH)==TRUE)]) #no NA for depth = good
length(data$DEPTH_ZONE[which(is.na(data$DEPTH_ZONE)==TRUE)]) #13 NA = OK because we have depth
length(data$WATERBODY_NAME[which(is.na(data$WATERBODY_NAME)==TRUE)]) #NO NA for lake name

length(data$DEPTH[which(is.na(data$DEPTH) & is.na(data$DEPTH_ZONE))==TRUE]) 

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID <- data$WATERBODY_ID
data.Export$LakeName <- data$WATERBODY_NAME
data.Export$SourceVariableName <- "NITROGEN, NITRITE (NO2) + NITRATE (NO3) AS N"
data.Export$SourceVariableDescription <- "Total Nitrite + Nitrate Nitrogen as N"

#populate SourceFlags
unique(data$LAB_QUALIFIER)
data.Export$SourceFlags <- NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID <- 18
data.Export$LagosVariableName <- "Nitrogen, nitrite (NO2) + nitrate (NO3)"
unique(data$RESULTS)

#no censored obs. set as NC
data.Export$Value <- data$RESULTS
data.Export$CensorCode <- as.character(data.Export$CensorCode)
data.Export$CensorCode[grep("<",data.Export$Value)] <- "LT" 
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)] <- "NC"
unique(data.Export$CensorCode)

data.Export$Value <- gsub("<","",data.Export$Value) #remove the < from values
data.Export$Value <- as.numeric(data.Export$Value)
data.Export$Value <- data.Export$Value * 1000 #convert to ug/l

#continue exporting other info
data.Export$Date <- as.Date(data$START_DATE, format='%m/%d/%y')  #convert date to correct format and populate
data.Export$Units <- "ug/L"

#populate sampelposition
unique(data$DEPTH_ZONE)
data.Export$SamplePosition <- data$DEPTH_ZONE
data.Export$SamplePosition[which(data.Export$SamplePosition=="EPILIMNION")] <- "EPI"
data.Export$SamplePosition[which(data.Export$SamplePosition=="UPPER")] <- "EPI"
data.Export$SamplePosition[which(data.Export$SamplePosition=="LOWER")] <- "HYPO"
data.Export$SamplePosition[which(data.Export$SamplePosition=="METALIMNION")] <- "META"
data.Export$SamplePosition[which(data.Export$SamplePosition=="HYPOLIMNION")] <- "HYPO"
data.Export$SamplePosition[which(data.Export$SamplePosition=="COMPOSITE")] <- "SPECIFIED"
data.Export$SamplePosition[which(is.na(data.Export$SamplePosition)==TRUE)] <- "UNKNOWN"
unique(data.Export$SamplePosition)

# populate sampletype
data.Export$SampleType <- as.character(data.Export$SampleType)
data.Export$SampleType[which(data$DEPTH_ZONE=="COMPOSITE")] <- "INTEGRATED" 
data.Export$SampleType[which(is.na(data.Export$SampleType)==TRUE)] <- "GRAB"
unique(data.Export$SampleType)

#assign sampledepth 
data.Export$SampleDepth <- data$DEPTH
unique(data.Export$SampleDepth)
unique(data$DEPTH_UNITS) #check depth units--all meters= good
unique(data$DEPTH_MEAS_FROM)

#check integrated sample depths if provided
unique(data$UPPER_DEPTH)
unique(data$LOWER_DEPTH)

#continue populating other lagos fields
data.Export$BasinType <- "UNKNOWN"
unique(data.Export$BasinType)

#continue with other fields
data.Export$MethodInfo <- NA 

unique(data$ANALYTICAL_METHOD)
data.Export$LabMethodName <- as.character(data.Export$LabMethodName)
data.Export$LabMethodName[which(data$ANALYTICAL_METHOD=="10-107-04-1-C")] <- "LACHAT_10.107.04.1.C" #per emi's metadata
data.Export$LabMethodName[which(data$ANALYTICAL_METHOD=="353.2")] <- "EPA_353.2"
unique(data.Export$LabMethodName)

data.Export$LabMethodInfo <- NA
unique(data.Export$LabMethodInfo)#look at unique values exported

data.Export$DetectionLimit <- as.character(data.Export$DetectionLimit)
data.Export$DetectionLimit[which(data$ANALYTICAL_METHOD=="10-107-04-1-C")] <- "50" #per meta
data.Export$DetectionLimit[which(data$ANALYTICAL_METHOD=="353.2")] <- "50-100"
unique(data.Export$DetectionLimit)

data$LKTROPH[which(is.na(data$LKTROPH)==TRUE)] <- "VLAP"
data.Export$Subprogram <- data$LKTROPH
unique(data.Export$Subprogram)

data.Export$Comments <- NA

no32.Final <- data.Export
rm(data)
rm(data.Export)

###########################################################################################################################################################################################
###################################  PHOSPHORUS AS P #############################################################################################################################
data <-Lakedata

#filter so only var of interest remains
unique(data$PARAMETER)
data <- data[which(data$PARAMETER=="PHOSPHORUS AS P"),]

# filter so only samps of "TOTAL" remain
unique(data$FRACTION_TYPE)


#check data status
unique(data$DATA_STATUS) #all final = good

#remove those that are preliminary
data <- data[which(data$DATA_STATUS != "PRELIMINARY"),]

#discard observations that are ND and Not Run
data <- data[which(data$RESULTS != "ND"),]
data <- data[which(data$RESULTS != "NOT RUN"),]

#check depth,position, and lake name
length(data$DEPTH[which(is.na(data$DEPTH)==TRUE)]) #no NA for depth = good
length(data$DEPTH_ZONE[which(is.na(data$DEPTH_ZONE)==TRUE)]) #13 NA = OK because we have depth
length(data$WATERBODY_NAME[which(is.na(data$WATERBODY_NAME)==TRUE)]) #NO NA for lake name
length(data$WATERBODY_ID[which(is.na(data$WATERBODY_ID)==TRUE)])
#remove obs w/o ID
data <- data[which(is.na(data$WATERBODY_ID)==FALSE),]

length(data$DEPTH[which(is.na(data$DEPTH) & is.na(data$DEPTH_ZONE))==TRUE]) 

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID <- data$WATERBODY_ID
data.Export$LakeName <- data$WATERBODY_NAME
data.Export$SourceVariableName <- "PHOSPHORUS AS P"
data.Export$SourceVariableDescription <- "Total Phosphorus"

#populate SourceFlags
unique(data$LAB_QUALIFIER)
data.Export$SourceFlags <- NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID <- 27
data.Export$LagosVariableName <- "Phosphorus, total"
unique(data$RESULTS)

#no censored obs. set as NC
data.Export$Value <- data$RESULTS
data.Export$CensorCode <- as.character(data.Export$CensorCode)
data.Export$CensorCode[grep("<",data.Export$Value)] <- "LT" 
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)] <- "NC"
unique(data.Export$CensorCode)

data.Export$Value <- gsub("<","",data.Export$Value) #remove the < from values
data.Export$Value <- as.numeric(data.Export$Value)
data.Export$Value <- data.Export$Value * 1000 #convert to ug/l

#continue exporting other info
data.Export$Date <- as.Date(data$START_DATE, format='%m/%d/%y')  #convert date to correct format and populate
data.Export$Units <- "ug/L"

#populate sampelposition
unique(data$DEPTH_ZONE)
data.Export$SamplePosition <- data$DEPTH_ZONE
data.Export$SamplePosition[which(data.Export$SamplePosition=="EPILIMNION")] <- "EPI"
data.Export$SamplePosition[which(data.Export$SamplePosition=="UPPER")] <- "EPI"
data.Export$SamplePosition[which(data.Export$SamplePosition=="LOWER")] <- "HYPO"
data.Export$SamplePosition[which(data.Export$SamplePosition=="METALIMNION")] <- "META"
data.Export$SamplePosition[which(data.Export$SamplePosition=="HYPOLIMNION")] <- "HYPO"
data.Export$SamplePosition[which(data.Export$SamplePosition=="COMPOSITE")] <- "SPECIFIED"
data.Export$SamplePosition[which(is.na(data.Export$SamplePosition)==TRUE)] <- "UNKNOWN"
unique(data.Export$SamplePosition)

# populate sampletype
data.Export$SampleType <- as.character(data.Export$SampleType)
data.Export$SampleType[which(data$DEPTH_ZONE=="COMPOSITE")] <- "INTEGRATED" 
data.Export$SampleType[which(is.na(data.Export$SampleType)==TRUE)] <- "GRAB"
unique(data.Export$SampleType)

#assign sampledepth 
data.Export$SampleDepth <- data$DEPTH
unique(data.Export$SampleDepth)
unique(data$DEPTH_UNITS) #check depth units--all meters= good
unique(data$DEPTH_MEAS_FROM)

#check integrated sample depths if provided
unique(data$UPPER_DEPTH)
unique(data$LOWER_DEPTH)

#continue populating other lagos fields
data.Export$BasinType <- "UNKNOWN"
unique(data.Export$BasinType)

#continue with other fields
data.Export$MethodInfo <- NA 

unique(data$ANALYTICAL_METHOD)
data.Export$LabMethodName <- as.character(data.Export$LabMethodName)
data.Export$LabMethodName[which(data$ANALYTICAL_METHOD=="10-115-01-1-F")] <- "LACHAT_10.115.01.1.F" #per emi's metadata
data.Export$LabMethodName[which(data$ANALYTICAL_METHOD=="4500-P-E")] <- "LACHAT_10.115.01.1.F"
data.Export$LabMethodName[which(data$ANALYTICAL_METHOD=="365.3")] <- "EPA_365.3"
data.Export$LabMethodName[which(data$ANALYTICAL_METHOD=="365.2")] <- "EPA_365.2"
unique(data.Export$LabMethodName)

data.Export$LabMethodInfo <- NA
unique(data.Export$LabMethodInfo)#look at unique values exported

data.Export$DetectionLimit <- as.character(data.Export$DetectionLimit)
data.Export$DetectionLimit[which(data$ANALYTICAL_METHOD=="10-115-01-1-F")] <- "5" #per meta
data.Export$DetectionLimit[which(data$ANALYTICAL_METHOD=="4500-P-E")] <- "5"
data.Export$DetectionLimit[which(data$ANALYTICAL_METHOD=="365.3")] <- "5-10"
data.Export$DetectionLimit[which(data$ANALYTICAL_METHOD=="365.2")] <- NA
unique(data.Export$DetectionLimit)

data$LKTROPH[which(is.na(data$LKTROPH)==TRUE)] <- "VLAP"
data.Export$Subprogram <- data$LKTROPH
unique(data.Export$Subprogram)

data.Export$Comments <- NA

po4.Final <- data.Export
rm(data)
rm(data.Export)

###################################  CARBON, ORGANIC -dissolved #############################################################################################################################
data <-Lakedata

#filter so only var of interest remains
unique(data$PARAMETER)
data <- data[which(data$PARAMETER=="CARBON, ORGANIC"),]

# filter so only samps of "dissolved" remain
unique(data$FRACTION_TYPE)
data <- data[which(data$FRACTION_TYPE=="DISSOLVED"),]

#check data status
unique(data$DATA_STATUS) #all final = good

#remove those that are preliminary
data <- data[which(data$DATA_STATUS != "PRELIMINARY"),]

#discard observations that are ND and Not Run
data <- data[which(data$RESULTS != "ND"),]
data <- data[which(data$RESULTS != "NOT RUN"),]

#check depth,position, and lake name
length(data$DEPTH[which(is.na(data$DEPTH)==TRUE)]) #no NA for depth = good
length(data$DEPTH_ZONE[which(is.na(data$DEPTH_ZONE)==TRUE)]) #13 NA = OK because we have depth
length(data$WATERBODY_NAME[which(is.na(data$WATERBODY_NAME)==TRUE)]) #NO NA for lake name
length(data$WATERBODY_ID[which(is.na(data$WATERBODY_ID)==TRUE)])

length(data$DEPTH[which(is.na(data$DEPTH) & is.na(data$DEPTH_ZONE))==TRUE]) 

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID <- data$WATERBODY_ID
data.Export$LakeName <- data$WATERBODY_NAME
data.Export$SourceVariableName <- "CARBON, ORGANIC"
data.Export$SourceVariableDescription <- "Dissolved Organic Carbon"

#populate SourceFlags
unique(data$LAB_QUALIFIER)
data.Export$SourceFlags <- NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID <- 6
data.Export$LagosVariableName <- "Carbon, dissolved organic"
unique(data$RESULTS)

#no censored obs. set as NC
data.Export$Value <- data$RESULTS
data.Export$CensorCode <- as.character(data.Export$CensorCode)
data.Export$CensorCode[grep("<",data.Export$Value)] <- "LT" 
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)] <- "NC"
unique(data.Export$CensorCode)

data.Export$Value <- gsub("<","",data.Export$Value) #remove the < from values
data.Export$Value <- as.numeric(data.Export$Value)
unique(data.Export$Value)

#continue exporting other info
data.Export$Date <- as.Date(data$START_DATE, format='%m/%d/%y')  #convert date to correct format and populate
data.Export$Units <- "mg/L"

#populate sampelposition
unique(data$DEPTH_ZONE)
data.Export$SamplePosition <- data$DEPTH_ZONE
data.Export$SamplePosition[which(data.Export$SamplePosition=="EPILIMNION")] <- "EPI"
data.Export$SamplePosition[which(data.Export$SamplePosition=="UPPER")] <- "EPI"
data.Export$SamplePosition[which(data.Export$SamplePosition=="LOWER")] <- "HYPO"
data.Export$SamplePosition[which(data.Export$SamplePosition=="METALIMNION")] <- "META"
data.Export$SamplePosition[which(data.Export$SamplePosition=="HYPOLIMNION")] <- "HYPO"
data.Export$SamplePosition[which(data.Export$SamplePosition=="COMPOSITE")] <- "SPECIFIED"
data.Export$SamplePosition[which(is.na(data.Export$SamplePosition)==TRUE)] <- "UNKNOWN"
unique(data.Export$SamplePosition)

# populate sampletype
data.Export$SampleType <- as.character(data.Export$SampleType)
data.Export$SampleType[which(data$DEPTH_ZONE=="COMPOSITE")] <- "INTEGRATED" 
data.Export$SampleType[which(is.na(data.Export$SampleType)==TRUE)] <- "GRAB"
unique(data.Export$SampleType)

#assign sampledepth 
data.Export$SampleDepth <- data$DEPTH
unique(data.Export$SampleDepth)
unique(data$DEPTH_UNITS) #check depth units--all meters= good
unique(data$DEPTH_MEAS_FROM)

#check integrated sample depths if provided or applicable
unique(data$UPPER_DEPTH)
unique(data$LOWER_DEPTH)

#continue populating other lagos fields
data.Export$BasinType <- "UNKNOWN"
unique(data.Export$BasinType)

#continue with other fields
data.Export$MethodInfo <- NA 

unique(data$ANALYTICAL_METHOD)
data.Export$LabMethodName <- as.character(data.Export$LabMethodName)
data.Export$LabMethodName <- "APHA_5310B"
unique(data.Export$LabMethodName)

data.Export$LabMethodInfo <- NA
unique(data.Export$LabMethodInfo)#look at unique values exported

data.Export$DetectionLimit <- 0.50
unique(data.Export$DetectionLimit)

data$LKTROPH[which(is.na(data$LKTROPH)==TRUE)] <- "VLAP"
data.Export$Subprogram <- data$LKTROPH
unique(data.Export$Subprogram)

data.Export$Comments <- NA

doc.Final <- data.Export
rm(data)
rm(data.Export)

################################### NITROGEN, AMMONIA AS N  #############################################################################################################################
data <-Lakedata

#filter so only var of interest remains
unique(data$PARAMETER)
data <- data[which(data$PARAMETER=="NITROGEN, AMMONIA AS N"),]

# filter so only samps of "TOTAL" remain
unique(data$FRACTION_TYPE)


#check data status
unique(data$DATA_STATUS) #all final = good

#remove those that are preliminary
data <- data[which(data$DATA_STATUS != "PRELIMINARY"),]

#discard observations that are ND and Not Run
data <- data[which(data$RESULTS != "ND"),]
data <- data[which(data$RESULTS != "NOT RUN"),]

#check depth,position, and lake name
length(data$DEPTH[which(is.na(data$DEPTH)==TRUE)]) #no NA for depth = good
length(data$DEPTH_ZONE[which(is.na(data$DEPTH_ZONE)==TRUE)]) #13 NA = OK because we have depth
length(data$WATERBODY_NAME[which(is.na(data$WATERBODY_NAME)==TRUE)]) #NO NA for lake name
length(data$WATERBODY_ID[which(is.na(data$WATERBODY_ID)==TRUE)])
#remove obs w/o ID
data <- data[which(is.na(data$WATERBODY_ID)==FALSE),]

length(data$DEPTH[which(is.na(data$DEPTH) & is.na(data$DEPTH_ZONE))==TRUE]) 

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID <- data$WATERBODY_ID
data.Export$LakeName <- data$WATERBODY_NAME
data.Export$SourceVariableName <- "NITROGEN, AMMONIA AS N"
data.Export$SourceVariableDescription <- "Ammonia as N"

#populate SourceFlags
unique(data$LAB_QUALIFIER)
data.Export$SourceFlags <- NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID <- 19
data.Export$LagosVariableName <- "Nitrogen, NH4"
unique(data$RESULTS)

#no censored obs. set as NC
data.Export$Value <- data$RESULTS
data.Export$CensorCode <- as.character(data.Export$CensorCode)
data.Export$CensorCode[grep("<",data.Export$Value)] <- "LT" 
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)] <- "NC"
unique(data.Export$CensorCode)

data.Export$Value <- gsub("<","",data.Export$Value) #remove the < from values
data.Export$Value <- as.numeric(data.Export$Value)
data.Export$Value <- data.Export$Value * 1000 #convert to ug/l

#continue exporting other info
data.Export$Date <- as.Date(data$START_DATE, format='%m/%d/%y')  #convert date to correct format and populate
data.Export$Units <- "ug/L"

#populate sampelposition
unique(data$DEPTH_ZONE)
data.Export$SamplePosition <- data$DEPTH_ZONE
data.Export$SamplePosition[which(data.Export$SamplePosition=="EPILIMNION")] <- "EPI"
data.Export$SamplePosition[which(data.Export$SamplePosition=="UPPER")] <- "EPI"
data.Export$SamplePosition[which(data.Export$SamplePosition=="LOWER")] <- "HYPO"
data.Export$SamplePosition[which(data.Export$SamplePosition=="METALIMNION")] <- "META"
data.Export$SamplePosition[which(data.Export$SamplePosition=="HYPOLIMNION")] <- "HYPO"
data.Export$SamplePosition[which(data.Export$SamplePosition=="COMPOSITE")] <- "SPECIFIED"
data.Export$SamplePosition[which(is.na(data.Export$SamplePosition)==TRUE)] <- "UNKNOWN"
unique(data.Export$SamplePosition)

# populate sampletype
data.Export$SampleType <- as.character(data.Export$SampleType)
data.Export$SampleType[which(data$DEPTH_ZONE=="COMPOSITE")] <- "INTEGRATED" 
data.Export$SampleType[which(is.na(data.Export$SampleType)==TRUE)] <- "GRAB"
unique(data.Export$SampleType)

#assign sampledepth 
data.Export$SampleDepth <- data$DEPTH
unique(data.Export$SampleDepth)
unique(data$DEPTH_UNITS) #check depth units--all meters= good
unique(data$DEPTH_MEAS_FROM)

#check integrated sample depths if provided
unique(data$UPPER_DEPTH)
unique(data$LOWER_DEPTH)

#continue populating other lagos fields
data.Export$BasinType <- "UNKNOWN"
unique(data.Export$BasinType)

#continue with other fields
data.Export$MethodInfo <- NA 

unique(data$ANALYTICAL_METHOD)
data.Export$LabMethodName <- as.character(data.Export$LabMethodName)
data.Export$LabMethodName <- "EPA_350.1"
unique(data.Export$LabMethodName)

data.Export$LabMethodInfo <- NA
unique(data.Export$LabMethodInfo)#look at unique values exported

data.Export$DetectionLimit <- 50
unique(data.Export$DetectionLimit)

data$LKTROPH[which(is.na(data$LKTROPH)==TRUE)] <- "VLAP"
data.Export$Subprogram <- data$LKTROPH
unique(data.Export$Subprogram)

data.Export$Comments <- NA

nh4.Final <- data.Export
rm(data)
rm(data.Export)

################################### CHLOROPHYLL A, UNCORRECTED FOR PHEOPHYTIN && CHLOROPHYLL A (PROBE)   #############################################################################################################################
data <-Lakedata

#filter so only var of interest remains
unique(data$PARAMETER)
tempDf <- data[which(data$PARAMETER=="CHLOROPHYLL A (PROBE)"),]
tempDf1 <- data[which(data$PARAMETER=="CHLOROPHYLL A, UNCORRECTED FOR PHEOPHYTIN"),]

data <- rbind(tempDf,tempDf1)

unique(data$FRACTION_TYPE)


#check data status
unique(data$DATA_STATUS) #all final = good

#remove those that are preliminary
sum(data$DATA_STATUS=='PRELIMINARY')
data <- data[which(data$DATA_STATUS != "PRELIMINARY"),]

#discard observations that are ND and Not Run
data <- data[which(data$RESULTS != "SAMPLE LOST DURING ANALYSIS"),]
data <- data[which(data$RESULTS != "NO RESULTS FOUND IN BENCH BOOK FOR SAMPLE"),]
data <- data[which(data$RESULTS != "SAMPLE NOT RUN - BAD REAGENT"),]
data <- data[which(data$RESULTS != "NO DATA IN BENCH BOOK"),]
data <- data[which(data$RESULTS != "NO DATA FOUND IN BENCH BOOK"),]


#check depth,position, and lake name
length(data$DEPTH[which(is.na(data$DEPTH)==TRUE)]) 
length(data$DEPTH_ZONE[which(is.na(data$DEPTH_ZONE)==TRUE)]) # NA = OK because we have depth
length(data$WATERBODY_NAME[which(is.na(data$WATERBODY_NAME)==TRUE)]) #NO NA for lake name
length(data$WATERBODY_ID[which(is.na(data$WATERBODY_ID)==TRUE)])
#remove obs w/o ID
data <- data[which(is.na(data$WATERBODY_ID)==FALSE),]

length(data$DEPTH[which(is.na(data$DEPTH) & is.na(data$DEPTH_ZONE))==TRUE]) #0 which is good

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID <- data$WATERBODY_ID
data.Export$LakeName <- data$WATERBODY_NAME
data$PARAMETER <- as.character(data$PARAMETER)
data.Export$SourceVariableName <- as.character(data.Export$SourceVariableName)
data.Export$SourceVariableDescription <- as.character(data.Export$SourceVariableDescription)
data.Export$SourceVariableName[which(data$PARAMETER=='CHLOROPHYLL A, UNCORRECTED FOR PHEOPHYTIN')] <- "CHLOROPHYLL A, UNCORRECTED FOR PHEOPHYTIN" 
data.Export$SourceVariableName[which(data$PARAMETER=='CHLOROPHYLL A (PROBE)')] <- "CHLOROPHYLL A (PROBE)" 
data.Export$SourceVariableDescription[which(data$PARAMETER=='CHLOROPHYLL A, UNCORRECTED FOR PHEOPHYTIN')] <- "Chlorophyll-a uncorrected"
data.Export$SourceVariableDescription[which(data$PARAMETER=='CHLOROPHYLL A (PROBE)')] <- "Chlorophyll-a measured by probe"

#populate SourceFlags
unique(data$LAB_QUALIFIER)
data.Export$SourceFlags <- NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID <- 10
data.Export$LagosVariableName <- "Chlorophyll a, uncorrected for pheophytin"

unique(data$RESULTS)

#no censored obs. set as NC
data.Export$Value <- data$RESULTS
data.Export$CensorCode <- as.character(data.Export$CensorCode)
data.Export$CensorCode[grep("<",data.Export$Value)] <- "LT" 
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)] <- "NC"
unique(data.Export$CensorCode)

data.Export$Value <- gsub("<","",data.Export$Value) #remove the < from values
data.Export$Value <- as.numeric(data.Export$Value)


#continue exporting other info
data.Export$Date <- as.Date(data$START_DATE, format='%m/%d/%y')  #convert date to correct format and populate
data.Export$Units <- "ug/L"

#populate sampelposition
unique(data$DEPTH_ZONE)
data.Export$SamplePosition <- data$DEPTH_ZONE
data.Export$SamplePosition[which(data.Export$SamplePosition=="EPILIMNION")] <- "EPI"
data.Export$SamplePosition[which(data.Export$SamplePosition=="UPPER")] <- "EPI"
data.Export$SamplePosition[which(data.Export$SamplePosition=="LOWER")] <- "HYPO"
data.Export$SamplePosition[which(data.Export$SamplePosition=="METALIMNION")] <- "META"
data.Export$SamplePosition[which(data.Export$SamplePosition=="HYPOLIMNION")] <- "HYPO"
data.Export$SamplePosition[which(data.Export$SamplePosition=="COMPOSITE")] <- "SPECIFIED"
data.Export$SamplePosition[which(is.na(data.Export$SamplePosition)==TRUE)] <- "UNKNOWN"
unique(data.Export$SamplePosition)

# populate sampletype
data.Export$SampleType <- as.character(data.Export$SampleType)
data.Export$SampleType[which(data$DEPTH_ZONE=="COMPOSITE")] <- "INTEGRATED" 
data.Export$SampleType[which(is.na(data.Export$SampleType)==TRUE)] <- "GRAB"
unique(data.Export$SampleType)

#assign sampledepth 
data.Export$SampleDepth <- data$DEPTH
unique(data.Export$SampleDepth)
unique(data$DEPTH_UNITS) #meters and feet convert to meters; those that are NA have no specified numeric depth
sum(is.na(data$DEPTH_UNITS))

data.Export$SampleDepth[which(data$DEPTH_UNITS=="FT")] <- data.Export$SampleDepth[which(data$DEPTH_UNITS=="FT")] * 0.3048

unique(data$DEPTH_MEAS_FROM) #only surface specified here 
unique(data.Export$SampleDepth)

#continue populating other lagos fields
data.Export$BasinType <- "UNKNOWN"
unique(data.Export$BasinType)

#continue with other fields
data.Export$MethodInfo <- NA 

unique(data$ANALYTICAL_METHOD)

data.Export$LabMethodName <- as.character(data.Export$LabMethodName)
data.Export$LabMethodName[which(data$ANALYTICAL_METHOD=='10200H(3)')] <- "APHA_10200H.3"
data.Export$LabMethodName[which(data$ANALYTICAL_METHOD=='10200-H MOD')] <- "NHDES_10200H"
data.Export$LabMethodName[which(data$ANALYTICAL_METHOD=='445')] <- "EPA_445"
data.Export$LabMethodName[which(data$ANALYTICAL_METHOD=='10200H(2)')] <- "APHA_10200H.3"

unique(data.Export$LabMethodName)

data.Export$LabMethodInfo <- NA
unique(data.Export$LabMethodInfo)#look at unique values exported

data.Export$DetectionLimit[which(data.Export$LabMethodName=='APHA_10200H.3')] <- NA
data.Export$DetectionLimit[which(data.Export$LabMethodName=='NHDES_10200H')] <- 0.2
data.Export$DetectionLimit[which(data.Export$LabMethodName=='EPA_445')] <- NA
data.Export$DetectionLimit[which(data.Export$LabMethodName=='APHA_10200H.3')] <- NA

unique(data.Export$DetectionLimit)

data$LKTROPH[which(is.na(data$LKTROPH)==TRUE)] <- "VLAP"
data.Export$Subprogram <- data$LKTROPH
unique(data.Export$Subprogram)

data.Export$Comments <- NA

chla.Final <- data.Export
rm(data)
rm(data.Export)


################################### SECCHI DISK TRANSPARENCY  #############################################################################################################################
data <-Lakedata

#filter so only var of interest remains
unique(data$PARAMETER)
data <- data[which(data$PARAMETER=="SECCHI DISK TRANSPARENCY"),]

str(data)

unique(data$FRACTION_TYPE)


#check data status
unique(data$DATA_STATUS) #all final = good

#remove those that are preliminary
sum(data$DATA_STATUS=='PRELIMINARY')
data <- data[which(data$DATA_STATUS != "PRELIMINARY"),]

#discard observations that are ND and Not Run

#check depth,position, and lake name
length(data$WATERBODY_NAME[which(is.na(data$WATERBODY_NAME)==TRUE)]) #NO NA for lake name
length(data$WATERBODY_ID[which(is.na(data$WATERBODY_ID)==TRUE)])
#remove obs w/o ID
data <- data[which(is.na(data$WATERBODY_ID)==FALSE),]


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID <- data$WATERBODY_ID
data.Export$LakeName <- data$WATERBODY_NAME
data$PARAMETER <- as.character(data$PARAMETER)
data.Export$SourceVariableName <- as.character(data.Export$SourceVariableName)
data.Export$SourceVariableDescription <- as.character(data.Export$SourceVariableDescription)
data.Export$SourceVariableName <-"SECCHI DISK TRANSPARENCY"
data.Export$SourceVariableDescription <- "Secchi Disk"

#populate SourceFlags
unique(data$LAB_QUALIFIER)
data.Export$SourceFlags <- NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID <- 30
data.Export$LagosVariableName <- "Secchi"

unique(data$RESULTS)

#no censored obs. set as NC
data.Export$Value <- data$RESULTS
data.Export$CensorCode <- as.character(data.Export$CensorCode)
data.Export$CensorCode[grep("<",data.Export$Value)] <- "LT" 
data.Export$CensorCode[grep(">",data.Export$Value)] <- "GT" 
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)] <- "NC"
unique(data.Export$CensorCode)

data.Export$Value <- gsub("<","",data.Export$Value) #remove the < from values
data.Export$Value <- gsub(">","",data.Export$Value)
data.Export$Value <- as.numeric(data.Export$Value)


#continue exporting other info
data.Export$Date <- as.Date(data$START_DATE, format='%m/%d/%y')  #convert date to correct format and populate
data.Export$Units <- "m"

#populate sampelposition
unique(data$DEPTH_ZONE)
data.Export$SamplePosition <- "SPECIFIED"


# populate sampletype
data.Export$SampleType <- as.character(data.Export$SampleType)
data.Export$SampleType <- "INTEGRATED"

#assign sampledepth 
data.Export$SampleDepth <- NA

#continue populating other lagos fields
data.Export$BasinType <- "UNKNOWN"
unique(data.Export$BasinType)

#continue with other fields
data.Export$MethodInfo <- as.character(data.Export$MethodInfo)
data.Export$MethodInfo[which(data$ANALYTICAL_METHOD=='SECCHI-SCOPE')] <- 'SECCHI_VIEW'
data.Export$MethodInfo[which(data$ANALYTICAL_METHOD=='SECCHI')] <- NA
data.Export$MethodInfo[which(data$ANALYTICAL_METHOD=='LLMP-SECCHI')] <- NA
unique(data.Export$MethodInfo)

data.Export$LabMethodName <- as.character(data.Export$LabMethodName)
data.Export$LabMethodName <- NA
unique(data.Export$LabMethodName)

data.Export$LabMethodInfo <- NA
unique(data.Export$LabMethodInfo)#look at unique values exported

data.Export$DetectionLimit <- NA
unique(data.Export$DetectionLimit)

data$LKTROPH[which(is.na(data$LKTROPH)==TRUE)] <- "VLAP"
data.Export$Subprogram <- data$LKTROPH
unique(data.Export$Subprogram)

data.Export$Comments <- NA

secchi.Final <- data.Export
rm(data)
rm(data.Export)
###################################### final export ########################################################################################
Final.Export = rbind(toc.Final,tkn.Final,no32.Final,po4.Final,doc.Final,nh4.Final,chla.Final,secchi.Final)
#############################################################################################################
##Duplicates check #################################
#an observation is defined as duplicate if it is NOT unique for programid, lagoslakeid, date, sampledepth, sampleposition, lagosvariableid, datavalue
names(Final.Export)
library(data.table)

data1=data.table(Final.Export,key <- c('LakeID','Value','Date','LagosVariableID','SampleDepth','SamplePosition'))
data1=data1[,Dup:=duplicated(.SD),.SDcols=c('LakeID','Value','Date', 'LagosVariableID', 'SampleDepth', 'SamplePosition')]

data1$Dup[which(data1$Dup==FALSE)]=NA 
data1$Dup[which(data1$Dup==TRUE)]=1
unique(data1$Dup)

#check to see if they add up to the total
length(data1$Dup[which(data1$Dup=="1")])
length(data1$Dup[which(is.na(data1$Dup)==TRUE)])
935+41361#adds up to total

##write table
Final.Export1=data1

typeof(Final.Export1$Value) #make sure value is numeric
length(Final.Export1$Value[which(Final.Export1$Value<0)]) #make sure there are no negative values

nosamplepos=which(is.na(Final.Export1$SampleDepth)==TRUE & Final.Export1$SamplePosition=="UNKNOWN") #make sure that there is some info on sample pos

42296-1784
Final.Export1 <- Final.Export1[-c(nosamplepos),]
length(Final.Export1$Dup[which(Final.Export1$Dup==1)]) #749 are duplicates

write.table(Final.Export1,file="DataImport_NHDES_1995toPresent.csv",row.names=FALSE,sep=",")
