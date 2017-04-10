#set path to files
setwd("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MI data/Paul Lake (finished)/DataImport_MI_PAUL")
setwd("C:/Users/Sam/Dropbox/CSI-LIMNO_DATA/DATA-lake/MI data/Paul Lake (finished)/DataImport_MI_PAUL")

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
#data from the underc freshwater "cascade project"
#data from a single lake, paul lake (reference) in northern michigan
###########################################################################################################################################################################################
################################### chl a   #############################################################################################################################
data=paul_lake
names(data)#look at column names
#filter out columns of interest
data=data[,c(1,6)]
unique(data$chl.a)#looking for unusual values that might need special attention
#filter out null values
length(data$chl.a[which(is.na(data$chl.a)==TRUE)])
length(data$chl.a[which(data$chl.a=="")])
387-50 #337 should remain after filtering out NA
data=data[which(is.na(data$chl.a)==FALSE),]

#done filtering

#proceed to populating LAGOS template

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = NA 
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = "Paul Lake"
data.Export$SourceVariableName = "chl a"
data.Export$SourceVariableDescription = "Chlorophyll a"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no flags w/ these data
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 9
data.Export$LagosVariableName="Chlorophyll a"
names(data)
data.Export$Value = data$chl.a #export observations already in prefferred units
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$sampledate #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"#per metadata
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
#assign sampledepth 
data.Export$SampleDepth=NA
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY"#according to the meta
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="Samples collected at 0m with a Van Dorn bottle and filtered through a GF/F.  Material retained on the filter was extracted in methanol for 24 hrs.  Chlorophyll a determined on a Turner 450 fluorometer, then acidified for phaeophytin determination."
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #not specified in meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
unique(data.Export$Comments)
data.Export$Subprogram="Cascade Project"
unique(data.Export$Subprogram)
chla.Final = data.Export
rm(data)
rm(data.Export)

###################################   Color G440 (1/m)   #############################################################################################################################
data=paul_lake
names(data)#look at column names
#filter out columns of interest
data=data[,c(1,7)]
unique(data$Color.G440..1.m.)#looking for unusual values that might need special attention
#filter out null values
length(data$Color.G440..1.m.[which(is.na(data$Color.G440..1.m.)==TRUE)])
length(data$Color.G440..1.m.[which(data$Color.G440..1.m.=="")])
387-302 #85 should remain after filtering out NA
data=data[which(is.na(data$Color.G440..1.m.)==FALSE),]

#done filtering

#proceed to populating LAGOS template

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = NA 
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = "Paul Lake"
data.Export$SourceVariableName = "Color G440 (1/m)"
data.Export$SourceVariableDescription = "Color absorbance at 440 nm"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no flags w/ these data
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 12
data.Export$LagosVariableName="Color, true"
names(data)
#export color obs and convert to appropriate units
g_440=(2.303*data$Color.G440..1.m.)/(.10)
data.Export$Value = (18.216*g_440)-.209
unique(data.Export$Value)


data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$sampledate #date already in correct format
data.Export$Units="PCU"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="UNKNOWN" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="UNKNOWN")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"#per metadata
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
#assign sampledepth 
data.Export$SampleDepth=NA
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY"#according to the meta
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo= NA 
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #not specified in meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
unique(data.Export$Comments)
data.Export$Subprogram="Cascade Project"
unique(data.Export$Subprogram)
color.Final = data.Export
rm(data)
rm(data.Export)
rm(g_440)

################################### DOC(mg/L)   #############################################################################################################################
data=paul_lake
names(data)#look at column names
#filter out columns of interest
data=data[,c(1,8)]
unique(data$DOC.mg.L.)#looking for unusual values that might need special attention
#filter out null values
length(data$DOC.mg.L.[which(is.na(data$DOC.mg.L.)==TRUE)])
length(data$DOC.mg.L.[which(data$DOC.mg.L.=="")])
387-124 #263 should remain after filtering out NA
data=data[which(is.na(data$DOC.mg.L.)==FALSE),]

