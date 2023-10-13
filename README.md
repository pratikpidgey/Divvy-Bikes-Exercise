
# Divvy Data Project

A capstone project for the Google Coursera Program. Based on the case study "'Sophisticated, Clear, and Polished’: Divvy and Data Visualization" written by Kevin Hartman (found here: https://artscience.blog/home/divvy-dataviz-case-study).

## Introduction
Divvy, a bike-share service, wants to want increase revenue by turning casual members into paid members. To do this, the firm wants you to understand the difference between a casual memeber and a paid member. They believe that understanding this behavior will unlock the key to increasing revenue.

### Strategy
Working with the monthly 2021 data, I opened the datasets Excel to inspect the data. We want to ensure the data is clean and there are no discrepancies between the files. I noticed some rows under columns such as 'started_at' are blank. However, this does impact our analysis since we do not need this information to understand this behavior. I quickly caluclated 'ride_length' & 'day_of_week' by performing the folling formulas on the two empty columns: `=D2-C2` & `=WEEKDAY(C2,1)`.
I created a pivot table to see what trends I can find.

I saw that paid member is more likely to use bikes on weekdays for a shorter duration. A casual member is more likely to use bikes on the weekend for a longer duration.

I want to see if my thesis applies to the entire year

### Using R
Since we have 12 csv files, we cannot aggregate all of the into Excel. We will utilize R to aggregate all the files into one and perform our analysis. We will need the `tidyverse` & `lubridate` packages for this task. Please refer to the Github repo for the R script. 

### Conclusion
After wrangling through the data, we see that our the trend we found applies for the entire year. Knowing this behavior of users, the firm can decide how they want to target casual users into pursuading them buying a subscription. 


## License
https://divvybikes.com/data-license-agreement