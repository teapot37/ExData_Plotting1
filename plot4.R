  ## make sure we have the library we need to use the read.csv.sql function
  library("sqldf")

  ## if the dataset doesn't exist locally, download and unzip it; otherwise, use local copy
    if(!file.exists("./household_power_consumption.txt")){
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", "./power.zip")
    closeAllConnections()
    unzip("./power.zip")
  }
  
  ## read in the dataset
  data <- read.csv.sql("household_power_consumption.txt", 
                       sql = "select * from file where Date in ('1/2/2007', '2/2/2007')", 
                       sep=";", 
                       header=TRUE)
  closeAllConnections()

  ## put date and time columns into a shared DateTime column as datetime objects
  data$DateTime <- paste(data$Date, data$Time)
  data$DateTime <- strptime(data$DateTime, "%d/%m/%Y %H:%M:%S")
  
  ## set the output file and format
  png("plot4.png", width=480, height=480)
  ## set the plot display as 2x2
  par(mfrow=c(2,2))
  ## plot 1
  with(iris2, plot(DateTime, Global_active_power, type="l", ylab="Global Active Power", xlab=""))
  ## plot 2
  with(iris2, plot(DateTime, Voltage, type="l", xlab="datetime"))
  ## plot 3
  with(data, plot(DateTime, Sub_metering_1, type = "n", 
                  ylab="Energy sub metering", xlab=""))
  with(data, lines(DateTime, Sub_metering_1, col = "black"))
  with(data, lines(DateTime, Sub_metering_2, col = "red"))
  with(data, lines(DateTime, Sub_metering_3, col = "blue"))
  legend("topright", col=c("black", "red", "blue"), 
         legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
         lwd=1, bty="n", cex=0.75)
  ## plot 4
  with(iris2, plot(DateTime, Global_reactive_power, type="l", xlab="datetime"))
  
  ## close the output device
  dev.off()