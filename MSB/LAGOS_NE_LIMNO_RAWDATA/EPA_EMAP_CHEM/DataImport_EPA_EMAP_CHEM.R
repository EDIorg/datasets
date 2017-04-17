#set path to files
setwd("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/Northeast TIME RLTM/EPA EMAP (Finished)/DataImport_EPA_EMAP_CHEM")
setwd("C:/Users/Sam/Dropbox/CSI-LIMNO_DATA/DATA-lake/Northeast TIME RLTM/EPA EMAP (Finished)/DataImport_EPA_EMAP_CHEM")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/Northeast TIME RLTM/EPA EMAP (Finished)/DataImport_EPA_EMAP_CHEM/DataImport_EPA_EMAP_CHEM.RData")

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
#water chem survey of northeastern lakes (EPA) from 1991-94
#all chemistry = "GRAB" and "EPI" sample depth = 1.5 meters (see metadata protocol)
#LakeID and LakeName both specified
#null values= blank cell or "."
#there are data flags but the meaning of the flags not specified in meta.
###########################################################################################################################################################################################
################################### DOC #############################################################################################################################
data=EPA.EMAP
names(data) #looking at data
#pull out columns of interest
data=data[,c(1:2,4,15:16,19:20,23)]
names(data)
head(data)#looking at data
unique(data$DEP_SAMP) #note that not all samples were collected at 1.5 m as the metadata suggests
unique(data$DOC)#looking for unique values that could be a problem
length(data$DOC[which(data$DOC==".")]) # 5 are null
length(data$DOC[which(data$DOC=="")]) #25 more null
525-25-5 #filter these out 495 should remain
data=data[which(data$DOC!=""),]
data=data[which(data$DOC!="."),]
unique(data$LAKE_ID)#looking at lake id & checking for null lake id observations (next three lines)
length(data$LAKE_ID[which(data$LAKE_ID=="")])
length(data$LAKE_ID[which(data$LAKE_ID==".")])
length(data$LAKE_ID[which(is.na(data$LAKE_ID)==TRUE)])
#no null lake id obs.
unique(data$DATE_COL) #looking at date collected & checking for null dates
length(data$DATE_COL[which(data$DATE_COL=="")])
length(data$DATE_COL[which(data$DATE_COL==".")])
length(data$DATE_COL[which(is.na(data$DATE_COL)==TRUE)]) 
#no null dates
unique(data$DOCF)#the meaning of these data flags is specified in the import log
#note that all "HX" flags where X=1,2,..N. describe the number of days a sample was help before analysis
unique(data$COM_FLD) #export these to the comments field
#finished with filtering and looking at data

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$LAKE_ID
data.Export$LakeName = data$LAKENAME
data.Export$SourceVariableName = "DOC"
data.Export$SourceVariableDescription = "Dissolved organic C"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags= data$DOCF #meaning of flags specified in import log
length(data.Export$SourceFlags[which(data.Export$SourceFlags==" ")])
data.Export$SourceFlags[which(data.Export$SourceFlags==" ")]=NA
unique(data.Export$SourceFlags)
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 6
data.Export$LagosVariableName="Carbon, dissolved organic"
names(data)
data.Export$Value = data[,3] #export doc values already in preff. units of mg/L
data.Export$CensorCode = "NC" #no infor on CensorCode
data.Export$Date = data$DATE_COL #date already in correct format
data.Export$Units="mg/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all grab
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"#per metadata
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
#assign sampledepth 
unique(data$DEP_SAMP)#not all were collected at 1.5 meters as metadata suggests
length(data$DEP_SAMP[which(data$DEP_SAMP=="0.5")])
length(data$DEP_SAMP[which(data$DEP_SAMP=="1.5")])
length(data$DEP_SAMP[which(data$DEP_SAMP==".")])
length(data$DEP_SAMP[which(data$DEP_SAMP=="")])
21+223+251 #adds to total
#assign sample depth
data.Export$SampleDepth[which(data$DEP_SAMP=="0.5")]=0.5
data.Export$SampleDepth[which(data$DEP_SAMP=="1.5")]=1.5
data.Export$SampleDepth[which(data$DEP_SAMP==".")]=NA
data.Export$SampleDepth[which(data$DEP_SAMP=="")]=NA
unique(data.Export$SampleDepth)

