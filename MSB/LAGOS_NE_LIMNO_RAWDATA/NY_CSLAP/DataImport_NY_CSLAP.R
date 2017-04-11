#set path to files
setwd("C:/Users/sam/Dropbox/CSI-LIMNO_DATA/DATA-lake/NY data/NY_CSLAP (finished)/DataImport_NY_CSLAP")
setwd("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/NY data/NY_CSLAP (finished)/DataImport_NY_CSLAP")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/NY data/NY_CSLAP (finished)/DataImport_NY_CSLAP/DataImport_NY_CSLAP.RData")

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
#data file is "NY_CSLAP.csv"
#citizen monitoring program
#missing values usually represented with blank cell, check for other values representing null (as metadata says they occur)
#for sample depth missing values are identified by "not rec, not recorded, or NA" be sure to check
#in sample depth "epi", "meta", "shore" "~" "+" and other characters may occur again be sure to check for unique values
#LakeID spec. by "LNum" LakeName spec. by "PName"
#The "type" field indicates whether it was a surface or bottom sample. (these are all specified samples as a depth should be given)
#The metadata specifies LabMethodName and Lab MethodInfo as well as DetectionLImit(for some methods)
###########################################################################################################################################################################################
################################### Chl.a   #############################################################################################################################
data= NY_CSLAP
data = data[,c(1:3,6:7,16)]
names(data)
unique(data$Chl.a) # blank cells and <LOD are the problematic "missing values" here.
#where <LOD  occurs populate the lagos Value with the method detection limit, and specify "LT" in CensorCode
length(data$Chl.a[which(data$Chl.a=="")])
data=data[which(data$Chl.a!=""),] #4967 are empty cells/null
21092-4967 #should be left with 16125
length(data$Chl.a[which(data$Chl.a=="<LOD")]) #6 obs are "<LOD"
length(data$Chl.a[which(data$Chl.a=="7.75*")]) #1 obs 
typeof(data$Chl.a)
data$Chl.a=as.character(data$Chl.a)
unique(data$Chl.a)
data$Chl.a[which(data$Chl.a=="<LOD")]= "999"
data$Chl.a[which(data$Chl.a=="7.75*")]= "7.75"

#look at the unique values in the Zsamp which is the sampling depth field
unique(data$Zsamp) #note that there several unique values
length(data$Zsamp[which(data$Zsamp=="not rec")]) #19
length(data$Zsamp[which(data$Zsamp=="not recorded")])#47
length(data$Zsamp[which(data$Zsamp=='"same"')])#5
length(data$Zsamp[which(data$Zsamp=="")])#1376
length(data$Zsamp[which(data$Zsamp==".")])#1
length(data$Zsamp[which(data$Zsamp==" ")]) #59
#filter out "not rec" "not recorded" and "same", and null values as depth cannot be determined
19+47+5+1376+1+59
(16125-1507)/16125 #91% of data has depth inf
data$Zsamp=as.character(data$Zsamp)
data$Zsamp[which(data$Zsamp=="not rec")]=9999
data$Zsamp[which(data$Zsamp=="not recorded")]=9999
data$Zsamp[which(data$Zsamp=='"same"')]=9999
data$Zsamp[which(data$Zsamp=="")]=9999
data$Zsamp[which(data$Zsamp==" ")]=9999
data$Zsamp[which(data$Zsamp==".")]=9999
length(data$Zsamp[which(data$Zsamp=="9999")])
data$Zsamp[which(data$Zsamp=="9999")]=NA
length(data$Zsamp[which(data$Zsamp=="surface")])#8
length(data$Zsamp[which(data$Zsamp=='"surface"')])#14
length(data$Zsamp[which(data$Zsamp=="\"surface\"")])#14
length(data$Zsamp[which(data$Zsamp=="epi")])#9
#assign a depth of "0" to those that are "surface", deal with "epi" after assigning SamplePosition 
data$Zsamp[which(data$Zsamp=="surface")]=0
data$Zsamp[which(data$Zsamp=='"surface"')]=0
data$Zsamp[which(data$Zsamp=="\"surface\"")]=0
unique(data$Zsamp)#epi should be the only unique value left in depth

#done with filtering populate lagos

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$LNum 
data.Export$LakeName = data$PName
data.Export$SourceVariableName = "Chl.a"
data.Export$SourceVariableDescription = "Chlorophyll a (fluorometric)"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA 
#continue populating other lagos variables
data.Export$LagosVariableID = 9
data.Export$LagosVariableName="Chlorophyll a"
names(data)
typeof(data$Chl.a)
data.Export$Value = data[,6] #export chla values, already in preferred units of ug/l
data.Export$Value=as.numeric(data.Export$Value)
unique(data.Export$Value)
data.Export$CensorCode=as.character(data.Export$CensorCode)
#populate CensorCode, assign "LT" where chla value is detection limit
data.Export$CensorCode[which(data$Chl.a=="999")]= "LT"
length(data$Chl.a[which(data$Chl.a=="999")])
unique(data.Export$CensorCode)
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]="NC"
unique(data.Export$CensorCode)#check to make sure appropriate values
###continue populating other columns
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB"
#assign sampledepth 
unique(data$Zsamp)
typeof(data$Zsamp)
data.Export$SampleDepth=data$Zsamp
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==FALSE)]) #check for missing depth values, should only occur for epi

