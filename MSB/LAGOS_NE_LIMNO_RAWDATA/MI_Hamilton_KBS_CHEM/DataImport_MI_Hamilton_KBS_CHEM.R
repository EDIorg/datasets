#path to files
setwd("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MI data/Hamilton-KBS lake database (finished)/DataImport_MI_HAMILTON_KBS_CHEM")

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
#these data are from a university researcher, database of lake chem and chla data for lakes around the kellog biological station
#gull lake data added
#sample type="integrated" or "grab" position="epi" or "hypo"
#see import log other important notes
###########################################################################################################################################################################################
################################### aq: DOC (mg/L)  #############################################################################################################################
data=mi_hamilton_kbs_chem
names(data)#look at column names
#filter out columns of interest
data=data[,c(2:5,7:9,22)]
names(data)
#look at observations for problematic values & filter out null
unique(data$aq..DOC..mg.L.)
length(data$aq..DOC..mg.L.[which(is.na(data$aq..DOC..mg.L.)==TRUE)])
length(data$aq..DOC..mg.L.[which(data$aq..DOC..mg.L.=="")])
1365-854#511 remain after filtering out null
data=data[which(is.na(data$aq..DOC..mg.L.)==FALSE),]
#check for null sample depths
length(data$az..Zsamp..meters.[which(is.na(data$az..Zsamp..meters.)==TRUE)])#175 NULL
#don't filter out those null for sample depths
#look at values for other variables
unique(data$SiteCode)#LakeID
unique(data$SamplingPoint)#those that contain deep are BasinType= "PRIMARY"
unique(data$sampleposition)#export to sample position
length(data$sampleposition[which(data$sampleposition=="")])
unique(data$az..Zsamp..meters.)
length(data$az..Zsamp..meters.[which(is.na(data$az..Zsamp..meters.)==TRUE)])
#done filtering
#proceed to populating LAGOS template


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$SiteCode
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$GeneralSite
data.Export$SourceVariableName = "aq: DOC (mg/L)"
data.Export$SourceVariableDescription = "Dissolved organic carbon"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID =6
data.Export$LagosVariableName="Carbon, dissolved organic"
data.Export$Value=data$aq..DOC..mg.L. #export values, already in preferred units
unique(data.Export$Value)#look at exported values
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode="NC" #no censored obs.
unique(data.Export$CensorCode)
#continue exporting other info
data.Export$Date = data$SampleDate  #date already in correct format
data.Export$Units="mg/L"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition=data$sampleposition
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth=data$az..Zsamp..meters.
unique(data.Export$SampleDepth)
temp.df=data.Export[which(is.na(data.Export$SampleDepth)==TRUE & data.Export$SamplePosition=="UNKNOWN"),]
#3 obs are null for depth and unknown for sample position!
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)#use sample position to determine sample type per metadata
data.Export$SampleType[which(data$sampleposition=="EPI")]="INTEGRATED"
data.Export$SampleType[which(data$sampleposition=="HYPO")]="GRAB"
data.Export$SampleType[which(data$sampleposition=="UNKNOWN")]="UNKNOWN"
unique(data.Export$SampleType)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
unique(data$SamplingPoint)
data.Export$BasinType[grep("deep",data$SamplingPoint,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[which(is.na(data.Export$BasinType)==TRUE)]="UNKNOWN"
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="Followed methods detailed in Hamilton et al. (2001, 2007, and 2009)"
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #per meta
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data.Export$SampleType=="INTEGRATED")]="SampleDepth is reported as the midpoint of the vertical integration sample"
unique(data.Export$Comments)
doc.Final = data.Export
rm(data)
rm(data.Export)
rm(temp.df)

