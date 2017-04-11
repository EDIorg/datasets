setwd("C:/Users/Samuel T. Christel/Dropbox/CSI-LIMNO_DATA/DATA-lake/NJ data/DataImport_NJ_DEP_CHEM")
setwd("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/NJ data/DataImport_NJ_DEP_CHEM")

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
#There are 7 priority variables that need to be exported in the LAGOS format
#These data come from a citizen monitoring program
#Note that DL's are specified for TP, NO3-N, and NH4-N
# The variable ZProfile represents the depth at which a sample was taken- see metadata for specifics on where sampling location was chose on a specific lake & to what depth sample was taken
# Missing Values are represented by "9999"
#replicates are not an issue and no data flags
#############################################################################################################################################################################################
################################## Chl(ug/L)#################################################################################
data = NJ_DEP_CHEM_EF
head(data) #looking at data
names(data) #looking at data
data = data[,c(1:2,8,10,20)] #pulling out data relevant to chl
head(data)
unique(data$Chl..ug.L.)
data = data[which(data$Chl..ug.L.!=9999),] #pulling out null values- no null values
length(data$Chl..ug.L.[which(is.na(data$Chl..ug.L.)==TRUE)]) #no missing values double check
length(data$Chl..ug.L.[which(data$Chl..ug.L.==9999)]) #no missing values check
length(data$Chl..ug.L.[which(data$Chl..ug.L.=="")])
# no replicates or other observations to exclude, ready to populate Lagos Template
####Begin Populating Lagos Template
data.Export = LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$Site.ID
data.Export$LakeName = data$Site.Name
data.Export$SourceVariableName = "Chl (ug/L)"
data.Export$SourceVariableDescription = "Chlorophyll a"
data.Export$SourceFlags = as.character(data.Export$SourceFlags) #converting source flags to character
data.Export$SourceFlags = NA #no source flags here
data.Export$LagosVariableID =9
data.Export$LagosVariableName="Chlorophyll a"
names(data)
data.Export$Value = data[,5] #export chla values
data.Export$CensorCode = as.character(data.Export$CensorCode)
data.Export$CensorCode = "NC"
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L"
data.Export$SampleType="INTEGRATED"
data.Export$SampleDepth= data$Zprofile
unique(data.Export$SampleDepth)
length(data.Export$SampleDepth[which(data.Export$SampleDepth=="")])
data.Export$SamplePosition= as.character(data.Export$SamplePosition) #character
data.Export$SamplePosition= "EPI"
unique(data.Export$SamplePosition) #check to see that the proper designations were exported
data.Export$BasinType="UNKNOWN" #not specified in data
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "EPA_445.0"
data.Export$LabMethodInfo= as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo= NA 
data.Export$DetectionLimit= .05
data.Export$Comments = NA 
data.Export$Subprogram= NA #not specified
Chl.Final = data.Export
rm(data)
rm(data.Export)

