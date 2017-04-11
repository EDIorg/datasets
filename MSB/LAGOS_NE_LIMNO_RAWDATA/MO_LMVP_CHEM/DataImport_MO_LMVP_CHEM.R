#set wd
setwd("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MO data/DataImport_MO_LMVP_CHEM")
setwd("C:/Users/Sam/Dropbox/CSI-LIMNO_DATA/DATA-lake/MO data/DataImport_MO_LMVP_CHEM")

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
#these data are from a volunteer lake monitoring program in missouri
#the primary interest is to 'measure' lake trophic status via chla along with N and P.
#samples from 1992-2010
###############################################################################################################################################
###################################  TN (mg/l)  #############################################################################################################################
data=lmvp_water_chem
names(data)
#check for nulls and filter out
length(data$TN..mg.l.[which(is.na(data$TN..mg.l.)==TRUE)])
length(data$TN..mg.l.[which(data$TN..mg.l.=="")])
8347-212#number remaining after filtering out null
data=data[which(data$TN..mg.l.!=""),]
#check for null lake ids
length(data$Site.Code[which(is.na(data$Site.Code)==TRUE)])
length(data$Site.Code[which(data$Site.Code=="")])
#no null site codes= good
unique(data$Media.Type)#filter out composite
unique(data$Sample.Type)#filter out fielddupl
length(data$Media.Type[which(data$Media.Type=="Water - Raw - Composite")])
length(data$Sample.Type[which(data$Sample.Type=="FieldDupl")])
8135-7#number remaining after filtering media and sample type (unwanted)
data=data[which(data$Media.Type!="Water - Raw - Composite"),]
data=data[which(data$Sample.Type!="FieldDupl"),]

#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID=data$Site.Code
unique(data.Export$LakeID)
length(data.Export$LakeID[which(data.Export$LakeID=="")])
#export lake name
data.Export$LakeName = data$Site.Name
#continue with other variables
data.Export$SourceVariableName = "TN (mg/l)"
data.Export$SourceVariableDescription = "Total nitrogen"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags= NA 
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 21
data.Export$LagosVariableName="Nitrogen, total"
#export values
typeof(data$TN..mg.l.)#convert from integer to numeric
unique(data$TN..mg.l.)
data$TN..mg.l.=as.character(data$TN..mg.l.)
length(data$TN..mg.l.[which(data$TN..mg.l.=="<2.0")])#censor these as LT
#export censor code
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$TN..mg.l.=="<2.0")]="LT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]="NC"
data$TN..mg.l.[which(data$TN..mg.l.=="<2.0")]="2.0"#overwrite <
#export values
unique(data$TN..mg.l.)
data$TN..mg.l.=as.numeric(data$TN..mg.l.)
data.Export$Value = data$TN..mg.l.*1000 #export and convert to ug/L
unique(data.Export$Value)
#continue exporting
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
#assign sampledepth 
unique(data$Depth..m.)
length(data$Depth..m.[which(data$Depth..m.=="0")])#528 have a depth of 0
length(data$Depth..m.[which(data$Depth..m.!="0")])#only 97 that aren't surface grab
length(data$Depth..m.[which(is.na(data$Depth..m.)==TRUE)])#SET these to depth of zero since these are supossed to be surface grab
data$Depth..m.[which(is.na(data$Depth..m.)==TRUE)]=0
unique(data$Depth..m.)
data.Export$SampleDepth=data$Depth..m.
#SAMPLE position
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(data.Export$SampleDepth==0)]="EPI"
data.Export$SamplePosition[which(data.Export$SampleDepth!=0)]="SPECIFIED"
unique(data.Export$SamplePosition)
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])#check to make sure most are epi
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")]) #check to make sure CORRECT NUMBER populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="APHA, Crumpton et al. 1992"
data.Export$DetectionLimit= 50 #meta specifies .05 mg/l = 50 ug/L
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments="Water samples were collected by volunteers by submerging sample bottle upside down elbow deep (or as deep as the volunteer could reach). These steps were repeated 2-5 more times. The water was combined in the bucket and then the volunteer filled the sample bottle from the bucket."
tn.Final = data.Export
rm(data.Export)
rm(data)

################################### TP (mg/l)   #############################################################################################################################
data=lmvp_water_chem
names(data)
#check for nulls and filter out
length(data$TP..mg.l.[which(is.na(data$TP..mg.l.)==TRUE)])
length(data$TP..mg.l.[which(data$TP..mg.l.=="")])
8347-216#number remaining after filtering out null
data=data[which(data$TP..mg.l.!=""),]
#check for null lake ids
length(data$Site.Code[which(is.na(data$Site.Code)==TRUE)])
length(data$Site.Code[which(data$Site.Code=="")])
#no null site codes= good
unique(data$Media.Type)#filter out composite
unique(data$Sample.Type)#filter out fielddupl
length(data$Media.Type[which(data$Media.Type=="Water - Raw - Composite")])
length(data$Sample.Type[which(data$Sample.Type=="FieldDupl")])
8131-7#number remaining after filtering media and sample type (unwanted)
data=data[which(data$Media.Type!="Water - Raw - Composite"),]
data=data[which(data$Sample.Type!="FieldDupl"),]

