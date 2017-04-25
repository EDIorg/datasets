#set wd
setwd("C:/Users/Sam/Dropbox/CSI-LIMNO_DATA/DATA-lake/MN data/NEW_MPCA_data/DataImport_MN_MPCA_CHEM_1999_2012")


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
#MN lake monitoring program
###############################################################################################################################################
#read in source dataframe
new_mn_mpca <- read.csv("C:/Users/Sam/Dropbox/CSI-LIMNO_DATA/DATA-lake/MN data/NEW_MPCA_data/unedited data from MPCA/MPCA_Lakes_1999_2005.csv", stringsAsFactors=FALSE)
new_mn_mpca1 <- read.csv("C:/Users/Sam/Dropbox/CSI-LIMNO_DATA/DATA-lake/MN data/NEW_MPCA_data/unedited data from MPCA/MPCA_Lakes_2006_2012.csv", stringsAsFactors=FALSE)
new_mn_mpca_final <- rbind(new_mn_mpca,new_mn_mpca1)

###################################  Ammonia-nitrogen  #############################################################################################################################
data <- new_mn_mpca_final
colnames(data)

#remove nulls
unique(data$CHEMICAL_NAME)
data <- data[which(data$CHEMICAL_NAME=='Ammonia-nitrogen'),]
data <- data[which(is.na(data$CHEMICAL_NAME)==FALSE),]
data <- data[which(is.na(data$RESULT_NUMERIC)==FALSE),]
unique(data$SAMPLE_TYPE_CODE)
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-FR'),] #don't want QA samples
unique(data$RESULT_NUMERIC)
unique(data$REPORTABLE_RESULT)# if "N" then filter out

#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA

#assign lake name and id
data.Export$LakeID=data$SYS_LOC_CODE
length(data.Export$LakeID[which(data.Export$LakeID=="")])
data.Export$LakeName = data$LOC_NAME
unique(data.Export$LakeName)
length(data.Export$LakeName[which(data.Export$LakeName=="")])

#continue with other variables
data.Export$SourceVariableName = "Ammonia-nitrogen"
data.Export$SourceVariableDescription = "Ammonia"

#populate SourceFlags
data.Export$SourceFlags <- as.character(data.Export$SourceFlags)
data.Export$SourceFlags <-  NA 


#continue populating other lagos variables
data.Export$LagosVariableID  <- 19
data.Export$LagosVariableName="Nitrogen, NH4"

#export censor code
data.Export$CensorCode <- as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$RESULT_NUMERIC<=data$METHOD_DETECTION_LIMIT)] <- 'LT'
data.Export$CensorCode[which(data$RESULT_NUMERIC>data$METHOD_DETECTION_LIMIT)] <- 'NC'
data.Export$CensorCode[which(is.na(data$METHOD_DETECTION_LIMIT))] <- 'NC'
unique(data.Export$CensorCode)

#export values
data.Export$Value <- data$RESULT_NUMERIC*1000
unique(data.Export$Value)

#continue exporting
data.Export$Date <- data$SAMPLE_DATE
data.Export$Units <- "ug/L"

#prepare to populate sampletype
data.Export$SampleType <- as.character(data.Export$SampleType)
data.Export$SampleType <- ifelse(is.na(data$END_DEPTH),'GRAB','INTEGRATED')


#assign sampledepth 
data.Export$SampleDepth <- ifelse(is.na(data$END_DEPTH),data$START_DEPTH,data$END_DEPTH)
unique(data.Export$SampleDepth)
sum(is.na(data.Export$SampleDepth))

#SAMPLE position
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition <- 'SPECIFIED'

#continue populating other lagos fields
data.Export$BasinType <-as.character(data.Export$BasinType)
data.Export$BasinType <- "UNKNOWN"

#continue with other fields
data.Export$MethodInfo <- as.character(data.Export$MethodInfo)
data.Export$MethodInfo <- NA #not applicable

data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='4500-NH3(H)')] <- 'APHA_4500-NH3(H)'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='350.1')] <- 'EPA_350.1'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='4500-NH3(F)')] <- 'APHA_4500-NH3(F)'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='4500-NH3(E)')] <- 'APHA_4500-NH3(E)'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='4500-NH3(D)')] <- 'APHA_4500-NH3(D)'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='4500-NH3(C)')] <- 'APHA_4500-NH3(C)'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='4500-NH3(G)')] <- 'APHA_4500-NH3(G)'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='I1520')] <- 'USDOI_USGS?_I1520'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='10001')] <- 'HACH_10001'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='I2522')] <- 'USDOI_USGS_I2522'

data.Export$LabMethodInfo<-as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo <- data$ANALYTIC_METHOD

unique(data$DETECTION_LIMIT_UNIT)
data.Export$DetectionLimit <- data$METHOD_DETECTION_LIMIT*1000

data.Export$Comments <- as.character(data.Export$Comments)
data.Export$Comments <- NA

nh3.Final = data.Export
rm(data.Export)
rm(data)

####
###################################  Apparent color  #############################################################################################################################
data <- new_mn_mpca_final
colnames(data)

#remove nulls
unique(data$CHEMICAL_NAME)
data <- data[which(data$CHEMICAL_NAME=='Apparent color'),]
data <- data[which(is.na(data$CHEMICAL_NAME)==FALSE),]
data <- data[which(is.na(data$RESULT_NUMERIC)==FALSE),]
unique(data$SAMPLE_TYPE_CODE)
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-FR'),] #don't want QA samples
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-F'),] #don't want QA samples
unique(data$RESULT_NUMERIC)
unique(data$REPORTABLE_RESULT)# if "N" then filter out

#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA

#assign lake name and id
data.Export$LakeID=data$SYS_LOC_CODE
length(data.Export$LakeID[which(data.Export$LakeID=="")])
data.Export$LakeName = data$LOC_NAME
unique(data.Export$LakeName)
length(data.Export$LakeName[which(data.Export$LakeName=="")])

#continue with other variables
data.Export$SourceVariableName = "Apparent color"
data.Export$SourceVariableDescription = "Apparent color"

#populate SourceFlags
data.Export$SourceFlags <- as.character(data.Export$SourceFlags)
data.Export$SourceFlags <-  NA 


#continue populating other lagos variables
data.Export$LagosVariableID  <- 11
data.Export$LagosVariableName="Color, apparent"

#export censor code
data.Export$CensorCode <- as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$RESULT_NUMERIC<=data$METHOD_DETECTION_LIMIT)] <- 'LT'
data.Export$CensorCode[which(data$RESULT_NUMERIC>data$METHOD_DETECTION_LIMIT)] <- 'NC'
data.Export$CensorCode[which(is.na(data$METHOD_DETECTION_LIMIT))] <- 'NC'
unique(data.Export$CensorCode)

#export values
data.Export$Value <- data$RESULT_NUMERIC
unique(data.Export$Value)

#continue exporting
data.Export$Date <- data$SAMPLE_DATE
data.Export$Units <- "PCU"

#prepare to populate sampletype
data.Export$SampleType <- as.character(data.Export$SampleType)
data.Export$SampleType <- ifelse(is.na(data$END_DEPTH),'GRAB','INTEGRATED')
unique(data.Export$SampleType)

#assign sampledepth 
data.Export$SampleDepth <- ifelse(is.na(data$END_DEPTH),data$START_DEPTH,data$END_DEPTH)
unique(data.Export$SampleDepth)
sum(is.na(data.Export$SampleDepth))

#SAMPLE position
data.Export$SamplePosition <- as.character(data.Export$SamplePosition)
data.Export$SamplePosition <- 'SPECIFIED'

#continue populating other lagos fields
data.Export$BasinType <-as.character(data.Export$BasinType)
data.Export$BasinType <- "UNKNOWN"

#continue with other fields
data.Export$MethodInfo <- as.character(data.Export$MethodInfo)
data.Export$MethodInfo <- NA #not applicable

data.Export$LabMethodName <- as.character(data.Export$LabMethodName)
data.Export$LabMethodName <- 'APHA_2120-B'

data.Export$LabMethodInfo<-as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo <- NA

unique(data$DETECTION_LIMIT_UNIT)
data.Export$DetectionLimit <- data$METHOD_DETECTION_LIMIT

data.Export$Comments <- as.character(data.Export$Comments)
data.Export$Comments <- NA

color.Final = data.Export
rm(data.Export)
rm(data)

###################################  Chlorophyll a  #############################################################################################################################
data <- new_mn_mpca_final
colnames(data)