##################################   NH4N (mg/L)   #########################################################################################################################################################
data = NJ_DEP_CHEM_EF
head(data) #looking at data
names(data) #looking at data
unique(data$NH4N..mg.L.)
#there are observations to censor here 
#note that there are also NA values
typeof(data$NH4N..mg.L.)#these data are integer convert to numeric before unit conversions
data = data[,c(1:2,8,10,19)] #pulling out data relevant to NH4N
head(data)
length(data$NH4N..mg.L.[which(is.na(data$NH4N..mg.L.)==TRUE)])
data = data[which(is.na(data[,5])==FALSE),] #one missing value remove 
data = data[which(data$NH4N..mg.L.!=9999),] #no null values
length(data$NH4N..mg.L.[which(data$NH4N..mg.L.=="")])
length(data$Chl..ug.L.[which(data$Chl..ug.L.==9999)]) #no missing values check
# no replicates or other observations to exclude, ready to populate Lagos Template
####Begin Populating Lagos Template
data.Export = LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$Site.ID
data.Export$LakeName = data$Site.Name
data.Export$SourceVariableName = "NH4N (mg/L)"
data.Export$SourceVariableDescription = "Ammonium-N"
data.Export$SourceFlags = as.character(data.Export$SourceFlags) #converting source flags to character
data.Export$SourceFlags = NA #no source flags here
data.Export$LagosVariableID = 19
data.Export$LagosVariableName="Nitrogen, NH4 "
#censor observations
unique(data$NH4N..mg.L.)
length(grep("<",data$NH4N..mg.L.,ignore.case=TRUE))
length(grep(">",data$NH4N..mg.L.,ignore.case=TRUE))
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[grep("<",data$NH4N..mg.L.,ignore.case=TRUE)]="LT"
unique(data.Export$CensorCode)
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]="NC"
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure correct number
#overwrite censors
data$NH4N..mg.L.[which(data$NH4N..mg.L.=="<0.004")]=0.004
data$NH4N..mg.L.[which(data$NH4N..mg.L.=="<0.015")]=0.015
#now convert nh4 to character then to numeric then convert to ug/L
unique(data$NH4N..mg.L.)
data$NH4N..mg.L.=as.character(data$NH4N..mg.L.)
data$NH4N..mg.L.= as.numeric(data$NH4N..mg.L.) #convert to numeric
data.Export$Value = (data$NH4N..mg.L.)*1000 #export nh4 values and multiply by 1000 because it is in mg/L but preferred units are ug/L
unique(data.Export$Value)
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L"
data.Export$SampleType="GRAB"
data.Export$SampleDepth= data$Zprofile
unique(data.Export$SampleDepth)
length(data.Export$SampleDepth[which(data.Export$SampleDepth=="")])
data.Export$SamplePosition= as.character(data.Export$SamplePosition) #character
data.Export$SamplePosition= "EPI"
unique(data.Export$SamplePosition) #check to see that the proper designations were exported
data.Export$BasinType="UNKNOWN" #not specified in data
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA 
data.Export$LabMethodInfo= as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo= NA 
data.Export$DetectionLimit= 15 #metadata gives .015 mg/L but preferred units are ug/L so multiply by 1000
data.Export$Comments = NA 
data.Export$Subprogram= NA #not specified
NH4N.Final = data.Export
rm(data)
rm(data.Export)

##################################   NO3N (mg/L)   #########################################################################################################################################################
data = NJ_DEP_CHEM_EF
head(data) #looking at data
names(data) #looking at data
unique(data$NO3N..mg.L.)
#note there are observations that need to be censored
typeof(data$NO3N..mg.L.) #these data are stored as integer, convert to numeric
data = data[,c(1:2,8,10,18)] #pulling out data relevant to NH4N
head(data)
length(data$NO3N..mg.L.[which(is.na(data$NO3N..mg.L.)==TRUE)])
data = data[which(is.na(data[,5])==FALSE),] #no missing values
data = data[which(data$NO3N..mg.L.!=9999),] #no null values
length(data$Chl..ug.L.[which(data$Chl..ug.L.=="")]) #no missing values check
length(data$Chl..ug.L.[which(data$Chl..ug.L.==9999)])
# no replicates or other observations to exclude, ready to populate Lagos Template
####Begin Populating Lagos Template
data.Export = LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$Site.ID
data.Export$LakeName = data$Site.Name
data.Export$SourceVariableName = "NO3N (mg/L)"
data.Export$SourceVariableDescription = "Nitrite and Nitrate-Nitrogen"
data.Export$SourceFlags = as.character(data.Export$SourceFlags) #converting source flags to character
data.Export$SourceFlags = NA #no source flags here
data.Export$LagosVariableID = 18
data.Export$LagosVariableName="Nitrogen, nitrite (NO2) + nitrate (NO3)"
#censor observations
unique(data$NO3N..mg.L.)
length(grep("<",data$NO3N..mg.L.,ignore.case=TRUE))
length(grep(">",data$NO3N..mg.L.,ignore.case=TRUE))
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[grep("<",data$NO3N..mg.L.,ignore.case=TRUE)]="LT"
unique(data.Export$CensorCode)
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]="NC"
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure correct number
#overwrite censors
data$NO3N..mg.L.[which(data$NO3N..mg.L.=="<0.006")]=0.006
#now convert from integer to character to numeric, and then convert to ug/L
unique(data$NO3N..mg.L.)
data$NO3N..mg.L.=as.character(data$NO3N..mg.L.)
data$NO3N..mg.L.= as.numeric(data$NO3N..mg.L.) #convert to numeric
data.Export$Value = (data$NO3N..mg.L.)*1000 #export no3 values and multiply by 1000 because it is in mg/L but preferred units are ug/L
unique(data.Export$Value)
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L"
data.Export$SampleType="GRAB"
data.Export$SampleDepth= data$Zprofile
unique(data.Export$SampleDepth)
length(data.Export$SampleDepth[which(data.Export$SampleDepth=="")])
data.Export$SamplePosition= as.character(data.Export$SamplePosition) #character
data.Export$SamplePosition= "EPI"
unique(data.Export$SamplePosition) #check to see that the proper designations were exported
data.Export$BasinType="UNKNOWN" #not specified in data
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA 
data.Export$LabMethodInfo= as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo= NA 
data.Export$DetectionLimit= 6 #metadata gives .006 mg/L but preferred units are ug/L so multiply by 1000
data.Export$Comments = NA 
data.Export$Subprogram= NA #not specified
NO3N.Final = data.Export
rm(data)
rm(data.Export)

