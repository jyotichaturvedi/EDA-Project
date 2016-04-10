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

#Search by comb in Short Name column
SCC_combustion <- grepl("comb", SCC$Short.Name, ignore.case=TRUE) 

#Search by coal in Short Name column
SCC_coal <- grepl("coal", SCC$Short.Name, ignore.case=TRUE)  

#Combine both searches
coal_combustion <- (SCC_combustion & SCC_coal) 

#Subset and filter Source dataset (SCC) to have only coal & combustion rows and SCC column
SCC_coal_combustion <- SCC[coal_combustion,]$SCC 

#Filter Emission dataset (NEI) to have rows that have SCC code for coal & combustion 
NEI_coal_combustion <- NEI[NEI$SCC %in% SCC_coal_combustion,] 

#Aggregate coal combustion emissions data using sum by year 
aggUSCoalCombByYear <- aggregate(Emissions ~ year, NEI_coal_combustion, sum) 

#Create the plot on the device
png("plot4.png", width=680, height=480) 
barplot(height=aggUSCoalCombByYear$Emissions, names.arg=aggUSCoalCombByYear$year, xlab="Years", ylab="Total PM2.5 emissions (Tons)",main="Total PM2.5 emissions from coal combustion-related sources for United States") 
#Close the device
dev.off() 
#====================
coal <- SCC[grepl("coal", SCC$Short.Name, ignore.case = TRUE), ]
NEIcoal <- NEI[NEI$SCC %in% coal$SCC, ]

ytitle <- expression("PM"[2.5] * " emission")
maintitle <- expression ("coal total PM"[2.5]* " emissions")



plot4 <- ggplot(NEIcoal, aes(factor(year), Emissions, fill = type))
plot4 <- plot4 + geom_bar(stat = "identity") + xlab("year") + ylab(ytitle) + ggtitle(maintitle)
print(plot4)

#++++++++++++++++++++
Plot6Subset <- NEI[(NEI$fips == "24510" | NEI$fips == "06037") & NEI$type == "ON-ROAD", ]

Plot6Totals <- aggregate(Emissions ~ year + fips, Plot6Subset, sum)
Plot6Totals$location <- ifelse(Plot6Totals$fips == 24510, "Baltimore City", "LA County")
#_____===================
shortnames <- as.character(SCC$Short.Name) # 11717
newindex <- grep("coal.*combustion", shortnames, ignore.case = TRUE)
sccindex <- SCC[newindex[1], c(1, 3)]
for (i in 2:length(newindex)){
  sccindex <<- rbind(sccindex, SCC[newindex[i], c(1, 3)])
}

coalcombustion.nei <- subset(NEI, SCC %in% sccindex[, 1]) # 206*6
result <- with(coalcombustion.nei, tapply(Emissions, year, sum, na.rm = TRUE))
result
plot(row.names(result), result, type = "b", col = "red",
     xlab = "year",
     ylab = "coal combustion-related PM2.5 emission (tons)",
     main = "Coal Combustion-related PM2.5 Emission in US (1999~2008)")
