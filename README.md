# JHU Exploratory Data Analysis Course Week 4 Project 2

Fine particulate matter (PM2.5) is an ambient air pollutant for which there is strong evidence that 
it is harmful to human health. In the United States, the Environmental Protection Agency (EPA) is 
tasked with setting national ambient air quality standards for fine PM and for tracking the 
emissions of this pollutant into the atmosphere. Approximatly every 3 years, the EPA releases its 
database on emissions of PM2.5. This database is known as the National Emissions Inventory (NEI). 

For each year and for each type of PM source, the NEI records how many tons of PM2.5 were emitted 
from that source over the course of the entire year. The data that I will use for this assignment 
are for 1999, 2002, 2005, and 2008.


# Data
The data for this assignment is available from the course web site as a single zip file:

[Data for Peer Assessment](https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip) [29Mb]


# Questions
I must address the following questions:

__1.__ Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
Using the base plotting system, make a plot showing the total PM2.5 emission from 
all sources for each of the years 1999, 2002, 2005, and 2008.

__2.__ Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") 
from 1999 to 2008? Use the base plotting system to make a plot answering this question.

__3.__ Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, 
which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? 
Which have seen increases in emissions from 1999–2008? 
Use the ggplot2 plotting system to make a plot answer this question.

__4.__ Across the United States, how have emissions from coal combustion-related sources changed 
from 1999–2008?

__5.__ How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

__6.__ Compare emissions from motor vehicle sources in Baltimore City with emissions from motor 
vehicle sources in Los Angeles County, California (fips == "06037"). 
Which city has seen greater changes over time in motor vehicle emissions?


You will find that I create a separate R code file (plot1.R, plot2.R, etc.) that constructs the 
corresponding plot, i.e. code in plot1.R constructs the plot1.png plot and so on.

