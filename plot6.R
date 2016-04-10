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

#Since filtering on "motor vehicle" string on column Short Name retrieves only Non-Point sources, Subset Emissions
#data using type value of 'ON-ROAD' to retrieve emissions from motor vehicle sources.
subsetNEI_Baltimore_LA <- NEI[(NEI$fips=="24510" | NEI$fips=="06037") & NEI$type=="ON-ROAD", ]
aggBaltimoreLAByYear <- aggregate(Emissions ~ year + fips, subsetNEI_Baltimore_LA, sum)

##Replace flips by city names
aggBaltimoreLAByYear$fips[aggBaltimoreLAByYear$fips=="24510"] <- "Baltimore, MD" 
aggBaltimoreLAByYear$fips[aggBaltimoreLAByYear$fips=="06037"] <- "Los Angeles, CA" 

#Create the plot on the device
png("plot6.png", width=680, height=480) 

g <- ggplot(aggBaltimoreLAByYear, aes(factor(year), Emissions)) 
g <- g + facet_grid(. ~ fips) 
g <- g + geom_bar(stat="identity")  + 
xlab("Years") + 
ylab("Total PM2.5 Emissions (Tons)") + 
ggtitle("Total Emissions from motor vehicle sources in Baltimore City, MD vs Los Angeles, CA") 
print(g) 

#Close the device
dev.off() 