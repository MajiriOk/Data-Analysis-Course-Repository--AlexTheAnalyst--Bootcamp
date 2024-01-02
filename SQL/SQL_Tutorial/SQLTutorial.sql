/* Creating a Table */

CREATE TABLE EmployeeDemographics
(
EmployeeID int,
FirstName varchar(50),
LastName varchar(50),
Age int,
Gender varchar(50)
)

CREATE TABLE EmployeeSalary
(
EmployeeID int,
JobTitle varchar(50),
Salary int
)

CREATE TABLE WarehouseEmployeeDemographics
(
EmployeeID int,
FirstName varchar(50),
LastName varchar(50),
Age int,
Gender varchar(50)
)

/* Inserting Values into a Table */

INSERT INTO EmployeeDemographics VALUES

(1001, 'Jim', 'Crow', 24, 'Male'),
(1002, 'Sean','Taylor', 30, 'Male'),
(1003, 'Harper', 'Stevens', 45, 'Female'),
(1004, 'Chris', 'Bright', 50, 'Male'),
(1005, 'Faith', 'Evans', 23, 'Female'),
(1006, 'Sylvia', 'Mikal', 27, 'Female'),
(1007, 'Ruth', 'Maple', 30, 'Female'),
(1008, 'Shauna', 'McFried', 43, 'Female'),
(1009, 'Paul', 'Fred', 29, 'Male')

INSERT INTO EmployeeDemographics VALUES
(1010, 'Holly', 'Flake', NULL, NULL),
(NULL, 'Myron', 'Penny', 33, 'Male'),
(1012, 'Rashad', 'Batemann', NULL, 'Male')


INSERT INTO EmployeeSalary VALUES

(1001, 'Salesman', 45000),
(1002, 'Receptionist', 36000),
(1003, 'Accountant', 47000),
(1004, 'Salesman', 50000),
(1005, 'HR', 65000),
(1006, 'Regional Manager', 65000),
(1007, 'Supplier Relations', 41000),
(1008, 'Accountant', 48000),
(1009, 'Salesman', 42000)

INSERT INTO EmployeeSalary VALUES
(1010, NULL, 47000),
(1011, NULL, 43000),
(NULL, 'Accountant', 48000)

INSERT INTO WarehouseEmployeeDemographics VALUES
(1013, 'Curtis', 'Love', NULL, 'Male'),
(1050, 'Pennel', 'Suul', 31, 'Male'),
(1051, 'Martin', 'Cohen', 40, 'Male'),
(1052, 'Val', 'Bell', 38, 'Female'),
(1053, 'Bruce', 'Aseme', 39, 'Male'),
(1054, 'Kady', 'Simpson', 41, 'Female')


/*
SELECT Statement
*, TOP, DISTINCT, COUNT, AS, MAX, MIN, AVG
*/

SELECT *
FROM EmployeeDemographics

SELECT TOP 5 *
FROM EmployeeDemographics

SELECT DISTINCT(Gender)
FROM EmployeeDemographics

SELECT COUNT(LastName) AS LastNameCount
FROM EmployeeDemographics

SELECT MAX(Salary) AS MaximumSalary
FROM EmployeeSalary

SELECT MIN(Salary) AS MinimumSalary
FROM EmployeeSalary

SELECT AVG(Salary) AS AverageSalary
FROM EmployeeSalary

/*
WHERE Statement
=, <>, <, >, AND, OR, LIKE, NULL, NOT NULL, IN
*/

SELECT *
FROM EmployeeDemographics
WHERE FirstName = 'Paul'

SELECT *
FROM EmployeeDemographics
WHERE FirstName <> 'Paul'

SELECT *
FROM EmployeeDemographics
WHERE Age >= 30

SELECT *
FROM EmployeeDemographics
WHERE Age < 30

SELECT *
FROM EmployeeDemographics
WHERE Age <= 30 AND Gender = 'Male'

SELECT *
FROM EmployeeDemographics
WHERE Age <= 30 OR Gender = 'Male'

SELECT *
FROM EmployeeDemographics
WHERE LastName LIKE '%A%'

SELECT *
FROM EmployeeDemographics
WHERE Age IS NOT NULL

SELECT *
FROM EmployeeDemographics
WHERE FirstName IN ('Faith', 'Ruth', 'Paul', 'Jim')

/*
GROUP BY, ORDER BY
*/
SELECT *
FROM EmployeeDemographics

SELECT Gender, COUNT(Gender) AS Gender_Count
FROM EmployeeDemographics 
GROUP BY Gender

SELECT Gender, COUNT(Gender) AS Gender_Count
FROM EmployeeDemographics 
WHERE Age > 30
GROUP BY Gender

SELECT Gender, Age, COUNT(Gender) AS Gender_Count
FROM EmployeeDemographics 
GROUP BY Gender, Age

SELECT Gender, COUNT(Gender) AS Gender_Count
FROM EmployeeDemographics 
WHERE Age > 30
GROUP BY Gender
ORDER BY Gender_Count

SELECT *
FROM EmployeeDemographics
ORDER BY Age DESC

SELECT *
FROM EmployeeDemographics
ORDER BY 4 DESC, 5 ASC


