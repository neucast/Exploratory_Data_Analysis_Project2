#####################################################################################################################
# 1.- Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
# Using the base plotting system, this program makes a plot showing the total PM2.5 emission from all sources 
# for each of the years 1999, 2002, 2005, and 2008.
#####################################################################################################################


#######################################

# Set working directories.

#######################################

setwd("D:/OneDrive/Documentos/CourseraDataScience/ExploratoryDataAnalysis/Week4/Project2/Exploratory_Data_Analysis_Project2")

#######################################

# Set required libraries.

#######################################

library("data.table")
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

# Histogram prints in scientific notation.
NEI[, Emissions := lapply(.SD, as.numeric), .SDcols = c("Emissions")]

# Aggregate emissions by year.
totalNEI <- NEI[, lapply(.SD, sum, na.rm = TRUE), .SDcols = c("Emissions"), by = year]

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

png(filename='plot1.png')

cols <- brewer.pal(9,"Blues")

barplot(height=totalNEI[, Emissions]
        , names.arg=totalNEI[, year]
        , xlab="Years"
        , ylab=expression('Aggregated Emissions (Tons)')
        , main=expression('Aggregated PM'[2.5]*' Emmissions by Year')
        , col = cols)

dev.off()

#######################################

# Remove unnecessary data.
# in order to save RAM memory.

#######################################

# Remove data table.
rm(totalNEI, cols, fileName, path)