#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY" #per methods in meta
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) #check to make sure all populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #no info in metadata
data.Export$Comments=as.character(data.Export$Comments)
unique(data.Export$SourceFlags)
data.Export$Comments[grep("H",data.Export$SourceFlags,ignore.case=FALSE)]= "Hxx=Holding time exceeded, xx indicates the number of days between sample collection and analysis."
data.Export$Comments[which(data.Export$SourceFlags=="V")]="V=Value appears to be very unusual during validation but further checks indicate that the value appears to be real."
unique(data.Export$Comments)
doc.Final = data.Export
rm(data.Export)
rm(data)


###################################  CHLA  #############################################################################################################################
data=EPA.EMAP
names(data) #looking at data
#pull out columns of interest
data=data[,c(1:2,11:12,15:16,19:20)]
names(data)
head(data)#looking at data
unique(data$DEP_SAMP) #note that not all samples were collected at 1.5 m as the metadata suggests
unique(data$CHLA)#looking for unique values that could be a problem
length(data$CHLA[which(data$CHLA==".")]) # 5 are null
length(data$CHLA[which(data$CHLA=="")]) #25 more null
525-25-8 #filter these out 492 should remain
data=data[which(data$CHLA!=""),]
data=data[which(data$CHLA!="."),]
unique(data$LAKE_ID)#looking at lake id & checking for null lake id observations (next three lines)
length(data$LAKE_ID[which(data$LAKE_ID=="")])
length(data$LAKE_ID[which(data$LAKE_ID==".")])
length(data$LAKE_ID[which(is.na(data$LAKE_ID)==TRUE)])
#no null lake id obs.
unique(data$DATE_COL) #looking at date collected & checking for null dates
length(data$DATE_COL[which(data$DATE_COL=="")])
length(data$DATE_COL[which(data$DATE_COL==".")])
length(data$DATE_COL[which(is.na(data$DATE_COL)==TRUE)]) 
#no null dates
unique(data$CLF) #flags specified in import log

#finished with filtering and looking at data

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$LAKE_ID
data.Export$LakeName = data$LAKENAME
data.Export$SourceVariableName = "CHLA"
data.Export$SourceVariableDescription = "Trichromatic Chlorophyll A"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags= data$CLF #meaning of flags specified in import log
length(data.Export$SourceFlags[which(data.Export$SourceFlags==" ")])
data.Export$SourceFlags[which(data.Export$SourceFlags==" ")]=NA
unique(data.Export$SourceFlags)
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA
#continue populating other lagos variables
data.Export$LagosVariableID = 9
data.Export$LagosVariableName="Chlorophyll a"
names(data)
data.Export$Value = data[,3] #export chla values already in preff. units of ug/L
data.Export$CensorCode = NA #no infor on CensorCode
data.Export$Date = data$DATE_COL #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all grab
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"#per metadata
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
#assign sampledepth 
unique(data$DEP_SAMP)#not all were collected at 1.5 meters as metadata suggests
length(data$DEP_SAMP[which(data$DEP_SAMP=="0.5")])
length(data$DEP_SAMP[which(data$DEP_SAMP=="1.5")])
length(data$DEP_SAMP[which(data$DEP_SAMP==".")])
length(data$DEP_SAMP[which(data$DEP_SAMP=="")])
21+222+249 #adds to total
#assign sample depth
data.Export$SampleDepth[which(data$DEP_SAMP=="0.5")]=0.5
data.Export$SampleDepth[which(data$DEP_SAMP=="1.5")]=1.5
data.Export$SampleDepth[which(data$DEP_SAMP==".")]=NA
data.Export$SampleDepth[which(data$DEP_SAMP=="")]=NA
unique(data.Export$SampleDepth)

