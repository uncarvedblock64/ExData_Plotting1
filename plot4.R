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
png(file = "plot4.png", width=480, height=480) 

par(mfrow = c(2,2))
with(powercons_data, {
     plot(Global_active_power ~ datetime, ylab='Global Active Power', xlab='', type='l')
     plot(Voltage ~ datetime, ylab='Voltage', xlab='datetime', type='l')
     plot(Sub_metering_1 ~ datetime, ylab='Energy sub metering', xlab='', type='l')
     	lines(Sub_metering_2 ~ datetime, col='red')
     	lines(Sub_metering_3 ~ datetime, col='blue')
	# add legend for each line on the top right
	legend("topright", lty='solid', box.lty=0, col = c('black','red','blue'), legend = c('Sub_metering_1','Sub_metering_2','Sub_metering_3'))
     plot(Global_reactive_power ~ datetime, ylab='Global_reative_power', xlab='datetime', type='l')
})
