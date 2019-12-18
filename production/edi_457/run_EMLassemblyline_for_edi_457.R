# This script executes an EMLassemblyline workflow.

# Staging identifier = edi.328
# Production identifier = edi.457

# Initialize workspace --------------------------------------------------------

library(EMLassemblyline)

setwd("/Users/csmith/Documents/EDI/datasets/edi_457")

# Create metadta templates ----------------------------------------------------

EMLassemblyline::template_core_metadata(
  path = "./metadata_templates",
  license = "CCBY", 
  file.type = ".docx"
)

EMLassemblyline::template_table_attributes(
  path = "./metadata_templates",
  data.path = "./data_objects",
  data.table = c(
    "dailyflux_CenterChannel.csv",
    "dailyflux_WestChannel.csv",
    "dailyflux_WestWetland.csv",
    "PZ-CC_161005_Calib20161001_1300_TotHead.csv",
    "PZ-CW_161005_Calib20161001_1400_TotHead.csv",
    "PZ-In_161005_Calib20160531_0900_TotHead.csv",
    "SG-1_1st_Position_161005_Calib20160531_0945_TotHead.csv",
    "SG-1_2nd_Position_161005_Calib20161001_1430_TotHead.csv",
    "SCAllData2016.csv",
    "TPA.csv",
    "TPB.csv",
    "TPC.csv"
  )
)

EMLassemblyline::template_categorical_variables(
  path = "./metadata_templates",
  data.path = "./data_objects"
)

# Convert templates to EML ----------------------------------------------------

EMLassemblyline::make_eml(
  path = "./metadata_templates", 
  data.path = "./data_objects",
  eml.path = "./eml",
  dataset.title = "Summer 2016 hydrology and water chemistry data at Second Creek, a sulfate-impacted riparian wetland in northeast Minnesota", 
  temporal.coverage = c("2016-05-31", "2016-10-02"), 
  geographic.description = "Second Creek, riparian wetland near Aurora, MN",
  geographic.coordinates = c("47.520509", "-92.192352", "47.520351", "-92.192634"), 
  maintenance.description = "Completed", 
  data.table = c(
    "dailyflux_CenterChannel.csv",
    "dailyflux_WestChannel.csv",
    "dailyflux_WestWetland.csv",
    "PZ-CC_161005_Calib20161001_1300_TotHead.csv",
    "PZ-CW_161005_Calib20161001_1400_TotHead.csv",
    "PZ-In_161005_Calib20160531_0900_TotHead.csv",
    "SG-1_1st_Position_161005_Calib20160531_0945_TotHead.csv",
    "SG-1_2nd_Position_161005_Calib20161001_1430_TotHead.csv",
    "SCAllData2016.csv",
    "TPA.csv",
    "TPB.csv",
    "TPC.csv"
  ),
  data.table.description = c(
    "Daily water flux time series at the center of the stream channel, determined via inverse modeling of vertical temperature profile time series and hydraulic gradient between surface water and groundwater.",
    "Daily water flux time series about 3 m west of channel center, determined via inverse modeling of vertical temperature profile time series and hydraulic gradient between surface water and groundwater.",
    "Daily water flux time series in west-flanking wetland of the stream channel, determined via inverse modeling of vertical temperature profile time series and hydraulic gradient between surface water and groundwater.",
    "Groundwater head time series measured below the center of the stream channel.",
    "Groundwater head time series measured below the west-flanking wetland of the stream channel.",
    "Groundwater head time series measured below the channel about 3 m west of the center of the channel.",
    "Surface water head time series measured by the stream gauge installed over the first part of summer 2016.",
    "Surface water head time series measured by the stream gauge after it was moved for the second part of summer 2016, in order to avoid dry (no surface water) conditions.",
    "Water chemistry data from surface water and porewater samples collected by 'peepers' (passive diffusive samplers) in the center channel and west-flanking wetland locations.",
    "Vertical temperature profile time series measured in the streambed about 3 m west of the channel center.",
    "Vertical temperature profile time series measured in the streambed at the center of the stream channel.",
    "Vertical temperature profile time series measured in the wetland sediments in the west-flanking wetland of the stream channel."
  ), 
  user.id = "csmith", 
  user.domain = "LTER", 
  package.id = "edi.457.1"
)