#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY" #per methods in meta
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) #check to make sure all populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #no info in metadata
data.Export$Comments=as.character(data.Export$Comments)
unique(data.Export$SourceFlags)
data.Export$Comments[grep("H",data.Export$SourceFlags,ignore.case=FALSE)]= "Hxx=Holding time exceeded, xx indicates the number of days between sample collection and analysis."
data.Export$Comments[which(data.Export$SourceFlags=="V")]="V=Value appears to be very unusual during validation but further checks indicate that the value appears to be real."
data.Export$Comments[which(data.Export$SourceFlags=="L")]="L=Sample lost during analysis."
unique(data.Export$Comments)
chla.Final = data.Export
rm(data.Export)
rm(data)


################################### COLOR   #############################################################################################################################
data=EPA.EMAP
names(data) #looking at data
#pull out columns of interest
data=data[,c(1:2,13:14,15:16,19:20)]
names(data)
head(data)#looking at data
unique(data$DEP_SAMP) #note that not all samples were collected at 1.5 m as the metadata suggests
unique(data$COLOR)#looking for unique values that could be a problem
length(data$COLOR[which(data$COLOR==".")]) # 5 are null
length(data$COLOR[which(data$COLOR=="")]) #25 more null
525-25-5 #filter these out 495 should remain
data=data[which(data$COLOR!=""),]
data=data[which(data$COLOR!="."),]
unique(data$LAKE_ID)#looking at lake id & checking for null lake id observations (next three lines)
length(data$LAKE_ID[which(data$LAKE_ID=="")])
length(data$LAKE_ID[which(data$LAKE_ID==".")])
length(data$LAKE_ID[which(is.na(data$LAKE_ID)==TRUE)])
#no null lake id obs.
unique(data$DATE_COL) #looking at date collected & checking for null dates
length(data$DATE_COL[which(data$DATE_COL=="")])
length(data$DATE_COL[which(data$DATE_COL==".")])
length(data$DATE_COL[which(is.na(data$DATE_COL)==TRUE)]) 
#no null dates
unique(data$COLORF)#flags specified in import log

#finished with filtering and looking at data

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$LAKE_ID
data.Export$LakeName = data$LAKENAME
data.Export$SourceVariableName = "COLOR"
data.Export$SourceVariableDescription = "Color"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags= data$COLORF #meaning of flags specified in import log
length(data.Export$SourceFlags[which(data.Export$SourceFlags==" ")])
data.Export$SourceFlags[which(data.Export$SourceFlags==" ")]=NA
unique(data.Export$SourceFlags)
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA
#continue populating other lagos variables
data.Export$LagosVariableID = 12
data.Export$LagosVariableName="Color, true"
names(data)
data.Export$Value = data[,3] #export true color values already in preff. units of PCU
data.Export$CensorCode = NA #no infor on CensorCode
data.Export$Date = data$DATE_COL #date already in correct format
data.Export$Units="PCU"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all grab
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"#per metadata
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
#assign sampledepth 
unique(data$DEP_SAMP)#not all were collected at 1.5 meters as metadata suggests
length(data$DEP_SAMP[which(data$DEP_SAMP=="0.5")])
length(data$DEP_SAMP[which(data$DEP_SAMP=="1.5")])
length(data$DEP_SAMP[which(data$DEP_SAMP==".")])
length(data$DEP_SAMP[which(data$DEP_SAMP=="")])
21+223+251 #adds to total
#assign sample depth
data.Export$SampleDepth[which(data$DEP_SAMP=="0.5")]=0.5
data.Export$SampleDepth[which(data$DEP_SAMP=="1.5")]=1.5
data.Export$SampleDepth[which(data$DEP_SAMP==".")]=NA
data.Export$SampleDepth[which(data$DEP_SAMP=="")]=NA
unique(data.Export$SampleDepth)

