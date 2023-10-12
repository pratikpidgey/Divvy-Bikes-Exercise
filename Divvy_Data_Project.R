### Cyclistic_Exercise_Full_Year_Analysis ###

# This analysis is for case study 1 from the Google Data Analytics Certificate (Cyclistic).  It’s originally based on the case study "'Sophisticated, Clear, and Polished’: Divvy and Data Visualization" written by Kevin Hartman (found here: https://artscience.blog/home/divvy-dataviz-case-study). We will be using the Divvy dataset for the case study. The purpose of this script is to consolidate downloaded Divvy data into a single dataframe and then conduct simple analysis to help answer the key question: “In what ways do members and casual riders use Divvy bikes differently?”

# # # # # # # # # # # # # # # # # # # # # # # 
# Install required packages
# tidyverse for data import and wrangling
# libridate for date functions
# ggplot for visualization
# # # # # # # # # # # # # # # # # # # # # # #  

library(tidyverse)  #helps wrangle data
library(lubridate)  #helps wrangle date attributes
library(ggplot2)  #helps visualize data
getwd() #displays your working directory
setwd("/Users/Pratik Patel/Desktop/Google Capstone Project/Divy Data/2021/csv")

#=====================
# STEP 1: COLLECT DATA
#=====================
# Upload Divvy datasets (csv files) here

Jan_21 <- read.csv("202101-divvy-tripdata.csv")
Feb_21 <- read.csv("202102-divvy-tripdata.csv")
Mar_21 <- read.csv("202103-divvy-tripdata.csv")
Apr_21 <- read.csv("202104-divvy-tripdata.csv")
May_21 <- read.csv("202105-divvy-tripdata.csv")
Jun_21 <- read.csv("202106-divvy-tripdata.csv")
Jul_21 <- read.csv("202107-divvy-tripdata.csv")
Aug_21 <- read.csv("202108-divvy-tripdata.csv")
Sep_21 <- read.csv("202109-divvy-tripdata.csv")
Oct_21 <- read.csv("202110-divvy-tripdata.csv")
Nov_21 <- read.csv("202111-divvy-tripdata.csv")
Dec_21 <- read.csv("202112-divvy-tripdata.csv")


#====================================================
# STEP 2: WRANGLE DATA AND COMBINE INTO A SINGLE FILE
#====================================================
# Compare column names each of the files
# While the names don't have to be in the same order, they DO need to match perfectly before we can use a command to join them into one file
colnames(Jan_21)
colnames(Feb_21)
colnames(Mar_21)
colnames(Apr_21)
colnames(May_21)
colnames(Jun_21)
colnames(Jul_21)
colnames(Aug_21)
colnames(Sep_21)
colnames(Oct_21)
colnames(Nov_21)
colnames(Dec_21)


# Convert ride_id and rideable_type to character so that they can stack correctly
Jan_21 <-  mutate(Jan_21, ride_id = as.character(ride_id)
                   ,rideable_type = as.character(rideable_type)) 
Feb_21<-  mutate(Feb_21, ride_id = as.character(ride_id)
                  ,rideable_type = as.character(rideable_type)) 
Mar_21 <-  mutate(Mar_21, ride_id = as.character(ride_id)
                  ,rideable_type = as.character(rideable_type)) 
Apr_21 <-  mutate(Apr_21, ride_id = as.character(ride_id)
                  ,rideable_type = as.character(rideable_type)) 
May_21 <-  mutate(May_21, ride_id = as.character(ride_id)
                  ,rideable_type = as.character(rideable_type)) 
Jun_21 <-  mutate(Jun_21, ride_id = as.character(ride_id)
                  ,rideable_type = as.character(rideable_type)) 
Jul_21 <-  mutate(Jul_21, ride_id = as.character(ride_id)
                  ,rideable_type = as.character(rideable_type)) 
Aug_21 <-  mutate(Aug_21, ride_id = as.character(ride_id)
                  ,rideable_type = as.character(rideable_type)) 
Sep_21 <-  mutate(Sep_21, ride_id = as.character(ride_id)
                  ,rideable_type = as.character(rideable_type)) 
Oct_21 <-  mutate(Oct_21, ride_id = as.character(ride_id)
                  ,rideable_type = as.character(rideable_type)) 
Nov_21 <-  mutate(Nov_21, ride_id = as.character(ride_id)
                  ,rideable_type = as.character(rideable_type)) 
Dec_21 <-  mutate(Dec_21, ride_id = as.character(ride_id)
                  ,rideable_type = as.character(rideable_type)) 

# Stack individual month's data frames into one big data frame
all_trips <- bind_rows(Jan_21,Feb_21,Mar_21,Apr_21,May_21,Jun_21,Jul_21,Aug_21,Sep_21,Oct_21,Nov_21,Dec_21)

# Remove lat, long,and ride_length. The reason for removing ride_length is that we will remake in R. All the durations will be in seconds
all_trips <- all_trips %>%  
  select(-c(start_lat, start_lng, end_lat, end_lng,ride_length))
