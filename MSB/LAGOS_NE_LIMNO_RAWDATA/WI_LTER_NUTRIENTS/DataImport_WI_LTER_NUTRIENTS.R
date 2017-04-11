#SET PATH TO FILES
setwd("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/WI data/LTER (finished)/DataImport_WI_LTER_NUTRIENTS")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/WI data/LTER (finished)/DataImport_WI_LTER_NUTRIENTS/DataImport_WI_LTER_NUTRIENTS.RData")


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


################################## MAJOR NUTRIENTS #####################################################################################################
###FROM THE LTER MAJOR NUTRIENTS DATASET ONLY DOC,  NH4_SLOH, NH4, NO3NO2_SLOH, NO3NO2, TOTNUF
###KJDL_N_SLOH, DRP_SLOH, TOTPUF_SLOH, TOTPUF, AND TOTPF ARE PRIORITY!! AS SUCH THESE ANALYSES
###ONLY FOCUSES ON THOSE
##data files fo rnutrients are "major nutrients1" and "major nutrients2" (.csv files)
#########################################################################################################################################################
###############################     DOC     ##############################################################################################################
data=major.nutrients1
data = data[,c(1,4:6,9,17)]
head(data)
#pulling out the columns relevant to doc
head(data) #just looking at the data
data=data[which(is.na(data[,5])==FALSE),]  #remove null (NA) doc observations
#note that a "safer way to acheive the same command as line 38 is "data=data[which(is.na(data$doc)==FALSE),]"
sum(is.na(data[,5])) #double check to confirm they have been removed, confirmed
sum(!is.na(data[,6])) #gives the total number of flags== 12537
unique(data$rep) # Check to see unique levels of replicates, only 1 and 2
data$rep = as.character(data$rep) #data was a factor, convert it to characters
unique(data$rep) #confirm rep is a character class 
#look at how many replicate types there are:
length(which(data$rep==1)) # 95% of observations have only one replicate
#limit data to those with rep=1 (command below)
data = data[which(data$rep==1),]
#### Begin Populating Lagos Template ###
data.Export = LAGOS_Template #creates LAGOS export template
data.Export[1:nrow(data),]=NA #specifies how to fill template
data$lakeid = as.character(data$lakeid) #need to work on getting the full lake name from lakeid in the dataset
unique(data$lakeid) #reveals number of lakes == 11 NTL-LTER study lakes
#now convert to full lakename and export to LAGOS 
data.Export$LakeName=as.character(data.Export$LakeName) #convert to character so it can be manipulated
data.Export$LakeName[which(data$lakeid=="ME")]="LAKE MENDOTA"
data.Export$LakeName[which(data$lakeid=="MO")]="LAKE MONONA"
data.Export$LakeName[which(data$lakeid=="FI")]="FISH LAKE"
data.Export$LakeName[which(data$lakeid=="WI")]="LAKE WINGRA"
data.Export$LakeName[which(data$lakeid=="TR")]="TROUT LAKE"
data.Export$LakeName[which(data$lakeid=="TB")]="TROUT BOG"
data.Export$LakeName[which(data$lakeid=="AL")]="ALLEQUASH LAKE"
data.Export$LakeName[which(data$lakeid=="SP")]="SPARKLING LAKE"
data.Export$LakeName[which(data$lakeid=="BM")]="BIG MUSKELLUNGE LAKE"
data.Export$LakeName[which(data$lakeid=="CB")]="CRYSTAL BOG"
data.Export$LakeName[which(data$lakeid=="CR")]="CRYSTAL LAKE"
#now populate LAGOS LakeID--use WDNR (Wisconsin DNR) WBIC (WBIC=waterbody identification code) for LakeID
data.Export$LakeID=as.character(data.Export$LakeID)
data.Export$LakeID[which(data$lakeid=="ME")]="805400"
data.Export$LakeID[which(data$lakeid=="MO")]="804600"
data.Export$LakeID[which(data$lakeid=="FI")]="985100"
data.Export$LakeID[which(data$lakeid=="WI")]="805000"
data.Export$LakeID[which(data$lakeid=="TR")]="2331600" #note that it is the south basin of trout
data.Export$LakeID[which(data$lakeid=="TB")]="2014700"
data.Export$LakeID[which(data$lakeid=="SP")]="1881900"
data.Export$LakeID[which(data$lakeid=="BM")]="1835300"
data.Export$LakeID[which(data$lakeid=="AL")]="2332400" ##note that it is the north basin of allequash
data.Export$LakeID[which(data$lakeid=="CB")]="2017500"
data.Export$LakeID[which(data$lakeid=="CR")]="1842400"
#fill in source variable name according to major.nutrients
data.Export$SourceVariableName = "doc"
data.Export$SourceVariableDescription = "Dissolved organic carbon" #be sure to check metadata table to make sure it matches
##need to populate data flags and make a note in the processing log
head(data)
data.Export$SourceFlags = data[,6] #doc flags =see eml file (as .xml)
unique(data.Export$SourceFlags)
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
unique(data.Export$SourceFlags) 
data.Export$SourceFlags[which(data.Export$SourceFlags=="")] = NA
unique(data.Export$SourceFlags)
data.Export$LagosVariableID= "6" 
data.Export$LagosVariableName="Carbon, dissolved organic"
data.Export$Value = data[,5] #not sure why NAs are still showing up
data.Export$DetectionLimit = .30
##censor code populating- determine if detection limit (dl exists) then determine if observation is greater than (GL) or less than (LT) the detection limit. Assign "NC" if there is no censor code
data.Export$CensorCode = as.character(data.Export$CensorCode)
data.Export$CensorCode= "NC"
data.Export$Units="mg/L" #preferred units per metadata table
data.Export$Date = data$sampledate #export sample date, already in correct format
data.Export$SamplePosition = as.character(data.Export$SamplePosition) #convert sample position to character, so it can be manipulated
data.Export$SamplePosition= "SPECIFIED" #a depth is specified for every observation, researcher can determine epi, meta, hypo
unique(data$depth)# lots of unique depths, correct negative depths
data.Export$SampleDepth = abs(data$depth) #use absolute value to get rid of negative values
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
data.Export$LabMethodInfo="See NT LTER website - http://lter.limnology.wisc.edu/research/protocols. DOC - from 1985 to 2006 determined by heated persulfate digestion; from 2006 - 2010 determined by Shimadzu TOC-V-csh Total Organic C Analyzer"
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
#remove missing values
unique(data.Export$Value)
#check how many need to be removed
length(data.Export$Value[which(data.Export$Value==-99.99)])
length(data.Export$Value[which(data.Export$Value==-99.00)])
#remove missing values
data.Export=data.Export[which(data.Export$Value!=-99.99),]
data.Export=data.Export[which(data.Export$Value!=-99.00),]
doc.Final = data.Export
rm(data)
rm(data.Export)