#remove nulls
unique(data$CHEMICAL_NAME)
data <- data[which(data$CHEMICAL_NAME=='Chlorophyll a'),]
data <- data[which(is.na(data$CHEMICAL_NAME)==FALSE),]
data <- data[which(is.na(data$RESULT_NUMERIC)==FALSE),]
unique(data$SAMPLE_TYPE_CODE)
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-FR'),] #don't want QA samples
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-F'),] #don't want QA samples
unique(data$RESULT_NUMERIC)
unique(data$REPORTABLE_RESULT)# if "N" then filter out

#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA

#assign lake name and id
data.Export$LakeID=data$SYS_LOC_CODE
length(data.Export$LakeID[which(data.Export$LakeID=="")])
data.Export$LakeName = data$LOC_NAME
unique(data.Export$LakeName)
length(data.Export$LakeName[which(data.Export$LakeName=="")])

#continue with other variables
data.Export$SourceVariableName = "Chlorophyll a"
data.Export$SourceVariableDescription = "Chlorophyll a"

#populate SourceFlags
data.Export$SourceFlags <- as.character(data.Export$SourceFlags)
data.Export$SourceFlags <-  NA 


#continue populating other lagos variables
data.Export$LagosVariableID  <- 9
data.Export$LagosVariableName="Chlorophyll a"

#export censor code
data.Export$CensorCode <- as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$RESULT_NUMERIC<=data$METHOD_DETECTION_LIMIT)] <- 'LT'
data.Export$CensorCode[which(data$RESULT_NUMERIC>data$METHOD_DETECTION_LIMIT)] <- 'NC'
data.Export$CensorCode[which(is.na(data$METHOD_DETECTION_LIMIT))] <- 'NC'
unique(data.Export$CensorCode)

#export values
data.Export$Value <- data$RESULT_NUMERIC
unique(data.Export$Value)

#continue exporting
data.Export$Date <- data$SAMPLE_DATE
data.Export$Units <- "ug/L"

#prepare to populate sampletype
data.Export$SampleType <- as.character(data.Export$SampleType)
data.Export$SampleType <- ifelse(is.na(data$END_DEPTH),'GRAB','INTEGRATED')
unique(data.Export$SampleType)

#assign sampledepth 
data.Export$SampleDepth <- ifelse(is.na(data$END_DEPTH),data$START_DEPTH,data$END_DEPTH)
unique(data.Export$SampleDepth)
sum(is.na(data.Export$SampleDepth))

#SAMPLE position
data.Export$SamplePosition <- as.character(data.Export$SamplePosition)
data.Export$SamplePosition <- 'SPECIFIED'

#continue populating other lagos fields
data.Export$BasinType <-as.character(data.Export$BasinType)
data.Export$BasinType <- "UNKNOWN"

#continue with other fields
data.Export$MethodInfo <- as.character(data.Export$MethodInfo)
data.Export$MethodInfo <- NA #not applicable

data.Export$LabMethodName <- as.character(data.Export$LabMethodName)
data.Export$LabMethodName <- 'APHA_10200-H'

data.Export$LabMethodInfo<-as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo <- NA

unique(data$DETECTION_LIMIT_UNIT)
data.Export$DetectionLimit <- data$METHOD_DETECTION_LIMIT

data.Export$Comments <- as.character(data.Export$Comments)
data.Export$Comments <- NA

chla.Final = data.Export
rm(data.Export)
rm(data)

########
###################################  Chlorophyll a, corrected for pheophytin  #############################################################################################################################
data <- new_mn_mpca_final
colnames(data)

#remove nulls
unique(data$CHEMICAL_NAME)
data <- data[which(data$CHEMICAL_NAME=='Chlorophyll a, corrected for pheophytin'),]
data <- data[which(is.na(data$CHEMICAL_NAME)==FALSE),]
data <- data[which(is.na(data$RESULT_NUMERIC)==FALSE),]
unique(data$SAMPLE_TYPE_CODE)
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-FR'),] #don't want QA samples
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-IP'),] #don't want QA samples
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-LD'),] #don't want QA samples
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-FS'),] #don't want QA samples
unique(data$RESULT_NUMERIC)
unique(data$REPORTABLE_RESULT)# if "N" then filter out

#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA

#assign lake name and id
data.Export$LakeID=data$SYS_LOC_CODE
length(data.Export$LakeID[which(data.Export$LakeID=="")])
data.Export$LakeName = data$LOC_NAME
unique(data.Export$LakeName)
length(data.Export$LakeName[which(data.Export$LakeName=="")])

#continue with other variables
data.Export$SourceVariableName = "Chlorophyll a, corrected for pheophytin"
data.Export$SourceVariableDescription = "Chlorophyll a corrected for pheophytin"

#populate SourceFlags
data.Export$SourceFlags <- as.character(data.Export$SourceFlags)
data.Export$SourceFlags <-  NA 


#continue populating other lagos variables
data.Export$LagosVariableID  <- 9
data.Export$LagosVariableName="Chlorophyll a"

#export censor code
data.Export$CensorCode <- as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$RESULT_NUMERIC<=data$METHOD_DETECTION_LIMIT)] <- 'LT'
data.Export$CensorCode[which(data$RESULT_NUMERIC>data$METHOD_DETECTION_LIMIT)] <- 'NC'
data.Export$CensorCode[which(is.na(data$METHOD_DETECTION_LIMIT))] <- 'NC'
unique(data.Export$CensorCode)

#export values
data.Export$Value <- data$RESULT_NUMERIC
unique(data.Export$Value)

#continue exporting
data.Export$Date <- data$SAMPLE_DATE
data.Export$Units <- "ug/L"

#prepare to populate sampletype
data.Export$SampleType <- as.character(data.Export$SampleType)
data.Export$SampleType <- ifelse(is.na(data$END_DEPTH),'GRAB','INTEGRATED')
unique(data.Export$SampleType)

#assign sampledepth 
data.Export$SampleDepth <- ifelse(is.na(data$END_DEPTH),data$START_DEPTH,data$END_DEPTH)
unique(data.Export$SampleDepth)
sum(is.na(data.Export$SampleDepth))

#SAMPLE position
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition <- 'SPECIFIED'

#continue populating other lagos fields
data.Export$BasinType <-as.character(data.Export$BasinType)
data.Export$BasinType <- "UNKNOWN"

#continue with other fields
data.Export$MethodInfo <- as.character(data.Export$MethodInfo)
data.Export$MethodInfo <- NA #not applicable

data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='10200-H')] <- 'APHA_10200-H'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='ASTM D3731-87')] <- 'ASTM_D3731-87'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='APHA 1002G')] <- 'APHA_1002G'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='445')] <- '445'
unique(data.Export$LabMethodName)

data.Export$LabMethodInfo<-as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo <- data$ANALYTIC_METHOD

unique(data$DETECTION_LIMIT_UNIT)
data.Export$DetectionLimit <- data$METHOD_DETECTION_LIMIT

data.Export$Comments <- as.character(data.Export$Comments)
data.Export$Comments <- NA

corr_chla.Final = data.Export
rm(data.Export)
rm(data)
#######
################################### Chlorophyll a, uncorrected for pheophytin #############################################################################################################################
data <- new_mn_mpca_final
colnames(data)

#remove nulls
unique(data$CHEMICAL_NAME)
data <- data[which(data$CHEMICAL_NAME=='Chlorophyll a, uncorrected for pheophytin'),]
data <- data[which(is.na(data$CHEMICAL_NAME)==FALSE),]
data <- data[which(is.na(data$RESULT_NUMERIC)==FALSE),]
unique(data$SAMPLE_TYPE_CODE)
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-FR'),] #don't want QA samples
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-IP'),] #don't want QA samples
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-LD'),] #don't want QA samples
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-FS'),] #don't want QA samples
unique(data$RESULT_NUMERIC)
unique(data$REPORTABLE_RESULT)# if "N" then filter out

#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA

#assign lake name and id
data.Export$LakeID=data$SYS_LOC_CODE
length(data.Export$LakeID[which(data.Export$LakeID=="")])
data.Export$LakeName = data$LOC_NAME
unique(data.Export$LakeName)
length(data.Export$LakeName[which(data.Export$LakeName=="")])

#continue with other variables
data.Export$SourceVariableName = "Chlorophyll a, uncorrected for pheophytin"
data.Export$SourceVariableDescription = "Chlorophyll a uncorrected for pheophytin"

