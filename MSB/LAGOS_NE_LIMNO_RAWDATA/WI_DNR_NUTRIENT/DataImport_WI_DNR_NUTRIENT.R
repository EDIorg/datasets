#SET WD
setwd("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/WI data/WI DNR Data (Finished)/New Data/DataImport_WI_DNR_NUTRIENT")
setwd("C:/Users/Sam/Dropbox/CSI-LIMNO_DATA/DATA-lake/WI data/WI DNR Data (Finished)/New Data/DataImport_WI_DNR_NUTRIENT")

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
#data from the WDNR WQ database= SWIMS
#data collected under a variety of different projects
#much of the data is collected by citizen monitors
#
###############################################################################################################################################
###################################  DOC  #############################################################################################################################
data=WT_SWIMS_MONIT_STATION
names(data)
data=data[,c(1,2,6,12,13:18,39:42)]
names(data)
unique(data$DOC)# the DOC result
unique(data$DOC.Amt)#this is what we want to export as the value
length(data$DOC.Amt[which(is.na(data$DOC.Amt)==TRUE)])
length(data$DOC.Amt[which(data$DOC.Amt=="")])
#filter out null observations
202414-201733 #number of observations that should remain
data=data[which(is.na(data$DOC.Amt)==FALSE),]
unique(data$DOC.Units) #only one unit specified = really good!
unique(data$DOC.Comm) #populate comments field with these comments
unique(data$START_AMT)
length(data$START_AMT[which(is.na(data$START_AMT)==TRUE)]) #296 NULL FOR START SAMPLE DEPTH
unique(data$END_AMT)
length(data$END_AMT[which(is.na(data$END_AMT)==TRUE)])#655 NULL FOR END SAMPLE DEPTH (OR START)
temp.df=data[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==TRUE),] #296 observations null for both depths, sample depth=NA, position= "EPI"
rm(temp.df)
#no other filtering to be done


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID=data$Waterbody.ID.Code..WBIC.
unique(data.Export$LakeID)
length(data.Export$LakeID[which(data.Export$LakeID=="")])
length(data.Export$LakeID[which(is.na(data.Export$LakeID)==TRUE)])# 5 observations missing unique lake id
#export lake name
data.Export$LakeName = data$Official.Lakel.Name
#continue with other variables
data.Export$SourceVariableName = "DOC"
data.Export$SourceVariableDescription = "Dissolved Organic Carbon"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
unique(data$DOC.Comm)
data.Export$SourceFlags[grep("MM1",data$DOC.Comm,ignore.case=TRUE)]="See analytical file"
data.Export$SourceFlags[grep("Sample Rec'd",data$DOC.Comm ,ignore.case=TRUE)] = "Sample not acidified"
data.Export$SourceFlags[grep("Sample was not acidified",data$DOC.Comm ,ignore.case=TRUE)] = "Sample not acidified"
data.Export$SourceFlags[grep("sample was acidified",data$DOC.Comm ,ignore.case=TRUE)] = "Sample not acidified"
data.Export$SourceFlags[grep("holding time",data$DOC.Comm ,ignore.case=TRUE)] = "Holding time exceeded"
data.Export$SourceFlags[grep("sample was",data$DOC.Comm ,ignore.case=TRUE)] = "Sample received to warm"
unique(data.Export$SourceFlags)
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 6
data.Export$LagosVariableName="Carbon, dissolved organic"
#export values
typeof(data$DOC.Amt)
data.Export$Value = data$DOC.Amt
unique(data.Export$Value)
#continue exporting
data.Export$CensorCode = "NC" #no info on CensorCode
data.Export$Date = data$Date #date already in correct format
unique(data$Date)
data.Export$Units="mg/L"
#assign sampledepth 
length(data$DOC.Amt[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==TRUE)]) #this corresponds to the null observations
length(data$DOC.Amt[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==FALSE)]) #this corresponds to the integrated observations
length(data$DOC.Amt[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==FALSE)])
length(data$DOC.Amt[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==TRUE)])#this corresponds to the grab observations
296+359+26 #adds up to the total
data.Export$SampleDepth[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==TRUE)]=NA
data.Export$SampleDepth[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==FALSE)]= data$END_AMT[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==FALSE)] #integrated samples have bottom depth end amt
data.Export$SampleDepth[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==TRUE)]=data$START_AMT[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==TRUE)] #grab sample with start amount = depth
unique(data.Export$SampleDepth)
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])#check to make sure correct number of na obs.
#assign sample position
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"
unique(data.Export$SamplePosition)
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==TRUE)]="GRAB"
data.Export$SampleType[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==FALSE)]= "INTEGRATED"
data.Export$SampleType[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==TRUE)]="GRAB"
unique(data.Export$SampleType)
#check to make sure correct number of each
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")])
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")]) #check to make sure CORRECT NUMBER populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #not specified in meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
unique(data.Export$Comments)
doc.Final = data.Export
rm(data.Export)
rm(data)

###################################  Chlorophyll A   #############################################################################################################################
data=WT_SWIMS_MONIT_STATION
names(data)
data=data[,c(1,2,6,12,13:18,35:38)]
names(data)
unique(data$Chlorophll.A)# the text version of resutls
unique(data$Chlorophll.A.Amt)# the numeric result, this is what we want to export as the value
length(data$Chlorophll.A.Amt[which(is.na(data$Chlorophll.A.Amt)==TRUE)])
length(data$Chlorophll.A.Amt[which(data$Chlorophll.A.Amt=="")])
#filter out null observations
202414-174843 #number of observations that should remain
data=data[which(is.na(data$Chlorophll.A.Amt)==FALSE),]
unique(data$UNIT_CODE) #feet and meters expressed here, handle depths accordingly
length(data$UNIT_CODE[which(data$UNIT_CODE=="")])
temp.df=data[which(data$UNIT_CODE==""),]
unique(temp.df$START_AMT)#no upper depth
unique(temp.df$END_AMT)#no lower depth
#those null unit code observations have no sample depth so it isn't an issue
unique(data$Chlorophyll.A.Comm) #populate comments field and source flags with these comments
unique(data$START_AMT)
unique(data$END_AMT)
temp.df=data[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==TRUE),] #296 observations null for both depths, sample depth=NA, position= "EPI"
rm(temp.df)
#no other filtering to be done


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID=data$Waterbody.ID.Code..WBIC.
unique(data.Export$LakeID)
length(data.Export$LakeID[which(data.Export$LakeID=="")])
length(data.Export$LakeID[which(is.na(data.Export$LakeID)==TRUE)])# 143 observations missing unique lake id
#export lake name
data.Export$LakeName = data$Official.Lakel.Name
#continue with other variables
data.Export$SourceVariableName = "Chlorophyll A"
data.Export$SourceVariableDescription = "Chlorophyll a"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
unique(data$Chlorophyll.A.Comm)
data.Export$SourceFlags[grep("DUPLICATE QC EXCEEDED",data$Chlorophyll.A.Comm,ignore.case=TRUE)]="Duplicate QC exceeded, result is reported as an average"
data.Export$SourceFlags[grep("holding time",data$Chlorophyll.A.Comm,ignore.case=TRUE)]="Holding time exceeded"
data.Export$SourceFlags[grep("volume filtered",data$Chlorophyll.A.Comm,ignore.case=TRUE)]="Volume filtered not provided, assumed to be 200 milliliters"
data.Export$SourceFlags[grep("improper filter",data$Chlorophyll.A.Comm,ignore.case=TRUE)]="Improper filter, result is approximate"
data.Export$SourceFlags[grep("ice",data$Chlorophyll.A.Comm,ignore.case=TRUE)]="Sample not preserved on ice, result is approximate"
unique(data.Export$SourceFlags)
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 9
data.Export$LagosVariableName="Chlorophyll a"
#export values
typeof(data$Chlorophll.A.Amt)
data.Export$Value = data$Chlorophll.A.Amt
unique(data$Chlorophyll.A.Units)#all micro grams per liter the preferreed units
unique(data.Export$Value)
#continue exporting
data.Export$CensorCode = "NC" #no info on CensorCode
data.Export$Date = data$Date #date already in correct format
unique(data$Date)
data.Export$Units="ug/L"
# convert those sample depths of feet to meters
data$START_AMT[which(data$UNIT_CODE=="FEET")]=data$START_AMT[which(data$UNIT_CODE=="FEET")]* 0.3048
data$END_AMT[which(data$UNIT_CODE=="FEET")]=data$END_AMT[which(data$UNIT_CODE=="FEET")]* 0.3048
unique(data$UNIT_CODE)
unique(data$START_AMT)
unique(data$END_AMT)
#assign sampledepth 
length(data$Chlorophll.A.Amt[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==TRUE)]) #this corresponds to the null observations
length(data$Chlorophll.A.Amt[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==FALSE)]) #this corresponds to the integrated observations
length(data$Chlorophll.A.Amt[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==FALSE)])#this is a grab obs
length(data$Chlorophll.A.Amt[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==TRUE)])#this corresponds to the grab observations
3419+2886+1+21265 #adds up to the total
data.Export$SampleDepth[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==TRUE)]=NA
data.Export$SampleDepth[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==FALSE)]= data$END_AMT[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==FALSE)] #integrated samples have bottom depth end amt
data.Export$SampleDepth[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==TRUE)]=data$START_AMT[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==TRUE)] #grab sample with start amount = depth
data.Export$SampleDepth[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==FALSE)]=data$END_AMT[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==FALSE)] #grab sample with start amount = depth
unique(data.Export$SampleDepth)
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])#check to make sure correct number of na obs.
#assign sample position
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(is.na(data.Export$SampleDepth)==TRUE)]="EPI"
data.Export$SamplePosition[which(is.na(data.Export$SampleDepth)==FALSE)]="SPECIFIED"
unique(data.Export$SamplePosition)
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==TRUE)]="GRAB"
data.Export$SampleType[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==FALSE)]= "INTEGRATED"
data.Export$SampleType[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==TRUE)]="GRAB"
data.Export$SampleType[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==FALSE)]="GRAB"
unique(data.Export$SampleType)
#check to make sure correct number of each
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")])
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")]) #check to make sure CORRECT NUMBER populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #not specified in meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
unique(data.Export$Comments)
chla.Final = data.Export
rm(data.Export)
rm(data)