###############################     TOC     ##############################################################################################################
data=all_ntl_nutrients
names(data)
names(data)
data = data[,c(1,4:6,14,39)]
head(data)
#pulling out the columns relevant to doc
head(data) #just looking at the data
data=data[which(is.na(data[,5])==FALSE),]  #remove null (NA) doc observations
sum(is.na(data[,5])) #double check to confirm they have been removed, confirmed
sum(!is.na(data[,6])) #gives the total number of flags== 12537
unique(data$rep) # Check to see unique levels of replicates, only 1 and 2
data$rep = as.character(data$rep) #data was a factor, convert it to characters
unique(data$rep) #confirm rep is a character class 
#look at how many replicate types there are:
length(which(data$rep==1)) # 95% of observations have only one replicate
#limit data to those with rep=1 (command below)
data = data[which(data$rep==1),]
#### Begin Populating Lagos Template ###
data.Export = LAGOS_Template #creates LAGOS export template
data.Export[1:nrow(data),]=NA #specifies how to fill template
data$lakeid = as.character(data$lakeid) #need to work on getting the full lake name from lakeid in the dataset
unique(data$lakeid) #reveals number of lakes == 11 NTL-LTER study lakes
#now convert to full lakename and export to LAGOS 
data.Export$LakeName=as.character(data.Export$LakeName) #convert to character so it can be manipulated
data.Export$LakeName[which(data$lakeid=="ME")]="LAKE MENDOTA"
data.Export$LakeName[which(data$lakeid=="MO")]="LAKE MONONA"
data.Export$LakeName[which(data$lakeid=="FI")]="FISH LAKE"
data.Export$LakeName[which(data$lakeid=="WI")]="LAKE WINGRA"
data.Export$LakeName[which(data$lakeid=="TR")]="TROUT LAKE"
data.Export$LakeName[which(data$lakeid=="TB")]="TROUT BOG"
data.Export$LakeName[which(data$lakeid=="AL")]="ALLEQUASH LAKE"
data.Export$LakeName[which(data$lakeid=="SP")]="SPARKLING LAKE"
data.Export$LakeName[which(data$lakeid=="BM")]="BIG MUSKELLUNGE LAKE"
data.Export$LakeName[which(data$lakeid=="CB")]="CRYSTAL BOG"
data.Export$LakeName[which(data$lakeid=="CR")]="CRYSTAL LAKE"
#now populate LAGOS LakeID--use WDNR (Wisconsin DNR) WBIC (WBIC=waterbody identification code) for LakeID
data.Export$LakeID=as.character(data.Export$LakeID)
data.Export$LakeID[which(data$lakeid=="ME")]="805400"
data.Export$LakeID[which(data$lakeid=="MO")]="804600"
data.Export$LakeID[which(data$lakeid=="FI")]="985100"
data.Export$LakeID[which(data$lakeid=="WI")]="805000"
data.Export$LakeID[which(data$lakeid=="TR")]="2331600" #note that it is the south basin of trout
data.Export$LakeID[which(data$lakeid=="TB")]="2014700"
data.Export$LakeID[which(data$lakeid=="SP")]="1881900"
data.Export$LakeID[which(data$lakeid=="BM")]="1835300"
data.Export$LakeID[which(data$lakeid=="AL")]="2332400" ##note that it is the north basin of allequash
data.Export$LakeID[which(data$lakeid=="CB")]="2017500"
data.Export$LakeID[which(data$lakeid=="CR")]="1842400"
#fill in source variable name according to major.nutrients
data.Export$SourceVariableName = "toc"
data.Export$SourceVariableDescription = "Total organic carbon" #be sure to check metadata table to make sure it matches
##need to populate data flags and make a note in the processing log
head(data)
data.Export$SourceFlags = data[,6] #doc flags =see eml file (as .xml)
unique(data.Export$SourceFlags)
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
unique(data.Export$SourceFlags) 
data.Export$SourceFlags[which(data.Export$SourceFlags=="")] = NA
unique(data.Export$SourceFlags)
data.Export$LagosVariableID= 7 
data.Export$LagosVariableName="Carbon, total organic"
data.Export$Value = data[,5] 
data.Export$DetectionLimit = .30
##censor code populating- determine if detection limit (dl exists) then determine if observation is greater than (GL) or less than (LT) the detection limit. Assign "NC" if there is no censor code
data.Export$CensorCode = as.character(data.Export$CensorCode)
data.Export$CensorCode= "NC"
data.Export$Units="mg/L" #preferred units per metadata table
data.Export$Date = data$sampledate #export sample date, already in correct format
data.Export$SamplePosition = as.character(data.Export$SamplePosition) #convert sample position to character, so it can be manipulated
data.Export$SamplePosition= "SPECIFIED" #a depth is specified for every observation, researcher can determine epi, meta, hypo
unique(data$depth)# lots of unique depths, correct negative depths
data.Export$SampleDepth = abs(data$depth) #use absolute value to get rid of negative values
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
data.Export$LabMethodInfo="TOC - from 1986 to 2006 determined by heated persulfate digestion; from 2006 - 2010 determined by Shimadzu TOC-V-csh Total Organic C Analyzer. Organic C is determined by combustion. See NT LTER website - http://lter.limnology.wisc.edu/research/protocols "
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
#remove missing values
unique(data.Export$Value)
#check how many need to be removed
length(data.Export$Value[which(data.Export$Value==-99.99)])
length(data.Export$Value[which(data.Export$Value==-99.00)])
#remove missing values
data.Export=data.Export[which(data.Export$Value!=-99.99),]
data.Export=data.Export[which(data.Export$Value!=-99.00),]
toc.Final = data.Export
rm(data)
rm(data.Export)
###############################     NO3NO2    ##################################
data=major.nutrients1
head(data)
data = data[,c(1,4:6,10,18)] #pulling out the columns relevant to doc
head(data) #just looking at the data)
data=data[which(is.na(data[,5])==FALSE),] #remove null (NA) doc observations
sum(is.na(data[,5])) #double check to confirm they have been removed, confirmed
sum(!is.na(data[,6])) #sums the number of flags
unique(data$rep) # Check to see unique levels of replicates, only 1 and 2
data$rep = as.character(data$rep) #data was a factor, convert it to characters
unique(data$rep) #confirm rep is a character class 
#look at how many replicate types there are:
length(which(data$rep==1)) # 95% of observations have only one replicate
#limit data to those with rep=1 (command below)
data = data[which(data$rep==1),]
#### Begin Populating Lagos Template ###
data.Export = LAGOS_Template #creates LAGOS export template
data.Export[1:nrow(data),]=NA #specifies how to fill template
data$lakeid = as.character(data$lakeid) #need to work on getting the full lake name from lakeid in the dataset
unique(data$lakeid) #reveals number of lakes == 11 NTL-LTER study lakes
#now convert to full lakename and export to LAGOS
data.Export$LakeName=as.character(data.Export$LakeName) #convert to character so it can be manipulated
data.Export$LakeName[which(data$lakeid=="ME")]="LAKE MENDOTA"
data.Export$LakeName[which(data$lakeid=="MO")]="LAKE MONONA"
data.Export$LakeName[which(data$lakeid=="FI")]="FISH LAKE"
data.Export$LakeName[which(data$lakeid=="WI")]="LAKE WINGRA"
data.Export$LakeName[which(data$lakeid=="TR")]="TROUT LAKE"
data.Export$LakeName[which(data$lakeid=="TB")]="TROUT BOG"
data.Export$LakeName[which(data$lakeid=="AL")]="ALLEQUASH LAKE"
data.Export$LakeName[which(data$lakeid=="SP")]="SPARKLING LAKE"
data.Export$LakeName[which(data$lakeid=="BM")]="BIG MUSKELLUNGE LAKE"
data.Export$LakeName[which(data$lakeid=="CB")]="CRYSTAL BOG"
data.Export$LakeName[which(data$lakeid=="CR")]="CRYSTAL LAKE"
#now populate LAGOS LakeID--use WDNR (Wisconsin DNR) WBIC (WBIC=waterbody identification code) for LakeID
data.Export$LakeID=as.character(data.Export$LakeID)
data.Export$LakeID[which(data$lakeid=="ME")]="805400"
data.Export$LakeID[which(data$lakeid=="MO")]="804600"
data.Export$LakeID[which(data$lakeid=="FI")]="985100"
data.Export$LakeID[which(data$lakeid=="WI")]="805000"
data.Export$LakeID[which(data$lakeid=="TR")]="2331600" #note that it is the south basin of trout
data.Export$LakeID[which(data$lakeid=="TB")]="2014700"
data.Export$LakeID[which(data$lakeid=="SP")]="1881900"
data.Export$LakeID[which(data$lakeid=="BM")]="1835300"
data.Export$LakeID[which(data$lakeid=="AL")]="2332400" ##note that it is the north basin of allequash
data.Export$LakeID[which(data$lakeid=="CB")]="2017500"
data.Export$LakeID[which(data$lakeid=="CR")]="1842400"
#fill in source variable name according to major.nutrients
data.Export$SourceVariableName = "no3no2"
data.Export$SourceVariableDescription = "Nitrogen, nitrite + nitrate -N" #be sure to check metadata table to make sure it matches METADATA FILE
##need to populate data flags and make a note in the processing log
data.Export$SourceFlags = data[,6] #doc flags =see eml file (as .xml)
unique(data.Export$SourceFlags)
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
unique(data.Export$SourceFlags) 
data.Export$SourceFlags[which(data.Export$SourceFlags=="")] = NA
data.Export$LagosVariableID= "18" 
data.Export$LagosVariableName="Nitrogen, nitrite (NO2) + nitrate (NO3)" #LOOK at standard lagos variable name on metadata table
data.Export$Value = data[,5]
head(data)
data.Export$DetectionLimit = NA
##censor code populating- determine if detection limit (dl exists) then determine if observation is greater than (GL) or less than (LT) the detection limit. Assign "NC" if there is no censor code
data.Export$CensorCode = as.character(data.Export$CensorCode)
data.Export$CensorCode = "NC" #GT/LT not relevant since all observations are above the DL
data.Export$Units="ug/L" #preferred units per metadata table
data.Export$Date = data$sampledate #export sample date, already in correct format
data.Export$SamplePosition = as.character(data.Export$SamplePosition) #convert sample position to character, so it can be manipulated
data.Export$SamplePosition= "SPECIFIED" #a depth is specified for every observation, researcher can determine epi, meta, hypo
unique(data$depth)# lots of unique depths, correct negative depths
data.Export$SampleDepth = abs(data$depth) #use absolute value to get rid of negative values
unique(data.Export$SampleDepth) #check to make sure negative depths gone
data.Export$SampleType = as.character(data.Export$SampleType)
data.Export$SampleType= "GRAB" #all observations are grab samples (water pumped from a specific depth: point)
data.Export$BasinType = as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY"
data.Export$MethodInfo=as.character(data.Export$MethodInfo)
data.Export$MethodInfo=NA
data.Export$LabMethodName=as.character(data.Export$LabMethodName)
data.Export$LabMethodName=NA 
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="See NT LTER website - http://lter.limnology.wisc.edu/research/protocols"
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
#remove missing values
unique(data.Export$Value)
#check how many need to be removed
length(data.Export$Value[which(data.Export$Value==-99.99)])
length(data.Export$Value[which(data.Export$Value==-99.00)])
#remove missing values
data.Export=data.Export[which(data.Export$Value!=-99.99),]
data.Export=data.Export[which(data.Export$Value!=-99.00),]
no3no2.Final = data.Export
rm(data)
rm(data.Export)

