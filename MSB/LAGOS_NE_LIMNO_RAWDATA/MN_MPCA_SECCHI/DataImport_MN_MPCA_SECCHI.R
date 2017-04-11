#path to files
setwd("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MN data/MPCA_chemistry/CSILimnoData/DataImport_MN_MPCA_SECCHI")

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
#SAMPLE_TYPE values
#don't have to worry about dealing with replicates
###########################################################################################################################################################################################
###################################Depth, Secchi disk depth #############################################################################################################################
data=Citizen_Lake.Monitoring_Program_Secchi
head(data) #looking at data
names(data)#column names
#filter out data not interested in
data$PARAMETER=as.character(data$PARAMETER)
unique(data$PARAMETER) #only secchi depth
unique(data$SAMPLE_FRACTION_TYPE) #not applicable to secchi only an observation - dissolved, total doesn't apply
data$RESULT[which(data$RESULT=="")]=NA #missing values indicated by blank cell, set to NA
length(data$RESULT[which(is.na(data$RESULT)==TRUE)]) #check for NA values
data = data[which(is.na(data$RESULT)==FALSE),] #remove NA values (none here)
unique(data$PARAMETER)#check to make sure not other parameters mixed in
unique(data$RESULT_UNIT) #check to make sure only one unique unit, only one unit found = meters
unique(data$SAMPLE_TYPE) #FMO= obervation is a field measurment, only one unique SAMPLE_TYPE
unique(data$GTLT) #only ">" which means GT, in this case the secchi disk hit the bottom of the lake
unique(data$STATISTIC_TYPE) #look at what's unique here, filter out, null
length(data$STATISTIC_TYPE[which(data$STATISTIC_TYPE=="Mean")]) #specify that these obs are an average in the comments field
length(data$GTLT[which(data$GTLT=="> ")])
#3304 obs. are ">" or lagos CensorCode "GT" that is to say the secchi hit the bottom
length(data$STATISTIC_TYPE[which(data$STATISTIC_TYPE=="Minimum")])
#3304 obs. are also "Minimum" which makes sense because  ">" means a minimum value was reported--the actual value is larger
#no other filtering req'd move onto populating lagos

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
names(data)
typeof(data$RESULT)
data.Export$Value = data[,10] #export secchi values, already in preferred units of m
unique(data.Export$Value)
data.Export$CensorCode=as.character(data.Export$CensorCode)
length(data$GTLT[which(data$GTLT=="> ")]) 
data.Export$CensorCode[which(data$GTLT=="> ")]= "GT"
length(data.Export$CensorCode[which(data.Export$CensorCode=="GT")]) #check to make sure proper number exported
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]="NC"
length(data.Export$CensorCode[which(data.Export$CensorCode=="NC")])#check to make sure proper number exported
336012+3304 #check to make sure numbers add up
data.Export$Date = data$SAMPLE_DATE #date already in correct format
data.Export$Units="m"
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED"
#populate SamplePosition
data.Export$SamplePosition="SPECIFIED"
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth=NA
#continue populating other lagos fields
data.Export$BasinType="UNKNOWN" #not specified in data
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable to SECCHI
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA 
data.Export$DetectionLimit= NA #per metadata
data.Export$Comments=as.character(data.Export$Comments)
length(data$STATISTIC_TYPE[which(data$STATISTIC_TYPE=="Mean")])#52 obs reported as mean
data.Export$Comments[which(data$STATISTIC_TYPE=="Mean")]="observation is reported as an average depth"
length(data.Export$Comments[which(data.Export$Comments=="observation is reported as an average depth")]) #check to make sure proper number of comments
data.Export$Subprogram= NA #not specified
Secchi.Final = data.Export
rm(data)
rm(data.Export)
##############################################
Final.Export = rbind(Secchi.Final)
#################################################
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
8+339308#adds up to total
##write table
Final.Export1=data1
typeof(Final.Export1$Value)
length(Final.Export1$Value[which(Final.Export1$Value<0)])
nosamplepos=Final.Export1[which(is.na(Final.Export1$SampleDepth)==TRUE & Final.Export1$SamplePosition=="UNKNOWN"),]
write.table(Final.Export1,file="DataImport_MN_MPCA_SECCHI.csv",row.names=FALSE,sep=",")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MN data/MPCA_chemistry/CSILimnoData/DataImport_MN_MPCA_SECCHI/DataImport_MN_MPCA_SECCHI.RData")

