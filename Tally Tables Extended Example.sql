/*

This uses tally tables and CROSS joins to solve a common challenge.
We will use the Tally table in the course database
Create a table with a row for every year and month that a drug is licensed  based on  a period table

The challenge comes from a scenario described by a student
They have a table of license periods for drugs.
Drugs are licensed between a start year month and end year month
e.g. Drug A is licensed from May 2022 to the current month (since its end year month is NULL) 

The goal is to create a table that has a row for every month that a drug is licensed.
      
 */
-- We simulated the initial data in the temporary #DrugLicensePeriod table

DROP TABLE IF EXISTS #DrugLicensePeriod;

WITH cte (YearStart, MonthStart, YearEnd, MonthEnd, Drug)
AS (
select 
	* 
FROM (
	VALUES 
	(2022, 5, NULL, NULL, 'A'), -- Alpha start continuous license from May 2022
	(2022, 3, 2022, 9, 'B'), -- Bravo licensed from March to September 2022 inclusive
	(2022, 1, 2022, 6, 'C'),  -- Charlie was licensed from January to June 2022   inclusive
	(2023, 4, NULL, NULL, 'C') -- Charlie relicensed in Apr 2023 and is still under license
	) T (YearStart, MonthStart, YearEnd, MonthEnd, Drug)
)
SELECT 
	* 
INTO 
	#DrugLicensePeriod
FROM 
cte;

SELECT * FROM #DrugLicensePeriod;

-- useful numbers Tally table - Google "SQL Tally Table" for more


-- Create a temp table of years from the Tally table
DROP TABLE IF EXISTS #Year;

SELECT 
	2000 + n  AS Year
INTO #Year
	from Tally
where n between 21 and 24

SELECT * FROM #Year

-- Create a temp table of months
DROP TABLE IF EXISTS #MonthNumber;

SELECT 
	n  AS MonthNumber
INTO #MonthNumber
	from Tally
where n between 1 and 12;

SELECT * FROM #MonthNumber;

/*
Create a table of all possible compination of months / drugs
Later we will use #DrugLicensePeriod to only keep the rows for months when the drug is lircensed.
 */

DROP TABLE IF EXISTS #YearMonth;

SELECT * 
INTO #YearMonth
FROM #Year CROSS JOIN #MonthNumber ;

SELECT * FROM #YearMonth;

-- Use CROSS JOIN to generate all the possible combinations to create a table with a row for each month for each drug
-- A drug can have several rows in the #DrugLicensePeriod table so the DISTINCT is needed.

DROP TABLE IF EXISTS #FinalCrossData;

SELECT
	ym.[Year]
	, ym.MonthNumber
	, rd.Drug
INTO #FinalCrossData
FROM
	#YearMonth ym
CROSS JOIN (SELECT DISTINCT Drug FROM #DrugLicensePeriod) rd;

SELECT * FROM #FinalCrossData;

SELECT COUNT(*) AS NumberOfRows FROM #FinalCrossData;

-- Filter combinations to those rows where a drug is being produced
SELECT 
	r.Drug
	, f.[Year]
	, f.MonthNumber
FROM #FinalCrossData f
INNER JOIN #DrugLicensePeriod r ON f.Drug = r.Drug 
WHERE
	((f.[Year] > r.YearStart) OR (f.[Year] = r.YearStart AND f.MonthNumber >= r.MonthStart))
	AND 
	(
	((f.[Year] < r.YearEnd) OR (f.[Year] = r.YearEnd and f.MonthNumber <= r.MonthEnd))
	OR 
	r.YearEnd IS NULL
	)
ORDER BY
	r.Drug
	, f.[Year]
	, f.MonthNumber;

