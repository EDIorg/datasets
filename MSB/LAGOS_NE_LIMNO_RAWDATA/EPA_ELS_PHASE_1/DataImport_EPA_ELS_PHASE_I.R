#set path to files
setwd("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/EPA national surveys/IN-LAKE DATA/EASTERN LAKE SURVEY all (FINISHED)/DataImport_EPA_ELS_PHASE_I")
setwd("C:/Users/Sam/Dropbox/CSI-LIMNO_DATA/DATA-lake/EPA national surveys/IN-LAKE DATA/EASTERN LAKE SURVEY all (FINISHED)/DataImport_EPA_ELS_PHASE_I")


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

load("C:/Users/Sam/Dropbox/CSI-LIMNO_DATA/DATA-lake/EPA national surveys/IN-LAKE DATA/EASTERN LAKE SURVEY all (FINISHED)/DataImport_EPA_ELS_PHASE_I/DataImport_EPA_ELS_PHASE_I.RData")

#################################### General Notes ########################################################################################################################################
#us epa study to monitor the effects of acid deposition on easter surface waters
#each variable has unique column w/ flags
#samples are grab w/ van dorn, export van dorn to comments
#sample depth should be 1.5, but there is separate column specifying depth
#sample position should be specified.
###########################################################################################################################################################################################
################################### NH411    #############################################################################################################################
data=els_phase1_chem
names(data)#look at column names and pull out columns of interest
data=data[,c(37,48:49,63,67:71,90:92,99,127,134:137)]
names(data)
#many columns some filtered still are not relevant to this import effort
unique(data$NH411)#looking at data for problematic observations
#check for null values
length(data$NH411[which(data$NH411=="")])
#no null observations
#check for null sample depths
unique(data$DP_TOP)
length(data$DP_TOP[which(data$DP_TOP=="")])
#no null depths
#check for data flags
unique(data$NH411F)#many data flags, export to SourceFlags and specify in import log

#proceed to populating LAGOS template

#done filtering

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$LAKE_ID
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$LAKENAME
data.Export$SourceVariableName = "NH411"
data.Export$SourceVariableDescription = "Ammonium (NH4)"
#populate SourceFlags
unique(data$NH411F)
data$NH411F=as.character(data$NH411F)
source_flags = data.frame(B2=character(0),B3=character(0),B5=character(0),Z1=character(0),Z0=character(0), V0=character(0),W0=character(0),D2=character(0),combined=character(0))
source_flags[1:nrow(data),]=NA
source_flags$B2=as.character(source_flags$B2)
source_flags$B2[grep("B2",data$NH411F,ignore.case=TRUE)]="B2"
source_flags$B3=as.character(source_flags$B3)
source_flags$B3[grep("B3",data$NH411F,ignore.case=TRUE)]="B3"
source_flags$B5=as.character(source_flags$B5)
source_flags$B5[grep("B5",data$NH411F,ignore.case=TRUE)]="B5"
source_flags$Z1=as.character(source_flags$Z1)
source_flags$Z1[grep("Z1",data$NH411F,ignore.case=TRUE)]="Z1"
source_flags$Z0=as.character(source_flags$Z0)
source_flags$Z0[grep("Z0",data$NH411F,ignore.case=TRUE)]="Z0"
source_flags$W0=as.character(source_flags$W0)
source_flags$W0[grep("W0",data$NH411F,ignore.case=TRUE)]="W0"
source_flags$D2=as.character(source_flags$D2)
source_flags$D2[grep("D2",data$NH411F,ignore.case=TRUE)]="D2"
source_flags$V0=as.character(source_flags$V0)
source_flags$V0[grep("V0",data$NH411F,ignore.case=TRUE)]="V0"
source_flags$combined = paste(source_flags$B2,source_flags$B3,source_flags$B5,source_flags$Z1,source_flags$Z0, source_flags$V0, source_flags$W0, source_flags$W0, source_flags$D2,sep="; ")
data.Export$SourceFlags=source_flags$combined #remove NA values in text editor
data.Export$SourceFlags[which(data.Export$SourceFlags=="NA; NA; NA; NA; NA; NA; NA; NA; NA")]=NA
unique(data.Export$SourceFlags)

