#####################################################################################################################
# 5.- How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City? 
# This program uses the ggplot2 plotting system to make a plot to answer this question.
#####################################################################################################################


#######################################

# Set working directories.

#######################################

setwd("D:/OneDrive/Documentos/CourseraDataScience/ExploratoryDataAnalysis/Week4/Project2/Exploratory_Data_Analysis_Project2")

#######################################

# Set required libraries.

#######################################

library("data.table")
library("dplyr")
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

# Subset of the NEI data which corresponds to vehicles.
restriction <- grepl("vehicle", SCC[, SCC.Level.Two], ignore.case=TRUE)
vehiclesSCC <- SCC[restriction, SCC]
vehiclesNEI <- NEI[NEI[, SCC] %in% vehiclesSCC,]

# Subset the vehicles NEI data to Baltimore's fip
baltimoreVehiclesNEI <- vehiclesNEI[fips=="24510",]

# Aggregate Baltimore Vehicles emissions by year.
totalBaltimoreVehiclesNEI <- baltimoreVehiclesNEI[, lapply(.SD, sum, na.rm = TRUE), .SDcols = c("Emissions"), by = year]

#######################################

# Remove unnecessary data.
# in order to save RAM memory.

#######################################

# Remove data table.
rm(NEI, SCC, restriction, vehiclesSCC, vehiclesNEI, baltimoreVehiclesNEI)

#######################################

# Create the graph and save it to a
# png file.

#######################################

png(filename='plot5.png')

#display.brewer.all(colorblindFriendly = TRUE)

thePlot <- ggplot(totalBaltimoreVehiclesNEI, aes(x=factor(year), y=Emissions,fill=year, label = round(Emissions,2))) +
  geom_bar(stat="identity") +
  scale_fill_gradient(low="darkblue",high="blue") +
  xlab("Year") +
  ylab(expression("Total PM"[2.5]*" emissions (Tons)")) +
  ggtitle(expression("PM"[2.5]*" emissions from Baltimore city motor vehicule sources")) +
  geom_label(aes(fill = year),colour = "white", fontface = "bold")

print(thePlot)

dev.off()

#######################################

# Remove unnecessary data.
# in order to save RAM memory.

#######################################

# Remove data table.
rm(totalBaltimoreVehiclesNEI, fileName, path, thePlot)