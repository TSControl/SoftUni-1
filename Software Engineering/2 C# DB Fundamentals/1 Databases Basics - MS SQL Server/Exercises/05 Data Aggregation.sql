USE Gringotts

--01. Records’ Count
SELECT COUNT(*) FROM WizzardDeposits

--02. Longest Magic Wand
SELECT MAX(MagicWandSize) AS LongestMagicWand FROM WizzardDeposits

--03. Longest Magic Wand per Deposit Groups
SELECT DepositGroup, MAX(MagicWandSize) AS LongestMagicWand
FROM WizzardDeposits
GROUP BY DepositGroup

--04. Smallest Deposit Group per Magic Wand Size
SELECT TOP(2) DepositGroup FROM WizzardDeposits
GROUP BY DepositGroup
ORDER BY AVG(MagicWandSize)

--05. Deposits Sum
SELECT DepositGroup, SUM(DepositAmount) AS TotalSum
FROM WizzardDeposits
GROUP BY DepositGroup

--06. Deposits Sum for Ollivander Family
SELECT DepositGroup, SUM(DepositAmount) AS TotalSum
FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup

--07. Deposits Filter
SELECT DepositGroup, SUM(DepositAmount) AS TotalSum
FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup
HAVING SUM(DepositAmount) < 150000
ORDER BY TotalSum DESC

--08. Deposit Charge
SELECT DepositGroup, MagicWandCreator, MIN(DepositCharge) AS MinDepositCharge
FROM WizzardDeposits
GROUP BY DepositGroup, MagicWandCreator
ORDER BY MagicWandCreator, DepositGroup

--09. Age Groups
SELECT 
CASE
WHEN Age <= 10 THEN '[0-10]'
WHEN Age <= 20 THEN '[11-20]'
WHEN Age <= 30 THEN '[21-30]'
WHEN Age <= 40 THEN '[31-40]'
WHEN Age <= 50 THEN '[41-50]'
WHEN Age <= 60 THEN '[51-60]'
ELSE '[61+]'
END AS AgeGroup,
COUNT(*) AS WizzardCount
FROM WizzardDeposits
GROUP BY 
CASE
WHEN Age <= 10 THEN '[0-10]'
WHEN Age <= 20 THEN '[11-20]'
WHEN Age <= 30 THEN '[21-30]'
WHEN Age <= 40 THEN '[31-40]'
WHEN Age <= 50 THEN '[41-50]'
WHEN Age <= 60 THEN '[51-60]'
ELSE '[61+]'
END

--10. First Letter
SELECT LEFT(FirstName, 1) AS FirstLetter
FROM WizzardDeposits
WHERE DepositGroup = 'Troll Chest'
GROUP BY LEFT(FirstName, 1)
ORDER BY FirstLetter

--11. Average Interest
SELECT DepositGroup, IsDepositExpired, AVG(DepositInterest) AS AverageInterest
FROM WizzardDeposits
WHERE DepositStartDate > '01/01/1985'
GROUP BY DepositGroup, IsDepositExpired
ORDER BY DepositGroup DESC, IsDepositExpired

--12. Rich Wizard, Poor Wizard
SELECT SUM([Difference]) FROM (
SELECT FirstName AS [Host Wizard], 
	   DepositAmount AS [Host Wizard Deposit],
	   LEAD(FirstName) OVER(ORDER BY Id ASC) AS [Guest Wizard],
	   LEAD(DepositAmount) OVER(ORDER BY Id ASC) AS [Guest Wizard Deposit],
	   (DepositAmount - LEAD(DepositAmount) OVER(ORDER BY Id ASC)) AS [Difference]
FROM WizzardDeposits
) AS SumDifference
--
USE SoftUni
--13. Departments Total Salaries
SELECT DepartmentId, SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY DepartmentId
ORDER BY DepartmentId

--14. Employees Minimum Salaries
SELECT DepartmentId, MIN(Salary) AS MinimumSalary
FROM Employees
WHERE DepartmentId IN (2, 5, 7) AND HireDate > '01/01/2000'
GROUP BY DepartmentId

--15. Employees Average Salaries
SELECT * INTO Employees3 FROM Employees
WHERE Salary > 30000

DELETE FROM Employees3
WHERE ManagerID = 42

UPDATE Employees3
SET Salary += 5000
WHERE DepartmentID = 1

SELECT DepartmentID, AVG(Salary) AS AverageSalary
FROM Employees3
GROUP BY DepartmentID

--16. Employees Maximum Salaries
SELECT DepartmentId, MAX(Salary) AS MaxSalary
FROM Employees
GROUP BY DepartmentId
HAVING MAX(Salary) NOT BETWEEN 30000 AND 70000

--17. Employees Count Salaries
SELECT COUNT(*) AS [Count]
FROM Employees
WHERE ManagerId IS NULL

--18. 3rd Highest Salary
SELECT DepartmentID, Salary FROM (
SELECT DepartmentID, Salary AS Salary,
DENSE_RANK() OVER(PARTITION BY DepartmentID ORDER BY Salary DESC) AS [Rank]
FROM Employees
GROUP BY DepartmentID, Salary
) AS RankedSalaries
WHERE [Rank] = 3

--19. Salary Challenge
SELECT TOP(10) FirstName, LastName, DepartmentID
FROM Employees AS e
WHERE Salary > (
SELECT AverageSalary FROM (SELECT DepartmentID, AVG(Salary) AS AverageSalary FROM Employees
GROUP BY DepartmentID) AS ass
WHERE e.DepartmentID = ass.DepartmentID
)
ORDER BY DepartmentID