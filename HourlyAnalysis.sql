

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
(
Select t1.Id, t1.Date_d, t1.time_h, t1.Calories, t2.TotalIntensity, t2.AverageIntensity, t3.StepTotal
From [dbo].[hourlyCalories_merged] as t1
Inner Join [dbo].[hourlyIntensities_merged] as t2
ON t1.Id = t2.Id and t1.Date_d = t2.ActivityHour and t1.time_h = t2.time_h
Inner Join [dbo].[hourlySteps_merged] as t3
ON t1.Id = t3.Id and t1.Date_d = t3.Date_d and t1.time_h = t3.time_h
)



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


--Calculate average met per day per user, and compare with the calories burned

Select Distinct t1.Id, t1.dates_d, sum(t1.METs) as sum_mets, t2.Calories
From [dbo].[minuteMETsNarrow_merged] as t1
inner join dailyActivity_merged as t2
on t1.Id = t2.Id and t1.dates_d = t2.Date_d
Group By t1.Id, t1.dates_d, t2.Calories
Order by dates_d




Select *
From [dbo].[hourlyCalories_merged]

Select *
From [dbo].[hourlyIntensities_merged]

Select *
From [dbo].[hourlySteps_merged]

Select *
From [dbo].[minuteMETsNarrow_merged]

Select *
From hourly_cal_int_step_merge

Select *
From dailyActivity_merged