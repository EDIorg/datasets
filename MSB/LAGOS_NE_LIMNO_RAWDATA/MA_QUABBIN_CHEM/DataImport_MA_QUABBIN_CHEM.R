#path to files
setwd("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MA data/MWSA- Reservoirs (Finished)/Quabbin/DataImport_MA_QUABBIN_CHEM")


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
#data collected from a single reservoir in MA--Quabbin Reservoir
#the exact sample depth is not known for all observations but a general sample depth is known; and exported to the comments field for those
#observations where sample depth=NA
#Sampletype= "GRAB"
###########################################################################################################################################################################################
################################### NO3  #############################################################################################################################
data=quabbin_chem
names(data)#look at column names
#filter out columns of interest
data=data[,c(1,2,11)]
names(data)
#look at data, check for nulls, filter out nulls
unique(data$NO3.)
length(data$NO3.[which(is.na(data$NO3.)==TRUE)])
length(data$NO3.[which(data$NO3.=="")])
1181-1133#48 values remain after filtering out null
data=data[which(is.na(data$NO3.)==FALSE),]

#done filtering

#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID =206
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = "QUABBIN RESERVOIR"
data.Export$SourceVariableName = "NO3-"
data.Export$SourceVariableDescription = "Nitrate"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID =18
data.Export$LagosVariableName="Nitrogen, nitrite (NO2) + nitrate (NO3)"
data.Export$Value=data$NO3.*1000  #export values and convert to preff. units
unique(data.Export$Value)#look at exported values
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode="NC" #no censored obs.
unique(data.Export$CensorCode)
#continue exporting other info
data.Export$Date = data$DATE #date already in correct format
data.Export$Units="ug/L"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(data$SITE=="206S")]="EPI"
data.Export$SamplePosition[which(data$SITE=="206M")]="META"
data.Export$SamplePosition[which(data$SITE=="206D")]="HYPO"
unique(data.Export$SamplePosition)
#assign sampledepth 
unique(data$SITE)
data.Export$SampleDepth[which(data$SITE=="206D")]=NA#see import log
data.Export$SampleDepth[which(data$SITE=="206M")]=NA#see import log
data.Export$SampleDepth[which(data$SITE=="206S")]= 0.50 #see import log
data.Export$SampleDepth[which(data$SITE=="206")]=0.50 #see import log
unique(data.Export$SampleDepth)#should only be NA or 0.5
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])#check to make sure correct number
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB"
unique(data.Export$SampleType)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="NOT_PRIMARY"
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
unique(data.Export$LabMethodInfo)#look at unique exported values
data.Export$DetectionLimit= NA #per meta
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
data.Export$Comments=as.character(data.Export$Comments)
unique(data$SITE)
data.Export$Comments[which(data$SITE=="206M")]="Sample was collected at a discrete depth between 9-14 meters"
data.Export$Comments[which(data$SITE=="206D")]="Sample was collected at a discrete depth 2-3 meters from the bottom"
unique(data.Export$Comments)
length(data.Export$Comments[which(is.na(data.Export$Comments)==FALSE)])#check to see if this corresponds w/ sample depth obs. that are NA
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])
no3.Final = data.Export
rm(data)
rm(data.Export)

################################### TKN #############################################################################################################################
data=quabbin_chem
names(data)#look at column names
#filter out columns of interest
data=data[,c(1,2,12)]
names(data)
#look at data, check for nulls, filter out nulls
unique(data$TKN)
length(data$TKN[which(is.na(data$TKN)==TRUE)])
length(data$TKN[which(data$TKN=="")])
1181-1133#48 values remain after filtering out null
data=data[which(is.na(data$TKN)==FALSE),]

#done filtering