#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
unique(data$Type)
length(data$Type[which(data$Type=="3")])#assume these are surface
length(data$Type[which(data$Type=="")])
length(data$Type[which(data$Type==" ")])
length(data$Type[which(data$Type==" ")])
length(data$Type[which(is.na(data$Type)==TRUE)])
data$Type=as.character(data$Type)
data.Export$SamplePosition[which(data$Type=="3")]="EPI"
data.Export$SamplePosition[which(data$Type=="surface")]="EPI"
data.Export$SamplePosition[which(data$Type=="Surface")]="EPI"
data.Export$SamplePosition[which(data$Type=="bottom")]="HYPO"
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="HYPO")])
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="UNKNOWN")])
unique(data.Export$SamplePosition)
16065+60

typeof(data.Export$SampleDepth)
unique(data.Export$SampleDepth)
data.Export$SampleDepth[which(data.Export$SampleDepth=="epi")]=0
data.Export$SampleDepth=as.numeric(data.Export$SampleDepth)
unique(data.Export$SampleDepth)

#continue populating other lagos fields
data.Export$BasinType="UNKNOWN" #not specified in metadata
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable to chla
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "EPA_445.0r1.2"
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="EPA_445.0 Rev. 1.2"
data.Export$DetectionLimit= .1 #per metadata
data.Export$Comments= "sample collected with a kemmerer bottle"
chla.Final = data.Export
rm(data)
rm(data.Export)

################################### TColor  #############################################################################################################################
data= NY_CSLAP
data = data[,c(1:3,6:7,12)]
unique(data$TColor) # blank cells and <LOD are the problematic "missing values" here.
#where <LOD  occurs populate the lagos Value with the method detection limit, and specify "LT" in CensorCode
length(data$TColor[which(data$TColor=="")])#4770 null values
data=data[which(data$TColor!=""),] #4967 are empty cells/null
21092-4770 #should be left with 16322
length(data$TColor[which(data$TColor=="<LOD")]) #9 obs are "<LOD"
data$TColor=as.character(data$TColor)
data$TColor[which(data$TColor=="<LOD")]= "999"

#look at the unique values in the Zsamp which is the sampling depth field
unique(data$Zsamp) #note that there several unique values
length(data$Zsamp[which(data$Zsamp=="not rec")]) #20
length(data$Zsamp[which(data$Zsamp=="not recorded")])#49
length(data$Zsamp[which(data$Zsamp=='"same"')])#5
length(data$Zsamp[which(data$Zsamp=="")])#1376
length(data$Zsamp[which(data$Zsamp==".")])#1
length(data$Zsamp[which(data$Zsamp==" ")]) #59
#filter out "not rec" "not recorded" and "same", and null values as depth cannot be determined
20+49+5+1376+1+59
(16322-1510)/16125 #91% of data is kept, the rest discarded
data$Zsamp=as.character(data$Zsamp)
data$Zsamp[which(data$Zsamp=="not rec")]=9999
data$Zsamp[which(data$Zsamp=="not recorded")]=9999
data$Zsamp[which(data$Zsamp=='"same"')]=9999
data$Zsamp[which(data$Zsamp=="")]=9999
data$Zsamp[which(data$Zsamp==" ")]=9999
data$Zsamp[which(data$Zsamp==".")]=9999
length(data$Zsamp[which(data$Zsamp=="9999")])
data$Zsamp[which(data$Zsamp=="9999")]=NA

length(data$Zsamp[which(data$Zsamp=="surface")])#9
length(data$Zsamp[which(data$Zsamp=='"surface"')])#14
length(data$Zsamp[which(data$Zsamp=="\"surface\"")])#14
length(data$Zsamp[which(data$Zsamp=="epi")])#8
#assign a depth of "0" to those that are "surface", deal with "epi" after assigning SamplePosition 
data$Zsamp[which(data$Zsamp=="surface")]=0
data$Zsamp[which(data$Zsamp=='"surface"')]=0
data$Zsamp[which(data$Zsamp=="\"surface\"")]=0
unique(data$Zsamp)#epi should be the only unique value left in depth