################################### Color-PT-CO/Color Units  #############################################################################################################################
data=WT_SWIMS_MONIT_STATION
names(data)
data=data[,c(1,2,6,12,13:18,43:47)]
names(data)
unique(data$Color)# the text version of resutls, note that there are observations that need to be censored
unique(data$Color.Amt)# the numeric result, this is what we want to export as the value
length(data$Color.Amt[which(is.na(data$Color.Amt)==TRUE)])
length(data$Color.Amt[which(data$Color.Amt=="")])
#filter out null observations
202414-198729 #number of observations that should remain
data=data[which(is.na(data$Color.Amt)==FALSE),]
unique(data$UNIT_CODE) #feet and meters expressed here, handle depths accordingly
length(data$UNIT_CODE[which(data$UNIT_CODE=="")])
temp.df=data[which(data$UNIT_CODE==""),]
unique(temp.df$START_AMT)#no upper depth
unique(temp.df$END_AMT)#no lower depth
#those null unit code observations have no sample depth so it isn't an issue
unique(data$Color.Units)
length(data$Color.Units[which(data$Color.Units=="PT-CO")])
length(data$Color.Units[which(data$Color.Units=="COLOR UNITS")])
401+88 #FILTER these out
data=data[which(data$Color.Units!="SU"),]
unique(data$Color.Comm) #no comments that needed to be added to source flag or comments field
unique(data$START_AMT)
unique(data$END_AMT)
temp.df=data[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==TRUE),] #111 observations null for both depths, sample depth=NA, position= "EPI"
rm(temp.df)
#no other filtering to be done


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID=data$Waterbody.ID.Code..WBIC.
unique(data.Export$LakeID)
length(data.Export$LakeID[which(data.Export$LakeID=="")])
length(data.Export$LakeID[which(is.na(data.Export$LakeID)==TRUE)])# 3 observations missing unique lake id
#export lake name
data.Export$LakeName = data$Official.Lakel.Name
#continue with other variables
data.Export$SourceVariableName = "Color"
data.Export$SourceVariableDescription = "True color"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
unique(data$Color.Comm)#no source flags that need to be exported
data.Export$SourceFlags=NA
unique(data.Export$SourceFlags)
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 12
data.Export$LagosVariableName="Color, true"
#export values
typeof(data$Color.Amt)
data.Export$Value = data$Color.Amt
unique(data$Color.Units)#all PCU the preferred units
unique(data.Export$Value)
#continue exporting
data.Export$CensorCode=as.character(data.Export$CensorCode)
unique(data$Color)#note the observations that need to be censored
length(grep("<",data$Color,ignore.case=TRUE))#1 LT
length(grep(">",data$Color,ignore.case=TRUE))#0 GT
data.Export$CensorCode[grep("<",data$Color,ignore.case=TRUE)]="LT"
data.Export$CensorCode[grep(">",data$Color,ignore.case=TRUE)]="GT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]="NC"
unique(data.Export$CensorCode)
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure correct number
data.Export$Date = data$Date #date already in correct format
unique(data$Date)
data.Export$Units="PCU"
# convert those sample depths of feet to meters
data$START_AMT[which(data$UNIT_CODE=="FEET")]=data$START_AMT[which(data$UNIT_CODE=="FEET")]* 0.3048
data$END_AMT[which(data$UNIT_CODE=="FEET")]=data$END_AMT[which(data$UNIT_CODE=="FEET")]* 0.3048
unique(data$UNIT_CODE)
unique(data$START_AMT)
unique(data$END_AMT)
#assign sampledepth 
length(data$Color.Amt[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==TRUE)]) #this corresponds to the null observations
length(data$Color.Amt[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==FALSE)]) #this corresponds to the integrated observations
length(data$Color.Amt[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==FALSE)])#this is a grab obs
length(data$Color.Amt[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==TRUE)])#this corresponds to the grab observations
111+378 #adds up to the total
data.Export$SampleDepth[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==TRUE)]=NA
data.Export$SampleDepth[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==FALSE)]= data$END_AMT[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==FALSE)] #integrated samples have bottom depth end amt
data.Export$SampleDepth[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==TRUE)]=data$START_AMT[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==TRUE)] #grab sample with start amount = depth
data.Export$SampleDepth[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==FALSE)]=data$END_AMT[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==FALSE)] #grab sample with start amount = depth
unique(data.Export$SampleDepth)
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])#check to make sure correct number of na obs.
#assign sample position
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"
unique(data.Export$SamplePosition)
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==TRUE)]="GRAB"
data.Export$SampleType[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==FALSE)]= "INTEGRATED"
data.Export$SampleType[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==TRUE)]="GRAB"
data.Export$SampleType[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==FALSE)]="GRAB"
unique(data.Export$SampleType)
#check to make sure correct number of each
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")])
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")]) #check to make sure CORRECT NUMBER populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #not specified in meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
unique(data.Export$Comments)
color1.Final = data.Export
rm(data.Export)
rm(data)

