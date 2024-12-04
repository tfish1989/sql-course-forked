/*
Subqueries Exercise 2 - Correlated

This exercise will use two related tables
* PricePaidSW12 - sales of properties in London SW12 from 1995 to 2019. 
* PropertyTypeLookup - a lookup table on the PropertyType column of PricePaidSW12.  This contains a one letter code e.g. 'D'.  
  The PropertyTypeLookup has a column PropertyTypeCode with matching values and a column PropertyTypeName with the description e.g. 'Detached'

In this example we will focus sales in  a particular street, Ranmere Street
*/

-- List properties sold in Ranmere Street
SELECT
	pp.TransactionID
	, pp.TransactionDate 
	, pp.Price 
	, pp.PropertyType
	, pp.PAON
	, pp.Street 
FROM
	PricePaidSW12 pp
WHERE
	pp.Street = 'Ranmere Street'

-- Get the average price of properties sold in Ranmere Street
SELECT
	AVG(pp.Price)
FROM
	PricePaidSW12 pp
WHERE
	pp.Street = 'Ranmere Street';

-- Which property types have not been sold in Ranmere Street? (use a correlated subquery to answer this)

SELECT
	ptl.PropertyTypeName
FROM
	PropertyTypeLookup ptl
	-- complete the query below here

	
-- List properties sold for more than the average price in the street -  for each and every street in SW12
-- Use correlated subqueries both in the column list and in the WHERE clause
SELECT
	pp.TransactionDate
	, pp.PAON
	, pp.SAON
	, pp.Price
	, pp.Street
	, 'write the subquery here' AS AveragePriceOnStreet
FROM PricePaidSW12 pp
-- 'write the subquery here'
ORDER BY pp.Street, pp.Price;


