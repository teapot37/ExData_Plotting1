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
  png("plot2.png", width=480, height=480)

  ## create the plot  
  plot(data$DateTime, data$Global_active_power, type="l", 
       main="", xlab="", ylab="Global Active Power (kilowatts)")

  ## close the output device
  dev.off()