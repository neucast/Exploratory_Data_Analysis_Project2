#####################################################################################################################
# 6.- Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in 
# Los Angeles County, California (fips == "06037"). 
# Which city has seen greater changes over time in motor vehicle emissions?
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

#Baltimore
# Subset the vehicles NEI data to Baltimore's fip
baltimoreVehiclesNEI <- vehiclesNEI[fips=="24510",]

# Aggregate Baltimore vehicule emissions by year.
totalBaltimoreVehiclesNEI <- baltimoreVehiclesNEI[, lapply(.SD, sum, na.rm = TRUE), .SDcols = c("Emissions"), by = year]
totalBaltimoreVehiclesNEI$County <- "Baltimore City, MD"
totalBaltimoreVehiclesNEI$city <- "Baltimore City"

#Los Angeles
# Subset the vehicles NEI data to Los Angeles's fip
losAngelesVehiclesNEI <- vehiclesNEI[fips=="06037",]

# Aggregate Baltimore vehicule emissions by year.
totalLosAngelesVehiclesNEI <- losAngelesVehiclesNEI[, lapply(.SD, sum, na.rm = TRUE), .SDcols = c("Emissions"), by = year]
totalLosAngelesVehiclesNEI$County <- "Los Angeles County, CA"
totalLosAngelesVehiclesNEI$city <- "Los Angeles"

# Combine data.tables into one data.table
baltimoreAndLosAngelesVehiclesNEI <- rbind(totalBaltimoreVehiclesNEI,totalLosAngelesVehiclesNEI)

#######################################

# Remove unnecessary data.
# in order to save RAM memory.

#######################################

# Remove data table.
rm(NEI, SCC, restriction, vehiclesSCC, vehiclesNEI, baltimoreVehiclesNEI, losAngelesVehiclesNEI, totalBaltimoreVehiclesNEI, totalLosAngelesVehiclesNEI)

#######################################

# Create the graph and save it to a
# png file.

#######################################

png(filename='plot6.png')

#display.brewer.all(colorblindFriendly = TRUE)

thePlot <- ggplot(baltimoreAndLosAngelesVehiclesNEI, aes(x=factor(year), y=Emissions, fill=County,label = round(Emissions,2))) +
    geom_bar(stat="identity") + 
    #facet_grid(County~., scales="free") +
    facet_grid(scales="free", space="free", .~city) +
    ylab(expression("Total PM"[2.5]*" emissions (Tons)")) + 
    xlab("Year") +
    ggtitle(expression("Baltimore City vs Los Angeles County Motor Vehicle PM"[2.5]*" Emissions"))+
    geom_label(aes(fill = County),colour = "yellow", fontface = "bold")

print(thePlot)

dev.off()

#######################################

# Remove unnecessary data.
# in order to save RAM memory.

#######################################

# Remove data table.
rm(baltimoreAndLosAngelesVehiclesNEI, fileName, path, thePlot)