#done with filtering populate lagos

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$LNum 
data.Export$LakeName = data$PName
data.Export$SourceVariableName = "TColor"
data.Export$SourceVariableDescription = "True color, field filtered, platinum color units"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA 
#continue populating other lagos variables
data.Export$LagosVariableID = 12
data.Export$LagosVariableName="Color, true"
names(data)
typeof(data$TColor)
data.Export$Value = data[,6] #export tcolor obs., already in pref units of PCU
unique(data.Export$Value)
data.Export$Value=as.numeric(data.Export$Value)
data.Export$CensorCode=as.character(data.Export$CensorCode)
#populate CensorCode, assign "LT" where chla value is detection limit
data.Export$CensorCode[which(data$TColor=="999")]= "LT"
length(data$TColor[which(data$TColor=="999")])
unique(data.Export$CensorCode)
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]="NC"
unique(data.Export$CensorCode)#check to make sure appropriate values
###continue populating other columns
data.Export$Date = data$Date #date already in correct format
data.Export$Units="PCU"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB"
#assign sampledepth 
unique(data$Zsamp)
typeof(data$Zsamp)
data.Export$SampleDepth=data$Zsamp
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==FALSE)]) #check for missing depth values, should only occur for epi

#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
unique(data$Type)
length(data$Type[which(data$Type=="3")])#assume these are surface
length(data$Type[which(data$Type=="")])
length(data$Type[which(data$Type==" ")])
length(data$Type[which(data$Type==" ")])
length(data$Type[which(is.na(data$Type)==TRUE)])
data$Type=as.character(data$Type)
data.Export$SamplePosition[which(data$Type=="3")]="EPI"
data.Export$SamplePosition[which(data$Type=="surface")]="EPI"
data.Export$SamplePosition[which(data$Type=="Surface")]="EPI"
data.Export$SamplePosition[which(data$Type=="bottom")]="HYPO"
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="HYPO")])
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="UNKNOWN")])
unique(data.Export$SamplePosition)
16268+54

typeof(data.Export$SampleDepth)
unique(data.Export$SampleDepth)
data.Export$SampleDepth[which(data.Export$SampleDepth=="epi")]=0
data.Export$SampleDepth=as.numeric(data.Export$SampleDepth)
unique(data.Export$SampleDepth)

#continue populating other lagos fields
data.Export$BasinType="UNKNOWN" #not specified in metadata
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable to tcolor
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "EPA_110.2"
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA 
data.Export$DetectionLimit= 3 #per metadata
data.Export$Comments= "sample collected with a kemmerer bottle"
tcolor.Final = data.Export
rm(data)
rm(data.Export)

###################################  NH4    #############################################################################################################################
data= NY_CSLAP
data = data[,c(1:4,6:7,10)]
data$NH4=as.character(data$NH4)
unique(data$NH4) # blank cells and <LOD are the problematic "missing values" here.
#where <LOD  occurs populate the lagos Value with the method detection limit, and specify "LT" in CensorCode
length(data$NH4[which(data$NH4=="")]) #11924 are null
length(data$NH4[which(data$NH4=="#VALUE!")]) #10 have this special value, assuming this is null
11924+10 #remove 11934 observations
21092-11934 #should be left with 9158 obs.
data=data[which(data$NH4!=""),] #remove null
data=data[which(data$NH4!="#VALUE!"),] #remove null
#left wtih 9158=good
unique(data$NH4)
#look at the unique values in the Zsamp which is the sampling depth field
unique(data$Zsamp) #note that there several unique values
length(data$Zsamp[which(data$Zsamp=="not rec")]) #20
length(data$Zsamp[which(data$Zsamp=="not recorded")])#53
length(data$Zsamp[which(data$Zsamp=='"same"')])#5
length(data$Zsamp[which(data$Zsamp=="")])#1453
1453+5+53+20 #1531 values need to be removed
(9158-1531)/9158 #83% of data is kept, the rest discarded
data$Zsamp=as.character(data$Zsamp)
data$Zsamp[which(data$Zsamp=="not rec")]=9999
data$Zsamp[which(data$Zsamp=="not recorded")]=9999
data$Zsamp[which(data$Zsamp=='"same"')]=9999
data$Zsamp[which(data$Zsamp=="")]=9999
data$Zsamp[which(data$Zsamp==" ")]=9999
length(data$Zsamp[which(data$Zsamp=="9999")])

data$Zsamp[which(data$Zsamp=="9999")]=NA

#keep looking at special depth values that need to be dealt with
length(data$Zsamp[which(data$Zsamp=="surface")])#10
length(data$Zsamp[which(data$Zsamp=='"surface"')])#14
length(data$Zsamp[which(data$Zsamp=="\"surface\"")])#14
length(data$Zsamp[which(data$Zsamp=='\"surface\"')])#14
length(data$Zsamp[which(data$Zsamp=="bottom")])#3
length(data$Zsamp[which(data$Zsamp=='\"bottom\"')])#3
length(data$Zsamp[which(data$Zsamp=="26-30")])#1
length(data$Zsamp[which(data$Zsamp==">6")])#1
length(data$Zsamp[which(data$Zsamp=="1.5?")])#1
length(data$Zsamp[which(data$Zsamp=="~20")])#1
length(data$Zsamp[which(data$Zsamp=="epi")])#9
#first ignore ~ and ?
data$Zsamp[which(data$Zsamp=="1.5?")]=1.5 
data$Zsamp[which(data$Zsamp=="~20")]= 20
data$Zsamp[which(data$Zsamp=="26-30")]= 28