#populate SourceFlags
data.Export$SourceFlags <- as.character(data.Export$SourceFlags)
data.Export$SourceFlags <-  NA 


#continue populating other lagos variables
data.Export$LagosVariableID  <- 10
data.Export$LagosVariableName="Chlorophyll a, uncorrected for pheophytin"


#export values
data.Export$Value[which(data$RESULT_UNIT=='ug/L')] <- data$RESULT_NUMERIC[which(data$RESULT_UNIT=='ug/L')]
data.Export$Value[which(data$RESULT_UNIT=='mg/L')] <- data$RESULT_NUMERIC[which(data$RESULT_UNIT=='mg/L')]*1000

unique(data.Export$Value)
sum(is.na(data.Export$Value))

#continue exporting
data.Export$Date <- data$SAMPLE_DATE
data.Export$Units <- "ug/L"

#prepare to populate sampletype
data.Export$SampleType <- as.character(data.Export$SampleType)
data.Export$SampleType <- ifelse(is.na(data$END_DEPTH),'GRAB','INTEGRATED')
unique(data.Export$SampleType)

#assign sampledepth 
data.Export$SampleDepth <- ifelse(is.na(data$END_DEPTH),data$START_DEPTH,data$END_DEPTH)
unique(data.Export$SampleDepth)
sum(is.na(data.Export$SampleDepth))

#SAMPLE position
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition <- 'SPECIFIED'

#continue populating other lagos fields
data.Export$BasinType <-as.character(data.Export$BasinType)
data.Export$BasinType <- "UNKNOWN"

#continue with other fields
data.Export$MethodInfo <- as.character(data.Export$MethodInfo)
data.Export$MethodInfo <- NA #not applicable

data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='10200-H')] <- 'APHA_10200-H'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='ASTM D3731-87')] <- 'ASTM_D3731-87'
unique(data.Export$LabMethodName)

data.Export$LabMethodInfo<-as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo <- data$ANALYTIC_METHOD

unique(data$DETECTION_LIMIT_UNIT)
data.Export$DetectionLimit <- as.numeric(data.Export$DetectionLimit)
data.Export$DetectionLimit <- data$METHOD_DETECTION_LIMIT

#export censor code
data.Export$CensorCode <- as.character(data.Export$CensorCode)
data.Export$DetectionLimit <- as.numeric(data.Export$DetectionLimit)
data.Export$CensorCode[which(data.Export$Value<=data.Export$DetectionLimit)] <- 'LT'
data.Export$CensorCode[which(data.Export$Value>data.Export$DetectionLimit)] <- 'NC'
data.Export$CensorCode[which(is.na(data.Export$DetectionLimit))] <- 'NC'
unique(data.Export$CensorCode)

data.Export$Comments <- as.character(data.Export$Comments)
data.Export$Comments <- NA

uncorr_chla.Final = data.Export
rm(data.Export)
rm(data)

#######
################################### Depth, Secchi disk depth  #############################################################################################################################
data <- new_mn_mpca_final
colnames(data)

#remove nulls
unique(data$CHEMICAL_NAME)
data <- data[which(data$CHEMICAL_NAME=='Depth, Secchi disk depth'),]
data <- data[which(is.na(data$CHEMICAL_NAME)==FALSE),]
data <- data[which(is.na(data$RESULT_NUMERIC)==FALSE),]
unique(data$SAMPLE_TYPE_CODE)
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-FR'),] #don't want QA samples
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-F'),] #don't want QA samples
unique(data$RESULT_NUMERIC)
unique(data$REPORTABLE_RESULT)# if "N" then filter out

#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA

#assign lake name and id
data.Export$LakeID=data$SYS_LOC_CODE
length(data.Export$LakeID[which(data.Export$LakeID=="")])
data.Export$LakeName = data$LOC_NAME
unique(data.Export$LakeName)
length(data.Export$LakeName[which(data.Export$LakeName=="")])

#continue with other variables
data.Export$SourceVariableName = "Depth, Secchi disk depth"
data.Export$SourceVariableDescription = "Secchi disk reading"

#populate SourceFlags
data.Export$SourceFlags <- as.character(data.Export$SourceFlags)
data.Export$SourceFlags <-  NA 


#continue populating other lagos variables
data.Export$LagosVariableID  <- 30
data.Export$LagosVariableName <- "Secchi"

#export censor code
data.Export$CensorCode <- as.character(data.Export$CensorCode)
data.Export$CensorCode <- 'NC'
unique(data.Export$CensorCode)

#export values
data.Export$Value <- data$RESULT_NUMERIC
unique(data.Export$Value)

#continue exporting
data.Export$Date <- data$SAMPLE_DATE
data.Export$Units <- 'm'

#prepare to populate sampletype
data.Export$SampleType <- as.character(data.Export$SampleType)
data.Export$SampleType <- 'INTEGRATED'

#assign sampledepth 
data.Export$SampleDepth <- NA

#SAMPLE position
data.Export$SamplePosition <- as.character(data.Export$SamplePosition)
data.Export$SamplePosition <- 'SPECIFIED'

#continue populating other lagos fields
data.Export$BasinType <-as.character(data.Export$BasinType)
data.Export$BasinType <- "UNKNOWN"

#continue with other fields
data.Export$MethodInfo <- as.character(data.Export$MethodInfo)
data.Export$MethodInfo <- NA #not applicable

data.Export$LabMethodName <- as.character(data.Export$LabMethodName)
data.Export$LabMethodName <- NA

data.Export$LabMethodInfo<-as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo <- NA

unique(data$DETECTION_LIMIT_UNIT)
data.Export$DetectionLimit <- NA

data.Export$Comments <- as.character(data.Export$Comments)
data.Export$Comments <- NA

secchi.Final = data.Export
rm(data.Export)
rm(data)

###########
###################################  Kjeldahl nitrogen  #############################################################################################################################
data <- new_mn_mpca_final
colnames(data)

#remove nulls
unique(data$CHEMICAL_NAME)
data <- data[which(data$CHEMICAL_NAME=='Kjeldahl nitrogen'),]
unique(data$FRACTION)# want the total only fraction
data <- data[which(data$FRACTION=='Total'),]
data <- data[which(is.na(data$CHEMICAL_NAME)==FALSE),]
data <- data[which(is.na(data$RESULT_NUMERIC)==FALSE),]
unique(data$SAMPLE_TYPE_CODE)
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-FR'),] #don't want QA samples
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-IP'),] #don't want QA samples
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-LD'),] #don't want QA samples
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-FS'),] #don't want QA samples
unique(data$RESULT_NUMERIC)
unique(data$REPORTABLE_RESULT)# if "N" then filter out
unique(data$REPORT_RESULT_UNIT)
data <- data[which(data$REPORT_RESULT_UNIT!='% by wt'),]

#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA

#assign lake name and id
data.Export$LakeID=data$SYS_LOC_CODE
length(data.Export$LakeID[which(data.Export$LakeID=="")])
data.Export$LakeName = data$LOC_NAME
unique(data.Export$LakeName)
length(data.Export$LakeName[which(data.Export$LakeName=="")])

#continue with other variables
data.Export$SourceVariableName = "Kjeldahl nitrogen"
data.Export$SourceVariableDescription = "Kjeldahl nitrogen"

#populate SourceFlags
data.Export$SourceFlags <- as.character(data.Export$SourceFlags)
data.Export$SourceFlags <-  NA 


#continue populating other lagos variables
data.Export$LagosVariableID  <- 16
data.Export$LagosVariableName="Nitrogen, total Kjeldahl"

#export censor code
data.Export$CensorCode <- as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$RESULT_NUMERIC<=data$METHOD_DETECTION_LIMIT)] <- 'LT'
data.Export$CensorCode[which(data$RESULT_NUMERIC>data$METHOD_DETECTION_LIMIT)] <- 'NC'
data.Export$CensorCode[which(is.na(data$METHOD_DETECTION_LIMIT))] <- 'NC'
unique(data.Export$CensorCode)

#export values
data.Export$Value <- data$RESULT_NUMERIC*1000
unique(data.Export$Value)

#continue exporting
data.Export$Date <- data$SAMPLE_DATE
data.Export$Units <- "ug/L"

#prepare to populate sampletype
data.Export$SampleType <- as.character(data.Export$SampleType)
data.Export$SampleType <- ifelse(is.na(data$END_DEPTH),'GRAB','INTEGRATED')
unique(data.Export$SampleType)