#done filtering

#proceed to populating LAGOS template

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = NA 
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = "Paul Lake"
data.Export$SourceVariableName = "DOC(mg/L)"
data.Export$SourceVariableDescription = "Dissolved organic carbon"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no flags w/ these data
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 6
data.Export$LagosVariableName="Carbon, dissolved organic"
names(data)
data.Export$Value = data$DOC.mg.L. #export observations already in prefferred units
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$sampledate #date already in correct format
data.Export$Units="mg/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"#per metadata
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
#assign sampledepth 
data.Export$SampleDepth=NA
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY"#according to the meta
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="Samples filtered through a pre-ashed 0.7 um GF/F filter and acidified to pH 2 with H2SO4.  Analyzed on an Astro 2001 TOC analyzer (1991-1993), Shimadzu 5050 TOC analyzer (1994-)"
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #not specified in meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
unique(data.Export$Comments)
data.Export$Subprogram="Cascade Project"
unique(data.Export$Subprogram)
doc.Final = data.Export
rm(data)
rm(data.Export)

################################### totp #############################################################################################################################
data=paul_lake
names(data)#look at column names
#filter out columns of interest
data=data[,c(1,10)]
unique(data$totp)#looking for unusual values that might need special attention
#filter out null values
length(data$totp[which(is.na(data$totp)==TRUE)])
length(data$totp[which(data$totp=="")])
387-181 #206 should remain after filtering out NA
data=data[which(is.na(data$totp)==FALSE),]

#done filtering

#proceed to populating LAGOS template

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = NA 
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = "Paul Lake"
data.Export$SourceVariableName = "totp"
data.Export$SourceVariableDescription = "Total phosphorus"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no flags w/ these data
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 27
data.Export$LagosVariableName="Phosphorus, total"
names(data)
data.Export$Value = data$totp #export observations already in prefferred units
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$sampledate #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"#per metadata
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
#assign sampledepth 
data.Export$SampleDepth=NA
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY"#according to the meta
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data$sampledate=as.character(data$sampledate)
data.Export$LabMethodInfo[which(data$sampledate>"1992-12-31")]="Unfiltered samples. Persulfate digestion, Lachat method 10-115-01-1-F."
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= 1 #per meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
unique(data.Export$Comments)
data.Export$Subprogram="Cascade Project"
unique(data.Export$Subprogram)
tp.Final = data.Export
rm(data)
rm(data.Export)

################################### totn    #############################################################################################################################
data=paul_lake
names(data)#look at column names
#filter out columns of interest
data=data[,c(1,11)]
unique(data$totn)#looking for unusual values that might need special attention
#filter out null values
length(data$totn[which(is.na(data$totn)==TRUE)])
length(data$totn[which(data$totn=="")])
387-231 #156 should remain after filtering out NA
data=data[which(is.na(data$totn)==FALSE),]

#done filtering

#proceed to populating LAGOS template

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = NA 
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = "Paul Lake"
data.Export$SourceVariableName = "totn"
data.Export$SourceVariableDescription = "Total nitrogen"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no flags w/ these data
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 21
data.Export$LagosVariableName="Nitrogen, total"
names(data)
data.Export$Value = data$totn #export observations already in prefferred units
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$sampledate #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"#per metadata
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
#assign sampledepth 
data.Export$SampleDepth=NA
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY"#according to the meta
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data$sampledate=as.character(data$sampledate)
data.Export$LabMethodInfo[which(data$sampledate<"1999-12-31")]="Calculated from tot_kjdl_n + no23"
data.Export$LabMethodInfo[which(data$sampledate>"1999-12-31")]="Determined directly by persulfate digestion and analysis on a Lachat QuickChem 8000 FIA Ion Analyzer"
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #per meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
unique(data.Export$Comments)
data.Export$Subprogram="Cascade Project"
unique(data.Export$Subprogram)
tn.Final = data.Export
rm(data)
rm(data.Export)