#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID=data$Site.Code
unique(data.Export$LakeID)
length(data.Export$LakeID[which(data.Export$LakeID=="")])
#export lake name
data.Export$LakeName = data$Site.Name
#continue with other variables
data.Export$SourceVariableName = "TP (mg/l)"
data.Export$SourceVariableDescription = "Total phosphorus"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags= NA 
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 27
data.Export$LagosVariableName="Phosphorus, total"
#export values
typeof(data$TP..mg.l.)#convert from integer to numeric
unique(data$TP..mg.l.)
data$TP..mg.l.=as.character(data$TP..mg.l.)
length(data$TP..mg.l.[which(data$TP..mg.l.=="<0.2")])#censor these as LT
length(data$TP..mg.l.[which(data$TP..mg.l.=="<0.06")])

#export censor code
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$TP..mg.l.=="<0.2")]="LT"
data.Export$CensorCode[which(data$TP..mg.l.=="<0.06")]="LT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]="NC"
data$TP..mg.l.[which(data$TP..mg.l.=="<0.2")]="0.2"#overwrite <
data$TP..mg.l.[which(data$TP..mg.l.=="<0.06")]="0.06"
#export values
unique(data$TP..mg.l.)
data$TP..mg.l.=as.numeric(data$TP..mg.l.)
data.Export$Value = data$TP..mg.l.*1000 #export and convert to ug/L
unique(data.Export$Value)
#continue exporting
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
#assign sampledepth 
unique(data$Depth..m.)
length(data$Depth..m.[which(data$Depth..m.=="0")])#528 have a depth of 0
length(data$Depth..m.[which(data$Depth..m.!="0")])#only 97 that aren't surface grab
length(data$Depth..m.[which(is.na(data$Depth..m.)==TRUE)])#SET these to depth of zero since these are supossed to be surface grab
data$Depth..m.[which(is.na(data$Depth..m.)==TRUE)]=0
unique(data$Depth..m.)
data.Export$SampleDepth=data$Depth..m.
#SAMPLE position
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(data.Export$SampleDepth==0)]="EPI"
data.Export$SamplePosition[which(data.Export$SampleDepth!=0)]="SPECIFIED"
unique(data.Export$SamplePosition)
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])#check to make sure most are epi
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")]) #check to make sure CORRECT NUMBER populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="Followed standard methods (APHA)"
data.Export$DetectionLimit= 2 #meta specifies
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments="Water samples were collected by volunteers by submerging sample bottle upside down elbow deep (or as deep as the volunteer could reach). These steps were repeated 2-5 more times. The water was combined in the bucket and then the volunteer filled the sample bottle from the bucket."
tp.Final = data.Export
rm(data.Export)
rm(data)

################################### ChlT (ug/l)   #############################################################################################################################
data=lmvp_water_chem
names(data)
#check for nulls and filter out
length(data$chla..ug.l.[which(is.na(data$chla..ug.l.)==TRUE)])
length(data$chla..ug.l.[which(data$chla..ug.l.=="")])
8347-326#number remaining after filtering out null
data=data[which(data$chla..ug.l.!=""),]
#check for null lake ids
length(data$Site.Code[which(is.na(data$Site.Code)==TRUE)])
length(data$Site.Code[which(data$Site.Code=="")])
#no null site codes= good
unique(data$Media.Type)#filter out composite
unique(data$Sample.Type)#filter out fielddupl
length(data$Media.Type[which(data$Media.Type=="Water - Raw - Composite")])
length(data$Sample.Type[which(data$Sample.Type=="FieldDupl")])
8021-7#number remaining after filtering media and sample type (unwanted)
data=data[which(data$Media.Type!="Water - Raw - Composite"),]
data=data[which(data$Sample.Type!="FieldDupl"),]

#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID=data$Site.Code
unique(data.Export$LakeID)
length(data.Export$LakeID[which(data.Export$LakeID=="")])
#export lake name
data.Export$LakeName = data$Site.Name
#continue with other variables
data.Export$SourceVariableName = "ChlT (ug/l)"
data.Export$SourceVariableDescription = "Chlorophyll a"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags= NA 
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 9
data.Export$LagosVariableName="Chlorophyll a"
#export values
typeof(data$chla..ug.l.)#convert from integer to numeric
unique(data$chla..ug.l.)
#export censor code
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode="NC" #no obs. are censored
unique(data.Export$CensorCode)
#export values
data.Export$Value = data$chla..ug.l.
unique(data.Export$Value)
#continue exporting
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
#assign sampledepth 
unique(data$Depth..m.)
length(data$Depth..m.[which(data$Depth..m.=="0")])#520 have a depth of 0
length(data$Depth..m.[which(data$Depth..m.!="0")])#only 97 that aren't surface grab
length(data$Depth..m.[which(is.na(data$Depth..m.)==TRUE)])#SET these to depth of zero since these are supossed to be surface grab
data$Depth..m.[which(is.na(data$Depth..m.)==TRUE)]=0
unique(data$Depth..m.)
data.Export$SampleDepth=data$Depth..m.
#SAMPLE position
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(data.Export$SampleDepth==0)]="EPI"
data.Export$SamplePosition[which(data.Export$SampleDepth!=0)]="SPECIFIED"
unique(data.Export$SamplePosition)
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])#check to make sure most are epi
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")]) #check to make sure CORRECT NUMBER populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="APHA, Sartory and Grobbelar, and Knowlton"
data.Export$DetectionLimit= 1 #meta specifies 
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments="Water samples were collected by volunteers by submerging sample bottle upside down elbow deep (or as deep as the volunteer could reach). These steps were repeated 2-5 more times. The water was combined in the bucket and then the volunteer filled the sample bottle from the bucket."
chla.Final = data.Export
rm(data.Export)
rm(data)