#assign sampledepth 
data.Export$SampleDepth <- ifelse(is.na(data$END_DEPTH),data$START_DEPTH,data$END_DEPTH)
unique(data.Export$SampleDepth)
sum(is.na(data.Export$SampleDepth))

#SAMPLE position
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition <- 'SPECIFIED'

#continue populating other lagos fields
data.Export$BasinType <-as.character(data.Export$BasinType)
data.Export$BasinType <- "UNKNOWN"

#continue with other fields
data.Export$MethodInfo <- as.character(data.Export$MethodInfo)
data.Export$MethodInfo <- NA #not applicable

data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='351.2')] <- 'EPA_351.2'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='351.1')] <- 'EPA_351.1'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='4500-NOR(B)')] <- 'APHA_4500-NOR(B)'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='APHA 4500-NORGE')] <- 'APHA_4500-NORGE'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='4500-NH3(C)')] <- 'APHA_4500-NH3(C)'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='4500-NH3(E)')] <- 'APHA_4500-NH3(E)'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='UNKNOWN')] <- NA
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='D3590(A)')] <- 'D3590(A)'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='351.3(A)')] <- 'EPA_351.3(A)'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='350.1')] <- 'EPA_350.1'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='I-2515-91')] <- 'USDOI_USGS_I-2515-91'
unique(data.Export$LabMethodName)

data.Export$LabMethodInfo<-as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo <- data$ANALYTIC_METHOD

unique(data$DETECTION_LIMIT_UNIT)
data.Export$DetectionLimit <- data$METHOD_DETECTION_LIMIT*1000

data.Export$Comments <- as.character(data.Export$Comments)
data.Export$Comments <- NA

tkn.Final = data.Export
rm(data.Export)
rm(data)

########
###################################  Kjeldahl nitrogen-dissolved #############################################################################################################################
data <- new_mn_mpca_final
colnames(data)

#remove nulls
unique(data$CHEMICAL_NAME)
data <- data[which(data$CHEMICAL_NAME=='Kjeldahl nitrogen'),]
unique(data$FRACTION)# want the total only fraction
data <- data[which(data$FRACTION=='Dissolved'),]
data <- data[which(is.na(data$CHEMICAL_NAME)==FALSE),]
data <- data[which(is.na(data$RESULT_NUMERIC)==FALSE),]
unique(data$SAMPLE_TYPE_CODE)
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-FR'),] #don't want QA samples
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-IP'),] #don't want QA samples
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-LD'),] #don't want QA samples
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-FS'),] #don't want QA samples
unique(data$RESULT_NUMERIC)
unique(data$REPORTABLE_RESULT)# if "N" then filter out
unique(data$REPORT_RESULT_UNIT)

#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA

#assign lake name and id
data.Export$LakeID=data$SYS_LOC_CODE
length(data.Export$LakeID[which(data.Export$LakeID=="")])
data.Export$LakeName = data$LOC_NAME
unique(data.Export$LakeName)
length(data.Export$LakeName[which(data.Export$LakeName=="")])

#continue with other variables
data.Export$SourceVariableName = "Kjeldahl nitrogen"
data.Export$SourceVariableDescription = "Kjeldahl nitrogen"

#populate SourceFlags
data.Export$SourceFlags <- as.character(data.Export$SourceFlags)
data.Export$SourceFlags <-  NA 


#continue populating other lagos variables
data.Export$LagosVariableID  <- 15
data.Export$LagosVariableName="Nitrogen, dissolved Kjeldahl"

#export censor code
data.Export$CensorCode <- as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$RESULT_NUMERIC<=data$METHOD_DETECTION_LIMIT)] <- 'LT'
data.Export$CensorCode[which(data$RESULT_NUMERIC>data$METHOD_DETECTION_LIMIT)] <- 'NC'
data.Export$CensorCode[which(is.na(data$METHOD_DETECTION_LIMIT))] <- 'NC'
unique(data.Export$CensorCode)

#export values
data.Export$Value <- data$RESULT_NUMERIC*1000
unique(data.Export$Value)

#continue exporting
data.Export$Date <- data$SAMPLE_DATE
data.Export$Units <- "ug/L"

#prepare to populate sampletype
data.Export$SampleType <- as.character(data.Export$SampleType)
data.Export$SampleType <- ifelse(is.na(data$END_DEPTH),'GRAB','INTEGRATED')
unique(data.Export$SampleType)

#assign sampledepth 
data.Export$SampleDepth <- ifelse(is.na(data$END_DEPTH),data$START_DEPTH,data$END_DEPTH)
unique(data.Export$SampleDepth)
sum(is.na(data.Export$SampleDepth))

#SAMPLE position
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition <- 'SPECIFIED'

#continue populating other lagos fields
data.Export$BasinType <-as.character(data.Export$BasinType)
data.Export$BasinType <- "UNKNOWN"

#continue with other fields
data.Export$MethodInfo <- as.character(data.Export$MethodInfo)
data.Export$MethodInfo <- NA #not applicable

data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='351.2')] <- 'EPA_351.2'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='I-4515-91')] <- 'USDOI_USGS_I-4515-91'
unique(data.Export$LabMethodName)

data.Export$LabMethodInfo<-as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo <- data$ANALYTIC_METHOD

unique(data$DETECTION_LIMIT_UNIT)
data.Export$DetectionLimit <- data$METHOD_DETECTION_LIMIT*1000

data.Export$Comments <- as.character(data.Export$Comments)
data.Export$Comments <- NA

dkn.Final = data.Export
rm(data.Export)
rm(data)
#######
################################### Nutrient-nitrogen-total #############################################################################################################################
data <- new_mn_mpca_final
colnames(data)

#remove nulls
unique(data$CHEMICAL_NAME)
data <- data[which(data$CHEMICAL_NAME=='Nutrient-nitrogen'),]
unique(data$FRACTION)# want the total only fraction
data <- data[which(data$FRACTION=='Total'),]
data <- data[which(is.na(data$CHEMICAL_NAME)==FALSE),]
data <- data[which(is.na(data$RESULT_NUMERIC)==FALSE),]
unique(data$SAMPLE_TYPE_CODE)
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-FR'),] #don't want QA samples
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-IP'),] #don't want QA samples
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-LD'),] #don't want QA samples
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-FS'),] #don't want QA samples
unique(data$RESULT_NUMERIC)
unique(data$REPORTABLE_RESULT)# if "N" then filter out
unique(data$REPORT_RESULT_UNIT)

#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA

#assign lake name and id
data.Export$LakeID=data$SYS_LOC_CODE
length(data.Export$LakeID[which(data.Export$LakeID=="")])
data.Export$LakeName = data$LOC_NAME
unique(data.Export$LakeName)
length(data.Export$LakeName[which(data.Export$LakeName=="")])

#continue with other variables
data.Export$SourceVariableName = "Nutrient-nitrogen"
data.Export$SourceVariableDescription = "Total nitrogen"

#populate SourceFlags
data.Export$SourceFlags <- as.character(data.Export$SourceFlags)
data.Export$SourceFlags <-  NA 


#continue populating other lagos variables
data.Export$LagosVariableID  <- 21
data.Export$LagosVariableName <- "Nitrogen, total"

#export censor code
unique(data$DETECTION_LIMIT_UNIT)
data.Export$CensorCode <- as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$RESULT_NUMERIC<=data$METHOD_DETECTION_LIMIT)] <- 'LT'
data.Export$CensorCode[which(data$RESULT_NUMERIC>data$METHOD_DETECTION_LIMIT)] <- 'NC'
data.Export$CensorCode[which(is.na(data$METHOD_DETECTION_LIMIT))] <- 'NC'
unique(data.Export$CensorCode)

#export values
data.Export$Value <- data$RESULT_NUMERIC*1000
unique(data.Export$Value)

#continue exporting
data.Export$Date <- data$SAMPLE_DATE
data.Export$Units <- "ug/L"

#prepare to populate sampletype
data.Export$SampleType <- as.character(data.Export$SampleType)
data.Export$SampleType <- ifelse(is.na(data$END_DEPTH),'GRAB','INTEGRATED')
unique(data.Export$SampleType)

#assign sampledepth 
data.Export$SampleDepth <- ifelse(is.na(data$END_DEPTH),data$START_DEPTH,data$END_DEPTH)
unique(data.Export$SampleDepth)
sum(is.na(data.Export$SampleDepth))

#SAMPLE position
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition <- 'SPECIFIED'

