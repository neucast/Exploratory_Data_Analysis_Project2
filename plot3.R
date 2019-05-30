#####################################################################################################################
# 3.- Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these 
# four sources have seen decreases in emissions from 1999-2008 for Baltimore City? 
# Which have seen increases in emissions from 1999-2008? 
# This program uses the ggplot2 plotting system to make a plot to answer this questions.
#####################################################################################################################


#######################################

# Set working directories.

#######################################

setwd("D:/OneDrive/Documentos/CourseraDataScience/ExploratoryDataAnalysis/Week4/Project2/Exploratory_Data_Analysis_Project2")

#######################################

# Set required libraries.

#######################################

library("data.table")
library("ggplot2")
library("RColorBrewer")

#######################################

# Download and unzip data.

#######################################

# Get data.
path <- getwd()

fileName <- "dataFiles.zip"

# Checking if archieve already exists.
if (!file.exists(fileName)){
  download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
              , destfile = paste(path, fileName, sep = "/"))
  unzip(zipfile = fileName)
}

#######################################

# Read data.

#######################################

# National Emissions Inventory.
NEI <- data.table::as.data.table(x = readRDS(file = "summarySCC_PM25.rds"))

# Source Classification Code.
SCC <- data.table::as.data.table(x = readRDS(file = "Source_Classification_Code.rds"))

#######################################

# Filter the data of interest.
# Clean and adjust data.

#######################################

# Prints in scientific notation.
NEI[, Emissions := lapply(.SD, as.numeric), .SDcols = c("Emissions")]

# Subset NEI data for Baltimore
baltimoreNEI <- NEI[fips=="24510",]

# Aggregate emissions for Baltimore City, Maryland (fips == "24510") by year and type.
baltimoreByYearAndTypeEmissions <- aggregate(Emissions ~ year + type, baltimoreNEI, sum)


#######################################

# Remove unnecessary data.
# in order to save RAM memory.

#######################################

# Remove data table.
rm(NEI, SCC)

#######################################

# Create the graph and save it to a
# png file.

#######################################

png(filename='plot3.png')

#display.brewer.all(colorblindFriendly = TRUE)

thePlot <- ggplot(baltimoreByYearAndTypeEmissions, aes(year, Emissions, color = type))
thePlot <- thePlot + geom_line() +
  xlab("Year") +
  ylab(expression("Total PM"[2.5]*" Emissions (Tons)")) +
  ggtitle(expression("PM"[2.5]*" Emissions, Baltimore City From 1999 to 2008 by Source Type")) +
  scale_color_brewer(palette = "Set2")

print(thePlot)

dev.off()

#######################################

# Remove unnecessary data.
# in order to save RAM memory.

#######################################

# Remove data table.
rm(baltimoreNEI, baltimoreByYearAndTypeEmissions, fileName, path, thePlot)