#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID =206
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = "QUABBIN RESERVOIR"
data.Export$SourceVariableName = "TKN"
data.Export$SourceVariableDescription = "Total Kjeldahl nitrogen"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID =15
data.Export$LagosVariableName="Nitrogen, total Kjeldahl"
data.Export$Value=data$TKN*1000  #export values and convert to preff. units
unique(data.Export$Value)#look at exported values
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode="NC" #no censored obs.
unique(data.Export$CensorCode)
#continue exporting other info
data.Export$Date = data$DATE #date already in correct format
data.Export$Units="ug/L"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(data$SITE=="206S")]="EPI"
data.Export$SamplePosition[which(data$SITE=="206M")]="META"
data.Export$SamplePosition[which(data$SITE=="206D")]="HYPO"
unique(data.Export$SamplePosition)
#assign sampledepth 
unique(data$SITE)
data.Export$SampleDepth[which(data$SITE=="206D")]=NA#see import log
data.Export$SampleDepth[which(data$SITE=="206M")]=NA#see import log
data.Export$SampleDepth[which(data$SITE=="206S")]= 0.50 #see import log
data.Export$SampleDepth[which(data$SITE=="206")]=0.50 #see import log
unique(data.Export$SampleDepth)#should only be NA or 0.5
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])#check to make sure correct number
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB"
unique(data.Export$SampleType)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="NOT_PRIMARY"
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
unique(data.Export$LabMethodInfo)#look at unique exported values
data.Export$DetectionLimit= NA #per meta
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
data.Export$Comments=as.character(data.Export$Comments)
unique(data$SITE)
data.Export$Comments[which(data$SITE=="206M")]="Sample was collected at a discrete depth between 9-14 meters"
data.Export$Comments[which(data$SITE=="206D")]="Sample was collected at a discrete depth 2-3 meters from the bottom"
unique(data.Export$Comments)
length(data.Export$Comments[which(is.na(data.Export$Comments)==FALSE)])#check to see if this corresponds w/ sample depth obs. that are NA
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])
tkn.Final = data.Export
rm(data)
rm(data.Export)

################################### TPH   #############################################################################################################################
data=quabbin_chem
names(data)#look at column names
#filter out columns of interest
data=data[,c(1,2,13)]
names(data)
#look at data, check for nulls, filter out nulls
unique(data$TPH)
length(data$TPH[which(is.na(data$TPH)==TRUE)])
length(data$TPH[which(data$TPH=="")])
1181-1133#48 values remain after filtering out null
data=data[which(is.na(data$TPH)==FALSE),]

#done filtering

#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID =206
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = "QUABBIN RESERVOIR"
data.Export$SourceVariableName = "TPH"
data.Export$SourceVariableDescription = "Total phosphorus"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID =27
data.Export$LagosVariableName="Phosphorus, total"
data.Export$Value=data$TPH*1000  #export values and convert to preff. units
unique(data.Export$Value)#look at exported values
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode="NC" #no censored obs.
unique(data.Export$CensorCode)
#continue exporting other info
data.Export$Date = data$DATE #date already in correct format
data.Export$Units="ug/L"
#populate sampelposition
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(data$SITE=="206S")]="EPI"
data.Export$SamplePosition[which(data$SITE=="206M")]="META"
data.Export$SamplePosition[which(data$SITE=="206D")]="HYPO"
unique(data.Export$SamplePosition)
#assign sampledepth 
unique(data$SITE)
data.Export$SampleDepth[which(data$SITE=="206D")]=NA#see import log
data.Export$SampleDepth[which(data$SITE=="206M")]=NA#see import log
data.Export$SampleDepth[which(data$SITE=="206S")]= 0.50 #see import log
data.Export$SampleDepth[which(data$SITE=="206")]=0.50 #see import log
unique(data.Export$SampleDepth)#should only be NA or 0.5
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])#check to make sure correct number
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB"
unique(data.Export$SampleType)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="NOT_PRIMARY"
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
unique(data.Export$LabMethodInfo)#look at unique exported values
data.Export$DetectionLimit= NA #per meta
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
data.Export$Comments=as.character(data.Export$Comments)
unique(data$SITE)
data.Export$Comments[which(data$SITE=="206M")]="Sample was collected at a discrete depth between 9-14 meters"
data.Export$Comments[which(data$SITE=="206D")]="Sample was collected at a discrete depth 2-3 meters from the bottom"
unique(data.Export$Comments)
length(data.Export$Comments[which(is.na(data.Export$Comments)==FALSE)])#check to see if this corresponds w/ sample depth obs. that are NA
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])
tp.Final = data.Export
rm(data)
rm(data.Export)