#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY" #per methods in meta
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) #check to make sure all populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #no info in metadata
data.Export$Comments=as.character(data.Export$Comments)
unique(data.Export$SourceFlags)
data.Export$Comments[grep("H",data.Export$SourceFlags,ignore.case=FALSE)]= "Hxx=Holding time exceeded, xx indicates the number of days between sample collection and analysis."
data.Export$Comments[which(data.Export$SourceFlags=="V")]="V=Value appears to be very unusual during validation but further checks indicate that the value appears to be real."
data.Export$Comments[which(data.Export$SourceFlags=="L")]="L=Sample lost during analysis."
unique(data.Export$Comments)
tcolor.Final = data.Export
rm(data.Export)
rm(data)


###################################  NH4  #############################################################################################################################
data=EPA.EMAP
names(data) #looking at data
#pull out columns of interest
data=data[,c(1:2,32:33,15:16,19:20)]
names(data)
head(data)#looking at data
unique(data$DEP_SAMP) #note that not all samples were collected at 1.5 m as the metadata suggests
unique(data$NH4)#looking for unique values that could be a problem
length(data$NH4[which(data$NH4==".")]) # 5 are null
length(data$NH4[which(data$NH4=="")]) #25 more null
525-25-5 #filter these out 495 should remain
data=data[which(data$NH4!=""),]
data=data[which(data$NH4!="."),]
unique(data$LAKE_ID)#looking at lake id & checking for null lake id observations (next three lines)
length(data$LAKE_ID[which(data$LAKE_ID=="")])
length(data$LAKE_ID[which(data$LAKE_ID==".")])
length(data$LAKE_ID[which(is.na(data$LAKE_ID)==TRUE)])
#no null lake id obs.
unique(data$DATE_COL) #looking at date collected & checking for null dates
length(data$DATE_COL[which(data$DATE_COL=="")])
length(data$DATE_COL[which(data$DATE_COL==".")])
length(data$DATE_COL[which(is.na(data$DATE_COL)==TRUE)]) 
#no null dates
unique(data$NH4F)#flags specified in import log

#finished with filtering and looking at data

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$LAKE_ID
data.Export$LakeName = data$LAKENAME
data.Export$SourceVariableName = "NH4"
data.Export$SourceVariableDescription = "Ammonium (NH4)"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags= data$NH4F #meaning of flags specified in import log
length(data.Export$SourceFlags[which(data.Export$SourceFlags==" ")])
data.Export$SourceFlags[which(data.Export$SourceFlags==" ")]=NA
unique(data.Export$SourceFlags)
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA
#continue populating other lagos variables
data.Export$LagosVariableID = 19
data.Export$LagosVariableName="Nitrogen, NH4"
names(data)
data$NH4=as.numeric(data$NH4)
data.Export$Value = ((data[,3])/55.44)*1000 #export nh4 obs., convert from ueq/L to preferred ug/L
data.Export$Value=as.character(data.Export$Value)
data.Export$CensorCode = NA #no infor on CensorCode
data.Export$Date = data$DATE_COL #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all grab
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"#per metadata
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
#assign sampledepth 
unique(data$DEP_SAMP)#not all were collected at 1.5 meters as metadata suggests
length(data$DEP_SAMP[which(data$DEP_SAMP=="0.5")])
length(data$DEP_SAMP[which(data$DEP_SAMP=="1.5")])
length(data$DEP_SAMP[which(data$DEP_SAMP==".")])
length(data$DEP_SAMP[which(data$DEP_SAMP=="")])
21+223+251 #adds to total
#assign sample depth
data.Export$SampleDepth[which(data$DEP_SAMP=="0.5")]=0.5
data.Export$SampleDepth[which(data$DEP_SAMP=="1.5")]=1.5
data.Export$SampleDepth[which(data$DEP_SAMP==".")]=NA
data.Export$SampleDepth[which(data$DEP_SAMP=="")]=NA
unique(data.Export$SampleDepth)