#continue populating other lagos variables
data.Export$LagosVariableID = 19
data.Export$LagosVariableName="Nitrogen, NH4"
names(data)
data.Export$Value = data$NH411*1000 #export observations and convert to preferred units
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$DATSMP #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="SPECIFIED"#per metadata
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")])
#assign sampledepth 
data.Export$SampleDepth=data$DP_TOP #meta specifies this is the depth at which sample collected
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="Automated colorimetry (phenate)"
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= 0.01*1000 #per meta
data.Export$Comments=as.character(data.Export$Comments)
# comments_flags = data.frame(B2=character(0),B3=character(0),B5=character(0),Z1=character(0),Z0=character(0), V0=character(0),W0=character(0),D2=character(0),B0=character(0),H0=character(0),U0=character(0),U1=character(0), U2=character(0), N5=character(0),combined=character(0))
# comments_flags[1:nrow(data),]=NA
# comments_flags$B2=as.character(comments_flags$B2)
# comments_flags$B2[grep("B2",data$NH411F,ignore.case=TRUE)]="B2= External (field) blank was above expected criteria and contributed more than 20% to sample values which were greater than ten times the required detection limit. (Flag not used for pH, DIC, DOC, acidity, or alkalinity determinations.)"
# comments_flags$B3=as.character(comments_flags$B3)
# comments_flags$B3[grep("B3",data$NH411F,ignore.case=TRUE)]="B3= Internal (laboratory) blank was more than twice the required detection limit and contributed more than 10% to the sample concentrations which were greater than ten times the required detection limit. (Flag not used for pH, DIC, DOC1 acidity, or alkalinity determinations.)"
# comments_flags$B5=as.character(comments_flags$B5)
# comments_flags$B5[grep("B5",data$NH411F,ignore.case=TRUE)]="B5 =Potential negative sample bias based on external (field) blank data."
# comments_flags$Z1=as.character(comments_flags$Z1)
# comments_flags$Z1[grep("Z1",data$NH411F,ignore.case=TRUE)]="Zl =Value was less than the system decision limit (nonparametric)."
# comments_flags$Z0=as.character(comments_flags$Z0)
# comments_flags$Z0[grep("Z0",data$NH411F,ignore.case=TRUE)]="Z0 =Original value was less than zero and has been replaced with zero."
# comments_flags$W0=as.character(comments_flags$W0)
# comments_flags$W0[grep("W0",data$NH411F,ignore.case=TRUE)]="W0 =Data value has possible measurement error, based on relationships with other variables, has QA violations, or is outside of QA windows for acceptable data."
# comments_flags$D2=as.character(comments_flags$D2)
# comments_flags$D2[grep("D2",data$NH411F,ignore.case=TRUE)]="D2= External (field) duplicate precision exceeded the maximum expected percent relative standard deviation, and both the routine and the duplicate sample concentrations were greater than ten times the required detection limit. "
# comments_flags$V0=as.character(comments_flags$V0)
# comments_flags$V0[grep("V0",data$NH411F,ignore.case=TRUE)]="V0= Data value represents the average from a duplicate split and measurement of the lake sample"
# comments_flags$B0=as.character(comments_flags$B0)
# comments_flags$B0[grep("B0",data$NH411F,ignore.case=TRUE)]="B0 =External (field) blank was above expected criteria. (For pH, DIC, DOC, conductance, alkalinity, and acidity determinations where the blank was above expected criteria)."
# comments_flags$U0=as.character(comments_flags$U0)
# comments_flags$U0[grep("U0",data$NH411F,ignore.case=TRUE)]="U0 =Known error based on relationships with other variables and/or impossible values; substitutions were made in data set 4."
# comments_flags$U1=as.character(comments_flags$U1)
# comments_flags$U1[grep("U1",data$NH411F,ignore.case=TRUE)]="Ul =Value is a substitution, original value was missing."
# comments_flags$U2=as.character(comments_flags$U2)
# comments_flags$U2[grep("U2",data$NH411F,ignore.case=TRUE)]="U2 =Value is a substitution, original value was considered to be in error."
# comments_flags$H0=as.character(comments_flags$H0)
# comments_flags$H0[grep("H0",data$NH411F,ignore.case=TRUE)]="H0 =The maximum holding time criteria were not met."
# comments_flags$N5=as.character(comments_flags$N5)
# comments_flags$N5[grep("N5",data$NH411F,ignore.case=TRUE)]="N5= N03 data obtained from analysis of aliquot 5."
# comments_flags$combined = paste(comments_flags$B2,comments_flags$B3,comments_flags$B5,comments_flags$Z1,comments_flags$Z0, comments_flags$V0, comments_flags$W0, comments_flags$W0, comments_flags$D2, comments_flags$B0, comments_flags$U0, comments_flags$U1, comments_flags$U2,comments_flags$H0, comments_flags$N5, sep="; ")
data.Export$Comments <- NA
unique(data.Export$Comments)
data.Export$Subprogram="USEPA-NAPAP"
unique(data.Export$Subprogram)
nh4.Final = data.Export
rm(data)
rm(source_flags)
rm(comments_flags)
rm(data.Export)

################################### DOC11   #############################################################################################################################
data=els_phase1_chem
names(data)#look at column names and pull out columns of interest
data=data[,c(37,45:46,48:49,63,67:71,99,127,134:137)]
names(data)
#many columns some filtered still are not relevant to this import effort
unique(data$DOC11)#looking at data for problematic observations
#check for null values
length(data$DOC11[which(data$DOC11=="")])
length(data$DOC11[which(is.na(data$DOC11)==TRUE)])
#no null observations
#check for null sample depths
unique(data$DP_TOP)
length(data$DP_TOP[which(data$DP_TOP=="")])
#no null depths
#check for data flags
unique(data$DOC11F)#many data flags, export to SourceFlags and specify in import log

#proceed to populating LAGOS template

