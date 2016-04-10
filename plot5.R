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
subsetNEI <- NEI[NEI$fips=="24510" & NEI$type=="ON-ROAD", ]
aggMotorVehicleByYear <- aggregate(Emissions ~ year, subsetNEI, sum)

#Create the plot on the device
png("plot5.png", width=680, height=480) 
barplot(height=aggMotorVehicleByYear$Emissions, names.arg=aggMotorVehicleByYear$year, xlab="Years", ylab="Total PM2.5 emissions (Tons)",main="Total PM2.5 emissions from Motor Vehicle sources for Baltimore") 
#Close the device
dev.off() 

##--------------------
classification = data.table(SCC) 
data = data.table(NEI) 


#Create Graph

baltimore4 <- data[(data$fips=="24510"), ] 
baltimore4 <- aggregate(Emissions ~ year, data = baltimore4, FUN = sum) 
losangeles <- data[(data$fips=="06037"),] 
losangeles <- aggregate(Emissions ~ year, data = losangeles, FUN = sum) 
baltimore4$County <- "Baltimore" 
losangeles$County <- "Los Angeles" 
bothcities <- rbind(baltimore4, losangeles) 


fmt <- function(){ 
  f <- function(x) as.character(round(x,2)) 
  f 
} 
ggplot(bothcities, aes(x=factor(year), y=Emissions, fill=County)) + 
  geom_bar(aes(fill = County), position = "dodge", stat="identity") + 
  labs(x = "Year") + labs(y = expression("Total Emissions (in log scale) of PM"[2.5])) + 
  xlab("year") + 
  ggtitle(expression("Motor vehicle emission in Baltimore and Los Angeles")) + 
  scale_y_continuous(trans = log_trans(), labels = fmt()) 