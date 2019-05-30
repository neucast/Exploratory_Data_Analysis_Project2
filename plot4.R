#####################################################################################################################
# 4.- Across the United States, how have emissions from coal combustion-related sources changed from 1999-2008? 
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

# Get combiustion related coal sources.
combustionCoal <- grepl("Fuel Comb.*Coal", SCC$EI.Sector)
combustionCoalSources <- SCC[combustionCoal,]

# Find emissions from combustion related coal sources.
emissionsCoalCombustion <- NEI[(NEI$SCC %in% combustionCoalSources$SCC), ]

# Aggregate combustion related coal emissions by year.
emissionsCoalRelated <- emissionsCoalCombustion[, lapply(.SD, sum, na.rm = TRUE), .SDcols = c("Emissions"), by = year]
#emissionsCoalRelated <- summarise(group_by(emissionsCoalCombustion, year), Emissions=sum(Emissions))


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

png(filename='plot4.png')

#display.brewer.all(colorblindFriendly = TRUE)

thePlot <- ggplot(emissionsCoalRelated, aes(x=factor(year), y=Emissions/1000,fill=year, label = round(Emissions/1000,2))) +
  geom_bar(stat="identity") +
  scale_fill_gradient(low="darkgreen",high="green") +
  xlab("Year") +
  ylab(expression("Total PM"[2.5]*" emissions (Kilotons)")) +
  ggtitle(expression("PM"[2.5]*" emissions from combustion related coal sources across the U.S.")) +
  geom_label(aes(fill = year),colour = "black", fontface = "bold")

print(thePlot)

dev.off()

#######################################

# Remove unnecessary data.
# in order to save RAM memory.

#######################################

# Remove data table.
rm(combustionCoal, combustionCoalSources, emissionsCoalCombustion, emissionsCoalRelated, fileName, path, thePlot)