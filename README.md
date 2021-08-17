# FitBit Fitness Tracker Data Analysis
#### Author: Mohammed Amja
#### Date: 18/08/2021

*Note: Please refer to the files in this repository to find all of the data/code/graphs/tables found in this report and much more.*
___

## Introduction
 Bellabeat is a high-tech company that manufactures health-focused products primarily for women. The company makes products and applications that help monitor their health and wellness such as activity, stress levels, sleep and other mindful habits. Bellabeat is a successful small company that is looking forward to expand their capabilities and improve their products to hopefully become a competitive large player in the global smart device market. Urška Sršen, cofounder and Chief Creative Officer of Bellabeat, is determined to unlock new growth oppurtunities and believes that can be done by analyzing data from smart device fitness gadgets. 
___

## Problem Statements
The Co-founder and Chief Creative Officer of Bellabeat, Urška, wants to develop effective marketing strategies to help unlock new growth oppurtunities for the company. She believes this can be done by analyzing consumer data on smart device usage and gaining insights. 

**The Business Task:**
  * To analyze data to gain insights on how consumers use smart devices.
  * Use the discovered insights to help guide marketing strategies for the company.
___

## Preparing Data for Analysis

For this project, I've used the 18 datasets dated from 03/12/2016 - 05/12/2016 provided on kaggle. Click on this [FitBit Fitness Tracker Data](https://www.kaggle.com/arashnic/fitbit) (CC0: Public Domain, dataset made available through Mobius) to access the website and download the datasets provided as .csv files. This data set contains personal fitness data from 30 fitbit users on minute-level output for physical activity, heart rate, and sleep monitoring. It also includes information on daily activity, steps, and heart rate that can be used to explore users’ habits. Thirty Fitbit users consented to the submission of personal tracker data and the data provided in this website is made available to access to the public. 

Or you could access and download the data from this repository named as "Raw Data".

I am using Microsoft SQL Server Management Studio in this part of the project to help process and analyze the datasets.

First make sure to import all of the dataset as a .csv file to the database server.
In order to solve this business task, only 6 of the given 18 datasets was used. Many of the files are either redundant, is not essential, or relevant, or lacking sufficient data to perform an analysis upon.

___


## Processing and Analysis of Data
Here, I will be transforming and organizing data by adding new columns, extracting information and removing bad data and duplicates.

**In order to get accurate analysis, validate and make sure the dataset does not include any bias, incorrect data, and duplicates.**

```TSQL

--Checking Number of Rows on dailyActivities

Select Count(*)
From [dbo].[dailyActivity_merged]


--Checking for duplicates in dailyActivity dataset

Select Id, ActivityDate, TotalSteps, Count(*)
From [dbo].[dailyActivity_merged]
group by id, ActivityDate, TotalSteps
Having Count(*) > 1


--Modify date format for better understaning in sleepDay

Update sleepDay_merged
Set SleepDay = Convert(date, SleepDay, 101)


--Modify date format for better understaning in dailyActivity

Update dailyActivity_merged
Set ActivityDate = Convert(date, ActivityDate, 101)


--Add day_0f_week column on dailyActivities

Alter Table [dbo].[dailyActivity_merged]
ADD day_of_week nvarchar(50)


--Extract datename from ActivityDate

Update dailyActivity_merged
SET day_of_week = DATENAME(DW, ActivityDate)


--Add sleep data columns on dailyActivity table

Alter Table [dbo].[dailyActivity_merged]
ADD total_mins_sleep int,
total_mins_bed int


--Add sleep records into dailyActivity table

UPDATE dailyActivity_merged
Set total_mins_sleep = t2.TotalMinutesAsleep,
total_mins_bed = t2.TotalTimeInBed 
From [dbo].[dailyActivity_merged] as t1
Full Outer Join sleepDay_merged as t2
on t1.id = t2.id and t1.ActivityDate = t2.SleepDay


--Adding specific date format to [dailyActivity_merged] table

Alter table dailyActivity_merged
Add Date_d date

Update dailyActivity_merged
Set Date_d = CONVERT( date, ActivityDate, 103 )


--Split date and time seperately for [hourlyCalories_merged] table

Alter Table [dbo].[hourlyCalories_merged]
ADD time_h int

Update [dbo].[hourlyCalories_merged]
Set time_h = DATEPART(hh, Date_d)

Update [dbo].[hourlyCalories_merged]
Set Date_d = SUBSTRING(Date_d, 1, 9)


--Split date and time seperately for [hourlyIntensities_merged]

Alter Table [dbo].[hourlyIntensities_merged]
ADD time_h int

Update [dbo].[hourlyIntensities_merged]
Set time_h = DATEPART(hh, ActivityHour)

Update [dbo].[hourlyIntensities_merged]
Set ActivityHour = SUBSTRING(ActivityHour, 1, 9)


--Split date and time seperately for [hourlySteps_merged]

Alter Table [dbo].[hourlySteps_merged]
ADD time_h int

Update [dbo].[hourlySteps_merged]
Set time_h = DATEPART(hh, Date_d)

Update [dbo].[hourlySteps_merged]
Set Date_d = SUBSTRING(Date_d, 1, 9)


--Split date and time seperately for [minuteMETsNarrow_merged]

Alter Table [dbo].[minuteMETsNarrow_merged]
ADD time_t time

Update [dbo].[minuteMETsNarrow_merged]
Set time_t = CAST(Date_d as time)

Update [dbo].[minuteMETsNarrow_merged]
Set time_t = Convert(varchar(5), time_t, 108)

Update [dbo].[minuteMETsNarrow_merged]
Set Date_d = SUBSTRING(Date_d, 1, 9)


--Create new table to merge hourlyCalories, hourlyIntensities, and hourlySteps

Create table hourly_cal_int_step_merge(
Id numeric(18,0),
Date_d nvarchar(50),
time_h int,
Calories numeric(18,0),
TotalIntensity numeric(18,0),
AverageIntensity float,
StepTotal numeric (18,0)
)


--Insert corresponsing data and merge multiple table into one table

Insert Into hourly_cal_int_step_merge (Id, Date_d, time_h, Calories, TotalIntensity, AverageIntensity, StepTotal)
(Select t1.Id, t1.Date_d, t1.time_h, t1.Calories, t2.TotalIntensity, t2.AverageIntensity, t3.StepTotal
From [dbo].[hourlyCalories_merged] as t1
Inner Join [dbo].[hourlyIntensities_merged] as t2
ON t1.Id = t2.Id and t1.Date_d = t2.ActivityHour and t1.time_h = t2.time_h
Inner Join [dbo].[hourlySteps_merged] as t3
ON t1.Id = t3.Id and t1.Date_d = t3.Date_d and t1.time_h = t3.time_h)


--Checking for duplicates

/*Select Id, time_h, Calories, TotalIntensity, AverageIntensity, StepTotal, Count(*) as duplicates
From [dbo].[hourly_cal_int_step_merge]
Group by Id, time_h, Calories, TotalIntensity, AverageIntensity, StepTotal
Having Count(*) > 1*/


--Checking for duplicates

/*Select sum(duplicates) as sum_s
from (Select Id, Date_d time_h, Calories, TotalIntensity, AverageIntensity, StepTotal, Count(*) as duplicates
From [dbo].[hourly_cal_int_step_merge]
Group by Id, Date_d, time_h, Calories, TotalIntensity, AverageIntensity, StepTotal
Having Count(*) > 1
Order by duplicates DESC) as cte*/


--Query in hh:mm time format for better understanding on MET Table 

select Id, Cast(Date_d as date) as date_d, METs, Convert(varchar(5), time_t, 108) as time_t
From [dbo].[minuteMETsNarrow_merged]


--Change date type nvarchar to date on MET table to join properly with other table

Alter table minuteMETsNarrow_merged
Add dates_d date

Update minuteMETsNarrow_merged
Set dates_d = Cast(Date_d as date)
```

