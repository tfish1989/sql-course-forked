/*
Foundation Lab
Creating Objects in SQL
Purpose: Create objects in SQL and set all the properties to achieve a robust well performing database: tables, views, sequences

Each comment describes a task
Write  SQL statement(s)  for the task under the comment

The script must be able to run repeatedly (which is why you will need to drop tables so that you can recreate them)
The SQL script must be able to run completely and correctly on another database.
*/

/*
Tidy up any previous runs by dropping (deleting) any objects that this script creates.  
Use the IF EXISTS clause for brevity.
*/

/*
Create an Address  table with columns: 
    AddressKey INT
    HouseNumber INT
    StreetName VARCHAR(100)
    PostCode VARCHAR(8)
Set the AddressKey column as the primary key
Set the AddressKey column as an identity column
All columns must be not NULL
*/


/*
Add three  rows to the table for the addresses
with the following values for HouseNumber, StreetName and PostCode
    32, 'Acacia Avenue', 'SL1 1AA'
    52, 'Cambray Road', 'SW12 9ES'
    10, 'Downing Street', 'SW1A 2AA'
Use a single statement, not three statements
*/


-- Check that the data in the Address tables is as expected
SELECT * FROM Address;

/*
Create a view, named AddressView,  that has columns for the HouseNumber and PostCode columns only
*/


-- Check the view works as expected.
SELECT * FROM AddressView;

/*
Create a Person table with columns: 
    PersonKey INT 
    AddressKey  INT 
    FirstName VARCHAR(100),
    LastName VARCHAR(100)
    DateOfBirth DATE  
Set the PersonKey column as the primary key.
Set the PersonKey column as an identity column
All columns must be NOT NULL.
*/


-- Check that the rows are now in the Person table
SELECT * FROM Person;

/*
Create a foreign key relationship 
so that AddressKey in the Person table references the AddressKey column in the Address table. 
*/
--ALTER TABLE Person ADD FOREIGN KEY (AddressKey) REFERENCES Address (AddressKey);

/*
Add two sample rows to the table
* Boris Johnson in Downing Street (use variables)
* Theresa May in Cambray Road (use a SQL sub query)
*/


-- Check that the Person table now has these two rows of data.
SELECT * FROM Person;

/*
Show that the foreign key constraint is active
Try insert a row with a value for Addresskey that is not in the Address table
e.g. Kier Starmer, born on '1963-01-19', with AddressKey 12345
Note the error message
*/

-- Create a PersonView view that the FirstName and LastName (but not the DateOfBirth)

-- Extend the view to include the House Number and PostCode from the Address table

-- Check that the view is working correctly
SELECT * FROM PersonView;

