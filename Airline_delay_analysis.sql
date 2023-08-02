/*
AIr Flight Delays Analysis

Skills used: Joins, Aggregate Functions, Converting Data Types

*/

-- Standardize Date Format
select [year], [month], [day] from flights;


-- create new column as flightDate and insert concatenated date to the new column
alter table flights
add FlightDate as 
(convert(date, cast([year] as varchar(4)) + '-' +
cast([month] as varchar(2)) + '-' +
cast([day] as varchar(2))));


-- Add new column for day of the week
alter table flights
add Name_of_Day varchar(10);

-- update the Name_of_day column
Update flights
set Name_of_Day =
	CASE WHEN DAY_OF_WEEK = 1 THEN 'Sunday'
		WHEN DAY_OF_WEEK = 2 THEN 'Monday'
		WHEN DAY_OF_WEEK = 3 THEN 'Tuesday'
		WHEN DAY_OF_WEEK = 4 THEN 'Wednesday'
		WHEN DAY_OF_WEEK = 5 THEN 'Thursday'
		WHEN DAY_OF_WEEK = 6 THEN 'Friday'
		WHEN DAY_OF_WEEK = 7 THEN 'Saturday'
END
FROM flights;


-----------------------------------------------------------------------------------------------------------------------------
-- View all the tables in the database
select * from flights a
join airlines b
on a.airline = b.IATA_CODE
join cancellation_codes c
on a.cancellation_reason = c.cancellation_reason 


-- How does the overall flight volume vary by month?
select DATENAME(month, FlightDate) as Month, count(*) as Volume 
from [dbo].[flights]
group by DATENAME(month, FlightDate);


-- How does the overall flight volume vary by day of week?
select Name_of_Day, count(*) as Volume 
from [dbo].[flights]
group by Name_of_Day
order by Volume desc;


-- Percentage of flights that experienced a departure delay in 2015
select convert(float,(select COUNT(*)
from flights where DEPARTURE_DELAY>0))/convert(float,count(*)) * 100 
from flights


-- Average Departure delay time in minute
select avg(convert(float,DEPARTURE_DELAY)) from flights
where DEPARTURE_DELAY > 0 


-- Total Flight Cancellation in 2015
select count(*) as total_flight_cancelled from flights
where CANCELLED = 1


-- Cancellation reasons
select a.CANCELLATION_REASON, b.CANCELLATION_DESCRIPTION, count(*) as total_cancellation from flights a
inner join cancellation_codes b
on a.CANCELLATION_REASON = b.CANCELLATION_REASON
where CANCELLED = 1
group by a.CANCELLATION_REASON, b.CANCELLATION_DESCRIPTION
order by total_cancellation desc;


-- Most relaible airlines in terms of on-time departure
select a.AIRLINE, b.airline, count(a.DEPARTURE_DELAY) as total_departure from flights a
left join airlines b
on a.airline = b.IATA_CODE
where DEPARTURE_DELAY <= 0 and cancelled = 0
group by a.AIRLINE, b.airline
order by total_departure


-- Least relaible airlines in terms of late departure
select a.AIRLINE, b.airline, count(a.DEPARTURE_DELAY) as total_departure from flights a
left join airlines b
on a.airline = b.IATA_CODE
where DEPARTURE_DELAY > 0 and cancelled = 0
group by a.AIRLINE, b.airline
order by total_departure desc;


-- Least relaible airlines in terms of Cancellation
select a.AIRLINE, b.airline, count(a.CANCELLED) as total_cancellation from flights a
left join airlines b
on a.airline = b.IATA_CODE
where a.CANCELLED = 1
group by a.AIRLINE, b.airline
order by total_cancellation desc