###############################     no2    ##################################
data=all_ntl_nutrients
head(data)
names(data)
data = data[,c(1,4:6,16,41)] #pulling out the columns relevant to doc
head(data) #just looking at the data)
data=data[which(is.na(data[,5])==FALSE),] #remove null (NA) doc observations
sum(is.na(data[,5])) #double check to confirm they have been removed, confirmed
sum(!is.na(data[,6])) #sums the number of flags
unique(data$rep) # Check to see unique levels of replicates, only 1 and 2
data$rep = as.character(data$rep) #data was a factor, convert it to characters
unique(data$rep) #confirm rep is a character class 
#look at how many replicate types there are:
length(which(data$rep==1)) # 95% of observations have only one replicate
#limit data to those with rep=1 (command below)
data = data[which(data$rep==1),]
#### Begin Populating Lagos Template ###
data.Export = LAGOS_Template #creates LAGOS export template
data.Export[1:nrow(data),]=NA #specifies how to fill template
data$lakeid = as.character(data$lakeid) #need to work on getting the full lake name from lakeid in the dataset
unique(data$lakeid) #reveals number of lakes == 11 NTL-LTER study lakes
#now convert to full lakename and export to LAGOS
data.Export$LakeName=as.character(data.Export$LakeName) #convert to character so it can be manipulated
data.Export$LakeName[which(data$lakeid=="ME")]="LAKE MENDOTA"
data.Export$LakeName[which(data$lakeid=="MO")]="LAKE MONONA"
data.Export$LakeName[which(data$lakeid=="FI")]="FISH LAKE"
data.Export$LakeName[which(data$lakeid=="WI")]="LAKE WINGRA"
data.Export$LakeName[which(data$lakeid=="TR")]="TROUT LAKE"
data.Export$LakeName[which(data$lakeid=="TB")]="TROUT BOG"
data.Export$LakeName[which(data$lakeid=="AL")]="ALLEQUASH LAKE"
data.Export$LakeName[which(data$lakeid=="SP")]="SPARKLING LAKE"
data.Export$LakeName[which(data$lakeid=="BM")]="BIG MUSKELLUNGE LAKE"
data.Export$LakeName[which(data$lakeid=="CB")]="CRYSTAL BOG"
data.Export$LakeName[which(data$lakeid=="CR")]="CRYSTAL LAKE"
#now populate LAGOS LakeID--use WDNR (Wisconsin DNR) WBIC (WBIC=waterbody identification code) for LakeID
data.Export$LakeID=as.character(data.Export$LakeID)
data.Export$LakeID[which(data$lakeid=="ME")]="805400"
data.Export$LakeID[which(data$lakeid=="MO")]="804600"
data.Export$LakeID[which(data$lakeid=="FI")]="985100"
data.Export$LakeID[which(data$lakeid=="WI")]="805000"
data.Export$LakeID[which(data$lakeid=="TR")]="2331600" #note that it is the south basin of trout
data.Export$LakeID[which(data$lakeid=="TB")]="2014700"
data.Export$LakeID[which(data$lakeid=="SP")]="1881900"
data.Export$LakeID[which(data$lakeid=="BM")]="1835300"
data.Export$LakeID[which(data$lakeid=="AL")]="2332400" ##note that it is the north basin of allequash
data.Export$LakeID[which(data$lakeid=="CB")]="2017500"
data.Export$LakeID[which(data$lakeid=="CR")]="1842400"
#fill in source variable name according to major.nutrients
data.Export$SourceVariableName = "no2"
data.Export$SourceVariableDescription = "Nitrogen, nitrite" #be sure to check metadata table to make sure it matches METADATA FILE
##need to populate data flags and make a note in the processing log
data.Export$SourceFlags = data[,6] #flags =see eml file (as .xml)
unique(data.Export$SourceFlags)
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
unique(data.Export$SourceFlags) 
data.Export$SourceFlags[which(data.Export$SourceFlags=="")] = NA
data.Export$LagosVariableID= "17" 
data.Export$LagosVariableName="Nitrogen, nitrite (NO2)" #LOOK at standard lagos variable name on metadata table
data.Export$Value = data[,5]
head(data)
data.Export$DetectionLimit = NA
##censor code populating- determine if detection limit (dl exists) then determine if observation is greater than (GL) or less than (LT) the detection limit. Assign "NC" if there is no censor code
data.Export$CensorCode = as.character(data.Export$CensorCode)
data.Export$CensorCode = "NC" #GT/LT not relevant since all observations are above the DL
data.Export$Units="ug/L" #preferred units per metadata table
data.Export$Date = data$sampledate #export sample date, already in correct format
data.Export$SamplePosition = as.character(data.Export$SamplePosition) #convert sample position to character, so it can be manipulated
data.Export$SamplePosition= "SPECIFIED" #a depth is specified for every observation, researcher can determine epi, meta, hypo
unique(data$depth)# lots of unique depths, correct negative depths
data.Export$SampleDepth = abs(data$depth) #use absolute value to get rid of negative values
unique(data.Export$SampleDepth) #check to make sure negative depths gone
data.Export$SampleType = as.character(data.Export$SampleType)
data.Export$SampleType= "GRAB" #all observations are grab samples (water pumped from a specific depth: point)
data.Export$BasinType = as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY"
data.Export$MethodInfo=as.character(data.Export$MethodInfo)
data.Export$MethodInfo=NA
data.Export$LabMethodName=as.character(data.Export$LabMethodName)
data.Export$LabMethodName=NA 
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="See NT LTER website - http://lter.limnology.wisc.edu/research/protocols"
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
#remove missing values
unique(data.Export$Value)
#check how many need to be removed
length(data.Export$Value[which(data.Export$Value==-99.99)])
length(data.Export$Value[which(data.Export$Value==-99.00)])
#remove missing values
data.Export=data.Export[which(data.Export$Value!=-99.99),]
data.Export=data.Export[which(data.Export$Value!=-99.00),]
no2.Final = data.Export
rm(data)
rm(data.Export)

############################ TOTPUF ########################################
data=major.nutrients1
names(data)
data = data[,c(1,4:6,12,20)]
head(data)
#pulling out the columns relevant to doc
head(data) #just looking at the data
data=data[which(is.na(data[,5])==FALSE),]  #remove null (NA) doc observations
#note that a "safer way to acheive the same command as line 38 is "data=data[which(is.na(data$doc)==FALSE),]"
sum(is.na(data[,5])) #double check to confirm they have been removed, confirmed
sum(!is.na(data[,6])) #gives the total number of flags== 12537
unique(data$rep) # Check to see unique levels of replicates, only 1 and 2
data$rep = as.character(data$rep) #data was a factor, convert it to characters
unique(data$rep) #confirm rep is a character class 
#look at how many replicate types there are:
length(which(data$rep==1)) # 95% of observations have only one replicate
#limit data to those with rep=1 (command below)
data = data[which(data$rep==1),]
#### Begin Populating Lagos Template ###
data.Export = LAGOS_Template #creates LAGOS export template
data.Export[1:nrow(data),]=NA #specifies how to fill template
data$lakeid = as.character(data$lakeid) #need to work on getting the full lake name from lakeid in the dataset
unique(data$lakeid) #reveals number of lakes == 11 NTL-LTER study lakes
#now convert to full lakename and export to LAGOS 
data.Export$LakeName=as.character(data.Export$LakeName) #convert to character so it can be manipulated
data.Export$LakeName[which(data$lakeid=="ME")]="LAKE MENDOTA"
data.Export$LakeName[which(data$lakeid=="MO")]="LAKE MONONA"
data.Export$LakeName[which(data$lakeid=="FI")]="FISH LAKE"
data.Export$LakeName[which(data$lakeid=="WI")]="LAKE WINGRA"
data.Export$LakeName[which(data$lakeid=="TR")]="TROUT LAKE"
data.Export$LakeName[which(data$lakeid=="TB")]="TROUT BOG"
data.Export$LakeName[which(data$lakeid=="AL")]="ALLEQUASH LAKE"
data.Export$LakeName[which(data$lakeid=="SP")]="SPARKLING LAKE"
data.Export$LakeName[which(data$lakeid=="BM")]="BIG MUSKELLUNGE LAKE"
data.Export$LakeName[which(data$lakeid=="CB")]="CRYSTAL BOG"
data.Export$LakeName[which(data$lakeid=="CR")]="CRYSTAL LAKE"
#now populate LAGOS LakeID--use WDNR (Wisconsin DNR) WBIC (WBIC=waterbody identification code) for LakeID
data.Export$LakeID=as.character(data.Export$LakeID)
data.Export$LakeID[which(data$lakeid=="ME")]="805400"
data.Export$LakeID[which(data$lakeid=="MO")]="804600"
data.Export$LakeID[which(data$lakeid=="FI")]="985100"
data.Export$LakeID[which(data$lakeid=="WI")]="805000"
data.Export$LakeID[which(data$lakeid=="TR")]="2331600" #note that it is the south basin of trout
data.Export$LakeID[which(data$lakeid=="TB")]="2014700"
data.Export$LakeID[which(data$lakeid=="SP")]="1881900"
data.Export$LakeID[which(data$lakeid=="BM")]="1835300"
data.Export$LakeID[which(data$lakeid=="AL")]="2332400" ##note that it is the north basin of allequash
data.Export$LakeID[which(data$lakeid=="CB")]="2017500"
data.Export$LakeID[which(data$lakeid=="CR")]="1842400"
#fill in source variable name according to major.nutrients
data.Export$SourceVariableName = "totpuf"
data.Export$SourceVariableDescription = "Total P" #be sure to check metadata table to make sure it matches
##need to populate data flags and make a note in the processing log
head(data)
data.Export$SourceFlags = data[,6] #doc flags =see eml file (as .xml)
unique(data.Export$SourceFlags)
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
unique(data.Export$SourceFlags) 
data.Export$SourceFlags[which(data.Export$SourceFlags=="")] = NA
data.Export$LagosVariableID= "27" 
data.Export$LagosVariableName="Phosphorus, total"
data.Export$Value = data[,5] #not sure why NAs are still showing up
data.Export$DetectionLimit = 3
##censor code populating- determine if detection limit (dl exists) then determine if observation is greater than (GL) or less than (LT) the detection limit. Assign "NC" if there is no censor code
data.Export$CensorCode = as.character(data.Export$CensorCode)
data.Export$CensorCode= "NC"
data.Export$Units="ug/L" #preferred units per metadata table
data.Export$Date = data$sampledate #export sample date, already in correct format
data.Export$SamplePosition = as.character(data.Export$SamplePosition) #convert sample position to character, so it can be manipulated
data.Export$SamplePosition= "SPECIFIED" #a depth is specified for every observation, researcher can determine epi, meta, hypo
unique(data$depth)# lots of unique depths, correct negative depths
data.Export$SampleDepth = abs(data$depth) #use absolute value to get rid of negative values
unique(data.Export$SampleDepth) #check to make sure negative depths gone
data.Export$SampleType = as.character(data.Export$SampleType)
data.Export$SampleType= "GRAB" #all observations are grab samples (water pumped from a specific depth: point)
data.Export$BasinType = as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY"
data.Export$MethodInfo=as.character(data.Export$MethodInfo)
data.Export$MethodInfo=NA
data.Export$LabMethodName=as.character(data.Export$LabMethodName)
data.Export$LabMethodName=NA 
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="See NT LTER website - http://lter.limnology.wisc.edu/research/protocols"
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
#remove missing values
unique(data.Export$Value)
#check how many need to be removed
length(data.Export$Value[which(data.Export$Value==-99.99)])
length(data.Export$Value[which(data.Export$Value==-99.00)])
#remove missing values
data.Export=data.Export[which(data.Export$Value!=-99.99),]
data.Export=data.Export[which(data.Export$Value!=-99.00),]
tp.Final = data.Export
rm(data)
rm(data.Export)