################################### Color-SU  #############################################################################################################################
data=WT_SWIMS_MONIT_STATION
names(data)
data=data[,c(1,2,6,12,13:18,43:47)]
names(data)
unique(data$Color)# the text version of resutls, note that there are observations that need to be censored
unique(data$Color.Amt)# the numeric result, this is what we want to export as the value
length(data$Color.Amt[which(is.na(data$Color.Amt)==TRUE)])
length(data$Color.Amt[which(data$Color.Amt=="")])
#filter out null observations
202414-198729 #number of observations that should remain
data=data[which(is.na(data$Color.Amt)==FALSE),]
unique(data$UNIT_CODE) #feet and meters expressed here, handle depths accordingly
length(data$UNIT_CODE[which(data$UNIT_CODE=="")])
temp.df=data[which(data$UNIT_CODE==""),]
unique(temp.df$START_AMT)#no upper depth
unique(temp.df$END_AMT)#no lower depth
#those null unit code observations have no sample depth so it isn't an issue
unique(data$Color.Units)
length(data$Color.Units[which(data$Color.Units=="SU")])
#FILTER these out
data=data[which(data$Color.Units=="SU"),]
unique(data$Color.Comm) #now there are many comments that need to exported to the source flags field
unique(data$START_AMT)
unique(data$END_AMT)
temp.df=data[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==TRUE),] #409 observations null for both depths, sample depth=NA, position= "EPI"
rm(temp.df)
#no other filtering to be done


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID=data$Waterbody.ID.Code..WBIC.
unique(data.Export$LakeID)
length(data.Export$LakeID[which(data.Export$LakeID=="")])
length(data.Export$LakeID[which(is.na(data.Export$LakeID)==TRUE)])# 14 observations missing unique lake id
#export lake name
data.Export$LakeName = data$Official.Lakel.Name
#continue with other variables
data.Export$SourceVariableName = "Color"
data.Export$SourceVariableDescription = "True color"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
unique(data$Color.Comm)#no source flags that need to be exported
data.Export$SourceFlags[grep("DUPLICATE QC EXCEEDED",data$Color.Comm,ignore.case=TRUE)]="Duplicate QC exceeded, result is reported as an average"
data.Export$SourceFlags[grep("holding time",data$Color.Comm,ignore.case=TRUE)]="Holding time exceeded"
data.Export$SourceFlags[grep("NO COLLECTION DATE",data$Color.Comm,ignore.case=TRUE)]="No collection date listed, result is approximate"
data.Export$SourceFlags[grep("volume filtered",data$Color.Comm,ignore.case=TRUE)]="Volume filtered not provided, assumed to be 200 milliliters"
data.Export$SourceFlags[grep("improper filter",data$Color.Comm,ignore.case=TRUE)]="Improper filter, result is approximate"
data.Export$SourceFlags[grep("ice",data$Color.Comm,ignore.case=TRUE)]="Sample not preserved on ice, result is approximate"
unique(data.Export$SourceFlags)
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA
#continue populating other lagos variables
data.Export$LagosVariableID = 12
data.Export$LagosVariableName="Color, true"
#export values
typeof(data$Color.Amt)
data.Export$Value = data$Color.Amt
unique(data$Color.Units)#all PCU the preferred units
unique(data.Export$Value)
#continue exporting
data.Export$CensorCode=as.character(data.Export$CensorCode)
unique(data$Color)#note the observations that need to be censored
length(grep("<",data$Color,ignore.case=TRUE))#51 LT
length(grep(">",data$Color,ignore.case=TRUE))#32 GT
data.Export$CensorCode[grep("<",data$Color,ignore.case=TRUE)]="LT"
data.Export$CensorCode[grep(">",data$Color,ignore.case=TRUE)]="GT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]="NC"
unique(data.Export$CensorCode)
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure correct number
data.Export$Date = data$Date #date already in correct format
unique(data$Date)
data.Export$Units="PCU"
# convert those sample depths of feet to meters
data$START_AMT[which(data$UNIT_CODE=="FEET")]=data$START_AMT[which(data$UNIT_CODE=="FEET")]* 0.3048
data$END_AMT[which(data$UNIT_CODE=="FEET")]=data$END_AMT[which(data$UNIT_CODE=="FEET")]* 0.3048
unique(data$UNIT_CODE)
unique(data$START_AMT)
unique(data$END_AMT)
#assign sampledepth 
length(data$Color.Amt[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==TRUE)]) #this corresponds to the null observations
length(data$Color.Amt[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==FALSE)]) #this corresponds to the integrated observations
length(data$Color.Amt[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==FALSE)])#this is a grab obs
length(data$Color.Amt[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==TRUE)])#this corresponds to the grab observations
409+552+2+2233 #adds up to the total
data.Export$SampleDepth[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==TRUE)]=NA
data.Export$SampleDepth[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==FALSE)]= data$END_AMT[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==FALSE)] #integrated samples have bottom depth end amt
data.Export$SampleDepth[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==TRUE)]=data$START_AMT[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==TRUE)] #grab sample with start amount = depth
data.Export$SampleDepth[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==FALSE)]=data$END_AMT[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==FALSE)] #grab sample with start amount = depth
unique(data.Export$SampleDepth)
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])#check to make sure correct number of na obs.
#assign sample position
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"
unique(data.Export$SamplePosition)
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==TRUE)]="GRAB"
data.Export$SampleType[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==FALSE)]= "INTEGRATED"
data.Export$SampleType[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==TRUE)]="GRAB"
data.Export$SampleType[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==FALSE)]="GRAB"
unique(data.Export$SampleType)
#check to make sure correct number of each
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")])
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")]) #check to make sure CORRECT NUMBER populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #not specified in meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
unique(data.Export$Comments)
color2.Final = data.Export
rm(data.Export)
rm(data)

################################### Nitrogen NO3+NO2 DISS  #############################################################################################################################
data=WT_SWIMS_MONIT_STATION
names(data)
data=data[,c(1,2,6,12,13:18,31:34)]
names(data)
unique(data$NITR.NO3.NO2.DISS..AS.N.)# filter out those that were not detected or nd
unique(data$NITR.NO3.NO2.DISS..AS.N..Amt)# the numeric result, this is what we want to export as the value
length(data$NITR.NO3.NO2.DISS..AS.N..Amt[which(is.na(data$NITR.NO3.NO2.DISS..AS.N..Amt)==TRUE)])
length(data$NITR.NO3.NO2.DISS..AS.N..Amt[which(data$NITR.NO3.NO2.DISS..AS.N..Amt=="")])
#filter out null observations
202414-193338 #number of observations that should remain
data=data[which(is.na(data$NITR.NO3.NO2.DISS..AS.N..Amt)==FALSE),]
length(grep("nd",data$NITR.NO3.NO2.DISS..AS.N.,ignore.case=TRUE))#filter out these 33 obs. that are not detected
data$NITR.NO3.NO2.DISS..AS.N.=as.character(data$NITR.NO3.NO2.DISS..AS.N.)
data$NITR.NO3.NO2.DISS..AS.N.[grep("nd",data$NITR.NO3.NO2.DISS..AS.N.,ignore.case=TRUE)]="-99999"
length(data$NITR.NO3.NO2.DISS..AS.N.[which(data$NITR.NO3.NO2.DISS..AS.N.=="-99999")])
9076-33# number remaining after filtering out not detected
data=data[which(data$NITR.NO3.NO2.DISS..AS.N.!="-99999"),]#filter out not detected obs.
unique(data$UNIT_CODE) #feet and meters expressed here, handle depths accordingly
length(data$UNIT_CODE[which(data$UNIT_CODE=="")])
temp.df=data[which(data$UNIT_CODE==""),]
unique(temp.df$START_AMT)#no upper depth
unique(temp.df$END_AMT)#no lower depth
#those null unit code observations have no sample depth so it isn't an issue
unique(data$NITR.NO3.NO2.DISS..AS.N..Units)#all mg/l which is good
unique(data$NITR.NO3.NO2.DISS..AS.N..Comm) #now there are many comments that need to exported to the source flags field
unique(data$START_AMT)
unique(data$END_AMT)
temp.df=data[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==TRUE),] #1453 observations null for both depths, sample depth=NA, position= "EPI"
rm(temp.df)
#no other filtering to be done


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID=data$Waterbody.ID.Code..WBIC.
unique(data.Export$LakeID)
length(data.Export$LakeID[which(data.Export$LakeID=="")])
length(data.Export$LakeID[which(is.na(data.Export$LakeID)==TRUE)])# 167 observations missing unique lake id
#export lake name
data.Export$LakeName = data$Official.Lakel.Name
#continue with other variables
data.Export$SourceVariableName = "Nitrogen NO3+NO2 DISS"
data.Export$SourceVariableDescription = "Nitrate + Nitrite Nitrogen (filtered)"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
unique(data$NITR.NO3.NO2.DISS..AS.N..Comm)#no source flags that need to be exported
data.Export$SourceFlags[grep("DUPLICATE QC EXCEEDED",data$NITR.NO3.NO2.DISS..AS.N..Comm,ignore.case=TRUE)]="Duplicate QC exceeded, result is reported as an average"
data.Export$SourceFlags[grep("holding time",data$NITR.NO3.NO2.DISS..AS.N..Comm,ignore.case=TRUE)]="Holding time exceeded"
data.Export$SourceFlags[grep("NO COLLECTION DATE",data$NITR.NO3.NO2.DISS..AS.N..Comm,ignore.case=TRUE)]="No collection date listed, result is approximate"
data.Export$SourceFlags[grep("volume filtered",data$NITR.NO3.NO2.DISS..AS.N..Comm,ignore.case=TRUE)]="Volume filtered not provided, assumed to be 200 milliliters"
data.Export$SourceFlags[grep("improper filter",data$NITR.NO3.NO2.DISS..AS.N..Comm,ignore.case=TRUE)]="Improper filter, result is approximate"
data.Export$SourceFlags[grep("ice",data$NITR.NO3.NO2.DISS..AS.N..Comm,ignore.case=TRUE)]="Sample not preserved on ice, result is approximate"
data.Export$SourceFlags[grep("spike",data$NITR.NO3.NO2.DISS..AS.N..Comm,ignore.case=TRUE)]="Quality control spike exceeded"
data.Export$SourceFlags[grep("blank",data$NITR.NO3.NO2.DISS..AS.N..Comm,ignore.case=TRUE)]="Filter blank greater than limit of detection"
data.Export$SourceFlags[grep("matrix problem",data$NITR.NO3.NO2.DISS..AS.N..Comm,ignore.case=TRUE)]="Matrix problem, higher detection limit reported"
unique(data.Export$SourceFlags)
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA
#continue populating other lagos variables
data.Export$LagosVariableID = 18
data.Export$LagosVariableName="Nitrogen, nitrite (NO2) + nitrate (NO3)"
#export values
typeof(data$NITR.NO3.NO2.DISS..AS.N..Amt)
data.Export$Value = data$NITR.NO3.NO2.DISS..AS.N..Amt*1000
unique(data$NITR.NO3.NO2.DISS..AS.N..Units)#all mg/l == good
unique(data.Export$Value)
#continue exporting
data.Export$CensorCode=as.character(data.Export$CensorCode)
unique(data$NITR.NO3.NO2.DISS..AS.N.)#note the observations that need to be censored
length(grep("<",data$NITR.NO3.NO2.DISS..AS.N.,ignore.case=TRUE))#51 LT
length(grep(">",data$NITR.NO3.NO2.DISS..AS.N.,ignore.case=TRUE))#32 GT
data.Export$CensorCode[grep("<",data$NITR.NO3.NO2.DISS..AS.N.,ignore.case=TRUE)]="LT"
data.Export$CensorCode[grep(">",data$NITR.NO3.NO2.DISS..AS.N.,ignore.case=TRUE)]="GT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]="NC"
unique(data.Export$CensorCode)
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure correct number
data.Export$Date = data$Date #date already in correct format
unique(data$Date)
data.Export$Units="ug/L"
# convert those sample depths of feet to meters
data$START_AMT[which(data$UNIT_CODE=="FEET")]=data$START_AMT[which(data$UNIT_CODE=="FEET")]* 0.3048
data$END_AMT[which(data$UNIT_CODE=="FEET")]=data$END_AMT[which(data$UNIT_CODE=="FEET")]* 0.3048
unique(data$UNIT_CODE)
unique(data$START_AMT)
unique(data$END_AMT)
#assign sampledepth 
length(data$NITR.NO3.NO2.DISS..AS.N..Amt[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==TRUE)]) #this corresponds to the null observations
length(data$NITR.NO3.NO2.DISS..AS.N..Amt[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==FALSE)]) #this corresponds to the integrated observations
length(data$NITR.NO3.NO2.DISS..AS.N..Amt[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==FALSE)])#this is a grab obs
length(data$NITR.NO3.NO2.DISS..AS.N..Amt[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==TRUE)])#this corresponds to the grab observations
1453+344+1+7245 #adds up to the total
data.Export$SampleDepth[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==TRUE)]=NA
data.Export$SampleDepth[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==FALSE)]= data$END_AMT[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==FALSE)] #integrated samples have bottom depth end amt
data.Export$SampleDepth[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==TRUE)]=data$START_AMT[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==TRUE)] #grab sample with start amount = depth
data.Export$SampleDepth[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==FALSE)]=data$END_AMT[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==FALSE)] #grab sample with start amount = depth
unique(data.Export$SampleDepth)
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])#check to make sure correct number of na obs.
#assign sample position
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(is.na(data.Export$SampleDepth)==TRUE)]="EPI"
data.Export$SamplePosition[which(is.na(data.Export$SampleDepth)==FALSE)]="SPECIFIED"
unique(data.Export$SamplePosition)
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==TRUE)]="GRAB"
data.Export$SampleType[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==FALSE)]= "INTEGRATED"
data.Export$SampleType[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==TRUE)]="GRAB"
data.Export$SampleType[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==FALSE)]="GRAB"
unique(data.Export$SampleType)
#check to make sure correct number of each
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")])
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")]) #check to make sure CORRECT NUMBER populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #not specified in meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
unique(data.Export$Comments)
no3no2.Final = data.Export
rm(data.Export)
rm(data)