################################### NH3  #############################################################################################################################
data=quabbin_chem
names(data)#look at column names
#filter out columns of interest
data=data[,c(1,2,15)]
names(data)
#look at data, check for nulls, filter out nulls
unique(data$NH3)
length(data$NH3[which(is.na(data$NH3)==TRUE)])
length(data$NH3[which(data$NH3=="")])
1181-1136#45 values remain after filtering out null
data=data[which(is.na(data$NH3)==FALSE),]

#done filtering

#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID =206
data.Export$LakeName=as.character(data.Export$LakeName)
data.Export$LakeName = "QUABBIN RESERVOIR"
data.Export$SourceVariableName = "NH3"
data.Export$SourceVariableDescription = "Ammonia"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags=NA #no source flags
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID =19
data.Export$LagosVariableName="Nitrogen, NH4"
data.Export$Value=data$NH3*1000  #export values and convert to preff. units
unique(data.Export$Value)#look at exported values
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode="NC" #no censored obs.
unique(data.Export$CensorCode)
#continue exporting other info
data.Export$Date = data$DATE #date already in correct format
data.Export$Units="ug/L"
#populate sampelposition
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(data$SITE=="206S")]="EPI"
data.Export$SamplePosition[which(data$SITE=="206M")]="META"
data.Export$SamplePosition[which(data$SITE=="206D")]="HYPO"
unique(data.Export$SamplePosition)
#assign sampledepth 
unique(data$SITE)
data.Export$SampleDepth[which(data$SITE=="206D")]=NA#see import log
data.Export$SampleDepth[which(data$SITE=="206M")]=NA#see import log
data.Export$SampleDepth[which(data$SITE=="206S")]= 0.50 #see import log
data.Export$SampleDepth[which(data$SITE=="206")]=0.50 #see import log
unique(data.Export$SampleDepth)#should only be NA or 0.5
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])#check to make sure correct number
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB"
unique(data.Export$SampleType)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="NOT_PRIMARY"
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= NA #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
unique(data.Export$LabMethodInfo)#look at unique exported values
data.Export$DetectionLimit= NA #per meta
data.Export$Subprogram=NA
unique(data.Export$Subprogram)
data.Export$Comments=as.character(data.Export$Comments)
unique(data$SITE)
data.Export$Comments[which(data$SITE=="206M")]="Sample was collected at a discrete depth between 9-14 meters"
data.Export$Comments[which(data$SITE=="206D")]="Sample was collected at a discrete depth 2-3 meters from the bottom"
unique(data.Export$Comments)
length(data.Export$Comments[which(is.na(data.Export$Comments)==FALSE)])#check to see if this corresponds w/ sample depth obs. that are NA
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])
nh4.Final = data.Export
rm(data)
rm(data.Export)


###################################### final export ########################################################################################
Final.Export = rbind(no3.Final,nh4.Final,tkn.Final,tp.Final)
############################################################################################################
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
0+189#adds up to total
##write table
Final.Export1=data1
typeof(Final.Export1$Value)
length(Final.Export1$Value[which(Final.Export1$Value<0)])
nosamplepos=Final.Export1[which(is.na(Final.Export1$SampleDepth)==TRUE & Final.Export1$SamplePosition=="UNKNOWN"),]
write.table(Final.Export1,file="DataImport_MA_QUABBIN_CHEM.csv",row.names=FALSE,sep=",")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/MA data/MWSA- Reservoirs (Finished)/Quabbin/DataImport_MA_QUABBIN_CHEM/DataImport_MA_QUABBIN_CHEM.RData")