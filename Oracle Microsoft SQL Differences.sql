/*
Oracle Microsoft SQL Differences.sql

Learning Objectives: 
Highlight the main differences between Microsoft T-SQL and Oracle SQL
For each difference, provide two example SQL statements, one in Orcale and one in T-SQL, that are equivalent i.e. produce the  same result

A note about terminanting statements.
Oracle SQL statements always need the terminating semi-colon.  With T-SQL, this is optional (apart from before WITH).  
Best practice: always use ; to terminate a statement, even in T-SQL.
*/

/*
Oracle must always have a FROM clause, even when SELECT of a literal. Use the dummy table DUAL
*/
SELECT 'Hello' AS Greeting;
/* 
Oracle version
SELECT 'Hello' AS Greeting FROM DUAL;
*/

/*
Restricting the number of rows returned
-	Oracle FETCH FIRST | NEXT <n> ROWS ONLY
-	T-SQL, use TOP <n>
*/

SELECT TOP 10
       *
FROM Message;

/* 
Oracle version

SELECT
       *
FROM Message
FETCH NEXT 10 ROWS ONLY;
*/

/*
Table Aliases and AS
In Oracle SQL, do not use AS in the table alias definition. For example
�FROM MessageData AS m � not correct
�FROM MessageData  m �  correct
*/
SELECT
	m.MessageId
	, m.ReceivedDate
	, m.Region
	, m.Category
	, m.Movement
FROM
	Message AS m;

/* 
Oracle version

SELECT m.MessageId,
       m.ReceivedDate,
       m.Region,
       m.Category,
       m.Movement
FROM Message m;
*/

/*
Defining columns
Oracle SQL � use � � to define column � note this will make it case-sensitive.  Best not to do this -> better to ensure no spaces in table or column names.
T SQL � use [ ] to define column but can also use ��
*/

SELECT
	m.MessageId AS "MessageIdentifier"
	, m.ReceivedDate AS "Received Date"
	, m.Region
	, m.Category
	, m.Movement
FROM
	Message m;

SELECT
	m.MessageId AS MessageIdentifier
	, m.ReceivedDate AS [Received Date]
	, m.Region
	, m.Category
	, m.Movement
FROM
	Message m;

/* 
Oracle version

SELECT m.MessageId AS "MessageIdentifier",
       m.ReceivedDate AS "Received Date",
       m.Region,
       m.Category,
       m.Movement
FROM Message m;
*/


/*
Concatenating strings
Oracle CONCAT() only takes two arguments.  Better to use the || concatenation operator.
T-SQL CONCAT()  takes several arguments.  Or use the + concatenation operator.

*/
SELECT m.MessageId AS "MessageIdentifier"
       , CAST(m.ReceivedDate AS VARCHAR) + m.Region + m.Category + CAST(m.Movement AS VARCHAR) AS CombinedColumnOperator
       , CONCAT(m.ReceivedDate, m.Region, m.Category, m.Movement) AS CombinedColumnConcat
FROM Message m;

/*
 * Oracle version
-- Use || as the concatenation operator.  Note that this implicity converts datatypes to string
-- Oracle CONCAT can only take two arguments so we need to nest these
SELECT m.MessageId AS "MessageIdentifier",
       m.ReceivedDate || m.Region || m.Category || m.Movement AS CombinedColumnOperator,
       CONCAT(m.ReceivedDate, CONCAT(m.Region, CONCAT(m.Category, m.MOVEMENT))) AS CombinedColumnConcat
FROM Message m;
 */
 
/*
 * *** DATE FUNCTIONS ***
 */

/*
Casting VARCHAR to Date datatype
T-SQL will implicitly cast a date string such as �2022-09-27� to a date datatype.  
Oracle requires the TO_DATE() function or the DATE keyword to do this explicitly 
*/

SELECT DATEADD(DAY, 1, '2022-09-29') AS LaterDate;
/* 
Oracle version
SELECT TO_DATE('2022-09-28', 'yyyy-mm-dd') + 1 AS LaterDate FROM Dual;
SELECT DATE '2022-09-28' + 1 AS LaterDate FROM Dual;
*/

