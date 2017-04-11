#path to files
setwd("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/NY data/Adirondack Lakes (finished)/DataImport_NY_ADIRONDACK_1992")


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
#continuation of the adirondack lakes monitoring program. these data are also a part of the epa "time" study= temporally monitoring of integrated ecosystems
#sample type= grab, sample position=epi
###########################################################################################################################################################################################
################################### NO3-    #############################################################################################################################
data=adirondack_1992
names(data)#look at column names
#filter out columns of interest
data=data[,c(5:6,25:28,9)]
names(data)#check to see if the correct columns remain
#check for problematic and null values
unique(data$NO3)#note there are some negative values
length(data$NO3[which(is.na(data$NO3)==TRUE)])
length(data$NO3[which(data$NO3=="")])
16034-13#16021 remain after filtering out null
data=data[which(is.na(data$NO3)==FALSE),]
#check for missing sample depths
length(data$Depth.meters[which(is.na(data$Depth.meters)==TRUE)])
length(data$Depth.meters[which(data$Depth.meters=="")])

#check for missing lake id
length(data$ALSC.Site_Station[which(is.na(data$ALSC.Site_Station)==TRUE)])
length(data$ALSC.Site_Station[which(data$ALSC.Site_Station=="")])
#no null lake id


#done filtering
#proceed to populating LAGOS template


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$ALSC.Site_Station#see import log
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$lake_name
data.Export$SourceVariableName = "NO3-"
data.Export$SourceVariableDescription = "Nitrate"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID =18
data.Export$LagosVariableName="Nitrogen, nitrite (NO2) + nitrate (NO3)"
unique(data$NO3)
data.Export$Value=data$NO3*1000 #export values and convert to preferred units
unique(data.Export$Value)

#continue exporting other info
data.Export$Date = data$Sample.Date  #date already in correct format
data.Export$Units="ug/L"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"
data.Export$SamplePosition[which(is.na(data$Depth.meters)==TRUE)]="UNKNOWN"
unique(data.Export$SamplePosition)
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="UNKNOWN")])#check to make sure correct number
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all integrated
#assign sampledepth 
unique(data$Depth)
data.Export$SampleDepth=data$Depth.meters
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY"
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="See ALSC lab manual"
unique(data.Export$LabMethodInfo)#look at unique values exported
#assign detection limits for each year
unique(data$year)
data.Export$DetectionLimit[which(data$year==1992)]=0.036*1000
data.Export$DetectionLimit[which(data$year==1993)]=0.020*1000
data.Export$DetectionLimit[which(data$year==1994)]=0.028*1000
data.Export$DetectionLimit[which(data$year==1995)]=0.022*1000
data.Export$DetectionLimit[which(data$year==1996)]=0.007*1000
data.Export$DetectionLimit[which(data$year==1997)]=0.014*1000
data.Export$DetectionLimit[which(data$year==1998)]=0.017*1000
data.Export$DetectionLimit[which(data$year==1999)]=0.020*1000
data.Export$DetectionLimit[which(data$year==2000)]=0.011*1000
data.Export$DetectionLimit[which(data$year==2001)]=0.041*1000
data.Export$DetectionLimit[which(data$year==2002)]=0.028*1000
data.Export$DetectionLimit[which(data$year==2003)]=0.016*1000
data.Export$DetectionLimit[which(data$year==2004)]=0.015*1000
data.Export$DetectionLimit[which(data$year==2005)]=0.016*1000
data.Export$DetectionLimit[which(data$year==2006)]=0.010*1000
data.Export$DetectionLimit[which(data$year==2007)]=0.020*1000
data.Export$DetectionLimit[which(data$year==2008)]=0.010*1000
data.Export$DetectionLimit[which(data$year==2009)]=0.002*1000
data.Export$DetectionLimit[which(data$year==2010)]=0.00*1000
data.Export$DetectionLimit[which(data$year==2011)]=0.00*1000
unique(data.Export$DetectionLimit)
#censor observations less than detection limit
length(data.Export$Value[which(data.Export$Value<=data.Export$DetectionLimit)])
#1288 observations will be censored as "LT"
#censor observations based on qualifier
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data.Export$Value<=data.Export$DetectionLimit)]="LT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)] = "NC" #none censored
unique(data.Export$CensorCode)
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure correct number
data.Export$Subprogram="EPA-TIME"
unique(data.Export$Subprogram)
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
no3.Final = data.Export
rm(data)
rm(data.Export)

