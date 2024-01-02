/*
CTEs (COMMON TABLE EXPRESSION)
*/

-- EXAMPLE 1
WITH CTE_Employee AS
(
SELECT FirstName, LastName, Gender, Salary
, COUNT(Gender) OVER (PARTITION BY Gender) AS Total_Gender
,  AVG(Salary) OVER (PARTITION BY Gender) AS Avg_Salary
FROM EmployeeDemographics AS emp
JOIN EmployeeSalary AS sal
	ON emp.EmployeeID = sal.EmployeeID
WHERE Salary > '45000'
)
SELECT *
FROM CTE_Employee

-- EXAMPLE 2
WITH CTE_Employee AS
(
SELECT FirstName, LastName, Gender, Salary
, COUNT(Gender) OVER (PARTITION BY Gender) AS Total_Gender
,  AVG(Salary) OVER (PARTITION BY Gender) AS Avg_Salary
FROM EmployeeDemographics AS emp
JOIN EmployeeSalary AS sal
	ON emp.EmployeeID = sal.EmployeeID
WHERE Salary > '45000'
)
SELECT FirstName, Salary
FROM CTE_Employee



/*
TEMP TABLES
*/

CREATE TABLE #Temp_Employee (
EmployeeID int,
JobTitle varchar(100),
Salary int
)

SELECT *
FROM #Temp_Employee

INSERT INTO #Temp_Employee VALUES 
('1001', 'HR', '46000'),
('1002', 'Accountant', '48000'),
('1003', 'HR', '45000'),
('1004', 'Salesman', '47000'),
('1005', 'Head Of Department', '60000')

INSERT INTO #Temp_Employee
SELECT *
FROM EmployeeSalary

DROP TABLE IF EXISTS #Temp_Employee2
CREATE TABLE #Temp_Employee2 (
JobTitle varchar(50),
Employees_Per_Job int,
Avg_Age int,
Avg_Salary int
)

INSERT INTO #Temp_Employee2
SELECT JobTitle, COUNT(JobTitle), AVG(Age), AVG(Salary)
FROM EmployeeDemographics AS emp
JOIN EmployeeSalary AS sal
	ON emp.EmployeeID = sal.EmployeeID
WHERE JobTitle IS NOT NULL
GROUP BY JobTitle

SELECT *
FROM #Temp_Employee2


/*
String Functions : TRIM, LTRIM, RTRIP, Replace, Substring, UPPER, LOWER
-- DROP TABLE EmployeeErrors
*/

CREATE TABLE EmployeeErrors (
EmployeeID varchar(50),
FirstName varchar(50),
LastName varchar(50)
)

INSERT INTO EmployeeErrors VALUES
('1001   ', 'Jimbo', 'Halbert'),
('   1002', 'Pamela', 'Beasley'),
('1005', 'TOby', 'Flenderson - Fired')

SELECT *
FROM EmployeeErrors

-- Using TRIM, LTRIM, RTRIM

SELECT EmployeeID, TRIM(EmployeeID) AS IDTRIM
FROM EmployeeErrors

SELECT EmployeeID, LTRIM(EmployeeID) AS IDTRIM
FROM EmployeeErrors

SELECT EmployeeID, RTRIM(EmployeeID) AS IDTRIM
FROM EmployeeErrors

--Using Replace

SELECT LastName, REPLACE(LastName, '- Fired','') AS LastName_Fixed
FROM EmployeeErrors

-- Using Substring

SELECT SUBSTRING(FirstName, 1, 3)
FROM EmployeeErrors

SELECT SUBSTRING(FirstName, 3 , 3)
FROM EmployeeErrors

SELECT err.FirstName, dem.FirstName
FROM EmployeeErrors AS err
JOIN EmployeeDemographics AS dem
	ON err.FirstName = dem.FirstName

SELECT SUBSTRING(err.FirstName, 1, 3), SUBSTRING(dem.FirstName,1 ,3)
FROM EmployeeErrors AS err
JOIN EmployeeDemographics AS dem
	ON SUBSTRING(err.FirstName, 1, 3) = SUBSTRING(dem.FirstName,1 ,3)


-- Using UPPER and LOWER

SELECT FirstName, LOWER(FirstName)
FROM EmployeeErrors

SELECT FirstName, UPPER(FirstName)
FROM EmployeeErrors


/*
Stored Procedures
*/

CREATE PROCEDURE TEST
AS
SELECT *
FROM EmployeeDemographics

EXEC TEST
----------------------------------------------------------
CREATE PROCEDURE Temp_Employee
AS
CREATE TABLE #temp_Employee (
JobTitle varchar(50),
Employees_Per_Job int,
Avg_Age int,
Avg_Salary int
)

INSERT INTO #temp_Employee
SELECT JobTitle, COUNT(JobTitle), AVG(Age), AVG(Salary)
FROM EmployeeDemographics AS emp
JOIN EmployeeSalary AS sal
	ON emp.EmployeeID = sal.EmployeeID
WHERE JobTitle IS NOT NULL
GROUP BY JobTitle

SELECT *
FROM #temp_Employee

EXEC Temp_Employee 

EXEC Temp_Employee @JobTitle = 'Salesman'
-----------------------------------------------------------

/*
Subqueries (in the SELECT, FROM and WHERE Statements)
*/

SELECT *
FROM EmployeeSalary

-- Subquery in SELECT

SELECT EmployeeID, Salary, (SELECT AVG(Salary) FROM EmployeeSalary) AS All_Avg_Salary
FROM EmployeeSalary

-- Subquery with PARTITION BY

SELECT EmployeeID, Salary, AVG(Salary) OVER () AS All_Avg_Salary
FROM EmployeeSalary

-- Why GROUP BY doesn't work

SELECT EmployeeID, Salary, AVG(Salary) AS All_Avg_Salary
FROM EmployeeSalary
GROUP BY EmployeeID, Salary
ORDER BY 1,2

--Subquery in FROM

SELECT a.EmployeeID, All_Avg_Salary
FROM (SELECT EmployeeID, Salary, AVG(Salary) OVER () AS All_Avg_Salary
		FROM EmployeeSalary) AS a

--Subquery in WHERE

SELECT EmployeeID, JobTitle, Salary
FROM EmployeeSalary
WHERE EmployeeID IN (
		SELECT EmployeeID
		FROM EmployeeDemographics
		WHERE Age > 30)