################################### au: Chla (ug/L)  #############################################################################################################################
data=mi_hamilton_kbs_chem
names(data)#look at column names
#filter out columns of interest
data=data[,c(2:5,7:9,10)]
names(data)
#look at observations for problematic values & filter out null
unique(data$au..Chla..ug.L.)
length(data$au..Chla..ug.L.[which(is.na(data$au..Chla..ug.L.)==TRUE)])
length(data$au..Chla..ug.L.[which(data$au..Chla..ug.L.=="")])
1365-1036#329 remain after filtering out null
data=data[which(is.na(data$au..Chla..ug.L.)==FALSE),]
#check for null sample depths
length(data$az..Zsamp..meters.[which(is.na(data$az..Zsamp..meters.)==TRUE)])
#don't filter out those null for sample depths
#look at values for other variables
unique(data$SiteCode)#LakeID
unique(data$SamplingPoint)#those that contain deep are BasinType= "PRIMARY"
unique(data$sampleposition)#export to sample position
length(data$sampleposition[which(data$sampleposition=="")])
unique(data$az..Zsamp..meters.)
length(data$az..Zsamp..meters.[which(is.na(data$az..Zsamp..meters.)==TRUE)])
#done filtering
#proceed to populating LAGOS template


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$SiteCode
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$GeneralSite
data.Export$SourceVariableName = "au: Chla (ug/L)"
data.Export$SourceVariableDescription = "Chlorophyll a"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID =9
data.Export$LagosVariableName="Chlorophyll a"
data.Export$Value=data$au..Chla..ug.L. #export values, already in preferred units
unique(data.Export$Value)#look at exported values
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode="NC" #no censored obs.
unique(data.Export$CensorCode)
#continue exporting other info
data.Export$Date = data$SampleDate  #date already in correct format
data.Export$Units="ug/L"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition=data$sampleposition
unique(data.Export$SamplePosition)
data.Export$SampleDepth=data$az..Zsamp..meters.
unique(data.Export$SampleDepth)
temp.df=data.Export[which(is.na(data.Export$SampleDepth)==TRUE & data.Export$SamplePosition=="UNKNOWN"),]
#1 observations null for sample depth and unknown for sample position
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)#use sample position to determine sample type per metadata
data.Export$SampleType[which(data$sampleposition=="EPI")]="INTEGRATED"
data.Export$SampleType[which(data$sampleposition=="HYPO")]="GRAB"
data.Export$SampleType[which(data$sampleposition=="UNKNOWN")]="UNKNOWN"
unique(data.Export$SampleType)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
unique(data$SamplingPoint)
data.Export$BasinType[grep("deep",data$SamplingPoint,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("shallow",data$SamplingPoint,ignore.case=TRUE)]="NOT_PRIMARY"
data.Export$BasinType[which(is.na(data.Export$BasinType)==TRUE)]="UNKNOWN"
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="Calculated fluorometrically"
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #per meta
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data.Export$SampleType=="INTEGRATED")]="SampleDepth is reported as the midpoint of the vertical integration sample"
unique(data.Export$Comments)
chla.Final = data.Export
rm(data)
rm(data.Export)
rm(temp.df)

