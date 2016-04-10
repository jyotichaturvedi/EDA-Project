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
#head(baltimoreNEI)
#Aggregate Baltimore city emissions data using sum by year and type columns
aggBaltimoreByYearAndType <- aggregate(Emissions ~ year + type, baltimoreNEI, sum) 

#Use the library for the plot
library(ggplot2)

#Create the plot on the device
png("plot3.png", width=480, height=480) 
g <- ggplot(aggBaltimoreByYearAndType, aes(year, Emissions, color = type)) 
g <- g + geom_line() + 
xlab("Years") + 
ylab("Total PM2.5 Emissions (Tons)") + 
ggtitle('Total PM2.5 Emissions for Baltimore City') 
print(g) 
#Close the device
dev.off() 

#-------------------------------------------------------
library(plyr) 
library(ggplot2) 
library(data.table) 
library(grid) 
library(scales) 
library(httr)  

classification = data.table(SCC) 
data = data.table(NEI) 
baltimore <- data[which(data$fips == "24510"), ] 
baltimore3 <- ddply(baltimore, .(type, year), summarize, Emissions = sum(Emissions)) 


qplot(year, Emissions, data = baltimore3, group = type,  
      color = type, geom = c("point", "line"), ylab = expression("Total Emissions of PM"[2.5]),  
      xlab = "Year", main = "Total Emissions in Baltimore. by Type of Pollutant") 
#==============================
ggp <- ggplot(baltimoreNEI,aes(factor(year),Emissions,fill=type)) +
  geom_bar(stat="identity") +
  theme_bw() + guides(fill=FALSE)+
  facet_grid(.~type,scales = "free",space="free") + 
  labs(x="year", y=expression("Total PM"[2.5]*" Emission (Tons)")) + 
  labs(title=expression("PM"[2.5]*" Emissions, Baltimore City 1999-2008 by Source Type"))

print(ggp)