#continue populating other lagos fields
data.Export$BasinType <-as.character(data.Export$BasinType)
data.Export$BasinType <- "UNKNOWN"

#continue with other fields
data.Export$MethodInfo <- as.character(data.Export$MethodInfo)
data.Export$MethodInfo <- NA #not applicable

data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='APHA 4500-NORGD')] <- 'APHA_4500-NORGD'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='4500-N-C')] <- 'APHA_4500-N-C'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='TN SEC-DER SPEC')] <- 'TN-SEC-DER SPEC'
unique(data.Export$LabMethodName)

data.Export$LabMethodInfo<-as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo <- data$ANALYTIC_METHOD

unique(data$DETECTION_LIMIT_UNIT)
data.Export$DetectionLimit <- data$METHOD_DETECTION_LIMIT*1000

data.Export$Comments <- as.character(data.Export$Comments)
data.Export$Comments <- NA

tn.Final = data.Export
rm(data.Export)
rm(data)
########
################################### Nutrient-nitrogen-dissolved #############################################################################################################################
data <- new_mn_mpca_final
colnames(data)

#remove nulls
unique(data$CHEMICAL_NAME)
data <- data[which(data$CHEMICAL_NAME=='Nutrient-nitrogen'),]
unique(data$FRACTION)# want the dissolved only fraction
data <- data[which(data$FRACTION=='Dissolved'),]
data <- data[which(is.na(data$CHEMICAL_NAME)==FALSE),]
data <- data[which(is.na(data$RESULT_NUMERIC)==FALSE),]
unique(data$SAMPLE_TYPE_CODE)
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-FR'),] #don't want QA samples
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-IP'),] #don't want QA samples
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-LD'),] #don't want QA samples
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-FS'),] #don't want QA samples
unique(data$RESULT_NUMERIC)
unique(data$REPORTABLE_RESULT)# if "N" then filter out
unique(data$REPORT_RESULT_UNIT)

#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA

#assign lake name and id
data.Export$LakeID=data$SYS_LOC_CODE
length(data.Export$LakeID[which(data.Export$LakeID=="")])
data.Export$LakeName = data$LOC_NAME
unique(data.Export$LakeName)
length(data.Export$LakeName[which(data.Export$LakeName=="")])

#continue with other variables
data.Export$SourceVariableName = "Nutrient-nitrogen"
data.Export$SourceVariableDescription = "Total dissolved nitrogen"

#populate SourceFlags
data.Export$SourceFlags <- as.character(data.Export$SourceFlags)
data.Export$SourceFlags <-  NA 


#continue populating other lagos variables
data.Export$LagosVariableID  <- 22
data.Export$LagosVariableName <- "Nitrogen, total dissolved"

#export censor code
unique(data$DETECTION_LIMIT_UNIT)
data.Export$CensorCode <- as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$RESULT_NUMERIC<=data$METHOD_DETECTION_LIMIT)] <- 'LT'
data.Export$CensorCode[which(data$RESULT_NUMERIC>data$METHOD_DETECTION_LIMIT)] <- 'NC'
data.Export$CensorCode[which(is.na(data$METHOD_DETECTION_LIMIT))] <- 'NC'
unique(data.Export$CensorCode)

#export values
data.Export$Value <- data$RESULT_NUMERIC*1000
unique(data.Export$Value)

#continue exporting
data.Export$Date <- data$SAMPLE_DATE
data.Export$Units <- "ug/L"

#prepare to populate sampletype
data.Export$SampleType <- as.character(data.Export$SampleType)
data.Export$SampleType <- ifelse(is.na(data$END_DEPTH),'GRAB','INTEGRATED')
unique(data.Export$SampleType)

#assign sampledepth 
data.Export$SampleDepth <- ifelse(is.na(data$END_DEPTH),data$START_DEPTH,data$END_DEPTH)
unique(data.Export$SampleDepth)
sum(is.na(data.Export$SampleDepth))

#SAMPLE position
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition <- 'SPECIFIED'

#continue populating other lagos fields
data.Export$BasinType <-as.character(data.Export$BasinType)
data.Export$BasinType <- "UNKNOWN"

#continue with other fields
data.Export$MethodInfo <- as.character(data.Export$MethodInfo)
data.Export$MethodInfo <- NA #not applicable

data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='4500-N-C')] <- 'APHA_4500-N-C'
unique(data.Export$LabMethodName)

data.Export$LabMethodInfo<-as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo <- data$ANALYTIC_METHOD

unique(data$DETECTION_LIMIT_UNIT)
data.Export$DetectionLimit <- data$METHOD_DETECTION_LIMIT*1000

data.Export$Comments <- as.character(data.Export$Comments)
data.Export$Comments <- NA

tdn.Final = data.Export
rm(data.Export)
rm(data)
#########
########
################################### Nitrate-total #############################################################################################################################
data <- new_mn_mpca_final
colnames(data)

#remove nulls
unique(data$CHEMICAL_NAME)
data <- data[which(data$CHEMICAL_NAME=='Nitrate'),]
unique(data$FRACTION)# want the total only fraction
data <- data[which(data$FRACTION=='Total'),]
data <- data[which(is.na(data$CHEMICAL_NAME)==FALSE),]
data <- data[which(is.na(data$RESULT_NUMERIC)==FALSE),]
unique(data$SAMPLE_TYPE_CODE)
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-FR'),] #don't want QA samples
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-IP'),] #don't want QA samples
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-LD'),] #don't want QA samples
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-FS'),] #don't want QA samples
unique(data$RESULT_NUMERIC)
unique(data$REPORTABLE_RESULT)# if "N" then filter out
unique(data$REPORT_RESULT_UNIT)

#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA

#assign lake name and id
data.Export$LakeID=data$SYS_LOC_CODE
length(data.Export$LakeID[which(data.Export$LakeID=="")])
data.Export$LakeName = data$LOC_NAME
unique(data.Export$LakeName)
length(data.Export$LakeName[which(data.Export$LakeName=="")])

#continue with other variables
data.Export$SourceVariableName = "Nitrate"
data.Export$SourceVariableDescription = "Total nitrate"

#populate SourceFlags
data.Export$SourceFlags <- as.character(data.Export$SourceFlags)
data.Export$SourceFlags <-  NA 


#continue populating other lagos variables
data.Export$LagosVariableID  <- 18
data.Export$LagosVariableName <- "Nitrogen, nitrite (NO2) + nitrate (NO3)"

#export censor code
unique(data$DETECTION_LIMIT_UNIT)
data.Export$CensorCode <- as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$RESULT_NUMERIC<=data$METHOD_DETECTION_LIMIT)] <- 'LT'
data.Export$CensorCode[which(data$RESULT_NUMERIC>data$METHOD_DETECTION_LIMIT)] <- 'NC'
data.Export$CensorCode[which(is.na(data$METHOD_DETECTION_LIMIT))] <- 'NC'
unique(data.Export$CensorCode)

#export values
data.Export$Value <- data$RESULT_NUMERIC*1000
unique(data.Export$Value)

#continue exporting
data.Export$Date <- data$SAMPLE_DATE
data.Export$Units <- "ug/L"

#prepare to populate sampletype
data.Export$SampleType <- as.character(data.Export$SampleType)
data.Export$SampleType <- ifelse(is.na(data$END_DEPTH),'GRAB','INTEGRATED')
unique(data.Export$SampleType)

#assign sampledepth 
data.Export$SampleDepth <- ifelse(is.na(data$END_DEPTH),data$START_DEPTH,data$END_DEPTH)
unique(data.Export$SampleDepth)
sum(is.na(data.Export$SampleDepth))

#SAMPLE position
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition <- 'SPECIFIED'

#continue populating other lagos fields
data.Export$BasinType <-as.character(data.Export$BasinType)
data.Export$BasinType <- "UNKNOWN"

#continue with other fields
data.Export$MethodInfo <- as.character(data.Export$MethodInfo)
data.Export$MethodInfo <- NA #not applicable

data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='353.1')] <- 'EPA_353.1'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='4500-NO3(E)')] <- 'APHA_4500-NO3(E)'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='4500-NO3(D)')] <- 'APHA_4500-NO3(D)'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='4500-NO3(F)')] <- 'APHA_4500-NO3(F)'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='353.2')] <- 'EPA_353.2'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='4500-NO3(H)')] <- 'APHA_4500-NO3(H)'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='353.3')] <- 'EPA_353.3'


unique(data.Export$LabMethodName)

