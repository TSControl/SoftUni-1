USE Softuni

--01. Employee Address
SELECT TOP(5) e.EmployeeID, e.JobTitle, e.AddressId, a.AddressText FROM Employees AS e
INNER JOIN Addresses AS a
ON e.AddressID = a.AddressID
ORDER BY e.AddressID ASC

--02. Addresses with Towns
SELECT TOP(50) e.FirstName, e.LastName, t.[Name] AS Town, a.AddressText
FROM Employees AS e
JOIN Addresses AS a ON e.AddressID = a.AddressID
JOIN Towns AS t ON a.TownID = t.TownID
ORDER BY e.FirstName ASC, e.LastName

--03. Sales Employees
SELECT e.EmployeeID,
e.FirstName,
e.LastName,
d.[Name] AS DepartmentName
FROM Employees AS e
JOIN Departments AS d
ON e.DepartmentID = d.DepartmentID
WHERE d.[Name] = 'Sales'
ORDER BY e.EmployeeID ASC

--04. Employee Departments
SELECT TOP(5) e.EmployeeID, e.FirstName, e.Salary, d.[Name]
FROM Employees AS e
JOIN Departments AS d
ON e.DepartmentID = d.DepartmentID
WHERE e.Salary > 15000
ORDER BY e.DepartmentID ASC

--05. Employees Without Projects
SELECT TOP(3) e.EmployeeID, e.FirstName FROM Employees AS e
WHERE e.EmployeeID NOT IN (SELECT e1.EmployeeID FROM Employees AS e1
JOIN EmployeesProjects AS ep
ON e1.EmployeeID = ep.EmployeeID) --(SELECT DISTINCT EmployeeID FROM EmployeesProjects)
ORDER BY e.EmployeeID ASC

--05. Employees Without Projects - from the white table - option 2 - with join
SELECT TOP 3 e.EmployeeID, e.FirstName
FROM Employees AS e
LEFT OUTER JOIN EmployeesProjects AS ep
ON e.EmployeeID = ep.EmployeeID
WHERE ep.ProjectID IS NULL

--06. Employees Hired After
SELECT e.FirstName, e.LastName, e.HireDate, d.[Name] AS DeptName FROM Employees AS e
JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
WHERE e.HireDate > '1.1.1999' AND d.[Name] IN ('Sales', 'Finance')
ORDER BY e.HireDate ASC

--07. Employees With Project
SELECT TOP(5) e.EmployeeID, e.FirstName, p.[Name] AS ProjectName FROM Employees AS e
JOIN EmployeesProjects AS ep ON e.EmployeeID = ep.EmployeeID
JOIN Projects AS p ON ep.ProjectID = p.ProjectID
WHERE p.StartDate > '2002-08-13' AND p.EndDate IS NULL
ORDER BY e.EmployeeID ASC

--08. Employee 24
SELECT e.EmployeeID, e.FirstName,
CASE
WHEN DATEPART(YEAR, p.StartDate) >= '2005' THEN NULL --CASE WHEN p.StartDate >='2005' THEN NULL
ELSE p.[Name]
END AS ProjectName FROM Employees AS e
JOIN EmployeesProjects AS ep ON e.EmployeeID = ep.EmployeeID
JOIN Projects AS p ON ep.ProjectID = p.ProjectID
WHERE e.EmployeeID = 24

--09. Employee Manager
SELECT e.EmployeeID, e.FirstName, e.ManagerID, e2.FirstName AS ManagerName FROM Employees AS e
JOIN Employees AS e2 ON e.ManagerID = e2.EmployeeID
WHERE e.ManagerID IN (3,7)
ORDER BY e.EmployeeID ASC

--10. Employees Summary
SELECT TOP(50) e.EmployeeID, CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName, CONCAT(m.FirstName, ' ', m.LastName) AS ManagerName, d.[Name] AS DepartmentName
FROM Employees AS e
JOIN Employees AS m ON e.ManagerID = m.EmployeeID
JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
ORDER BY e.EmployeeID

--11. Min Average Salary
SELECT TOP 1 AVG(e.Salary) AS MinAverageSalary FROM Employees AS e
GROUP BY e.DepartmentID
ORDER BY AVG(Salary)

