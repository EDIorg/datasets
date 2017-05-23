setwd('C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/PA data/PA_DEP_LAKE_DATA/DataImport_PA_DEP_CHEM')
setwd('C:/Users/Sam/Dropbox/CSI-LIMNO_DATA/DATA-lake/PA data/PA_DEP_LAKE_DATA/DataImport_PA_DEP_CHEM')

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

######################################GENERAL NOTES#######################################################################################
#The data used in this data import effort comes from "Comprehensive Chemistry" found in 
#"PA_DEP_LAKE_DATA.mdb." Of all the variables in "Comprehensive Chemistry" only 9 are of interest
#for exportation to LAGOS. "Comprehensive Chemistry" was exported from the access database,
#and saved as a text file "PA_DEP_CHEM.csv" in PA data > PA_DEP_LAKE_DATA >DatabaseData
#no replicates to worry about filtering out

###################################Organic carbon, T (mg/L)##########################################################################################
data=PA_DEP_CHEM
names(data) #71 columns, pull out the columns interested in working with
data = data[,c(1:3,5:6,19,23)] #pulling out columns of interest
head(data)
names(data)
length(data$Organic.carbon..T..mg.L.!=NA)
length(data$Organic.carbon..T..mg.L.[which(is.na(data$Organic.carbon..T..mg.L.)==FALSE)])
unique(data$Organic.carbon..T..mg.L.)
#there are no observations for organic carbon in this data set, even though
#it was listed as a priority variable. Skip and move to next
rm(data)

##################################TOC (mg/L)##########################################################################################################
data=PA_DEP_CHEM
names(data) #looking at data, filter columns 
data = data[,c(1:3,5:6,19,48)] #pulling out columns of interest
head(data) #looking at data
names(data)
length(data$TOC..mg.L.[which(is.na(data$TOC..mg.L.==TRUE))]) #4018 of the observations are "NA"
typeof(data$TOC..mg.L.)
names(data)
data = data[which(is.na(data[,7])==FALSE),] #only three observations!!
unique(data$Sample.No) #sample number represents the batch processed by the lab that processed this data
unique(data$Station)
unique(data$comments)
###no other data filtering, begin exporting to LAGOS
data.Export = LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$Lake.ID
data.Export$LakeName=data$Lake.Name
data.Export$SourceVariableName = "TOC (mg/L)"
data.Export$SourceVariableDescription = as.character(data.Export$SourceVariableDescription)
data.Export$SourceVariableDescription = "Total organic carbon"
data.Export$LagosVariableID= 7
data.Export$LagosVariableName="Carbon, total organic"
data.Export$Value = data[,7] #export toc values
data.Export$CensorCode = "NC"
data.Export$SourceFlags= NA 
data.Export$SampleType = as.character(data.Export$SampleType)
data.Export$SampleType= "GRAB"
data.Export$Date = data$Date #date already in correct format
data.Export$Units="mg/L" #preferred units
unique(data$Sample.No) #Sample.No contains info on the depth/position in some cases
#in this case Sample.No does not contian into on depth/position
unique(data$Station) #contains info on the depth/position sample was taken at
data.Export$SampleDepth=as.character(data.Export$SampleDepth)
data.Export$SampleDepth= NA #no info on numeric depth
data$Station=as.character(data$Station)
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(data$Station=="STA 2 near Inlet, sfc SAC 035")] = "EPI" #specifying position based on unique data$Station
unique(data.Export$SampleDepth)
data.Export$SamplePosition[which(data$Station=="Sta #3 Midlake ")]= "UNKNOWN" #specifying position based on unique data$Station
data.Export$SamplePosition[which(data$Station=="")]= "UNKNOWN"                                     
data.Export$BasinType = "UNKNOWN" #no info on whether deep spot or not
data.Export$MethodInfo = NA
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments = data$comments #exporting comments 
data.Export$Subprogram=NA
data.Export$LabMethodName=as.character(data.Export$LabMethodName)
data.Export$LabMethodName="SM_144A"
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)                     
data.Export$LabMethodInfo= "Standard Methods (1971) Method 144A"             
data.Export$DetectionLimit=NA 
TOC.Final = data.Export
rm(data)
rm(data.Export)
length(TOC.Final[which(TOC.Final$SamplePosition=="UNKNOWN" & is.na(TOC.Final$SampleDepth)==TRUE)])
#####################################################"Chlo.a"#######################################################################################
data=PA_DEP_CHEM
names(data) #looking at data, filter columns 
data = data[,c(1:3,5:6,14,19)] #pulling out columns of interest
head(data) #looking at data
length(data$Chlo.a[which(is.na(data$Chlo.a==TRUE))]) #1900 of the observations are "NA"
data = data[which(is.na(data[,6])==FALSE),] 
4021-1900 #the above command should result in 2121 values, and it does
unique(data$Sample.No) #SampleNo contains info on depth and sample position, looking at info on unique values
unique(data$Station) #over 700 unique values describing the Station-which contains info on the sampling depth and sample position
# The info in Sample.No and Station will have to be picked out to determine depth and sample position
#### now filter out observations that have "dup" or "dupl" in the Station field as these are duplicate/replicate values
data$Station=as.character(data$Station)
data$Station[grep("dup",data$Station,ignore.case=TRUE)]="-9999" #works I checked the length of values of "-9999"
data$Station[grep("dupl",data$Station,ignore.case=TRUE)]="-9999"
data$Station[grep("average",data$Station,ignore.case=TRUE)]="-9999"
data$Station[grep("averages",data$Station,ignore.case=TRUE)]="-9999"
data$Station[grep("avg",data$Station,ignore.case=TRUE)]="-9999"
data=data[which(data$Station!="-9999"),] #remove those "dup" or duplicate observations

###no other data filtering, begin exporting to LAGOS
data.Export = LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$Lake.ID
data.Export$LakeName=data$Lake.Name
data.Export$SourceVariableName = "Chlo a"
data.Export$SourceVariableDescription = as.character(data.Export$SourceVariableDescription)
data.Export$SourceVariableDescription = "Chlorophyll a"
data.Export$LagosVariableID= 9
data.Export$LagosVariableName="Chlorophyll a"
typeof(data$Chlo.a)
unique(data$Chlo.a)
data.Export$Value = (data[,6])*1000 #export chla values, multiply by 1000 to go from mg/l to preferred units of ug/l
unique(data.Export$Value)
data.Export$CensorCode = "NC"
data.Export$SourceFlags= NA  #no source flags involved with these data
data.Export$SampleType = as.character(data.Export$SampleType)
data.Export$SampleType[grep("integrated",data$Station,ignore.case=TRUE)]="INTEGRATED"
data.Export$SampleType[which(is.na(data.Export$SampleType==TRUE))]="GRAB"
unique(data.Export$SampleType) #just looking to see if the right values were exported.
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")])#ONLY 4 ARE INTEGRATED
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L" #preferred units
unique(data$Sample.No) #Sample.No contains info on the depth/position in some cases
unique(data$Station) #contains info on the depth/position sample was taken at
data$Station=as.character(data$Station) #set as character so it can be manipulated
data$Sample.No=as.character(data$Sample.No) #set as character so it can be manipulated
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[which(data$Sample.No=="Bottom/ CHL A")] = "HYPO" #specifying position based on unique data$Sample.No
data.Export$SamplePosition[which(data$Sample.No=="dam-sfc")] = "EPI" 
data.Export$SamplePosition[which(data$Sample.No=="Surface/ CHL A")] = "EPI" 
data.Export$SamplePosition[which(data$Sample.No=="Surface")] = "EPI" 
data.Export$SamplePosition[which(data$Sample.No=="dam sfc")] = "EPI" 
data.Export$SamplePosition[which(data$Sample.No=="uplake sfc")] = "EPI" 
######do same thing for data$Station
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[grep("sfc",data$Station,ignore.case=TRUE)]="EPI" #for all "Station" observations that have "sfc"=surface, set SamplePosition to EPI
data.Export$SamplePosition[grep("surf",data$Station,ignore.case=TRUE)]="EPI"#for all "Station" observations that have "surf"=surface, set sampleposition to EPI
data.Export$SamplePosition[grep("surface",data$Station,ignore.case=TRUE)]="EPI" #for all "Station" observations that have "surface"=surface, set sampleposition to EPI
data.Export$SamplePosition[grep("bott",data$Station,ignore.case=TRUE)]="HYPO" #for all "Station" observations that have "bott"= bottom, set sampleposition to HYPO
data.Export$SamplePosition[grep("bot",data$Station,ignore.case=TRUE)]="HYPO" #for all "Station" observations that have "bot"= bottom, set sampleposition to HYPO
data.Export$SamplePosition[grep("bottom",data$Station,ignore.case=TRUE)]="HYPO"
data.Export$SamplePosition[grep("bottm",data$Station,ignore.case=TRUE)]="HYPO"
data.Export$SamplePosition[grep("(sfc)",data$Station,ignore.case=TRUE)]="EPI"
data.Export$SamplePosition[grep("-sfc",data$Station,ignore.case=TRUE)]="EPI"
data.Export$SamplePosition[grep("-bott",data$Station,ignore.case=TRUE)]="HYPO"
data.Export$SamplePosition[grep("(bott)",data$Station,ignore.case=TRUE)]="HYPO" 
unique(data.Export$SamplePosition)

####now populate sample depth based on the info in data$Sample.No and data$Station
data.Export$SampleDepth[grep(".1M",data$Station,ignore.case=TRUE)]=".1"
data.Export$SampleDepth[grep(".2M",data$Station,ignore.case=TRUE)]=".2"
data.Export$SampleDepth[grep(".3M",data$Station,ignore.case=TRUE)]=".3"
data.Export$SampleDepth[grep(".4M",data$Station,ignore.case=TRUE)]=".4"
data.Export$SampleDepth[grep(".5M",data$Station,ignore.case=TRUE)]=".5"
data.Export$SampleDepth[grep(".6M",data$Station,ignore.case=TRUE)]=".6"
data.Export$SampleDepth[grep(".7M",data$Station,ignore.case=TRUE)]=".7"
data.Export$SampleDepth[grep(".8M",data$Station,ignore.case=TRUE)]=".8"
data.Export$SampleDepth[grep(".9M",data$Station,ignore.case=TRUE)]=".9"
data.Export$SampleDepth[grep("1M",data$Station,ignore.case=TRUE)]="1"
data.Export$SampleDepth[grep("1.5M",data$Station,ignore.case=TRUE)]="1.5"
data.Export$SampleDepth[grep("2M",data$Station,ignore.case=TRUE)]="2"
data.Export$SampleDepth[grep("2.3M",data$Station,ignore.case=TRUE)]="2.3"
data.Export$SampleDepth[grep("2.5M",data$Station,ignore.case=TRUE)]="2.5"
data.Export$SampleDepth[grep("3M",data$Station,ignore.case=TRUE)]="3"
data.Export$SampleDepth[grep("3.5M",data$Station,ignore.case=TRUE)]="3.5"
data.Export$SampleDepth[grep("4M",data$Station,ignore.case=TRUE)]="4"
data.Export$SampleDepth[grep("4.5M",data$Station,ignore.case=TRUE)]="4.5"
data.Export$SampleDepth[grep("5M",data$Station,ignore.case=TRUE)]="5"
data.Export$SampleDepth[grep("5.5M",data$Station,ignore.case=TRUE)]="5.5"
data.Export$SampleDepth[grep("6M",data$Station,ignore.case=TRUE)]="6"
data.Export$SampleDepth[grep("6.5M",data$Station,ignore.case=TRUE)]="6.5"
data.Export$SampleDepth[grep("6.7M",data$Station,ignore.case=TRUE)]="6.7"
data.Export$SampleDepth[grep("7M",data$Station,ignore.case=TRUE)]="7"
data.Export$SampleDepth[grep("7.5M",data$Station,ignore.case=TRUE)]="7.5"
data.Export$SampleDepth[grep("8M",data$Station,ignore.case=TRUE)]="8"
data.Export$SampleDepth[grep("8.5M",data$Station,ignore.case=TRUE)]="8.5"
data.Export$SampleDepth[grep("9M",data$Station,ignore.case=TRUE)]="9"
data.Export$SampleDepth[grep("9.5M",data$Station,ignore.case=TRUE)]="9.5"
data.Export$SampleDepth[grep("10M",data$Station,ignore.case=TRUE)]="10"
data.Export$SampleDepth[grep("10.5M",data$Station,ignore.case=TRUE)]="10.5"
data.Export$SampleDepth[grep("11M",data$Station,ignore.case=TRUE)]="11"
data.Export$SampleDepth[grep("11.5M",data$Station,ignore.case=TRUE)]="11.5"
data.Export$SampleDepth[grep("12M",data$Station,ignore.case=TRUE)]="12"
data.Export$SampleDepth[grep("12.5M",data$Station,ignore.case=TRUE)]="12.5"
data.Export$SampleDepth[grep("13M",data$Station,ignore.case=TRUE)]="13"
data.Export$SampleDepth[grep("13.5M",data$Station,ignore.case=TRUE)]="13.5"
data.Export$SampleDepth[grep("14M",data$Station,ignore.case=TRUE)]="14"
data.Export$SampleDepth[grep("14.5M",data$Station,ignore.case=TRUE)]="14.5"
data.Export$SampleDepth[grep("15M",data$Station,ignore.case=TRUE)]="15"
data.Export$SampleDepth[grep("15.5M",data$Station,ignore.case=TRUE)]="15.5"
data.Export$SampleDepth[grep("16M",data$Station,ignore.case=TRUE)]="16"
data.Export$SampleDepth[grep("16.5M",data$Station,ignore.case=TRUE)]="16.5"
data.Export$SampleDepth[grep("17M",data$Station,ignore.case=TRUE)]="17"
data.Export$SampleDepth[grep("17.5M",data$Station,ignore.case=TRUE)]="17.5"
data.Export$SampleDepth[grep("18M",data$Station,ignore.case=TRUE)]="18"
data.Export$SampleDepth[grep("18.5M",data$Station,ignore.case=TRUE)]="18.5"
data.Export$SampleDepth[grep("19M",data$Station,ignore.case=TRUE)]="19"
data.Export$SampleDepth[grep("19.5M",data$Station,ignore.case=TRUE)]="19.5"
data.Export$SampleDepth[grep("20M",data$Station,ignore.case=TRUE)]="20"
data.Export$SampleDepth[grep("21M",data$Station,ignore.case=TRUE)]="21"
data.Export$SampleDepth[grep("22M",data$Station,ignore.case=TRUE)]="22"
data.Export$SampleDepth[grep("25M",data$Station,ignore.case=TRUE)]="25"
data.Export$SampleDepth[grep("27M",data$Station,ignore.case=TRUE)]="27"
data.Export$SampleDepth[grep("1-M",data$Station,ignore.case=TRUE)]="1"
data.Export$SampleDepth[grep("35M",data$Station,ignore.case=TRUE)]="35"
data.Export$SampleDepth[grep("40M",data$Station,ignore.case=TRUE)]="40"
data.Export$SampleDepth[grep("45M",data$Station,ignore.case=TRUE)]="45"
#now dealing with observations that are null for both SamplePosition and SampleDepth
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SampleDepth[which(data.Export$SampleDepth=="")]=NA 
data.Export$SamplePosition[which(data.Export$SamplePosition=="")]=NA 
data.Export$SamplePosition=as.character(data.Export$SamplePosition) 
data.Export$SamplePosition[which(is.na(data.Export$SamplePosition)==TRUE & is.na(data.Export$SampleDepth)==FALSE)]="SPECIFIED" 
data.Export$SamplePosition[which(is.na(data.Export$SamplePosition)==TRUE & is.na(data.Export$SampleDepth)==TRUE)]="UNKNOWN" 
unique(data.Export$SamplePosition) #should only be three unique sample positions (epi, hypo, unknown,null)

