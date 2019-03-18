USE SoftUni
--01. Find Names of All Employees by First Name
SELECT FirstName, LastName FROM Employees
WHERE LEFT(FirstName, 2)='SA' 

--02. Find Names of All Employees by Last Name
SELECT FirstName, LastName FROM Employees
WHERE CHARINDEX('ei', LastName) != 0

--03. Find First Names of All Employess
SELECT FirstName FROM Employees
WHERE (DepartmentID = 3 OR DepartmentId = 10) AND DATEPART(YEAR, HireDate)>1994 AND DATEPART(YEAR, HireDate)<2006

--04. Find All Employees Except Engineers
SELECT FirstName, LastName FROM Employees
WHERE CHARINDEX('engineer', JobTitle) = 0

--05. Find Towns with Name Length
SELECT [Name] FROM Towns
WHERE LEN([Name]) = 5 OR LEN([Name]) = 6
ORDER BY [Name]

--06. Find Towns Starting With
SELECT TownID, [Name] FROM Towns
WHERE LEFT([Name], 1) IN ('M', 'K', 'B', 'E')
ORDER BY [Name]

--07. Find Towns Not Starting With
SELECT TownID, [Name] FROM Towns
WHERE Left([Name], 1) NOT IN ('R', 'B', 'D') --WHERE [Name] LIKE '[^RDB]%'
ORDER BY [Name]

--08. Create View Employees Hired After
CREATE VIEW V_EmployeesHiredAfter2000 AS
SELECT FirstName, LastName FROM Employees
WHERE DATEPART(YEAR, HireDate) > 2000 
--GO
--SELECT * FROM V_EmployeesHiredAfter2000

--09. Length of Last Name
SELECT FirstName, LastName FROM Employees
WHERE LEN(LastName) = 5

--USE Geography
--10. Countries Holding 'A'
SELECT CountryName AS [Country Name], IsoCode AS [ISO Code] FROM Countries
WHERE CountryName LIKE '%A%A%A%'
ORDER BY IsoCode

--11. Mix of Peak and River Names
SELECT Peaks.PeakName, Rivers.RiverName, LOWER(CONCAT(Peaks.PeakName, RIGHT(Rivers.RiverName, LEN(Rivers.RiverName)-1))) AS Mix FROM Peaks, Rivers
WHERE RIGHT(Peaks.PeakName, 1) = LEFT(Rivers.RiverName, 1)
ORDER BY Mix

--USE Diablo
--12. Games From 2011 and 2012 Year
SELECT TOP(50) [Name], FORMAT(Start, 'yyyy-MM-dd') AS [Start] FROM Games
WHERE YEAR([Start]) IN (2011, 2012)
ORDER BY [Start], [Name]

--13. User Email Providers
SELECT Username, RIGHT(Email, LEN(Email) - CHARINDEX('@', Email)) AS [Email Provider] FROM Users
ORDER BY [Email Provider], Username;

--14. Get Users with IPAddress Like Pattern
SELECT Username, IpAddress AS [IP Address] FROM Users
WHERE IpAddress LIKE '___.1%.%.___'
ORDER BY Username

--15. Show All Games with Duration
SELECT [Name] AS Game,
CASE
WHEN DATEPART(HOUR, [Start]) BETWEEN 0 AND 11 THEN 'Morning'
WHEN DATEPART(HOUR, [Start]) BETWEEN 12 AND 17 THEN 'Afternoon'
ELSE 'Evening'
END AS [Part of the Day],
 CASE
 WHEN Duration <= 3 THEN 'Extra Short'
 WHEN Duration <= 6 THEN 'Short'
 WHEN Duration > 6 THEN 'Long'
 ELSE 'Extra Long'
 END AS Duration
 FROM Games
ORDER BY [Name], Duration, [Part of the Day]

--USE Orders
--16. Orders Table
SELECT Productname, Orderdate,
 DATEADD(DAY, 3, Orderdate)  AS [Pay Due],
 DATEADD(MONTH, 1, Orderdate)  AS [Deliver Due]
 FROM Orders

--17. People Table
 SELECT [Name], 
 DATEDIFF(YEAR, Birthdate, GETDATE()) AS [Age in Years],
 DATEDIFF(MONTH, Birthdate, GETDATE()) AS [Age in Months],
 DATEDIFF(DAY, Birthdate, GETDATE()) AS [Age in Days],
 DATEDIFF(MINUTE, Birthdate, GETDATE()) AS [Age in Minutes],
 FROM People