-- CURRENT_TIMESTAMP and GETDATE() return the current date and time
-- CAST a datetime value to a date datatype to return the date (without any time component)
SELECT CURRENT_TIMESTAMP AS TheDateTimeNow;
SELECT GETDATE() AS TheDateTimeNow;
SELECT CAST(GETDATE() AS DATE) AS TodaysDate;

/*
 * Oracle version
SELECT SYSTIMESTAMP AS TheDateTimeNow FROM dual;
SELECT SYSDATE AS TodaysDate FROM dual;
 */


-- Format dates as strings

-- T-SQL's DATENAME() and FORMAT() returns part of a date as a string
-- See https://www.w3schools.com/sql/func_sqlserver_datename.asp for interval argument examples
SELECT m.MessageId
       , m.ReceivedDate
       , DATENAME(WEEKDAY, m.ReceivedDate) AS ReceivedWeekDay
FROM Message m;

-- FORMAT returns a string given a data and a format specifier 
SELECT FORMAT(DATEFROMPARTS(2022, 1, 18), 'dd-MMM-yyyy');
SELECT FORMAT(DATEFROMPARTS(2022, 1, 18), 'ddd dd-MMMM-yy');

/*
 * Oracle uses TO_CHAR()
-- See https://www.databasestar.com/oracle-to_char/ for example format masks
SELECT m.MessageId,
       m.ReceivedDate,
       TO_CHAR(m.ReceivedDate, 'DAY') AS ReceivedWeekDay
FROM Message m;

SELECT TO_CHAR(DATE'2022-01-18', 'DD-MON-YY') AS DateString FROM DUAL;
SELECT TO_CHAR(DATE'2022-01-18', 'DAY DD-MONTH-YY') AS DateString FROM DUAL;
 */
 
-- T-SQL's DATEPART() returns part of a date as a number
SELECT m.MessageId
       , m.ReceivedDate
       , DATEPART(WEEKDAY, m.ReceivedDate) AS ReceivedWeekDay
FROM Message m;

/*
 * Oracle near equivalent is EXTRACT()
-- See https://database.guide/extract-datetime-function-in-oracle/ for list of date parts to extract
SELECT m.MessageId,
       m.ReceivedDate,
       EXTRACT(DAY FROM m.ReceivedDate) AS ReceivedWeekDay,
       EXTRACT(MONTH FROM m.ReceivedDate) AS ReceivedMonth
FROM Message m;
 */
 
/*
Add intervals (days, weeks, months,..) to a date
T-SQL's DATEADD() and Oracle's ADD_MONTHS()
Note � 
�	In T-SQL, DATEADD() takes interval argument, can be MONTH, YEAR etc
�	In Oracle there is no ADD_YEARS function, use ADD_MONTHS and multiply by 12
�	In both can add days with + 1
DATEADD adds an interval to a date
Note that SQL will understand a string with a yyyy-mm-dd format as a date
*/
SELECT DATEADD(WEEK, 1, '2022-05-18');
SELECT DATEADD(MONTH, -2, '2022-05-18');

SELECT m.MessageId
       , m.ReceivedDate
       , DATEADD(MONTH, 1, m.ReceivedDate) AS DueDate
       , m.Movement
FROM Message m;

/* 
Oracle version

SELECT m.MessageId,
       m.ReceivedDate,
       ADD_MONTHS(m.ReceivedDate, 1) AS DueDate,
       m.Movement
FROM Message m;
*/

-- DATEDIFF() will return the number of intervals between two dates
SELECT DATEDIFF(DAY, '2022-06-10', '2022-07-10');
SELECT DATEDIFF(WEEK, '2022-06-10', '2022-07-10');
/*
 * Oracle version has no exact equivalent.  here are some near alternatives  

-- Note this returns a negative number.  start and end date arguments in reverse order to T-SQL 
SELECT MONTHS_BETWEEN(DATE'2022-06-10', DATE'2022-07-10') AS NumberOfMonths FROM DUAL;
SELECT DATE'2022-07-10' - DATE'2022-06-10' AS NumberOfDays FROM DUAL;
 */