#proceed with populating other lagos fields. 
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType[grep("deep",data$Station,ignore.case=TRUE)]="PRIMARY" #for observations in "Station" that contain "deep" the deep whole was sampled= PRIMARY
data.Export$BasinType[which(is.na(data.Export$BasinType==TRUE))]= "UNKNOWN" #those for which "deep hole" or "deep" is not specified remain unknown
data.Export$MethodInfo = NA #no method info
data.Export$Comments=as.character(data.Export$Comments)
unique(data.Export$Value) #flag those chla obs > 5000 as suspicious
length(data.Export$Value[which(data.Export$Value>=5000)])
data.Export$Comments[which(data.Export$Value>=5000)]="Value is suspiciously high. Source data reported observation in units of mg/L, but it is suspected that the observation was actually reported in ug/L."
unique(data.Export$Comments)
data.Export$Subprogram=NA #sub program unknown
data.Export$LabMethodName=as.character(data.Export$LabMethodName)
data.Export$LabMethodName="SM_10200H"
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)                     
data.Export$LabMethodInfo= "Trichromatic Spectrometric method corrected for phaeophytin. Standard Methods (1976) 10200H"             
data.Export$DetectionLimit=NA 
unique(data.Export$SamplePosition) #check to make sure only 3 unique- (unknown, epi, hypo)
Chla.Final = data.Export
rm(data.Export)
rm(data)


#########################"Ammonia-N T (mg/L)"#######################################################################################
data=PA_DEP_CHEM
names(data) #looking at data, filter columns 
data = data[,c(1:3,5:6,19,25)] #pulling out columns of interest
head(data) #looking at data
data$Ammonia.N.T..mg.L.=as.character(data$Ammonia.N.T..mg.L.)
length(data$Ammonia.N.T..mg.L.[which(data$Ammonia.N.T..mg.L.=="")]) 
4021-3279 #only 742 observations the rest are NA
data$Ammonia.N.T..mg.L.[which(data$Ammonia.N.T..mg.L.=="")]=NA #set all null observations to NA
length(data$Ammonia.N.T..mg.L.[which(is.na(data$Ammonia.N.T..mg.L.==TRUE))]) #check to make sure proper number of obserations set as NA. 
data = data[which(is.na(data[,7])==FALSE),] #filter data to exclude NA observations
unique(data$Ammonia.N.T..mg.L.) #get rid of anything that is "<" and add a CensorCode
#get rid of those data with text like "mg/l" and "x" (next 6 lines)
data$Ammonia.N.T..mg.L.[which(data$Ammonia.N.T..mg.L.=="12/31/1899")]=NA 
data$Ammonia.N.T..mg.L.[which(data$Ammonia.N.T..mg.L.=="1/0/1900")]=NA 
data$Ammonia.N.T..mg.L.[which(data$Ammonia.N.T..mg.L.=="1/2/1900")]=NA 
data$Ammonia.N.T..mg.L.[which(data$Ammonia.N.T..mg.L.=="0.61 mg/l")]=".61"
data$Ammonia.N.T..mg.L.[which(data$Ammonia.N.T..mg.L.=="0.15 mg/l")]=".15"
data$Ammonia.N.T..mg.L.[which(data$Ammonia.N.T..mg.L.=="0.06x")]=".06"
data = data[which(is.na(data[,7])==FALSE),] #get rid of new NA values
unique(data$Ammonia.N.T..mg.L.) #those unique values with "<" will be dealt with when Censor Code is defined
unique(data$Sample.No) #SampleNo contains info on depth and sample position, looking at info on unique values
unique(data$Station) #over 700 unique values describing the Station-which contains info on the sampling depth and sample position
data$Sample.No=as.character(data$Sample.No)
data$Sample.No[which(data$Sample.No=="0959*-106")]="99" #use 99 as a generic value to eliminate these observations (next two lines=same)
data=data[which(data$Sample.No!="99"),] #filter these observations out as they are flagged to be duplicate

###no other data filtering, begin exporting to LAGOS
data.Export = LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$Lake.ID
data.Export$LakeName=data$Lake.Name
data.Export$SourceVariableName = "Ammonia-N T (mg/L)"
data.Export$SourceVariableDescription = as.character(data.Export$SourceVariableDescription)
data.Export$SourceVariableDescription = "Ammonia as N in mg/L"
data.Export$LagosVariableID= 19
data.Export$LagosVariableName="Nitrogen, NH4"
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$Ammonia.N.T..mg.L.=="<0.02")]="LT"
data.Export$CensorCode[which(data$Ammonia.N.T..mg.L.=="< 0.02")]="LT"
data.Export$CensorCode[which(data$Ammonia.N.T..mg.L.=="<.02")]="LT"
data.Export$CensorCode[which(data$Ammonia.N.T..mg.L.=="<0.10")]="LT"
data.Export$CensorCode[which(data$Ammonia.N.T..mg.L.=="<0.01")]="LT"
data.Export$CensorCode[which(data$Ammonia.N.T..mg.L.=="<0.04")]="LT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode==TRUE))]= "NC"
unique(data.Export$CensorCode) #check to make sure proper CensorCode types exported
#now overwrite data with "<" signs
data$Ammonia.N.T..mg.L.[which(data$Ammonia.N.T..mg.L.=="<0.02")]="0.02"
data$Ammonia.N.T..mg.L.[which(data$Ammonia.N.T..mg.L.=="< 0.02")]="0.02"
data$Ammonia.N.T..mg.L.[which(data$Ammonia.N.T..mg.L.=="<.02")]="0.02"
data$Ammonia.N.T..mg.L.[which(data$Ammonia.N.T..mg.L.=="<0.10")]="0.10"
data$Ammonia.N.T..mg.L.[which(data$Ammonia.N.T..mg.L.=="<0.01")]="0.01"  
data$Ammonia.N.T..mg.L.[which(data$Ammonia.N.T..mg.L.=="<0.04")]= "0.04"   
unique(data$Ammonia.N.T..mg.L.) #check to make sure all strange values gone  
typeof(data$Ammonia.N.T..mg.L.)
unique(data$Ammonia.N.T..mg.L.)
data$Ammonia.N.T..mg.L.=as.numeric(data$Ammonia.N.T..mg.L.)
data$Ammonia.N.T..mg.L.=as.numeric(data$Ammonia.N.T..mg.L.)
data.Export$Value = (data[,7])*1000 #export nh4 values, multiply by 1000 to go from mg/l to preferred units of ug/l
unique(data.Export$Value)
data.Export$SourceFlags= NA  #no source flags involved with these data
data.Export$SampleType = as.character(data.Export$SampleType)
data.Export$SampleType= "GRAB"
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L" #preferred units
unique(data$Sample.No) #Sample.No contains info on the depth/position in some cases
unique(data$Station) #contains info on the depth/position sample was taken at
data$Station=as.character(data$Station) #set as character so it can be manipulated
data$Sample.No=as.character(data$Sample.No) #set as character so it can be manipulated
#now need to use "Sample.No" and "Station" to export info on depth and SamplePositionto LAGOS
#grep will be used to extract info found in "Sample.No" and "Station" and based on that info specify LAGOS "SampleDepth" and "SamplePosition"
data.Export$SampleDepth[which(data$Sample.No=="Sta.3-1M")] = "1" #specifying depth based on unique data$Sample.No
data.Export$SampleDepth[which(data$Sample.No=="Sta.3-2.5M")] = "2.5" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.2-14.5M")] = "14.5" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.1-1M")] = "1" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.3-3M")] = "3" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.1-12M")] = "12" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.3-18.5M")] = "18.5" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.2-13.5M")] = "13.5" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.2-8.5M")] = "8.5" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.2-1M")] = "1" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.1-4M")] = "4" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.3-19M")] = "19" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.2-4.5M")] = "4.5"
data.Export$SampleDepth[which(data$Sample.No=="Sta.2-4M")] = "4"
data.Export$SampleDepth[which(data$Sample.No=="Sta.1-11M")] = "11"
#now look at data$Station and use grep to find the specified depth and export to LAGOS
data.Export$SampleDepth[grep(".1M",data$Station,ignore.case=TRUE)]=".1"
data.Export$SampleDepth[grep(".2M",data$Station,ignore.case=TRUE)]=".2"
data.Export$SampleDepth[grep(".3M",data$Station,ignore.case=TRUE)]=".3"
data.Export$SampleDepth[grep(".4M",data$Station,ignore.case=TRUE)]=".4"
data.Export$SampleDepth[grep(".5M",data$Station,ignore.case=TRUE)]=".5"
data.Export$SampleDepth[grep(".6M",data$Station,ignore.case=TRUE)]=".6"
data.Export$SampleDepth[grep(".7M",data$Station,ignore.case=TRUE)]=".7"
data.Export$SampleDepth[grep(".8M",data$Station,ignore.case=TRUE)]=".8"
data.Export$SampleDepth[grep(".9M",data$Station,ignore.case=TRUE)]=".9"
data.Export$SampleDepth[grep("1M",data$Station,ignore.case=TRUE)]="1"
data.Export$SampleDepth[grep("1.5M",data$Station,ignore.case=TRUE)]="1.5"
data.Export$SampleDepth[grep("2M",data$Station,ignore.case=TRUE)]="2"
data.Export$SampleDepth[grep("2.3M",data$Station,ignore.case=TRUE)]="2.3"
data.Export$SampleDepth[grep("2.5M",data$Station,ignore.case=TRUE)]="2.5"
data.Export$SampleDepth[grep("3M",data$Station,ignore.case=TRUE)]="3"
data.Export$SampleDepth[grep("3.5M",data$Station,ignore.case=TRUE)]="3.5"
data.Export$SampleDepth[grep("4M",data$Station,ignore.case=TRUE)]="4"
data.Export$SampleDepth[grep("4.5M",data$Station,ignore.case=TRUE)]="4.5"
data.Export$SampleDepth[grep("5M",data$Station,ignore.case=TRUE)]="5"
data.Export$SampleDepth[grep("5.5M",data$Station,ignore.case=TRUE)]="5.5"
data.Export$SampleDepth[grep("6M",data$Station,ignore.case=TRUE)]="6"
data.Export$SampleDepth[grep("6.5M",data$Station,ignore.case=TRUE)]="6.5"
data.Export$SampleDepth[grep("6.7M",data$Station,ignore.case=TRUE)]="6.7"
data.Export$SampleDepth[grep("7M",data$Station,ignore.case=TRUE)]="7"
data.Export$SampleDepth[grep("7.5M",data$Station,ignore.case=TRUE)]="7.5"
data.Export$SampleDepth[grep("8M",data$Station,ignore.case=TRUE)]="8"
data.Export$SampleDepth[grep("8.5M",data$Station,ignore.case=TRUE)]="8.5"
data.Export$SampleDepth[grep("9M",data$Station,ignore.case=TRUE)]="9"
data.Export$SampleDepth[grep("9.5M",data$Station,ignore.case=TRUE)]="9.5"
data.Export$SampleDepth[grep("10M",data$Station,ignore.case=TRUE)]="10"
data.Export$SampleDepth[grep("10.5M",data$Station,ignore.case=TRUE)]="10.5"
data.Export$SampleDepth[grep("11M",data$Station,ignore.case=TRUE)]="11"
data.Export$SampleDepth[grep("11.5M",data$Station,ignore.case=TRUE)]="11.5"
data.Export$SampleDepth[grep("12M",data$Station,ignore.case=TRUE)]="12"
data.Export$SampleDepth[grep("12.5M",data$Station,ignore.case=TRUE)]="12.5"
data.Export$SampleDepth[grep("13M",data$Station,ignore.case=TRUE)]="13"
data.Export$SampleDepth[grep("13.5M",data$Station,ignore.case=TRUE)]="13.5"
data.Export$SampleDepth[grep("14M",data$Station,ignore.case=TRUE)]="14"
data.Export$SampleDepth[grep("14.5M",data$Station,ignore.case=TRUE)]="14.5"
data.Export$SampleDepth[grep("15M",data$Station,ignore.case=TRUE)]="15"
data.Export$SampleDepth[grep("15.5M",data$Station,ignore.case=TRUE)]="15.5"
data.Export$SampleDepth[grep("16M",data$Station,ignore.case=TRUE)]="16"
data.Export$SampleDepth[grep("16.5M",data$Station,ignore.case=TRUE)]="16.5"
data.Export$SampleDepth[grep("17M",data$Station,ignore.case=TRUE)]="17"
data.Export$SampleDepth[grep("17.5M",data$Station,ignore.case=TRUE)]="17.5"
data.Export$SampleDepth[grep("18M",data$Station,ignore.case=TRUE)]="18"
data.Export$SampleDepth[grep("18.5M",data$Station,ignore.case=TRUE)]="18.5"
data.Export$SampleDepth[grep("19M",data$Station,ignore.case=TRUE)]="19"
data.Export$SampleDepth[grep("19.5M",data$Station,ignore.case=TRUE)]="19.5"
data.Export$SampleDepth[grep("20M",data$Station,ignore.case=TRUE)]="20"
data.Export$SampleDepth[grep("21M",data$Station,ignore.case=TRUE)]="21"
data.Export$SampleDepth[grep("22M",data$Station,ignore.case=TRUE)]="22"
data.Export$SampleDepth[grep("25M",data$Station,ignore.case=TRUE)]="25"
data.Export$SampleDepth[grep("27M",data$Station,ignore.case=TRUE)]="27"
data.Export$SampleDepth[grep("1-M",data$Station,ignore.case=TRUE)]="1"
data.Export$SampleDepth[grep("35M",data$Station,ignore.case=TRUE)]="35"
data.Export$SampleDepth[grep("40M",data$Station,ignore.case=TRUE)]="40"
#now do the same thing for SamplePosition using data$Station
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[grep("sfc",data$Station,ignore.case=TRUE)]="EPI" #for all "Station" observations that have "sfc"=surface, set SamplePosition to EPI
data.Export$SamplePosition[grep("surf",data$Station,ignore.case=TRUE)]="EPI"#for all "Station" observations that have "surf"=surface, set sampleposition to EPI
data.Export$SamplePosition[grep("surface",data$Station,ignore.case=TRUE)]="EPI" #for all "Station" observations that have "surface"=surface, set sampleposition to EPI
data.Export$SamplePosition[grep("bott",data$Station,ignore.case=TRUE)]="HYPO" #for all "Station" observations that have "bott"= bottom, set sampleposition to HYPO
data.Export$SamplePosition[grep("bot",data$Station,ignore.case=TRUE)]="HYPO" #for all "Station" observations that have "bot"= bottom, set sampleposition to HYPO
data.Export$SamplePosition[grep("bottom",data$Station,ignore.case=TRUE)]="HYPO"
data.Export$SamplePosition[grep("bottm",data$Station,ignore.case=TRUE)]="HYPO"
data.Export$SamplePosition[grep("(sfc)",data$Station,ignore.case=TRUE)]="EPI"
data.Export$SamplePosition[grep("-sfc",data$Station,ignore.case=TRUE)]="EPI"
data.Export$SamplePosition[grep("-bott",data$Station,ignore.case=TRUE)]="HYPO"
data.Export$SamplePosition[grep("(bott)",data$Station,ignore.case=TRUE)]="HYPO" 