##################################   TKN (mg/L)   #########################################################################################################################################################
data = NJ_DEP_CHEM_EF
head(data) #looking at data
names(data) #looking at data
unique(data$TKN..mg.L.)
typeof(data$TKN..mg.L.)
data = data[,c(1:2,8,10,17)] #pulling out data relevant to NH4N
head(data)
length(data$TKN..mg.L.[which(is.na(data$TKN..mg.L.)==TRUE)])
data = data[which(is.na(data[,5])==FALSE),] #no missing values
length(data$TKN..mg.L.[which(data$TKN..mg.L.==9999)])
data = data[which(data$TKN..mg.L.!=9999),] #there are 2 null value
length(data$TKN..mg.L.[which(data$TKN..mg.L.==9999)]) #no missing values check
# no replicates or other observations to exclude, ready to populate Lagos Template
####Begin Populating Lagos Template
data.Export = LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$Site.ID
data.Export$LakeName = data$Site.Name
data.Export$SourceVariableName = "TKN (mg/L)"
data.Export$SourceVariableDescription = "Total Kjeldahl Nitrogen"
data.Export$SourceFlags = as.character(data.Export$SourceFlags) #converting source flags to character
data.Export$SourceFlags = NA #no source flags here
data.Export$LagosVariableID = 16
data.Export$LagosVariableName="Nitrogen, total Kjeldahl"
data$TKN..mg.L.= as.numeric(data$TKN..mg.L.) #convert to numeric
data.Export$Value = (data$TKN..mg.L.)*1000 #export tkn values and multiply by 1000 because it is in mg/L but preferred units are ug/L
unique(data.Export$Value)
data.Export$CensorCode = as.character(data.Export$CensorCode)
data.Export$CensorCode = "NC"
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L"
data.Export$SampleType="GRAB"
data.Export$SampleDepth= data$Zprofile
unique(data.Export$SampleDepth)
length(data.Export$SampleDepth[which(data.Export$SampleDepth=="")])
data.Export$SamplePosition= as.character(data.Export$SamplePosition) #character
data.Export$SamplePosition= "EPI"
unique(data.Export$SamplePosition) #check to see that the proper designations were exported
data.Export$BasinType="UNKNOWN" #not specified in data
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA 
data.Export$LabMethodInfo= as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo= NA 
data.Export$DetectionLimit= "100" #metadata gives .10 mg/L but preferred units are ug/L so multiply by 1000
data.Export$Comments = NA 
data.Export$Subprogram= NA #not specified
TKN.Final = data.Export
rm(data)
rm(data.Export)