################################### ac: NH4-N (ug/L)   #############################################################################################################################
data=mi_hamilton_kbs_chem
names(data)#look at column names
#filter out columns of interest
data=data[,c(2:5,7:9,20)]
names(data)
#look at observations for problematic values & filter out null
unique(data$ac..NH4.N..ug.L.)
length(data$ac..NH4.N..ug.L.[which(is.na(data$ac..NH4.N..ug.L.)==TRUE)])
length(data$ac..NH4.N..ug.L.[which(data$ac..NH4.N..ug.L.=="")])
1365-155#1210 remain after filtering out null
data=data[which(is.na(data$ac..NH4.N..ug.L.)==FALSE),]
#check for null sample depths
length(data$az..Zsamp..meters.[which(is.na(data$az..Zsamp..meters.)==TRUE)])
#don't filter out those null for sample depths
#look at values for other variables
unique(data$SiteCode)#LakeID
unique(data$SamplingPoint)#those that contain deep are BasinType= "PRIMARY"
unique(data$sampleposition)#export to sample position
length(data$sampleposition[which(data$sampleposition=="")])
data$sampleposition[which(data$sampleposition=="")]="UNKNOWN"
unique(data$sampleposition)
unique(data$az..Zsamp..meters.)
length(data$az..Zsamp..meters.[which(is.na(data$az..Zsamp..meters.)==TRUE)])
#done filtering
#proceed to populating LAGOS template


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$SiteCode
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$GeneralSite
data.Export$SourceVariableName = "ac: NH4-N (ug/L)"
data.Export$SourceVariableDescription = "Nitrogen, NH4 Ammonium"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID =19
data.Export$LagosVariableName="Nitrogen, NH4"
data.Export$Value=data$ac..NH4.N..ug.L. #export values, already in preferred units
unique(data.Export$Value)#look at exported values
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode="NC" #no censored obs.
unique(data.Export$CensorCode)
#continue exporting other info
data.Export$Date = data$SampleDate  #date already in correct format
data.Export$Units="ug/L"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition=data$sampleposition
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth=data$az..Zsamp..meters.
unique(data.Export$SampleDepth)
temp.df=data.Export[which(is.na(data.Export$SampleDepth)==TRUE & data.Export$SamplePosition=="UNKNOWN"),]
#15  observations null for sample depth and unknown for sample position
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)#use sample position to determine sample type per metadata
data.Export$SampleType[which(data$sampleposition=="EPI")]="INTEGRATED"
data.Export$SampleType[which(data$sampleposition=="HYPO")]="GRAB"
data.Export$SampleType[which(data$sampleposition=="UNKNOWN")]="UNKNOWN"
data.Export$SampleType[which(data$sampleposition=="")]="UNKNOWN"
unique(data.Export$SampleType)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
unique(data$SamplingPoint)
data.Export$BasinType[grep("deep",data$SamplingPoint,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("shallow",data$SamplingPoint,ignore.case=TRUE)]="NOT_PRIMARY"
data.Export$BasinType[which(is.na(data.Export$BasinType)==TRUE)]="UNKNOWN"
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="Followed methods detailed in Hamilton et al. (2001, 2007, and 2009)"
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #per meta
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data.Export$SampleType=="INTEGRATED")]="SampleDepth is reported as the midpoint of the vertical integration sample"
unique(data.Export$Comments)
nh4.Final = data.Export
rm(data)
rm(data.Export)
rm(temp.df)

################################### ae: NO3-N (mg/L)   #############################################################################################################################
data=mi_hamilton_kbs_chem
names(data)#look at column names
#filter out columns of interest
data=data[,c(2:5,7:9,16)]
names(data)
#look at observations for problematic values & filter out null
unique(data$ae..NO3.N..mg.L.)
length(data$ae..NO3.N..mg.L.[which(is.na(data$ae..NO3.N..mg.L.)==TRUE)])
length(data$ae..NO3.N..mg.L.[which(data$ae..NO3.N..mg.L.=="")])
1365-255#1110 remain after filtering out null
data=data[which(is.na(data$ae..NO3.N..mg.L.)==FALSE),]
#check for null sample depths
length(data$az..Zsamp..meters.[which(is.na(data$az..Zsamp..meters.)==TRUE)])
#don't filter out those null for sample depths
#look at values for other variables
unique(data$SiteCode)#LakeID
unique(data$SamplingPoint)#those that contain deep are BasinType= "PRIMARY"
unique(data$sampleposition)#export to sample position
length(data$sampleposition[which(data$sampleposition=="")])
data$sampleposition[which(data$sampleposition=="")]="UNKNOWN"
unique(data$sampleposition)
unique(data$az..Zsamp..meters.)
length(data$az..Zsamp..meters.[which(is.na(data$az..Zsamp..meters.)==TRUE)])