###################################  Nitrogen Kjeldahl Total     #############################################################################################################################
data=WT_SWIMS_MONIT_STATION
names(data)
data=data[,c(1,2,6,12,13:18,23:26)]
names(data)
unique(data$NITROGEN.KJELDAHL.TOTAL)# filter out those that were not detected or nd
unique(data$NITROGEN.KJELDAHL.TOTAL.Amt)# the numeric result, this is what we want to export as the value
length(data$NITROGEN.KJELDAHL.TOTAL.Amt[which(is.na(data$NITROGEN.KJELDAHL.TOTAL.Amt)==TRUE)])
length(data$NITROGEN.KJELDAHL.TOTAL.Amt[which(data$NITROGEN.KJELDAHL.TOTAL.Amt=="")])
#filter out null observations
202414-188971 #number of observations that should remain
data=data[which(is.na(data$NITROGEN.KJELDAHL.TOTAL.Amt)==FALSE),]
length(grep("nd",data$NITROGEN.KJELDAHL.TOTAL,ignore.case=TRUE))#don't have to worry about not detected observations here.
unique(data$UNIT_CODE) #feet and meters expressed here, handle depths accordingly
length(data$UNIT_CODE[which(data$UNIT_CODE=="")])
temp.df=data[which(data$UNIT_CODE==""),]
unique(temp.df$START_AMT)#no upper depth
unique(temp.df$END_AMT)#no lower depth
#those null unit code observations have no sample depth so it isn't an issue
unique(data$NITROGEN.KJELDAHL.TOTAL.Units)#all mg/l which is good
unique(data$NITROGEN.KJELDAHL.TOTAL.Comm) #now there are many comments that need to exported to the source flags field
unique(data$START_AMT)
unique(data$END_AMT)
temp.df=data[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==TRUE),] #1749 observations null for both depths, sample depth=NA, position= "EPI"
rm(temp.df)
#no other filtering to be done


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID=data$Waterbody.ID.Code..WBIC.
unique(data.Export$LakeID)
length(data.Export$LakeID[which(data.Export$LakeID=="")])
length(data.Export$LakeID[which(is.na(data.Export$LakeID)==TRUE)])# 151 observations missing unique lake id
#export lake name
data.Export$LakeName = data$Official.Lakel.Name
#continue with other variables
data.Export$SourceVariableName = "Nitrogen Kjeldahl Total"
data.Export$SourceVariableDescription = "Total Nitrogen (kjedahl method)"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
unique(data$NITROGEN.KJELDAHL.TOTAL.Comm)#no source flags that need to be exported
data.Export$SourceFlags[grep("DUPLICATE QC EXCEEDED",data$NITROGEN.KJELDAHL.TOTAL.Comm,ignore.case=TRUE)]="Duplicate QC exceeded, result is reported as an average"
data.Export$SourceFlags[grep("QC EXCEEDED",data$NITROGEN.KJELDAHL.TOTAL.Comm,ignore.case=TRUE)]="Duplicate QC exceeded, result is reported as an average"
data.Export$SourceFlags[grep("holding time",data$NITROGEN.KJELDAHL.TOTAL.Comm,ignore.case=TRUE)]="Holding time exceeded"
data.Export$SourceFlags[grep("Analyzed past",data$NITROGEN.KJELDAHL.TOTAL.Comm,ignore.case=TRUE)]="Holding time exceeded"
data.Export$SourceFlags[grep("NO COLLECTION DATE",data$NITROGEN.KJELDAHL.TOTAL.Comm,ignore.case=TRUE)]="No collection date listed, result is approximate"
data.Export$SourceFlags[grep("volume filtered",data$NITROGEN.KJELDAHL.TOTAL.Comm,ignore.case=TRUE)]="Volume filtered not provided, assumed to be 200 milliliters"
data.Export$SourceFlags[grep("improper filter",data$NITROGEN.KJELDAHL.TOTAL.Comm,ignore.case=TRUE)]="Improper filter, result is approximate"
data.Export$SourceFlags[grep("ice",data$NITROGEN.KJELDAHL.TOTAL.Comm,ignore.case=TRUE)]="Sample not preserved on ice, result is approximate"
data.Export$SourceFlags[grep("spike",data$NITROGEN.KJELDAHL.TOTAL.Comm,ignore.case=TRUE)]="Quality control spike exceeded"
data.Export$SourceFlags[grep("blank",data$NITROGEN.KJELDAHL.TOTAL.Comm,ignore.case=TRUE)]="Filter blank greater than limit of detection"
data.Export$SourceFlags[grep("matrix problem",data$NITROGEN.KJELDAHL.TOTAL.Comm,ignore.case=TRUE)]="Matrix problem, higher detection limit reported"
data.Export$SourceFlags[grep("quality control problem",data$NITROGEN.KJELDAHL.TOTAL.Comm,ignore.case=TRUE)]="Quality control problem, result is approximate"
unique(data.Export$SourceFlags)
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA
#continue populating other lagos variables
data.Export$LagosVariableID = 16
data.Export$LagosVariableName="Nitrogen, total Kjeldahl"
#export values
typeof(data$NITROGEN.KJELDAHL.TOTAL.Amt)
data.Export$Value = data$NITROGEN.KJELDAHL.TOTAL.Amt*1000
unique(data$NITROGEN.KJELDAHL.TOTAL.Units)#all mg/l == good
unique(data.Export$Value)
#continue exporting
data.Export$CensorCode=as.character(data.Export$CensorCode)
unique(data$NITROGEN.KJELDAHL.TOTAL)#note the observations that need to be censored
length(grep("<",data$NITROGEN.KJELDAHL.TOTAL,ignore.case=TRUE))#51 LT
length(grep(">",data$NITROGEN.KJELDAHL.TOTAL,ignore.case=TRUE))#32 GT
data.Export$CensorCode[grep("<",data$NITROGEN.KJELDAHL.TOTAL,ignore.case=TRUE)]="LT"
data.Export$CensorCode[grep(">",data$NITROGEN.KJELDAHL.TOTAL,ignore.case=TRUE)]="GT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]="NC"
unique(data.Export$CensorCode)
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure correct number
data.Export$Date = data$Date #date already in correct format
unique(data$Date)
data.Export$Units="ug/L"
# convert those sample depths of feet to meters
data$START_AMT[which(data$UNIT_CODE=="FEET")]=data$START_AMT[which(data$UNIT_CODE=="FEET")]* 0.3048
data$END_AMT[which(data$UNIT_CODE=="FEET")]=data$END_AMT[which(data$UNIT_CODE=="FEET")]* 0.3048
unique(data$UNIT_CODE)
unique(data$START_AMT)
unique(data$END_AMT)
#assign sampledepth 
length(data$NITROGEN.KJELDAHL.TOTAL.Amt[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==TRUE)]) #this corresponds to the null observations
length(data$NITROGEN.KJELDAHL.TOTAL.Amt[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==FALSE)]) #this corresponds to the integrated observations
length(data$NITROGEN.KJELDAHL.TOTAL.Amt[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==FALSE)])#this is a grab obs
length(data$NITROGEN.KJELDAHL.TOTAL.Amt[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==TRUE)])#this corresponds to the grab observations
1749+947+3+10744 #adds up to the total
data.Export$SampleDepth[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==TRUE)]=NA
data.Export$SampleDepth[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==FALSE)]= data$END_AMT[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==FALSE)] #integrated samples have bottom depth end amt
data.Export$SampleDepth[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==TRUE)]=data$START_AMT[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==TRUE)] #grab sample with start amount = depth
data.Export$SampleDepth[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==FALSE)]=data$END_AMT[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==FALSE)] #grab sample with start amount = depth
unique(data.Export$SampleDepth)
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])#check to make sure correct number of na obs.
#assign sample position
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(is.na(data.Export$SampleDepth)==TRUE)]="EPI"
data.Export$SamplePosition[which(is.na(data.Export$SampleDepth)==FALSE)]="SPECIFIED"
unique(data.Export$SamplePosition)
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==TRUE)]="GRAB"
data.Export$SampleType[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==FALSE)]= "INTEGRATED"
data.Export$SampleType[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==TRUE)]="GRAB"
data.Export$SampleType[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==FALSE)]="GRAB"
unique(data.Export$SampleType)
#check to make sure correct number of each
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")])
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")]) #check to make sure CORRECT NUMBER populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #not specified in meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
unique(data.Export$Comments)
tkn.Final = data.Export
rm(data.Export)
rm(data)