#now dealing with observations that are null for both SamplePosition and SampleDepth
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SampleDepth[which(data.Export$SampleDepth=="")]=NA #make sure empty is specified as NA
data.Export$SamplePosition[which(data.Export$SamplePosition=="")]=NA #make sure empty is specified as NA
data.Export$SamplePosition=as.character(data.Export$SamplePosition) 
data.Export$SamplePosition[which(is.na(data.Export$SamplePosition)==TRUE & is.na(data.Export$SampleDepth)==FALSE)]="SPECIFIED" 
data.Export$SamplePosition[which(is.na(data.Export$SamplePosition)==TRUE & is.na(data.Export$SampleDepth)==TRUE)]="UNKNOWN" 
unique(data.Export$SamplePosition) 

#continue populating lagos
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType[grep("deep",data$Station,ignore.case=TRUE)]="PRIMARY" #for observations in "Station" that contain "deep" the deep whole was sampled= PRIMARY
data.Export$BasinType[which(is.na(data.Export$BasinType==TRUE))]= "UNKNOWN" #those for which "deep hole" or "deep" is not specified remain unknown
unique(data.Export$BasinType) #check to make sure proper values exported
data.Export$MethodInfo = NA 
data.Export$Comments = NA # comments excluded because they are only relevant to the specific sample no. which is not specified in LAGOS
data.Export$Subprogram=NA #sub program unknown
data.Export$LabMethodName=as.character(data.Export$LabMethodName)
data.Export$LabMethodName="EPA_350.1"
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)                     
data.Export$LabMethodInfo= "Semi-automated colorimetry"             
data.Export$DetectionLimit=as.numeric(data.Export$DetectionLimit)
data.Export$DetectionLimit= (0.02*1000) #Dl= .02 mg/l per metadata, multiply by 1000 to get into prefered units of ug/l
NH4.Final = data.Export
rm(data.Export)
rm(data)

#########################"Nitrate-N (mg/L)"#######################################################################################
data=PA_DEP_CHEM
names(data) #looking at data, filter columns 
data = data[,c(1:3,5:6,19,26)] #pulling out columns of interest
head(data) #looking at data
data$Nitrate.N..mg.L.=as.character(data$Nitrate.N..mg.L.)
length(data$Nitrate.N..mg.L.[which(is.na(data$Nitrate.N..mg.L.==TRUE))]) #only 2 Null values
data$Nitrate.N..mg.L.[which(data$Nitrate.N..mg.L.=="")]=NA #set all null observations to NA
length(data$Nitrate.N..mg.L.[which(is.na(data$Nitrate.N..mg.L.==TRUE))]) #set blank observations to NA
4021-3370 #651 observations should be left after filtering out NA (next command)
data = data[which(is.na(data[,7])==FALSE),] #filter data to exclude NA observations
unique(data$Nitrate.N..mg.L.) #get rid of anything that is "<" and add a CensorCode
#get rid of those data with text like "mg/l" and "x" (next 6 lines)
data$Nitrate.N..mg.L.[which(data$Nitrate.N..mg.L.=="1/2/1900")]=NA 
data$Nitrate.N..mg.L.[which(data$Nitrate.N..mg.L.=="1/1/1900")]=NA 
data$Nitrate.N..mg.L.[which(data$Nitrate.N..mg.L.=="1/0/1900")]=NA 
data$Nitrate.N..mg.L.[which(data$Nitrate.N..mg.L.=="1/3/1900")]=NA 
data = data[which(is.na(data[,7])==FALSE),] #get rid of new NA values
unique(data$Nitrate.N..mg.L.) #those unique values with "<" ">" and "Below Det." will be dealt with when Censor Code is defined
unique(data$Sample.No) #SampleNo contains info on depth and sample position, looking at info on unique values
unique(data$Station) #146 unique values describing the Station-which contains info on the sampling depth and sample position
###no other data filtering, begin exporting to LAGOS
data.Export = LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$Lake.ID
data.Export$LakeName=data$Lake.Name
data.Export$SourceVariableName = "Nitrate-N (mg/L)"
data.Export$SourceVariableDescription = as.character(data.Export$SourceVariableDescription)
data.Export$SourceVariableDescription = "Nitrate as N"
data.Export$LagosVariableID= 18
data.Export$LagosVariableName="Nitrogen, nitrite (NO2) + nitrate (NO3)"
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$Nitrate.N..mg.L.=="<0.10")]="LT"
data.Export$CensorCode[which(data$Nitrate.N..mg.L.=="<0.064")]="LT"
data.Export$CensorCode[which(data$Nitrate.N..mg.L.=="<0.04")]="LT"
data.Export$CensorCode[which(data$Nitrate.N..mg.L.=="<0.50")]="LT"
data.Export$CensorCode[which(data$Nitrate.N..mg.L.==">0.50")]="GT"
data.Export$CensorCode[which(data$Nitrate.N..mg.L.=="<0.0.4")]="LT"
data.Export$CensorCode[which(data$Nitrate.N..mg.L.=="<.04")]="LT"
data.Export$CensorCode[which(data$Nitrate.N..mg.L.=="<0.02")]="LT"
data.Export$CensorCode[which(data$Nitrate.N..mg.L.=="Below Det.")]="LT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode==TRUE))]= "NC"
unique(data.Export$CensorCode) #check to make sure proper CensorCode types exported
#now overwrite data with "<" and ">" signs and deal with "Below Det." (ELIMINATE SPECIAL CHARACTERS)
data$Nitrate.N..mg.L.[which(data$Nitrate.N..mg.L.=="<0.10")]="0.10"
data$Nitrate.N..mg.L.[which(data$Nitrate.N..mg.L.=="<0.064")]="0.064"
data$Nitrate.N..mg.L.[which(data$Nitrate.N..mg.L.=="<0.04")]="0.04"
data$Nitrate.N..mg.L.[which(data$Nitrate.N..mg.L.=="<0.50")]="0.50"
data$Nitrate.N..mg.L.[which(data$Nitrate.N..mg.L.==">0.50")]="0.50"
data$Nitrate.N..mg.L.[which(data$Nitrate.N..mg.L.=="<0.0.4")]="0.04"
data$Nitrate.N..mg.L.[which(data$Nitrate.N..mg.L.=="<.04")]="0.04"
data$Nitrate.N..mg.L.[which(data$Nitrate.N..mg.L.=="<0.02")]="0.04"
data$Nitrate.N..mg.L.[which(data$Nitrate.N..mg.L.=="Below Det.")]="0.05" #SET THESE EQUAL TO THE DETECTION LIMIT (MG/L) 
unique(data$Nitrate.N..mg.L.) #check to make sure all strange values gone/SPECIAL CHARACTERS GONE  
typeof(data$Nitrate.N..mg.L.)
data$Nitrate.N..mg.L.=as.numeric(data$Nitrate.N..mg.L.)
data.Export$Value = (data[,7])*1000 #export n03 values, multiply by 1000 to go from mg/l to preferred units of ug/l
unique(data.Export$Value)
data.Export$SourceFlags= NA  #no source flags involved with these data
data.Export$SampleType = as.character(data.Export$SampleType)
data.Export$SampleType= "GRAB"
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L" #preferred units
unique(data$Sample.No) #Sample.No contains info on the depth/position in some cases
unique(data$Station) #contains info on the depth/position sample was taken at
data$Station=as.character(data$Station) #set as character so it can be manipulated
data$Sample.No=as.character(data$Sample.No) #set as character so it can be manipulated
#now need to use "Sample.No" and "Station" to export info on depth and SamplePositionto LAGOS
#grep will be used to extract info found in "Sample.No" and "Station" and based on that info specify LAGOS "SampleDepth" and "SamplePosition"
data.Export$SampleDepth[which(data$Sample.No=="Sta.1-11M")] = "11" #specifying depth based on unique data$Sample.No
data.Export$SampleDepth[which(data$Sample.No==" Sta.1-1M ")] = "1" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.2-14.5M")] = "14.5" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.1-12M")] = "12" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.3-18.5M")] = "18.5" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.2-1M")] = "1" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.2-8.5M")] = "8.5" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.2-13.5M")] = "13.5" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.3-1M")] = "1" 
#now look at data$Station and use grep to find the specified depth and export to LAGOS
data.Export$SampleDepth[grep(".1M",data$Station,ignore.case=TRUE)]=".1"
data.Export$SampleDepth[grep(".2M",data$Station,ignore.case=TRUE)]=".2"
data.Export$SampleDepth[grep(".3M",data$Station,ignore.case=TRUE)]=".3"
data.Export$SampleDepth[grep(".4M",data$Station,ignore.case=TRUE)]=".4"
data.Export$SampleDepth[grep(".5M",data$Station,ignore.case=TRUE)]=".5"
data.Export$SampleDepth[grep(".6M",data$Station,ignore.case=TRUE)]=".6"
data.Export$SampleDepth[grep(".7M",data$Station,ignore.case=TRUE)]=".7"
data.Export$SampleDepth[grep(".8M",data$Station,ignore.case=TRUE)]=".8"
data.Export$SampleDepth[grep(".9M",data$Station,ignore.case=TRUE)]=".9"
data.Export$SampleDepth[grep("1M",data$Station,ignore.case=TRUE)]="1"
data.Export$SampleDepth[grep("1.5M",data$Station,ignore.case=TRUE)]="1.5"
data.Export$SampleDepth[grep("2M",data$Station,ignore.case=TRUE)]="2"
data.Export$SampleDepth[grep("2.3M",data$Station,ignore.case=TRUE)]="2.3"
data.Export$SampleDepth[grep("2.5M",data$Station,ignore.case=TRUE)]="2.5"
data.Export$SampleDepth[grep("3M",data$Station,ignore.case=TRUE)]="3"
data.Export$SampleDepth[grep("3.5M",data$Station,ignore.case=TRUE)]="3.5"
data.Export$SampleDepth[grep("4M",data$Station,ignore.case=TRUE)]="4"
data.Export$SampleDepth[grep("4.5M",data$Station,ignore.case=TRUE)]="4.5"
data.Export$SampleDepth[grep("5M",data$Station,ignore.case=TRUE)]="5"
data.Export$SampleDepth[grep("5.5M",data$Station,ignore.case=TRUE)]="5.5"
data.Export$SampleDepth[grep("6M",data$Station,ignore.case=TRUE)]="6"
data.Export$SampleDepth[grep("6.5M",data$Station,ignore.case=TRUE)]="6.5"
data.Export$SampleDepth[grep("6.7M",data$Station,ignore.case=TRUE)]="6.7"
data.Export$SampleDepth[grep("7M",data$Station,ignore.case=TRUE)]="7"
data.Export$SampleDepth[grep("7.5M",data$Station,ignore.case=TRUE)]="7.5"
data.Export$SampleDepth[grep("8M",data$Station,ignore.case=TRUE)]="8"
data.Export$SampleDepth[grep("8.5M",data$Station,ignore.case=TRUE)]="8.5"
data.Export$SampleDepth[grep("9M",data$Station,ignore.case=TRUE)]="9"
data.Export$SampleDepth[grep("9.5M",data$Station,ignore.case=TRUE)]="9.5"
data.Export$SampleDepth[grep("10M",data$Station,ignore.case=TRUE)]="10"
data.Export$SampleDepth[grep("10.5M",data$Station,ignore.case=TRUE)]="10.5"
data.Export$SampleDepth[grep("11M",data$Station,ignore.case=TRUE)]="11"
data.Export$SampleDepth[grep("11.5M",data$Station,ignore.case=TRUE)]="11.5"
data.Export$SampleDepth[grep("12M",data$Station,ignore.case=TRUE)]="12"
data.Export$SampleDepth[grep("12.5M",data$Station,ignore.case=TRUE)]="12.5"
data.Export$SampleDepth[grep("13M",data$Station,ignore.case=TRUE)]="13"
data.Export$SampleDepth[grep("13.5M",data$Station,ignore.case=TRUE)]="13.5"
data.Export$SampleDepth[grep("14M",data$Station,ignore.case=TRUE)]="14"
data.Export$SampleDepth[grep("14.5M",data$Station,ignore.case=TRUE)]="14.5"
data.Export$SampleDepth[grep("15M",data$Station,ignore.case=TRUE)]="15"
data.Export$SampleDepth[grep("15.5M",data$Station,ignore.case=TRUE)]="15.5"
data.Export$SampleDepth[grep("16M",data$Station,ignore.case=TRUE)]="16"
data.Export$SampleDepth[grep("16.5M",data$Station,ignore.case=TRUE)]="16.5"
data.Export$SampleDepth[grep("17M",data$Station,ignore.case=TRUE)]="17"
data.Export$SampleDepth[grep("17.5M",data$Station,ignore.case=TRUE)]="17.5"
data.Export$SampleDepth[grep("18M",data$Station,ignore.case=TRUE)]="18"
data.Export$SampleDepth[grep("18.5M",data$Station,ignore.case=TRUE)]="18.5"
data.Export$SampleDepth[grep("19M",data$Station,ignore.case=TRUE)]="19"
data.Export$SampleDepth[grep("19.5M",data$Station,ignore.case=TRUE)]="19.5"
data.Export$SampleDepth[grep("20M",data$Station,ignore.case=TRUE)]="20"
data.Export$SampleDepth[grep("21M",data$Station,ignore.case=TRUE)]="21"
data.Export$SampleDepth[grep("22M",data$Station,ignore.case=TRUE)]="22"
data.Export$SampleDepth[grep("25M",data$Station,ignore.case=TRUE)]="25"
data.Export$SampleDepth[grep("27M",data$Station,ignore.case=TRUE)]="27"
data.Export$SampleDepth[grep("1-M",data$Station,ignore.case=TRUE)]="1"
data.Export$SampleDepth[grep("35M",data$Station,ignore.case=TRUE)]="35"
data.Export$SampleDepth[grep("40M",data$Station,ignore.case=TRUE)]="40"
data.Export$SampleDepth[grep("45M",data$Station,ignore.case=TRUE)]="45"
#now do the same thing for SamplePosition using data$Station
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[grep("sfc",data$Station,ignore.case=TRUE)]="EPI" #for all "Station" observations that have "sfc"=surface, set SamplePosition to EPI
data.Export$SamplePosition[grep("surf",data$Station,ignore.case=TRUE)]="EPI"#for all "Station" observations that have "surf"=surface, set sampleposition to EPI
data.Export$SamplePosition[grep("surface",data$Station,ignore.case=TRUE)]="EPI" #for all "Station" observations that have "surface"=surface, set sampleposition to EPI
data.Export$SamplePosition[grep("bott",data$Station,ignore.case=TRUE)]="HYPO" #for all "Station" observations that have "bott"= bottom, set sampleposition to HYPO
data.Export$SamplePosition[grep("bot",data$Station,ignore.case=TRUE)]="HYPO" #for all "Station" observations that have "bot"= bottom, set sampleposition to HYPO
data.Export$SamplePosition[grep("bottom",data$Station,ignore.case=TRUE)]="HYPO"
data.Export$SamplePosition[grep("bottm",data$Station,ignore.case=TRUE)]="HYPO"
data.Export$SamplePosition[grep("(sfc)",data$Station,ignore.case=TRUE)]="EPI"
data.Export$SamplePosition[grep("-sfc",data$Station,ignore.case=TRUE)]="EPI"
data.Export$SamplePosition[grep("-bott",data$Station,ignore.case=TRUE)]="HYPO"
data.Export$SamplePosition[grep("(bott)",data$Station,ignore.case=TRUE)]="HYPO" 