################################### DOC (mg L-1)  #############################################################################################################################
data=adirondack_1992
names(data)#look at column names
#filter out columns of interest
data=data[,c(5:6,25:28,13)]
names(data)#check to see if the correct columns remain
#check for problematic and null values
unique(data$DOC)#note there are some negative values
length(data$DOC[which(is.na(data$DOC)==TRUE)])
length(data$DOC[which(data$DOC=="")])
16034-3#16031 remain after filtering out null
data=data[which(is.na(data$DOC)==FALSE),]
#check for missing sample depths
length(data$Depth.meters[which(is.na(data$Depth.meters)==TRUE)])
length(data$Depth.meters[which(data$Depth.meters=="")])
#check for missing lake id
length(data$ALSC.Site_Station[which(is.na(data$ALSC.Site_Station)==TRUE)])
length(data$ALSC.Site_Station[which(data$ALSC.Site_Station=="")])
#no null lake id


#done filtering
#proceed to populating LAGOS template


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$ALSC.Site_Station#see import log
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$lake_name
data.Export$SourceVariableName = "DOC (mg L-1)"
data.Export$SourceVariableDescription = "Dissolved organic carbon"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID =6
data.Export$LagosVariableName="Carbon, dissolved organic"
data.Export$Value=data$DOC #export values 
unique(data.Export$Value)

#continue exporting other info
data.Export$Date = data$Sample.Date  #date already in correct format
data.Export$Units="mg/L"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"
data.Export$SamplePosition[which(is.na(data$Depth.meters)==TRUE)]="UNKNOWN"
unique(data.Export$SamplePosition)
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="UNKNOWN")])#check to make sure correct number
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all integrated
#assign sampledepth 
unique(data$Depth)
data.Export$SampleDepth=data$Depth.meters
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY"
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="See ALSC lab manual"
unique(data.Export$LabMethodInfo)#look at unique values exported
#assign detection limits for each year
unique(data$year)
data.Export$DetectionLimit[which(data$year==1992)]=0.263
data.Export$DetectionLimit[which(data$year==1993)]=0.239
data.Export$DetectionLimit[which(data$year==1994)]=0.238
data.Export$DetectionLimit[which(data$year==1995)]=0.282
data.Export$DetectionLimit[which(data$year==1996)]=0.171
data.Export$DetectionLimit[which(data$year==1997)]=0.203
data.Export$DetectionLimit[which(data$year==1998)]=0.184
data.Export$DetectionLimit[which(data$year==1999)]=0.219
data.Export$DetectionLimit[which(data$year==2000)]=0.189
data.Export$DetectionLimit[which(data$year==2001)]=0.224
data.Export$DetectionLimit[which(data$year==2002)]=0.327
data.Export$DetectionLimit[which(data$year==2003)]=0.127
data.Export$DetectionLimit[which(data$year==2004)]=0.201
data.Export$DetectionLimit[which(data$year==2005)]=0.184
data.Export$DetectionLimit[which(data$year==2006)]=0.111
data.Export$DetectionLimit[which(data$year==2007)]=0.109
data.Export$DetectionLimit[which(data$year==2008)]=0.140
data.Export$DetectionLimit[which(data$year==2009)]=0.155
data.Export$DetectionLimit[which(data$year==2010)]=0.138
data.Export$DetectionLimit[which(data$year==2011)]=0.193
unique(data.Export$DetectionLimit)
#censor observations less than detection limit
length(data.Export$Value[which(data.Export$Value<=data.Export$DetectionLimit)])
#1 observations will be censored as "LT"
#censor observations based on qualifier
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data.Export$Value<=data.Export$DetectionLimit)]="LT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)] = "NC" #none censored
unique(data.Export$CensorCode)
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure correct number
data.Export$Subprogram="EPA-TIME"
unique(data.Export$Subprogram)
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
doc.Final = data.Export
rm(data)
rm(data.Export)

