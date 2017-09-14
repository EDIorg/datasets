
setwd("./ecocomDP/")




infile1  <- "https://pasta.lternet.edu/package/data/eml/knb-lter-mcr/6/55/ac2c7a859ce8595ec1339e8530b9ba50" 
infile1 <- sub("^https","http",infile1) 
dt1 <-read.csv(infile1, header=T, sep=",", as.is = T)
write.csv(dt1, file = "./data/knb-lter-mcr.6.55.csv", row.names = F)
# attempting to convert dt1$Date dateTime string to R date structure (date or POSIXct)                                
tmpDateFormat<-"%Y-%m-%d"
dt1$Date<-as.Date(dt1$Date,format=tmpDateFormat)