#done filtering
#proceed to populating LAGOS template


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$SiteCode
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$GeneralSite
data.Export$SourceVariableName = "ae: NO3-N (mg/L)"
data.Export$SourceVariableDescription = "Nitrogen, nitrate"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID =18
data.Export$LagosVariableName="Nitrogen, nitrite (NO2) + nitrate (NO3)"
data.Export$Value=data$ae..NO3.N..mg.L.*1000 #export values,and convert to preferred units
unique(data.Export$Value)#look at exported values
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode="NC" #no censored obs.
unique(data.Export$CensorCode)
#continue exporting other info
data.Export$Date = data$SampleDate  #date already in correct format
data.Export$Units="ug/L"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition=data$sampleposition
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth=data$az..Zsamp..meters.
unique(data.Export$SampleDepth)
temp.df=data.Export[which(is.na(data.Export$SampleDepth)==TRUE & data.Export$SamplePosition=="UNKNOWN"),]
#9 observations null for sample depth and unknown for sample position
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)#use sample position to determine sample type per metadata
data.Export$SampleType[which(data$sampleposition=="EPI")]="INTEGRATED"
data.Export$SampleType[which(data$sampleposition=="HYPO")]="GRAB"
data.Export$SampleType[which(data$sampleposition=="UNKNOWN")]="UNKNOWN"
unique(data.Export$SampleType)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
unique(data$SamplingPoint)
data.Export$BasinType[grep("deep",data$SamplingPoint,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("shallow",data$SamplingPoint,ignore.case=TRUE)]="NOT_PRIMARY"
data.Export$BasinType[which(is.na(data.Export$BasinType)==TRUE)]="UNKNOWN"
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="Followed methods detailed in Hamilton et al. (2001, 2007, and 2009)"
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #per meta
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data.Export$SampleType=="INTEGRATED")]="SampleDepth is reported as the midpoint of the vertical integration sample"
unique(data.Export$Comments)
no3.Final = data.Export
rm(data)
rm(data.Export)
rm(temp.df)
################################### bu: TN (mg/L)   #############################################################################################################################
data=mi_hamilton_kbs_chem
names(data)#look at column names
#filter out columns of interest
data=data[,c(2:5,7:9,27)]
names(data)
#look at observations for problematic values & filter out null
unique(data$bu..TN..mg.L.)
length(data$bu..TN..mg.L.[which(is.na(data$bu..TN..mg.L.)==TRUE)])
length(data$bu..TN..mg.L.[which(data$bu..TN..mg.L.=="")])
1365-1363#2 remain after filtering out null
data=data[which(is.na(data$bu..TN..mg.L.)==FALSE),]
#check for null sample depths
length(data$az..Zsamp..meters.[which(is.na(data$az..Zsamp..meters.)==TRUE)])
#don't filter out those null for sample depths
#look at values for other variables
unique(data$SiteCode)#LakeID
unique(data$sampleposition)#export to sample position
length(data$sampleposition[which(data$sampleposition=="")])
data$sampleposition[which(data$sampleposition=="")]="UNKNOWN"
unique(data$sampleposition)
unique(data$az..Zsamp..meters.)
length(data$az..Zsamp..meters.[which(is.na(data$az..Zsamp..meters.)==TRUE)])
#done filtering
#proceed to populating LAGOS template


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$SiteCode
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$GeneralSite
data.Export$SourceVariableName = "bu: TN (mg/L)"
data.Export$SourceVariableDescription = "Total nitrogen"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID =21
data.Export$LagosVariableName="Nitrogen, total"
data.Export$Value=data$bu..TN..mg.L.*1000 #export values,and convert to preferred units
unique(data.Export$Value)#look at exported values
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode="NC" #no censored obs.
unique(data.Export$CensorCode)
#continue exporting other info
data.Export$Date = data$SampleDate  #date already in correct format
data.Export$Units="ug/L"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition=data$sampleposition
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth=data$az..Zsamp..meters.
unique(data.Export$SampleDepth)
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)#use sample position to determine sample type per metadata
data.Export$SampleType[which(data$sampleposition=="EPI")]="INTEGRATED"
data.Export$SampleType[which(data$sampleposition=="HYPO")]="GRAB"
data.Export$SampleType[which(data$sampleposition=="UNKNOWN")]="UNKNOWN"
unique(data.Export$SampleType)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
unique(data$SamplingPoint)
data.Export$BasinType[grep("deep",data$SamplingPoint,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("shallow",data$SamplingPoint,ignore.case=TRUE)]="NOT_PRIMARY"
data.Export$BasinType[which(is.na(data.Export$BasinType)==TRUE)]="UNKNOWN"
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="Followed methods detailed in Hamilton et al. (2001, 2007, and 2009)"
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #per meta
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data.Export$SampleType=="INTEGRATED")]="SampleDepth is reported as the midpoint of the vertical integration sample"
unique(data.Export$Comments)
tn.Final = data.Export
rm(data)
rm(data.Export)

