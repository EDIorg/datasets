#SET PATH TO FILES
setwd("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/WI data/LTER (finished)/DataImport_WI_TROUT_CHL")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/WI data/LTER (finished)/DataImport_WI_TROUT_CHL/DataImport_WI_TROUT_CHL.RData")

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


################################## WI_TROUT_CHL #####################################################################################################
#CHLA for the seven northern lakes
#########################################################################################################################################################
###############################  chlor     ##############################################################################################################
data=chl_trout
names(data)
#pull out columns of interest
data=data[,c(1,4:7,9)]
head(data)
unique(data$chlor)#look at problematic values-special characters etc...
length(data$chlor[which(is.na(data$chlor)==TRUE)])#remove 2 na values
data=data[which(is.na(data$chlor)==FALSE),]
unique(data$rep)
length(data$rep[which(data$rep=="1")])
#only keep obs. with a rep = 1, should be left with 23650
data=data[which(data$rep==1),]
#done filtering

#### Begin Populating Lagos Template ###
data.Export = LAGOS_Template #creates LAGOS export template
data.Export[1:nrow(data),]=NA #specifies how to fill template
data$lakeid = as.character(data$lakeid) #need to work on getting the full lake name from lakeid in the dataset
unique(data$lakeid) #reveals number of lakes == 11 NTL-LTER study lakes
#now convert to full lakename and export to LAGOS 
data.Export$LakeName=as.character(data.Export$LakeName) #convert to character so it can be manipulated
data.Export$LakeName[which(data$lakeid=="TR")]="TROUT LAKE"
data.Export$LakeName[which(data$lakeid=="TB")]="TROUT BOG"
data.Export$LakeName[which(data$lakeid=="AL")]="ALLEQUASH LAKE"
data.Export$LakeName[which(data$lakeid=="SP")]="SPARKLING LAKE"
data.Export$LakeName[which(data$lakeid=="BM")]="BIG MUSKELLUNGE LAKE"
data.Export$LakeName[which(data$lakeid=="CB")]="CRYSTAL BOG"
data.Export$LakeName[which(data$lakeid=="CR")]="CRYSTAL LAKE"
#now populate LAGOS LakeID--use WDNR (Wisconsin DNR) WBIC (WBIC=waterbody identification code) for LakeID
data.Export$LakeID=as.character(data.Export$LakeID)
data.Export$LakeID[which(data$lakeid=="TR")]="2331600" #note that it is the south basin of trout
data.Export$LakeID[which(data$lakeid=="TB")]="2014700"
data.Export$LakeID[which(data$lakeid=="SP")]="1881900"
data.Export$LakeID[which(data$lakeid=="BM")]="1835300"
data.Export$LakeID[which(data$lakeid=="AL")]="2332400" ##note that it is the north basin of allequash
data.Export$LakeID[which(data$lakeid=="CB")]="2017500"
data.Export$LakeID[which(data$lakeid=="CR")]="1842400"
#fill in source variable name according to major.nutrients
data.Export$SourceVariableName = "chlor"
data.Export$SourceVariableDescription = "Chlorophyll a concentration" #be sure to check metadata table to make sure it matches
##need to populate data flags and make a note in the processing log
head(data)
#assign source flags
unique(data$flagchlor)
data.Export$SourceFlags = data$flagchlor
unique(data.Export$SourceFlags)
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
unique(data.Export$SourceFlags) 
data.Export$SourceFlags[which(data.Export$SourceFlags=="")] = NA
unique(data.Export$SourceFlags)
#continue
data.Export$LagosVariableID= 9 
data.Export$LagosVariableName="Chlorophyll a"
names(data)
data.Export$Value = data[,5] #export obs, already in ug/L the preff. units
data.Export$DetectionLimit = NA #per meta
##censor code populating- determine if detection limit (dl exists) then determine if observation is greater than (GL) or less than (LT) the detection limit. Assign "NC" if there is no censor code
data.Export$CensorCode = as.character(data.Export$CensorCode)
data.Export$CensorCode= "NC"
data.Export$Units="ug/L" #preferred units per metadata table
data.Export$Date = data$sampledate #export sample date, already in correct format
data.Export$SamplePosition = as.character(data.Export$SamplePosition) #convert sample position to character, so it can be manipulated
data.Export$SamplePosition= "SPECIFIED" #a depth is specified for every observation, researcher can determine epi, meta, hypo
unique(data$depth)# lots of unique depths, correct negative depths
data.Export$SampleDepth = data$depth
unique(data.Export$SampleDepth) #check to make sure negative depths gone
data.Export$SampleType = as.character(data.Export$SampleType)
data.Export$SampleType= "GRAB" #all observations are grab samples (water pumped from a specific depth: point)
data.Export$BasinType = as.character(data.Export$BasinType)
data.Export$BasinType= "PRIMARY"
data.Export$MethodInfo=as.character(data.Export$MethodInfo)
data.Export$MethodInfo=NA
data.Export$LabMethodName=as.character(data.Export$LabMethodName)
data.Export$LabMethodName=NA 
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo= NA
data.Export$Comments=as.character(data.Export$Comments)
unique(data[,6])#export flag defintions  to comments field
data.Export$Comments[which(data[,6]=="A")]="A=Sample suspect"
data.Export$Comments[which(data[,6]=="B")]="B=Standard curve/reduction suspect"
data.Export$Comments[which(data[,6]=="C")]="C=No sample taken"
data.Export$Comments[which(data[,6]=="D")]="D=Sample lost"
data.Export$Comments[which(data[,6]=="E")]="E=Average of duplicate analyses"
data.Export$Comments[which(data[,6]=="F")]="F=Duplicate analyses in error"
data.Export$Comments[which(data[,6]=="G")]="G=Analysed late"
data.Export$Comments[which(data[,6]=="H")]="H=Outside of standard range"
data.Export$Comments[which(data[,6]=="I")]="I=Outside of data entry constraints"
data.Export$Comments[which(data[,6]=="J")]="J=Non standard routine followed"
data.Export$Comments[which(data[,6]=="K")]="K=Data suspect"
data.Export$Comments[which(data[,6]=="L")]="L=Data point and blind value differ by more than 15%"
data.Export$Comments[which(data[,6]=="M")]="M=More than t"
data.Export$Comments[which(data[,6]=="N")]="N=Sample retested"
data.Export$Comments[which(data[,6]=="O")]="O=Value suspect but total pigment(CHL + PHAEO) value accurate"
data.Export$Comments[which(data[,6]=="P")]="P=TPM uncorrected for humidity change between filter weighing"
data.Export$Comments[which(data[,6]=="Q")]="Q=Quality control comments on SLOH lab sheet"
data.Export$Comments[which(data[,6]=="R")]="R=Value between LOD and LOQ"
data.Export$Comments[which(data[,6]=="S")]="S=Value below detection limit; set to zero"
data.Export$Comments[which(data[,6]=="T")]="T=Sample contaminated; data not reported"
data.Export$Comments[which(data[,6]=="U")]="U=Equipment malfunction produced bad value; value set to missing"
data.Export$Comments[which(data[,6]=="V")]="V=Could not be computed; set to missing"
data.Export$Comments[which(data[,6]=="W")]="W=negative light value; set to zero"
chla.Final = data.Export
rm(data)
rm(data.Export)

###################################### final export ########################################################################################
Final.Export = rbind(chla.Final)
write.table(Final.Export,file="DataImport_WI_TROUT_CHL.csv",row.names=FALSE,sep=",")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/WI data/LTER (finished)/DataImport_WI_TROUT_CHL/DataImport_WI_TROUT_CHL.RData")