#======================================================
# STEP 3: CLEAN UP AND ADD DATA TO PREPARE FOR ANALYSIS
#======================================================
# Inspect the new table that has been created
colnames(all_trips)  #List of column names
nrow(all_trips)  #How many rows are in data frame?
dim(all_trips)  #Dimensions of the data frame?
head(all_trips)  #See the first 6 rows of data frame.  Also tail(qs_raw)
str(all_trips)  #See list of columns and data types (numeric, character, etc)
summary(all_trips)  #Statistical summary of data. Mainly for numerics

# There are a few problems we will need to fix:
#   The data can only be aggregated at the ride-level, which is too granular. We will want to add some additional columns of data -- such as day, month, year -- that provide additional opportunities to aggregate the data.
#   We will want to add a calculated field for length of ride since the 2020Q1 data did not have the "tripduration" column. We will add "ride_length" to the entire dataframe for consistency.
#   There are some rides where tripduration shows up as negative, including several hundred rides where Divvy took bikes out of circulation for Quality Control reasons. We will want to delete these rides.


# Add columns that list the date, month, day, and year of each ride
# This will allow us to aggregate ride data for each month, day, or year ... before completing these operations we could only aggregate at the ride level
# https://www.statmethods.net/input/dates.html more on date formats in R found at that link

all_trips$date <- as.Date(all_trips$started_at, format="%m/%d/%Y") #The default format is yyyy-mm-dd
all_trips$month <- format(as.Date(all_trips$date), "%m")
all_trips$day <- format(as.Date(all_trips$date), "%d")
all_trips$year <- format(as.Date(all_trips$date), "%Y")
all_trips$day_of_week <- format(as.Date(all_trips$date), "%A")

# Add a "ride_length" calculation to all_trips (in seconds)
# https://stat.ethz.ch/R-manual/R-devel/library/base/html/difftime.html
all_trips$started_at <- as.POSIXct(all_trips$started_at, format = "%m/%d/%Y %H:%M")
all_trips$ended_at <- as.POSIXct(all_trips$ended_at, format = "%m/%d/%Y %H:%M")
all_trips$ride_length <- difftime(all_trips$ended_at,all_trips$started_at)

# Inspect the structure of the columns
str(all_trips)


# Convert "ride_length" from Character to numeric so we can run calculations on the data
is.factor(all_trips$ride_length)
all_trips$ride_length <- as.numeric(as.character(all_trips$ride_length))
is.numeric(all_trips$ride_length)


# Remove "bad" data
# The dataframe includes a few hundred entries when bikes were taken out of docks and checked for quality by Divvy or ride_length was negative
# We will create a new version of the dataframe (v2) since data is being removed
# https://www.datasciencemadesimple.com/delete-or-drop-rows-in-r-with-conditions-2/
all_trips_v2 <- all_trips[!(all_trips$start_station_name == "HQ QR" | all_trips$ride_length<0),]

#=====================================
# STEP 4: CONDUCT DESCRIPTIVE ANALYSIS
#=====================================
# Descriptive analysis on ride_length (all figures in seconds)
mean(all_trips_v2$ride_length) #straight average (total ride length / rides)
median(all_trips_v2$ride_length) #midpoint number in the ascending array of ride lengths
max(all_trips_v2$ride_length) #longest ride
min(all_trips_v2$ride_length) #shortest ride

# You can condense the four lines above to one line using summary() on the specific attribute
summary(all_trips_v2$ride_length)

# Compare members and casual users
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = mean)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = median)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = max)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = min)

# See the average ride time by each day for members vs casual users
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week, FUN = mean)

# Notice that the days of the week are out of order. Let's fix that.
all_trips_v2$day_of_week <- ordered(all_trips_v2$day_of_week, levels=c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))

# Now, let's run the average ride time by each day for members vs casual users
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week, FUN = mean)

# analyze ridership data by type and weekday
all_trips_v2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>%  #creates weekday field using wday()
  group_by(member_casual, weekday) %>%  #groups by usertype and weekday
  summarise(number_of_rides = n()							#calculates the number of rides and average duration 
            ,average_duration = mean(ride_length)) %>% 		# calculates the average duration
  arrange(member_casual, weekday)								# sorts

# Let's visualize the number of rides by rider type
all_trips_v2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>% 
  group_by(member_casual, weekday) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>% 
  arrange(member_casual, weekday)  %>% 
  ggplot(aes(x = weekday, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge")

# Let's create a visualization for average duration
all_trips_v2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>% 
  group_by(member_casual, weekday) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>% 
  arrange(member_casual, weekday)  %>% 
  ggplot(aes(x = weekday, y = average_duration, fill = member_casual)) +
  geom_col(position = "dodge")

#=================================================
# STEP 5: EXPORT SUMMARY FILE FOR FURTHER ANALYSIS
#=================================================
# Create a csv file that we will visualize in Excel, Tableau, or my presentation software
# N.B.: This file location is for a Mac. If you are working on a PC, change the file location accordingly (most likely "C:\Users\YOUR_USERNAME\Desktop\...") to export the data. You can read more here: https://datatofish.com/export-dataframe-to-csv-in-r/
counts <- aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week, FUN = mean)
write.csv(counts, file = 'C:/Users/Pratik Patel/Desktop/Google Capstone Project/Divy Data/2021/counts.csv')

#You're done! Congratulations!