#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY" #per methods in meta
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) #check to make sure all populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #no info in metadata
data.Export$Comments=as.character(data.Export$Comments)
unique(data.Export$SourceFlags)
data.Export$Comments[grep("H",data.Export$SourceFlags,ignore.case=FALSE)]= "Hxx=Holding time exceeded, xx indicates the number of days between sample collection and analysis."
data.Export$Comments[which(data.Export$SourceFlags=="V")]="V=Value appears to be very unusual during validation but further checks indicate that the value appears to be real."
data.Export$Comments[which(data.Export$SourceFlags=="L")]="L=Sample lost during analysis."
unique(data.Export$Comments)
nh4.Final = data.Export
rm(data.Export)
rm(data)


################################### NO3   #############################################################################################################################
data=EPA.EMAP
names(data) #looking at data
#pull out columns of interest
data=data[,c(1:2,34:35,15:16,19:20)]
names(data)
head(data)#looking at data
unique(data$DEP_SAMP) #note that not all samples were collected at 1.5 m as the metadata suggests
unique(data$NO3)#looking for unique values that could be a problem
length(data$NO3[which(data$NO3==".")]) # 5 are null
length(data$NO3[which(data$NO3=="")]) #25 more null
525-25-5 #filter these out 495 should remain
data=data[which(data$NO3!=""),]
data=data[which(data$NO3!="."),]
unique(data$LAKE_ID)#looking at lake id & checking for null lake id observations (next three lines)
length(data$LAKE_ID[which(data$LAKE_ID=="")])
length(data$LAKE_ID[which(data$LAKE_ID==".")])
length(data$LAKE_ID[which(is.na(data$LAKE_ID)==TRUE)])
#no null lake id obs.
unique(data$DATE_COL) #looking at date collected & checking for null dates
length(data$DATE_COL[which(data$DATE_COL=="")])
length(data$DATE_COL[which(data$DATE_COL==".")])
length(data$DATE_COL[which(is.na(data$DATE_COL)==TRUE)]) 
#no null dates
unique(data$NO3F)#source flag info specified in import log

#finished with filtering and looking at data

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$LAKE_ID
data.Export$LakeName = data$LAKENAME
data.Export$SourceVariableName = "NO3"
data.Export$SourceVariableDescription = "Nitrate (NO3)"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags= data$NO3F #meaning of flags specified in import log
length(data.Export$SourceFlags[which(data.Export$SourceFlags==" ")])
data.Export$SourceFlags[which(data.Export$SourceFlags==" ")]=NA
unique(data.Export$SourceFlags)
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA
#continue populating other lagos variables
data.Export$LagosVariableID = 18
data.Export$LagosVariableName="Nitrogen, nitrite (NO2) + nitrate (NO3)"
names(data)
data$NO3=as.numeric(data$NO3)
data.Export$Value = ((data[,3])/16.13)*1000 #export no3 obs., convert from ueq/L to preferred ug/L
data.Export$Value=as.character(data.Export$Value)
data.Export$CensorCode = NA #no infor on CensorCode
data.Export$Date = data$DATE_COL #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all grab
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"#per metadata
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
#assign sampledepth 
unique(data$DEP_SAMP)#not all were collected at 1.5 meters as metadata suggests
length(data$DEP_SAMP[which(data$DEP_SAMP=="0.5")])
length(data$DEP_SAMP[which(data$DEP_SAMP=="1.5")])
length(data$DEP_SAMP[which(data$DEP_SAMP==".")])
length(data$DEP_SAMP[which(data$DEP_SAMP=="")])
21+223+251 #adds to total
#assign sample depth
data.Export$SampleDepth[which(data$DEP_SAMP=="0.5")]=0.5
data.Export$SampleDepth[which(data$DEP_SAMP=="1.5")]=1.5
data.Export$SampleDepth[which(data$DEP_SAMP==".")]=NA
data.Export$SampleDepth[which(data$DEP_SAMP=="")]=NA
unique(data.Export$SampleDepth)