#done filtering

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$LAKE_ID
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$LAKENAME
data.Export$SourceVariableName = "DOC11"
data.Export$SourceVariableDescription = "Dissolved organic C"
#populate SourceFlags
unique(data$DOC11F)
data$DOC11F=as.character(data$DOC11F)
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
source_flags = data.frame(B2=character(0),B3=character(0),B5=character(0),Z1=character(0),Z0=character(0), V0=character(0),W0=character(0),D2=character(0),B0=character(0),H0=character(0),U0=character(0),U1=character(0), U2=character(0),combined=character(0))
source_flags[1:nrow(data),]=NA
source_flags$B2=as.character(source_flags$B2)
source_flags$B2[grep("B2",data$DOC11F,ignore.case=TRUE)]="B2"
source_flags$B3=as.character(source_flags$B3)
source_flags$B3[grep("B3",data$DOC11F,ignore.case=TRUE)]="B3"
source_flags$B5=as.character(source_flags$B5)
source_flags$B5[grep("B5",data$DOC11F,ignore.case=TRUE)]="B5"
source_flags$Z1=as.character(source_flags$Z1)
source_flags$Z1[grep("Z1",data$DOC11F,ignore.case=TRUE)]="Z1"
source_flags$Z0=as.character(source_flags$Z0)
source_flags$Z0[grep("Z0",data$DOC11F,ignore.case=TRUE)]="Z0"
source_flags$W0=as.character(source_flags$W0)
source_flags$W0[grep("W0",data$DOC11F,ignore.case=TRUE)]="W0"
source_flags$D2=as.character(source_flags$D2)
source_flags$D2[grep("D2",data$DOC11F,ignore.case=TRUE)]="D2"
source_flags$V0=as.character(source_flags$V0)
source_flags$V0[grep("V0",data$DOC11F,ignore.case=TRUE)]="V0"
source_flags$B0=as.character(source_flags$B0)
source_flags$B0[grep("B0",data$DOC11F,ignore.case=TRUE)]="B0"
source_flags$U0=as.character(source_flags$U0)
source_flags$U0[grep("U0",data$DOC11F,ignore.case=TRUE)]="U0"
source_flags$U1=as.character(source_flags$U1)
source_flags$U1[grep("U1",data$DOC11F,ignore.case=TRUE)]="U1"
source_flags$U2=as.character(source_flags$U2)
source_flags$U2[grep("U2",data$DOC11F,ignore.case=TRUE)]="U2"
source_flags$H0=as.character(source_flags$H0)
source_flags$H0[grep("H0",data$DOC11F,ignore.case=TRUE)]="H0"
source_flags$combined = paste(source_flags$B2,source_flags$B3,source_flags$B5,source_flags$Z1,source_flags$Z0, source_flags$V0, source_flags$W0, source_flags$W0, source_flags$D2,source_flags$B0,source_flags$H0, source_flags$U0,source_flags$U0,source_flags$U1,source_flags$U2,sep="; ")
data.Export$SourceFlags=source_flags$combined #remove NA values in text editor
unique(data.Export$SourceFlags)
source_flags$combined = paste(source_flags$B2,source_flags$B3,source_flags$B5,source_flags$Z1,source_flags$Z0, source_flags$V0, source_flags$W0, source_flags$W0, source_flags$D2,source_flags$B0,source_flags$H0, source_flags$U0,source_flags$U0,source_flags$U1,source_flags$U2,sep="; ")
data.Export$SourceFlags=source_flags$combined #remove NA values in text editor
unique(data.Export$SourceFlags)
data.Export$SourceFlags[which(data.Export$SourceFlags=="NA; NA; NA; NA; NA; NA; NA; NA; NA; NA; NA; NA; NA; NA; NA")]=NA
unique(data.Export$SourceFlags)

