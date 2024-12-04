/*
 * Tally Tables Exercise

 * The temporary table, #PatientAdmission, has values for dates between the 1st and 8th January inclusive
 * But not all dates are present

 Act as a SQL expert.   
 A table PatientAdmission with columns AdmittedDate DATE and  NumAdmissions INT  
 should have rows with continuous dates from the earliest date (say 1 jan 2024) and the latest date (say 31 Dec 2024) 
 There should be no gaps. how do i list any gaps
 I have a Tally table with column N with values between 1 and 10000.  Please use that in your response


 */

DROP TABLE IF EXISTS #PatientAdmission;
CREATE TABLE #PatientAdmission (AdmittedDate DATE, NumAdmissions INT);
INSERT INTO #PatientAdmission (AdmittedDate, NumAdmissions) VALUES ('2024-01-01', 5)
INSERT INTO #PatientAdmission (AdmittedDate, NumAdmissions) VALUES ('2024-01-02', 6)
INSERT INTO #PatientAdmission (AdmittedDate, NumAdmissions) VALUES ('2024-01-03', 4)
INSERT INTO #PatientAdmission (AdmittedDate, NumAdmissions) VALUES ('2024-01-05', 2)
INSERT INTO #PatientAdmission (AdmittedDate, NumAdmissions) VALUES ('2024-01-08', 2)
SELECT * FROM #PatientAdmission

/*
 * Exercise: create a resultset that has a row for all dates in that period 
 * of 8 days with NumAdmissions set to 0 for missing dates. 
 */

DECLARE @StartDate DATE;
DECLARE @EndDate DATE;
SELECT @StartDate = DATEFROMPARTS(2024, 1, 1);
SELECT @EndDate = DATEFROMPARTS(2024, 1, 8);
WITH ContiguousDateRange ([AdmittedDate]) AS
(
	SELECT 
	DATEADD(DAY, N-1, @StartDate) AS AdmittedDate
FROM 
	Tally
WHERE
	N <= DATEDIFF(DAY, @StartDate, @EndDate) + 1
)
SELECT 
	cdr.[AdmittedDate]
	, COALESCE (pa.Numadmissions, 0) AS NumAdmissions
FROM ContiguousDateRange cdr LEFT JOIN #PatientAdmission pa ON cdr.[AdmittedDate] = pa.[AdmittedDate]
ORDER BY cdr.[AdmittedDate];

/*
 * Exercise: list the dates that have no patient admissions
*/

DECLARE @StartDate DATE;
DECLARE @EndDate DATE;
SELECT @StartDate = DATEFROMPARTS(2024, 1, 1);
SELECT @EndDate = DATEFROMPARTS(2024, 1, 8);
WITH ContiguousDateRange ([AdmittedDate]) AS
(
	SELECT 
	DATEADD(DAY, N-1, @StartDate) AS AdmittedDate
FROM 
	Tally
WHERE
	N <= DATEDIFF(DAY, @StartDate, @EndDate) + 1
)
SELECT 
	cdr.[AdmittedDate]
FROM ContiguousDateRange cdr LEFT JOIN #PatientAdmission pa ON cdr.[AdmittedDate] = pa.[AdmittedDate]
WHERE pa.NumAdmissions IS NULL
ORDER BY cdr.[AdmittedDate];

