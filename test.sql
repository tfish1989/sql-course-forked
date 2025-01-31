/*
This sql fie used to test ideas and connections to the database
*/

SELECT *
FROM PatientStay ps
WHERE ps.AdmittedDate >= '2024-02-27';

select top 10
    *
from PricePaidSW12

-- Select rows from a Table or View 'patientstay' in schema 'dbo'
SELECT *
FROM dbo.PatientStay ps
WHERE ps.Hospital = 'PRUH'

SELECT
    *
FROM
    PatientStay ps