#continue populating other lagos variables
data.Export$LagosVariableID = 6
data.Export$LagosVariableName="Carbon, dissolved organic"
names(data)
data.Export$Value = data$DOC11 #export observations already in preffered units
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$DATSMP #date already in correct format
data.Export$Units="mg/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="SPECIFIED"#per metadata
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")])
#assign sampledepth 
data.Export$SampleDepth=data$DP_TOP #meta specifies this is the depth at which sample collected
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="Instrument (ultraviolet-promoted oxidation, CO2 generation, infrared radiation detection)"
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= 0.10 #per meta
data.Export$Comments=as.character(data.Export$Comments)
# comments_flags = data.frame(B2=character(0),B3=character(0),B5=character(0),Z1=character(0),Z0=character(0), V0=character(0),W0=character(0),D2=character(0),B0=character(0),H0=character(0),U0=character(0),U1=character(0), U2=character(0), N5=character(0),combined=character(0))
# comments_flags[1:nrow(data),]=NA
# comments_flags$B2=as.character(comments_flags$B2)
# comments_flags$B2[grep("B2",data$DOC11F,ignore.case=TRUE)]="B2= External (field) blank was above expected criteria and contributed more than 20% to sample values which were greater than ten times the required detection limit. (Flag not used for pH, DIC, DOC, acidity, or alkalinity determinations.)"
# comments_flags$B3=as.character(comments_flags$B3)
# comments_flags$B3[grep("B3",data$DOC11F,ignore.case=TRUE)]="B3= Internal (laboratory) blank was more than twice the required detection limit and contributed more than 10% to the sample concentrations which were greater than ten times the required detection limit. (Flag not used for pH, DIC, DOC1 acidity, or alkalinity determinations.)"
# comments_flags$B5=as.character(comments_flags$B5)
# comments_flags$B5[grep("B5",data$DOC11F,ignore.case=TRUE)]="B5 =Potential negative sample bias based on external (field) blank data."
# comments_flags$Z1=as.character(comments_flags$Z1)
# comments_flags$Z1[grep("Z1",data$DOC11F,ignore.case=TRUE)]="Zl =Value was less than the system decision limit (nonparametric)."
# comments_flags$Z0=as.character(comments_flags$Z0)
# comments_flags$Z0[grep("Z0",data$DOC11F,ignore.case=TRUE)]="Z0 =Original value was less than zero and has been replaced with zero."
# comments_flags$W0=as.character(comments_flags$W0)
# comments_flags$W0[grep("W0",data$DOC11F,ignore.case=TRUE)]="W0 =Data value has possible measurement error, based on relationships with other variables, has QA violations, or is outside of QA windows for acceptable data."
# comments_flags$D2=as.character(comments_flags$D2)
# comments_flags$D2[grep("D2",data$DOC11F,ignore.case=TRUE)]="D2= External (field) duplicate precision exceeded the maximum expected percent relative standard deviation, and both the routine and the duplicate sample concentrations were greater than ten times the required detection limit. "
# comments_flags$V0=as.character(comments_flags$V0)
# comments_flags$V0[grep("V0",data$DOC11F,ignore.case=TRUE)]="V0= Data value represents the average from a duplicate split and measurement of the lake sample"
# comments_flags$B0=as.character(comments_flags$B0)
# comments_flags$B0[grep("B0",data$DOC11F,ignore.case=TRUE)]="B0 =External (field) blank was above expected criteria. (For pH, DIC, DOC, conductance, alkalinity, and acidity determinations where the blank was above expected criteria)."
# comments_flags$U0=as.character(comments_flags$U0)
# comments_flags$U0[grep("U0",data$DOC11F,ignore.case=TRUE)]="U0 =Known error based on relationships with other variables and/or impossible values; substitutions were made in data set 4."
# comments_flags$U1=as.character(comments_flags$U1)
# comments_flags$U1[grep("U1",data$DOC11F,ignore.case=TRUE)]="Ul =Value is a substitution, original value was missing."
# comments_flags$U2=as.character(comments_flags$U2)
# comments_flags$U2[grep("U2",data$DOC11F,ignore.case=TRUE)]="U2 =Value is a substitution, original value was considered to be in error."
# comments_flags$H0=as.character(comments_flags$H0)
# comments_flags$H0[grep("H0",data$DOC11F,ignore.case=TRUE)]="H0 =The maximum holding time criteria were not met."
# comments_flags$N5=as.character(comments_flags$N5)
# comments_flags$N5[grep("N5",data$DOC11F,ignore.case=TRUE)]="N5= N03 data obtained from analysis of aliquot 5."
# comments_flags$combined = paste(comments_flags$B2,comments_flags$B3,comments_flags$B5,comments_flags$Z1,comments_flags$Z0, comments_flags$V0, comments_flags$W0, comments_flags$W0, comments_flags$D2, comments_flags$B0, comments_flags$U0, comments_flags$U1, comments_flags$U2,comments_flags$H0, comments_flags$N5, sep="; ")
# data.Export$Comments=comments_flags$combined
data.Export$Comments <- NA
unique(data.Export$Comments)
data.Export$Subprogram="USEPA-NAPAP"
unique(data.Export$Subprogram)
doc.Final = data.Export
rm(data)
rm(data.Export)
rm(source_flags)
rm(comments_flags)
################################### COLVAL #############################################################################################################################
data=els_phase1_chem
names(data)#look at column names and pull out columns of interest
data=data[,c(37,26:27,48:49,63,67:71,99,127,134:137)]
names(data)
#many columns some filtered still are not relevant to this import effort
unique(data$COLVAL)#looking at data for problematic observations
#check for null values
length(data$COLVAL[which(data$COLVAL=="")])
length(data$COLVAL[which(is.na(data$COLVAL)==TRUE)])
#no null observations
#check for null sample depths
unique(data$DP_TOP)
length(data$DP_TOP[which(data$DP_TOP=="")])
#no null depths
#check for data flags
unique(data$COLVALF)#many data flags, export to SourceFlags and specify in import log

#proceed to populating LAGOS template

#done filtering

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$LAKE_ID
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$LAKENAME
data.Export$SourceVariableName = "COLVAL"
data.Export$SourceVariableDescription = "color"
#populate SourceFlags
unique(data$COLVALF)
data$COLVALF=as.character(data$COLVALF)
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=data$COLVALF
data.Export$SourceFlags[which(data.Export$SourceFlags==" ")]=NA
unique(data.Export$SourceFlags)#be sure to export definitions in comments field

#continue populating other lagos variables
data.Export$LagosVariableID = 12
data.Export$LagosVariableName="Color, true"
names(data)
data.Export$Value = data$COLVAL #export observations already in preffered units
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$DATSMP #date already in correct format
data.Export$Units="PCU"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="SPECIFIED"#per metadata
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")])
#assign sampledepth 
data.Export$SampleDepth=data$DP_TOP #meta specifies this is the depth at which sample collected
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="Comparison to platinum-cobalt color standards"
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #per meta
data.Export$Comments=as.character(data.Export$Comments)
# unique(data.Export$SourceFlags)
# data.Export$Comments[which(data.Export$SourceFlags=="V0")]="V0=Data value represents the average from a duplicate split and measurement of the lake sample."
# data.Export$Comments[which(data.Export$SourceFlags=="W0")]="W0=Data value has possible measurement error, based on relationships with other variables, has QA violations, or is outside of QA windows for acceptable data"
# data.Export$Comments[which(data.Export$SourceFlags=="U1")]="U1=Value is a substitution, original value was missing."
# data.Export$Comments[which(is.na(data.Export$SourceFlags)==TRUE)]=NA
data.Export$Comments <- NA
unique(data.Export$Comments)
data.Export$Subprogram="USEPA-NAPAP"
unique(data.Export$Subprogram)
color.Final = data.Export
rm(data)
rm(data.Export)