############################ totpf ########################################
data=all_ntl_nutrients
names(data)
data = data[,c(1,4:6,20,45)]
head(data)
#pulling out the columns relevant to doc
head(data) #just looking at the data
data=data[which(is.na(data[,5])==FALSE),]  #remove null (NA) doc observations
#note that a "safer way to acheive the same command as line 38 is "data=data[which(is.na(data$doc)==FALSE),]"
sum(is.na(data[,5])) #double check to confirm they have been removed, confirmed
sum(!is.na(data[,6])) #gives the total number of flags== 12537
unique(data$rep) # Check to see unique levels of replicates, only 1 and 2
data$rep = as.character(data$rep) #data was a factor, convert it to characters
unique(data$rep) #confirm rep is a character class 
#look at how many replicate types there are:
length(which(data$rep==1)) # 95% of observations have only one replicate
#limit data to those with rep=1 (command below)
data = data[which(data$rep==1),]
#### Begin Populating Lagos Template ###
data.Export = LAGOS_Template #creates LAGOS export template
data.Export[1:nrow(data),]=NA #specifies how to fill template
data$lakeid = as.character(data$lakeid) #need to work on getting the full lake name from lakeid in the dataset
unique(data$lakeid) #reveals number of lakes == 11 NTL-LTER study lakes
#now convert to full lakename and export to LAGOS 
data.Export$LakeName=as.character(data.Export$LakeName) #convert to character so it can be manipulated
data.Export$LakeName[which(data$lakeid=="ME")]="LAKE MENDOTA"
data.Export$LakeName[which(data$lakeid=="MO")]="LAKE MONONA"
data.Export$LakeName[which(data$lakeid=="FI")]="FISH LAKE"
data.Export$LakeName[which(data$lakeid=="WI")]="LAKE WINGRA"
data.Export$LakeName[which(data$lakeid=="TR")]="TROUT LAKE"
data.Export$LakeName[which(data$lakeid=="TB")]="TROUT BOG"
data.Export$LakeName[which(data$lakeid=="AL")]="ALLEQUASH LAKE"
data.Export$LakeName[which(data$lakeid=="SP")]="SPARKLING LAKE"
data.Export$LakeName[which(data$lakeid=="BM")]="BIG MUSKELLUNGE LAKE"
data.Export$LakeName[which(data$lakeid=="CB")]="CRYSTAL BOG"
data.Export$LakeName[which(data$lakeid=="CR")]="CRYSTAL LAKE"
#now populate LAGOS LakeID--use WDNR (Wisconsin DNR) WBIC (WBIC=waterbody identification code) for LakeID
data.Export$LakeID=as.character(data.Export$LakeID)
data.Export$LakeID[which(data$lakeid=="ME")]="805400"
data.Export$LakeID[which(data$lakeid=="MO")]="804600"
data.Export$LakeID[which(data$lakeid=="FI")]="985100"
data.Export$LakeID[which(data$lakeid=="WI")]="805000"
data.Export$LakeID[which(data$lakeid=="TR")]="2331600" #note that it is the south basin of trout
data.Export$LakeID[which(data$lakeid=="TB")]="2014700"
data.Export$LakeID[which(data$lakeid=="SP")]="1881900"
data.Export$LakeID[which(data$lakeid=="BM")]="1835300"
data.Export$LakeID[which(data$lakeid=="AL")]="2332400" ##note that it is the north basin of allequash
data.Export$LakeID[which(data$lakeid=="CB")]="2017500"
data.Export$LakeID[which(data$lakeid=="CR")]="1842400"
#fill in source variable name according to major.nutrients
data.Export$SourceVariableName = "totpf"
data.Export$SourceVariableDescription = "Total P filtered" #be sure to check metadata table to make sure it matches
##need to populate data flags and make a note in the processing log
head(data)
data.Export$SourceFlags = data[,6] #flags =see eml file (as .xml)
unique(data.Export$SourceFlags)
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
unique(data.Export$SourceFlags) 
data.Export$SourceFlags[which(data.Export$SourceFlags=="")] = NA
data.Export$LagosVariableID= 28
data.Export$LagosVariableName="Phosphorus, total dissolved"
data.Export$Value = data[,5] #not sure why NAs are still showing up
data.Export$DetectionLimit = NA
##censor code populating- determine if detection limit (dl exists) then determine if observation is greater than (GL) or less than (LT) the detection limit. Assign "NC" if there is no censor code
data.Export$CensorCode = as.character(data.Export$CensorCode)
data.Export$CensorCode= "NC"
data.Export$Units="ug/L" #preferred units per metadata table
data.Export$Date = data$sampledate #export sample date, already in correct format
data.Export$SamplePosition = as.character(data.Export$SamplePosition) #convert sample position to character, so it can be manipulated
data.Export$SamplePosition= "SPECIFIED" #a depth is specified for every observation, researcher can determine epi, meta, hypo
unique(data$depth)# lots of unique depths, correct negative depths
data.Export$SampleDepth = abs(data$depth) #use absolute value to get rid of negative values
unique(data.Export$SampleDepth) #check to make sure negative depths gone
data.Export$SampleType = as.character(data.Export$SampleType)
data.Export$SampleType= "GRAB" #all observations are grab samples (water pumped from a specific depth: point)
data.Export$BasinType = as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY"
data.Export$MethodInfo=as.character(data.Export$MethodInfo)
data.Export$MethodInfo=NA
data.Export$LabMethodName=as.character(data.Export$LabMethodName)
data.Export$LabMethodName=NA 
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="See NT LTER website - http://lter.limnology.wisc.edu/research/protocols"
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
#remove missing values
unique(data.Export$Value)
#check how many need to be removed
length(data.Export$Value[which(data.Export$Value==-99.99)])
length(data.Export$Value[which(data.Export$Value==-99.00)])
#remove missing values
data.Export=data.Export[which(data.Export$Value!=-99.99),]
data.Export=data.Export[which(data.Export$Value!=-99.00),]
tdp.Final = data.Export
rm(data)
rm(data.Export)

