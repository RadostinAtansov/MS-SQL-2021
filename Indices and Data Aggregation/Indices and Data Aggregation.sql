Indices and Data Aggregation

----------1----------

SELECT COUNT(*)
FROM WizzardDeposits

----------2----------

SELECT MAX(MagicWandSize) AS LongestMagicWand
FROM WizzardDeposits

----------3---------

SELECT DepositGroup, MAX(MagicWandSize) AS LongestMagicWand
FROM WizzardDeposits
GROUP BY DepositGroup

----------4----------

SELECT TOP(2) DepositGroup
FROM WizzardDeposits
GROUP BY DepositGroup
ORDER BY AVG(MagicWandSize)

----------5----------

SELECT DepositGroup, SUM(DepositAmount)
FROM WizzardDeposits
GROUP BY DepositGroup

----------6----------

SELECT DepositGroup, SUM(DepositAmount) AS ToTALSum
FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup

----------7----------

SELECT DepositGroup, TotalSum
  FROM (SELECT DepositGroup, SUM(DepositAmount) AS TotalSum
  FROM WizzardDeposits
 WHERE MagicWandCreator = 'Ollivander family' 
 GROUP BY DepositGroup) AS Total
WHERE TotalSum < 150000
ORDER BY TotalSum DESC

----------8----------

SELECT DepositGroup, MagicWandCreator, MIN(DepositCharge)
FROM WizzardDeposits
GROUP BY DepositGroup, MagicWandCreator
ORDER BY MagicWandCreator, DepositGroup

----------9----------

SELECT AgeGroup, COUNT(AgeGroup)
 FROM (SELECT Age,
	 CASE
		WHEN Age >= 0 AND Age <= 10 THEN '[0-10]'
		WHEN Age >= 11 AND Age <= 20 THEN '[11-20]'
		WHEN Age >= 21 AND Age <= 30 THEN '[21-30]'
		WHEN Age >= 31 AND Age <= 40 THEN '[31-40]'
		WHEN Age >= 41 AND Age <= 50 THEN '[41-50]'
		WHEN Age >= 51 AND Age <= 60 THEN '[51-60]'
		WHEN Age >= 61 THEN '[61+]'
	  END AS AgeGroup
        FROM WizzardDeposits) AS ABRAKADABRA
GROUP BY AgeGroup

----------10---------

SELECT DISTINCT LEFT(FirstName,1)
FROM WizzardDeposits
WHERE DepositGroup = 'Troll Chest'

----------11---------

SELECT DepositGroup, IsDepositExpired, AVG(DepositInterest)
FROM WizzardDeposits
WHERE DepositStartDate > '01/01/1985'
GROUP BY DepositGroup, IsDepositExpired
ORDER BY DepositGroup DESC, IsDepositExpired

----------12---------

SELECT  SUM(Guest.DepositAmount- Host.DepositAmount) AS [Difference]
FROM WizzardDeposits AS Host
JOIN WizzardDeposits AS Guest ON Guest.Id + 1 = Host.Id

----------13---------

SELECT DepartmentID, SUM(Salary)
FROM Employees
GROUP BY DepartmentID

----------14---------

SELECT DepartmentID, MIN(Salary)
FROM Employees
WHERE DepartmentID IN (2 ,5 ,7 ) AND HireDate > '01/01/2000'
GROUP BY DepartmentID

----------15---------

SELECT * INTO NewTable
FROM Employees
WHERE Salary > 30000

DELETE FROM NewTable
WHERE ManagerID = 42

UPDATE NewTable
SET Salary += 5000
WHERE DepartmentID = 1

SELECT DepartmentID, AVG(Salary)
FROM NewTable
GROUP BY DepartmentID

----------16-------

SELECT DepartmentID, MAX(Salary)
FROM Employees
GROUP BY DepartmentID
HAVING MAX(Salary) NOT BETWEEN 30000 AND 70000

----------17---------

SELECT COUNT(*)
FROM Employees
WHERE ManagerID IS NULL

----------18---------

SELECT DISTINCT k.DepartmentID, k.Salary
FROM (SELECT DepartmentID, Salary,
 DENSE_RANK() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS [Ranked]
FROM Employees) AS k
WHERE k.Ranked = 3

----------19---------

SELECT TOP(10) FirstName, LastName ,DepartmentID
  FROM Employees AS emp
 WHERE Salary > (SELECT AVG(Salary)
				FROM Employees
				WHERE DepartmentID = emp.DepartmentID
				GROUP BY DepartmentID)
ORDER BY DepartmentID