################################### NO311  #############################################################################################################################
data=els_phase1_chem
names(data)#look at column names and pull out columns of interest
data=data[,c(37,93:94,48:49,63,67:71,99,127,134:137)]
names(data)
#many columns some filtered still are not relevant to this import effort
unique(data$NO311)#looking at data for problematic observations
#check for null values
length(data$NO311[which(data$NO311=="")])
length(data$NO311[which(is.na(data$NO311)==TRUE)])
#no null observations
#check for null sample depths
unique(data$DP_TOP)
length(data$DP_TOP[which(data$DP_TOP=="")])
#no null depths
#check for data flags
unique(data$NO311F)#many data flags, export to SourceFlags and specify in import log

#proceed to populating LAGOS template

#done filtering

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$LAKE_ID
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$LAKENAME
data.Export$SourceVariableName = "NO311"
data.Export$SourceVariableDescription = "Nitrate"
#populate SourceFlags
unique(data$NO311F)
data$NO311F=as.character(data$NO311F)
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
source_flags = data.frame(B2=character(0),B3=character(0),B5=character(0),Z1=character(0),Z0=character(0), V0=character(0),W0=character(0),D2=character(0),B0=character(0),H0=character(0),U0=character(0),U1=character(0), U2=character(0), N5=character(0),combined=character(0))
source_flags[1:nrow(data),]=NA
source_flags$B2=as.character(source_flags$B2)
source_flags$B2[grep("B2",data$NO311F,ignore.case=TRUE)]="B2"
source_flags$B3=as.character(source_flags$B3)
source_flags$B3[grep("B3",data$NO311F,ignore.case=TRUE)]="B3"
source_flags$B5=as.character(source_flags$B5)
source_flags$B5[grep("B5",data$NO311F,ignore.case=TRUE)]="B5"
source_flags$Z1=as.character(source_flags$Z1)
source_flags$Z1[grep("Z1",data$NO311F,ignore.case=TRUE)]="Z1"
source_flags$Z0=as.character(source_flags$Z0)
source_flags$Z0[grep("Z0",data$NO311F,ignore.case=TRUE)]="Z0"
source_flags$W0=as.character(source_flags$W0)
source_flags$W0[grep("W0",data$NO311F,ignore.case=TRUE)]="W0"
source_flags$D2=as.character(source_flags$D2)
source_flags$D2[grep("D2",data$NO311F,ignore.case=TRUE)]="D2"
source_flags$V0=as.character(source_flags$V0)
source_flags$V0[grep("V0",data$NO311F,ignore.case=TRUE)]="V0"
source_flags$B0=as.character(source_flags$B0)
source_flags$B0[grep("B0",data$NO311F,ignore.case=TRUE)]="B0"
source_flags$U0=as.character(source_flags$U0)
source_flags$U0[grep("U0",data$NO311F,ignore.case=TRUE)]="U0"
source_flags$U1=as.character(source_flags$U1)
source_flags$U1[grep("U1",data$NO311F,ignore.case=TRUE)]="U1"
source_flags$U2=as.character(source_flags$U2)
source_flags$U2[grep("U2",data$NO311F,ignore.case=TRUE)]="U2"
source_flags$H0=as.character(source_flags$H0)
source_flags$H0[grep("H0",data$NO311F,ignore.case=TRUE)]="H0"
source_flags$N5=as.character(source_flags$N5)
source_flags$N5[grep("N5",data$NO311F,ignore.case=TRUE)]="N5"
source_flags$combined = paste(source_flags$B2,source_flags$B3,source_flags$B5,source_flags$Z1,source_flags$Z0, source_flags$V0, source_flags$W0, source_flags$W0, source_flags$D2,source_flags$B0,source_flags$H0, source_flags$U0,source_flags$U0,source_flags$U1,source_flags$U2, source_flags$N5,sep="; ")
data.Export$SourceFlags=source_flags$combined #remove NA values in text editor
unique(data.Export$SourceFlags)