################################### NH4+   #############################################################################################################################
data=adirondack_1992
names(data)#look at column names
#filter out columns of interest
data=data[,c(5:6,25:28,19)]
names(data)#check to see if the correct columns remain
#check for problematic and null values
unique(data$NH4)#note there are some negative values
length(data$NH4[which(is.na(data$NH4)==TRUE)])
length(data$NH4[which(data$NH4=="")])
16034-7#16027 remain after filtering out null
data=data[which(is.na(data$NH4)==FALSE),]
#check for missing sample depths
length(data$Depth.meters[which(is.na(data$Depth.meters)==TRUE)])
length(data$Depth.meters[which(data$Depth.meters=="")])
#check for missing lake id
length(data$ALSC.Site_Station[which(is.na(data$ALSC.Site_Station)==TRUE)])
length(data$ALSC.Site_Station[which(data$ALSC.Site_Station=="")])
#no null lake id


#done filtering
#proceed to populating LAGOS template


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$ALSC.Site_Station#see import log
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$lake_name
data.Export$SourceVariableName = "NH4+"
data.Export$SourceVariableDescription = "Ammonium"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID =19
data.Export$LagosVariableName="Nitrogen, NH4"
data.Export$Value=data$NH4*1000 #export values and convert to preff units
unique(data.Export$Value)

#continue exporting other info
data.Export$Date = data$Sample.Date  #date already in correct format
data.Export$Units="ug/L"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"
data.Export$SamplePosition[which(is.na(data$Depth.meters)==TRUE)]="UNKNOWN"
unique(data.Export$SamplePosition)
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="UNKNOWN")])#check to make sure correct number
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all integrated
#assign sampledepth 
unique(data$Depth)
data.Export$SampleDepth=data$Depth.meters
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY"
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="See ALSC lab manual"
unique(data.Export$LabMethodInfo)#look at unique values exported
#assign detection limits for each year
unique(data$year)
data.Export$DetectionLimit[which(data$year==1992)]=0.030*1000
data.Export$DetectionLimit[which(data$year==1993)]=0.026*1000
data.Export$DetectionLimit[which(data$year==1994)]=0.037*1000
data.Export$DetectionLimit[which(data$year==1995)]=0.019*1000
data.Export$DetectionLimit[which(data$year==1996)]=0.021*1000
data.Export$DetectionLimit[which(data$year==1997)]=0.041*1000
data.Export$DetectionLimit[which(data$year==1998)]=0.035*1000
data.Export$DetectionLimit[which(data$year==1999)]=0.034*1000
data.Export$DetectionLimit[which(data$year==2000)]=0.024*1000
data.Export$DetectionLimit[which(data$year==2001)]=0.031*1000
data.Export$DetectionLimit[which(data$year==2002)]=0.043*1000
data.Export$DetectionLimit[which(data$year==2003)]=0.026*1000
data.Export$DetectionLimit[which(data$year==2004)]=0.024*1000
data.Export$DetectionLimit[which(data$year==2005)]=0.020*1000
data.Export$DetectionLimit[which(data$year==2006)]=0.020*1000
data.Export$DetectionLimit[which(data$year==2007)]=0.024*1000
data.Export$DetectionLimit[which(data$year==2008)]=0.017*1000
data.Export$DetectionLimit[which(data$year==2009)]=0.026*1000
data.Export$DetectionLimit[which(data$year==2010)]=0.026*1000
data.Export$DetectionLimit[which(data$year==2011)]=0.030*1000
unique(data.Export$DetectionLimit)
#censor observations less than detection limit
length(data.Export$Value[which(data.Export$Value<=data.Export$DetectionLimit)])
#9508 observations will be censored as "LT"
#censor observations based on qualifier
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data.Export$Value<=data.Export$DetectionLimit)]="LT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)] = "NC" #none censored
unique(data.Export$CensorCode)
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure correct number
data.Export$Subprogram="EPA-TIME"
unique(data.Export$Subprogram)
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
nh4.Final = data.Export
rm(data)
rm(data.Export)