#assign a depth of "0" to those that are "surface", deal with "epi" after assigning SamplePosition, set those that are "bottom" to the "zbot"
data$Zsamp[which(data$Zsamp=="surface")]=0
data$Zsamp[which(data$Zsamp=='"surface"')]=0
data$Zsamp[which(data$Zsamp=="\"surface\"")]=0
data$Zsamp[which(data$Zsamp=="bottom")]=data$Zbot[which(data$Zsamp=="bottom")]
data$Zsamp[which(data$Zsamp=='\"bottom\"')]=data$Zbot[which(data$Zsamp=='\"bottom\"')]
unique(data$Zsamp)#epi and ">6" should be the only unique values left in depth, deal with later

#done with filtering populate lagos

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$LNum 
data.Export$LakeName = data$PName
data.Export$SourceVariableName = "NH4"
data.Export$SourceVariableDescription = "Ammonium"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA 
#continue populating other lagos variables
data.Export$LagosVariableID = 19
data.Export$LagosVariableName="Nitrogen, NH4"

#populate CensorCode
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$Zsamp==">6")]= "GT"
data.Export$CensorCode[which(data$Zsamp=="28+")]= "GT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]="NC" 
unique(data.Export$CensorCode)#check to make sure appropriate values
#overwrite special characters
data$Zsamp[which(data$Zsamp==">6")]= 6 
data$Zsamp[which(data$Zsamp=="28+")]= 28
unique(data$Zsamp) #now only epi is unique
#populate obs
data.Export$Value=data$NH4
unique(data.Export$Value)
data.Export$Value=as.numeric(data.Export$Value)
data.Export$Value=(data.Export$Value)*1000
unique(data.Export$Value)

###continue populating other columns
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB"
#assign sampledepth 
unique(data$Zsamp)
typeof(data$Zsamp)
data.Export$SampleDepth=data$Zsamp
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==FALSE)]) #check for missing depth values, should only occur for epi

#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
unique(data$Type)
length(data$Type[which(data$Type=="3")])#assume these are surface
length(data$Type[which(data$Type=="")])
length(data$Type[which(data$Type==" ")])
length(data$Type[which(data$Type==" ")])
length(data$Type[which(is.na(data$Type)==TRUE)])
data$Type=as.character(data$Type)
data.Export$SamplePosition[which(data$Type=="3")]="EPI"
data.Export$SamplePosition[which(data$Type=="surface")]="EPI"
data.Export$SamplePosition[which(data$Type=="Surface")]="EPI"
data.Export$SamplePosition[which(data$Type=="bottom")]="HYPO"
data.Export$SamplePosition[which(data$Type=="Bottom")]="HYPO"
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="HYPO")])
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="UNKNOWN")])
unique(data.Export$SamplePosition)
7665+1493

typeof(data.Export$SampleDepth)
unique(data.Export$SampleDepth)
data.Export$SampleDepth[which(data.Export$SampleDepth=="epi")]=0
data.Export$SampleDepth=as.numeric(data.Export$SampleDepth)
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType="UNKNOWN" #not specified in metadata
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable to nh4
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "EPA_350.1r2"
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="EPA_350.1 Rev. 2.0"
data.Export$DetectionLimit= 10 #per metadata
data.Export$Comments= "sample collected with a kemmerer bottle"
nh4.Final = data.Export
rm(data)
rm(data.Export)