--11. Min Average Salary - from the white table - втори начин
SELECT MIN(AvgSalary) AS MinAverageSalary FROM (SELECT AVG(e.Salary) AS AvgSalary
FROM Employees AS e
GROUP BY e.DepartmentID ) AS TempTable

USE Geography

--12. Highest Peaks in Bulgaria
SELECT c.CountryCode, m.MountainRange, p.PeakName, p.Elevation
FROM Countries AS c
JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
JOIN Mountains AS m ON mc.MountainId = m.Id
JOIN Peaks AS p ON m.Id = p.MountainId
WHERE p.Elevation > 2835 AND c.CountryCode = 'BG'
ORDER BY p.Elevation DESC

--13. Count Mountain Ranges
SELECT c.CountryCode, COUNT(m.MountainRange)
FROM Countries AS c
JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
JOIN Mountains AS m ON mc.MountainId = m.Id
WHERE c.CountryCode IN ('BG', 'RU', 'US')
GROUP BY c.CountryCode

--14. Countries With or Without Rivers
SELECT TOP 5 c.CountryName, r.RiverName
FROM Countries AS c
LEFT JOIN CountriesRivers AS cr
ON c.CountryCode = cr.CountryCode
LEFT JOIN Rivers AS r
ON cr.RiverID = r.Id
WHERE c.ContinentCode = (SELECT ContinentCode FROM Continents WHERE ContinentName = 'Africa')
ORDER BY c.CountryName

--15. *Continents and Currencies
SELECT ContinentCode, CurrencyCode, CurrencyUsage FROM
( SELECT ContinentCode, CurrencyCode, CurrencyUsage, DENSE_RANK() OVER(PARTITION BY (ContinentCode)
ORDER BY CurrencyUsage DESC) AS [Rank]
FROM (SELECT ContinentCode, CurrencyCode, COUNT(CurrencyCode) AS CurrencyUsage
FROM Countries
GROUP BY CurrencyCode, ContinentCode) AS Currencies ) AS RankedCurrencies
WHERE [Rank] = 1 AND CurrencyUsage > 1
ORDER BY ContinentCode

--16. Countries Without any Mountains
SELECT COUNT(CountryCode) AS CountryCode
FROM Countries
WHERE CountryCode NOT IN (SELECT CountryCode FROM MountainsCountries)

--17. Highest Peak and Longest River by Country
SELECT TOP 5 c.CountryName, MAX(p.Elevation) AS HighestPeakElevation, MAX(r.[Length]) AS LongestRiverLength
FROM Countries AS c
JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
JOIN Mountains AS m ON mc.MountainId = m.Id
JOIN Peaks AS p ON m.Id = p.MountainId
JOIN CountriesRivers AS cr ON c.CountryCode = cr.CountryCode
JOIN Rivers AS r ON r.Id = cr.RiverId
GROUP BY c.CountryName
ORDER BY HighestPeakElevation DESC, LongestRiverLength DESC, c.CountryName ASC

--18. *Highest Peak Name and Elevation by Country
SELECT TOP 5 CountryName, 
CASE 
WHEN PeakName IS NULL THEN '(no highest peak)'
ELSE PeakName
END AS [Highest Peak Name], 
CASE 
WHEN Elevation IS NULL THEN 0
ELSE ELevation
END AS [Highest Peak Elevation],
CASE 
WHEN MountainRange IS NULL THEN '(no mountain)'
ELSE MountainRange
END AS [Mountain]
FROM (
SELECT CountryName, PeakName, Elevation, MountainRange,
DENSE_RANK() OVER(PARTITION BY CountryName ORDER BY Elevation DESC) AS [Rank]
FROM (SELECT c.CountryName, p.PeakName, p.Elevation, m.MountainRange
FROM Countries AS c
LEFT JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
LEFT JOIN Mountains AS m ON mc.MountainID = m.Id
LEFT JOIN Peaks AS p ON m.Id = p.MountainId) AS allPeaks 
) AS rankedPeaks 
WHERE [Rank] = 1
ORDER BY CountryName, PeakName