###################################  TRUCOLOR  #############################################################################################################################
data=adirondack_1992
names(data)#look at column names
#filter out columns of interest
data=data[,c(5:6,25:28,21)]
names(data)#check to see if the correct columns remain
#check for problematic and null values
unique(data$TRUCOLOR)#note there are some negative values
length(data$TRUCOLOR[which(is.na(data$TRUCOLOR)==TRUE)])
length(data$TRUCOLOR[which(data$TRUCOLOR=="")])
16034-2#16032 remain after filtering out null
data=data[which(is.na(data$TRUCOLOR)==FALSE),]
#check for missing sample depths
length(data$Depth.meters[which(is.na(data$Depth.meters)==TRUE)])
length(data$Depth.meters[which(data$Depth.meters=="")])

#check for missing lake id
length(data$ALSC.Site_Station[which(is.na(data$ALSC.Site_Station)==TRUE)])
length(data$ALSC.Site_Station[which(data$ALSC.Site_Station=="")])
#no null lake id


#done filtering
#proceed to populating LAGOS template


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$ALSC.Site_Station#see import log
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$lake_name
data.Export$SourceVariableName = "TRUCOLOR"
data.Export$SourceVariableDescription = "True color"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID =12
data.Export$LagosVariableName="Color, true"
data.Export$Value=data$TRUCOLOR #export values 
unique(data.Export$Value)

#continue exporting other info
data.Export$Date = data$Sample.Date  #date already in correct format
data.Export$Units="PCU"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"
data.Export$SamplePosition[which(is.na(data$Depth.meters)==TRUE)]="UNKNOWN"
unique(data.Export$SamplePosition)
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="UNKNOWN")])#check to make sure correct number
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all integrated
#assign sampledepth 
unique(data$Depth)
data.Export$SampleDepth=data$Depth.meters
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY"
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="See ALSC lab manual"
unique(data.Export$LabMethodInfo)#look at unique values exported
#assign detection limits for each year
data.Export$DetectionLimit=NA#none for color
unique(data.Export$DetectionLimit)
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Subprogram="EPA-TIME"
unique(data.Export$Subprogram)
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
color.Final = data.Export
rm(data)
rm(data.Export)

################################### Total Phosphorus  #############################################################################################################################
data=adirondack_1992
names(data)#look at column names
#filter out columns of interest
data=data[,c(5:6,25:28,23)]
names(data)#check to see if the correct columns remain
#check for problematic and null values
unique(data$Total.Phosphorus)#note there are some negative values
length(data$Total.Phosphorus[which(is.na(data$Total.Phosphorus)==TRUE)])
length(data$Total.Phosphorus[which(data$Total.Phosphorus=="")])
16034-13300#2734 remain after filtering out null
data=data[which(is.na(data$Total.Phosphorus)==FALSE),]
#check for missing sample depths
length(data$Depth.meters[which(is.na(data$Depth.meters)==TRUE)])
length(data$Depth.meters[which(data$Depth.meters=="")])
#check for missing lake id
length(data$ALSC.Site_Station[which(is.na(data$ALSC.Site_Station)==TRUE)])
length(data$ALSC.Site_Station[which(data$ALSC.Site_Station=="")])
#no null lake id


#done filtering
#proceed to populating LAGOS template


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$ALSC.Site_Station#see import log
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$lake_name
data.Export$SourceVariableName = "Total Phosphorus"
data.Export$SourceVariableDescription = "Total phosphorus"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID =27
data.Export$LagosVariableName="Phosphorus, total"
data.Export$Value=data$Total.Phosphorus #export values 
unique(data.Export$Value)

#continue exporting other info
data.Export$Date = data$Sample.Date  #date already in correct format
data.Export$Units="ug/L"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"
unique(data.Export$SamplePosition)
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all integrated
#assign sampledepth 
unique(data$Depth)
data.Export$SampleDepth=data$Depth.meters
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY"
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="See ALSC lab manual"
unique(data.Export$LabMethodInfo)#look at unique values exported
#assign detection limits for each year
unique(data$year)
data.Export$DetectionLimit[which(data$year==2008)]=NA
data.Export$DetectionLimit[which(data$year==2009)]=0.526
data.Export$DetectionLimit[which(data$year==2010)]=1.035
data.Export$DetectionLimit[which(data$year==2011)]=0.833
unique(data.Export$DetectionLimit)
#censor observations less than detection limit
length(data.Export$Value[which(data.Export$Value<=data.Export$DetectionLimit)])
#7 observations will be censored as "LT"
#censor observations based on qualifier
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data.Export$Value<=data.Export$DetectionLimit)]="LT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)] = "NC" #none censored
unique(data.Export$CensorCode)
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure correct number
data.Export$Subprogram="EPA-TIME"
unique(data.Export$Subprogram)
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
tp.Final = data.Export
rm(data)
rm(data.Export)