#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY" #per methods in meta
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) #check to make sure all populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #no info in metadata
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=as.character(data.Export$Comments)
unique(data.Export$SourceFlags)
data.Export$Comments[grep("H",data.Export$SourceFlags,ignore.case=FALSE)]= "Hxx=Holding time exceeded, xx indicates the number of days between sample collection and analysis."
data.Export$Comments[which(data.Export$SourceFlags=="V")]="V=Value appears to be very unusual during validation but further checks indicate that the value appears to be real."
data.Export$Comments[which(data.Export$SourceFlags=="L")]="L=Sample lost during analysis."
data.Export$Comments[which(data.Export$SourceFlags=="H8V")]="Hxx=Holding time exceeded, xx indicates the number of days between sample collection and analysis, V=V=Value appears to be very unusual during validation but further checks indicate that the value appears to be real."
unique(data.Export$Comments)
no3.Final = data.Export
rm(data.Export)
rm(data)


################################### NTL  #############################################################################################################################
data=EPA.EMAP
names(data) #looking at data
#pull out columns of interest
data=data[,c(1:2,36:37,15:16,19:20)]
names(data)
head(data)#looking at data
unique(data$DEP_SAMP) #note that not all samples were collected at 1.5 m as the metadata suggests
unique(data$NTL)#looking for unique values that could be a problem
length(data$NTL[which(data$NTL==".")]) # 5 are null
length(data$NTL[which(data$NTL=="")]) #25 more null
525-25-5 #filter these out 495 should remain
data=data[which(data$NTL!=""),]
data=data[which(data$NTL!="."),]
unique(data$LAKE_ID)#looking at lake id & checking for null lake id observations (next three lines)
length(data$LAKE_ID[which(data$LAKE_ID=="")])
length(data$LAKE_ID[which(data$LAKE_ID==".")])
length(data$LAKE_ID[which(is.na(data$LAKE_ID)==TRUE)])
#no null lake id obs.
unique(data$DATE_COL) #looking at date collected & checking for null dates
length(data$DATE_COL[which(data$DATE_COL=="")])
length(data$DATE_COL[which(data$DATE_COL==".")])
length(data$DATE_COL[which(is.na(data$DATE_COL)==TRUE)]) 
#no null dates
unique(data$NTLF)#source flag info specified in import log

#finished with filtering and looking at data

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$LAKE_ID
data.Export$LakeName = data$LAKENAME
data.Export$SourceVariableName = "NTL"
data.Export$SourceVariableDescription = "Total nitrogen"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags= data$NTLF #meaning of flags specified in import log
length(data.Export$SourceFlags[which(data.Export$SourceFlags==" ")])
data.Export$SourceFlags[which(data.Export$SourceFlags==" ")]=NA
unique(data.Export$SourceFlags)
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA
#continue populating other lagos variables
data.Export$LagosVariableID = 21
data.Export$LagosVariableName="Nitrogen, total"
names(data)
data.Export$Value = data[,3] #export tn obs. already in ug/L the preff. units
data.Export$CensorCode = NA #no infor on CensorCode
data.Export$Date = data$DATE_COL #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all grab
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"#per metadata
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
#assign sampledepth 
unique(data$DEP_SAMP)#not all were collected at 1.5 meters as metadata suggests
length(data$DEP_SAMP[which(data$DEP_SAMP=="0.5")])
length(data$DEP_SAMP[which(data$DEP_SAMP=="1.5")])
length(data$DEP_SAMP[which(data$DEP_SAMP==".")])
length(data$DEP_SAMP[which(data$DEP_SAMP=="")])
21+223+251 #adds to total
#assign sample depth
data.Export$SampleDepth[which(data$DEP_SAMP=="0.5")]=0.5
data.Export$SampleDepth[which(data$DEP_SAMP=="1.5")]=1.5
data.Export$SampleDepth[which(data$DEP_SAMP==".")]=NA
data.Export$SampleDepth[which(data$DEP_SAMP=="")]=NA
unique(data.Export$SampleDepth)

