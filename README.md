---
title: "Readme.md"
output: github_document
---

Fine particulate matter (PM2.5) is an ambient air pollutant for which there is strong evidence that it is harmful to human health. In the United States, the Environmental Protection Agency (EPA) is tasked with setting national ambient air quality standards for fine PM and for tracking the emissions of this pollutant into the atmosphere. Approximatly every 3 years, the EPA releases its database on emissions of PM2.5. This database is known as the National Emissions Inventory (NEI). You can read more information about the NEI at the EPA National Emissions Inventory web site.

For each year and for each type of PM source, the NEI records how many tons of PM2.5 were emitted from that source over the course of the entire year. The data used for this assignment are for 1999, 2002, 2005, and 2008.

##Assignment

The overall goal of this assignment is to explore the National Emissions Inventory database and see what it say about fine particulate matter pollution in the United states over the 10-year period 1999-2008. 

##Questions

Following questions are addressed in this exploratory analysis.

1. Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
2  Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008? 
3.  Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999-2008 for Baltimore City? Which have seen increases in emissions from 1999-2008? 
4.  Across the United States, how have emissions from coal combustion-related sources changed from 1999-2008?
5.  How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?
6.  Emissions from motor vehicle sources in Baltimore City are compared with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"). 
