#path to files
setwd("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MI data/MiCorps(finished)/MiCorps/DataImport_MI_CORPS_CHEM")
setwd("C:/Users/Sam/Dropbox/CSI-LIMNO_DATA/DATA-lake/MI data/MiCorps(finished)/MiCorps/DataImport_MI_CORPS_CHEM")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MI data/MiCorps(finished)/MiCorps/DataImport_MI_CORPS_CHEM/DataImport_MI_CORPS_CHEM.RData")


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
#citizen monitoring program in MI = CLMP
#missing represented by blank cell or null
#each variable has several associated columns- replicates and other info that may relate to lagos columns
#lakename and lakeid are both known
###########################################################################################################################################################################################
################################### chl ug/L_Rep1   #############################################################################################################################
data=MI_CORPS_Chem
names(data) #looking at diff. columns/variables
#need to filter out columns that are not elevant to chl-a.
data=data[,c(1:3,7,30:34,38)] #only interested in the first replicate of chl-a obs. also only pull out the columns relevant to chla
names(data)
#just looking at data
unique(data$chl.ug.L_Rep1) #these are the values we are interested in, deal with special characters
#determining the number of records that need to be removed because they are null 
length(data$chl.ug.L_Rep1[which(is.na(data$chl.ug.L_Rep1)==TRUE)]) #98878 values are NA 
length(data$chl.ug.L_Rep1[which(data$chl.ug.L_Rep1=="NULL")]) #2 values are null
length(data$chl.ug.L_Rep1[which(data$chl.ug.L_Rep1=="Interference")]) #  11  treating as null
length(data$chl.ug.L_Rep1[which(data$chl.ug.L_Rep1=="")]) #628
98878+2+11+628 #99519 obs. need to be removed
105765-99519 #6246 obs. should remain after filtering
data=data[which(is.na(data$chl.ug.L_Rep1)==FALSE),]
data=data[which(data$chl.ug.L_Rep1!="NULL"),]
data=data[which(data$chl.ug.L_Rep1!="Interference"),]
data=data[which(data$chl.ug.L_Rep1!=""),]
#left with the correct number of obs.
#determining the number of records which will be assigned censor codes (later)
length(data$chl.ug.L_Rep1[which(data$chl.ug.L_Rep1=="<1.0")]) #104 obs
length(data$chl.ug.L_Rep1[which(data$chl.ug.L_Rep1=="< 1.0")]) #510 obs
510+104
#looking at info in other columns
unique(data$Unusual_Conditions_Chl) #maybe export to comments field
unique(data$Sample_Depth_feet_Chl) # be sure to check for missing sample depths
length(data$Sample_Depth_feet_Chl[which(is.na(data$Sample_Depth_feet_Chl)==TRUE)]) #no null sample depths= good
length(data$Sample_Depth_feet_Chl[which(data$Sample_Depth_feet_Chl=="")]) 
unique(data$Weather_Conditions_Chl) #not interested in these
unique(data$Comments_Chl) #probably not going to export to comments field
unique(data$Site_ID_description)
#no other filtering that needs to be done
#proceed to populating LAGOS template

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$Site_ID
data.Export$LakeName = data$Lake_Name
data.Export$SourceVariableName = "chl ug/L_Rep1"
data.Export$SourceVariableDescription = "Chlorophyll a"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no info on source flags
#continue populating other lagos variables
data.Export$LagosVariableID = 9
data.Export$LagosVariableName="Chlorophyll a"
#populate censor code and remove special characters from chla obs, 614 obs will be "LT"
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$chl.ug.L_Rep1=="< 1.0")]="LT"
data.Export$CensorCode[which(data$chl.ug.L_Rep1=="<1.0")]="LT"
data.Export$CensorCode[which(is.na(data$chl.ug.L_Rep1)==TRUE)]="NC"
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure 614, and there are
#now overwrite special characters
data$chl.ug.L_Rep1[which(data$chl.ug.L_Rep1=="< 1.0")]=1
data$chl.ug.L_Rep1[which(data$chl.ug.L_Rep1=="<1.0")]=1
unique(data$chl.ug.L_Rep1)#check to make sure special charac. gone
#continue with exporting other variables
names(data)
typeof(data$chl.ug.L_Rep1)
data$chl.ug.L_Rep1=as.character(data$chl.ug.L_Rep1)
unique(data$chl.ug.L_Rep1)
data.Export$Value = data[,9] #export chla values, no conversion necessary, already in preff units of ug/l
unique(data.Export$Value)
data.Export$Value=as.numeric(data.Export$Value)
unique(data.Export$Value)
data.Export$Date = data$Sample_Date #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED"
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #all obs. populated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="SPECIFIED"
#check to make sure adds up to total
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")]) #all obs. populated
#assign sampledepth 
length(data$Sample_Depth_feet_Chl[which(is.na(data$Sample_Depth_feet_Chl)==FALSE)]) #check for missing depth values=none
names(data)
data.Export$SampleDepth= data[,5]*0.3048
unique(data.Export$SampleDepth) #checking for problematic special characters
data.Export$SampleDepth=round(data.Export$SampleDepth,digits=4)
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==FALSE)]) #check to make sure no obs. null for depth
#continue populating other lagos fields
unique(data$Site_ID_description) #if "deep" or "hole" found set basin type to primary, otherwise unknown
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType[grep("deep",data$Site_ID_description,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("hole",data$Site_ID_description,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[which(is.na(data.Export$BasinType)==TRUE)]="UNKNOWN"
#check to make sure all obs. assigned a basin type
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")])
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")])
3644+2602 #adds up to total
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable to chla
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #no info in metadata
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments= data$Unusual_Conditions_Chl
chla.Final = data.Export
rm(data.Export)
rm(data)



################################### ug P/L_Rep1   #############################################################################################################################
data=MI_CORPS_Chem
names(data) #looking at diff. columns/variables
#need to filter out columns that are not elevant to chl-a.
data=data[,c(1:3,7,21:25,29)] #only interested in the first replicate of chl-a obs. also only pull out the columns relevant to chla
names(data)
#just looking at data
unique(data$ug.P.L_Rep1) #these are the values we are interested in, deal with special characters
#determining the number of records that need to be removed because they are null 
length(data$ug.P.L_Rep1[which(is.na(data$ug.P.L_Rep1)==TRUE)]) #101126 values are NA 
length(data$ug.P.L_Rep1[which(data$ug.P.L_Rep1=="")]) #75
101126+75 #101201 obs. need to be removed
105765-101201 #4564 obs. should remain after filtering
data=data[which(is.na(data$ug.P.L_Rep1)==FALSE),]
data=data[which(data$ug.P.L_Rep1!=""),]
#left with the correct number of obs.
#determining the number of records which will be assigned censor codes (later)
length(data$ug.P.L_Rep1[which(data$ug.P.L_Rep1=="<= 3")]) #173 obs
length(data$ug.P.L_Rep1[which(data$ug.P.L_Rep1=="< 5")]) #142
173+142 #315 will have CensorCodes
#looking at info in other columns
unique(data$Weather_Conditions_P) #not interested in these
unique(data$Unusual_Conditions_P) #maybe export to comments
unique(data$Comments_P) #maybe export to comments
#no other filtering that needs to be done
#proceed to populating LAGOS template

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$Site_ID
data.Export$LakeName = data$Lake_Name
data.Export$SourceVariableName = "ug P/L_Rep1"
data.Export$SourceVariableDescription = "Total phosphorus"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no info on source flags
#continue populating other lagos variables
data.Export$LagosVariableID = 27
data.Export$LagosVariableName="Phosphorus, total"
#populate censor code and remove special characters from chla obs, 315 obs will be "LT"
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$ug.P.L_Rep1=="<= 3")]="LT"
data.Export$CensorCode[which(data$ug.P.L_Rep1=="< 5")]="LT"
data.Export$CensorCode[which(is.na(data$ug.P.L_Rep1)==TRUE)]="NC"
length(data.Export$CensorCode[which(data.Export$CensorCode=="LT")])#check to make sure 315, and there are
#now overwrite special characters
data$ug.P.L_Rep1=as.character(data$ug.P.L_Rep1)
data$ug.P.L_Rep1[which(data$ug.P.L_Rep1=="<= 3")]=3
data$ug.P.L_Rep1[which(data$ug.P.L_Rep1=="< 5")]=5
unique(data$ug.P.L_Rep1)#check to make sure special charac. gone
data$ug.P.L_Rep1=as.integer(data$ug.P.L_Rep1)
#continue with exporting other variables
names(data)
typeof(data$ug.P.L_Rep1)
data$ug.P.L_Rep1=as.character(data$ug.P.L_Rep1)
data.Export$Value = data[,9] #export tp values, no conversion necessary, already in preff units of ug/l
unique(data.Export$Value)
data.Export$Value=as.numeric(data.Export$Value)
unique(data.Export$Value)
data.Export$Date = data$Sample_Date #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB"
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")]) #all obs. populated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="EPI"
#check to make sure adds up to total
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="EPI")]) #all obs. populated
#assign sampledepth 
data.Export$SampleDepth=0 #all surface grab samples
unique(data.Export$SampleDepth) #checking for problematic special characters
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==FALSE)]) #check to make sure no obs. null for depth
#continue populating other lagos fields
unique(data$Site_ID_description) #if "deep" or "hole" found set basin type to primary, otherwise unknown
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType[grep("deep",data$Site_ID_description,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("hole",data$Site_ID_description,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[which(is.na(data.Export$BasinType)==TRUE)]="UNKNOWN"
#check to make sure all obs. assigned a basin type
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")])
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")])
2376+2188 #adds up to total
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable to tp
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #no info in metadata
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments= data$Unusual_Conditions_P
tp.Final = data.Export
rm(data.Export)
rm(data)



################################### Secchi_Depth_feet   #############################################################################################################################
data=MI_CORPS_Chem
names(data) 
#need to filter out columns that are not elevant to chl-a.
data=data[,c(1:3,7,15:18)] #only interested in the first replicate of chl-a obs. also only pull out the columns relevant to chla
names(data)
unique(data$Measurement_Secchi)
unique(data$Secchi_Depth_feet)
#check for NA observations and filter out
length(data$Secchi_Depth_feet[which(is.na(data$Secchi_Depth_feet)==TRUE)])
105765-5147#100618 REMAIN after filtering out null
data=data[which(is.na(data$Secchi_Depth_feet)==FALSE),]
unique(data$Measurement_Secchi)
length(data$Measurement_Secchi[which(data$Measurement_Secchi=="N")]) #assing these a censor code of "gt"
length(data$Measurement_Secchi[which(data$Measurement_Secchi=="Y")])
length(data$Measurement_Secchi[which(data$Measurement_Secchi=="")])
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$Site_ID
data.Export$LakeName = data$Lake_Name
data.Export$SourceVariableName = "Secchi_Depth_feet"
data.Export$SourceVariableDescription = "Secchi depth, unknown if viewscope was used"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no info on source flags
#continue populating other lagos variables
data.Export$LagosVariableID = 30
data.Export$LagosVariableName="Secchi"
data.Export$CensorCode=as.character(data.Export$CensorCode)
unique(data$Measurement_Secchi)
data.Export$CensorCode[which(data$Measurement_Secchi=="N")]="GT"
unique(data.Export$CensorCode)
data.Export$CensorCode[which(is.na(data.Export$CensorCode)==TRUE)]="NC" #may change once hear back from source data contact
unique(data.Export$CensorCode)
#continue with exporting other variables
names(data)
data.Export$Value = data[,5]*0.3048 #export and convert from feet to meters
data.Export$Value=round(data.Export$Value,digits=4)
unique(data.Export$Value)
data.Export$Date = data$Sample_Date #date already in correct format
data.Export$Units="m"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED"
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")]) #all obs. populated
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="SPECIFIED"
#check to make sure adds up to total
length(data.Export$SamplePosition[which(data.Export$SamplePosition=="SPECIFIED")]) #all obs. populated
#assign sampledepth 
data.Export$SampleDepth=NA #because secchi
unique(data.Export$SampleDepth) #checking for problematic special characters
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)]) #check to make sure all obs. null for depth
#continue populating other lagos fields
unique(data$Unusual_Conditions_Secchi) #if "deep" or "hole" found set basin type to primary, otherwise unknown
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType[grep("deep",data$Site_ID_description,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[grep("hole",data$Site_ID_description,ignore.case=TRUE)]="PRIMARY"
data.Export$BasinType[which(is.na(data.Export$BasinType)==TRUE)]="UNKNOWN"
#check to make sure all obs. assigned a basin type
length(data.Export$BasinType[which(data.Export$BasinType=="PRIMARY")])
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")])
34428+66190 #adds up to total
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = "SECCHI_VIEW_UNKNOWN"
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #no info in metadata
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments=data$Unusual_Conditions_Secchi
secchi.Final=data.Export
rm(data.Export)
rm(data)

###Final.Export##########
Final.Export=rbind(chla.Final,secchi.Final,tp.Final)

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
1854+109574#adds up to total
##write table
Final.Export1=data1
typeof(Final.Export1$Value)
length(Final.Export1$Value[which(Final.Export1$Value<0)])
write.table(Final.Export1,file="DataImport_MI_CORPS_CHEM.csv",row.names=FALSE,sep=",")
nosamplepos=Final.Export1[which(is.na(Final.Export1$SampleDepth)==TRUE & Final.Export1$SamplePosition=="UNKNOWN"),]
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MI data/MiCorps(finished)/MiCorps/DataImport_MI_CORPS_CHEM/DataImport_MI_CORPS_CHEM.RData")    
       
         

       