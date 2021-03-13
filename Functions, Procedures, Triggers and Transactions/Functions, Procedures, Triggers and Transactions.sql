Functions, Procedures, Triggers and Transactions

----------1----------

CREATE PROC usp_GetEmployeesSalaryAbove35000
AS 
SELECT FirstName, LastName
FROM Employees
WHERE Salary > 35000

----------2----------

CREATE PROC usp_GetEmployeesSalaryAboveNumber (@inputSalary DECIMAL(18, 4))
AS
SELECT FirstName, LastName
FROM Employees
WHERE Salary >= @inputSalary

----------3---------

CREATE PROC usp_GetTownsStartingWith (@subName NVARCHAR(50))
AS
SELECT Name
  FROM Towns
 WHERE [Name] LIKE @subName + '%'

----------4----------

CREATE PROC usp_GetEmployeesFromTown (@townName NVARCHAR(50))
AS
SELECT FirstName, LastName 
FROM Employees AS e
JOIN Addresses AS a ON a.AddressID = e.AddressID
JOIN Towns AS t ON t.TownID = a.TownID
WHERE t.Name = @townName

----------5----------

CREATE FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18,4))
RETURNS VARCHAR(50)
AS
BEGIN
DECLARE @result VARCHAR(50)

IF (@salary < 30000)
	SET @result = 'Low'
ELSE IF (@salary >= 30000 AND @salary <= 50000)
	SET @result = 'Average'
ELSE
	SET @result = 'High'
RETURN @result;
END

----------6----------

CREATE PROC usp_EmployeesBySalaryLevel (@levelOfSalary VARCHAR(20))
AS
SELECT FirstName, 
	   LastName
  FROM Employees
WHERE dbo.ufn_GetSalaryLevel(Salary) = @levelOfSalary

----------7----------

CREATE FUNCTION ufn_IsWordComprised(@setOfLetters VARCHAR(MAX), @word VARCHAR(MAX))
RETURNS BIT
BEGIN
DECLARE @count INT = 1;

WHILE (@count <= LEN(@word))
BEGIN
	DECLARE @currentLetter CHAR(1) = SUBSTRING(@word, @count, 1)
	
	IF (CHARINDEX(@currentLetter, @setOfLetters) = 0)
		RETURN 0
										 
	SET @count += 1;					 
END										 
RETURN 1								 
END

----------8----------

CREATE PROC usp_DeleteEmployeesFromDepartment (@departmentId INT)
AS
ALTER TABLE Departments
ALTER COLUMN ManagerID INT NULL

DELETE FROM EmployeesProjects
WHERE EmployeeID IN (SELECT EmployeeID FROM Employees WHERE DepartmentID = @departmentId)

UPDATE Employees
   SET ManagerID = NULL
 WHERE EmployeeID IN (SELECT EmployeeID FROM Employees WHERE DepartmentID = @departmentId)

UPDATE Departments
   SET ManagerID = NULL
 WHERE ManagerID IN (SELECT EmployeeID FROM Employees WHERE DepartmentID = @departmentId)

UPDATE Departments
   SET ManagerID = NULL
 WHERE DepartmentID = @departmentId

DELETE FROM Employees
 WHERE DepartmentID = @departmentId

 DELETE FROM Departments
 WHERE DepartmentID = @departmentId

 SELECT COUNT(*)
 FROM Employees
 WHERE DepartmentID = @departmentId

----------9----------

CREATE PROC usp_GetHoldersFullName
AS
SELECT FirstName + ' ' + LastName
FROM AccountHolders

----------10---------

CREATE PROC usp_GetHoldersWithBalanceHigherThan (@money DECIMAL (15,2))
AS
	SELECT FirstName, LastName
	FROM AccountHolders AS ah
	JOIN Accounts AS a ON a.AccountHolderId = ah.Id
	GROUP BY FirstName, LastName
	HAVING SUM(Balance) > @money
	ORDER BY FirstName, LastName

----------11---------

CREATE FUNCTION ufn_CalculateFutureValue(@sum DECIMAL(15, 2), @yearly FLOAT, @years INT)
RETURNS DECIMAL(15, 4)
BEGIN
	DECLARE @Result DECIMAL(15, 4)
	SET @Result = (@sum * POWER((1 + @yearly), @years))
	RETURN @Result
END

----------12---------

CREATE PROCEDURE usp_CalculateFutureValueForAccount (@accountId INT, @interestRate FLOAT)
AS
SELECT a.Id, 
		ah.FirstName, 
		ah.LastName, 
		a.Balance, 
		dbo.ufn_CalculateFutureValue(a.Balance, @interestRate, 5)
 FROM AccountHolders AS ah
 JOIN Accounts AS a ON a.AccountHolderId = ah.Id
WHERE a.Id = @accountId

----------13---------

CREATE FUNCTION ufn_CashInUsersGames (@gameName VARCHAR(100))
RETURNS TABLE
AS
 RETURN (SELECT SUM(k.TotalCash) AS TotalCash
	FROM (SELECT Cash AS TotalCash,
		ROW_NUMBER() OVER (ORDER BY Cash DESC) AS RowNumber
	FROM Games AS g
	JOIN UsersGames AS ug ON g.Id = ug.GameId
WHERE Name = @gameName) AS k
	WHERE k.RowNumber % 2 = 1)

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