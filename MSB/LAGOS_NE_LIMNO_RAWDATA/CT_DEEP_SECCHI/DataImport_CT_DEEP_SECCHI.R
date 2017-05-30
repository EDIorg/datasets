#set path to files
setwd("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/CT data/CT_ENH/CT_Secchi_finished/DataImport_CT_DEEP_SECCHI")
setwd("C:/Users/Sam/Dropbox/CSI-LIMNO_DATA/DATA-lake/CT data/CT_ENH/CT_Secchi_finished/DataImport_CT_DEEP_SECCHI")

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
#only secchi disk obs. imported here. some w/ view scope, and some w/o view scope, some view scope unknown
###########################################################################################################################################################################################
################################### Transparency (Water column)      #############################################################################################################################
data=ct_deep_secchi
length(data$ChemParameter[which(data$ChemParameter=="transparency")]) #267 of the obs are just transparency
unique(data$ChemParameter)#look at parameters
#pull out parameter of interest
length(data$ChemParameter[which(data$ChemParameter=="Transparency (Water column)")]) #check no. of observations
data=data[which(data$ChemParameter=="Transparency (Water column)"),]
unique(data$value)#look at data for problematic values
#check for null observations
length(data$value[which(data$value=="")])
length(data$value[which(is.na(data$value)==TRUE)])
data=data[which(is.na(data$value)==FALSE),]#filter out two null values
#no null sample depths
#check units
unique(data$unit)#all meters=good
#check to see if obs. are flagged as less than detection limit
unique(data$lessthan)#none flagged


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
unique(data$unit)
data.Export$Value=data$value #export obs, all in meters the preff unit
unique(data.Export$Value)
unique(data$lessthan)#check to see if obs. is less than dl, if it is "TRUE" then censor as "LT", set all others to not censored "NT"
data.Export$CensorCode = "NC" #none censored
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
data.Export$SampleDepth= NA #not applicable to secchi
unique(data.Export$SampleDepth)
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
data.Export$MethodInfo = "SECCHI_VIEW_UNKNOWN" #per emi's meta
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #per meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
unique(data.Export$Comments)
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
secchi.Final = data.Export
rm(data)
rm(data.Export)

################################### transparency    #############################################################################################################################
data=ct_deep_secchi
unique(data$ChemParameter)#look at parameters
#pull out parameter of interest
length(data$ChemParameter[which(data$ChemParameter=="transparency")]) #check no. of observations
data=data[which(data$ChemParameter=="transparency"),]
unique(data$value)#look at data for problematic values
#check for null observations
length(data$value[which(data$value=="")])
length(data$value[which(is.na(data$value)==TRUE)])
#no null values
#check units
unique(data$unit)#note that different units are used, convert those of feet to meters
#check to see if obs. are flagged as less than detection limit
unique(data$lessthan)#none flagged, all false


#proceed to populating LAGOS template


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$basinid
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$StreamName.FacilityName
data.Export$SourceVariableName = "transparency"
data.Export$SourceVariableDescription = "Secchi depth (unknown if view scope was used)"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no flags w/ these data
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 30
data.Export$LagosVariableName="Secchi"
names(data)
unique(data$unit)
print(data[which(data$unit=="feet"),])#look at the values to confirm feet, values look like feet
print(data[which(data$unit=="Feet"),])
length(data$unit[which(data$unit=="feet")])#convert these to m
length(data$unit[which(data$unit=="Feet")])#convert these to m
91+29#120 need to be converted
data.Export$Value[which(data$unit=="feet")]=data$value[which(data$unit=="feet")]*0.3048
data.Export$Value[which(data$unit=="Feet")]=data$value[which(data$unit=="Feet")]*0.3048
data.Export$Value[which(data$unit=="meters")]=data$value[which(data$unit=="meters")]
data.Export$Value[which(data$unit=="m")]=data$value[which(data$unit=="m")]
data.Export$Value=round(data.Export$Value,digits=4)
unique(data.Export$Value)
unique(data$lessthan)#check to see if obs. is less than dl, if it is "TRUE" then censor as "LT", set all others to not censored "NT"
data.Export$CensorCode = "NC" #none censored
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
data.Export$SampleDepth= NA #not applicable to secchi
unique(data.Export$SampleDepth)
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
data.Export$MethodInfo = "SECCHI_VIEW_UNKNOWN" #per emi's meta
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #per meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
unique(data.Export$Comments)
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
secchi1.Final = data.Export
rm(data)
rm(data.Export)