#now dealing with observations that are null for both SamplePosition and SampleDepth
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SampleDepth[which(data.Export$SampleDepth=="")]=NA #make sure empty is specified as NA
data.Export$SamplePosition[which(data.Export$SamplePosition=="")]=NA #make sure empty is specified as NA
data.Export$SamplePosition=as.character(data.Export$SamplePosition) 
data.Export$SamplePosition[which(is.na(data.Export$SamplePosition)==TRUE & is.na(data.Export$SampleDepth)==FALSE)]="SPECIFIED" 
data.Export$SamplePosition[which(is.na(data.Export$SamplePosition)==TRUE & is.na(data.Export$SampleDepth)==TRUE)]="UNKNOWN" 
unique(data.Export$SamplePosition) 
###remove "null" values at the end
unique(data.Export$SamplePosition) #should only be four unique sample positions (epi, hypo, unknown, null)
#continue with populating other lagos variables
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType[grep("deep",data$Station,ignore.case=TRUE)]="PRIMARY" #for observations in "Station" that contain "deep" the deep whole was sampled= PRIMARY
data.Export$BasinType[which(is.na(data.Export$BasinType==TRUE))]= "UNKNOWN" #those for which "deep hole" or "deep" is not specified remain unknown
unique(data.Export$BasinType) #check to make sure proper values exported
data.Export$MethodInfo = NA 
data.Export$Comments = NA # comments excluded because they are only relevant to the specific sample no. which is not specified in LAGOS
data.Export$Subprogram=NA #sub program unknown
data.Export$LabMethodName=as.character(data.Export$LabMethodName)
data.Export$LabMethodName="EPA_353.2"
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)                     
data.Export$LabMethodInfo= "Automated cadmium reduction"             
data.Export$DetectionLimit=as.numeric(data.Export$DetectionLimit)
data.Export$DetectionLimit= (0.05*1000) #Dl= .05 mg/l per metadata, multiply by 1000 to get into prefered units of ug/l
NO3.Final = data.Export
rm(data.Export)
rm(data)


########################"Nitrite-N (mg/L)"#######################################################################################
data=PA_DEP_CHEM
names(data) #looking at data, filter columns 
data = data[,c(1:3,5:6,19,46)] #pulling out columns of interest
head(data) #looking at data
data$Nitrite.N..mg.L.=as.character(data$Nitrite.N..mg.L.)
length(data$Nitrite.N..mg.L.[which(is.na(data$Nitrite.N..mg.L.==TRUE))]) #no values are NA
data$Nitrite.N..mg.L.[which(data$Nitrite.N..mg.L.=="")]=NA #set all null observations to NA
length(data$Nitrite.N..mg.L.[which(is.na(data$Nitrite.N..mg.L.==TRUE))]) #set blank observations to NA, 3517 values are NA
4021-3517 #504 observations should be left after filtering out NA (next command)
data = data[which(is.na(data[,7])==FALSE),] #filter data to exclude NA observations
unique(data$Nitrite.N..mg.L.) #get rid of anything that is "<" and add a CensorCode
#get rid of those data with text like "mg/l" and "x" (next 6 lines)
data$Nitrite.N..mg.L.[which(data$Nitrite.N..mg.L.=="1/0/1900")]=NA 
data$Nitrite.N..mg.L.[which(data$Nitrite.N..mg.L.=="1/3/1900")]=NA 
data$Nitrite.N..mg.L.[which(data$Nitrite.N..mg.L.=="1/2/1900")]=NA 
data$Nitrite.N..mg.L.[which(data$Nitrite.N..mg.L.=="1/1/1900")]=NA 
data = data[which(is.na(data[,7])==FALSE),] #get rid of new NA values
unique(data$Nitrite.N..mg.L.) #those unique values with "<" and "Below Det." will be dealt with when Censor Code is defined
unique(data$Sample.No) #SampleNo contains info on depth and sample position, looking at info on unique values
unique(data$Station) #146 unique values describing the Station-which contains info on the sampling depth and sample position
##other filtering
data = data[which(data$Sample.No!="Duplicate Surface"),]#want to exclude duplicates
data = data[which(data$Sample.No!="Duplicate Bottom"),]#want to exclude duplicates
data$Sample.No=as.character(data$Sample.No)
data$Sample.No[which(data$Sample.No=="0959*-106")]="99" #use 99 as a generic value to eliminate these observations (next two lines=same)
data$Sample.No[which(data$Sample.No=="x")]="99"
data$Sample.No[which(data$Sample.No=="833?")]="99"
data=data[which(data$Sample.No!="99"),] #filter these observations out as they are flagged to be duplicate
#### now filter out observations that have "dup" or "dupl" in the Station field as these are duplicate/replicate values
data$Station=as.character(data$Station)
data$Station[grep("dup",data$Station,ignore.case=TRUE)]="-9999" #works I checked the length of values of "-9999"
data$Station[grep("dupl",data$Station,ignore.case=TRUE)]="-9999"
data$Station[grep("average",data$Station,ignore.case=TRUE)]="-9999"
data$Station[grep("averages",data$Station,ignore.case=TRUE)]="-9999"
data$Station[grep("avg",data$Station,ignore.case=TRUE)]="-9999"
data=data[which(data$Station!="-9999"),] #remove those "dup" or duplicate observations

###no other data filtering, begin exporting to LAGOS
data.Export = LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$Lake.ID
data.Export$LakeName=data$Lake.Name
data.Export$SourceVariableName = "Nitrite-N (mg/L)"
data.Export$SourceVariableDescription = as.character(data.Export$SourceVariableDescription)
data.Export$SourceVariableDescription = "Nitrite (NO2) Nitrogen"
data.Export$LagosVariableID= 17
data.Export$LagosVariableName="Nitrogen, nitrite (NO2)"
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$Nitrite.N..mg.L.=="<0.01")]="LT"
data.Export$CensorCode[which(data$Nitrite.N..mg.L.=="<0.005")]="LT"
data.Export$CensorCode[which(data$Nitrite.N..mg.L.=="<0.04")]="LT"
data.Export$CensorCode[which(data$Nitrite.N..mg.L.=="<0.100")]="LT"
data.Export$CensorCode[which(data$Nitrite.N..mg.L.=="<.0100")]="LT"
data.Export$CensorCode[which(data$Nitrite.N..mg.L.=="<.01")]="LT"
data.Export$CensorCode[which(data$Nitrite.N..mg.L.=="<0.500")]="LT"
data.Export$CensorCode[which(data$Nitrite.N..mg.L.=="<0.02")]="LT"
data.Export$CensorCode[which(data$Nitrite.N..mg.L.=="<10.0")]="LT"
data.Export$CensorCode[which(data$Nitrite.N..mg.L.=="Below Det.")]="LT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode==TRUE))]= "NC"
unique(data.Export$CensorCode) #check to make sure proper CensorCode types exported
#now overwrite data with "<" signs and deal with "Below Det." (ELIMINATE SPECIAL CHARACTERS)
data$Nitrite.N..mg.L.[which(data$Nitrite.N..mg.L.=="<0.01")]="0.01"
data$Nitrite.N..mg.L.[which(data$Nitrite.N..mg.L.=="<0.005")]="0.005"
data$Nitrite.N..mg.L.[which(data$Nitrite.N..mg.L.=="<0.04")]="0.04"
data$Nitrite.N..mg.L.[which(data$Nitrite.N..mg.L.=="<0.100")]="0.100"
data$Nitrite.N..mg.L.[which(data$Nitrite.N..mg.L.=="<.0100")]="0.0100"
data$Nitrite.N..mg.L.[which(data$Nitrite.N..mg.L.=="<.01")]="0.01"
data$Nitrite.N..mg.L.[which(data$Nitrite.N..mg.L.=="<0.500")]="0.500"
data$Nitrite.N..mg.L.[which(data$Nitrite.N..mg.L.=="<0.02")]="0.02"
data$Nitrite.N..mg.L.[which(data$Nitrite.N..mg.L.=="<10.0")]="10.0"
data$Nitrite.N..mg.L.[which(data$Nitrite.N..mg.L.=="Below Det.")]="0.05" #SET THESE EQUAL TO THE DETECTION LIMIT (MG/L) 
unique(data$Nitrite.N..mg.L.) #check to make sure all strange values gone/SPECIAL CHARACTERS GONE  
typeof(data$Nitrite.N..mg.L.)
data$Nitrite.N..mg.L.=as.numeric(data$Nitrite.N..mg.L.)
data.Export$Value = (data[,7])*1000 #export n02 values, multiply by 1000 to go from mg/l to preferred units of ug/l
unique(data.Export$Value)
data.Export$SourceFlags= NA  #no source flags involved with these data
data.Export$SampleType = as.character(data.Export$SampleType)
data.Export$SampleType[grep("integrated",data$Station,ignore.case=TRUE)]="INTEGRATED"
data.Export$SampleType[which(is.na(data.Export$SampleType==TRUE))]="GRAB"
unique(data.Export$SampleType) #just looking to see if the right values were exported.
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L" #preferred units
unique(data$Sample.No) #Sample.No contains info on the depth/position in some cases
unique(data$Station) #contains info on the depth/position sample was taken at
data$Station=as.character(data$Station) #set as character so it can be manipulated
data$Sample.No=as.character(data$Sample.No) #set as character so it can be manipulated
#now need to use "Sample.No" and "Station" to export info on depth and SamplePositionto LAGOS
#grep will be used to extract info found in "Sample.No" and "Station" and based on that info specify LAGOS "SampleDepth" and "SamplePosition"
data.Export$SampleDepth[which(data$Sample.No=="Sta.1-11M")] = "11" #specifying depth based on unique data$Sample.No
data.Export$SampleDepth[which(data$Sample.No==" Sta.1-1M ")] = "1" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.2-14.5M")] = "14.5" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.1-12M")] = "12" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.3-18.5M")] = "18.5" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.2-1M")] = "1" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.2-8.5M")] = "8.5" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.2-13.5M")] = "13.5" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.3-1M")] = "1" 