data.Export$LabMethodInfo<-as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo <- data$ANALYTIC_METHOD

unique(data$DETECTION_LIMIT_UNIT)
data.Export$DetectionLimit <- data$METHOD_DETECTION_LIMIT*1000

data.Export$Comments <- as.character(data.Export$Comments)
data.Export$Comments <- NA

tno3.Final = data.Export
rm(data.Export)
rm(data)

#######
################################### Nitrate-dissolved #############################################################################################################################
data <- new_mn_mpca_final
colnames(data)

#remove nulls
unique(data$CHEMICAL_NAME)
data <- data[which(data$CHEMICAL_NAME=='Nitrate'),]
unique(data$FRACTION)# want the dissolved only fraction
data <- data[which(data$FRACTION=='Dissolved'),]
data <- data[which(is.na(data$CHEMICAL_NAME)==FALSE),]
data <- data[which(is.na(data$RESULT_NUMERIC)==FALSE),]
unique(data$SAMPLE_TYPE_CODE)
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-FR'),] #don't want QA samples
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-IP'),] #don't want QA samples
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-LD'),] #don't want QA samples
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-FS'),] #don't want QA samples
unique(data$RESULT_NUMERIC)
unique(data$REPORTABLE_RESULT)# if "N" then filter out
unique(data$REPORT_RESULT_UNIT)

#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA

#assign lake name and id
data.Export$LakeID=data$SYS_LOC_CODE
length(data.Export$LakeID[which(data.Export$LakeID=="")])
data.Export$LakeName = data$LOC_NAME
unique(data.Export$LakeName)
length(data.Export$LakeName[which(data.Export$LakeName=="")])

#continue with other variables
data.Export$SourceVariableName = "Nitrate"
data.Export$SourceVariableDescription = "Dissolved nitrate"

#populate SourceFlags
data.Export$SourceFlags <- as.character(data.Export$SourceFlags)
data.Export$SourceFlags <-  NA 


#continue populating other lagos variables
data.Export$LagosVariableID  <- 18
data.Export$LagosVariableName <- "Nitrogen, nitrite (NO2) + nitrate (NO3)"

#export censor code
unique(data$DETECTION_LIMIT_UNIT)
data.Export$CensorCode <- as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$RESULT_NUMERIC<=data$METHOD_DETECTION_LIMIT)] <- 'LT'
data.Export$CensorCode[which(data$RESULT_NUMERIC>data$METHOD_DETECTION_LIMIT)] <- 'NC'
data.Export$CensorCode[which(is.na(data$METHOD_DETECTION_LIMIT))] <- 'NC'
unique(data.Export$CensorCode)

#export values
data.Export$Value <- data$RESULT_NUMERIC*1000
unique(data.Export$Value)

#continue exporting
data.Export$Date <- data$SAMPLE_DATE
data.Export$Units <- "ug/L"

#prepare to populate sampletype
data.Export$SampleType <- as.character(data.Export$SampleType)
data.Export$SampleType <- ifelse(is.na(data$END_DEPTH),'GRAB','INTEGRATED')
unique(data.Export$SampleType)

#assign sampledepth 
data.Export$SampleDepth <- ifelse(is.na(data$END_DEPTH),data$START_DEPTH,data$END_DEPTH)
unique(data.Export$SampleDepth)
sum(is.na(data.Export$SampleDepth))

#SAMPLE position
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition <- 'SPECIFIED'

#continue populating other lagos fields
data.Export$BasinType <-as.character(data.Export$BasinType)
data.Export$BasinType <- "UNKNOWN"

#continue with other fields
data.Export$MethodInfo <- as.character(data.Export$MethodInfo)
data.Export$MethodInfo <- NA #not applicable

data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='353.2')] <- 'EPA_353.2'
unique(data.Export$LabMethodName)

data.Export$LabMethodInfo<-as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo <- data$ANALYTIC_METHOD

unique(data$DETECTION_LIMIT_UNIT)
data.Export$DetectionLimit <- data$METHOD_DETECTION_LIMIT*1000

data.Export$Comments <- as.character(data.Export$Comments)
data.Export$Comments <- NA

dno3.Final = data.Export
rm(data.Export)
rm(data)
#######
#######
################################### Organic carbon-total #############################################################################################################################
data <- new_mn_mpca_final
colnames(data)

#remove nulls
unique(data$CHEMICAL_NAME)
data <- data[which(data$CHEMICAL_NAME=='Organic carbon'),]
unique(data$FRACTION)# want the total only fraction
data <- data[which(data$FRACTION=='Total'),]
data <- data[which(is.na(data$CHEMICAL_NAME)==FALSE),]
data <- data[which(is.na(data$RESULT_NUMERIC)==FALSE),]
unique(data$SAMPLE_TYPE_CODE)
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-FR'),] #don't want QA samples
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-IP'),] #don't want QA samples
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-LD'),] #don't want QA samples
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-FS'),] #don't want QA samples
unique(data$RESULT_NUMERIC)
unique(data$REPORTABLE_RESULT)# if "N" then filter out
unique(data$REPORT_RESULT_UNIT)

#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA

#assign lake name and id
data.Export$LakeID=data$SYS_LOC_CODE
length(data.Export$LakeID[which(data.Export$LakeID=="")])
data.Export$LakeName = data$LOC_NAME
unique(data.Export$LakeName)
length(data.Export$LakeName[which(data.Export$LakeName=="")])

#continue with other variables
data.Export$SourceVariableName = "Organic carbon"
data.Export$SourceVariableDescription = "Total organic carbon"

#populate SourceFlags
data.Export$SourceFlags <- as.character(data.Export$SourceFlags)
data.Export$SourceFlags <-  NA 


#continue populating other lagos variables
data.Export$LagosVariableID  <- 7
data.Export$LagosVariableName <- "Carbon, total organic"

#export censor code
unique(data$DETECTION_LIMIT_UNIT)
data.Export$CensorCode <- as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$RESULT_NUMERIC<=data$METHOD_DETECTION_LIMIT)] <- 'LT'
data.Export$CensorCode[which(data$RESULT_NUMERIC>data$METHOD_DETECTION_LIMIT)] <- 'NC'
data.Export$CensorCode[which(is.na(data$METHOD_DETECTION_LIMIT))] <- 'NC'
unique(data.Export$CensorCode)

#export values
data.Export$Value <- data$RESULT_NUMERIC
unique(data.Export$Value)

#continue exporting
data.Export$Date <- data$SAMPLE_DATE
data.Export$Units <- "mg/L"

#prepare to populate sampletype
data.Export$SampleType <- as.character(data.Export$SampleType)
data.Export$SampleType <- ifelse(is.na(data$END_DEPTH),'GRAB','INTEGRATED')
unique(data.Export$SampleType)

#assign sampledepth 
data.Export$SampleDepth <- ifelse(is.na(data$END_DEPTH),data$START_DEPTH,data$END_DEPTH)
unique(data.Export$SampleDepth)
sum(is.na(data.Export$SampleDepth))

#SAMPLE position
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition <- 'SPECIFIED'

#continue populating other lagos fields
data.Export$BasinType <-as.character(data.Export$BasinType)
data.Export$BasinType <- "UNKNOWN"

#continue with other fields
data.Export$MethodInfo <- as.character(data.Export$MethodInfo)
data.Export$MethodInfo <- NA #not applicable

data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='5310-C')] <- 'APHA_5310-C'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='415.1')] <- 'EPA_415.1'
unique(data.Export$LabMethodName)

data.Export$LabMethodInfo<-as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo <- data$ANALYTIC_METHOD

unique(data$DETECTION_LIMIT_UNIT)
data.Export$DetectionLimit <- data$METHOD_DETECTION_LIMIT

data.Export$Comments <- as.character(data.Export$Comments)
data.Export$Comments <- NA

toc.Final = data.Export
rm(data.Export)
rm(data)
###############
################################### Organic carbon-dissolved #############################################################################################################################
data <- new_mn_mpca_final
colnames(data)

#remove nulls
unique(data$CHEMICAL_NAME)
data <- data[which(data$CHEMICAL_NAME=='Organic carbon'),]
unique(data$FRACTION)# want the dissolved only fraction
data <- data[which(data$FRACTION=='Dissolved'),]
data <- data[which(is.na(data$CHEMICAL_NAME)==FALSE),]
data <- data[which(is.na(data$RESULT_NUMERIC)==FALSE),]
unique(data$SAMPLE_TYPE_CODE)
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-FR'),] #don't want QA samples
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-IP'),] #don't want QA samples
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-LD'),] #don't want QA samples
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-FS'),] #don't want QA samples
unique(data$RESULT_NUMERIC)
unique(data$REPORTABLE_RESULT)# if "N" then filter out
unique(data$REPORT_RESULT_UNIT)