################################### Transparency (Water column) no tube    #############################################################################################################################
data=ct_deep_secchi
unique(data$ChemParameter)#look at parameters
#pull out parameter of interest
length(data$ChemParameter[which(data$ChemParameter=="Transparency (Water column) no tube")]) #check no. of observations
data=data[which(data$ChemParameter=="Transparency (Water column) no tube"),]
unique(data$value)#look at data for problematic values
#check for null observations
length(data$value[which(data$value=="")])
length(data$value[which(is.na(data$value)==TRUE)])
data=data[which(is.na(data$value)==FALSE),]#remove 1 null obs.
#check units
unique(data$unit)#all meters=good
#check to see if obs. are flagged as less than detection limit
unique(data$lessthan)#none flagged, all false


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
unique(data$unit)
data.Export$Value=data$value#export obs. already in preff units of meters
unique(data.Export$Value)
unique(data$lessthan)#check to see if obs. is less than dl, if it is "TRUE" then censor as "LT", set all others to not censored "NT"
data.Export$CensorCode = "NC" #none censored
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
data.Export$SampleDepth= NA #not applicable to secchi
unique(data.Export$SampleDepth)
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
data.Export$MethodInfo = NA #per emi's meta
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #per meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
unique(data.Export$Comments)
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
secchi2.Final = data.Export
rm(data)
rm(data.Export)

###################################  Transparency (Water column) with tube   #############################################################################################################################
data=ct_deep_secchi
unique(data$ChemParameter)#look at parameters
#pull out parameter of interest
length(data$ChemParameter[which(data$ChemParameter=="Transparency (Water column) with tube")]) #check no. of observations
data=data[which(data$ChemParameter=="Transparency (Water column) with tube"),]
unique(data$value)#look at data for problematic values
#check for null observations
length(data$value[which(data$value=="")])
length(data$value[which(is.na(data$value)==TRUE)])
#no obs are null
#check units
unique(data$unit)#all meters=good
#check to see if obs. are flagged as less than detection limit
unique(data$lessthan)#none flagged, all false


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
unique(data$unit)
data.Export$Value=data$value#export obs. already in preff units of meters
unique(data.Export$Value)
unique(data$lessthan)#check to see if obs. is less than dl, if it is "TRUE" then censor as "LT", set all others to not censored "NT"
data.Export$CensorCode = "NC" #none censored
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
data.Export$SampleDepth= NA #not applicable to secchi
unique(data.Export$SampleDepth)
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
data.Export$MethodInfo = "SECCHI_VIEW" #per emi's meta
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #per meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
unique(data.Export$Comments)
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
secchi3.Final = data.Export
rm(data)
rm(data.Export)
###################################### final export ########################################################################################
Final.Export = rbind(secchi.Final,secchi1.Final,secchi2.Final,secchi3.Final)
#####################################################################
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
23+294#adds up to total
##write table
Final.Export1=data1
typeof(Final.Export1$Value)
length(Final.Export1$Value[which(Final.Export1$Value<0)])
nosamplepos=Final.Export1[which(is.na(Final.Export1$SampleDepth)==TRUE & Final.Export1$SamplePosition=="UNKNOWN"),]
write.table(Final.Export1,file="DataImport_CT_DEEP_SECCHI.csv",row.names=FALSE,sep=",")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/CT data/CT_ENH/CT_Secchi_finished/DataImport_CT_DEEP_SECCHI/DataImport_CT_DEEP_SECCHI.RData")
