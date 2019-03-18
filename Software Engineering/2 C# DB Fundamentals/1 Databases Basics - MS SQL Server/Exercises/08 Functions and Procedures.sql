USE Softuni
GO

--01. Employees with Salary Above 35000
CREATE PROC usp_GetEmployeesSalaryAbove35000
AS
BEGIN
SELECT e.FirstName, e.LastName FROM Employees AS e WHERE e.Salary > 35000
END
--end
GO
EXEC usp_GetEmployeesSalaryAbove35000
GO

--02. Employees with Salary Above Number
CREATE PROC usp_GetEmployeesSalaryAboveNumber @SalaryThreshold DECIMAL(18,4)
AS
BEGIN
SELECT e.FirstName, e.LastName FROM Employees AS e WHERE e.Salary >= @SalaryThreshold
END
--end
GO
EXEC usp_GetEmployeesSalaryAboveNumber 48100
GO

--03. Town Names Starting With
CREATE PROC usp_GetTownsStartingWith @Input VARCHAR(50)
AS
BEGIN
SELECT t.[Name] AS Town FROM Towns AS t
WHERE SUBSTRING(t.[Name],1,DATALENGTH(@Input)) = @Input 
END
--end
GO
EXEC usp_GetTownsStartingWith b
GO

--04. Employees from Town
 CREATE PROC usp_GetEmployeesFromTown @Input VARCHAR(50)
 AS
 BEGIN
 SELECT e.FirstName, e.LastName FROM Employees AS e
 INNER JOIN Addresses AS a
 ON e.AddressID = a.AddressID
 INNER JOIN Towns AS t
 ON a.TownID = t.TownID
 WHERE t.[Name] = @Input
 END
 --end
 GO
 EXEC usp_GetEmployeesFromTown Sofia
 GO

--05. Salary Level Function
CREATE OR ALTER FUNCTION ufn_GetSalaryLevel (@salary INT) --remove OR ALTER for judge
RETURNS NVARCHAR(10)
AS
 BEGIN
DECLARE @output NVARCHAR(10)
IF (@salary < 30000)
SET @output = 'Low'
ELSE IF (@salary BETWEEN 30000 AND 50000)
SET @output = 'Average'
ELSE
SET @output = 'High'
RETURN @output
END
--end
GO
SELECT dbo.ufn_GetSalaryLevel(45000)
GO

--06. Employees by Salary Level
CREATE PROC usp_EmployeesBySalaryLevel @SalaryLevel VARCHAR(10)
AS
BEGIN
SELECT e.FirstName AS [First Name], e.LastName AS [Last Name] FROM Employees AS e
WHERE dbo.ufn_GetSalaryLevel(e.Salary) = @SalaryLevel
END
--end
GO
EXEC usp_EmployeesBySalaryLevel High
GO

--07. Define Function
CREATE OR ALTER FUNCTION ufn_IsWordComprised(@SetOfLetters VARCHAR(50), @Word VARCHAR(50)) --remove OR ALTER for judge
RETURNS INT
AS
BEGIN
	DECLARE @Output INT = 1
	DECLARE @I INT = 1
	WHILE (@I <= DATALENGTH(@Word))
	BEGIN
		DECLARE @Char VARCHAR(1) = SUBSTRING(@Word, @I, 1)
		IF (@Char NOT LIKE '[' + @SetOfLetters + ']')  --може и с CHARINDEX (==0)
		BEGIN
			SET @Output = 0
			SET @I = DATALENGTH(@Word) + 1
		END
		SET @I += 1
	END
	RETURN @Output
END
--end
GO
SELECT dbo.ufn_IsWordComprised('bobr', 'Rob')
GO

--08. Delete Employees and Departments
CREATE PROC usp_DeleteEmployeesFromDepartment (@departmentId INT)
AS
BEGIN
	DELETE FROM EmployeesProjects
	WHERE EmployeeID IN (
	SELECT EmployeeID FROM Employees
	WHERE DepartmentID = @departmentId);

	ALTER TABLE Departments
	ALTER COLUMN ManagerId INT NULL;

	UPDATE Departments
	SET ManagerID = NULL
	WHERE ManagerID IN (
	SELECT EmployeeID FROM Employees
	WHERE DepartmentID = @departmentId);

	UPDATE Employees
	SET ManagerID = NULL
	WHERE ManagerID IN (
	SELECT EmployeeID FROM Employees
	WHERE DepartmentID = @departmentId);

	DELETE FROM Employees
	WHERE DepartmentID = @departmentId;

	DELETE FROM Departments
	WHERE DepartmentID = @departmentId;

	SELECT COUNT(*) FROM Employees AS e
	WHERE e.DepartmentID = @departmentId;