#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA

#assign lake name and id
data.Export$LakeID=data$SYS_LOC_CODE
length(data.Export$LakeID[which(data.Export$LakeID=="")])
data.Export$LakeName = data$LOC_NAME
unique(data.Export$LakeName)
length(data.Export$LakeName[which(data.Export$LakeName=="")])

#continue with other variables
data.Export$SourceVariableName = "Organic carbon"
data.Export$SourceVariableDescription = "Dissolved organic carbon"

#populate SourceFlags
data.Export$SourceFlags <- as.character(data.Export$SourceFlags)
data.Export$SourceFlags <-  NA 


#continue populating other lagos variables
data.Export$LagosVariableID  <- 6
data.Export$LagosVariableName <- "Carbon, dissolved organic"

#export censor code
unique(data$DETECTION_LIMIT_UNIT)
data.Export$CensorCode <- as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$RESULT_NUMERIC<=data$METHOD_DETECTION_LIMIT)] <- 'LT'
data.Export$CensorCode[which(data$RESULT_NUMERIC>data$METHOD_DETECTION_LIMIT)] <- 'NC'
data.Export$CensorCode[which(is.na(data$METHOD_DETECTION_LIMIT))] <- 'NC'
unique(data.Export$CensorCode)

#export values
data.Export$Value <- data$RESULT_NUMERIC
unique(data.Export$Value)

#continue exporting
data.Export$Date <- data$SAMPLE_DATE
data.Export$Units <- "mg/L"

#prepare to populate sampletype
data.Export$SampleType <- as.character(data.Export$SampleType)
data.Export$SampleType <- ifelse(is.na(data$END_DEPTH),'GRAB','INTEGRATED')
unique(data.Export$SampleType)

#assign sampledepth 
data.Export$SampleDepth <- ifelse(is.na(data$END_DEPTH),data$START_DEPTH,data$END_DEPTH)
unique(data.Export$SampleDepth)
sum(is.na(data.Export$SampleDepth))

#SAMPLE position
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition <- 'SPECIFIED'

#continue populating other lagos fields
data.Export$BasinType <-as.character(data.Export$BasinType)
data.Export$BasinType <- "UNKNOWN"

#continue with other fields
data.Export$MethodInfo <- as.character(data.Export$MethodInfo)
data.Export$MethodInfo <- NA #not applicable

data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='5310-C')] <- 'APHA_5310-C'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='415.1')] <- 'EPA_415.1'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='5310-B')] <- 'APHA_5310-B'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='9060')] <- 'EPA_9060'
unique(data.Export$LabMethodName)

data.Export$LabMethodInfo<-as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo <- data$ANALYTIC_METHOD

unique(data$DETECTION_LIMIT_UNIT)
data.Export$DetectionLimit <- data$METHOD_DETECTION_LIMIT

data.Export$Comments <- as.character(data.Export$Comments)
data.Export$Comments <- NA

doc.Final = data.Export
rm(data.Export)
rm(data)

######
#######
################################### Phosphorus #############################################################################################################################
data <- new_mn_mpca_final
colnames(data)

#remove nulls
unique(data$CHEMICAL_NAME)
data <- data[which(data$CHEMICAL_NAME=='Phosphorus'),]
unique(data$FRACTION)# want the total only fraction
data <- data[which(data$FRACTION=='Total'),]
data <- data[which(is.na(data$CHEMICAL_NAME)==FALSE),]
data <- data[which(is.na(data$RESULT_NUMERIC)==FALSE),]
unique(data$SAMPLE_TYPE_CODE)
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-FR'),] #don't want QA samples
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-IP'),] #don't want QA samples
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-LD'),] #don't want QA samples
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-FS'),] #don't want QA samples
unique(data$RESULT_NUMERIC)
unique(data$REPORTABLE_RESULT)# if "N" then filter out
unique(data$REPORT_RESULT_UNIT)

#filter out sediment tp
data <- data[which(data$MATRIX_CODE!='Soil-Surf'),]
data <- data[which(data$MATRIX_CODE!='Sed-USieve'),]

#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA

#assign lake name and id
data.Export$LakeID=data$SYS_LOC_CODE
length(data.Export$LakeID[which(data.Export$LakeID=="")])
data.Export$LakeName = data$LOC_NAME
unique(data.Export$LakeName)
length(data.Export$LakeName[which(data.Export$LakeName=="")])

#continue with other variables
data.Export$SourceVariableName = "Phosphorus"
data.Export$SourceVariableDescription = "Total Phosphorus"

#populate SourceFlags
data.Export$SourceFlags <- as.character(data.Export$SourceFlags)
data.Export$SourceFlags <-  NA 


#continue populating other lagos variables
data.Export$LagosVariableID  <- 27
data.Export$LagosVariableName <- "Phosphorus, total"

#export censor code
unique(data$DETECTION_LIMIT_UNIT)
data.Export$CensorCode <- as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$RESULT_NUMERIC<=data$METHOD_DETECTION_LIMIT)] <- 'LT'
data.Export$CensorCode[which(data$RESULT_NUMERIC>data$METHOD_DETECTION_LIMIT)] <- 'NC'
data.Export$CensorCode[which(is.na(data$METHOD_DETECTION_LIMIT))] <- 'NC'
unique(data.Export$CensorCode)

#export values
data.Export$Value <- data$RESULT_NUMERIC*1000
unique(data.Export$Value)

#continue exporting
data.Export$Date <- data$SAMPLE_DATE
data.Export$Units <- "ug/L"

#prepare to populate sampletype
data.Export$SampleType <- as.character(data.Export$SampleType)
data.Export$SampleType <- ifelse(is.na(data$END_DEPTH),'GRAB','INTEGRATED')
unique(data.Export$SampleType)

#assign sampledepth 
data.Export$SampleDepth <- ifelse(is.na(data$END_DEPTH),data$START_DEPTH,data$END_DEPTH)
unique(data.Export$SampleDepth)
sum(is.na(data.Export$SampleDepth))

#SAMPLE position
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition <- 'SPECIFIED'

#continue populating other lagos fields
data.Export$BasinType <-as.character(data.Export$BasinType)
data.Export$BasinType <- "UNKNOWN"

#continue with other fields
data.Export$MethodInfo <- as.character(data.Export$MethodInfo)
data.Export$MethodInfo <- NA #not applicable

data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='365.1')] <- 'EPA_365.1'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='365.3')] <- 'EPA_365.3'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='4500-P-E')] <- 'APHA_4500-P-E'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='365.2')] <- 'EPA_365.2'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='MDH058C')] <- 'MNPCA_MDH058C'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='365.4')] <- 'EPA_365.4'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='4500-P-F')] <- 'APHA_4500-P-F'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='4500-P-C')] <- 'APHA_4500-P-C'
unique(data.Export$LabMethodName)

data.Export$LabMethodInfo<-as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo <- data$ANALYTIC_METHOD

unique(data$DETECTION_LIMIT_UNIT)
data.Export$DetectionLimit <- data$METHOD_DETECTION_LIMIT*1000

data.Export$Comments <- as.character(data.Export$Comments)
data.Export$Comments <- NA

tp.Final = data.Export
rm(data.Export)
rm(data)

############################################
################################### Phosphorus-dissolved #############################################################################################################################
data <- new_mn_mpca_final
colnames(data)

#remove nulls
unique(data$CHEMICAL_NAME)
data <- data[which(data$CHEMICAL_NAME=='Phosphorus'),]
unique(data$FRACTION)# want the dissolved only fraction
data <- data[which(data$FRACTION=='Dissolved'),]
data <- data[which(is.na(data$CHEMICAL_NAME)==FALSE),]
data <- data[which(is.na(data$RESULT_NUMERIC)==FALSE),]
unique(data$SAMPLE_TYPE_CODE)
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-FR'),] #don't want QA samples
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-IP'),] #don't want QA samples
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-LD'),] #don't want QA samples
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-FS'),] #don't want QA samples
unique(data$RESULT_NUMERIC)
unique(data$REPORTABLE_RESULT)# if "N" then filter out
unique(data$REPORT_RESULT_UNIT)


