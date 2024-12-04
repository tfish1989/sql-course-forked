/*
Land Registry Case Study
This uses public data of property sales in England from the Land Registry at https://www.gov.uk/government/statistical-data-sets/price-paid-data-downloads
The data has been filtered to properties in the London SW12 postcode  
*/

-- How many sales? 

/*
How many sales in each property type?
Order the rows in the result set by number of sales (highest first)
*/

/*
How many sales in each year?
Since the year of the sales is not a column in the table, calculate it with the YEAR() function
Order the rows in the result set by Year (earliest first)
*/
SELECT YEAR('2022-09-21') AS TheYear;
SELECT TOP 5 YEAR(P.TransactionDate) YearSold FROM PricePaidSW12 p;

-- What was the total market value in £ Millions of all the sales each year?

-- What are the earliest and latest dates of a sale?

-- How many different property types are there?

-- List all the sales in 2018 between £400,000 and £500,000 in Cambray Road (a street in SW12)

/*
1.  List the 25 latest sales in Ormeley Road with the following fields: TransactionDate, Price, PostCode, PAON 
2. Join on PropertyTypeLookup to get the PropertyTypeName
3.  Use a CASE statement for PropertyTypeName column
*/


/*
List properties that have been sold three times or more in the last ten years.  
Assume that a property is uniquely identified by the combination of the postcode, PAON and SAON fields.
*/


-- Note  that we can get today's date and a date 10 years ago with the following statements
SELECT CURRENT_TIMESTAMP;
SELECT CAST(CURRENT_TIMESTAMP AS DATE);

--SELECT CURRENT_TIMESTAMP FROM DUAL; -- Oracle
--SELECT TO_DATE(TO_CHAR(CURRENT_TIMESTAMP, 'YYYY-MON-DD'), 'YYYY-MON-DD') AS TheDate FROM DUAL; -- Oracle

SELECT DATEADD(YEAR, -10, CAST(CURRENT_TIMESTAMP AS DATE));
--SELECT ADD_MONTHS(CURRENT_TIMESTAMP, -120) FROM DUAL; -- Oracle


-- List properties

/*
Count properties by the number of times sold 
How many properties were sold once, twice, three times etc.
This is a two step process
(1) List properties sold in the last 10 years - columns required are Postcode, PAON, SAON and NumberOfSales
(2) Count the properties grouping by the NumberOfSales
*/

-- Option 1: Use a subquery

-- Option 2: Use WITH and a CTE

-- Option 3: Use a temp table


-- Which properties were flipped more than 8 times?