#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY" #per methods in meta
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) #check to make sure all populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #no info in metadata
data.Export$Comments=as.character(data.Export$Comments)
unique(data.Export$SourceFlags)
data.Export$Comments[grep("H",data.Export$SourceFlags,ignore.case=FALSE)]= "Hxx=Holding time exceeded, xx indicates the number of days between sample collection and analysis."
data.Export$Comments[which(data.Export$SourceFlags=="V")]="V=Value appears to be very unusual during validation but further checks indicate that the value appears to be real."
data.Export$Comments[which(data.Export$SourceFlags=="L")]="L=Sample lost during analysis."
data.Export$Comments[which(data.Export$SourceFlags=="U")]="U=Value appears to be very unusual during validation but further checks indicate that	the value appears to be real."
unique(data.Export$Comments)
tn.Final = data.Export
rm(data.Export)
rm(data)


################################### PTL  #############################################################################################################################
data=EPA.EMAP
names(data) #looking at data
#pull out columns of interest
data=data[,c(1:2,41:42,15:16,19:20)]
names(data)
head(data)#looking at data
unique(data$DEP_SAMP) #note that not all samples were collected at 1.5 m as the metadata suggests
unique(data$PTL)#looking for unique values that could be a problem
length(data$PTL[which(data$PTL==".")]) # 5 are null
length(data$PTL[which(data$PTL=="")]) #25 more null
525-25-5 #filter these out 495 should remain
data=data[which(data$PTL!=""),]
data=data[which(data$PTL!="."),]
unique(data$LAKE_ID)#looking at lake id & checking for null lake id observations (next three lines)
length(data$LAKE_ID[which(data$LAKE_ID=="")])
length(data$LAKE_ID[which(data$LAKE_ID==".")])
length(data$LAKE_ID[which(is.na(data$LAKE_ID)==TRUE)])
#no null lake id obs.
unique(data$DATE_COL) #looking at date collected & checking for null dates
length(data$DATE_COL[which(data$DATE_COL=="")])
length(data$DATE_COL[which(data$DATE_COL==".")])
length(data$DATE_COL[which(is.na(data$DATE_COL)==TRUE)]) 
#no null dates
unique(data$PTLF)#source flag info specified in import log

#finished with filtering and looking at data

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$LAKE_ID
data.Export$LakeName = data$LAKENAME
data.Export$SourceVariableName = "PTL"
data.Export$SourceVariableDescription = "Total phosphorus"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags= data$PTLF #meaning of flags specified in import log
length(data.Export$SourceFlags[which(data.Export$SourceFlags==" ")])
data.Export$SourceFlags[which(data.Export$SourceFlags==" ")]=NA
unique(data.Export$SourceFlags)
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA
#continue populating other lagos variables
data.Export$LagosVariableID = 27
data.Export$LagosVariableName="Phosphorus, total"
names(data)
data.Export$Value = data[,3] #export tp obs. already in ug/L the preff. units
data.Export$CensorCode = NA #no infor on CensorCode
data.Export$Date = data$DATE_COL #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all grab
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"#per metadata
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")])
#assign sampledepth 
unique(data$DEP_SAMP)#not all were collected at 1.5 meters as metadata suggests
length(data$DEP_SAMP[which(data$DEP_SAMP=="0.5")])
length(data$DEP_SAMP[which(data$DEP_SAMP=="1.5")])
length(data$DEP_SAMP[which(data$DEP_SAMP==".")])
length(data$DEP_SAMP[which(data$DEP_SAMP=="")])
21+223+251 #adds to total
#assign sample depth
data.Export$SampleDepth[which(data$DEP_SAMP=="0.5")]=0.5
data.Export$SampleDepth[which(data$DEP_SAMP=="1.5")]=1.5
data.Export$SampleDepth[which(data$DEP_SAMP==".")]=NA
data.Export$SampleDepth[which(data$DEP_SAMP=="")]=NA
unique(data.Export$SampleDepth)

