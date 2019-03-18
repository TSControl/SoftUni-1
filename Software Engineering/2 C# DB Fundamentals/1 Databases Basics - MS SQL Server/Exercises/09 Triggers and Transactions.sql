USE Bank
GO
--01. Create Table Logs
CREATE TABLE Logs (
LogId INT PRIMARY KEY IDENTITY,
AccountId INT,
OldSum DECIMAL(18,2),
NewSum DECIMAL(18,2)
)
GO

CREATE OR ALTER TRIGGER tr_LogBalanceChange ON Accounts FOR UPDATE --delete OR ALTER for judge
AS
BEGIN
	INSERT INTO Logs(AccountId, OldSum, NewSum)
	SELECT i.Id, d.Balance, i.Balance
	FROM deleted AS d
	INNER JOIN inserted AS i ON d.Id = i.Id
END
GO --delete GO for judge

--02. Create Table Emails
CREATE TABLE NotificationEmails (
Id INT PRIMARY KEY IDENTITY,
Recipient INT,
[Subject] VARCHAR(50),
Body VARCHAR(50)
)
GO

CREATE OR ALTER TRIGGER tr_EmailNotification ON Logs FOR INSERT --remove OR ALTER for judge
AS
BEGIN
	INSERT INTO NotificationEmails(Recipient, [Subject], Body)
	SELECT i.AccountId, CONCAT('Balance change for account: ', i.AccountId), CONCAT('On ', GETDATE(), ' your balance was changed from ', i.OldSum, ' to ', i.NewSum + '.')
	FROM inserted AS i
END
GO --remove GO for judge

--03. Deposit Money
CREATE OR ALTER PROC usp_DepositMoney (@AccountId INT, @MoneyAmount DECIMAL(15,4)) AS --remove OR ALTER for judge
IF (@MoneyAmount >= 0)
BEGIN
	UPDATE Accounts
	SET Balance += @MoneyAmount
	WHERE Id = @AccountId
END
--
GO

--04. Withdraw Money Procedure
CREATE OR ALTER PROC usp_WithdrawMoney (@AccountId INT, @MoneyAmount DECIMAL(15,4)) --remove OR ALTER for judge
AS
IF (@MoneyAmount >= 0)
BEGIN
	UPDATE Accounts
	SET Balance -= @MoneyAmount
	WHERE Id = @AccountId
END
--
GO

--05. Money Transfer
CREATE OR ALTER PROC usp_TransferMoney(@SenderId INT, @ReceiverId INT, @Amount DECIMAL(15,4)) --remove OR ALTER for judge
AS
BEGIN TRAN
	EXEC usp_WithdrawMoney @SenderId, @Amount
	DECLARE @SenderBalance DECIMAL(15,4) = (SELECT Balance
											FROM Accounts
											WHERE Id = @SenderId)
	IF (@SenderBalance < 0)
		ROLLBACK
	EXEC usp_DepositMoney @ReceiverId, @Amount
COMMIT

-- 05. ends here
GO
USE Diablo
GO

--Problem 6.	Trigger
CREATE OR ALTER TRIGGER tr_RestrictHigherLevelItems ON UserGameItems AFTER INSERT
AS
BEGIN
	DECLARE @ItemMinLvl INT = ( SELECT i.MinLevel FROM inserted AS ins
												  JOIN Items AS i ON i.Id = ins.ItemId );
	DECLARE @UserLvl INT = ( SELECT ug.Level FROM inserted AS ins
										JOIN UsersGames AS ug ON ug.UserId = u.Id );
	IF (@UserLvl < @ItemLvl)
		BEGIN
			RAISERROR('Your level is too low to aquire that item!', 16, 1)
			ROLLBACK
			RETURN
		END