############################ TOTNUF ########################################
data=major.nutrients1
names(data)
data = data[,c(1,4:6,11,19)]
head(data)
#pulling out the columns relevant to totnuf
head(data) #just looking at the data
data=data[which(is.na(data[,5])==FALSE),]  #remove null (NA) totnuf observations
#note that a "safer way to acheive the same command as line 38 is "data=data[which(is.na(data$doc)==FALSE),]"
sum(is.na(data[,5])) #double check to confirm they have been removed, confirmed
sum(!is.na(data[,6])) #gives the total number of flags== 10919
unique(data$rep) # Check to see unique levels of replicates, only 1 and 2
data$rep = as.character(data$rep) #data was a factor, convert it to characters
unique(data$rep) #confirm rep is a character class 
#look at how many replicate types there are:
length(which(data$rep==1)) # 95% of observations have only one replicate
#limit data to those with rep=1 (command below)
data = data[which(data$rep==1),]
#### Begin Populating Lagos Template ###
data.Export = LAGOS_Template #creates LAGOS export template
data.Export[1:nrow(data),]=NA #specifies how to fill template
data$lakeid = as.character(data$lakeid) #need to work on getting the full lake name from lakeid in the dataset
unique(data$lakeid)#reveals number of lakes == 11 NTL-LTER study lakes
#now convert to full lakename and export to LAGOS 
data.Export$LakeName=as.character(data.Export$LakeName) #convert to character so it can be manipulated
data.Export$LakeName[which(data$lakeid=="ME")]="LAKE MENDOTA"
data.Export$LakeName[which(data$lakeid=="MO")]="LAKE MONONA"
data.Export$LakeName[which(data$lakeid=="FI")]="FISH LAKE"
data.Export$LakeName[which(data$lakeid=="WI")]="LAKE WINGRA"
data.Export$LakeName[which(data$lakeid=="TR")]="TROUT LAKE"
data.Export$LakeName[which(data$lakeid=="TB")]="TROUT BOG"
data.Export$LakeName[which(data$lakeid=="AL")]="ALLEQUASH LAKE"
data.Export$LakeName[which(data$lakeid=="SP")]="SPARKLING LAKE"
data.Export$LakeName[which(data$lakeid=="BM")]="BIG MUSKELLUNGE LAKE"
data.Export$LakeName[which(data$lakeid=="CB")]="CRYSTAL BOG"
data.Export$LakeName[which(data$lakeid=="CR")]="CRYSTAL LAKE"
#now populate LAGOS LakeID--use WDNR (Wisconsin DNR) WBIC (WBIC=waterbody identification code) for LakeID
data.Export$LakeID=as.character(data.Export$LakeID)
data.Export$LakeID[which(data$lakeid=="ME")]="805400"
data.Export$LakeID[which(data$lakeid=="MO")]="804600"
data.Export$LakeID[which(data$lakeid=="FI")]="985100"
data.Export$LakeID[which(data$lakeid=="WI")]="805000"
data.Export$LakeID[which(data$lakeid=="TR")]="2331600" #note that it is the south basin of trout
data.Export$LakeID[which(data$lakeid=="TB")]="2014700"
data.Export$LakeID[which(data$lakeid=="SP")]="1881900"
data.Export$LakeID[which(data$lakeid=="BM")]="1835300"
data.Export$LakeID[which(data$lakeid=="AL")]="2332400" ##note that it is the north basin of allequash
data.Export$LakeID[which(data$lakeid=="CB")]="2017500"
data.Export$LakeID[which(data$lakeid=="CR")]="1842400"
#fill in source variable name according to major.nutrients
data.Export$SourceVariableName = "totnuf"
data.Export$SourceVariableDescription = "Total Nitrogen" #be sure to check metadata table to make sure it matches
##need to populate data flags and make a note in the processing log
head(data)
data.Export$SourceFlags = data[,6] #totnuf flags =see eml file (as .xml)
unique(data.Export$SourceFlags)
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
unique(data.Export$SourceFlags) 
data.Export$SourceFlags[which(data.Export$SourceFlags=="")] = NA
data.Export$LagosVariableID= "21" 
data.Export$LagosVariableName="Nitrogen, total"
data.Export$Value = data[,5] 
data.Export$DetectionLimit = 21
data.Export$CensorCode = as.character(data.Export$CensorCode)
data.Export$CensorCode= "NC" #no censor code
data.Export$Units="ug/L" #preferred units per metadata table
data.Export$Date = data$sampledate #export sample date, already in correct format
data.Export$SamplePosition = as.character(data.Export$SamplePosition) #convert sample position to character, so it can be manipulated
data.Export$SamplePosition= "SPECIFIED" #a depth is specified for every observation, researcher can determine epi, meta, hypo
unique(data$depth)# lots of unique depths
data.Export$SampleDepth=data$depth
data.Export$SampleType = as.character(data.Export$SampleType)
data.Export$SampleType= "GRAB" #all observations are grab samples (water pumped from a specific depth: point)
data.Export$BasinType = as.character(data.Export$BasinType)
data.Export$BasinType= "PRIMARY"
data.Export$MethodInfo=as.character(data.Export$MethodInfo)
data.Export$MethodInfo=NA
data.Export$LabMethodName=as.character(data.Export$LabMethodName)
data.Export$LabMethodName=NA 
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="See NT LTER website - http://lter.limnology.wisc.edu/research/protocols"
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
#remove missing values
unique(data.Export$Value)
#check how many need to be removed
length(data.Export$Value[which(data.Export$Value==-99.99)])
length(data.Export$Value[which(data.Export$Value==-99.00)])
#remove missing values
data.Export=data.Export[which(data.Export$Value!=-99.99),]
data.Export=data.Export[which(data.Export$Value!=-99.00),]
tn.Final = data.Export
rm(data)
rm(data.Export)