#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY" #per methods in meta
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) #check to make sure all populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #no info in metadata
data.Export$Comments=as.character(data.Export$Comments)
unique(data.Export$SourceFlags)
data.Export$Comments[grep("H",data.Export$SourceFlags,ignore.case=FALSE)]= "Hxx=Holding time exceeded, xx indicates the number of days between sample collection and analysis."
data.Export$Comments[which(data.Export$SourceFlags=="V")]="V=Value appears to be very unusual during validation but further checks indicate that the value appears to be real."
data.Export$Comments[which(data.Export$SourceFlags=="L")]="L=Sample lost during analysis."
data.Export$Comments[which(data.Export$SourceFlags=="U")]="U=Value appears to be very unusual during validation but further checks indicate that  the value appears to be real."
data.Export$Comments[which(data.Export$SourceFlags=="X")]="X=Value appears to be very unusual during validation.  Further checking indicates some reason that the value is erroneous or impossible."
unique(data.Export$Comments)
tp.Final = data.Export
rm(data.Export)
rm(data)


################################### SECMEAN #############################################################################################################################
data=EPA.EMAP
names(data) #looking at data
#pull out columns of interest
data=data[,c(1:2,43,15:16,19:20)]
names(data)
head(data)#looking at data
unique(data$SECMEAN)#looking for unique values that could be a problem
length(data$SECMEAN[which(data$SECMEAN==".")]) # 5 are null
length(data$SECMEAN[which(data$SECMEAN=="")]) #25 more null
525-61-25 #filter these out 439 should remain
data=data[which(data$SECMEAN!=""),]
data=data[which(data$SECMEAN!="."),]
unique(data$LAKE_ID)#looking at lake id & checking for null lake id observations (next three lines)
length(data$LAKE_ID[which(data$LAKE_ID=="")])
length(data$LAKE_ID[which(data$LAKE_ID==".")])
length(data$LAKE_ID[which(is.na(data$LAKE_ID)==TRUE)])
#no null lake id obs.
unique(data$DATE_COL) #looking at date collected & checking for null dates
length(data$DATE_COL[which(data$DATE_COL=="")])
length(data$DATE_COL[which(data$DATE_COL==".")])
length(data$DATE_COL[which(is.na(data$DATE_COL)==TRUE)]) 
#no null dates

#finished with filtering and looking at data

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$LAKE_ID
data.Export$LakeName = data$LAKENAME
data.Export$SourceVariableName = "SECMEAN"
data.Export$SourceVariableDescription = "Secchi depth"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags= NA #secchi didn't have any associated source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA
#continue populating other lagos variables
data.Export$LagosVariableID = 30
data.Export$LagosVariableName="Secchi"
names(data)
data.Export$Value = data[,3] #export secchi obs. already in preff. units of meters
data.Export$CensorCode = NA #no infor on CensorCode
data.Export$Date = data$DATE_COL #date already in correct format
data.Export$Units="m"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED" #because secchi disk
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #check to make sure all grab
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition= "SPECIFIED" #BECAUSE SECCHI
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")])
#assign sampledepth 
data.Export$SampleDepth=NA #not applicable to secchi disk observations
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="PRIMARY" #per methods in meta
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")]) #check to make sure all populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #not applicable here
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments= NA
secchi.Final = data.Export
rm(data.Export)
rm(data)

########################################### final export ####################################################################################################################################
Final.Export = rbind(chla.Final,doc.Final,nh4.Final,no3.Final,secchi.Final,tcolor.Final,tn.Final,tp.Final)
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
7+3894#adds up to total
##write table
Final.Export1=data1
typeof(Final.Export1$Value)
Final.Export1$Value=as.character(Final.Export1$Value)
unique(Final.Export1$Value)
Final.Export1$Value=as.numeric(Final.Export1$Value)
unique(Final.Export1$Value)
length(Final.Export1$Value[which(Final.Export1$Value<0)])
write.table(Final.Export1,file="DataImport_EPA_EMAP_CHEM.csv",row.names=FALSE,sep=",")
nosamplepos=Final.Export1[which(is.na(Final.Export1$SampleDepth)==TRUE & Final.Export1$SamplePosition=="UNKNOWN"),]
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/Northeast TIME RLTM/EPA EMAP (Finished)/DataImport_EPA_EMAP_CHEM/DataImport_EPA_EMAP_CHEM.RData")