###################################  Total Phosphorus    #############################################################################################################################
data=WT_SWIMS_MONIT_STATION
names(data)
data=data[,c(1,2,6,12,13:18,19:22)]
names(data)
unique(data$Total.Phosphorus)# filter out those that were not detected or nd
unique(data$Total.Phosphorus.Amt)# the numeric result, this is what we want to export as the value
length(data$Total.Phosphorus.Amt[which(is.na(data$Total.Phosphorus.Amt)==TRUE)])
length(data$Total.Phosphorus.Amt[which(data$Total.Phosphorus.Amt=="")])
#filter out null observations
202414-145896 #number of observations that should remain
data=data[which(is.na(data$Total.Phosphorus.Amt)==FALSE),]
length(grep("nd",data$Total.Phosphorus,ignore.case=TRUE))#filter these out
data$Total.Phosphorus=as.character(data$Total.Phosphorus)
data$Total.Phosphorus[grep("nd",data$Total.Phosphorus,ignore.case=TRUE)]="-99999"
length(data$Total.Phosphorus[which(data$Total.Phosphorus=="-99999")])
56518-16# number remaining after filtering out not detected
data=data[which(data$Total.Phosphorus!="-99999"),]#filter out not detected obs.
unique(data$UNIT_CODE) #feet and meters expressed here, handle depths accordingly
length(data$UNIT_CODE[which(data$UNIT_CODE=="")])
temp.df=data[which(data$UNIT_CODE==""),]
unique(temp.df$START_AMT)#no upper depth
unique(temp.df$END_AMT)#no lower depth
#those null unit code observations have no sample depth so it isn't an issue
unique(data$Total.Phosphorus.Units)#all mg/l and ug/l make sure you don't convert all
length(data$Total.Phosphorus.Units[which(data$Total.Phosphorus.Units=="UG/L")])#these don't need to be converted
unique(data$Total.Phosphorus.Comm) #now there are many comments that need to exported to the source flags field
unique(data$START_AMT)
unique(data$END_AMT)
temp.df=data[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==TRUE),] #7575 observations null for both depths, sample depth=NA, position= "EPI"
rm(temp.df)
#no other filtering to be done


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID=data$Waterbody.ID.Code..WBIC.
unique(data.Export$LakeID)
length(data.Export$LakeID[which(data.Export$LakeID=="")])
length(data.Export$LakeID[which(is.na(data.Export$LakeID)==TRUE)])# 457 observations missing unique lake id
#export lake name
data.Export$LakeName = data$Official.Lakel.Name
#continue with other variables
data.Export$SourceVariableName = "Total Phosphorus"
data.Export$SourceVariableDescription = "Total phosphorus"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
unique(data$Total.Phosphorus.Comm)#no source flags that need to be exported
data.Export$SourceFlags[grep("DUPLICATE QC EXCEEDED",data$Total.Phosphorus.Comm.Comm,ignore.case=TRUE)]="Duplicate QC exceeded, result is reported as an average"
data.Export$SourceFlags[grep("QC EXCEEDED",data$Total.Phosphorus.Comm,ignore.case=TRUE)]="Duplicate QC exceeded, result is reported as an average"
data.Export$SourceFlags[grep("holding time",data$Total.Phosphorus.Comm,ignore.case=TRUE)]="Holding time exceeded"
data.Export$SourceFlags[grep("Analyzed past",data$Total.Phosphorus.Comm,ignore.case=TRUE)]="Holding time exceeded"
data.Export$SourceFlags[grep("NO COLLECTION DATE",data$Total.Phosphorus.Comm,ignore.case=TRUE)]="No collection date listed, result is approximate"
data.Export$SourceFlags[grep("volume filtered",data$Total.Phosphorus.Comm,ignore.case=TRUE)]="Volume filtered not provided, assumed to be 200 milliliters"
data.Export$SourceFlags[grep("improper filter",data$Total.Phosphorus.Comm,ignore.case=TRUE)]="Improper filter, result is approximate"
data.Export$SourceFlags[grep("ice",data$Total.Phosphorus.Comm,ignore.case=TRUE)]="Sample not preserved on ice, result is approximate"
data.Export$SourceFlags[grep("standard temp",data$Total.Phosphorus.Comm,ignore.case=TRUE)]="Sample not preserved on ice, result is approximate"
data.Export$SourceFlags[grep("spike",data$Total.Phosphorus.Comm,ignore.case=TRUE)]="Quality control spike exceeded"
data.Export$SourceFlags[grep("blank",data$Total.Phosphorus.Comm,ignore.case=TRUE)]="Filter blank greater than limit of detection"
data.Export$SourceFlags[grep("matrix problem",data$Total.Phosphorus.Comm,ignore.case=TRUE)]="Matrix problem, higher detection limit reported"
data.Export$SourceFlags[grep("quality control problem",data$Total.Phosphorus.Comm,ignore.case=TRUE)]="Quality control problem, result is approximate"
unique(data.Export$SourceFlags)
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA
#continue populating other lagos variables
data.Export$LagosVariableID = 27
data.Export$LagosVariableName="Phosphorus, total"
#export values
typeof(data$Total.Phosphorus.Amt)
unique(data$Total.Phosphorus.Units) #have to convert only those w/ units of mg/l to ug/l
length(data$Total.Phosphorus.Units[which(data$Total.Phosphorus.Units=="MG/L AS P")])
length(data$Total.Phosphorus.Units[which(data$Total.Phosphorus.Units=="MG/L")])
length(data$Total.Phosphorus.Units[which(data$Total.Phosphorus.Units=="UG/L")])
343+56085+74#adds up to total
unique(data$Total.Phosphorus.Amt)
data$Total.Phosphorus.Amt[which(data$Total.Phosphorus.Units=="MG/L")]=data$Total.Phosphorus.Amt[which(data$Total.Phosphorus.Units=="MG/L")]*1000
data$Total.Phosphorus.Amt[which(data$Total.Phosphorus.Units=="MG/L AS P")]=data$Total.Phosphorus.Amt[which(data$Total.Phosphorus.Units=="MG/L AS P")]*1000
unique(data$Total.Phosphorus.Amt)
typeof(data$Total.Phosphorus.Amt)
data.Export$Value=data$Total.Phosphorus.Amt
unique(data.Export$Value)
#continue exporting
data.Export$CensorCode=as.character(data.Export$CensorCode)
unique(data$Total.Phosphorus)#note the observations that need to be censored
length(grep("<",data$Total.Phosphorus,ignore.case=TRUE))#51 LT
length(grep(">",data$Total.Phosphorus,ignore.case=TRUE))#32 GT
data.Export$CensorCode[grep("<",data$Total.Phosphorus,ignore.case=TRUE)]="LT"
data.Export$CensorCode[grep(">",data$Total.Phosphorus,ignore.case=TRUE)]="GT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]="NC"
unique(data.Export$CensorCode)
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure correct number
data.Export$Date = data$Date #date already in correct format
unique(data$Date)
data.Export$Units="ug/L"
# convert those sample depths of feet to meters
data$START_AMT[which(data$UNIT_CODE=="FEET")]=data$START_AMT[which(data$UNIT_CODE=="FEET")]* 0.3048
data$END_AMT[which(data$UNIT_CODE=="FEET")]=data$END_AMT[which(data$UNIT_CODE=="FEET")]* 0.3048
unique(data$UNIT_CODE)
unique(data$START_AMT)
unique(data$END_AMT)
#assign sampledepth 
length(data$Total.Phosphorus.Amt[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==TRUE)]) #this corresponds to the null observations
length(data$Total.Phosphorus.Amt[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==FALSE)]) #this corresponds to the integrated observations
length(data$Total.Phosphorus.Amt[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==FALSE)])#this is a grab obs
length(data$Total.Phosphorus.Amt[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==TRUE)])#this corresponds to the grab observations
7575+4254+4+44669 #adds up to the total
data.Export$SampleDepth[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==TRUE)]=NA
data.Export$SampleDepth[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==FALSE)]= data$END_AMT[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==FALSE)] #integrated samples have bottom depth end amt
data.Export$SampleDepth[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==TRUE)]=data$START_AMT[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==TRUE)] #grab sample with start amount = depth
data.Export$SampleDepth[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==FALSE)]=data$END_AMT[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==FALSE)] #grab sample with start amount = depth
unique(data.Export$SampleDepth)
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])#check to make sure correct number of na obs.
#assign sample position
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(is.na(data.Export$SampleDepth)==TRUE)]="EPI"
data.Export$SamplePosition[which(is.na(data.Export$SampleDepth)==FALSE)]="SPECIFIED"
unique(data.Export$SamplePosition)
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==TRUE)]="GRAB"
data.Export$SampleType[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==FALSE)]= "INTEGRATED"
data.Export$SampleType[which(is.na(data$START_AMT)==FALSE & is.na(data$END_AMT)==TRUE)]="GRAB"
data.Export$SampleType[which(is.na(data$START_AMT)==TRUE & is.na(data$END_AMT)==FALSE)]="GRAB"
unique(data.Export$SampleType)
#check to make sure correct number of each
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")])
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")]) #check to make sure CORRECT NUMBER populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #not specified in meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
unique(data.Export$Comments)
tp.Final = data.Export
rm(data.Export)
rm(data)