Here, I will be analysing the consumer data to discover trends and patterns. 

```TSQL

```




___


## Visualizing Data

In this phase, we will be visualizing the data analyzed and tables created using Tableau Public.

For the interactive version, [Click here](https://public.tableau.com/app/profile/mohammed.amja5151/viz/BikeShareAnalysisVisualized/BikeShareAnalysisVisualized)

**Average Ride Duration:**


From inferring to the figure shown below. We can conclude that casual members on average tend to ride bikes for a longer duration of time than annual members.


![Avg Ride Duration](https://user-images.githubusercontent.com/83900526/123244664-c31be180-d501-11eb-9e92-9929671ecc17.png)

**Users Per Day Of the Week:**

The data suggests that casual users are more inclined to use the bikes on a weekend, while members tend to use them more on weekdays.

![Users Per Day of Week](https://user-images.githubusercontent.com/83900526/123246014-fe6ae000-d502-11eb-891e-30aa892b178f.png)


**Hourly Traffic Analysis of Users**

Although both groups seem to prefer evening rides, from **3:00PM - 7:00PM**, annual members also seem to have higher usage in the morning from **6:00AM - 9:00AM**.

![Hourly Traffic](https://user-images.githubusercontent.com/83900526/123246956-ff504180-d503-11eb-8dac-58be3478bf38.png)


**Monthly User Traffic**

The graph depicts that irrespective of the user type, the usage of their bikes are highest in the months **June - October**. While lowest traffic occurs from **November - March**.

![Monthly Traffic](https://user-images.githubusercontent.com/83900526/123247143-3161a380-d504-11eb-8cb9-d4e69a71b35a.png)


**Most Popular Stations for Casual Users**

Top 20 most popular stations for casual users.

![Most Popular Stations for Casuals](https://user-images.githubusercontent.com/83900526/123248777-f1032500-d505-11eb-92d8-8ed2f784613e.png)

**Tableau Dashboard**

Visualizations built in a dashboard. 

![BikeShare Analysis Dashboard](https://user-images.githubusercontent.com/83900526/123249276-6969e600-d506-11eb-8ecd-9619fb564647.png)

___

## Conclusion

After performing the collection, transformation, cleaning, organisation and analysis of the given 13 datasets, we have enough factual evidence to suggest answers to the business-related questions that were asked.

We can infer that casual users are more likely to use their bikes for a longer duration of time. Casual users are also more inclined to ride during evening hours of **3:00PM - 7PM** and weekends is when most of the casual users prefer to ride. While user traffic for both groups are highest during the months of summer, the months of winter is when user traffic significantly drops for both types.

In order to design new marketing strategies to better focus on and suit the casual users to help convert them into buying annual memberships, we have to refer to the analysis provided above and keep those facts in mind. The recommendations I would provide to help solve this business-related scenario is shown below.

#### Top Recommendations to Marketing Strategists:

* Implement advertising annual memberships prices more using billboards/posters near the top 20 most popular stations for casual users.
* Provide a limited discount on annual memberships purchased during the months of lowest traffic to increase rider usage in these months.
* Have frequent advertisements on social media and television during peak hours and peak months, since that is when most people have a thought about riding bikes.
* Consider provide free ride minutes for every minute passed after 30 minutes of usage, where the free minutes can **ONLY** be redeemed on weekdays to help promote rider usage during weekdays. 