############################  totnf ########################################
data=all_ntl_nutrients
names(data)
data = data[,c(1,4:6,18,43)]
head(data)
#pulling out the columns relevant to totnuf
head(data) #just looking at the data
data=data[which(is.na(data[,5])==FALSE),]  #remove null (NA) totnuf observations
#note that a "safer way to acheive the same command as line 38 is "data=data[which(is.na(data$doc)==FALSE),]"
sum(is.na(data[,5])) #double check to confirm they have been removed, confirmed
sum(!is.na(data[,6])) #gives the total number of flags== 10919
unique(data$rep) # Check to see unique levels of replicates, only 1 and 2
data$rep = as.character(data$rep) #data was a factor, convert it to characters
unique(data$rep) #confirm rep is a character class 
#look at how many replicate types there are:
length(which(data$rep==1)) # 95% of observations have only one replicate
#limit data to those with rep=1 (command below)
data = data[which(data$rep==1),]
#### Begin Populating Lagos Template ###
data.Export = LAGOS_Template #creates LAGOS export template
data.Export[1:nrow(data),]=NA #specifies how to fill template
data$lakeid = as.character(data$lakeid) #need to work on getting the full lake name from lakeid in the dataset
unique(data$lakeid)#reveals number of lakes == 11 NTL-LTER study lakes
#now convert to full lakename and export to LAGOS 
data.Export$LakeName=as.character(data.Export$LakeName) #convert to character so it can be manipulated
data.Export$LakeName[which(data$lakeid=="ME")]="LAKE MENDOTA"
data.Export$LakeName[which(data$lakeid=="MO")]="LAKE MONONA"
data.Export$LakeName[which(data$lakeid=="FI")]="FISH LAKE"
data.Export$LakeName[which(data$lakeid=="WI")]="LAKE WINGRA"
data.Export$LakeName[which(data$lakeid=="TR")]="TROUT LAKE"
data.Export$LakeName[which(data$lakeid=="TB")]="TROUT BOG"
data.Export$LakeName[which(data$lakeid=="AL")]="ALLEQUASH LAKE"
data.Export$LakeName[which(data$lakeid=="SP")]="SPARKLING LAKE"
data.Export$LakeName[which(data$lakeid=="BM")]="BIG MUSKELLUNGE LAKE"
data.Export$LakeName[which(data$lakeid=="CB")]="CRYSTAL BOG"
data.Export$LakeName[which(data$lakeid=="CR")]="CRYSTAL LAKE"
#now populate LAGOS LakeID--use WDNR (Wisconsin DNR) WBIC (WBIC=waterbody identification code) for LakeID
data.Export$LakeID=as.character(data.Export$LakeID)
data.Export$LakeID[which(data$lakeid=="ME")]="805400"
data.Export$LakeID[which(data$lakeid=="MO")]="804600"
data.Export$LakeID[which(data$lakeid=="FI")]="985100"
data.Export$LakeID[which(data$lakeid=="WI")]="805000"
data.Export$LakeID[which(data$lakeid=="TR")]="2331600" #note that it is the south basin of trout
data.Export$LakeID[which(data$lakeid=="TB")]="2014700"
data.Export$LakeID[which(data$lakeid=="SP")]="1881900"
data.Export$LakeID[which(data$lakeid=="BM")]="1835300"
data.Export$LakeID[which(data$lakeid=="AL")]="2332400" ##note that it is the north basin of allequash
data.Export$LakeID[which(data$lakeid=="CB")]="2017500"
data.Export$LakeID[which(data$lakeid=="CR")]="1842400"
#fill in source variable name according to major.nutrients
data.Export$SourceVariableName = "totnf"
data.Export$SourceVariableDescription = "Total N filtered" #be sure to check metadata table to make sure it matches
##need to populate data flags and make a note in the processing log
head(data)
data.Export$SourceFlags = data[,6] #totnuf flags =see eml file (as .xml)
unique(data.Export$SourceFlags)
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
unique(data.Export$SourceFlags) 
data.Export$SourceFlags[which(data.Export$SourceFlags=="")] = NA
data.Export$LagosVariableID=22
data.Export$LagosVariableName="Nitrogen, total dissolved"
data.Export$Value = data[,5] 
data.Export$DetectionLimit = NA
data.Export$CensorCode = as.character(data.Export$CensorCode)
data.Export$CensorCode= "NC" #no censor code
data.Export$Units="ug/L" #preferred units per metadata table
data.Export$Date = data$sampledate #export sample date, already in correct format
data.Export$SamplePosition = as.character(data.Export$SamplePosition) #convert sample position to character, so it can be manipulated
data.Export$SamplePosition= "SPECIFIED" #a depth is specified for every observation, researcher can determine epi, meta, hypo
unique(data$depth)# lots of unique depths
data.Export$SampleDepth=data$depth
data.Export$SampleType = as.character(data.Export$SampleType)
data.Export$SampleType= "GRAB" #all observations are grab samples (water pumped from a specific depth: point)
data.Export$BasinType = as.character(data.Export$BasinType)
data.Export$BasinType= "PRIMARY"
data.Export$MethodInfo=as.character(data.Export$MethodInfo)
data.Export$MethodInfo=NA
data.Export$LabMethodName=as.character(data.Export$LabMethodName)
data.Export$LabMethodName=NA 
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="See NT LTER website - http://lter.limnology.wisc.edu/research/protocols"
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
#remove missing values
unique(data.Export$Value)
#check how many need to be removed
length(data.Export$Value[which(data.Export$Value==-99.99)])
length(data.Export$Value[which(data.Export$Value==-99.00)])
#remove missing values
data.Export=data.Export[which(data.Export$Value!=-99.99),]
data.Export=data.Export[which(data.Export$Value!=-99.00),]
tdn.Final = data.Export
rm(data)
rm(data.Export)
################################ NH4 #####################################################################
data=major.nutrients2
names(data)
data = data[,c(1:5,10)]
head(data)
#pulling out the columns relevant to doc
head(data) #just looking at the data
data=data[which(is.na(data[,5])==FALSE),]  #remove null (NA) nh4 observations
sum(is.na(data[,5])) #double check to confirm they have been removed, confirmed
sum(!is.na(data[,6])) #gives the total number of flags== 13182
unique(data$rep) # Check to see unique levels of replicates, only 1 and 2
data$rep = as.character(data$rep) #data was a factor, convert it to characters
unique(data$rep) #confirm rep is a character class 
#look at how many replicate types there are:
length(which(data$rep==1)) # 95% of observations have only one replicate
#limit data to those with rep=1 (command below)
data = data[which(data$rep==1),]
#### Begin Populating Lagos Template ###
data.Export = LAGOS_Template #creates LAGOS export template
data.Export[1:nrow(data),]=NA #specifies how to fill template
data$lakeid = as.character(data$lakeid) #need to work on getting the full lake name from lakeid in the dataset
unique(data$lakeid) #reveals number of lakes == 9 out of 11 of the LTER Study Lakes
#Note that Lake Mendota and Lake Monona are not included for nh4 observations
#now convert to full lakename and export to LAGOS 
data.Export$LakeName=as.character(data.Export$LakeName) #convert to character so it can be manipulated
data.Export$LakeName[which(data$lakeid=="ME")]="LAKE MENDOTA"
data.Export$LakeName[which(data$lakeid=="MO")]="LAKE MONONA"
data.Export$LakeName[which(data$lakeid=="FI")]="FISH LAKE"
data.Export$LakeName[which(data$lakeid=="WI")]="LAKE WINGRA"
data.Export$LakeName[which(data$lakeid=="TR")]="TROUT LAKE"
data.Export$LakeName[which(data$lakeid=="TB")]="TROUT BOG"
data.Export$LakeName[which(data$lakeid=="AL")]="ALLEQUASH LAKE"
data.Export$LakeName[which(data$lakeid=="SP")]="SPARKLING LAKE"
data.Export$LakeName[which(data$lakeid=="BM")]="BIG MUSKELLUNGE LAKE"
data.Export$LakeName[which(data$lakeid=="CB")]="CRYSTAL BOG"
data.Export$LakeName[which(data$lakeid=="CR")]="CRYSTAL LAKE"
#now populate LAGOS LakeID--use WDNR (Wisconsin DNR) WBIC (WBIC=waterbody identification code) for LakeID
data.Export$LakeID=as.character(data.Export$LakeID)
data.Export$LakeID[which(data$lakeid=="ME")]="805400"
data.Export$LakeID[which(data$lakeid=="MO")]="804600"
data.Export$LakeID[which(data$lakeid=="FI")]="985100"
data.Export$LakeID[which(data$lakeid=="WI")]="805000"
data.Export$LakeID[which(data$lakeid=="TR")]="2331600" #note that it is the south basin of trout
data.Export$LakeID[which(data$lakeid=="TB")]="2014700"
data.Export$LakeID[which(data$lakeid=="SP")]="1881900"
data.Export$LakeID[which(data$lakeid=="BM")]="1835300"
data.Export$LakeID[which(data$lakeid=="AL")]="2332400" ##note that it is the north basin of allequash
data.Export$LakeID[which(data$lakeid=="CB")]="2017500"
data.Export$LakeID[which(data$lakeid=="CR")]="1842400"
#fill in source variable name according to major.nutrients2
data.Export$SourceVariableName = "nh4"
data.Export$SourceVariableDescription = "Nitrogen, Ammonium (NH4)" #be sure to check metadata table to make sure it matches
##need to populate data flags and make a note in the processing log
head(data)
data.Export$SourceFlags = data[,6] #nh4 flags =see eml file (as .xml)
unique(data.Export$SourceFlags)
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
unique(data.Export$SourceFlags) 
data.Export$SourceFlags[which(data.Export$SourceFlags=="")] = NA
data.Export$LagosVariableID= "19" 
data.Export$LagosVariableName="Nitrogen, NH4"
data.Export$Value = data[,5] #not sure why NAs are still showing up
data.Export$DetectionLimit = "NA"
##censor code populating- determine if detection limit (dl exists) then determine if observation is greater than (GL) or less than (LT) the detection limit. Assign "NC" if there is no censor code
data.Export$CensorCode = as.character(data.Export$CensorCode)
data.Export$CensorCode= "NC"
data.Export$Units="ug/L" #preferred units per metadata table
data.Export$Date = data$sampledate #export sample date, already in correct format
data.Export$SamplePosition = as.character(data.Export$SamplePosition) #convert sample position to character, so it can be manipulated
data.Export$SamplePosition= "SPECIFIED" #a depth is specified for every observation, researcher can determine epi, meta, hypo
unique(data$depth)# lots of unique depths
data.Export$SampleDepth=data$depth
data.Export$SampleType = as.character(data.Export$SampleType)
data.Export$SampleType= "GRAB" #all observations are grab samples (water pumped from a specific depth: point)
data.Export$BasinType = as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY"
data.Export$MethodInfo=as.character(data.Export$MethodInfo)
data.Export$MethodInfo=NA
data.Export$LabMethodName=as.character(data.Export$LabMethodName)
data.Export$LabMethodName=NA 
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="See NT LTER website - http://lter.limnology.wisc.edu/research/protocols"
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
#remove missing values
unique(data.Export$Value)
#check how many need to be removed
length(data.Export$Value[which(data.Export$Value==-99.99)])
length(data.Export$Value[which(data.Export$Value==-99.00)])
#remove missing values
data.Export=data.Export[which(data.Export$Value!=-99.99),]
data.Export=data.Export[which(data.Export$Value!=-99.00),]
nh4.Final = data.Export
rm(data)                     
rm(data.Export)
################################ NH4_SLOH #####################################################################
data=major.nutrients2
names(data)
data = data[,c(1:4,7,12)]
head(data)
#pulling out the columns relevant to doc
data=data[which(is.na(data[,5])==FALSE),]  #remove null (NA) nh4 observations
sum(is.na(data[,5])) #double check to confirm they have been removed, confirmed
sum(!is.na(data[,6])) #gives the total number of flags== 2167
unique(data$rep) # Check to see unique levels of replicates, only 1 replicate observed
data = data[which(data$rep==1),] #doesn't do anything because only 1 replicate anyhow
#### Begin Populating Lagos Template ###
data.Export = LAGOS_Template #creates LAGOS export template
data.Export[1:nrow(data),]=NA #specifies how to fill template
data$lakeid = as.character(data$lakeid) #need to work on getting the full lake name from lakeid in the dataset
unique(data$lakeid) #only nh4_sloh for the four southern lakes
#now convert to full lakename and export to LAGOS 
data.Export$LakeName=as.character(data.Export$LakeName) #convert to character so it can be manipulated
data.Export$LakeName[which(data$lakeid=="ME")]="LAKE MENDOTA"
data.Export$LakeName[which(data$lakeid=="MO")]="LAKE MONONA"
data.Export$LakeName[which(data$lakeid=="FI")]="FISH LAKE"
data.Export$LakeName[which(data$lakeid=="WI")]="LAKE WINGRA"
#now populate LAGOS LakeID--use WDNR (Wisconsin DNR) WBIC (WBIC=waterbody identification code) for LakeID
data.Export$LakeID=as.character(data.Export$LakeID)
data.Export$LakeID[which(data$lakeid=="ME")]="805400"
data.Export$LakeID[which(data$lakeid=="MO")]="804600"
data.Export$LakeID[which(data$lakeid=="FI")]="985100"
data.Export$LakeID[which(data$lakeid=="WI")]="805000"
#fill in source variable name according to major.nutrients2
data.Export$SourceVariableName = "nh4_sloh"
data.Export$SourceVariableDescription = "Ammonium Nitrogen from WI State Lab. of Hygiene" #be sure to check metadata table to make sure it matches
##need to populate data flags and make a note in the processing log
head(data)
data.Export$SourceFlags = data[,6] #nh4_sloh flags =see eml file (as .xml)
unique(data.Export$SourceFlags) #only four unique flags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
unique(data.Export$SourceFlags) 
data.Export$SourceFlags[which(data.Export$SourceFlags=="")] = NA
data.Export$LagosVariableID= "19" 
data.Export$LagosVariableName="Nitrogen, NH4"
data.Export$Value = data[,5] #not sure why NAs are still showing up
data.Export$DetectionLimit = "NA"
data.Export$CensorCode = as.character(data.Export$CensorCode)
data.Export$CensorCode= "NC"
data.Export$Units="mg/L" #preferred units per metadata table
data.Export$Date = data$sampledate #export sample date, already in correct format
data.Export$SamplePosition = as.character(data.Export$SamplePosition) #convert sample position to character, so it can be manipulated
data.Export$SamplePosition= "SPECIFIED" #a depth is specified for every observation, researcher can determine epi, meta, hypo
unique(data$depth)# lots of unique depths
data.Export$SampleDepth=data$depth
data.Export$SampleType = as.character(data.Export$SampleType)
data.Export$SampleType= "GRAB" #all observations are grab samples (water pumped from a specific depth: point)
data.Export$BasinType = as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY"
data.Export$MethodInfo=as.character(data.Export$MethodInfo)
data.Export$MethodInfo=NA
data.Export$LabMethodName=as.character(data.Export$LabMethodName)
data.Export$LabMethodName=NA 
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="See NT LTER website - http://lter.limnology.wisc.edu/research/protocols"
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
#remove missing values
unique(data.Export$Value)
#check how many need to be removed
length(data.Export$Value[which(data.Export$Value==-99.99)])
length(data.Export$Value[which(data.Export$Value==-99.00)])
#remove missing values
data.Export=data.Export[which(data.Export$Value!=-99.99),]
data.Export=data.Export[which(data.Export$Value!=-99.00),]
nh4_1.Final = data.Export
rm(data)                     
rm(data.Export)                                                       
#################################NO3NO2_SLOH################################################
data=major.nutrients2
names(data)
data = data[,c(1:4,6,11)]
head(data)
#pulling out the columns relevant to doc
head(data) #just looking at the data
data=data[which(is.na(data[,5])==FALSE),]  #remove null (NA) doc observations
#note that a "safer way to acheive the same command as line 38 is "data=data[which(is.na(data$doc)==FALSE),]"
sum(is.na(data[,5])) #double check to confirm they have been removed, confirmed
sum(!is.na(data[,6])) #gives the total number of flags== 2156
unique(data$rep) # Check to see unique levels of replicates
data = data[which(data$rep==1),]
#### Begin Populating Lagos Template ###
data.Export = LAGOS_Template #creates LAGOS export template
data.Export[1:nrow(data),]=NA #specifies how to fill template
data$lakeid = as.character(data$lakeid) #need to work on getting the full lake name from lakeid in the dataset
unique(data$lakeid) #reveals number of lakes == 4 southern LTER study lakes: ME, MO, WI, FI
#now convert to full lakename and export to LAGOS 
data.Export$LakeName=as.character(data.Export$LakeName) #convert to character so it can be manipulated
data.Export$LakeName[which(data$lakeid=="ME")]="LAKE MENDOTA"
data.Export$LakeName[which(data$lakeid=="MO")]="LAKE MONONA"
data.Export$LakeName[which(data$lakeid=="FI")]="FISH LAKE"
data.Export$LakeName[which(data$lakeid=="WI")]="LAKE WINGRA"
#now populate LAGOS LakeID--use WDNR (Wisconsin DNR) WBIC (WBIC=waterbody identification code) for LakeID
data.Export$LakeID=as.character(data.Export$LakeID)
data.Export$LakeID[which(data$lakeid=="ME")]="805400"
data.Export$LakeID[which(data$lakeid=="MO")]="804600"
data.Export$LakeID[which(data$lakeid=="FI")]="985100"
data.Export$LakeID[which(data$lakeid=="WI")]="805000"
#fill in source variable name according to major.nutrients
data.Export$SourceVariableName = "no3no2_sloh"
data.Export$SourceVariableDescription = "Nitrate plus Nitrite Nitrogen from WI State Lab. of Hygiene" #be sure to check metadata table to make sure it matches
##need to populate data flags and make a note in the processing log
head(data)
data.Export$SourceFlags = data[,6] #no3no2_sloh flags =see eml file (as .xml)
unique(data.Export$SourceFlags)
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
unique(data.Export$SourceFlags) #only 4 unique flags remeber to record in processing log
data.Export$SourceFlags[which(data.Export$SourceFlags=="")] = NA
data.Export$LagosVariableID= "18" 
data.Export$LagosVariableName="Nitrogen, nitrite (NO2) + nitrate (NO3)"
data.Export$Value = data[,5]
data.Export$DetectionLimit = "NA"
data.Export$CensorCode = as.character(data.Export$CensorCode)
data.Export$CensorCode= "NC"
data.Export$Units="mg/L" #preferred units per metadata table
data.Export$Date = data$sampledate #export sample date, already in correct format
data.Export$SamplePosition = as.character(data.Export$SamplePosition) #convert sample position to character, so it can be manipulated
data.Export$SamplePosition= "SPECIFIED" #a depth is specified for every observation, researcher can determine epi, meta, hypo
unique(data$depth)# lots of unique depths
data.Export$SampleDepth=data$depth
data.Export$SampleType = as.character(data.Export$SampleType)
data.Export$SampleType= "GRAB" #all observations are grab samples (water pumped from a specific depth: point)
data.Export$BasinType = as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY"
data.Export$MethodInfo=as.character(data.Export$MethodInfo)
data.Export$MethodInfo=NA
data.Export$LabMethodName=as.character(data.Export$LabMethodName)
data.Export$LabMethodName=NA 
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="See NT LTER website - http://lter.limnology.wisc.edu/research/protocols"
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
#remove missing values
unique(data.Export$Value)
#check how many need to be removed
length(data.Export$Value[which(data.Export$Value==-99.99)])
length(data.Export$Value[which(data.Export$Value==-99.00)])
#remove missing values
data.Export=data.Export[which(data.Export$Value!=-99.99),]
data.Export=data.Export[which(data.Export$Value!=-99.00),]
no3no2_1.Final = data.Export
rm(data)
rm(data.Export)                            
##################################### KJDL_N_SLOH############################################################
data=major.nutrients1
names(data)
data = data[,c(1,4:6,13,21)] #pulling out the columns relevant to kjdl_n_sloh
head(data) #just looking at the data)
data=data[which(is.na(data[,5])==FALSE),] #remove null (NA) kjdl_n_sloh observations
sum(is.na(data[,5])) #double check to confirm they have been removed, confirmed
sum(!is.na(data[,6])) #sums the number of flags= 1985
unique(data$rep) # only one replicate anyhow
data = data[which(data$rep==1),] #doesn't do anything only one rep anyhow
#### Begin Populating Lagos Template ###
data.Export = LAGOS_Template #creates LAGOS export template
data.Export[1:nrow(data),]=NA #specifies how to fill template
data$lakeid = as.character(data$lakeid) #need to work on getting the full lake name from lakeid in the dataset
unique(data$lakeid) #reveals number of lakes == 4 southern lter study lakes
#now convert to full lakename and export to LAGOS
data.Export$LakeName=as.character(data.Export$LakeName) #convert to character so it can be manipulated
data.Export$LakeName[which(data$lakeid=="ME")]="LAKE MENDOTA"
data.Export$LakeName[which(data$lakeid=="MO")]="LAKE MONONA"
data.Export$LakeName[which(data$lakeid=="FI")]="FISH LAKE"
data.Export$LakeName[which(data$lakeid=="WI")]="LAKE WINGRA"
#now populate LAGOS LakeID--use WDNR (Wisconsin DNR) WBIC (WBIC=waterbody identification code) for LakeID
data.Export$LakeID=as.character(data.Export$LakeID)
data.Export$LakeID[which(data$lakeid=="ME")]="805400"
data.Export$LakeID[which(data$lakeid=="MO")]="804600"
data.Export$LakeID[which(data$lakeid=="FI")]="985100"
data.Export$LakeID[which(data$lakeid=="WI")]="805000"
#fill in source variable name according to major.nutrients
data.Export$SourceVariableName = "kjdl_n_sloh"
data.Export$SourceVariableDescription = "Total Kjeldahl Nitrogen from WI State Lab. of Hygiene" #be sure to check metadata table to make sure it matches METADATA FILE
##need to populate data flags and make a note in the processing log
data.Export$SourceFlags = data[,6] #doc flags =see eml file (as .xml)
unique(data.Export$SourceFlags)
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
unique(data.Export$SourceFlags) 
data.Export$SourceFlags[which(data.Export$SourceFlags=="")] = NA
data.Export$LagosVariableID= "16" 
data.Export$LagosVariableName="Nitrogen, total Kjeldahl" #LOOK at standard lagos variable name on metadata table
data.Export$Value = data[,5]
head(data)
data.Export$DetectionLimit = "NA"
##censor code populating- determine if detection limit (dl exists) then determine if observation is greater than (GL) or less than (LT) the detection limit. Assign "NC" if there is no censor code
data.Export$CensorCode = as.character(data.Export$CensorCode)
data.Export$CensorCode = "NC" #GT/LT not relevant since all observations are above the DL
data.Export$Units="mg/L" #preferred units per metadata table
data.Export$Date = data$sampledate #export sample date, already in correct format
data.Export$SamplePosition = as.character(data.Export$SamplePosition) #convert sample position to character, so it can be manipulated
data.Export$SamplePosition= "SPECIFIED" #a depth is specified for every observation, researcher can determine epi, meta, hypo
unique(data$depth)# lots of unique depths
data.Export$SampleDepth=data$depth
data.Export$SampleType = as.character(data.Export$SampleType)
data.Export$SampleType= "GRAB" #all observations are grab samples (water pumped from a specific depth: point)
data.Export$BasinType = as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY"
data.Export$MethodInfo=as.character(data.Export$MethodInfo)
data.Export$MethodInfo=NA
data.Export$LabMethodName=as.character(data.Export$LabMethodName)
data.Export$LabMethodName=NA 
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="See NT LTER website - http://lter.limnology.wisc.edu/research/protocols"
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
#remove missing values
unique(data.Export$Value)
#check how many need to be removed
length(data.Export$Value[which(data.Export$Value==-99.99)])
length(data.Export$Value[which(data.Export$Value==-99.00)])
#remove missing values
data.Export=data.Export[which(data.Export$Value!=-99.99),]
data.Export=data.Export[which(data.Export$Value!=-99.00),]
tkn.Final = data.Export
rm(data)
rm(data.Export)