################################## ab: PO4-P (ug/L)     #############################################################################################################################
data=mi_hamilton_kbs_chem
names(data)#look at column names
#filter out columns of interest
data=data[,c(2:5,7:9,21)]
names(data)
#look at observations for problematic values & filter out null
unique(data$ab..PO4.P..ug.L.)
length(data$ab..PO4.P..ug.L.[which(is.na(data$ab..PO4.P..ug.L.)==TRUE)])
length(data$ab..PO4.P..ug.L.[which(data$ab..PO4.P..ug.L.=="")])
1365-203#1162 remain after filtering out null
data=data[which(is.na(data$ab..PO4.P..ug.L.)==FALSE),]
#check for null sample depths
length(data$az..Zsamp..meters.[which(is.na(data$az..Zsamp..meters.)==TRUE)])
#don't filter out those null for sample depths
#look at values for other variables
unique(data$SiteCode)#LakeID
unique(data$SamplingPoint)#those that contain deep are BasinType= "PRIMARY"
unique(data$sampleposition)#export to sample position
length(data$sampleposition[which(data$sampleposition=="")])
data$sampleposition[which(data$sampleposition=="")]="UNKNOWN"
unique(data$sampleposition)
unique(data$az..Zsamp..meters.)
length(data$az..Zsamp..meters.[which(is.na(data$az..Zsamp..meters.)==TRUE)])
#done filtering
#proceed to populating LAGOS template


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$SiteCode
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$GeneralSite
data.Export$SourceVariableName = "ab: PO4-P (ug/L)"
data.Export$SourceVariableDescription = "Phosphorus, orthophosphate"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID =26
data.Export$LagosVariableName="Phosphorus, soluable reactive orthophosphate"
data.Export$Value=data$ab..PO4.P..ug.L.#export values
unique(data.Export$Value)#look at exported values
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode="NC" #no censored obs.
unique(data.Export$CensorCode)
#continue exporting other info
data.Export$Date = data$SampleDate  #date already in correct format
data.Export$Units="ug/L"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition=data$sampleposition
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth=data$az..Zsamp..meters.
unique(data.Export$SampleDepth)
temp.df=data.Export[which(is.na(data.Export$SampleDepth)==TRUE & data.Export$SamplePosition=="UNKNOWN"),]
#9 observations null for sample depth and unknown for sample position
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)#use sample position to determine sample type per metadata
data.Export$SampleType[which(data$sampleposition=="EPI")]="INTEGRATED"
data.Export$SampleType[which(data$sampleposition=="HYPO")]="GRAB"
data.Export$SampleType[which(data$sampleposition=="UNKNOWN")]="UNKNOWN"
unique(data.Export$SampleType)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
unique(data$SamplingPoint)
data.Export$BasinType[grep("deep",data$SamplingPoint,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("shallow",data$SamplingPoint,ignore.case=TRUE)]="NOT_PRIMARY"
data.Export$BasinType[which(is.na(data.Export$BasinType)==TRUE)]="UNKNOWN"
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="Followed methods detailed in Hamilton et al. (2001, 2007, and 2009)"
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #per meta
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data.Export$SampleType=="INTEGRATED")]="SampleDepth is reported as the midpoint of the vertical integration sample"
unique(data.Export$Comments)
srp.Final = data.Export
rm(data)
rm(data.Export)
rm(temp.df)