###################################  Secchi all     #############################################################################################################################
data=WT_SWIMS_MONIT_STATION
names(data)
data=data[,c(1,2,6,12,13:18,48:52)]
names(data)
unique(data$Secchi.Feet)# the numeric result, this is what we want to export as the value
unique(data$Secchi.Feet.Units)#note these observations will all have to be converted to meters
unique(data$Secchi.Meters)
unique(data$Secchi.Meters.Units) #observations will all have to be converted to meters
both.secchi.df=data[which(data$Secchi.Feet!="" & data$Secchi.Meters!=""),] #shows the number of observations that have a secchi observation in meters and feet on same date
sec.ft=data[which(data$Secchi.Feet!="" & data$Secchi.Meters==""),]
sec.meters=data[which(data$Secchi.Feet=="" & data$Secchi.Meters!=""),]
143809+9759#should end up with this number of observations

#process sec.ft and sec.meters separately

###############sec.ft#######################################################################################
data.Export= LAGOS_Template
data.Export[1:nrow(sec.ft),]=NA
data.Export$LakeID=sec.ft$Waterbody.ID.Code..WBIC.
unique(data.Export$LakeID)
length(data.Export$LakeID[which(data.Export$LakeID=="")])
length(data.Export$LakeID[which(is.na(data.Export$LakeID)==TRUE)])# 403 observations missing unique lake id
#export lake name
data.Export$LakeName = sec.ft$Official.Lakel.Name
#continue with other variables
data.Export$SourceVariableName = "Secchi Feet"
data.Export$SourceVariableDescription = "Secchi units of Feet"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
unique(sec.ft$Secchi.Hit.Bottom)#no source flags that need to be exported
length(sec.ft$Secchi.Hit.Bottom[which(sec.ft$Secchi.Hit.Bottom=="90")])#assume this is an error overwrite as NO
length(sec.ft$Secchi.Hit.Bottom[which(sec.ft$Secchi.Hit.Bottom=="95")])#assume this is an error overwrite as NO
length(sec.ft$Secchi.Hit.Bottom[which(sec.ft$Secchi.Hit.Bottom=="N0")])#overwrite as NO
length(sec.ft$Secchi.Hit.Bottom[which(sec.ft$Secchi.Hit.Bottom=="N")])#chagne to NO
length(sec.ft$Secchi.Hit.Bottom[which(sec.ft$Secchi.Hit.Bottom=="Y")])#change to YES
length(sec.ft$Secchi.Hit.Bottom[which(sec.ft$Secchi.Hit.Bottom=="YES")])
length(sec.ft$Secchi.Hit.Bottom[which(sec.ft$Secchi.Hit.Bottom=="NO")])
sec.ft$Secchi.Hit.Bottom[which(sec.ft$Secchi.Hit.Bottom=="90")]="NO"
sec.ft$Secchi.Hit.Bottom[which(sec.ft$Secchi.Hit.Bottom=="95")]="NO"
sec.ft$Secchi.Hit.Bottom[which(sec.ft$Secchi.Hit.Bottom=="N0")]="NO"
sec.ft$Secchi.Hit.Bottom[which(sec.ft$Secchi.Hit.Bottom=="N")]="NO"
sec.ft$Secchi.Hit.Bottom[which(sec.ft$Secchi.Hit.Bottom=="Y")]="YES"
unique(sec.ft$Secchi.Hit.Bottom)#export these as source flags
data.Export$SourceFlags=sec.ft$Secchi.Hit.Bottom
unique(data.Export$SourceFlags)
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 30
data.Export$LagosVariableName="Secchi"
#export values, but censor first
typeof(sec.ft$Secchi.Feet)
unique(sec.ft$Secchi.Feet)
#continue exporting
data.Export$CensorCode=as.character(data.Export$CensorCode)
length(grep("<",sec.ft$Secchi.Feet,ignore.case=TRUE))#1 LT
length(grep(">",sec.ft$Secchi.Feet,ignore.case=TRUE))#13 GT
data.Export$CensorCode[grep("<",sec.ft$Secchi.Feet,ignore.case=TRUE)]="LT"
data.Export$CensorCode[grep(">",sec.ft$Secchi.Feet,ignore.case=TRUE)]="GT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]="NC"
unique(data.Export$CensorCode)
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure correct number
length(data.Export$CensorCode[which(data.Export$CensorCode=="GT")])
#overwrite the < and >
sec.ft$Secchi.Feet[which(sec.ft$Secchi.Feet=="<1.0")]=1.0
sec.ft$Secchi.Feet[which(sec.ft$Secchi.Feet==">20.0")]=20.0
sec.ft$Secchi.Feet[which(sec.ft$Secchi.Feet==">5.5")]=5.5
sec.ft$Secchi.Feet[which(sec.ft$Secchi.Feet==">6.0")]=6.0
sec.ft$Secchi.Feet[which(sec.ft$Secchi.Feet==">5.0")]=5.0
sec.ft$Secchi.Feet[which(sec.ft$Secchi.Feet==">9.5")]=9.5
sec.ft$Secchi.Feet[which(sec.ft$Secchi.Feet==">9.0")]=9.0
sec.ft$Secchi.Feet[which(sec.ft$Secchi.Feet==">10.0")]=10.0
length(grep(">",sec.ft$Secchi.Feet,ignore.case=TRUE))
length(grep("<",sec.ft$Secchi.Feet,ignore.case=TRUE))
#now convert all to meters
unique(sec.ft$Secchi.Feet.Units)
length(sec.ft$Secchi.Feet.Units[which(sec.ft$Secchi.Feet.Units=="FEET")])
length(sec.ft$Secchi.Feet.Units[which(sec.ft$Secchi.Feet.Units=="FT")])
length(sec.ft$Secchi.Feet.Units[which(sec.ft$Secchi.Feet.Units=="METERS")])
length(sec.ft$Secchi.Feet.Units[which(sec.ft$Secchi.Feet.Units=="M")])
length(sec.ft$Secchi.Feet.Units[which(sec.ft$Secchi.Feet.Units=="CM")])
#make conversions
unique(sec.ft$Secchi.Feet)
sec.ft$Secchi.Feet=as.character(sec.ft$Secchi.Feet)
unique(sec.ft$Secchi.Feet)
sec.ft$Secchi.Feet=as.numeric(sec.ft$Secchi.Feet)
unique(sec.ft$Secchi.Feet)
sec.ft$Secchi.Feet[which(sec.ft$Secchi.Feet.Units=="FEET")]=sec.ft$Secchi.Feet[which(sec.ft$Secchi.Feet.Units=="FEET")]*0.3048
sec.ft$Secchi.Feet[which(sec.ft$Secchi.Feet.Units=="FT")]=sec.ft$Secchi.Feet[which(sec.ft$Secchi.Feet.Units=="FT")]*0.3048
sec.ft$Secchi.Feet[which(sec.ft$Secchi.Feet.Units=="CM")]=sec.ft$Secchi.Feet[which(sec.ft$Secchi.Feet.Units=="CM")]*0.01
unique(sec.ft$Secchi.Feet)
data.Export$Value=sec.ft$Secchi.Feet
unique(data.Export$Value)
data.Export$Date = sec.ft$Date #date already in correct format
unique(data$Date)
data.Export$Units="m"
#assign sampledepth 
data.Export$SampleDepth=NA # sample depth na for secchi
unique(data.Export$SampleDepth)
#assign sample position
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="SPECIFIED"# PER import protocol for secchi
unique(data.Export$SamplePosition)
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED"
unique(data.Export$SampleType)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")]) #check to make sure CORRECT NUMBER populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #not specified in meta
data.Export$Comments=as.character(data.Export$Comments)
unique(data.Export$SourceFlags)
data.Export$Comments[which(data.Export$SourceFlags=="NO")]="NO= Secchi disk did not hit bottom"
data.Export$Comments[which(data.Export$SourceFlags=="YES")]="YES= Secchi disk hit bottom"
unique(data.Export$Comments)
secft.Final = data.Export
rm(data.Export)


