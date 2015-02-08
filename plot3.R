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
png(file = "plot3.png", width=480, height=480) 

# Initial Plot, with black line graph
plot(powercons_data$Sub_metering_1 ~ powercons_data$datetime, 
     ylab='Energy sub metering', 
     xlab='',
     type='l'
     )
# Add Additional lines to the graph, red and blue respectively
lines(powercons_data$Sub_metering_2 ~ powercons_data$datetime, col='red')
lines(powercons_data$Sub_metering_3 ~ powercons_data$datetime, col='blue')

# add legend for each line on the top right
legend("topright", lty='solid', col = c('black','red','blue'), legend = c('Sub_metering_1','Sub_metering_2','Sub_metering_3'))

dev.off() ## Close the png device