#dam-sfc, dam-bot, dam sfc, Bottom/CHL A, Bottom/CHLA, surface, bottom- in Sample.No use grep to deduce SampleType
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[grep("sfc",data$Sample.No,ignore.case=TRUE)]="EPI"
data.Export$SamplePosition[grep("surface",data$Sample.No,ignore.case=TRUE)]="EPI"
data.Export$SamplePosition[grep("surf",data$Sample.No,ignore.case=TRUE)]="EPI"
data.Export$SamplePosition[grep("bott",data$Sample.No,ignore.case=TRUE)]="HYPO"
data.Export$SamplePosition[grep("bot",data$Sample.No,ignore.case=TRUE)]="HYPO"
data.Export$SamplePosition[grep("bottom",data$Sample.No,ignore.case=TRUE)]="HYPO"



#now look at data$Station and use grep to find the specified depth and export to LAGOS
data.Export$SampleDepth[grep(".1M",data$Station,ignore.case=TRUE)]=".1"
data.Export$SampleDepth[grep(".2M",data$Station,ignore.case=TRUE)]=".2"
data.Export$SampleDepth[grep(".3M",data$Station,ignore.case=TRUE)]=".3"
data.Export$SampleDepth[grep(".4M",data$Station,ignore.case=TRUE)]=".4"
data.Export$SampleDepth[grep(".5M",data$Station,ignore.case=TRUE)]=".5"
data.Export$SampleDepth[grep(".6M",data$Station,ignore.case=TRUE)]=".6"
data.Export$SampleDepth[grep(".7M",data$Station,ignore.case=TRUE)]=".7"
data.Export$SampleDepth[grep(".8M",data$Station,ignore.case=TRUE)]=".8"
data.Export$SampleDepth[grep(".9M",data$Station,ignore.case=TRUE)]=".9"
data.Export$SampleDepth[grep("1M",data$Station,ignore.case=TRUE)]="1"
data.Export$SampleDepth[grep("1.5M",data$Station,ignore.case=TRUE)]="1.5"
data.Export$SampleDepth[grep("2M",data$Station,ignore.case=TRUE)]="2"
data.Export$SampleDepth[grep("2.3M",data$Station,ignore.case=TRUE)]="2.3"
data.Export$SampleDepth[grep("2.5M",data$Station,ignore.case=TRUE)]="2.5"
data.Export$SampleDepth[grep("3M",data$Station,ignore.case=TRUE)]="3"
data.Export$SampleDepth[grep("3.5M",data$Station,ignore.case=TRUE)]="3.5"
data.Export$SampleDepth[grep("4M",data$Station,ignore.case=TRUE)]="4"
data.Export$SampleDepth[grep("4.5M",data$Station,ignore.case=TRUE)]="4.5"
data.Export$SampleDepth[grep("5M",data$Station,ignore.case=TRUE)]="5"
data.Export$SampleDepth[grep("5.5M",data$Station,ignore.case=TRUE)]="5.5"
data.Export$SampleDepth[grep("6M",data$Station,ignore.case=TRUE)]="6"
data.Export$SampleDepth[grep("6.5M",data$Station,ignore.case=TRUE)]="6.5"
data.Export$SampleDepth[grep("6.7M",data$Station,ignore.case=TRUE)]="6.7"
data.Export$SampleDepth[grep("7M",data$Station,ignore.case=TRUE)]="7"
data.Export$SampleDepth[grep("7.5M",data$Station,ignore.case=TRUE)]="7.5"
data.Export$SampleDepth[grep("8M",data$Station,ignore.case=TRUE)]="8"
data.Export$SampleDepth[grep("8.5M",data$Station,ignore.case=TRUE)]="8.5"
data.Export$SampleDepth[grep("9M",data$Station,ignore.case=TRUE)]="9"
data.Export$SampleDepth[grep("9.5M",data$Station,ignore.case=TRUE)]="9.5"
data.Export$SampleDepth[grep("10M",data$Station,ignore.case=TRUE)]="10"
data.Export$SampleDepth[grep("10.5M",data$Station,ignore.case=TRUE)]="10.5"
data.Export$SampleDepth[grep("11M",data$Station,ignore.case=TRUE)]="11"
data.Export$SampleDepth[grep("11.5M",data$Station,ignore.case=TRUE)]="11.5"
data.Export$SampleDepth[grep("12M",data$Station,ignore.case=TRUE)]="12"
data.Export$SampleDepth[grep("12.5M",data$Station,ignore.case=TRUE)]="12.5"
data.Export$SampleDepth[grep("13M",data$Station,ignore.case=TRUE)]="13"
data.Export$SampleDepth[grep("13.5M",data$Station,ignore.case=TRUE)]="13.5"
data.Export$SampleDepth[grep("14M",data$Station,ignore.case=TRUE)]="14"
data.Export$SampleDepth[grep("14.5M",data$Station,ignore.case=TRUE)]="14.5"
data.Export$SampleDepth[grep("15M",data$Station,ignore.case=TRUE)]="15"
data.Export$SampleDepth[grep("15.5M",data$Station,ignore.case=TRUE)]="15.5"
data.Export$SampleDepth[grep("16M",data$Station,ignore.case=TRUE)]="16"
data.Export$SampleDepth[grep("16.5M",data$Station,ignore.case=TRUE)]="16.5"
data.Export$SampleDepth[grep("17M",data$Station,ignore.case=TRUE)]="17"
data.Export$SampleDepth[grep("17.5M",data$Station,ignore.case=TRUE)]="17.5"
data.Export$SampleDepth[grep("18M",data$Station,ignore.case=TRUE)]="18"
data.Export$SampleDepth[grep("18.5M",data$Station,ignore.case=TRUE)]="18.5"
data.Export$SampleDepth[grep("19M",data$Station,ignore.case=TRUE)]="19"
data.Export$SampleDepth[grep("19.5M",data$Station,ignore.case=TRUE)]="19.5"
data.Export$SampleDepth[grep("20M",data$Station,ignore.case=TRUE)]="20"
data.Export$SampleDepth[grep("21M",data$Station,ignore.case=TRUE)]="21"
data.Export$SampleDepth[grep("22M",data$Station,ignore.case=TRUE)]="22"
data.Export$SampleDepth[grep("25M",data$Station,ignore.case=TRUE)]="25"
data.Export$SampleDepth[grep("27M",data$Station,ignore.case=TRUE)]="27"
data.Export$SampleDepth[grep("1-M",data$Station,ignore.case=TRUE)]="1"
data.Export$SampleDepth[grep("35M",data$Station,ignore.case=TRUE)]="35"
data.Export$SampleDepth[grep("40M",data$Station,ignore.case=TRUE)]="40"
data.Export$SampleDepth[grep("45M",data$Station,ignore.case=TRUE)]="45"
#now do the sampe ting for SamplePosition using data$Station
#now do the same thing for SamplePosition using data$Station
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[grep("sfc",data$Station,ignore.case=TRUE)]="EPI" #for all "Station" observations that have "sfc"=surface, set SamplePosition to EPI
data.Export$SamplePosition[grep("surf",data$Station,ignore.case=TRUE)]="EPI"#for all "Station" observations that have "surf"=surface, set sampleposition to EPI
data.Export$SamplePosition[grep("surface",data$Station,ignore.case=TRUE)]="EPI" #for all "Station" observations that have "surface"=surface, set sampleposition to EPI
data.Export$SamplePosition[grep("bott",data$Station,ignore.case=TRUE)]="HYPO" #for all "Station" observations that have "bott"= bottom, set sampleposition to HYPO
data.Export$SamplePosition[grep("bot",data$Station,ignore.case=TRUE)]="HYPO" #for all "Station" observations that have "bot"= bottom, set sampleposition to HYPO
data.Export$SamplePosition[grep("bottom",data$Station,ignore.case=TRUE)]="HYPO"
data.Export$SamplePosition[grep("bottm",data$Station,ignore.case=TRUE)]="HYPO"
data.Export$SamplePosition[grep("(sfc)",data$Station,ignore.case=TRUE)]="EPI"
data.Export$SamplePosition[grep("-sfc",data$Station,ignore.case=TRUE)]="EPI"
data.Export$SamplePosition[grep("-bott",data$Station,ignore.case=TRUE)]="HYPO"
data.Export$SamplePosition[grep("(bott)",data$Station,ignore.case=TRUE)]="HYPO" 

#now dealing with observations that are null for both SamplePosition and SampleDepth
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SampleDepth[which(data.Export$SampleDepth=="")]=NA #make sure empty is specified as NA
data.Export$SamplePosition[which(data.Export$SamplePosition=="")]=NA #make sure empty is specified as NA
data.Export$SamplePosition=as.character(data.Export$SamplePosition) 
data.Export$SamplePosition[which(is.na(data.Export$SamplePosition)==TRUE & is.na(data.Export$SampleDepth)==FALSE)]="SPECIFIED" 
data.Export$SamplePosition[which(is.na(data.Export$SamplePosition)==TRUE & is.na(data.Export$SampleDepth)==TRUE)]="UNKNOWN" 
unique(data.Export$SamplePosition) 
#continue with populating other lagos variables
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType[grep("deep",data$Station,ignore.case=TRUE)]="PRIMARY" #for observations in "Station" that contain "deep" the deep whole was sampled= PRIMARY
data.Export$BasinType[which(is.na(data.Export$BasinType==TRUE))]= "UNKNOWN" #those for which "deep hole" or "deep" is not specified remain unknown
unique(data.Export$BasinType) #check to make sure proper values exported
data.Export$MethodInfo = NA 
data.Export$Subprogram=NA #sub program unknown
data.Export$LabMethodName=as.character(data.Export$LabMethodName)
data.Export$LabMethodName="EPA_353.2"
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)                     
data.Export$LabMethodInfo= "Automated cadmium reduction"             
data.Export$DetectionLimit=as.numeric(data.Export$DetectionLimit)
data.Export$DetectionLimit= (0.05*1000) #Dl= .05 mg/l per metadata, multiply by 1000 to get into prefered units of ug/l
data.Export$Comments=as.character(data.Export$Comments)
unique(data.Export$Value) #flag those chla obs > 5000 as suspicious
length(data.Export$Value[which(data.Export$Value==10000)])
data.Export$Comments[which(data.Export$Value==10000)]="Value is suspiciously high. Source data reported observation in units of mg/L, but it is suspected that the observation was actually reported in ug/L."
unique(data.Export$Comments)
NO2.Final = data.Export
rm(data.Export)
rm(data)


########################"Total Nitrogen (mg/L)"#######################################################################################
data=PA_DEP_CHEM
names(data) #looking at data, filter columns 
data = data[,c(1:3,5:6,12,19)] #pulling out columns of interest
head(data) #looking at data
data$Total.Nitrogen..mg.L.=as.character(data$Total.Nitrogen..mg.L.)
length(data$Total.Nitrogen..mg.L.[which(is.na(data$Total.Nitrogen..mg.L.==TRUE))]) #no values are NA
data$Total.Nitrogen..mg.L.[which(data$Total.Nitrogen..mg.L.=="")]=NA #set all null observations to NA
length(data$Total.Nitrogen..mg.L.[which(is.na(data$Total.Nitrogen..mg.L.==TRUE))]) #set blank observations to NA, 496 values are NA
4021-496 #3525 observations should be left after filtering out NA (next command)
data = data[which(is.na(data[,6])==FALSE),] #filter data to exclude NA observations
data = data[which(data$Sample.No!="Duplicate Surface"),]#want to exclude duplicates
data = data[which(data$Sample.No!="Duplicate Bottom"),]#want to exclude duplicates
unique(data$Total.Nitrogen..mg.L.) #no strange characters mixed in with TN observations
unique(data$Sample.No) #SampleNo contains info on depth and sample position, looking at info on unique values
unique(data$Station) #146 unique values describing the Station-which contains info on the sampling depth and sample position
data$Sample.No=as.character(data$Sample.No)
data$Sample.No[which(data$Sample.No=="0959*-106")]="99" #use 99 as a generic value to eliminate these observations (next two lines=same)
data$Sample.No[which(data$Sample.No=="x")]="99"
data$Sample.No[which(data$Sample.No=="833?")]="99"
data=data[which(data$Sample.No!="99"),] #filter these observations out as they are flagged to be duplicate