###############ft.correct.df#######################################################################################
unique(sec.meters$Secchi.Meters.Units)
unique(sec.meters$Secchi.Meters)#where foot is attached make sur eyou convert to meters
ft.correct=sec.meters[grep("f",sec.meters$Secchi.Meters,ignore.case=TRUE),]#these say meters but are actually feet process separately
data.Export= LAGOS_Template
unique(ft.correct$Secchi.Meters)
length(ft.correct$Secchi.Meters[which(ft.correct$Secchi.Meters=="**")])
data.Export[1:nrow(ft.correct),]=NA
data.Export$LakeID=ft.correct$Waterbody.ID.Code..WBIC.
unique(data.Export$LakeID)
length(data.Export$LakeID[which(data.Export$LakeID=="")])
length(data.Export$LakeID[which(is.na(data.Export$LakeID)==TRUE)])#6 observations missing unique lake id
#export lake name
data.Export$LakeName = ft.correct$Official.Lakel.Name
#continue with other variables
data.Export$SourceVariableName = "Secchi Meters"
data.Export$SourceVariableDescription = "Secchi units of Meters"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
unique(ft.correct$Secchi.Hit.Bottom)
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=ft.correct$Secchi.Hit.Bottom
data.Export$SourceFlags[which(data.Export$SourceFlags=="")]=NA
unique(data.Export$SourceFlags)
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA
#continue populating other lagos variables
data.Export$LagosVariableID = 30
data.Export$LagosVariableName="Secchi"
#export values, but censor first
typeof(ft.correct$Secchi.Meters)
unique(ft.correct$Secchi.Meters)
#continue exporting
data.Export$CensorCode=as.character(data.Export$CensorCode)
length(grep("<",ft.correct$Secchi.Meters,ignore.case=TRUE))#0 LT
length(grep(">",ft.correct$Secchi.Meters,ignore.case=TRUE))#0 GT
data.Export$CensorCode[grep("<",ft.correct$Secchi.Meters,ignore.case=TRUE)]="LT"#shouldn't do anything
data.Export$CensorCode[grep(">",ft.correct$Secchi.Meters,ignore.case=TRUE)]="GT"#shouldn't do anything
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]="NC"
unique(data.Export$CensorCode)#all NC
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#0
length(data.Export$CensorCode[which(data.Export$CensorCode=="GT")])#0
#overwrite the F and FT for all observations convert from integer to character to numeric, then convert from feet to meters
ft.correct$Secchi.Meters= gsub(" f",".0",ft.correct$Secchi.Meters,ignore.case=TRUE)
ft.correct$Secchi.Meters= gsub("f","0",ft.correct$Secchi.Meters,ignore.case=TRUE)
ft.correct$Secchi.Meters= gsub("t","0",ft.correct$Secchi.Meters,ignore.case=TRUE)
ft.correct$Secchi.Meters[which(ft.correct$Secchi.Meters=="3.5.0")]="3.50"
ft.correct$Secchi.Meters[which(ft.correct$Secchi.Meters=="13.0.00")]="13.00"
ft.correct$Secchi.Meters[which(ft.correct$Secchi.Meters=="14.0.00")]="14.00"
ft.correct$Secchi.Meters[which(ft.correct$Secchi.Meters=="26 00")]="26.00"
ft.correct$Secchi.Meters[which(ft.correct$Secchi.Meters=="*13.00")]="13.00"
ft.correct$Secchi.Meters[which(ft.correct$Secchi.Meters=="4.0.0")]="4.00"
unique(ft.correct$Secchi.Meters)
typeof(ft.correct$Secchi.Meters)
ft.correct$Secchi.Meters=as.numeric(ft.correct$Secchi.Meters)
unique(ft.correct$Secchi.Meters)
#convert from ft to meters and export
ft.correct$Secchi.Meters=ft.correct$Secchi.Meters*0.3048
unique(ft.correct$Secchi.Meters)
unique(ft.correct$Secchi.Meters.Units)#now this matches the actual observation in Secchi.Meters
#finally export values
data.Export$Value=ft.correct$Secchi.Meters
unique(data.Export$Value)
data.Export$Date = sec.ft$Date#date already in correct format
unique(data$Date)
data.Export$Units="m"
#assign sampledepth 
data.Export$SampleDepth=NA # sample depth na for secchi
unique(data.Export$SampleDepth)
#assign sample position
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="SPECIFIED"# PER import protocol for secchi
unique(data.Export$SamplePosition)
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED"
unique(data.Export$SampleType)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")]) #check to make sure CORRECT NUMBER populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #not specified in meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
unique(data.Export$Comments)
sec.meters.correct.Final = data.Export
rm(data.Export)