########################################### DRP_SLOH #######################################################
data=major.nutrients2
names(data)
data = data[,c(1:4,9,14)] #just pulling out columns relevant to drp_sloh
head(data)
data=data[which(is.na(data[,5])==FALSE),]  #remove null (NA) drp_sloh observations
#note that a "safer way to acheive the same command as line 38 is "data=data[which(is.na(data$drp_sloh)==FALSE),]"
sum(is.na(data[,5])) #double check to confirm they have been removed, confirmed
sum(!is.na(data[,6])) #gives the total number of flags== 2650
unique(data$rep) # Check to see unique levels of replicates, only 1 replicate anyhow
data = data[which(data$rep==1),] #doesn't do anything only 1 rep anyways
#### Begin Populating Lagos Template ###
data.Export = LAGOS_Template #creates LAGOS export template
data.Export[1:nrow(data),]=NA #specifies how to fill template
data$lakeid = as.character(data$lakeid) #need to work on getting the full lake name from lakeid in the dataset
unique(data$lakeid) #reveals number of lakes == 4 southern LTER study lakes
#now convert to full lakename and export to LAGOS 
data.Export$LakeName=as.character(data.Export$LakeName) #convert to character so it can be manipulated
data.Export$LakeName[which(data$lakeid=="ME")]="LAKE MENDOTA"
data.Export$LakeName[which(data$lakeid=="MO")]="LAKE MONONA"
data.Export$LakeName[which(data$lakeid=="FI")]="FISH LAKE"
data.Export$LakeName[which(data$lakeid=="WI")]="LAKE WINGRA"
#now populate LAGOS LakeID--use WDNR (Wisconsin DNR) WBIC (WBIC=waterbody identification code) for LakeID
data.Export$LakeID=as.character(data.Export$LakeID)
data.Export$LakeID[which(data$lakeid=="ME")]="805400"
data.Export$LakeID[which(data$lakeid=="MO")]="804600"
data.Export$LakeID[which(data$lakeid=="FI")]="985100"
data.Export$LakeID[which(data$lakeid=="WI")]="805000"
#fill in source variable name according to major.nutrients
data.Export$SourceVariableName = "drp_sloh"
data.Export$SourceVariableDescription = "Dissolved Reactive Phosphorus from WI State Lab. of Hygiene" #be sure to check metadata table to make sure it matches
##need to populate data flags and make a note in the processing log
head(data)
data.Export$SourceFlags = data[,6] #doc flags =see eml file (as .xml)
unique(data.Export$SourceFlags)
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
unique(data.Export$SourceFlags) 
data.Export$SourceFlags[which(data.Export$SourceFlags=="")] = NA
data.Export$LagosVariableID= "26" 
data.Export$LagosVariableName="Phosphorus, soluable reactive orthophosphate"
data.Export$Value = data[,5]  
data.Export$CensorCode = as.character(data.Export$CensorCode)
data.Export$CensorCode= "NC"
data.Export$Units="mg/L" #preferred units per metadata table
data.Export$Date = data$sampledate #export sample date, already in correct format
data.Export$SamplePosition = as.character(data.Export$SamplePosition) #convert sample position to character, so it can be manipulated
data.Export$SamplePosition= "SPECIFIED" #a depth is specified for every observation, researcher can determine epi, meta, hypo
unique(data$depth)# lots of unique depths
data.Export$SampleDepth=data$depth
data.Export$SampleType = as.character(data.Export$SampleType)
data.Export$SampleType= "GRAB" #all observations are grab samples (water pumped from a specific depth: point)
data.Export$BasinType = as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY"
data.Export$MethodInfo=as.character(data.Export$MethodInfo)
data.Export$MethodInfo=NA
data.Export$LabMethodName=as.character(data.Export$LabMethodName)
data.Export$LabMethodName=NA 
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="See NT LTER website - http://lter.limnology.wisc.edu/research/protocols"
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
#remove missing values
unique(data.Export$Value)
#check how many need to be removed
length(data.Export$Value[which(data.Export$Value==-99.99)])
length(data.Export$Value[which(data.Export$Value==-99.00)])
#remove missing values
data.Export=data.Export[which(data.Export$Value!=-99.99),]
data.Export=data.Export[which(data.Export$Value!=-99.00),]
drp1.Final = data.Export
rm(data)
rm(data.Export)                                  

