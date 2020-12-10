# fix the time problem with these data

library(dplyr)
library(tidyr)
library(stringr)
library(lubridate)

df <- read.csv('micro-macro-contrast.csv', header = T, as.is = T)
df[(df$month == 6 & df$day == 31) , "month"] <- 5

df$sampledate <- as.Date(paste(as.character(df$month),"/",as.character(df$day), "/", as.character(df$year), sep = ''), format = "%m/%d/%Y")

first_date <- df$sampledate[1]
location <- str_locate(df$hour[1], ":") -1
count <- as.integer(str_sub(df$hour[1], 1, location[1]))

for (i in 1:nrow(df)) {
  
  second_date <- df$sampledate[i]
  location <- str_locate(df$hour[i], ":") -1
  hour <- as.integer(str_sub(df$hour[i], 1, location[1]))
  if (hour < 10){
    df$hour[i] <- paste("0", df$hour[i], sep = '')
  }
  if (first_date == second_date && count < 12){
    df$X[i] <- "AM"
  }
  else if (first_date == second_date && count > 11){
    df$X[i] <- "PM"
  }
  if (first_date < second_date && hour == 12){
    count <- 0
    df$X[i] <- "AM"
  }
  else if (first_date > second_date) { 
    count <- hour - 1
    df$X[i] <- "AM"
  }
  
  if (second_date == "2019-05-18") {
    df$X[i] <- "PM"
  }
  #print(paste("last date: ", first_date, "this date: ", second_date, "hour: ", hour, "count: ", count, 'am/pm: ', df$X[i]))
  print(df$recordID[i])
  
  first_date <- df$sampledate[i]
  count <- count + 1
}

df$real_time_string <- paste(as.character(df$sampledate), str_sub(df$hour,1,-4), df$X)
df$real_time <- as.POSIXct(df$real_time_string, format = "%Y-%m-%d %I:%M:%S %p")


write.csv(df, file = 'corrected.csv', row.names = F)