################################# sec meters- excluding those with the attached f #####################
unique(sec.meters$Secchi.Meters)
length(sec.meters$Secchi.Meters[which(sec.meters$Secchi.Meters=="**")])
sec.meters=sec.meters[which(sec.meters$Secchi.Meters!="**"),]
sec.meters$Secchi.Meters=as.character(sec.meters$Secchi.Meters)
sec.meters$Secchi.Meters[grep("f",sec.meters$Secchi.Meters,ignore.case=TRUE)]= "-99999"
length(sec.meters$Secchi.Meters[which(sec.meters$Secchi.Meters=="-99999")])
9758-578#number that should remain after filtering out those with attached f
sec.meters=sec.meters[which(sec.meters$Secchi.Meters!="-99999"),]
unique(sec.meters$Secchi.Meters)
length(sec.meters$Secchi.Meters[which(sec.meters$Secchi.Meters=="NT")])
#filter out those two observations that are NT
sec.meters=sec.meters[which(sec.meters$Secchi.Meters!="NT"),]
length(sec.meters$Secchi.Meters[which(sec.meters$Secchi.Meters<0)])
sec.meters$Secchi.Meters[which(sec.meters$Secchi.Meters<0)]#just filter out the one negative observations
sec.meters=sec.meters[which(sec.meters$Secchi.Meters!="-0.6"),]
data.Export= LAGOS_Template
data.Export[1:nrow(sec.meters),]=NA
data.Export$LakeID=sec.meters$Waterbody.ID.Code..WBIC.
unique(data.Export$LakeID)
length(data.Export$LakeID[which(data.Export$LakeID=="")])
length(data.Export$LakeID[which(is.na(data.Export$LakeID)==TRUE)])# 48 observations missing unique lake id
#export lake name
data.Export$LakeName = sec.meters$Official.Lakel.Name
#continue with other variables
data.Export$SourceVariableName = "Secchi Meters"
data.Export$SourceVariableDescription = "Secchi units of Meters"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
unique(sec.meters$Secchi.Hit.Bottom)#no source flags that need to be exported
length(sec.meters$Secchi.Hit.Bottom[which(sec.meters$Secchi.Hit.Bottom=="40")])#assume this is an error overwrite as NO
length(sec.meters$Secchi.Hit.Bottom[which(sec.meters$Secchi.Hit.Bottom=="70")])#assume this is an error overwrite as NO
length(sec.meters$Secchi.Hit.Bottom[which(sec.meters$Secchi.Hit.Bottom=="N")])#chagne to NO
length(sec.meters$Secchi.Hit.Bottom[which(sec.meters$Secchi.Hit.Bottom=="Y")])#change to YES
length(sec.meters$Secchi.Hit.Bottom[which(sec.meters$Secchi.Hit.Bottom=="YES")])
length(sec.meters$Secchi.Hit.Bottom[which(sec.meters$Secchi.Hit.Bottom=="NO")])
sec.meters$Secchi.Hit.Bottom[which(sec.meters$Secchi.Hit.Bottom=="40")]="NO"
sec.meters$Secchi.Hit.Bottom[which(sec.meters$Secchi.Hit.Bottom=="70")]="NO"
sec.meters$Secchi.Hit.Bottom[which(sec.meters$Secchi.Hit.Bottom=="N")]="NO"
sec.meters$Secchi.Hit.Bottom[which(sec.meters$Secchi.Hit.Bottom=="Y")]="YES"
unique(sec.meters$Secchi.Hit.Bottom)#export these as source flags
length(sec.meters$Secchi.Hit.Bottom[which(sec.meters$Secchi.Hit.Bottom=="")])#7068 do not contain info on whether disk hit bottom
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=sec.meters$Secchi.Hit.Bottom
data.Export$SourceFlags[which(data.Export$SourceFlags=="")]=NA
unique(data.Export$SourceFlags)
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA
#continue populating other lagos variables
data.Export$LagosVariableID = 30
data.Export$LagosVariableName="Secchi"
#export values, but censor first
typeof(sec.meters$Secchi.Meters)
unique(sec.meters$Secchi.Meters)
#continue exporting
data.Export$CensorCode=as.character(data.Export$CensorCode)
length(grep("<",sec.meters$Secchi.Meters,ignore.case=TRUE))#0 LT
length(grep(">",sec.meters$Secchi.Meters,ignore.case=TRUE))#17 GT
data.Export$CensorCode[grep("<",sec.meters$Secchi.Meters,ignore.case=TRUE)]="LT"
data.Export$CensorCode[grep(">",sec.meters$Secchi.Meters,ignore.case=TRUE)]="GT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]="NC"
unique(data.Export$CensorCode)
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure correct number
length(data.Export$CensorCode[which(data.Export$CensorCode=="GT")])
#overwrite the < and >
unique(sec.meters$Secchi.Meters)
sec.meters$Secchi.Meters[which(sec.meters$Secchi.Meters==">4.2")]=4.2
sec.meters$Secchi.Meters[which(sec.meters$Secchi.Meters==">2.5")]=2.5
sec.meters$Secchi.Meters[which(sec.meters$Secchi.Meters==">2.1")]=2.1
sec.meters$Secchi.Meters[which(sec.meters$Secchi.Meters==">2.0")]=2.0
sec.meters$Secchi.Meters[which(sec.meters$Secchi.Meters=="M 4.6")]=4.6
sec.meters$Secchi.Meters[which(sec.meters$Secchi.Meters==">1.0")]=1.0
sec.meters$Secchi.Meters[which(sec.meters$Secchi.Meters==">7.6")]=7.6
sec.meters$Secchi.Meters[which(sec.meters$Secchi.Meters==">3.1")]=3.1
sec.meters$Secchi.Meters[which(sec.meters$Secchi.Meters==">6.4")]=6.4
sec.meters$Secchi.Meters[which(sec.meters$Secchi.Meters=="M1.5")]=1.5
sec.meters$Secchi.Meters[which(sec.meters$Secchi.Meters=="M1.3")]=1.3
sec.meters$Secchi.Meters[which(sec.meters$Secchi.Meters==">1.5")]=1.5
sec.meters$Secchi.Meters[which(sec.meters$Secchi.Meters==">1.6")]=1.6
sec.meters$Secchi.Meters[which(sec.meters$Secchi.Meters==">6.7")]=6.7
sec.meters$Secchi.Meters[which(sec.meters$Secchi.Meters==">2.9")]=2.9
sec.meters$Secchi.Meters[which(sec.meters$Secchi.Meters=="M2.0")]=2.0
sec.meters$Secchi.Meters[which(sec.meters$Secchi.Meters=="4.M")]=4.0
unique(sec.meters$Secchi.Meters)
#check to see if all overwritten
length(grep(">",sec.meters$Secchi.Meters,ignore.case=TRUE))
length(grep("<",sec.meters$Secchi.Meters,ignore.case=TRUE))

#make conversions unit conversions
unique(sec.meters$Secchi.Meters)
sec.meters$Secchi.Meters=as.character(sec.meters$Secchi.Meters)
unique(sec.meters$Secchi.Meters)
sec.meters$Secchi.Meters=as.numeric(sec.meters$Secchi.Meters)
unique(sec.ft$Secchi.Feet)
unique(sec.meters$Secchi.Meters.Units)
sec.meters$Secchi.Meters[which(sec.meters$Secchi.Meters.Units=="IN")]=sec.meters$Secchi.Meters[which(sec.meters$Secchi.Meters.Units=="IN")]*0.0254
unique(sec.meters$Secchi.Meters)
#all in units of meters export now
data.Export$Value=sec.meters$Secchi.Meters
unique(data.Export$Value)
data.Export$Date = sec.meters$Date #date already in correct format
unique(data$Date)
data.Export$Units="m"
#assign sampledepth 
data.Export$SampleDepth=NA # sample depth na for secchi
unique(data.Export$SampleDepth)
#assign sample position
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="SPECIFIED"# PER import protocol for secchi
unique(data.Export$SamplePosition)
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED"
unique(data.Export$SampleType)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")]) #check to make sure CORRECT NUMBER populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #not specified in meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
unique(data.Export$Comments)
secmeters.Final = data.Export
rm(data.Export)
##secchi check
length(secft.Final$Value)
length(secmeters.Final$Value)
length(sec.meters.correct.Final$Value)
143809+9177+578 #153564 = correct number after considering those few obs. that were filtered out in the process
###################################### final export ########################################################################################
Final.Export = rbind(doc.Final,chla.Final,color1.Final,color2.Final,no3no2.Final,tkn.Final,secft.Final,sec.meters.correct.Final,secmeters.Final,tp.Final)
Final.Export$SourceFlags[which(Final.Export$SourceFlags=="")]=NA
unique(Final.Export$SourceFlags)
#######################################################################################################################
nosamplepos=Final.Export[which(is.na(Final.Export$SampleDepth)==TRUE & Final.Export$SamplePosition=="UNKNOWN"),]
##Duplicates check ##############################################################################################
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
11723+252766#adds up to total
##write table
Final.Export1=data1
write.table(Final.Export1,file="DataImport_WI_DNR_NUTRIENT.csv",row.names=FALSE,sep=",")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/WI data/WI DNR Data (Finished)/New Data/DataImport_WI_DNR_NUTRIENT/DataImport_WI_DNR_NUTRIENT.RData")