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

#Subset NEI data for Baltimore City, Maryland (fips == "24510") . 
baltimoreNEI <- NEI[NEI$fips=="24510",] 

#Aggregate Baltimore city emissions data using sum by year 
aggBaltimoreByYear <- aggregate(Emissions ~ year, baltimoreNEI,sum) 

#Create the plot on the device
png("plot2.png",width=480,height=480) 
barplot(aggBaltimoreByYear$Emissions,names.arg=aggBaltimoreByYear$year, xlab="Years", ylab="PM2.5 Emissions (Tons)", 
main="Total PM2.5 Emissions for Baltimore City" 
) 
#Close the device
dev.off() 



##Create line plot

#plot(aggBaltimoreByYear$year, aggBaltimoreByYear$Emissions, type = "b", pch = 25, col = "red",  
 #    ylab = "Emissions", xlab = "Year", main = "Baltimore Emissions") 
