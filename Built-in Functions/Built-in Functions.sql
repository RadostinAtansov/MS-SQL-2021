Built-in Functions
----------1----------

SELECT FirstName, LastName
  FROM Employees
 WHERE FirstName LIKE 'sa%'

----------2----------

SELECT FirstName, LastName
  FROM Employees
 WHERE LastName LIKE '%ei%'

----------3---------

SELECT FirstName
FROM Employees
WHERE DepartmentID = 3 OR DepartmentID = 10 --AND HireDate BETWEEN 1995 AND 2000

----------4----------

SELECT FirstName, LastName
FROM Employees
WHERE JobTitle NOT LIKE '%engineer%'

----------5----------

SELECT [Name]
FROM Towns
WHERE LEN([Name]) = 5 OR LEN([Name]) = 6
ORDER BY [Name]

----------6----------

SELECT *
FROM Towns
WHERE [Name] LIKE ('[MKBE]%')
ORDER BY [Name]

----------7----------

SELECT *
FROM Towns
WHERE [Name] LIKE ('[^RBD]%')
ORDER BY [Name]

----------8----------

CREATE VIEW V_EmployeesHiredAfter2000 AS
SELECT FirstName, LastName
FROM Employees
WHERE DATEPART(YEAR, HireDate ) > '2000'

----------9----------

SELECT FirstName, LastName
FROM Employees
WHERE LEN(LastName) = 5

----------10---------

SELECT EmployeeID, FirstName, LastName, Salary, DENSE_RANK() OVER (PARTITION BY Salary ORDER BY EmployeeID)
FROM Employees	
WHERE Salary BETWEEN 10000 AND 50000
ORDER BY Salary DESC

----------11---------

SELECT * FROM(
SELECT EmployeeID, FirstName, LastName, Salary, DENSE_RANK() OVER (PARTITION BY Salary ORDER BY EmployeeID) AS Ranked
FROM Employees
WHERE Salary BETWEEN 10000 AND 50000
) AS RESULT
WHERE Ranked = 2
ORDER BY Salary DESC

----------12---------

SELECT CountryName, IsoCode
FROM Countries
WHERE CountryName LIKE '%a%a%a%' 
ORDER BY IsoCode

----------13---------

SELECT PeakName, RiverName, LOWER(LEFT(PeakName, LEN(PeakName) - 1) ) + LOWER(RiverName) AS Mix
FROM Rivers, Peaks
WHERE RIGHT(PeakName, 1) = LEFT(RiverName, 1)
ORDER BY Mix

----------14---------

SELECT TOP(50)Name, CONVERT(varchar, Start, 23) AS [Start]
FROM Games
WHERE DATEPART(YEAR, Start) = 2011 OR DATEPART(YEAR, Start) = 2012
ORDER BY [Start], [Name]

----------15---------

SELECT UserName, SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email)) AS EmailProvider
FROM Users
ORDER BY EmailProvider, Username

----------16-------

SELECT Username, IpAddress
FROM Users
WHERE IpAddress LIKE '___.1%.%.___'
ORDER BY Username

----------17---------

SELECT [Name],
CASE
	WHEN DATEPART(HOUR, Start) >= 0 AND DATEPART(HOUR, Start) < 12 THEN 'Morning'
	WHEN DATEPART(HOUR, Start) >= 12 AND DATEPART(HOUR, Start) < 18 THEN 'Afternoon'
	WHEN DATEPART(HOUR, Start) >= 18 AND DATEPART(HOUR, Start) < 24 THEN 'Evening'

END AS [Part of the Day],
CASE
	WHEN Duration <= 3 THEN 'Extra Short'
	WHEN Duration BETWEEN 4 AND 6 THEN 'Short'
	WHEN Duration > 6 THEN 'Long'
	WHEN Duration IS NULL THEN 'Extra Long'	
END AS Duration
FROM Games
ORDER BY [Name], Duration

----------18---------

SELECT ProductName, OrderDate, DATEADD(DAY, 3, OrderDate) AS [Pay Due], 
DATEADD(MONTH, 1, OrderDate) AS [Deliver Due]
FROM Orders