##################################   TP  (mg/L)-###units for this set are in ug/l (must extract those observations with ug/l even though the variable name is TP (mg/l); observations from 2005 are ug/l per metadata)   #########################################################################################################################################################
data = NJ_DEP_CHEM_EF
head(data) #looking at data
names(data) #looking at data
data = data[,c(1:2,8,10,16)] #pulling out data relevant to NH4N
names(data)
typeof(data$Date)
data$Date=as.character(data$Date)
length(data$TP..mg.L.[which(data$Date<"2005-12-31")])
data = data[which(data$Date < "2005-12-31"),]
unique(data$TP..mg.L.)
#extract only observations (78 total) for 2005 as these are ug/L units, even though the variable name is "TP mg/L" prior to 2006 units are ug/L!!
# no replicates or other observations to exclude, ready to populate Lagos Template
####Begin Populating Lagos Template
data.Export = LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$Site.ID
data.Export$LakeName = data$Site.Name
data.Export$SourceVariableName = "TP (mg/L)" #even though these are ug/l
data.Export$SourceVariableDescription = "Total phosphorus"
data.Export$SourceFlags = as.character(data.Export$SourceFlags) #converting source flags to character
data.Export$SourceFlags = NA #no source flags here
data.Export$LagosVariableID = 27
data.Export$LagosVariableName="Phosphorus, total"
#censor observations
unique(data$TP..mg.L.)
length(grep("<",data$TP..mg.L.,ignore.case=TRUE))
length(grep(">",data$TP..mg.L.,ignore.case=TRUE))
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[grep("<",data$TP..mg.L.,ignore.case=TRUE)]="LT"
unique(data.Export$CensorCode)
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]="NC"
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure correct number
#overwrite censors
unique(data$TP..mg.L.)
data$TP..mg.L.=as.character(data$TP..mg.L.)
data$TP..mg.L.[which(data$TP..mg.L.=="< 38.41")]=38.41
data$TP..mg.L.[which(data$TP..mg.L.=="<38.41")]=38.41
data$TP..mg.L.[which(data$TP..mg.L.=="<10.37")]=10.37
unique(data$TP..mg.L.)
#now convert to numeric and export
data$TP..mg.L.=as.numeric(data$TP..mg.L.)
unique(data$TP..mg.L.)
data.Export$Value = data$TP..mg.L. #export tp as ug/l (no conversion needed ug/l are preferred units)
unique(data.Export$Value)
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L"
data.Export$SampleType="GRAB"
data.Export$SampleDepth= data$Zprofile
unique(data.Export$SampleDepth)
length(data.Export$SampleDepth[which(data.Export$SampleDepth=="")])
data.Export$SamplePosition= as.character(data.Export$SamplePosition) #character
data.Export$SamplePosition= "EPI"
unique(data.Export$SamplePosition) #check to see that the proper designations were exported
data.Export$BasinType="UNKNOWN" #not specified in data
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA 
data.Export$LabMethodInfo= as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo= NA 
data$Date= as.character(data$Date) #necessary for next command
data.Export$DetectionLimit[which(data$Date < "2005-08-31")]= 38.41 #detection limit during summer 2005
data.Export$DetectionLimit[which(data$Date > "2005-08-31")]= 10.37 #detection limit during fall 2005
data.Export$DetectionLimit[which(data$Date > "2005-12-31")]= 9.9  #over write detection limits occuring after 12/31/2005, had to multiply the DL given in the metadata= .099ppm (metadata)*1000 to get into the preferred units of ug/l
data.Export$Comments = NA 
data.Export$Subprogram= NA #not specified
TP1.Final = data.Export
rm(data)
rm(data.Export)

##################################   TP  (mg/L)- must extract TP observations that are mg/L   #########################################################################################################################################################
data=NJ_DEP_CHEM_EF
head(data) #looking at data
names(data) #looking at data
data = data[,c(1:2,8,10,16)] #pulling out data relevant to NH4N
head(data)
names(data)
data$Date=as.character(data$Date)
length(data$TP..mg.L.[which(data$Date>"2005-12-31")])
479+78#adds up to the total, now we want the 479 observations
data = data[which(data$Date > "2005-12-31"),] #extract only observations after 2005, these will be observations with units of mg/l
unique(data$TP..mg.L.)
length(data$TP..mg.L.[which(data$TP..mg.L.=="ND")])
479-63
#FILTER out those ND observations
data=data[which(data$TP..mg.L.!="ND"),]
typeof(data$TP..mg.L.)#convert to numeric before doing conversions
unique(data$TP..mg.L.)
length(data$TP..mg.L.[which(data$TP..mg.L.=="")])
length(data$TP..mg.L.[which(is.na(data$TP..mg.L.)==TRUE)])
####Begin Populating Lagos Template
data.Export = LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$Site.ID
data.Export$LakeName = data$Site.Name
data.Export$SourceVariableName = "TP (mg/L)"
data.Export$SourceVariableDescription = "Total phosphorus"
data.Export$SourceFlags = as.character(data.Export$SourceFlags) #converting source flags to character
data.Export$SourceFlags = NA #no source flags here
data.Export$LagosVariableID = 27
data.Export$LagosVariableName="Phosphorus, total"
unique(data$TP..mg.L.)
typeof(data$TP..mg.L.)
#convert from integer to character to numeric
data$TP..mg.L.=as.character(data$TP..mg.L.)
unique(data$TP..mg.L.)
data$TP..mg.L.=as.numeric(data$TP..mg.L.)
data.Export$Value = (data$TP..mg.L.*1000) #export tp as ug/l must multiply by 1000 since it is currently in mg/l
unique(data.Export$Value)
data.Export$CensorCode = as.character(data.Export$CensorCode)
data.Export$CensorCode = "NC"
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L"
data.Export$SampleType="GRAB"
data.Export$SampleDepth= data$Zprofile
unique(data.Export$SampleDepth)
length(data.Export$SampleDepth[which(data.Export$SampleDepth=="")])
data.Export$SamplePosition= as.character(data.Export$SamplePosition) #character
data.Export$SamplePosition= "EPI"
unique(data.Export$SamplePosition) #check to see that the proper designations were exported
data.Export$BasinType="UNKNOWN" #not specified in data
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA 
data.Export$LabMethodInfo= as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo= NA 
data$Date= as.character(data$Date) #necessary for next command
data.Export$DetectionLimit[which(data$Date < "2005-08-31")]= 38.41 #detection limit during summer 2005
data.Export$DetectionLimit[which(data$Date > "2005-08-31")]= 10.37 #detection limit during fall 2005
data.Export$DetectionLimit[which(data$Date > "2005-12-31")]= 9.9  #over write detection limits occuring after 12/31/2005, had to multiply the DL given in the metadata= .099ppm (metadata)*1000 to get into the preferred units of ug/l
unique(data.Export$DetectionLimit)
#all DL's should = 9.9 = TRUE
data.Export$Comments = NA 
data.Export$Subprogram= NA #not specified
TP2.Final = data.Export
rm(data)
rm(data.Export)