END
--solution ends here (no GO in judge)
GO
--part 2. of Problem 6
UPDATE UsersGames
SET Cash += 50000
WHERE UserId IN (SELECT Id FROM Users WHERE Username IN ('baleremuda', 'loosenoise', 'inguinalself', 'buildingdeltoid', 'monoxidecos' ) AND GameId = (SELECT Id FROM Games WHERE [Name] = 'Bali'))
--part 3. of Problem 6
--DECLARE @UserGameIds = (SELECT Id FROM UsersGames WHERE UserId IN (SELECT Id FROM Users WHERE Username IN ('baleremuda', 'loosenoise', 'inguinalself', 'buildingdeltoid', 'monoxidecos' ) AND GameId = (SELECT Id FROM Games WHERE [Name] = 'Bali')))
--DECLARE @ItemIds VARCHAR(50)= ('251,252,253') --etc.
--INSERT INTO UserGameItems
--VALUES (@ItemId, @UserGameId)
--FUCK THIS!!!
--part 4. of Problem 6
SELECT u.Username, g.[Name], ug.Cash, i.[Name] AS [Item Name]
FROM Users AS u
JOIN UsersGames AS ug ON u.Id = ug.UserId
JOIN Games AS g ON g.Id = ug.GameId
JOIN UserGameItems AS ugi ON ugi.UserGameId = ug.Id
JOIN Items AS i ON ugi.ItemId = i.Id
WHERE g.[Name] = 'Bali'
ORDER BY u.Username, i.[Name]
--
GO

--07. *Massive Shopping
DECLARE @UserGameId INT = (SELECT Id FROM UsersGames WHERE UserId = (SELECT Id FROM Users WHERE Username = 'Stamat') AND GameId = (SELECT Id FROM Games WHERE [Name] = 'Safflower'))
BEGIN TRY
BEGIN TRAN
	UPDATE UsersGames
	SET Cash -= (SELECT SUM(Price) 
				FROM Items
				WHERE MinLevel IN (11, 12))
	WHERE Id = @userGameId

	IF ((SELECT Cash FROM UsersGames WHERE Id = @UserGameId) < 0)
	BEGIN
		ROLLBACK
		RETURN
	END

	INSERT INTO UserGameItems
	SELECT Id, @UserGameId FROM Items WHERE MinLevel IN (11, 12)
COMMIT
END TRY
BEGIN CATCH
	ROLLBACK
END CATCH

BEGIN TRY
BEGIN TRAN
	UPDATE UsersGames
	SET Cash -= (SELECT SUM(Price) 
				FROM Items
				WHERE MinLevel IN (19, 20, 21))
	WHERE Id = @userGameId

	IF ((SELECT Cash FROM UsersGames WHERE Id = @UserGameId) < 0)
	BEGIN
		ROLLBACK
		RETURN
	END

	INSERT INTO UserGameItems
	SELECT Id, @UserGameId FROM Items WHERE MinLevel IN (19, 20, 21)
COMMIT
END TRY
BEGIN CATCH
	ROLLBACK
END CATCH

SELECT i.[Name] AS [Item Name]
FROM Items AS i
JOIN UserGameItems AS ugi ON ugi.ItemId = i.Id
WHERE UserGameId = @UserGameId
ORDER BY i.[Name]
--ends here
GO
USE SoftUni
GO

--08. Employees with Three Projects
CREATE OR ALTER PROC usp_AssignProject(@emloyeeId INT, @projectID INT) --remove OR ALTER for judge
AS
BEGIN
BEGIN TRAN
INSERT INTO EmployeesProjects VALUES (@emloyeeId, @projectID)
IF ((SELECT COUNT(*) FROM EmployeesProjects WHERE EmployeeID = @emloyeeId) > 3)
BEGIN
	RAISERROR('The employee has too many projects!', 16, 1)
	ROLLBACK
	RETURN
END
COMMIT
END
--ends here
GO
--

--09. Delete Employees - мое решение - to finish
CREATE TABLE Deleted_Employees (
EmployeeId INT PRIMARY KEY IDENTITY,
FirstName VARCHAR(20) NOT NULL,
LastName VARCHAR(20) NOT NULL,
MiddleName VARCHAR(20),
JobTitle VARCHAR(20) NOT NULL,
DepartmentId INT FOREIGN KEY REFERENCES Departments (DepartmentId),
Salary DECIMAL (15, 4)
)
--
GO
-- below for judge
CREATE OR ALTER TRIGGER tr_Deleted_Employees ON Employees FOR DELETE
AS
BEGIN
	INSERT INTO Deleted_Employees (FirstName, LastName, MiddleName, JobTitle, DepartmentId, Salary)
	SELECT deleted.FirstName, deleted.LastName, deleted.MiddleName, deleted.JobTitle, deleted.DepartmentId, deleted.Salary
	FROM deleted
END