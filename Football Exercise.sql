/*
Football Case Study - Start
Contains both Foundation and Advanced Level SQL statements

FootballMatch and FootballCalendar are the two tables we will use in this exercise.
The FootballMatch table contains a row for every match played as of early April 2019 in the English Premier League.
The FootballCalendar table contains a row for every date in 2018 and 2019

Connect to the LearnSQL database
*/

SELECT TOP 10 fm.* FROM FootballMatch fm;
SELECT TOP 10 cal.* FROM FootballCalendar cal;

-- How many matches have been played?

-- Which date had the most matches?
--SELECT fm.[Date],

-- follow on: Which day of week had most matches?

-- List all the teams in the Premier League in alphabetical order

/*
How many matches were played each month? Put the months in chronological order.
Implement this in two ways 
(a) using date functions such as MONTH and DATENAME
(b) joining to the FootballCalendar table
*/

-- Were any matches played on a Thursday?

/*
In which matches did the home team score more than three goals?  
Give the date, home team, full time score as n-m, then away team
where n is the number of goals scored by the home team 
and m in the number of goals scored by the away team. 
Sort these matches, firstly by highest scoring game then by earliest date  for ties.
Hint: use the CONCAT() function to build the full time score
*/

-- In which matches were more than 4 goals scored? 

-- Is there an advantage to playing at home? 
-- How many home wins and away wins?  


/*
**************
Advanced Level
**************
*/

-- Did any home team play two matches on the same day?

-- Do the dates in the FootballCalendar table cover the entire period of the 2018 and 2019 matches?
-- You can assume that the Calendar tables contains every date from the earliest to the latest date found


/*
Which dates had no matches?
Hint: Use the NOT EXISTS or the NOT IN clause
*/

/*
What was the average number of goals scored per match?
Hint: you will need to CAST the expression for the number of goals to a FLOAT so that AVG() returns an accurate result
*/

/*
-- Which matches had more than the average number of goals?
-- Hint: use a subquery in the WHERE clause
*/

/*
Get the dates of the latest three home matches for each team
Write using  Window functions.  
Have a look at an alternative approach using CROSS APPLY in the Final SQL script
*/