########################################  TOTPUF_SLOH ##################################################################################
data=major.nutrients2
names(data)
data = data[,c(1:4,8,13)] #just pulling out columns relevant to totpuf_sloh
head(data)
data=data[which(is.na(data[,5])==FALSE),]  #remove null (NA) totpuf_sloh observations
sum(is.na(data[,5])) #double check to confirm they have been removed, confirmed
sum(!is.na(data[,6])) #gives the total number of flags== 2673
unique(data$rep) # Check to see unique levels of replicates, only 1 replicate anyhow
data = data[which(data$rep==1),] #doesn't do anything only 1 rep anyways
#### Begin Populating Lagos Template ###
data.Export = LAGOS_Template #creates LAGOS export template
data.Export[1:nrow(data),]=NA #specifies how to fill template
data$lakeid = as.character(data$lakeid) #need to work on getting the full lake name from lakeid in the dataset
unique(data$lakeid) #reveals number of lakes == 4 southern LTER study lakes
#now convert to full lakename and export to LAGOS 
data.Export$LakeName=as.character(data.Export$LakeName) #convert to character so it can be manipulated
data.Export$LakeName[which(data$lakeid=="ME")]="LAKE MENDOTA"
data.Export$LakeName[which(data$lakeid=="MO")]="LAKE MONONA"
data.Export$LakeName[which(data$lakeid=="FI")]="FISH LAKE"
data.Export$LakeName[which(data$lakeid=="WI")]="LAKE WINGRA"
#now populate LAGOS LakeID--use WDNR (Wisconsin DNR) WBIC (WBIC=waterbody identification code) for LakeID
data.Export$LakeID=as.character(data.Export$LakeID)
data.Export$LakeID[which(data$lakeid=="ME")]="805400"
data.Export$LakeID[which(data$lakeid=="MO")]="804600"
data.Export$LakeID[which(data$lakeid=="FI")]="985100"
data.Export$LakeID[which(data$lakeid=="WI")]="805000"
#fill in source variable name according to major.nutrients
data.Export$SourceVariableName = "totpuf_sloh"
data.Export$SourceVariableDescription = "Total phosphorus Unfiltered from WI State Lab. of Hygiene" #be sure to check metadata table to make sure it matches
##need to populate data flags and make a note in the processing log
head(data)
data.Export$SourceFlags = data[,6] #doc flags =see eml file (as .xml)
unique(data.Export$SourceFlags)
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
unique(data.Export$SourceFlags) 
data.Export$SourceFlags[which(data.Export$SourceFlags=="")] = NA
data.Export$LagosVariableID= "27" 
data.Export$LagosVariableName="Phosphorus, total"
data.Export$Value = data[,5]  
data.Export$CensorCode = as.character(data.Export$CensorCode)
data.Export$CensorCode= "NC"
data.Export$Units="mg/L" #preferred units per metadata table
data.Export$Date = data$sampledate #export sample date, already in correct format
data.Export$SamplePosition = as.character(data.Export$SamplePosition) #convert sample position to character, so it can be manipulated
data.Export$SamplePosition= "SPECIFIED" #a depth is specified for every observation, researcher can determine epi, meta, hypo
unique(data$depth)# lots of unique depths
data.Export$SampleDepth=data$depth
data.Export$SampleType = as.character(data.Export$SampleType)
data.Export$SampleType= "GRAB" #all observations are grab samples (water pumped from a specific depth: point)
data.Export$BasinType = as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY"
data.Export$MethodInfo=as.character(data.Export$MethodInfo)
data.Export$MethodInfo=NA
data.Export$LabMethodName=as.character(data.Export$LabMethodName)
data.Export$LabMethodName=NA 
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="See NT LTER website - http://lter.limnology.wisc.edu/research/protocols"
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
#remove missing values
unique(data.Export$Value)
#check how many need to be removed
length(data.Export$Value[which(data.Export$Value==-99.99)])
length(data.Export$Value[which(data.Export$Value==-99.00)])
#remove missing values
data.Export=data.Export[which(data.Export$Value!=-99.99),]
data.Export=data.Export[which(data.Export$Value!=-99.00),]
tp1.Final = data.Export
rm(data)
rm(data.Export)   

###################################### final export ########################################################################################
Final.Export = rbind(doc.Final,drp1.Final,nh4.Final,nh4_1.Final,no2.Final,no3no2.Final,no3no2_1.Final,tdn.Final,tdp.Final,tn.Final,toc.Final,tp.Final,tp1.Final,tkn.Final)
write.table(Final.Export,file="DataImport_WI_LTER_NUTRIENTS.csv",row.names=FALSE,sep=",")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/WI data/LTER (finished)/DataImport_WI_LTER_NUTRIENTS/DataImport_WI_LTER_NUTRIENTS.RData")