END;
--end
GO
EXEC usp_DeleteEmployeesFromDepartment 1;
GO

USE Bank
GO

--09. Find Full Name
CREATE OR ALTER PROC usp_GetHoldersFullName --delete OR ALTER for judge
AS
BEGIN
SELECT CONCAT(ah.FirstName, ' ', ah.LastName) AS [Full Name] FROM AccountHolders AS ah
END
--end
GO

--10. People with Balance Higher Than
CREATE OR ALTER PROC usp_GetHoldersWithBalanceHigherThan (@number DECIMAL(18,2)) --remove OR ALTER for judge
AS
BEGIN
	SELECT FirstName, LastName
	FROM AccountHolders AS ah
	JOIN Accounts AS a
	ON ah.Id = a.AccountHolderId
	GROUP BY FirstName, LastName
	HAVING SUM(a.Balance) > @number
END
--end
GO
EXEC usp_GetHoldersWithBalanceHigherThan 15000
GO

--11. Future Value Function
CREATE OR ALTER FUNCTION ufn_CalculateFutureValue (@sum DECIMAL(18,4), @interestRate FLOAT, @yearsCount INT)
RETURNS DECIMAL(18,4)
AS
BEGIN
	RETURN (@sum * POWER((1+@interestRate), @yearsCount));
END
--end
GO
SELECT dbo.ufn_CalculateFutureValue(1000, 0.1, 5)
GO

--12. Calculating Interest
CREATE OR ALTER PROC usp_CalculateFutureValueForAccount (@accId INT, @interest FLOAT) --delete OR ALTER for judge
AS
BEGIN
	SELECT @accId AS [Account Id], ah.FirstName AS [FirstName], ah.LastName AS [Last Name], a.Balance AS [Current Balance], dbo.ufn_CalculateFutureValue(a.Balance, @interest, 5) AS [Balance in 5 years]
	FROM Accounts AS a
	JOIN AccountHolders AS ah
	ON ah.Id = a.AccountHolderId
	WHERE a.Id = @accId
END
--end
EXEC usp_CalculateFutureValueForAccount 1, 0.1
GO
USE Diablo
GO
--13. *Cash in User Games Odd Rows
CREATE OR ALTER FUNCTION ufn_CashInUsersGames (@gameName NVARCHAR(MAX))
RETURNS TABLE
AS
RETURN SELECT SUM(Cash) AS SumCash
FROM (
SELECT ug.Cash, ROW_NUMBER() OVER(ORDER BY Cash DESC) AS RowNum
FROM UsersGames AS ug
JOIN Games AS g ON g.Id = ug.GameId
WHERE g.[Name] = @gameName
) AS CashList
WHERE RowNum % 2 = 1;
--end
GO
--ЛЕКЦИЯ
USE Gringotts
GO

CREATE OR ALTER FUNCTION udf_GetAgeGroup(@Age INT)
RETURNS VARCHAR(10)
AS
BEGIN
	DECLARE @LowerBound INT = ((@Age - 1) / 10) * 10 + 1
	DECLARE @UpperBound INT = @LowerBound + 9
	DECLARE @Result VARCHAR(10) = '[' + CAST(@LowerBound AS VARCHAR(3)) + '-' + CAST(@UpperBound AS VARCHAR(3)) + ']'
	RETURN @Result
END
GO
SELECT Age, dbo.udf_GetAgeGroup(Age) AS AgeRange, COUNT(*) FROM WizzardDeposits
GROUP BY dbo.udf_GetAgeGroup(Age)
GO

--Problem Employee with 3 projects
USE SoftUni
GO

CREATE PROC usp_AddEmployeeToProject @EmployeeId INT, @ProjectId INT
AS
BEGIN
	DECLARE @EmployeeProjectCount INT = (SELECT COUNT(*) FROM EmployeesProjects
WHERE EmployeeID = 1)
	IF(@EmployeeProjectCount < 3) 
	BEGIN
		RAISERROR('Employee has too many projects!', 16, 1) --or THROW
	END

	INSERT INTO EmployeesProjects (EmployeeID, ProjectID) VALUES
	(@EmployeeId, @ProjectId)
END

--EXEC ups_AddEmployeeToProject 1, 2
GO
--THROW 50000, 'Error message to show', 2 - best use this, ERROR executes anyways