###################################  NOx   #############################################################################################################################
data= NY_CSLAP
data = data[,c(1:4,6:7,9)]
unique(data$NOx) # blank cells and <LOD are the problematic "missing values" here.
#where <LOD  occurs populate the lagos Value with the method detection limit, and specify "LT" in CensorCode
#no <LOD as unique values for $NOx proceed with dealing with other unique values = "#VALUE!"
length(data$NOx[which(data$NOx=="")]) #5561 are null
length(data$NOx[which(data$NOx=="#VALUE!")]) #357 have this special value, assuming this is null
5561+357 #remove 5918 observations
21092-5918 #should be left with 15174 obs.
data=data[which(data$NOx!=""),] #remove null
data=data[which(data$NOx!="#VALUE!"),] #remove null
#left wtih 15174=good
unique(data$NOx)
length(data$NOx[which(data$NOx==" ")])
15174-42#remove these (above)
data=data[which(data$NOx!=" "),]
#look at the unique values in the Zsamp which is the sampling depth field
unique(data$Zsamp) #note that there several unique values
length(data$Zsamp[which(data$Zsamp=="not rec")]) #20
length(data$Zsamp[which(data$Zsamp=="not recorded")])#49
length(data$Zsamp[which(data$Zsamp=='"same"')])#5
length(data$Zsamp[which(data$Zsamp=="")])#1485
length(data$Zsamp[which(data$Zsamp==" ")])
1485+20+49+5 #1559 values need to be removed
(15174-1559)/15174 #90% of data is kept, the rest discarded
data$Zsamp=as.character(data$Zsamp)
data$Zsamp[which(data$Zsamp=="not rec")]=9999
data$Zsamp[which(data$Zsamp=="not recorded")]=9999
data$Zsamp[which(data$Zsamp=='"same"')]=9999
data$Zsamp[which(data$Zsamp=="")]=9999
data$Zsamp[which(data$Zsamp==" ")]=9999
data$Zsamp[which(data$Zsamp==".")]=9999
length(data$Zsamp[which(data$Zsamp=="9999")])
data$Zsamp[which(data$Zsamp=="9999")]=NA
#keep looking at special depth values that need to be dealt with
length(data$Zsamp[which(data$Zsamp=="surface")])#10
length(data$Zsamp[which(data$Zsamp=='"surface"')])#14
length(data$Zsamp[which(data$Zsamp=="\"surface\"")])#14
length(data$Zsamp[which(data$Zsamp=='\"surface\"')])#14
length(data$Zsamp[which(data$Zsamp=="bottom")])#one
length(data$Zsamp[which(data$Zsamp=='\"bottom\"')])#none
length(data$Zsamp[which(data$Zsamp=="26-30")])#none
length(data$Zsamp[which(data$Zsamp==">6")])#none
length(data$Zsamp[which(data$Zsamp=="1.5?")])#1
length(data$Zsamp[which(data$Zsamp=="~20")])#none
length(data$Zsamp[which(data$Zsamp=="epi")])#9
#first ignore ~ and ?
data$Zsamp[which(data$Zsamp=="1.5?")]=1.5 

#assign a depth of "0" to those that are "surface", deal with "epi" after assigning SamplePosition, set those that are "bottom" to the "zbot"
data$Zsamp[which(data$Zsamp=="surface")]=0
data$Zsamp[which(data$Zsamp=='"surface"')]=0
data$Zsamp[which(data$Zsamp=="\"surface\"")]=0

unique(data$Zsamp)#epi should be the only unique value left in depth, deal with later

#done with filtering populate lagos

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$LNum 
data.Export$LakeName = data$PName
data.Export$SourceVariableName = "NOx"
data.Export$SourceVariableDescription = "nitrite (NO2) + nitrate (NO3)"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA 
#continue populating other lagos variables
data.Export$LagosVariableID = 18
data.Export$LagosVariableName="Nitrogen, nitrite (NO2) + nitrate (NO3)"

#populate CensorCode
data.Export$CensorCode="NC"
unique(data.Export$CensorCode)#check to make sure appropriate values

#export nox observations
data$NOx=as.character(data$NOx)
data.Export$Value=data$NOx
unique(data.Export$Value)
data.Export$Value=as.numeric(data.Export$Value)
data.Export$Value=(data.Export$Value)*1000


###continue populating other columns
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB"
#assign sampledepth 
unique(data$Zsamp)
typeof(data$Zsamp)
data.Export$SampleDepth=data$Zsamp
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==FALSE)]) #check for missing depth values, should only occur for epi

#populate sampelposition
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
unique(data$Type)
length(data$Type[which(data$Type=="3")])#assume these are surface
length(data$Type[which(data$Type=="")])
length(data$Type[which(data$Type==" ")])
length(data$Type[which(data$Type==" ")])
length(data$Type[which(is.na(data$Type)==TRUE)])
data$Type=as.character(data$Type)
data.Export$SamplePosition[which(data$Type=="3")]="EPI"
data.Export$SamplePosition[which(data$Type=="surface")]="EPI"
data.Export$SamplePosition[which(data$Type=="Surface")]="EPI"
data.Export$SamplePosition[which(data$Type=="bottom")]="HYPO"
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="HYPO")])
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="UNKNOWN")])
unique(data.Export$SamplePosition)
14758+374

typeof(data.Export$SampleDepth)
unique(data.Export$SampleDepth)
data.Export$SampleDepth[which(data.Export$SampleDepth=="epi")]=0
data.Export$SampleDepth=as.numeric(data.Export$SampleDepth)
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType="UNKNOWN" #not specified in metadata
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable to nox
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "EPA_353.2r2"
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="EPA_353.2 Rev. 2.0"
data$Date=as.character(data$Date)
data.Export$DetectionLimit[which(data$Date < "1987-12-31")]= 50
data.Export$DetectionLimit[which(data$Date > "1987-12-31")]= 20
data.Export$DetectionLimit[which(data$Date > "2002-12-31")]= 10
unique(data.Export$DetectionLimit)
data.Export$Comments= "sample collected with a kemmerer bottle"
nox.Final = data.Export
rm(data)
rm(data.Export)