################################## as: TP (ug/L)  #############################################################################################################################
data=mi_hamilton_kbs_chem
names(data)#look at column names
#filter out columns of interest
data=data[,c(2:5,7:9,25)]
names(data)
#look at observations for problematic values & filter out null
unique(data$as..TP..ug.L.)
length(data$as..TP..ug.L.[which(is.na(data$as..TP..ug.L.)==TRUE)])
length(data$as..TP..ug.L.[which(data$as..TP..ug.L.=="")])
1365-688#677 remain after filtering out null
data=data[which(is.na(data$as..TP..ug.L.)==FALSE),]
#check for null sample depths
length(data$az..Zsamp..meters.[which(is.na(data$az..Zsamp..meters.)==TRUE)])
#don't filter out those null for sample depths
#look at values for other variables
unique(data$SiteCode)#LakeID
unique(data$SamplingPoint)#those that contain deep are BasinType= "PRIMARY"
unique(data$sampleposition)#export to sample position
length(data$sampleposition[which(data$sampleposition=="")])
data$sampleposition[which(data$sampleposition=="")]="UNKNOWN"
unique(data$sampleposition)
unique(data$az..Zsamp..meters.)
length(data$az..Zsamp..meters.[which(is.na(data$az..Zsamp..meters.)==TRUE)])
#done filtering
#proceed to populating LAGOS template


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$SiteCode
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$GeneralSite
data.Export$SourceVariableName = "as: TP (ug/L)"
data.Export$SourceVariableDescription = "Total phosphorus"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID =27
data.Export$LagosVariableName="Phosphorus, total"
data.Export$Value=data$as..TP..ug.L.#export values
unique(data.Export$Value)#look at exported values
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode="NC" #no censored obs.
unique(data.Export$CensorCode)
#continue exporting other info
data.Export$Date = data$SampleDate  #date already in correct format
data.Export$Units="ug/L"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition=data$sampleposition
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth=data$az..Zsamp..meters.
unique(data.Export$SampleDepth)
temp.df=data.Export[which(is.na(data.Export$SampleDepth)==TRUE & data.Export$SamplePosition=="UNKNOWN"),]
#10 observations null for sample depth and unknown for sample position
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)#use sample position to determine sample type per metadata
data.Export$SampleType[which(data$sampleposition=="EPI")]="INTEGRATED"
data.Export$SampleType[which(data$sampleposition=="HYPO")]="GRAB"
data.Export$SampleType[which(data$sampleposition=="UNKNOWN")]="UNKNOWN"
unique(data.Export$SampleType)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
unique(data$SamplingPoint)
data.Export$BasinType[grep("deep",data$SamplingPoint,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("shallow",data$SamplingPoint,ignore.case=TRUE)]="NOT_PRIMARY"
data.Export$BasinType[which(is.na(data.Export$BasinType)==TRUE)]="UNKNOWN"
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="Followed methods detailed in Hamilton et al. (2001, 2007, and 2009)"
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #per meta
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data.Export$SampleType=="INTEGRATED")]="SampleDepth is reported as the midpoint of the vertical integration sample"
unique(data.Export$Comments)
tp.Final = data.Export
rm(data)
rm(data.Export)

################################## ar: TDP (ug/L)  #############################################################################################################################
data=mi_hamilton_kbs_chem
names(data)#look at column names
#filter out columns of interest
data=data[,c(2:5,7:9,24)]
names(data)
#look at observations for problematic values & filter out null
unique(data$ar..TDP..ug.L.)
length(data$ar..TDP..ug.L.[which(is.na(data$ar..TDP..ug.L.)==TRUE)])
length(data$ar..TDP..ug.L.[which(data$ar..TDP..ug.L.=="")])
1365-249#1116 remain after filtering out null
data=data[which(is.na(data$ar..TDP..ug.L.)==FALSE),]
#check for null sample depths
length(data$az..Zsamp..meters.[which(is.na(data$az..Zsamp..meters.)==TRUE)])
#don't filter out those null for sample depths
#look at values for other variables
unique(data$SiteCode)#LakeID
unique(data$SamplingPoint)#those that contain deep are BasinType= "PRIMARY"
unique(data$sampleposition)#export to sample position
length(data$sampleposition[which(data$sampleposition=="")])
data$sampleposition[which(data$sampleposition=="")]="UNKNOWN"
unique(data$sampleposition)
unique(data$az..Zsamp..meters.)
length(data$az..Zsamp..meters.[which(is.na(data$az..Zsamp..meters.)==TRUE)])