#continue populating other lagos variables
data.Export$LagosVariableID = 18
data.Export$LagosVariableName="Nitrogen, nitrite (NO2) + nitrate (NO3)"
names(data)
data.Export$Value = data$NO311*1000 #export obs and convert to preferred units
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$DATSMP #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="SPECIFIED"#per metadata
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")])
#assign sampledepth 
data.Export$SampleDepth=data$DP_TOP #meta specifies this is the depth at which sample collected
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="Ion chromotography"
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= 0.005*1000 #per meta
data.Export$Comments=as.character(data.Export$Comments)
# comments_flags = data.frame(B2=character(0),B3=character(0),B5=character(0),Z1=character(0),Z0=character(0), V0=character(0),W0=character(0),D2=character(0),B0=character(0),H0=character(0),U0=character(0),U1=character(0), U2=character(0), N5=character(0),combined=character(0))
# comments_flags[1:nrow(data),]=NA
# comments_flags$B2=as.character(comments_flags$B2)
# comments_flags$B2[grep("B2",data$NO311F,ignore.case=TRUE)]="B2= External (field) blank was above expected criteria and contributed more than 20% to sample values which were greater than ten times the required detection limit. (Flag not used for pH, DIC, DOC, acidity, or alkalinity determinations.)"
# comments_flags$B3=as.character(comments_flags$B3)
# comments_flags$B3[grep("B3",data$NO311F,ignore.case=TRUE)]="B3= Internal (laboratory) blank was more than twice the required detection limit and contributed more than 10% to the sample concentrations which were greater than ten times the required detection limit. (Flag not used for pH, DIC, DOC1 acidity, or alkalinity determinations.)"
# comments_flags$B5=as.character(comments_flags$B5)
# comments_flags$B5[grep("B5",data$NO311F,ignore.case=TRUE)]="B5 =Potential negative sample bias based on external (field) blank data."
# comments_flags$Z1=as.character(comments_flags$Z1)
# comments_flags$Z1[grep("Z1",data$NO311F,ignore.case=TRUE)]="Zl =Value was less than the system decision limit (nonparametric)."
# comments_flags$Z0=as.character(comments_flags$Z0)
# comments_flags$Z0[grep("Z0",data$NO311F,ignore.case=TRUE)]="Z0 =Original value was less than zero and has been replaced with zero."
# comments_flags$W0=as.character(comments_flags$W0)
# comments_flags$W0[grep("W0",data$NO311F,ignore.case=TRUE)]="W0 =Data value has possible measurement error, based on relationships with other variables, has QA violations, or is outside of QA windows for acceptable data."
# comments_flags$D2=as.character(comments_flags$D2)
# comments_flags$D2[grep("D2",data$NO311F,ignore.case=TRUE)]="D2= External (field) duplicate precision exceeded the maximum expected percent relative standard deviation, and both the routine and the duplicate sample concentrations were greater than ten times the required detection limit. "
# comments_flags$V0=as.character(comments_flags$V0)
# comments_flags$V0[grep("V0",data$NO311F,ignore.case=TRUE)]="V0= Data value represents the average from a duplicate split and measurement of the lake sample"
# comments_flags$B0=as.character(comments_flags$B0)
# comments_flags$B0[grep("B0",data$NO311F,ignore.case=TRUE)]="B0 =External (field) blank was above expected criteria. (For pH, DIC, DOC, conductance, alkalinity, and acidity determinations where the blank was above expected criteria)."
# comments_flags$U0=as.character(comments_flags$U0)
# comments_flags$U0[grep("U0",data$NO311F,ignore.case=TRUE)]="U0 =Known error based on relationships with other variables and/or impossible values; substitutions were made in data set 4."
# comments_flags$U1=as.character(comments_flags$U1)
# comments_flags$U1[grep("U1",data$NO311F,ignore.case=TRUE)]="Ul =Value is a substitution, original value was missing."
# comments_flags$U2=as.character(comments_flags$U2)
# comments_flags$U2[grep("U2",data$NO311F,ignore.case=TRUE)]="U2 =Value is a substitution, original value was considered to be in error."
# comments_flags$H0=as.character(comments_flags$H0)
# comments_flags$H0[grep("H0",data$NO311F,ignore.case=TRUE)]="H0 =The maximum holding time criteria were not met."
# comments_flags$N5=as.character(comments_flags$N5)
# comments_flags$N5[grep("N5",data$NO311F,ignore.case=TRUE)]="N5= N03 data obtained from analysis of aliquot 5."
# comments_flags$combined = paste(comments_flags$B2,comments_flags$B3,comments_flags$B5,comments_flags$Z1,comments_flags$Z0, comments_flags$V0, comments_flags$W0, comments_flags$W0, comments_flags$D2, comments_flags$B0, comments_flags$U0, comments_flags$U1, comments_flags$U2,comments_flags$H0, comments_flags$N5, sep="; ")
# data.Export$Comments=comments_flags$combined
data.Export$Comments <- NA
unique(data.Export$Comments)
data.Export$Subprogram="USEPA-NAPAP"
unique(data.Export$Subprogram)
no3.Final = data.Export
rm(data)
rm(data.Export)
rm(source_flags)
rm(comments_flags)
################################### PTL11  #############################################################################################################################
data=els_phase1_chem
names(data)#look at column names and pull out columns of interest
data=data[,c(37,113:114,48:49,63,67:71,99,127,134:137)]
names(data)
#many columns some filtered still are not relevant to this import effort
unique(data$PTL11)#looking at data for problematic observations
#check for null values
length(data$PTL11[which(data$PTL11=="")])
length(data$PTL11[which(is.na(data$PTL11)==TRUE)])
#no null observations
#check for null sample depths
unique(data$DP_TOP)
length(data$DP_TOP[which(data$DP_TOP=="")])
#no null depths
#check for data flags
unique(data$PTL11F)#many data flags, export to SourceFlags and specify in import log

#proceed to populating LAGOS template