################################## Secchi..m.#################################################################################
data = NJ_DEP_CHEM_EF
head(data) #looking at data
names(data) #looking at data
data = data[,c(1:2,8,10,11)] #pulling out data relevant to chl
head(data)
data = data[which(data$Secchi..m.!=9999),] #pulling out null values- no null values
557-548 #there were 9 missing values per command above
typeof(data$Secchi..m.)
unique(data$Secchi..m.)
length(data$Secchi..m.[which(data$Secchi..m.=="na")])
#filter that out
data=data[which(data$Secchi..m.!="na"),]
length(data$Secchi..m.[which(data$Secchi..m.=="")])
# no replicates or other observations to exclude, ready to populate Lagos Template
####Begin Populating Lagos Template
data.Export = LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$Site.ID
data.Export$LakeName = data$Site.Name
data.Export$SourceVariableName = "Secchi (m)"
data.Export$SourceVariableDescription = "Secchi disk depth"
data.Export$SourceFlags = as.character(data.Export$SourceFlags) #converting source flags to character
data.Export$SourceFlags = NA #no source flags here
data.Export$LagosVariableID = 30
data.Export$LagosVariableName="Secchi"
typeof(data$Secchi..m.)
#convert from integer to character to numeric,then export
data$Secchi..m.=as.character(data$Secchi..m.)
unique(data$Secchi..m.)
data$Secchi..m.=as.numeric(data$Secchi..m.)
data.Export$Value = data$Secchi..m. #export secchi values
unique(data.Export$Value)
data.Export$CensorCode = as.character(data.Export$CensorCode)
data.Export$CensorCode = "NC"
data.Export$Date = data$Date #date already in correct format
data.Export$Units="m"
data.Export$SampleType="INTEGRATED"
data.Export$SampleDepth= NA 
data.Export$SamplePosition= as.character(data.Export$SamplePosition) #character
data.Export$SamplePosition= "SPECIFIED"
unique(data.Export$SamplePosition) #check to see that the proper designations were exported
data.Export$BasinType="UNKNOWN" #not specified in data
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA 
data.Export$LabMethodInfo= as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo= NA 
data.Export$DetectionLimit= NA
data.Export$Comments = NA 
data.Export$Subprogram= NA #not specified
Secchi.Final = data.Export
rm(data)
rm(data.Export)

######final processing #############################################################################################################################
Final.Export = rbind(Chl.Final,NH4N.Final,NO3N.Final,Secchi.Final,TKN.Final,TP1.Final,TP2.Final)
write.table(Final.Export,file="DataImport_NJ_DEP_CHEM.csv",row.names=FALSE,sep=",")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/NJ data/DataImport_NJ_DEP_CHEM/DataImport_NJ_DEP_CHEM.RData")