#done filtering
#proceed to populating LAGOS template


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$SiteCode
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$GeneralSite
data.Export$SourceVariableName = "ar: TDP (ug/L)"
data.Export$SourceVariableDescription = "Total dissolved phosphorus"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID =28
data.Export$LagosVariableName="Phosphorus, total dissolved"
data.Export$Value=data$ar..TDP..ug.L.#export values
unique(data.Export$Value)#look at exported values
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode="NC" #no censored obs.
unique(data.Export$CensorCode)
#continue exporting other info
data.Export$Date = data$SampleDate  #date already in correct format
data.Export$Units="ug/L"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition=data$sampleposition
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth=data$az..Zsamp..meters.
unique(data.Export$SampleDepth)
temp.df=data.Export[which(is.na(data.Export$SampleDepth)==TRUE & data.Export$SamplePosition=="UNKNOWN"),]
#11 observations null for sample depth and unknown for sample position
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)#use sample position to determine sample type per metadata
data.Export$SampleType[which(data$sampleposition=="EPI")]="INTEGRATED"
data.Export$SampleType[which(data$sampleposition=="HYPO")]="GRAB"
data.Export$SampleType[which(data$sampleposition=="UNKNOWN")]="UNKNOWN"
unique(data.Export$SampleType)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
unique(data$SamplingPoint)
data.Export$BasinType[grep("deep",data$SamplingPoint,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("shallow",data$SamplingPoint,ignore.case=TRUE)]="NOT_PRIMARY"
data.Export$BasinType[which(is.na(data.Export$BasinType)==TRUE)]="UNKNOWN"
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="Followed methods detailed in Hamilton et al. (2001, 2007, and 2009)"
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #per meta
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments[which(data.Export$SampleType=="INTEGRATED")]="SampleDepth is reported as the midpoint of the vertical integration sample"
unique(data.Export$Comments)
tdp.Final = data.Export
rm(data)
rm(data.Export)
rm(temp.df)
################################## ay: Secchi (meters)  #############################################################################################################################
data=mi_hamilton_kbs_chem
names(data)#look at column names
#filter out columns of interest
data=data[,c(2:5,7:9,11)]
names(data)
#look at observations for problematic values & filter out null
unique(data$ay..Secchi..meters.)
length(data$ay..Secchi..meters.[which(is.na(data$ay..Secchi..meters.)==TRUE)])
length(data$ay..Secchi..meters.[which(data$ay..Secchi..meters.=="")])
1365-982#383 remain after filtering out null
data=data[which(is.na(data$ay..Secchi..meters.)==FALSE),]
#look at values for other variables
unique(data$SiteCode)#LakeID
unique(data$SamplingPoint)#those that contain deep are BasinType= "PRIMARY"

#done filtering
#proceed to populating LAGOS template


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$SiteCode
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$GeneralSite
data.Export$SourceVariableName = "ay: Secchi (meters)"
data.Export$SourceVariableDescription = "Secchi depth"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID =30
data.Export$LagosVariableName="Secchi"
data.Export$Value=data$ay..Secchi..meters.#export values
unique(data.Export$Value)#look at exported values
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode="NC" #no censored obs.
unique(data.Export$CensorCode)
#continue exporting other info
data.Export$Date = data$SampleDate  #date already in correct format
data.Export$Units="m"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="SPECIFIED"
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth=NA
unique(data.Export$SampleDepth)
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED"
unique(data.Export$SampleType)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
unique(data$SamplingPoint)
data.Export$BasinType[grep("deep",data$SamplingPoint,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("shallow",data$SamplingPoint,ignore.case=TRUE)]="NOT_PRIMARY"
data.Export$BasinType[which(is.na(data.Export$BasinType)==TRUE)]="UNKNOWN"
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #per meta
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
secchi.Final = data.Export
rm(data)
rm(data.Export)


###################################### final export ########################################################################################
Final.Export = rbind(doc.Final,chla.Final,nh4.Final,no3.Final,tdp.Final,srp.Final,tp.Final,tn.Final,secchi.Final)
######################################################################################

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
102 +6398#adds up to total
##write table
Final.Export1=data1
typeof(Final.Export1$Value)
length(Final.Export1$Value[which(Final.Export1$Value<0)])
nosamplepos=Final.Export1[which(is.na(Final.Export1$SampleDepth)==TRUE & Final.Export1$SamplePosition=="UNKNOWN"),]
write.table(Final.Export1,file="DataImport_MI_HAMILTON_KBS_CHEM.csv",row.names=FALSE,sep=",")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MI data/Hamilton-KBS lake database (finished)/DataImport_MI_HAMILTON_KBS_CHEM/DataImport_MI_HAMILTON_KBS_CHEM.RData")