#done filtering

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$LAKE_ID
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$LAKENAME
data.Export$SourceVariableName = "PTL11"
data.Export$SourceVariableDescription = "Total phosphorus"
#populate SourceFlags
unique(data$PTL11F)
data$PTL11F=as.character(data$PTL11F)
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
source_flags = data.frame(B2=character(0),B3=character(0),B5=character(0),Z1=character(0),Z0=character(0), V0=character(0),W0=character(0),D2=character(0),B0=character(0),H0=character(0),U0=character(0),U1=character(0), U2=character(0), N5=character(0),combined=character(0))
source_flags[1:nrow(data),]=NA
source_flags$B2=as.character(source_flags$B2)
source_flags$B2[grep("B2",data$PTL11F,ignore.case=TRUE)]="B2"
source_flags$B3=as.character(source_flags$B3)
source_flags$B3[grep("B3",data$PTL11F,ignore.case=TRUE)]="B3"
source_flags$B5=as.character(source_flags$B5)
source_flags$B5[grep("B5",data$PTL11F,ignore.case=TRUE)]="B5"
source_flags$Z1=as.character(source_flags$Z1)
source_flags$Z1[grep("Z1",data$PTL11F,ignore.case=TRUE)]="Z1"
source_flags$Z0=as.character(source_flags$Z0)
source_flags$Z0[grep("Z0",data$PTL11F,ignore.case=TRUE)]="Z0"
source_flags$W0=as.character(source_flags$W0)
source_flags$W0[grep("W0",data$PTL11F,ignore.case=TRUE)]="W0"
source_flags$D2=as.character(source_flags$D2)
source_flags$D2[grep("D2",data$PTL11F,ignore.case=TRUE)]="D2"
source_flags$V0=as.character(source_flags$V0)
source_flags$V0[grep("V0",data$PTL11F,ignore.case=TRUE)]="V0"
source_flags$B0=as.character(source_flags$B0)
source_flags$B0[grep("B0",data$PTL11F,ignore.case=TRUE)]="B0"
source_flags$U0=as.character(source_flags$U0)
source_flags$U0[grep("U0",data$PTL11F,ignore.case=TRUE)]="U0"
source_flags$U1=as.character(source_flags$U1)
source_flags$U1[grep("U1",data$PTL11F,ignore.case=TRUE)]="U1"
source_flags$U2=as.character(source_flags$U2)
source_flags$U2[grep("U2",data$PTL11F,ignore.case=TRUE)]="U2"
source_flags$H0=as.character(source_flags$H0)
source_flags$H0[grep("H0",data$PTL11F,ignore.case=TRUE)]="H0"
source_flags$N5=as.character(source_flags$N5)
source_flags$N5[grep("N5",data$PTL11F,ignore.case=TRUE)]="N5"
source_flags$combined = paste(source_flags$B2,source_flags$B3,source_flags$B5,source_flags$Z1,source_flags$Z0, source_flags$V0, source_flags$W0, source_flags$W0, source_flags$D2,source_flags$B0,source_flags$H0, source_flags$U0,source_flags$U0,source_flags$U1,source_flags$U2, source_flags$N5,sep="; ")
data.Export$SourceFlags=source_flags$combined #remove NA values in text editor
unique(data.Export$SourceFlags)


