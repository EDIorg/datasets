#SET WD
setwd("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/CT data/CT_POST_CHEM/DataImport_CT_POST_CHL")

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
#data belongs to david post at yale, mostly for the 6 long term study lakes
#13 lakes in total, extra lakes sampled in 2005,2006
#see import log for other info
###############################################################################################################################################
################################### [Chl] - actual    #############################################################################################################################
data=ct_post_chl
names(data)
unique(data$X.Chl....actual) #looking at data from problematic observations
#filter out those that are na and "dropped sample"
length(data$X.Chl....actual[which(data$X.Chl....actual=="dropped sample")])
length(data$X.Chl....actual[which(data$X.Chl....actual=="na")])
length(data$X.Chl....actual[which(data$X.Chl....actual=="")])
2+2+1
4846-5 #4841 should remain after filtering out the above
data=data[which(data$X.Chl....actual!="dropped sample"),]
data=data[which(data$X.Chl....actual!="na"),]
data=data[which(data$X.Chl....actual!=""),]
#continue looking at data
unique(data$Sample)#where F or f is attached to these observations export comment (see import log) to comments field
length(data$Sample[which(data$Sample=="DIWS F")])
length(data$Sample[which(data$Sample=="DIWS")])
unique(data$Depth)
length(data$Depth[which(data$Depth=="na")])
length(data$Depth[which(data$Depth=="DIWS")])
temp.df=data[which(data$Depth=="DIWS"),]
rm(temp.df)
#filter out those that are na and DIWS for depth
4841-24#number that should remain
data=data[which(data$Depth!="na"),]
data=data[which(data$Depth!="DIWS"),]
data$Depth[which(data$Depth=="0.5w/ VDM")]=0.5 #overwrite special characters
unique(data$Depth)
unique(data$Lake)#fix the lower case b in bride
data$Lake[which(data$Lake=="bride")]="Bride"
unique(data$Lake)
unique(data$Date)
#no other filtering to be done

###start populating the lagos template
data.Export= LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID=data$Lake
unique(data.Export$LakeID)
length(data.Export$LakeID[which(data.Export$LakeID=="")])
#export lake name
data.Export$LakeName = data$Lake
#continue with other variables
data.Export$SourceVariableName = "[Chl] - actual"
data.Export$SourceVariableDescription = "Chlorophyll a"
#populate SourceFlags
data.Export$SourceFlags=as.character(data.Export$SourceFlags)
data.Export$SourceFlags= NA #no remark codes
length(data.Export$SourceFlags[which(is.na(data.Export$SourceFlags)==TRUE)])#check to make sure correct number NA

#continue populating other lagos variables
data.Export$LagosVariableID = 9
data.Export$LagosVariableName="Chlorophyll a"
#export values
typeof(data$X.Chl....actual)
unique(data$X.Chl....actual)
data$X.Chl....actual=as.character(data$X.Chl....actual)
unique(data$X.Chl....actual)
data.Export$Value=as.character(data.Export$Value)
data.Export$Value = data$X.Chl....actual
unique(data.Export$Value)
data.Export$Value=as.numeric(data.Export$Value)
data.Export$CensorCode = "NC" #no info on CensorCode
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L"
#prepare to populate sampletype
data.Export$SampleType=as.character(data.Export$SampleType)
data.Export$SampleType="GRAB" #per metadata
length(data.Export$SampleType[which(data.Export$SampleType=="GRAB")])
#SAMPLE position
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition="SPECIFIED"
unique(data.Export$SamplePosition)
#assign sampledepth 
data.Export$SampleDepth=data$Depth
length(data.Export$SampleDepth[which(is.na(data.Export$SampleDepth)==TRUE)])#check to make sure all NA
unique(data.Export$SampleDepth)
#continue populating other lagos fields
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType="UNKNOWN"
length(data.Export$BasinType[which(data.Export$BasinType=="UNKNOWN")]) #check to make sure CORRECT NUMBER populated
#continue with other fields
data.Export$MethodInfo = as.character(data.Export$MethodInfo)
data.Export$MethodInfo = NA #not applicable
data.Export$LabMethodName= as.character(data.Export$LabMethodName)
data.Export$LabMethodName= "EPA_445.0" #per emi's metadata
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)
data.Export$LabMethodInfo=NA
data.Export$DetectionLimit= NA #not specified in meta
data.Export$Comments=as.character(data.Export$Comments)
unique(data$Sample)
data.Export$Comments[(grep("f",data$Sample,ignore.case=TRUE))]="sample was filtered through 30µm mesh for an edible or small algae chlorophyll a estimate"
unique(data.Export$Comments)
temp.df=data.Export[which(data.Export$Comments=="sample was filtered through 30µm mesh for an edible or small algae chlorophyll a estimate"),]
rm(temp.df)
chla.Final = data.Export
rm(data.Export)
rm(data)

###################################### final export ########################################################################################
Final.Export = chla.Final
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
298+4519#adds up to total
##write table
Final.Export1=data1
typeof(Final.Export1$Value)
length(Final.Export1$Value[which(Final.Export1$Value<0)])
negative.df=Final.Export1[which(Final.Export1$Value<0)]
unique(negative.df$SourceVariableName)
unique(negative.df$Value)
4817-34#number remaining after filtering out negatives
Final.Export1=Final.Export1[which(Final.Export1$Value>=0),]
length(Final.Export1$Dup[which(Final.Export1$Dup==1)])
write.table(Final.Export1,file="DataImport_CT_POST_CHL.csv",row.names=FALSE,sep=",")
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/CT data/CT_POST_CHEM/DataImport_CT_POST_CHL/DataImport_CT_POST_CHL.RData")