################################### tot_kjdl_n   #############################################################################################################################
data=paul_lake
names(data)#look at column names
#filter out columns of interest
data=data[,c(1,12)]
unique(data$tot_kjdl_n)#looking for unusual values that might need special attention
#filter out null values
length(data$tot_kjdl_n[which(is.na(data$tot_kjdl_n)==TRUE)])
length(data$tot_kjdl_n[which(data$tot_kjdl_n=="")])
387-288 #99 should remain after filtering out NA
data=data[which(is.na(data$tot_kjdl_n)==FALSE),]

#done filtering

#proceed to populating LAGOS template

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = NA 
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = "Paul Lake"
data.Export$SourceVariableName = "tot_kjdl_n"
data.Export$SourceVariableDescription = "Total kjeldahl nitrogen"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no flags w/ these data
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 16
data.Export$LagosVariableName="Nitrogen, total Kjeldahl"
names(data)
data.Export$Value = data$tot_kjdl_n #export observations already in prefferred units
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$sampledate #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"#per metadata
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
#assign sampledepth 
data.Export$SampleDepth=NA
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY"#according to the meta
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="Total N determined by Kjeldahl digestion on unfiltered samples, Lachat method 10-107-06-2-E"
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #per meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
unique(data.Export$Comments)
data.Export$Subprogram="Cascade Project"
unique(data.Export$Subprogram)
tkn.Final = data.Export
rm(data)
rm(data.Export)

################################### nh34  #############################################################################################################################
data=paul_lake
names(data)#look at column names
#filter out columns of interest
data=data[,c(1,13)]
unique(data$nh34)#looking for unusual values that might need special attention
#filter out null values
length(data$nh34[which(is.na(data$nh34)==TRUE)])
length(data$nh34[which(data$nh34=="")])
387-308 #79 should remain after filtering out NA
data=data[which(is.na(data$nh34)==FALSE),]

#done filtering

#proceed to populating LAGOS template

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = NA 
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = "Paul Lake"
data.Export$SourceVariableName = "nh34"
data.Export$SourceVariableDescription = "Ammonium nitrogen"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no flags w/ these data
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 19
data.Export$LagosVariableName="Nitrogen, NH4"
names(data)
data.Export$Value = data$nh34 #export observations already in prefferred units
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$sampledate #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"#per metadata
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
#assign sampledepth 
data.Export$SampleDepth=NA
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY"#according to the meta
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="samples filtered through 0.7 um pre-ashed GF/F. Lachat AE autoanalyer salycilate-nitroprusside method (No. 10-107-06-2-B)."
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= .50 #per meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
unique(data.Export$Comments)
data.Export$Subprogram="Cascade Project"
unique(data.Export$Subprogram)
nh4.Final = data.Export
rm(data)
rm(data.Export)

################################### no23  #############################################################################################################################
data=paul_lake
names(data)#look at column names
#filter out columns of interest
data=data[,c(1,14)]
unique(data$no23)#looking for unusual values that might need special attention
#filter out null values
length(data$no23[which(is.na(data$no23)==TRUE)])
length(data$no23[which(data$no23=="")])
387-305 #82 should remain after filtering out NA
data=data[which(is.na(data$no23)==FALSE),]

#done filtering

#proceed to populating LAGOS template

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = NA 
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = "Paul Lake"
data.Export$SourceVariableName = "no23"
data.Export$SourceVariableDescription = "Nitrate nitrogen"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no flags w/ these data
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 18
data.Export$LagosVariableName="Nitrogen, nitrite (NO2) + nitrate (NO3)"
names(data)
data.Export$Value = data$no23 #export observations already in prefferred units
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$sampledate #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"#per metadata
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
#assign sampledepth 
data.Export$SampleDepth=NA
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY"#according to the meta
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="Samples filtered through 0.7 um pre-ashed GF/F. Lachat AE autoanalyer Cu-Cd reduction method No. 10-107-04-1-B"
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= .50 #per meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
unique(data.Export$Comments)
data.Export$Subprogram="Cascade Project"
unique(data.Export$Subprogram)
no3no2.Final = data.Export
rm(data)
rm(data.Export)