#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA

#assign lake name and id
data.Export$LakeID=data$SYS_LOC_CODE
length(data.Export$LakeID[which(data.Export$LakeID=="")])
data.Export$LakeName = data$LOC_NAME
unique(data.Export$LakeName)
length(data.Export$LakeName[which(data.Export$LakeName=="")])

#continue with other variables
data.Export$SourceVariableName = "Phosphorus"
data.Export$SourceVariableDescription = "Soluable reactive Phosphorus"

#populate SourceFlags
data.Export$SourceFlags <- as.character(data.Export$SourceFlags)
data.Export$SourceFlags <-  NA 


#continue populating other lagos variables
data.Export$LagosVariableID  <- 26
data.Export$LagosVariableName <- "Phosphorus, soluable reactive orthophosphate"

#export censor code
unique(data$DETECTION_LIMIT_UNIT)
data.Export$CensorCode <- as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$RESULT_NUMERIC<=data$METHOD_DETECTION_LIMIT)] <- 'LT'
data.Export$CensorCode[which(data$RESULT_NUMERIC>data$METHOD_DETECTION_LIMIT)] <- 'NC'
data.Export$CensorCode[which(is.na(data$METHOD_DETECTION_LIMIT))] <- 'NC'
unique(data.Export$CensorCode)

#export values
data.Export$Value <- data$RESULT_NUMERIC*1000
unique(data.Export$Value)

#continue exporting
data.Export$Date <- data$SAMPLE_DATE
data.Export$Units <- "ug/L"

#prepare to populate sampletype
data.Export$SampleType <- as.character(data.Export$SampleType)
data.Export$SampleType <- ifelse(is.na(data$END_DEPTH),'GRAB','INTEGRATED')
unique(data.Export$SampleType)

#assign sampledepth 
data.Export$SampleDepth <- ifelse(is.na(data$END_DEPTH),data$START_DEPTH,data$END_DEPTH)
unique(data.Export$SampleDepth)
sum(is.na(data.Export$SampleDepth))

#SAMPLE position
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition <- 'SPECIFIED'

#continue populating other lagos fields
data.Export$BasinType <-as.character(data.Export$BasinType)
data.Export$BasinType <- "UNKNOWN"

#continue with other fields
data.Export$MethodInfo <- as.character(data.Export$MethodInfo)
data.Export$MethodInfo <- NA #not applicable

data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='365.1')] <- 'EPA_365.1'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='365.3')] <- 'EPA_365.3'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='365.4')] <- 'EPA_365.4'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='4500-P-C')] <- 'APHA_4500-P-C'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='4500-P-E')] <- 'APHA_4500-P-E'
unique(data.Export$LabMethodName)

data.Export$LabMethodInfo<-as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo <- data$ANALYTIC_METHOD

unique(data$DETECTION_LIMIT_UNIT)
data.Export$DetectionLimit <- data$METHOD_DETECTION_LIMIT*1000

data.Export$Comments <- as.character(data.Export$Comments)
data.Export$Comments <- NA

srp.Final = data.Export
rm(data.Export)
rm(data)

########
################################### True color  #############################################################################################################################
data <- new_mn_mpca_final
colnames(data)

#remove nulls
unique(data$CHEMICAL_NAME)
data <- data[which(data$CHEMICAL_NAME=='True color'),]
unique(data$FRACTION)
data <- data[which(is.na(data$CHEMICAL_NAME)==FALSE),]
data <- data[which(is.na(data$RESULT_NUMERIC)==FALSE),]
unique(data$SAMPLE_TYPE_CODE)
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-FR'),] #don't want QA samples
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-IP'),] #don't want QA samples
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-LD'),] #don't want QA samples
data <- data[which(data$SAMPLE_TYPE_CODE!='QC-FS'),] #don't want QA samples
unique(data$RESULT_NUMERIC)
unique(data$REPORTABLE_RESULT)# if "N" then filter out
unique(data$REPORT_RESULT_UNIT)


#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA

#assign lake name and id
data.Export$LakeID=data$SYS_LOC_CODE
length(data.Export$LakeID[which(data.Export$LakeID=="")])
data.Export$LakeName = data$LOC_NAME
unique(data.Export$LakeName)
length(data.Export$LakeName[which(data.Export$LakeName=="")])

#continue with other variables
data.Export$SourceVariableName = "True color"
data.Export$SourceVariableDescription = "True color"

#populate SourceFlags
data.Export$SourceFlags <- as.character(data.Export$SourceFlags)
data.Export$SourceFlags <-  NA 


#continue populating other lagos variables
data.Export$LagosVariableID  <- 12
data.Export$LagosVariableName <- "Color, true"

#export censor code
unique(data$DETECTION_LIMIT_UNIT)
data.Export$CensorCode <- as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$RESULT_NUMERIC<=data$METHOD_DETECTION_LIMIT)] <- 'LT'
data.Export$CensorCode[which(data$RESULT_NUMERIC>data$METHOD_DETECTION_LIMIT)] <- 'NC'
data.Export$CensorCode[which(is.na(data$METHOD_DETECTION_LIMIT))] <- 'NC'
unique(data.Export$CensorCode)

#export values
data.Export$Value <- data$RESULT_NUMERIC
unique(data.Export$Value)

#continue exporting
data.Export$Date <- data$SAMPLE_DATE
data.Export$Units <- "PCU"

#prepare to populate sampletype
data.Export$SampleType <- as.character(data.Export$SampleType)
data.Export$SampleType <- ifelse(is.na(data$END_DEPTH),'GRAB','INTEGRATED')
unique(data.Export$SampleType)

#assign sampledepth 
data.Export$SampleDepth <- ifelse(is.na(data$END_DEPTH),data$START_DEPTH,data$END_DEPTH)
unique(data.Export$SampleDepth)
sum(is.na(data.Export$SampleDepth))

#SAMPLE position
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition <- 'SPECIFIED'

#continue populating other lagos fields
data.Export$BasinType <-as.character(data.Export$BasinType)
data.Export$BasinType <- "UNKNOWN"

#continue with other fields
data.Export$MethodInfo <- as.character(data.Export$MethodInfo)
data.Export$MethodInfo <- NA #not applicable

data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='110.2')] <- 'EPA_110.2'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='2120-B')] <- 'APHA_2120-B'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='110.3')] <- 'EPA_110.3'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='UNKNOWN')] <- 'UNKNOWN'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='TB_253')] <- 'TB_253'
data.Export$LabMethodName[which(data$ANALYTIC_METHOD=='2120-C')] <- 'APHA_2120-C'
unique(data.Export$LabMethodName)

data.Export$LabMethodInfo<-as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo <- data$ANALYTIC_METHOD

unique(data$DETECTION_LIMIT_UNIT)
data.Export$DetectionLimit <- data$METHOD_DETECTION_LIMIT

data.Export$Comments <- as.character(data.Export$Comments)
data.Export$Comments <- NA

trueColor.Final = data.Export
rm(data.Export)
rm(data)

###################################### final export ########################################################################################
Final.Export = rbind(nh3.Final,color.Final,chla.Final,corr_chla.Final,uncorr_chla.Final,secchi.Final,
                     tkn.Final,dkn.Final,tn.Final,tdn.Final,tno3.Final,dno3.Final,toc.Final,doc.Final,
                     tp.Final,srp.Final,trueColor.Final)
################################################################################################################################################
#assign those w/o a sample depth as "UNKNOWN" for position
length(Final.Export$SampleDepth[which(is.na(Final.Export$SampleDepth))])
sum(is.na(Final.Export$SampleDepth))
Final.Export$SamplePosition[which(is.na(Final.Export$SampleDepth)==TRUE)] <- 'UNKNOWN'
length(Final.Export$SamplePosition[which(Final.Export$SamplePosition=='UNKNOWN')])


nosamplepos=Final.Export[which(is.na(Final.Export$SampleDepth)==TRUE & Final.Export$SamplePosition=="UNKNOWN"),]

nodep <- nosamplepos[which(nosamplepos$LagosVariableName!='Secchi'),]

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
4680+627106#adds up to total
##write table
Final.Export1 <- data1
typeof(Final.Export1$Value)
length(Final.Export1$Value[which(Final.Export1$Value<0)])
Final.Export1 <- Final.Export1[which(Final.Export1$Value>=0),]
write.table(Final.Export1,file="DataImport_MN_MPCA_CHEM_1999_2012.csv",row.names=FALSE,sep=",")

