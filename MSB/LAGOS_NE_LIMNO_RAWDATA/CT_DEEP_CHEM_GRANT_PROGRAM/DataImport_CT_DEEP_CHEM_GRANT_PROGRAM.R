library(reshape)
library(plyr)

#this package allows easy manipulation from horizontal
#to vertical structure
#melt.data.frame will allow manipulation to vertical format
#See this paper for further examples http://www.jstatsoft.org/v21/i12/paper

setwd("~/Dropbox/CSI-LIMNO_DATA/DATA-lake/CT data/CT_SKO")

data = read.csv("CT_lakes_chemistry_dataset.csv", header = TRUE)


levels(data$Sampling_Location)
#checks to see if there are sampling locations other than the primary (deep hole)
new.levels = c(rep("NOT_PRIMARY", 3), rep("PRIMARY", 9), rep("NOT_PRIMARY", 4), "PRIMARY", rep("UNKNOWN", 3))
levels(data$Sampling_Location) = new.levels
#set Sampling_Location equal to the newly defined levels

data$Sampling_Date = as.Date(data$Sampling_Date, format = "%m/%d/%Y")
#format date variable properly

data$SamplePosition = data$Sample_depth
#create a column called SamplePosition and make it equal to depth

new.levels = c(rep("SPECIFIED", 2), rep("UNKNOWN", 2), 
               rep("SPECIFIED", 152), rep("HYPO", 2), 
               rep("UNKNOWN", 2), "HYPO", "META", "UNKNOWN", 
               "HYPO", "HYPO", rep("EPI", 3), "UNKNOWN", 
               "UNKNOWN", "HYPO")
levels(data$SamplePosition) = new.levels
#create new levels according to where in the water column
#the sample was taken

data$SampleType = data$Sample_depth
new.levels = c(rep("INTEGRATED", 2), rep("GRAB", 2), 
               rep("INTEGRATED", 12), rep("GRAB", 18), "INTEGRATED",
               rep("GRAB", 8), "INTEGRATED", rep("GRAB", 6), "INTEGRATED",
               rep("GRAB", 73), "INTEGRATED", rep("GRAB", 15), "INTEGRATED", 
               rep("GRAB", 17), "INTEGRATED", rep("GRAB", 8), "INTEGRATED",
               "GRAB", "UNKNOWN", "GRAB")
levels(data$SampleType) = new.levels
#Creates new levels according to what type of sample it is

new.levels = levels(data$Sample_depth)
new.levels = gsub("(.+-)(.+)", "\\2", new.levels)
new.levels = gsub("(>.+)", "NA", new.levels)
new.levels = gsub("(\\D{2,})", "NA", new.levels)
levels(data$Sample_depth) =  new.levels
#cleans up depth information

data = data[ , c(1:10, 12, 22, 25:26)] #get rid of variables that aren't applicable
data2 = melt.data.frame(data, 
                        id.vars=c('Lake_Name', 'Sampling_Date', 
                                  'Sampling_Location', 'Sample_depth', 
                                  'SamplePosition', 'SampleType', 'Report_Title'), 
                        measure.vars = names(data)[6:11], 
                        na.rm = TRUE)
#turn data frame into vertical structure

standard = data.frame(LakeID=character(length(data2$Lake_Name)),  
                      LakeName=data2$Lake_Name,  
                      SourceVariableName=data2$variable,  
                      SourceVariableDescription=character(length(data2$Lake_Name)), 
                      SourceFlags=character(length(data2$Lake_Name)), 
                      LagosVariableID=numeric(length(data2$Lake_Name)),
                      LagosVariableName=character(length(data2$Lake_Name)), 
                      Value=numeric(length(data2$Lake_Name)), Units=character(length(data2$Lake_Name)),  
                      CensorCode=character(length(data2$Lake_Name)), 
                      DetectionLimit=numeric(length(data2$Lake_Name)),
                      Date=data2$Sampling_Date,
                      LabMethodName=character(length(data2$Lake_Name)), 
                      LabMethodInfo=character(length(data2$Lake_Name)), 
                      SampleType=data2$SampleType,
                      SamplePosition=data2$SamplePosition, 
                      SampleDepth=data2$Sample_depth, 
                      MethodInfo=character(length(data2$Lake_Name)),
                      BasinType=data2$Sampling_Location,
                      SubProgram=data2$ReportTitle,
                      Comments=character(length(data2$Lake_Name)))

#add data to clean dataframe with all appropriate headers
standard$LakeID = 
standard$LakeName = data2$Lake_Name
standard$SourceVariableName = data2$variable
standard$SourceVariableDescription = standard$SourceVariableName
standard$LagosVariableName = data2$variable
#convert source variable names to LAGOS names
new.levels = levels(standard$LagosVariableName)
new.levels = c("Nitrogen, total", "Phosphorus, total", "Chlorophyll a", "Secchi", "Nitrogen, NH4", "Nitrogen, total organic")
levels(standard$LagosVariableName) = new.levels

standard$Value = as.numeric(data2$value) #this needs to be changed
#currently, any symbols in the data (less than, etc) will turn into "NA" here
#consider a gsub function, where values are left blank in the "CensorCode" category, 
#and any symbol is transferred
standard$Units = standard$LagosVariableName
#connect LAGOS units to each LAGOS variable in the dataset
new.levels = levels(standard$Units)
new.levels = c("ug/L", "ug/L", "ug/L", "m", "ug/L", "ug/L")
levels(standard$Units) = new.levels

standard$CensorCode = data2$value
#put gsub function here to pull out any symbols

standard$DetectionLimit = 
standard$Date = standard$Sampling_Date
standard$LabMethodName = 
standard$LabMethodInfo = 
standard$SampleType = data2$SampleType
standard$SamplePosition = data2$SamplePosition
standard$SampleDepth = data2$Sample_depth
standard$MethodInfo = 
standard$BasinType = data2$Sampling_Location

  

standard$Value[standard$LagosVariableName == "Nitrogen, total"] = standard$Value * 1000