#### now filter out observations that have "dup" or "dupl" in the Station field as these are duplicate/replicate values
data$Station=as.character(data$Station)
data$Station[grep("dup",data$Station,ignore.case=TRUE)]="-9999" #works I checked the length of values of "-9999"
data$Station[grep("dupl",data$Station,ignore.case=TRUE)]="-9999"
data$Station[grep("average",data$Station,ignore.case=TRUE)]="-9999"
data$Station[grep("averages",data$Station,ignore.case=TRUE)]="-9999"
data$Station[grep("avg",data$Station,ignore.case=TRUE)]="-9999"
data=data[which(data$Station!="-9999"),] #remove those "dup" or duplicate observations

###no other data filtering, begin exporting to LAGOS
data.Export = LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$Lake.ID
data.Export$LakeName=data$Lake.Name
data.Export$SourceVariableName = "Total Nitrogen (mg/L)"
data.Export$SourceVariableDescription = as.character(data.Export$SourceVariableDescription)
data.Export$SourceVariableDescription = "Total nitrogen as N"
data.Export$LagosVariableID= 21
data.Export$LagosVariableName="Nitrogen, total"
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode="NC" #not censored in this case
data$Total.Nitrogen..mg.L.=as.numeric(data$Total.Nitrogen..mg.L.)
unique(data$Total.Nitrogen..mg.L.)
data.Export$Value = (data[,6])*1000 #export tn values, multiply by 1000 to go from mg/l to preferred units of ug/l
unique(data.Export$Value)
data.Export$SourceFlags= NA  #no source flags involved with these data (ONE "X" HERE, IGNORED)
data.Export$SampleType = as.character(data.Export$SampleType)
data.Export$SampleType[grep("integrated",data$Station,ignore.case=TRUE)]="INTEGRATED"
data.Export$SampleType[which(is.na(data.Export$SampleType==TRUE))]="GRAB"
unique(data.Export$SampleType) #just looking to see if the right values were exported.
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")])#ONLY 3 ARE INTEGRATED
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L" #preferred units
unique(data$Sample.No) #Sample.No contains info on the depth/position in some cases
unique(data$Station) #contains info on the depth/position sample was taken at
data$Station=as.character(data$Station) #set as character so it can be manipulated
data$Sample.No=as.character(data$Sample.No) #set as character so it can be manipulated
#now need to use "Sample.No" and "Station" to export info on depth and SamplePositionto LAGOS
#grep will be used to extract info found in "Sample.No" and "Station" and based on that info specify LAGOS "SampleDepth" and "SamplePosition"
data.Export$SampleDepth[which(data$Sample.No=="Sta.2-8.5M")] = "8.5" #specifying depth based on unique data$Sample.No
data.Export$SampleDepth[which(data$Sample.No=="Sta.2-13.5M")] = "13.5" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.2-4M")] = "4" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.3-1M ")] = "1" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.3-18.5M")] = "18.5" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.1-1M")] = "1"  
data.Export$SampleDepth[which(data$Sample.No=="Sta.2-4M")] = "4" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.1-5M")] = "5" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.3-3M")] = "3" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.3-2.5M ")] = "2.5" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.2-1M")] = "1"
data.Export$SampleDepth[which(data$Sample.No=="Sta.2-4.5M")] = "4.5"
data.Export$SampleDepth[which(data$Sample.No=="Sta.1-4M")] = "4"
data.Export$SampleDepth[which(data$Sample.No=="Sta.2-1M")] = "1"
data.Export$SampleDepth[which(data$Sample.No=="Sta.1-11M")] = "11"
data.Export$SampleDepth[which(data$Sample.No=="Sta.2-14.5M")] = "14.5"
data.Export$SampleDepth[which(data$Sample.No=="Sta.1-12M")] = "12"
data.Export$SampleDepth[which(data$Sample.No=="Sta.3-18.5M ")] = "18.5"
#now use grep to determine SampleType based on data$Sample.No values
#dam-sfc, dam-bot, dam sfc, Bottom/CHL A, Bottom/CHLA, surface, bottom- in Sample.No use grep to deduce SampleType
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[grep("sfc",data$Sample.No,ignore.case=TRUE)]="EPI"
data.Export$SamplePosition[grep("surface",data$Sample.No,ignore.case=TRUE)]="EPI"
data.Export$SamplePosition[grep("surf",data$Sample.No,ignore.case=TRUE)]="EPI"
data.Export$SamplePosition[grep("bott",data$Sample.No,ignore.case=TRUE)]="HYPO"
data.Export$SamplePosition[grep("bot",data$Sample.No,ignore.case=TRUE)]="HYPO"
data.Export$SamplePosition[grep("bottom",data$Sample.No,ignore.case=TRUE)]="HYPO"
#now look at data$Station and use grep to find the specified depth and export to LAGOS
data.Export$SampleDepth[grep(".1M",data$Station,ignore.case=TRUE)]=".1"
data.Export$SampleDepth[grep(".2M",data$Station,ignore.case=TRUE)]=".2"
data.Export$SampleDepth[grep(".3M",data$Station,ignore.case=TRUE)]=".3"
data.Export$SampleDepth[grep(".4M",data$Station,ignore.case=TRUE)]=".4"
data.Export$SampleDepth[grep(".5M",data$Station,ignore.case=TRUE)]=".5"
data.Export$SampleDepth[grep(".6M",data$Station,ignore.case=TRUE)]=".6"
data.Export$SampleDepth[grep(".7M",data$Station,ignore.case=TRUE)]=".7"
data.Export$SampleDepth[grep(".8M",data$Station,ignore.case=TRUE)]=".8"
data.Export$SampleDepth[grep(".9M",data$Station,ignore.case=TRUE)]=".9"
data.Export$SampleDepth[grep("1M",data$Station,ignore.case=TRUE)]="1"
data.Export$SampleDepth[grep("1.5M",data$Station,ignore.case=TRUE)]="1.5"
data.Export$SampleDepth[grep("2M",data$Station,ignore.case=TRUE)]="2"
data.Export$SampleDepth[grep("2.3M",data$Station,ignore.case=TRUE)]="2.3"
data.Export$SampleDepth[grep("2.5M",data$Station,ignore.case=TRUE)]="2.5"
data.Export$SampleDepth[grep("3M",data$Station,ignore.case=TRUE)]="3"
data.Export$SampleDepth[grep("3.5M",data$Station,ignore.case=TRUE)]="3.5"
data.Export$SampleDepth[grep("4M",data$Station,ignore.case=TRUE)]="4"
data.Export$SampleDepth[grep("4.5M",data$Station,ignore.case=TRUE)]="4.5"
data.Export$SampleDepth[grep("5M",data$Station,ignore.case=TRUE)]="5"
data.Export$SampleDepth[grep("5.5M",data$Station,ignore.case=TRUE)]="5.5"
data.Export$SampleDepth[grep("6M",data$Station,ignore.case=TRUE)]="6"
data.Export$SampleDepth[grep("6.5M",data$Station,ignore.case=TRUE)]="6.5"
data.Export$SampleDepth[grep("6.7M",data$Station,ignore.case=TRUE)]="6.7"
data.Export$SampleDepth[grep("7M",data$Station,ignore.case=TRUE)]="7"
data.Export$SampleDepth[grep("7.5M",data$Station,ignore.case=TRUE)]="7.5"
data.Export$SampleDepth[grep("8M",data$Station,ignore.case=TRUE)]="8"
data.Export$SampleDepth[grep("8.5M",data$Station,ignore.case=TRUE)]="8.5"
data.Export$SampleDepth[grep("9M",data$Station,ignore.case=TRUE)]="9"
data.Export$SampleDepth[grep("9.5M",data$Station,ignore.case=TRUE)]="9.5"
data.Export$SampleDepth[grep("10M",data$Station,ignore.case=TRUE)]="10"
data.Export$SampleDepth[grep("10.5M",data$Station,ignore.case=TRUE)]="10.5"
data.Export$SampleDepth[grep("11M",data$Station,ignore.case=TRUE)]="11"
data.Export$SampleDepth[grep("11.5M",data$Station,ignore.case=TRUE)]="11.5"
data.Export$SampleDepth[grep("12M",data$Station,ignore.case=TRUE)]="12"
data.Export$SampleDepth[grep("12.5M",data$Station,ignore.case=TRUE)]="12.5"
data.Export$SampleDepth[grep("13M",data$Station,ignore.case=TRUE)]="13"
data.Export$SampleDepth[grep("13.5M",data$Station,ignore.case=TRUE)]="13.5"
data.Export$SampleDepth[grep("14M",data$Station,ignore.case=TRUE)]="14"
data.Export$SampleDepth[grep("14.5M",data$Station,ignore.case=TRUE)]="14.5"
data.Export$SampleDepth[grep("15M",data$Station,ignore.case=TRUE)]="15"
data.Export$SampleDepth[grep("15.5M",data$Station,ignore.case=TRUE)]="15.5"
data.Export$SampleDepth[grep("16M",data$Station,ignore.case=TRUE)]="16"
data.Export$SampleDepth[grep("16.5M",data$Station,ignore.case=TRUE)]="16.5"
data.Export$SampleDepth[grep("17M",data$Station,ignore.case=TRUE)]="17"
data.Export$SampleDepth[grep("17.5M",data$Station,ignore.case=TRUE)]="17.5"
data.Export$SampleDepth[grep("18M",data$Station,ignore.case=TRUE)]="18"
data.Export$SampleDepth[grep("18.5M",data$Station,ignore.case=TRUE)]="18.5"
data.Export$SampleDepth[grep("19M",data$Station,ignore.case=TRUE)]="19"
data.Export$SampleDepth[grep("19.5M",data$Station,ignore.case=TRUE)]="19.5"
data.Export$SampleDepth[grep("20M",data$Station,ignore.case=TRUE)]="20"
data.Export$SampleDepth[grep("21M",data$Station,ignore.case=TRUE)]="21"
data.Export$SampleDepth[grep("22M",data$Station,ignore.case=TRUE)]="22"
data.Export$SampleDepth[grep("25M",data$Station,ignore.case=TRUE)]="25"
data.Export$SampleDepth[grep("27M",data$Station,ignore.case=TRUE)]="27"
data.Export$SampleDepth[grep("1-M",data$Station,ignore.case=TRUE)]="1"
data.Export$SampleDepth[grep("35M",data$Station,ignore.case=TRUE)]="35"
data.Export$SampleDepth[grep("40M",data$Station,ignore.case=TRUE)]="40"
data.Export$SampleDepth[grep("45M",data$Station,ignore.case=TRUE)]="45"
#now do the same thing for SamplePosition using data$Station
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[grep("sfc",data$Station,ignore.case=TRUE)]="EPI" #for all "Station" observations that have "sfc"=surface, set SamplePosition to EPI
data.Export$SamplePosition[grep("surf",data$Station,ignore.case=TRUE)]="EPI"#for all "Station" observations that have "surf"=surface, set sampleposition to EPI
data.Export$SamplePosition[grep("surface",data$Station,ignore.case=TRUE)]="EPI" #for all "Station" observations that have "surface"=surface, set sampleposition to EPI
data.Export$SamplePosition[grep("bott",data$Station,ignore.case=TRUE)]="HYPO" #for all "Station" observations that have "bott"= bottom, set sampleposition to HYPO
data.Export$SamplePosition[grep("bot",data$Station,ignore.case=TRUE)]="HYPO" #for all "Station" observations that have "bot"= bottom, set sampleposition to HYPO
data.Export$SamplePosition[grep("bottom",data$Station,ignore.case=TRUE)]="HYPO"
data.Export$SamplePosition[grep("bottm",data$Station,ignore.case=TRUE)]="HYPO"
data.Export$SamplePosition[grep("(sfc)",data$Station,ignore.case=TRUE)]="EPI"
data.Export$SamplePosition[grep("-sfc",data$Station,ignore.case=TRUE)]="EPI"
data.Export$SamplePosition[grep("-bott",data$Station,ignore.case=TRUE)]="HYPO"
data.Export$SamplePosition[grep("(bott)",data$Station,ignore.case=TRUE)]="HYPO" 

#now dealing with observations that are null for both SamplePosition and SampleDepth
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SampleDepth[which(data.Export$SampleDepth=="")]=NA #make sure empty is specified as NA
data.Export$SamplePosition[which(data.Export$SamplePosition=="")]=NA #make sure empty is specified as NA
data.Export$SamplePosition=as.character(data.Export$SamplePosition) 
data.Export$SamplePosition[which(is.na(data.Export$SamplePosition)==TRUE & is.na(data.Export$SampleDepth)==FALSE)]="SPECIFIED" 
data.Export$SamplePosition[which(is.na(data.Export$SamplePosition)==TRUE & is.na(data.Export$SampleDepth)==TRUE)]="UNKNOWN" 
unique(data.Export$SamplePosition) 

#continue with populating other lagos variables
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType[grep("deep",data$Station,ignore.case=TRUE)]="PRIMARY" #for observations in "Station" that contain "deep" the deep whole was sampled= PRIMARY
data.Export$BasinType[which(is.na(data.Export$BasinType==TRUE))]= "UNKNOWN" #those for which "deep hole" or "deep" is not specified remain unknown
unique(data.Export$BasinType) #check to make sure proper values exported
data.Export$MethodInfo = NA 
data.Export$Comments = NA # comments excluded because they are only relevant to the specific sample no. which is not specified in LAGOS
data.Export$Subprogram=NA #sub program unknown
data.Export$LabMethodName=as.character(data.Export$LabMethodName)
data.Export$LabMethodName="APHA_4500NC"
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)                     
data.Export$LabMethodInfo= "Semi-automated colorimetry with persulfate digestion"             
data.Export$DetectionLimit=as.numeric(data.Export$DetectionLimit)
data.Export$DetectionLimit= (0.25*1000) #Dl= .25 mg/l per metadata, multiply by 1000 to get into prefered units of ug/l
data.Export=data.Export[which(data.Export$SamplePosition!="null"),] #remove null
TN.Final = data.Export
rm(data.Export)
rm(data)