###################################  TN   #############################################################################################################################
data= NY_CSLAP
data = data[,c(1:4,6:7,11)]
data$TN=as.character(data$TN)
unique(data$TN) # blank cells, "#VALUE!", AND "!"  are the problematic "missing values" here.
length(data$TN[which(data$TN=="")]) #12908 are null
length(data$TN[which(data$TN=="#VALUE!")]) #362 have this special value, assuming this is null
length(data$TN[which(data$TN=="!")]) #2 have this value
12908+362+2 #remove 13272 observations
21092-13272 #should be left with 7820 obs.
data=data[which(data$TN!=""),] #remove null
data=data[which(data$TN!="#VALUE!"),] #remove null
data=data[which(data$TN!="!"),] #remove null
#left wtih 7820=good
unique(data$TN)
#look at the unique values in the Zsamp which is the sampling depth field
unique(data$Zsamp) #note that there several unique values
length(data$Zsamp[which(data$Zsamp=="not rec")]) #19
length(data$Zsamp[which(data$Zsamp=="not recorded")])#49
length(data$Zsamp[which(data$Zsamp=='"same"')])#5
length(data$Zsamp[which(data$Zsamp=="")])#1173
19+49+5+1173 #1246 values need to be removed
(7820-1246)/7820 #84% of data is kept, the rest discarded
data$Zsamp=as.character(data$Zsamp)
data$Zsamp[which(data$Zsamp=="not rec")]=9999
data$Zsamp[which(data$Zsamp=="not recorded")]=9999
data$Zsamp[which(data$Zsamp=='"same"')]=9999
data$Zsamp[which(data$Zsamp=="")]=9999
data$Zsamp[which(data$Zsamp==" ")]=9999
length(data$Zsamp[which(data$Zsamp=="9999")])
data$Zsamp[which(data$Zsamp=="9999")]=NA

#keep looking at special depth values that need to be dealt with
length(data$Zsamp[which(data$Zsamp=="surface")])#10
length(data$Zsamp[which(data$Zsamp=='"surface"')])#14
length(data$Zsamp[which(data$Zsamp=="\"surface\"")])#14
length(data$Zsamp[which(data$Zsamp=='\"surface\"')])#14
length(data$Zsamp[which(data$Zsamp=="1.5?")])#1
length(data$Zsamp[which(data$Zsamp=="epi")])#9
#first ignore ~ and ?
data$Zsamp[which(data$Zsamp=="1.5?")]=1.5 

#assign a depth of "0" to those that are "surface", deal with "epi" after assigning SamplePosition, set those that are "bottom" to the "zbot"
data$Zsamp[which(data$Zsamp=="surface")]=0
data$Zsamp[which(data$Zsamp=='"surface"')]=0
data$Zsamp[which(data$Zsamp=="\"surface\"")]=0
unique(data$Zsamp) #epi only unique now

#done with filtering populate lagos

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$LNum 
data.Export$LakeName = data$PName
data.Export$SourceVariableName = "TN"
data.Export$SourceVariableDescription = "Total nitrogen"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA 
#continue populating other lagos variables
data.Export$LagosVariableID = 21
data.Export$LagosVariableName="Nitrogen, total"

#populate CensorCode
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode="NC"
unique(data.Export$CensorCode)#should be only Nc

#populate TN obs.
data$TN=as.character(data$TN)
data.Export$Value=data$TN
unique(data.Export$Value)
data.Export$Value=as.numeric(data.Export$Value)
data.Export$Value=(data.Export$Value)*1000
unique(data.Export$Value)

###continue populating other columns
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB"
#assign sampledepth 
unique(data$Zsamp)
typeof(data$Zsamp)
data.Export$SampleDepth=data$Zsamp
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==FALSE)]) #check for missing depth values, should only occur for epi

#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
unique(data$Type)
length(data$Type[which(data$Type=="3")])#assume these are surface
length(data$Type[which(data$Type=="")])
length(data$Type[which(data$Type==" ")])
length(data$Type[which(data$Type==" ")])
length(data$Type[which(is.na(data$Type)==TRUE)])
data$Type=as.character(data$Type)
data.Export$SamplePosition[which(data$Type=="3")]="EPI"
data.Export$SamplePosition[which(data$Type=="surface")]="EPI"
data.Export$SamplePosition[which(data$Type=="Surface")]="EPI"
data.Export$SamplePosition[which(data$Type=="bottom")]="HYPO"
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="HYPO")])
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="UNKNOWN")])
unique(data.Export$SamplePosition)
7465+355


typeof(data.Export$SampleDepth)
unique(data.Export$SampleDepth)
data.Export$SampleDepth[which(data.Export$SampleDepth=="epi")]=0
data.Export$SampleDepth=as.numeric(data.Export$SampleDepth)
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType="UNKNOWN" #not specified in metadata
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable to tn
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "SM_204500NC"
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="SM_204500NC"
data.Export$DetectionLimit= 84 #per metadata
data.Export$Comments= "sample collected with a kemmerer bottle"
tn.Final=data.Export
rm(data)
rm(data.Export)

