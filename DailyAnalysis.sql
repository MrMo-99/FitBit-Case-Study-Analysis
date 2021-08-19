

/*Checking Number of Rows on dailyActivities*/

Select Count(*)
From [dbo].[dailyActivity_merged]


/*Checking for duplicates in dailyActivity dataset*/

Select Id, ActivityDate, TotalSteps, Count(*)
From [dbo].[dailyActivity_merged]
group by id, ActivityDate, TotalSteps
Having Count(*) > 1



/*Modify date format for better understaning in sleepDay*/

Update sleepDay_merged
Set SleepDay = Convert(date, SleepDay, 101)



/*Modify date format for better understaning in dailyActivity*/

Update dailyActivity_merged
Set ActivityDate = Convert(date, ActivityDate, 101)



/*Add day_0f_week column on dailyActivities*/

Alter Table [dbo].[dailyActivity_merged]
ADD day_of_week nvarchar(50)



/*Extract datename from ActivityDate*/

Update dailyActivity_merged
SET day_of_week = DATENAME(DW, ActivityDate)



/*Add sleep data columns on dailyActivity table*/

Alter Table [dbo].[dailyActivity_merged]
ADD total_mins_sleep int,
total_mins_bed int



/*Add sleep records into dailyActivity table*/

UPDATE dailyActivity_merged
Set total_mins_sleep = t2.TotalMinutesAsleep,
total_mins_bed = t2.TotalTimeInBed 
From [dbo].[dailyActivity_merged] as t1
Full Outer Join sleepDay_merged as t2
on t1.id = t2.id and t1.ActivityDate = t2.SleepDay

--------------------------------------------------------------------------

                                                             --Analysis--
--Daily Sum Analysis - No trends/patterns found

Select SUM(TotalSteps) as total_steps,
SUM(TotalDistance) as total_dist,
SUM(Calories) as total_calories,
day_of_week
From [dbo].[dailyActivity_merged]
Group By  day_of_week



--Daily Average analysis - No trends/patterns found

Select AVG(TotalSteps) as avg_steps,
AVG(TotalDistance) as avg_dist,
AVG(Calories) as avg_calories,
day_of_week
From [dbo].[dailyActivity_merged]
Group By  day_of_week



--Activities and colories comparison

Select Id,
SUM(TotalSteps) as total_steps,
SUM(VeryActiveMinutes) as total_Vactive_mins,
Sum(FairlyActiveMinutes) as total_Factive_mins,
SUM(LightlyActiveMinutes) as total_Lactive_mins,
SUM(Calories) as total_calories
From [dbo].[dailyActivity_merged]
Group By Id



--Average Sleep Time per user

Select Id, Avg(TotalMinutesAsleep)/60 as avg_sleep_time_h,
Avg(TotalTimeInBed)/60 as avg_time_bed_h,
AVG(TotalTimeInBed - TotalMinutesAsleep) as wasted_bed_time_m
from sleepDay_merged
Group by Id



--Sleep and calories comparison	

Select t1.Id, SUM(TotalMinutesAsleep) as total_sleep_m,
SUM(TotalTimeInBed) as total_time_inbed_m,
SUM(Calories) as calories
From [dbo].[dailyActivity_merged] as t1
Inner Join [dbo].[sleepDay_merged] as t2
ON t1.Id = t2.Id and t1.ActivityDate = t2.SleepDay
Group By t1.Id



Select *
From [dbo].[dailyActivity_merged]

Select Id, count(Id) as coun
From sleepDay_merged
Group by Id

--Time Expenditure per day
Select Distinct Id, SUM(SedentaryMinutes) as sedentary_mins,
SUM(LightlyActiveMinutes) as lightly_mins,
SUM(FairlyActiveMinutes) as fairlyactive_mins, 
SUM(VeryActiveMinutes) as veryactive_mins
From [dbo].[dailyActivity_merged]
where total_mins_bed IS NOT NULL
Group by Id