########################"Total Phos-phorus (mg/L)"#######################################################################################
data=PA_DEP_CHEM
names(data) #looking at data, filter columns 
data = data[,c(1:3,5:6,13,19)] #pulling out columns of interest
head(data) #looking at data
data$Total.Phos.phorus..mg.L.=as.character(data$Total.Phos.phorus..mg.L.)
length(data$Total.Phos.phorus..mg.L.[which(is.na(data$Total.Phos.phorus..mg.L.==TRUE))]) #1 value is NA
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="")]=NA #set all null observations to NA
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="*")]=NA 
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="x")]=NA 
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="1/0/1900")]=NA 
length(data$Total.Phos.phorus..mg.L.[which(is.na(data$Total.Phos.phorus..mg.L.==TRUE))]) #set blank observations to NA, 496 values are NA
data = data[which(is.na(data[,6])==FALSE),] #filter data to exclude NA observations
data = data[which(data$Sample.No!="Duplicate Surface"),]#want to exclude duplicates
data = data[which(data$Sample.No!="Duplicate Bottom"),]#want to exclude duplicates
unique(data$Total.Phos.phorus..mg.L.) #lots of strange characters included with the TP observations
data = data[which(data$Total.Phos.phorus..mg.L.!="none reported"),] #remove as these are null
data = data[which(data$Total.Phos.phorus..mg.L.!="canceled"),] #remove as these are null
data = data[which(data$Total.Phos.phorus..mg.L.!="missing"),] #remove as null
data = data[which(data$Total.Phos.phorus..mg.L.!="."),] #remove as this is null
data = data[which(data$Total.Phos.phorus..mg.L.!="canc"),]#null
data = data[which(data$Total.Phos.phorus..mg.L.!="not "),]#null
####these are data to be deleted, first set them equal to 99. then remove
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.53x")]="99"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.002x")]="99"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.128x")]="99"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.26x")]="99"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.52 x")]="99"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.249x")]="99"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.008x")]="99"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.153x")]="99"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.052*")]="99"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.055x")]="99"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.3014x")]="99"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.186x")]="99"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="1.052*")]="99"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.049x")]="99"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.096x")]="99"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.082x")]="99"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.07x")]="99"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.14x")]="99"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.152x")]="99"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.252x")]="99"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.094x")]="99"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.545x")]="99"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.13x")]="99"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.168*")]="99"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="1.333*")]="99"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.145x")]="99"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.159x")]="99"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.227x")]="99"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.038x")]="99"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.158x")]="99"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.181*")]="99"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.364x")]="99"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.72x")]="99"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.03x")]="99"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.56x")]="99"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.085x")]="99"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.171x")]="99"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.51x")]="99"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.574x")]="99"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.065x")]="99"
data$Sample.No=as.character(data$Sample.No) #set as character so it can be manipulated
data$Sample.No[which(data$Sample.No=="0959*-106")]="99" #also set these observations in Sample.No ="99" we want to remove them because they are flagged to be duplicates per metadata
data$Sample.No[which(data$Sample.No=="x")]="99"
data$Sample.No[which(data$Sample.No=="833?")]="99"
#station also contains "?" for observations which is a data flag for missing (possibly-see metadata) I am choosing to remove these observations
data$Station=as.character(data$Station)
data$Station[which(data$Station=="?")]="99"                                      
####now filter out observations of "99" for all three variables
data = data[which(data$Total.Phos.phorus..mg.L.!="99"),]
data= data[which(data$Sample.No!="99"),]
data= data[which(data$Station!="99"),]

#### now filter out observations that have "dup" "averages" "average" "avg" etc.. in the Station field as these are duplicate/replicate values
data$Station[grep("dup",data$Station,ignore.case=TRUE)]="-9999" #works I checked the length of values of "-9999"
data$Station[grep("dupl",data$Station,ignore.case=TRUE)]="-9999"
data$Station[grep("average",data$Station,ignore.case=TRUE)]="-9999"
data$Station[grep("averages",data$Station,ignore.case=TRUE)]="-9999"
data$Station[grep("avg",data$Station,ignore.case=TRUE)]="-9999"
data=data[which(data$Station!="-9999"),] #remove those "dup" or duplicate observations

unique(data$Total.Phos.phorus..mg.L.) #look at other unique TP values
#there are also lots of "<" signs to which a censor code of "LT" should be assigned.
unique(data$Sample.No) #SampleNo contains info on depth and sample position, looking at info on unique values
unique(data$Station) #146 unique values describing the Station-which contains info on the sampling depth and sample position

###no other data filtering, begin exporting to LAGOS
data.Export = LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$Lake.ID
data.Export$LakeName=data$Lake.Name
data.Export$SourceVariableName = "Total Phos-phorus (mg/L)"
data.Export$SourceVariableDescription = as.character(data.Export$SourceVariableDescription)
data.Export$SourceVariableDescription = "Total phosphorus as P"
data.Export$LagosVariableID= 27
data.Export$LagosVariableName="Phosphorus, total"
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode[which(data$Total.Phos.phorus..mg.L.=="<0.02")]="LT"
data.Export$CensorCode[which(data$Total.Phos.phorus..mg.L.=="<0.01")]="LT"
data.Export$CensorCode[which(data$Total.Phos.phorus..mg.L.=="<0.05")]="LT"
data.Export$CensorCode[which(data$Total.Phos.phorus..mg.L.=="<0.01*")]="LT"
data.Export$CensorCode[which(data$Total.Phos.phorus..mg.L.=="<0.012")]="LT"
data.Export$CensorCode[which(data$Total.Phos.phorus..mg.L.=="<.01check")]="LT"
data.Export$CensorCode[which(data$Total.Phos.phorus..mg.L.=="<.002")]="LT"
data.Export$CensorCode[which(data$Total.Phos.phorus..mg.L.=="<.01x")]="LT"
data.Export$CensorCode[which(data$Total.Phos.phorus..mg.L.=="<.01 (not fixed)")]="LT"
data.Export$CensorCode[which(data$Total.Phos.phorus..mg.L.=="<.01 get result")]="LT"
data.Export$CensorCode[which(data$Total.Phos.phorus..mg.L.=="<.010")]="LT"
data.Export$CensorCode[which(data$Total.Phos.phorus..mg.L.=="<.01 mg/l")]="LT"
data.Export$CensorCode[which(data$Total.Phos.phorus..mg.L.=="<.01")]="LT"
data.Export$CensorCode[which(is.na(data.Export$CensorCode==TRUE))]= "NC"
unique(data.Export$CensorCode) #check to make sure proper CensorCode types exported
#now overwrite data with "<" signs and deal with other special characters (ELIMINATE SPECIAL CHARACTERS)
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="<0.02")]="0.02"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="<0.01")]="0.01"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="<0.05")]="0.05"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="<0.01*")]="0.01"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="<0.012")]="0.012"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="<.01check")]="0.01"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="<.002")]="0.002"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="<.01x")]="0.01"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="<.01 (not fixed)")]="0.01"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="<.01 get result")]="0.01"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="<.010")]="0.010"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="<.01 mg/l")]="0.01"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="<.01")]="0.01"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.020 mg/l")]="0.020"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.027 mg/l")]="0.027"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.030 mg/l")]="0.030"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.267b")]="0.267"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.329b")]="0.329"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.010 mg/l")]="0.010"
unique(data$Total.Phos.phorus..mg.L.) #check to make sure all strange values gone/SPECIAL CHARACTERS GONE  
typeof(data$Total.Phos.phorus..mg.L.)
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.05x")]="0.05"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.193b")]="0.193"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.095b")]="0.095"
data$Total.Phos.phorus..mg.L.[which(data$Total.Phos.phorus..mg.L.=="0.15b")]="0.15"
#resume with populating other variables#
typeof(data$Total.Phos.phorus..mg.L.)
unique(data$Total.Phos.phorus..mg.L.)
data.Export$Value=as.numeric(data.Export$Value)
data$Total.Phos.phorus..mg.L.=as.numeric(data$Total.Phos.phorus..mg.L.)
length(data$Total.Phos.phorus..mg.L.[which(is.na(data$Total.Phos.phorus..mg.L.)==TRUE)])
data.Export$Value = data[,6]*1000 #export tp values, multiply by 1000 to go from mg/l to preferred units of ug/l
unique(data.Export$Value)
data.Export$SourceFlags= NA  #no source flags involved with these data (removed observations with "x" and "*" which were the only source flags)
data.Export$SampleType = as.character(data.Export$SampleType)
data.Export$SampleType[grep("integrated",data$Station,ignore.case=TRUE)]="INTEGRATED"
data.Export$SampleType[which(is.na(data.Export$SampleType==TRUE))]="GRAB"
unique(data.Export$SampleType) #just looking to see if the right values were exported.
length(data.Export$SampleType[which(data.Export$SampleType=="INTEGRATED")])#ONLY 3 ARE INTEGRATED
data.Export$Date = data$Date #date already in correct format
data.Export$Units="ug/L" #preferred units
unique(data$Sample.No) #Sample.No contains info on the depth/position in some cases
unique(data$Station) #contains info on the depth/position sample was taken at
data$Station=as.character(data$Station) #set as character so it can be manipulated
data$Sample.No=as.character(data$Sample.No) #set as character so it can be manipulated
#now need to use "Sample.No" and "Station" to export info on depth and SamplePositionto LAGOS
#grep will be used to extract info found in "Sample.No" and "Station" and based on that info specify LAGOS "SampleDepth" and "SamplePosition"
data.Export$SampleDepth[which(data$Sample.No=="Sta.1-11M")] = "11" #specifying depth based on unique data$Sample.No
data.Export$SampleDepth[which(data$Sample.No==" Sta.1-1M ")] = "1" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.2-14.5M")] = "14.5" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.1-12M")] = "12" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.3-18.5M")] = "18.5" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.2-1M")] = "1" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.2-8.5M")] = "8.5" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.2-13.5M")] = "13.5" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.3-1M")] = "1" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.3-19M")] = "19" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.2-4.5M")] = "4.5" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.2-4M")] = "4" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.3-2.5M")] = "2.5" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.3-3M")] = "3" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.1-5M")] = "5" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.2-1M")] = "1" 
data.Export$SampleDepth[which(data$Sample.No=="Sta.1-4M")] = "4" 

#now look at data$SampleNo. and uses phrases that indiciate sampleposition to determine sample position
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[grep("Surface",data$Sample.No,ignore.case=TRUE)]="EPI"
data.Export$SamplePosition[grep("sfc",data$Sample.No,ignore.case=TRUE)]="EPI"
data.Export$SamplePosition[grep("dam-sfc",data$Sample.No,ignore.case=TRUE)]="EPI"
data.Export$SamplePosition[grep("bottom",data$Sample.No,ignore.case=TRUE)]="HYPO"
data.Export$SamplePosition[grep("bott",data$Sample.No,ignore.case=TRUE)]="HYPO"
data.Export$SamplePosition[grep("bot",data$Sample.No,ignore.case=TRUE)]="HYPO"
data.Export$SamplePosition[grep("dam-bot",data$Sample.No,ignore.case=TRUE)]="HYPO"