################################### Tot P #############################################################################################################################
data= NY_CSLAP
data = data[,c(1:4,6:8)]
data$Tot.P=as.character(data$Tot.P)
unique(data$Tot.P) #looking for values of TP that may represent null
length(data$Tot.P[which(is.na(data$Tot.P)==TRUE)]) #939 values are NA
#NA is the only unique TP value here
21092-939#remove 11934 observations
21092-11934 #should be left with 20153 obs.
data=data[which(is.na(data$Tot.P)==FALSE),] #remove null
#left wtih 20153=good
unique(data$Tot.P)
#look at the unique values in the Zsamp which is the sampling depth field
unique(data$Zsamp) #note that there several unique values
length(data$Zsamp[which(data$Zsamp=="not rec")]) #20
length(data$Zsamp[which(data$Zsamp=="not recorded")])#53
length(data$Zsamp[which(data$Zsamp=='"same"')])#5
length(data$Zsamp[which(data$Zsamp=="")])#2477
2477+5+53+20 #2555 values need to be removed
(20153-2555)/20153 #87% of data is kept, the rest discarded
data$Zsamp=as.character(data$Zsamp)
data$Zsamp[which(data$Zsamp=="not rec")]=9999
data$Zsamp[which(data$Zsamp=="not recorded")]=9999
data$Zsamp[which(data$Zsamp=='"same"')]=9999
data$Zsamp[which(data$Zsamp=="")]=9999
data$Zsamp[which(data$Zsamp==" ")]=9999
length(data$Zsamp[which(data$Zsamp=="9999")])
data$Zsamp[which(data$Zsamp=="9999")]=NA

#keep looking at special depth values that need to be dealt with
length(data$Zsamp[which(data$Zsamp=="surface")])#10
length(data$Zsamp[which(data$Zsamp=='"surface"')])#14
length(data$Zsamp[which(data$Zsamp=="\"surface\"")])#14
length(data$Zsamp[which(data$Zsamp=='\"surface\"')])#14
length(data$Zsamp[which(data$Zsamp=="bottom")])#3
length(data$Zsamp[which(data$Zsamp=='\"bottom\"')])#3
length(data$Zsamp[which(data$Zsamp=="26-30")])#1
length(data$Zsamp[which(data$Zsamp==">6")])#1
length(data$Zsamp[which(data$Zsamp=="1.5?")])#1
length(data$Zsamp[which(data$Zsamp=="~20")])#1
length(data$Zsamp[which(data$Zsamp=="epi")])#9
length(data$Zsamp[which(data$Zsamp=="21?(cant read)")])
length(data$Zsamp[which(data$Zsamp=='\"hypo\"')])
length(data$Zsamp[which(data$Zsamp=='\"deep\"')])
length(data$Zsamp[which(data$Zsamp=="hypo")])
length(data$Zsamp[which(data$Zsamp=="epi")])
length(data$Zsamp[which(data$Zsamp=="\"deep\"")])
#first ignore ~ and ?
data$Zsamp[which(data$Zsamp=="1.5?")]=1.5 
data$Zsamp[which(data$Zsamp=="~20")]= 20
data$Zsamp[which(data$Zsamp=="26-30")]= 28
data$Zsamp[which(data$Zsamp=="28+")]=28
data$Zsamp[which(data$Zsamp=="~18")]=18
data$Zsamp[which(data$Zsamp==".")]=21
data$Zsamp[which(data$Zsamp=="21?(cant read)")]=21
data$Zsamp[which(data$Zsamp=="30+")]=30

#assign a depth of "0" to those that are "surface", deal with "epi" after assigning SamplePosition, set those that are "bottom" to the "zbot"
data$Zsamp[which(data$Zsamp=="surface")]=0
data$Zsamp[which(data$Zsamp=='"surface"')]=0
data$Zsamp[which(data$Zsamp=="\"surface\"")]=0
data$Zsamp[which(data$Zsamp=="bottom")]=data$Zbot[which(data$Zsamp=="bottom")]
data$Zsamp[which(data$Zsamp=='\"bottom\"')]=data$Zbot[which(data$Zsamp=='\"bottom\"')]
data$Zsamp[which(data$Zsamp=='\"deep\"')]=data$Zbot[which(data$Zsamp=='\"deep\"')]
unique(data$Zsamp)#epi, hypo, deep, and "<6" should be the only unique values left in depth, deal with later
data$Zsamp[which(data$Zsamp=="\"hypo\"")]=NA
data$Zsamp[which(data$Zsamp=="hypo")]=NA
data$Zsamp[which(data$Zsamp=="epi")]=NA
data$Zsamp[which(data$Zsamp==">6")]="6"
unique(data$Zsamp)