################################### po4 #############################################################################################################################
data=paul_lake
names(data)#look at column names
#filter out columns of interest
data=data[,c(1,15)]
unique(data$po4)#looking for unusual values that might need special attention
#filter out null values
length(data$po4[which(is.na(data$po4)==TRUE)])
length(data$po4[which(data$po4=="")])
387-302 #85 should remain after filtering out NA
data=data[which(is.na(data$po4)==FALSE),]

#done filtering

#proceed to populating LAGOS template

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = NA 
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = "Paul Lake"
data.Export$SourceVariableName = "po4"
data.Export$SourceVariableDescription = "Dissolved reactive phosphorus"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no flags w/ these data
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 26
data.Export$LagosVariableName="Phosphorus, soluable reactive orthophosphate"
names(data)
data.Export$Value = data$po4 #export observations already in prefferred units
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$sampledate #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"#per metadata
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
#assign sampledepth 
data.Export$SampleDepth=NA
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY"#according to the meta
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data$sampledate=as.character(data$sampledate)
data.Export$LabMethodInfo[which(data$sampledate>"1992-12-31")]="Samples filtered through 0.7 um pre-ashed GF/F. Lachat AE autoanalyzer ascorbic acid/molybdate blue method  No. 10-115-01-1-B"
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= 1 #per meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
unique(data.Export$Comments)
data.Export$Subprogram="Cascade Project"
unique(data.Export$Subprogram)
drp.Final = data.Export
rm(data)
rm(data.Export)

################################### secchi #############################################################################################################################
data=paul_lake
names(data)#look at column names
#filter out columns of interest
data=data[,c(1,3)]
unique(data$secchi)#looking for unusual values that might need special attention
#filter out null values
length(data$secchi[which(is.na(data$secchi)==TRUE)])
length(data$secchi[which(data$secchi=="")])
387-142 #245 should remain after filtering out NA
data=data[which(is.na(data$secchi)==FALSE),]

#done filtering

#proceed to populating LAGOS template

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = NA 
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = "Paul Lake"
data.Export$SourceVariableName = "secchi"
data.Export$SourceVariableDescription = "Secchi depth"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no flags w/ these data
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 30
data.Export$LagosVariableName="Secchi"
names(data)
data.Export$Value = data$secchi #export observations already in prefferred units
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$sampledate #date already in correct format
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
data.Export$SampleDepth=NA
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY"#according to the meta
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="Secchi viewed from shady side of boat"
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
unique(data.Export$Comments)
data.Export$Subprogram="Cascade Project"
unique(data.Export$Subprogram)
secchi.Final = data.Export
rm(data)
rm(data.Export)


###################################### final export ########################################################################################
Final.Export = rbind(chla.Final,color.Final,doc.Final,nh4.Final,tp.Final,tn.Final,tkn.Final,no3no2.Final,drp.Final,secchi.Final)
###################################################################################################
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
0+1637#adds up to total
##write table
Final.Export1=data1
typeof(Final.Export1$Value)
length(Final.Export1$Value[which(Final.Export1$Value<0)])
nosamplepos=Final.Export1[which(is.na(Final.Export1$SampleDepth)==TRUE & Final.Export1$SamplePosition=="UNKNOWN"),]
write.table(Final.Export1,file="DataImport_MI_PAUL.csv",row.names=FALSE,sep=",")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MI data/Paul Lake (finished)/DataImport_MI_PAUL/DataImport_MI_PAUL.RData")
