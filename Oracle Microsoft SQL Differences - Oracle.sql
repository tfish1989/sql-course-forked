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
SELECT 'Hello' AS Greeting FROM DUAL;

/*
Restricting the number of rows returned
-	Oracle FETCH FIRST | NEXT <n> ROWS ONLY
-	T-SQL, use TOP <n>
*/

SELECT
       *
FROM Message
FETCH NEXT 10 ROWS ONLY;

/*
Table Aliases and AS
In Oracle SQL, do not use AS in the table alias definition. For example
…FROM MessageData AS m – not correct
…FROM MessageData  m –  correct
*/

SELECT m.MessageId,
       m.ReceivedDate,
       m.Region,
       m.Category,
       m.Movement
FROM Message m;

/*
Defining columns
Oracle SQL – use “ “ to define column – note this will make it case-sensitive.  Best not to do this -> better to ensure no spaces in table or column names.
T SQL – use [ ] to define column but can also use “”
*/

SELECT m.MessageId AS "MessageIdentifier",
       m.ReceivedDate AS "Received Date",
       m.Region,
       m.Category,
       m.Movement
FROM Message m;



/*
Concatenating strings
Oracle CONCAT() only takes two arguments.  Better to use the || concatenation operator.
T-SQL CONCAT()  takes several arguments.  Or use the + concatenation operator.

*/
/*
 * Oracle version
-- Use || as the concatenation operator.  Note that this implicity converts datatypes to string
-- Oracle CONCAT can only take two arguments so we need to nest these
 */
SELECT m.MessageId AS "MessageIdentifier",
       m.ReceivedDate || m.Region || m.Category || m.Movement AS CombinedColumnOperator,
       CONCAT(m.ReceivedDate, CONCAT(m.Region, CONCAT(m.Category, m.MOVEMENT))) AS CombinedColumnConcat
FROM Message m;
 
/*
 * *** DATE FUNCTIONS ***
 */

/*
Casting VARCHAR to Date datatype
T-SQL will implicitly cast a date string such as ‘2022-09-27’ to a date datatype.  
Oracle requires the TO_DATE() function or the DATE keyword to do this explicitly 
*/

SELECT TO_DATE('2022-09-28', 'yyyy-mm-dd') + 1 AS LaterDate FROM Dual;
SELECT DATE '2022-09-28' + 1 AS LaterDate FROM Dual;

SELECT SYSTIMESTAMP AS TheDateTimeNow FROM dual;
SELECT SYSDATE AS TodaysDate FROM dual;


-- Format dates as strings

/*
 * Oracle uses TO_CHAR()
-- See https://www.databasestar.com/oracle-to_char/ for example format masks
 */
SELECT m.MessageId,
       m.ReceivedDate,
       TO_CHAR(m.ReceivedDate, 'DAY') AS ReceivedWeekDay
FROM Message m;

SELECT TO_CHAR(DATE'2022-01-18', 'DD-MON-YY') AS DateString FROM DUAL;
SELECT TO_CHAR(DATE'2022-01-18', 'DAY DD-MONTH-YY') AS DateString FROM DUAL;
 

/*
 * Oracle near equivalent to DATEPART() is EXTRACT()
-- See https://database.guide/extract-datetime-function-in-oracle/ for list of date parts to extract
 */
SELECT m.MessageId,
       m.ReceivedDate,
       EXTRACT(DAY FROM m.ReceivedDate) AS ReceivedWeekDay,
       EXTRACT(MONTH FROM m.ReceivedDate) AS ReceivedMonth
FROM Message m;
 
/*
Add intervals (days, weeks, months,..) to a date
T-SQL's DATEADD() and Oracle's ADD_MONTHS()
Note – 
•	In T-SQL, DATEADD() takes interval argument, can be MONTH, YEAR etc
•	In Oracle there is no ADD_YEARS function, use ADD_MONTHS and multiply by 12
•	In both can add days with + 1
DATEADD adds an interval to a date
Note that SQL will understand a string with a yyyy-mm-dd format as a date
*/

SELECT m.MessageId,
       m.ReceivedDate,
       ADD_MONTHS(m.ReceivedDate, 1) AS DueDate,
       m.Movement
FROM Message m;

/*
 * Oracle version has no exact equivalent to DATEDIFF().  Here are some near alternatives  
 */
--Note this returns a negative number.  start and end date arguments in reverse order to T-SQL 
SELECT MONTHS_BETWEEN(DATE'2022-06-10', DATE'2022-07-10') AS NumberOfMonths FROM DUAL;
SELECT DATE'2022-07-10' - DATE'2022-06-10' AS NumberOfDays FROM DUAL;


/*
*** General functions ***
*/

/*
T-SQL's ISNULL() function and Oracle's NVL() function are equivalent
*/
SELECT
m.region,
NVL(m.Region, 'n/a') AS TheRegion
FROM Message m;

/*
*** String functions ***
*/

/*
T-SQL's LEN() function and Oracle's LENGTH() function are equivalent
*/
SELECT
	m.REGION,
	LENGTH(m.REGION) AS RegionLength
FROM MESSAGE m;

/*
T-SQL's SUBSTRING() function and Oracle's SUBSTR() function are near equivalent
*/
SELECT SUBSTR('sql course', 2) AS Fragment FROM DUAL;
SELECT SUBSTR('sql course', 2, 4) AS Fragment FROM DUAL;

/*
T-SQL's CHARINDEX(), PATINDEX() functions and Oracle's INSTR() function are near equivalents
*/
SELECT INSTR('work hard, play hard', 'hard') AS Position FROM DUAL;
SELECT INSTR('work hard, play hard', 'hard', 10) AS Position FROM DUAL;
SELECT INSTR('work hard, play hard', 'hard', 1, 1) AS Position FROM DUAL; -- first occurrence
SELECT INSTR('work hard, play hard', 'hard', 1, 2) AS Position FROM DUAL; -- second occurrence
SELECT INSTR('work hard, play hard', 'hard', 1, 3) AS Position FROM DUAL; -- no third occurrence
SELECT INSTR('work hard, play hard', 'hard', -1) AS Position FROM DUAL; -- SEARCH FROM end


/*
 *** Maths functions ***
 * There are a few some difference in names and arguments and order of arguments
Examples:
LOG() -> LN
LOG10() -> LOG
% -> MOD()
CEILING() -> CEIL
*/
SELECT LOG(10, 100) FROM DUAL;
SELECT LOG(10, 1000) FROM DUAL;

SELECT LN (100) FROM DUAL;
SELECT LN(1000) FROM DUAL;

SELECT MOD(5,2) FROM DUAL;
SELECT MOD(6,2) FROM DUAL;

SELECT CEIL (5.3) FROM DUAL;