#done with filtering populate lagos

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$LNum 
data.Export$LakeName = data$PName
data.Export$SourceVariableName = "Tot P"
data.Export$SourceVariableDescription = "Total phosphorus"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA 
#continue populating other lagos variables
data.Export$LagosVariableID = 27
data.Export$LagosVariableName="Phosphorus, total"

#populate CensorCode
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode="NC"
unique(data.Export$CensorCode)#check to make sure appropriate values


#populate obs
data.Export$Value=data$Tot.P
unique(data.Export$Value)
data.Export$Value=as.numeric(data.Export$Value)
data.Export$Value=(data.Export$Value)*1000
unique(data.Export$Value)
###continue populating other columns
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB"
#assign sampledepth 
unique(data$Zsamp)
typeof(data$Zsamp)
data.Export$SampleDepth=data$Zsamp
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==FALSE)]) #check for missing depth values, should only occur for epi

#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
unique(data$Type)
length(data$Type[which(data$Type=="3")])#assume these are surface
length(data$Type[which(data$Type=="")])
length(data$Type[which(data$Type==" ")])
length(data$Type[which(data$Type==" ")])
length(data$Type[which(is.na(data$Type)==TRUE)])
data$Type=as.character(data$Type)
data.Export$SamplePosition[which(data$Type=="3")]="EPI"
data.Export$SamplePosition[which(data$Type=="surface")]="EPI"
data.Export$SamplePosition[which(data$Type=="Surface")]="EPI"
data.Export$SamplePosition[which(data$Type=="bottom")]="HYPO"
data.Export$SamplePosition[which(data$Type=="Bottom")]="HYPO"
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="HYPO")])
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="UNKNOWN")])
unique(data.Export$SamplePosition)
16110+4043


typeof(data.Export$SampleDepth)
unique(data.Export$SampleDepth)
data.Export$SampleDepth[which(data.Export$SampleDepth=="epi")]=0
data.Export$SampleDepth=as.numeric(data.Export$SampleDepth)
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType="UNKNOWN" #not specified in metadata
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable to tp
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "SM_18204500PE"
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="SM_18204500PE"
data$Date=as.character(data$Date)
data.Export$DetectionLimit[which(data$Date < "2001-12-31")]=2 #per metadata
data.Export$DetectionLimit[which(data$Date > "2001-12-31")]= 1.2 #per metadata
data.Export$Comments= "sample collected with a kemmerer bottle"
tp.Final = data.Export
rm(data)
rm(data.Export)
###################################secchi-Zsd ###########################################################################
data= NY_CSLAP
data = data[,c(1:7,11)]
data$Zsd=as.character(data$Zsd)
unique(data$Zsd) # blank cells and "not rec" are the unique identifiers representing null here
length(data$Zsd[which(data$Zsd=="")]) #4287 are null
length(data$Zsd[which(data$Zsd==" ")]) #9 are null
4287+9+1 #remove 4297 observations
21092-4297#should be left with 16795 obs.
data=data[which(data$Zsd!=""),] #remove null
data=data[which(data$Zsd!="not rec"),] #remove null
data=data[which(data$Zsd!=" "),] #remove null
#left wtih 16795=good
unique(data$Zsd)

#done with filtering populate lagos

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$LNum 
data.Export$LakeName = data$PName
data.Export$SourceVariableName = "Zsd"
data.Export$SourceVariableDescription = "Secchi disk transparency, no view scopes"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA 
#continue populating other lagos variables
data.Export$LagosVariableID = 30
data.Export$LagosVariableName="Secchi"

#populate CensorCode
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode="NC"
unique(data.Export$CensorCode)#should be only NA

#populate secchi obs.
data.Export$Value=data$Zsd
length(data.Export$Value[which(is.na(data.Export$Value)==TRUE)]) #check to make sure none are null
###continue populating other columns
data.Export$Date = data$Date #date already in correct format
data.Export$Units="m"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="SPECIFIED"
data.Export$SampleDepth=NA
#continue populating other lagos fields
data.Export$BasinType="UNKNOWN" #not specified in metadata
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA 
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA
data.Export$Comments= NA
secchi.Final=data.Export
rm(data)
rm(data.Export)

####Final.Export###########
Final.Export=rbind(chla.Final,nh4.Final,nox.Final,secchi.Final,tcolor.Final,tn.Final,tp.Final)

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
237+101268#adds up to total

##Final export######################################
Final.Export1=data1
length(Final.Export1$Value[which(Final.Export1$Value<0)])
write.table(Final.Export1,file="DataImport_NY_CSLAP.csv",row.names=FALSE,sep=",")
nosamplepos=Final.Export1[which(is.na(Final.Export1$SampleDepth)==TRUE & Final.Export1$SamplePosition=="UNKNOWN"),]
#remove temporary data frames
rm(data1)
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/NY data/NY_CSLAP (finished)/DataImport_NY_CSLAP/DataImport_NY_CSLAP.RData")