Subqueries and Joins

----------1----------

SELECT TOP(5) e.EmployeeID, e.JobTitle, a.AddressID, a.AddressText
  FROM Employees AS e
  JOIN Addresses AS a ON e.AddressID = a.AddressID
  ORDER BY AddressID

----------2----------

SELECT TOP(50) e.FirstName, e.LastName, t.[Name], a.AddressText
  FROM Employees AS e
  JOIN Addresses AS a ON e.AddressID = a.AddressID
  JOIN Towns AS t ON t.TownID = a.TownID
  ORDER BY e.FirstName ASC, e.LastName ASC

----------3---------

SELECT e.EmployeeID, e.FirstName, e.LastName, d.[Name] AS 'DepartmentsName'
  FROM Employees AS e
  JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
  WHERE d.Name = 'Sales'
  ORDER BY e.EmployeeID ASC

----------4----------

SELECT TOP(5) e.EmployeeID, e.FirstName, e.Salary, d.Name
FROM Employees AS e
JOIN Departments AS d ON d.DepartmentID = e.DepartmentID
WHERE e.Salary > 15000
ORDER BY e.DepartmentID

----------5----------

SELECT [Name]
SELECT TOP(3) e.EmployeeID, FirstName
  FROM Employees AS e
  LEFT JOIN EmployeesProjects AS ep ON e.EmployeeID = ep.EmployeeID
  WHERE ep.EmployeeID IS NULL
  ORDER BY e.EmployeeID ASCWHERE LEN([Name]) = 5 OR LEN([Name]) = 6
ORDER BY [Name]

----------6----------

SELECT FirstName, LastName, HireDate, Name
  FROM Employees AS e
  JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
  WHERE HireDate > '1.1.1999' AND Name IN ('Sales', 'Finance')

----------7----------

SELECT TOP(5) e.EmployeeID, e.FirstName, p.Name
  FROM Employees AS e
  JOIN EmployeesProjects AS ep ON ep.EmployeeID = e.EmployeeID
  JOIN Projects AS p ON p.ProjectID = ep.ProjectID
  WHERE p.StartDate > '2002.08.13' AND p.StartDate IS NOT NULL
  ORDER BY ep.EmployeeID ASC

----------8----------

SELECT e.EmployeeID, e.FirstName,
CASE
	WHEN DATEPART(YEAR, p.StartDate) >= 2005 THEN NULL
	ELSE p.Name
END AS ProjectName
FROM Employees AS e
JOIN EmployeesProjects AS ep ON ep.EmployeeID = e.EmployeeID
JOIN Projects AS p ON p.ProjectID = ep.ProjectID
WHERE e.EmployeeID = 24

----------9----------

SELECT e.EmployeeID, e.FirstName, e.ManagerID, msgN.FirstName
  FROM Employees AS e
  JOIN Departments AS d ON d.DepartmentID = e.DepartmentID
  JOIN Employees AS msgN ON msgN.EmployeeID = e.ManagerID
  WHERE e.ManagerID = 3 OR e.ManagerID = 7
  ORDER BY e.EmployeeID ASC

----------10---------

SELECT TOP(50)emp.EmployeeID, emp.FirstName + ' ' + emp.LastName AS EmployeeName, msg.FirstName + ' ' + msg.LastName AS ManagerName, d.Name AS DepartmentName
  FROM Employees AS emp
  JOIN Departments AS d ON emp.DepartmentID = d.DepartmentID
  JOIN Employees AS msg ON msg.EmployeeID = emp.ManagerID
  ORDER BY emp.EmployeeID

----------11---------

SELECT TOP(1) AVG(Salary) AS AverageSalry
  FROM Employees AS e
  JOIN Departments AS d ON d.DepartmentID = e.DepartmentID
  GROUP BY e.DepartmentID
  ORDER BY AverageSalry

----------12---------

SELECT c.CountryCode, M.MountainRange, p.PeakName, p.Elevation
  FROM Countries AS c
  JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
  JOIN Mountains AS m ON mc.MountainId = m.Id
  JOIN Peaks AS p ON m.Id = p.MountainId 
  WHERE c.CountryCode = 'BG' AND p.Elevation > 2835
  ORDER BY p.Elevation DESC

----------13---------

SELECT c.CountryCode, COUNT(*) 
  FROM Countries AS c
  JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
  WHERE c.CountryCode IN ('US', 'RU', 'BG')
  GROUP BY c.CountryCode

----------14---------

SELECT TOP(5) c.CountryName, r.RiverName
FROM Countries AS c
LEFT JOIN CountriesRivers AS cr ON cr.CountryCode = c.CountryCode
LEFT JOIN Rivers AS r ON r.Id = cr.RiverId
WHERE ContinentCode = 'AF'
ORDER BY c.CountryName

----------15---------

SELECT  ContinentCode, CurrencyCode, Total FROM	(SELECT ContinentCode, CurrencyCode, COUNT(CurrencyCode) AS Total,
DENSE_RANK() OVER (PARTITION BY ContinentCode ORDER BY COUNT(CurrencyCode) DESC) AS Ranked
FROM Countries
GROUP BY ContinentCode, CurrencyCode) AS K
WHERE Ranked = 1 AND Total > 1
ORDER BY ContinentCode

----------16-------

SELECT COUNT(*)
FROM Countries AS c
LEFT JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
LEFT JOIN Mountains AS m ON mc.MountainId = m.Id
LEFT JOIN Peaks AS p ON p.MountainId = m.Id
WHERE m.Id IS NULL

----------17---------

--USE Geography
SELECT TOP(5) c.CountryName, MAX(p.Elevation) AS HighestPeakElevation, MAX(r.Length) AS LongestRiverLength
FROM Countries AS c
LEFT JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
LEFT JOIN Mountains AS m ON mc.MountainId = m.Id
LEFT JOIN Peaks AS p ON p.MountainId = m.Id
LEFT JOIN CountriesRivers AS cr ON cr.CountryCode = c.CountryCode
LEFT JOIN Rivers AS r ON r.Id = cr.RiverId
GROUP BY c.CountryName
ORDER BY HighestPeakElevation DESC, LongestRiverLength DESC, c.CountryName

----------18---------

SELECT TOP(5) k.CountryName, k.PeakName, k.HighestPeak, k.MountainRange
FROM ( SELECT CountryName,
	ISNULL(p.PeakName, '(no highest peak)') AS PeakName,
	ISNULL(m.MountainRange, '(no mountain)') AS MountainRange,
	ISNULL(MAX(p.Elevation), 0) AS HighestPeak,
	DENSE_RANK() OVER (PARTITION BY CountryName ORDER BY MAX(Elevation) DESC) AS Ranked
FROM Countries AS c
LEFT JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
LEFT JOIN Mountains AS m ON mc.MountainId = m.Id
LEFT JOIN Peaks AS p ON p.MountainId = m.Id
LEFT JOIN CountriesRivers AS cr ON cr.CountryCode = c.CountryCode
LEFT JOIN Rivers AS r ON r.Id = cr.RiverId
GROUP BY c.CountryName, p.PeakName, m.MountainRange) AS k
WHERE Ranked = 1
ORDER BY CountryName, PeakName