-- DATEFROMPARTS() Returns a date given the year, month number and day of month
SELECT DATEFROMPARTS(2022, 5, 18) AS TheDate;
/*
Oracle version
There is no direct equivalent.  The nearest is:
SELECT TO_DATE('2022-05-18', 'yyyy-mm-dd') AS TheDate FROM dual;
*/

/*
*** General functions ***
*/

/*
T-SQL's ISNULL() function and Oracle's NVL() function are equivalent
*/
SELECT
	ISNULL('abc', 'n/a') AS Column1
	, ISNULL(NULL, 'n/a') AS Column2;

SELECT
	m.REGION
	,ISNULL(m.REGION, 'n/a') AS TheRegion
	,ISNULL(NULL, 'No region') AS TheRegion2
FROM
	Message m;

/* 
Oracle version
SELECT 
NVL('abc', 'n/a') AS Column1,
NVL(NULL, 'n/a') AS Column2
FROM DUAL;

SELECT
m.REGION,
NVL(m.REGION, 'n/a') AS TheRegion,
NVL(NULL, 'No region') AS TheRegion2
FROM Message m;
*/

/*
*** String functions ***
*/

/*
T-SQL's LEN() function and Oracle's LENGTH() function are equivalent
*/
SELECT
	m.REGION
	, LEN(m.REGION) AS RegionLength
FROM
	MESSAGE m;
/* 
Oracle version
SELECT
	m.REGION,
	LENGTH(m.REGION) AS RegionLength
FROM MESSAGE m;
*/

/*
T-SQL's SUBSTRING() function and Oracle's SUBSTR() function are near equivalent
*/
SELECT SUBSTRING('sql course', 2, 100) AS Fragment;
SELECT SUBSTRING('sql course', 2, 4) AS Fragment;
/* 
Oracle version
SELECT SUBSTR('sql course', 2) AS Fragment FROM DUAL;
SELECT SUBSTR('sql course', 2, 4) AS Fragment FROM DUAL;
*/

/*
T-SQL's CHARINDEX(), PATINDEX() functions and Oracle's INSTR() function are near equivalents
*/
SELECT CHARINDEX('hard', 'work hard, play hard') AS Position;
SELECT PATINDEX('%ha%', 'work hard, play hard') AS Position;
/* 
Oracle version
SELECT INSTR('work hard, play hard', 'hard') AS Position FROM DUAL;
SELECT INSTR('work hard, play hard', 'hard', 10) AS Position FROM DUAL;
SELECT INSTR('work hard, play hard', 'hard', 1, 1) AS Position FROM DUAL; -- first occurrence
SELECT INSTR('work hard, play hard', 'hard', 1, 2) AS Position FROM DUAL; -- second occurrence
SELECT INSTR('work hard, play hard', 'hard', 1, 3) AS Position FROM DUAL; -- no third occurrence
SELECT INSTR('work hard, play hard', 'hard', -1) AS Position FROM DUAL; -- SEARCH FROM end
*/


/*
 *** Maths functions ***
 * There are a few some difference in names and arguments and order of arguments
Examples:
LOG() -> LN
LOG10() -> LOG
% -> MOD()
CEILING() -> CEIL
*/
--natural logs
SELECT LOG(100);
SELECT LOG(1000);

-- LOGG TO BASE 10
SELECT LOG10(100);
SELECT LOG10(1000);

-- specify base
SELECT LOG(100, 4);
SELECT LOG(1000, 4);

SELECT 5 % 2;
SELECT 6 % 2;

SELECT CEILING (5.3);
/*
Oracle versions 
SELECT LOG(10, 100) FROM DUAL;
SELECT LOG(10, 1000) FROM DUAL;

SELECT LN (100) FROM DUAL;
SELECT LN(1000) FROM DUAL;

SELECT MOD(5,2) FROM DUAL;
SELECT MOD(6,2) FROM DUAL;

SELECT CEIL (5.3) FROM DUAL;
*/