################################### Chlorophyll a  #############################################################################################################################
data=adirondack_1992
names(data)#look at column names
#filter out columns of interest
data=data[,c(5:6,25:28,24)]
names(data)#check to see if the correct columns remain
#check for problematic and null values
unique(data$Chlorophyll.a)#note there are some negative values
length(data$Chlorophyll.a[which(is.na(data$Chlorophyll.a)==TRUE)])
length(data$Chlorophyll.a[which(data$Chlorophyll.a=="")])
16034-13830#2204 remain after filtering out null
data=data[which(is.na(data$Chlorophyll.a)==FALSE),]
#check for missing sample depths
length(data$Depth.meters[which(is.na(data$Depth.meters)==TRUE)])
length(data$Depth.meters[which(data$Depth.meters=="")])
#check for missing lake id
length(data$ALSC.Site_Station[which(is.na(data$ALSC.Site_Station)==TRUE)])
length(data$ALSC.Site_Station[which(data$ALSC.Site_Station=="")])
#no null lake id


#done filtering
#proceed to populating LAGOS template


###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$ALSC.Site_Station#see import log
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$lake_name
data.Export$SourceVariableName = "Chlorophyll a"
data.Export$SourceVariableDescription = "Chlorophyll a"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID =9
data.Export$LagosVariableName="Chlorophyll a"
data.Export$Value=data$Chlorophyll.a #export values 
unique(data.Export$Value)

#continue exporting other info
data.Export$Date = data$Sample.Date  #date already in correct format
data.Export$Units="ug/L"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"
unique(data.Export$SamplePosition)
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all integrated
#assign sampledepth 
unique(data$Depth)
data.Export$SampleDepth=data$Depth.meters
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY"
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="See ALSC lab manual"
unique(data.Export$LabMethodInfo)#look at unique values exported
#assign detection limits for each year
unique(data$year)
data.Export$DetectionLimit[which(data$year==2008)]=NA
data.Export$DetectionLimit[which(data$year==2009)]=0.372
data.Export$DetectionLimit[which(data$year==2010)]=0.236
data.Export$DetectionLimit[which(data$year==2011)]=0.461
unique(data.Export$DetectionLimit)
#censor observations less than detection limit
length(data.Export$Value[which(data.Export$Value<=data.Export$DetectionLimit)])
#79 observations will be censored as "LT"
#censor observations based on qualifier
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data.Export$Value<=data.Export$DetectionLimit)]="LT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)] = "NC" #none censored
unique(data.Export$CensorCode)
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure correct number
data.Export$Subprogram="EPA-TIME"
unique(data.Export$Subprogram)
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
chla.Final = data.Export
rm(data)
rm(data.Export)

###################################### final export ########################################################################################
Final.Export = rbind(doc.Final,no3.Final,nh4.Final,color.Final,tp.Final,chla.Final)
#####################################################################################################
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
0+69049#adds up to total
##write table
Final.Export1=data1
typeof(Final.Export1$Value)
length(Final.Export1$Value[which(Final.Export1$Value<0)])
negative.df=Final.Export1[which(Final.Export1$Value<0),]
unique(negative.df$SourceVariableName)
unique(negative.df$Value)
69049-2368#number remaining after filtering out negative values
Final.Export1=Final.Export1[which(Final.Export1$Value>=0),]
nosamplepos=Final.Export1[which(is.na(Final.Export1$SampleDepth)==TRUE & Final.Export1$SamplePosition=="UNKNOWN"),]
write.table(Final.Export1,file="DataImport_NY_ADIRONDACK_1992.csv",row.names=FALSE,sep=",")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/NY data/Adirondack Lakes (finished)/DataImport_NY_ADIRONDACK_1992/DataImport_NY_ADIRONDACK_1992.RData")