################################### Secchi (m)   #############################################################################################################################
data=lmvp_water_chem
names(data)
#check for nulls and filter out
length(data$Secchi..m.[which(is.na(data$Secchi..m.)==TRUE)])
length(data$Secchi..m.[which(data$Secchi..m.=="")])
8347-292#number remaining after filtering out null
data=data[which(data$Secchi..m.!=""),]
#check for null lake ids
length(data$Site.Code[which(is.na(data$Site.Code)==TRUE)])
length(data$Site.Code[which(data$Site.Code=="")])
#no null site codes= good
unique(data$Media.Type)#filter out composite
unique(data$Sample.Type)#filter out fielddupl
length(data$Media.Type[which(data$Media.Type=="Water - Raw - Composite")])
length(data$Sample.Type[which(data$Sample.Type=="FieldDupl")])
8055-8#number remaining after filtering media and sample type (unwanted)
data=data[which(data$Media.Type!="Water - Raw - Composite"),]
data=data[which(data$Sample.Type!="FieldDupl"),]

#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID=data$Site.Code
unique(data.Export$LakeID)
length(data.Export$LakeID[which(data.Export$LakeID=="")])
#export lake name
data.Export$LakeName = data$Site.Name
#continue with other variables
data.Export$SourceVariableName = "Secchi (m)"
data.Export$SourceVariableDescription = "Secchi"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags= NA 
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 30
data.Export$LagosVariableName="Secchi"
#export values
typeof(data$Secchi..m.)#convert from integer to numeric
unique(data$Secchi..m.)
data$Secchi..m.=as.character(data$Secchi..m.)
length(data$Secchi..m.[which(data$Secchi..m.=="<1.98")])
length(data$Secchi..m.[which(data$Secchi..m.=="<6.0")])
length(data$Secchi..m.[which(data$Secchi..m.=="<8.0")])
length(data$Secchi..m.[which(data$Secchi..m.==">4.27")])
length(data$Secchi..m.[which(data$Secchi..m.=="<2.0")])
#censor those accordingly
#export censor code
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$Secchi..m.=="<1.98")]="LT"
data.Export$CensorCode[which(data$Secchi..m.=="<6.0")]="LT"
data.Export$CensorCode[which(data$Secchi..m.=="<8.0")]="LT"
data.Export$CensorCode[which(data$Secchi..m.==">4.27")]="GT"
data.Export$CensorCode[which(data$Secchi..m.=="<2.0")]="LT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]="NC"
unique(data.Export$CensorCode)
#overwrite characters
data$Secchi..m.[which(data$Secchi..m.=="<1.98")]="1.98"
data$Secchi..m.[which(data$Secchi..m.=="<6.0")]="6.0"
data$Secchi..m.[which(data$Secchi..m.=="<8.0")]="8.0"
data$Secchi..m.[which(data$Secchi..m.==">4.27")]="4.27"
data$Secchi..m.[which(data$Secchi..m.=="<2.0")]="2.0"
#export values
unique(data$Secchi..m.)
data$Secchi..m.=as.numeric(data$Secchi..m.)
data.Export$Value = data$Secchi..m.
unique(data.Export$Value)
#continue exporting
data.Export$Date = data$Date #date already in correct format
data.Export$Units="m"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")])
#assign sampledepth 
data.Export$SampleDepth=NA
#SAMPLE position
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="SPECIFIED"
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")]) #check to make sure CORRECT NUMBER populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #meta specifies 
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments= NA
secchi.Final = data.Export
rm(data.Export)
rm(data)

###################################### final export ########################################################################################
Final.Export = rbind(tn.Final,tp.Final,chla.Final,secchi.Final)
################################################################################################################################################
nosamplepos=Final.Export[which(is.na(Final.Export$SampleDepth)==TRUE & Final.Export$SamplePosition=="UNKNOWN"),]
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
17+32296#adds up to total
##write table
Final.Export1=data1
typeof(Final.Export1$Value)
length(Final.Export1$Value[which(Final.Export1$Value<0)])
write.table(Final.Export1,file="DataImport_MO_LMVP.csv",row.names=FALSE,sep=",")

save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MO data/DataImport_MO_LMVP_CHEM/DataImport_MO_LMVP_CHEM.RData")