#now look at data$Station and use grep to find the specified depth and export to LAGOS
data.Export$SampleDepth[grep(".1M",data$Station,ignore.case=TRUE)]=".1"
data.Export$SampleDepth[grep(".2M",data$Station,ignore.case=TRUE)]=".2"
data.Export$SampleDepth[grep(".3M",data$Station,ignore.case=TRUE)]=".3"
data.Export$SampleDepth[grep(".4M",data$Station,ignore.case=TRUE)]=".4"
data.Export$SampleDepth[grep(".5M",data$Station,ignore.case=TRUE)]=".5"
data.Export$SampleDepth[grep(".6M",data$Station,ignore.case=TRUE)]=".6"
data.Export$SampleDepth[grep(".7M",data$Station,ignore.case=TRUE)]=".7"
data.Export$SampleDepth[grep(".8M",data$Station,ignore.case=TRUE)]=".8"
data.Export$SampleDepth[grep(".9M",data$Station,ignore.case=TRUE)]=".9"
data.Export$SampleDepth[grep("1M",data$Station,ignore.case=TRUE)]="1"
data.Export$SampleDepth[grep("1.5M",data$Station,ignore.case=TRUE)]="1.5"
data.Export$SampleDepth[grep("2M",data$Station,ignore.case=TRUE)]="2"
data.Export$SampleDepth[grep("2.3M",data$Station,ignore.case=TRUE)]="2.3"
data.Export$SampleDepth[grep("2.5M",data$Station,ignore.case=TRUE)]="2.5"
data.Export$SampleDepth[grep("3M",data$Station,ignore.case=TRUE)]="3"
data.Export$SampleDepth[grep("3.5M",data$Station,ignore.case=TRUE)]="3.5"
data.Export$SampleDepth[grep("4M",data$Station,ignore.case=TRUE)]="4"
data.Export$SampleDepth[grep("4.5M",data$Station,ignore.case=TRUE)]="4.5"
data.Export$SampleDepth[grep("5M",data$Station,ignore.case=TRUE)]="5"
data.Export$SampleDepth[grep("5.5M",data$Station,ignore.case=TRUE)]="5.5"
data.Export$SampleDepth[grep("6M",data$Station,ignore.case=TRUE)]="6"
data.Export$SampleDepth[grep("6.5M",data$Station,ignore.case=TRUE)]="6.5"
data.Export$SampleDepth[grep("6.7M",data$Station,ignore.case=TRUE)]="6.7"
data.Export$SampleDepth[grep("7M",data$Station,ignore.case=TRUE)]="7"
data.Export$SampleDepth[grep("7.5M",data$Station,ignore.case=TRUE)]="7.5"
data.Export$SampleDepth[grep("8M",data$Station,ignore.case=TRUE)]="8"
data.Export$SampleDepth[grep("8.5M",data$Station,ignore.case=TRUE)]="8.5"
data.Export$SampleDepth[grep("9M",data$Station,ignore.case=TRUE)]="9"
data.Export$SampleDepth[grep("9.5M",data$Station,ignore.case=TRUE)]="9.5"
data.Export$SampleDepth[grep("10M",data$Station,ignore.case=TRUE)]="10"
data.Export$SampleDepth[grep("10.5M",data$Station,ignore.case=TRUE)]="10.5"
data.Export$SampleDepth[grep("11M",data$Station,ignore.case=TRUE)]="11"
data.Export$SampleDepth[grep("11.5M",data$Station,ignore.case=TRUE)]="11.5"
data.Export$SampleDepth[grep("12M",data$Station,ignore.case=TRUE)]="12"
data.Export$SampleDepth[grep("12.5M",data$Station,ignore.case=TRUE)]="12.5"
data.Export$SampleDepth[grep("13M",data$Station,ignore.case=TRUE)]="13"
data.Export$SampleDepth[grep("13.5M",data$Station,ignore.case=TRUE)]="13.5"
data.Export$SampleDepth[grep("14M",data$Station,ignore.case=TRUE)]="14"
data.Export$SampleDepth[grep("14.5M",data$Station,ignore.case=TRUE)]="14.5"
data.Export$SampleDepth[grep("15M",data$Station,ignore.case=TRUE)]="15"
data.Export$SampleDepth[grep("15.5M",data$Station,ignore.case=TRUE)]="15.5"
data.Export$SampleDepth[grep("16M",data$Station,ignore.case=TRUE)]="16"
data.Export$SampleDepth[grep("16.5M",data$Station,ignore.case=TRUE)]="16.5"
data.Export$SampleDepth[grep("17M",data$Station,ignore.case=TRUE)]="17"
data.Export$SampleDepth[grep("17.5M",data$Station,ignore.case=TRUE)]="17.5"
data.Export$SampleDepth[grep("18M",data$Station,ignore.case=TRUE)]="18"
data.Export$SampleDepth[grep("18.5M",data$Station,ignore.case=TRUE)]="18.5"
data.Export$SampleDepth[grep("19M",data$Station,ignore.case=TRUE)]="19"
data.Export$SampleDepth[grep("19.5M",data$Station,ignore.case=TRUE)]="19.5"
data.Export$SampleDepth[grep("20M",data$Station,ignore.case=TRUE)]="20"
data.Export$SampleDepth[grep("21M",data$Station,ignore.case=TRUE)]="21"
data.Export$SampleDepth[grep("22M",data$Station,ignore.case=TRUE)]="22"
data.Export$SampleDepth[grep("25M",data$Station,ignore.case=TRUE)]="25"
data.Export$SampleDepth[grep("27M",data$Station,ignore.case=TRUE)]="27"
data.Export$SampleDepth[grep("1-M",data$Station,ignore.case=TRUE)]="1"
data.Export$SampleDepth[grep("35M",data$Station,ignore.case=TRUE)]="35"
data.Export$SampleDepth[grep("40M",data$Station,ignore.case=TRUE)]="40"
data.Export$SampleDepth[grep("45M",data$Station,ignore.case=TRUE)]="45"
#now do the sampe ting for SamplePosition using data$Station
#purposely exclude observations with ? associated with them
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SamplePosition[grep("sfc",data$Station,ignore.case=TRUE)]="EPI" #for all "Station" observations that have "sfc"=surface, set SamplePosition to EPI
data.Export$SamplePosition[grep("surf",data$Station,ignore.case=TRUE)]="EPI"#for all "Station" observations that have "surf"=surface, set sampleposition to EPI
data.Export$SamplePosition[grep("surface",data$Station,ignore.case=TRUE)]="EPI" #for all "Station" observations that have "surface"=surface, set sampleposition to EPI
data.Export$SamplePosition[grep("bott",data$Station,ignore.case=TRUE)]="HYPO" #for all "Station" observations that have "bott"= bottom, set sampleposition to HYPO
data.Export$SamplePosition[grep("bot",data$Station,ignore.case=TRUE)]="HYPO" #for all "Station" observations that have "bot"= bottom, set sampleposition to HYPO
data.Export$SamplePosition[grep("bottom",data$Station,ignore.case=TRUE)]="HYPO"
data.Export$SamplePosition[grep("(sfc)",data$Station,ignore.case=TRUE)]="EPI"
data.Export$SamplePosition[grep("-sfc",data$Station,ignore.case=TRUE)]="EPI"
data.Export$SamplePosition[grep("-bott",data$Station,ignore.case=TRUE)]="HYPO"
data.Export$SamplePosition[grep("(bott)",data$Station,ignore.case=TRUE)]="HYPO"
data.Export$SamplePosition[grep("bottm",data$Station,ignore.case=TRUE)]="HYPO"

#now dealing with observations that are null for both SamplePosition and SampleDepth
data.Export$SamplePosition=as.character(data.Export$SamplePosition)
data.Export$SampleDepth[which(data.Export$SampleDepth=="")]=NA #make sure empty is specified as NA
data.Export$SamplePosition[which(data.Export$SamplePosition=="")]=NA #make sure empty is specified as NA
data.Export$SamplePosition=as.character(data.Export$SamplePosition) 
data.Export$SamplePosition[which(is.na(data.Export$SamplePosition)==TRUE & is.na(data.Export$SampleDepth)==FALSE)]="SPECIFIED" 
data.Export$SamplePosition[which(is.na(data.Export$SamplePosition)==TRUE & is.na(data.Export$SampleDepth)==TRUE)]="UNKNOWN" 
unique(data.Export$SamplePosition) 


#continue with populating other lagos variables
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType[grep("deep",data$Station,ignore.case=TRUE)]="PRIMARY" #for observations in "Station" that contain "deep" the deep whole was sampled= PRIMARY
data.Export$BasinType[which(is.na(data.Export$BasinType==TRUE))]= "UNKNOWN" #those for which "deep hole" or "deep" is not specified remain unknown
unique(data.Export$BasinType) #check to make sure proper values exported
data.Export$MethodInfo = NA 
data.Export$Comments=as.character(data.Export$Comments)
data.Export$Comments = NA # comments excluded because they are only relevant to the specific sample no. which is not specified in LAGOS
length(Final.Export$Value[which(Final.Export$Value>=5000)])
length(Final.Export$Value[which(Final.Export$Value>10000)])
#flag (by comment below) all observations that are greater than 5000 ug/L
data.Export$Comments[which(data.Export$Value>=5000)]="Value is suspiciously high. Source data reported observation in units of mg/L, but it is suspected that the observation was actually reported in ug/L."
length(data.Export$Comments[which(data.Export$Comments=="Value is suspiciously high. Source data reported observation in units of mg/L, but it is suspected that the observation was actually reported in ug/L.")])
data.Export$Subprogram=NA #sub program unknown
data.Export$LabMethodName=as.character(data.Export$LabMethodName)
data.Export$LabMethodName="EPA_365.1"
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)                     
data.Export$LabMethodInfo= "Automated colorimetry"             
data.Export$DetectionLimit=as.numeric(data.Export$DetectionLimit)
data.Export$DetectionLimit= (0.01*1000) #Dl= .01 mg/l per metadata, multiply by 1000 to get into prefered units of ug/l
TP.Final = data.Export
rm(data.Export)
rm(data)



########################"Secchi (m)"#######################################################################################
data=PA_DEP_CHEM
names(data) #looking at data, filter columns 
data = data[,c(1:3,5:6,7,19)] #pulling out columns of interest
head(data) #looking at data
data$Secchi..m.=as.character(data$Secchi..m.)
length(data$Secchi..m.[which(is.na(data$Secchi..m.==TRUE))]) #1949 values are NA
data$Secchi..m.[which(data$Secchi..m.=="")]=NA #set all null observations to NA
length(data$Secchi..m.[which(is.na(data$Secchi..m.==TRUE))]) #set blank observations to NA, still 1949 NA values
data = data[which(is.na(data[,6])==FALSE),] #filter data to exclude NA observations
4021-1949 #check to make sure that 2072 values remain

#exclude duplicates and null as found in data$Sample.No
data = data[which(data$Sample.No!="Duplicate Surface"),]#want to exclude duplicates
data = data[which(data$Sample.No!="Duplicate Bottom"),]#want to exclude duplicates
data = data[which(data$Sample.No!="no samples"),]#want to exclude duplicates

#station also contains "x" and "*" which represent duplicates & "?" for observations which is a data flag for missing (possibly-see metadata) I am choosing to remove these observations
data$Station=as.character(data$Station)
data$Station[which(data$Station=="?")]="99"                                      
data$Station[which(data$Station=="x")]="99"  
data$Station[which(data$Station=="*")]="99"  

####now filter out observations of "99" for all three variables
data= data[which(data$Station!="99"),]

#### now filter out observations that have "dup" "averages" "average" "avg" etc.. in the Station field as these are duplicate/replicate values
data$Station[grep("dup",data$Station,ignore.case=TRUE)]="-9999" #works I checked the length of values of "-9999"
data$Station[grep("dupl",data$Station,ignore.case=TRUE)]="-9999"
data$Station[grep("average",data$Station,ignore.case=TRUE)]="-9999"
data$Station[grep("averages",data$Station,ignore.case=TRUE)]="-9999"
data$Station[grep("avg",data$Station,ignore.case=TRUE)]="-9999"
data=data[which(data$Station!="-9999"),] #remove those "dup" or duplicate observations

###no other data filtering, begin exporting to LAGOS
data.Export = LAGOS_Template
data.Export[1:nrow(data),]=NA
data.Export$LakeID = data$Lake.ID
data.Export$LakeName=data$Lake.Name
data.Export$SourceVariableName = "Secchi (m)"
data.Export$SourceVariableDescription = as.character(data.Export$SourceVariableDescription)
data.Export$SourceVariableDescription = "Secchi depth"
data.Export$LagosVariableID= 30
data.Export$LagosVariableName="Secchi"
data.Export$CensorCode=as.character(data.Export$CensorCode)
data.Export$CensorCode= "NC"
unique(data.Export$CensorCode) #check to make sure proper CensorCode types exported
typeof(data$Secchi..m.)
unique(data$Secchi..m.)
data.Export$Value=as.numeric(data.Export$Value)
data$Secchi..m.=as.numeric(data$Secchi..m.)
data.Export$Value = data[,6] #export secchi values already in preferred units of "m"
unique(data.Export$Value)
data.Export$SourceFlags= NA  #no sourcee flags involved with these data (removed observations with "x" and "*" which were the only source flags)
data.Export$SampleType = as.character(data.Export$SampleType)
data.Export$SampleType="INTEGRATED"
unique(data.Export$SampleType) #just looking to see if the right values were exported.
data.Export$Date = data$Date #date already in correct format
data.Export$Units="m" #preferred units
unique(data$Sample.No) #Sample.No contains info on the depth/position in some cases
unique(data$Station) #contains info on the depth/position sample was taken at
data$Station=as.character(data$Station) #set as character so it can be manipulated
data$Sample.No=as.character(data$Sample.No) #set as character so it can be manipulated
#now need to use "Sample.No" and "Station" to export info on depth and SamplePositionto LAGOS
data.Export$SampleDepth= NA #sample depth not relevant to secchi
data.Export$SamplePosition="SPECIFIED" #specified by the secchi depth measurement
data.Export$BasinType=as.character(data.Export$BasinType)
data.Export$BasinType[grep("deep",data$Station,ignore.case=TRUE)]="PRIMARY" #for observations in "Station" that contain "deep" the deep whole was sampled= PRIMARY
data.Export$BasinType[which(is.na(data.Export$BasinType==TRUE))]= "UNKNOWN" #those for which "deep hole" or "deep" is not specified remain unknown
unique(data.Export$BasinType) #check to make sure proper values exported
data.Export$MethodInfo=as.character(data.Export$MethodInfo)
data.Export$MethodInfo = "SECCHI_VIEW_UNKNOWN"
data.Export$Comments = NA # comments excluded because they are only relevant to the specific sample no. which is not specified in LAGOS
data.Export$Subprogram=NA #sub program unknown
data.Export$LabMethodName=as.character(data.Export$LabMethodName)
data.Export$LabMethodName=NA 
data.Export$LabMethodInfo=as.character(data.Export$LabMethodInfo)                     
data.Export$LabMethodInfo= NA           
data.Export$DetectionLimit= NA #dl not applicable to secchi
Secchi.Final = data.Export
rm(data.Export)
rm(data)

###################################### final export ########################################################################################
Final.Export = rbind(Chla.Final,NH4.Final,NO2.Final,NO3.Final,TN.Final,TOC.Final,TP.Final,Secchi.Final)

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
11313+1607#adds up to total

### final-final.export : ) ##########################################
Final.Export1=data1
typeof(Final.Export1$Value)
length(Final.Export1$Value[which(Final.Export1$Value<0)])
unique(Final.Export1$SamplePosition)
write.table(Final.Export1,file="DataImport_PA_DEP_CHEM.csv",row.names=FALSE,sep=",")
hist(log(TP.Final$Value))
save.image("C:/Users/schristel/Dropbox/CSI-LIMNO_DATA/DATA-lake/PA data/PA_DEP_LAKE_DATA/DataImport_PA_DEP_CHEM/DataImport_PA_DEP_CHEM.RData")
save.image("C:/Users/Sam/Dropbox/CSI-LIMNO_DATA/DATA-lake/PA data/PA_DEP_LAKE_DATA/DataImport_PA_DEP_CHEM/DataImport_PA_DEP_CHEM.RData")
###quality control test ##############
unique(Final.Export1$SamplePosition)
length(Final.Export1$SamplePosition[which(Final.Export1$SamplePosition=="UNKNOWN")])
length(Final.Export1$SamplePosition[which(Final.Export1$SamplePosition=="UNKNOWN" & is.na(Final.Export1$SampleDepth)==TRUE)])