#continue populating other lagos variables
data.Export$LagosVariableID = 27
data.Export$LagosVariableName="Phosphorus, total"
names(data)
data.Export$Value = data$PTL11 #export obs already in correct units
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$DATSMP #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #check to make sure all integrated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="SPECIFIED"#per metadata
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")])
#assign sampledepth 
data.Export$SampleDepth=data$DP_TOP #meta specifies this is the depth at which sample collected
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="Automated colorimetry (phosphomulbdate)"
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= 0.002*1000 #per meta
data.Export$Comments=as.character(data.Export$Comments)
# comments_flags = data.frame(B2=character(0),B3=character(0),B5=character(0),Z1=character(0),Z0=character(0), V0=character(0),W0=character(0),D2=character(0),B0=character(0),H0=character(0),U0=character(0),U1=character(0), U2=character(0), N5=character(0),combined=character(0))
# comments_flags[1:nrow(data),]=NA
# comments_flags$B2=as.character(comments_flags$B2)
# comments_flags$B2[grep("B2",data$PTL11F,ignore.case=TRUE)]="B2= External (field) blank was above expected criteria and contributed more than 20% to sample values which were greater than ten times the required detection limit. (Flag not used for pH, DIC, DOC, acidity, or alkalinity determinations.)"
# comments_flags$B3=as.character(comments_flags$B3)
# comments_flags$B3[grep("B3",data$PTL11F,ignore.case=TRUE)]="B3= Internal (laboratory) blank was more than twice the required detection limit and contributed more than 10% to the sample concentrations which were greater than ten times the required detection limit. (Flag not used for pH, DIC, DOC1 acidity, or alkalinity determinations.)"
# comments_flags$B5=as.character(comments_flags$B5)
# comments_flags$B5[grep("B5",data$PTL11F,ignore.case=TRUE)]="B5 =Potential negative sample bias based on external (field) blank data."
# comments_flags$Z1=as.character(comments_flags$Z1)
# comments_flags$Z1[grep("Z1",data$PTL11F,ignore.case=TRUE)]="Zl =Value was less than the system decision limit (nonparametric)."
# comments_flags$Z0=as.character(comments_flags$Z0)
# comments_flags$Z0[grep("Z0",data$PTL11F,ignore.case=TRUE)]="Z0 =Original value was less than zero and has been replaced with zero."
# comments_flags$W0=as.character(comments_flags$W0)
# comments_flags$W0[grep("W0",data$PTL11F,ignore.case=TRUE)]="W0 =Data value has possible measurement error, based on relationships with other variables, has QA violations, or is outside of QA windows for acceptable data."
# comments_flags$D2=as.character(comments_flags$D2)
# comments_flags$D2[grep("D2",data$PTL11F,ignore.case=TRUE)]="D2= External (field) duplicate precision exceeded the maximum expected percent relative standard deviation, and both the routine and the duplicate sample concentrations were greater than ten times the required detection limit. "
# comments_flags$V0=as.character(comments_flags$V0)
# comments_flags$V0[grep("V0",data$PTL11F,ignore.case=TRUE)]="V0= Data value represents the average from a duplicate split and measurement of the lake sample"
# comments_flags$B0=as.character(comments_flags$B0)
# comments_flags$B0[grep("B0",data$PTL11F,ignore.case=TRUE)]="B0 =External (field) blank was above expected criteria. (For pH, DIC, DOC, conductance, alkalinity, and acidity determinations where the blank was above expected criteria)."
# comments_flags$U0=as.character(comments_flags$U0)
# comments_flags$U0[grep("U0",data$PTL11F,ignore.case=TRUE)]="U0 =Known error based on relationships with other variables and/or impossible values; substitutions were made in data set 4."
# comments_flags$U1=as.character(comments_flags$U1)
# comments_flags$U1[grep("U1",data$PTL11F,ignore.case=TRUE)]="Ul =Value is a substitution, original value was missing."
# comments_flags$U2=as.character(comments_flags$U2)
# comments_flags$U2[grep("U2",data$PTL11F,ignore.case=TRUE)]="U2 =Value is a substitution, original value was considered to be in error."
# comments_flags$H0=as.character(comments_flags$H0)
# comments_flags$H0[grep("H0",data$PTL11F,ignore.case=TRUE)]="H0 =The maximum holding time criteria were not met."
# comments_flags$N5=as.character(comments_flags$N5)
# comments_flags$N5[grep("N5",data$PTL11F,ignore.case=TRUE)]="N5= N03 data obtained from analysis of aliquot 5."
# comments_flags$combined = paste(comments_flags$B2,comments_flags$B3,comments_flags$B5,comments_flags$Z1,comments_flags$Z0, comments_flags$V0, comments_flags$W0, comments_flags$W0, comments_flags$D2, comments_flags$B0, comments_flags$U0, comments_flags$U1, comments_flags$U2,comments_flags$H0, comments_flags$N5, sep="; ")
# data.Export$Comments=comments_flags$combined
data.Export$Comments <- NA
unique(data.Export$Comments)
data.Export$Subprogram="USEPA-NAPAP"
unique(data.Export$Subprogram)
tp.Final = data.Export
rm(data)
rm(data.Export)
rm(source_flags)
rm(comments_flags)
################################### SECMean  #############################################################################################################################
data=els_phase1_chem
names(data)#look at column names and pull out columns of interest
data=data[,c(37,123,48:49,63,67:71,99,127,134:137)]
names(data)
#many columns some filtered still are not relevant to this import effort
unique(data$SECMEAN)#looking at data for problematic observations
#remove "." observations
data=data[which(data$SECMEAN!="."),]#only 5 observations removed
#check for null values
length(data$SECMEAN[which(data$SECMEAN=="")])
length(data$SECMEAN[which(is.na(data$SECMEAN)==TRUE)])
#no null observations

#no data flags for secchi disk observations

#proceed to populating LAGOS template

#done filtering

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$LAKE_ID
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = data$LAKENAME
data.Export$SourceVariableName = "SECMEAN"
data.Export$SourceVariableDescription = "Mean secchi depth"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA
#continue populating other lagos variables
data.Export$LagosVariableID = 30
data.Export$LagosVariableName="Secchi"
names(data)
data.Export$Value = data$SECMEAN #export obs already in correct units
data.Export$CensorCode = "NC" #none censored
unique(data.Export$CensorCode)
data.Export$Date = data$DATSMP #date already in correct format
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
data.Export$SampleDepth=NA # because secchi
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"
unique(data.Export$BasinType)
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = "SECCHI_VIEW_UNKNOWN"
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo="Determined as the average of the disappear and reappear depths"
unique(data.Export$LabMethodInfo)#look at unique values exported
data.Export$DetectionLimit= NA #per meta
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=NA
unique(data.Export$Comments)
data.Export$Subprogram="USEPA-NAPAP"
unique(data.Export$Subprogram)
secchi.Final = data.Export
rm(data)
rm(data.Export)

###################################### final export ########################################################################################
Final.Export = rbind(color.Final,doc.Final,nh4.Final,no3.Final,tp.Final,secchi.Final)
###################################################################################################################################
##Duplicates check #an observation is defined as duplicate if it is NOT unique for programid, lagoslakeid, date, sampledepth, sampleposition, lagosvariableid, datavalue
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
0+10783#adds up to total
##write table
Final.Export1=data1
typeof(Final.Export1$Value)
length(Final.Export1$Value[which(Final.Export1$Value<0)])
unique(Final.Export1$Value)
Final.Export1$Value=as.numeric(Final.Export1$Value)
nosamplepos=Final.Export1[which(is.na(Final.Export1$SampleDepth)==TRUE & Final.Export1$SamplePosition=="UNKNOWN"),]
write.table(Final.Export1,file="DataImport_EPA_ELS_PHASE_I.csv",row.names=FALSE,sep=",")
save.image("C:/Users/Sam/Dropbox/CSI-LIMNO_DATA/DATA-lake/EPA national surveys/IN-LAKE DATA/EASTERN LAKE SURVEY all (FINISHED)/DataImport_EPA_ELS_PHASE_I/DataImport_EPA_ELS_PHASE_I.RData")
