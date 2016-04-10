#Download file from specified URL
fileURL<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
localFileName<-"./exdata-data-NEI_data.zip"
# Check if does not exists, download the file
if (file.exists(localFileName) == FALSE) {
  download.file(fileURL, destfile = localFileName)
}

# Variable for uncompressed folder name
dataFileDir<-"./summarySCC_PM25.rds"
# Uncompress the zip file
if (file.exists(dataFileDir) == FALSE) {
  unzip(localFileName)
}

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Aggregate emissions by year
aggUSByYear <- aggregate(Emissions ~ year, NEI, sum) 

#draw line plot
#plot(aggUSByYear, type = "b", pch = 25, col = "blue", ylab = "Emissions", xlab = "Year", main = "Annual Emissions") 

#Create barplot on device
png('plot1.png',width=480,height=480) 
barplot(height=aggUSByYear$Emissions, names.arg=aggUSByYear$year, xlab="Years", ylab="Total PM2.5 emissions (Tons)",main="Total PM2.5 emissions for United States") 
#Close the device
dev.off() 
  
