#!/usr/bin/env Rscript

require(lubridate)

# This script needs to be in the same folder as the unzipped dataset
power_rawdata <- read.table("./household_power_consumption.txt", header = TRUE, sep=';', colClasses = 'character', na.strings='?')

# create a boolean vector for filtering
dates <- dmy(power_rawdata[,1])
dates_ofinterest <- ymd(c('2007-02-01', '2007-02-02'))
dates_boolean <- is.element(dates, dates_ofinterest)

# filter out unneeded rows
powercons_data <- power_rawdata[dates_boolean,]
powercons_data[,1] <- dmy(powercons_data[,1])

# add a datetime column
powercons_data$datetime <- ymd_hms( paste(powercons_data$Date,powercons_data$Time) )

# Convert data columns to numeric
for (col in 3:9) {
	powercons_data[,col] <- as.numeric(powercons_data[,col])
}

# open a graphics device
png(file = "plot2.png", width=480, height=480) 

# Initial Plot, with black line graph
plot(powercons_data$Global_active_power ~ powercons_data$datetime, 
     ylab='Global Active Power (kilowatts)', 
     xlab='',
     type='l'
     )

dev.off() ## Close the png device
