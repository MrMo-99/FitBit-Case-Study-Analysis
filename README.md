# FitBit Fitness Tracker Data Analysis
#### Author: Mohammed Amja
#### Date: 23/06/2021

*Note: Please refer to the files in this repository to find all of the data/code/graphs/tables found in this report and much more.*
___

## Introduction
 


___

## Problem Statements



___

## Preparing Data for Analysis

For this project, I've used the 13 trip-data datasets dated from April 2020 to April 2021. Click on this [link](https://divvy-tripdata.s3.amazonaws.com/index.html) to access the website and download the datasets provided as .zip files. The data provided in this website is made available to access to the public.

Or you could access and download the data from this repository named as "Raw Data".

I am using Microsoft SQL Server Management Studio in this part of the project to help process and analyze the datasets.

First make sure to import all of the dataset as a .csv file to the database server.
Check and verify if the data types of each of the columns in each dataset is same to merge them all together.

**Note: The start_station_id column of dataset from Dec 2020 to April 2020 contains string values**



___


## Processing of Data




**In order to get accurate analysis, validate and make sure the dataset does not include any bias, incorrect data, and duplicates.**


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




